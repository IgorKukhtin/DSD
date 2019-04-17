-- Function: gpInsert_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderInternalPromoChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderInternalPromoChild(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;


     SELECT (MovementDate_StartSale.ValueData - INTERVAL '1 DAY')
          , (Movement.OperDate + INTERVAL '1 DAY')
          , MovementLinkObject_Retail.ObjectId AS RetailId
    INTO vbStartDate, vbEndDate, vbRetailId
     FROM Movement 
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
     WHERE Movement.Id = inMovementId;


    -- Cуществующие чайлд
     CREATE TEMP TABLE tmpMI_Child (Id Integer, ParentId Integer, UnitId Integer) ON COMMIT DROP;
       INSERT INTO tmpMI_Child (Id, ParentId, UnitId)
       SELECT MovementItem.Id
            , MovementItem.ParentId
            , MovementItem.ObjectId AS UnitId
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Child();

     -- снимаем удаление со строк чайлд
     UPDATE MovementItem
     SET isErased = FALSE
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child();


    CREATE TEMP TABLE tmpData (Id Integer, ParentId Integer, UnitId Integer, AmountOut TFloat, Remains TFloat, AmountIn TFloat) ON COMMIT DROP;
          INSERT INTO tmpData (Id, ParentId, UnitId, AmountOut, Remains, AmountIn)
          WITH -- строки мастера с кол-вом для распределения
               tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , MovementItem.Amount
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE (MovementItem.Amount,0) > 0
                                  AND MovementItem.isErased = FALSE
                                )

             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           )
              -- продажи
             , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                                     , MIContainer.ObjectId_analyzer               AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                                     FROM MovementItemContainer AS MIContainer
                                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                          INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = MIContainer.ObjectId_analyzer
                                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                                       AND MIContainer.MovementDescId = zc_Movement_Check()
                                       AND MIContainer.OperDate > vbStartDate AND MIContainer.OperDate < vbEndDate
                                     GROUP BY MIContainer.ObjectId_analyzer 
                                            , MIContainer.WhereObjectId_analyzer
                                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                     )
              -- остатки
             , tmpRemains AS (SELECT tmp.UnitId
                                   , tmp.GoodsId
                                   , SUM (tmp.Amount) AS Amount
                              FROM  (SELECT Container.WhereObjectId AS UnitId
                                          , Container.ObjectId      AS GoodsId 
                                          , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) AS Amount
                                     FROM Container
                                         INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                         INNER JOIN tmpMI_Master ON tmpMI_Master.GoodsId = Container.ObjectId
                                         LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                              AND MovementItemContainer.Operdate >= vbEndDate
                                     WHERE Container.DescId = zc_Container_Count()
                                     GROUP BY Container.WhereObjectId
                                            , Container.ObjectId
                                            , Container.Amount 
                                     HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0
                                     ) AS tmp
                              GROUP BY tmp.UnitId
                                     , tmp.GoodsId
                              )

             , tmpData AS (SELECT COALESCE (tmpMI_Child.Id,0) AS Id
                                , tmpMI_Master.Id             AS ParentId
                                , tmpUnit.UnitId              AS UnitId
                                , tmpContainer.Amount         AS AmountOut
                                , tmpRemains.Amount           AS Remains
                                , tmpMI_Master.Amount         AS Amount_Master
                                , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpMI_Master.Id) AS AmountOutSUM
                           FROM tmpMI_Master
                                LEFT JOIN tmpUnit ON 1=1
                                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                                    AND tmpRemains.UnitId = tmpUnit.UnitId
                                LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                                      AND tmpContainer.UnitId = tmpUnit.UnitId
                                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                                                     AND tmpMI_Child.UnitId = tmpUnit.UnitId
                           WHERE COALESCE (tmpContainer.Amount,0) > 0
                           )

        SELECT tmpData.Id
              , tmpData.ParentId
              , tmpData.UnitId
              , tmpData.AmountOUT
              , tmpData.Remains
              , ROUND ( (tmpData.Amount_Master / tmpData.AmountOutSUM) * tmpData.AmountOUT, 1) AS AmountIn
        FROM tmpData;
           
    --- сохраняем данные чайлд      
    PERFORM lpInsertUpdate_MI_OrderInternalPromoChild (ioId         := COALESCE (tmpData.Id,0)
                                                     , inParentId   := tmpData.ParentId
                                                     , inMovementId := inMovementId
                                                     , inUnitId     := tmpData.UnitId
                                                     , inAmount     := COALESCE (tmpData.AmountIn,0)   :: TFloat
                                                     , inAmountOut  := COALESCE (tmpData.AmountOut,0)  :: TFloat
                                                     , inRemains    := COALESCE (tmpData.Remains,0)    :: TFloat
                                                     , inUserId     := vbUserId
                                                     )
    FROM tmpData;
    
     -- удаляем строки чайлд, которые нам не нужны
     UPDATE MovementItem 
     SET isErased = TRUE
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child()
       AND MovementItem.Id IN (SELECT tmpMI_Child.Id
                               FROM tmpMI_Child
                                    LEFT JOIN tmpData ON tmpData.Id = tmpMI_Child.Id
                                                     AND COALESCE (tmpData.Id,0) <> 0
                               WHERE tmpData.Id IS NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.19         *
*/