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
   DECLARE vbDays TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

     SELECT (MovementDate_StartSale.ValueData - INTERVAL '1 DAY')
          , (Movement.OperDate + INTERVAL '1 DAY')
          , MovementLinkObject_Retail.ObjectId AS RetailId
          , (DATE_PART('day', AGE ((Movement.OperDate + INTERVAL '1 DAY'), (MovementDate_StartSale.ValueData - INTERVAL '1 DAY')))) :: TFloat
    INTO vbStartDate, vbEndDate, vbRetailId, vbDays
     FROM Movement 
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
     WHERE Movement.Id = inMovementId;

    -- Cуществующие чайлд
     CREATE TEMP TABLE tmpMI_Child (Id Integer, ParentId Integer, UnitId Integer, AmountManual TFloat) ON COMMIT DROP;
       INSERT INTO tmpMI_Child (Id, ParentId, UnitId, AmountManual)
       SELECT MovementItem.Id
            , MovementItem.ParentId
            , MovementItem.ObjectId AS UnitId
            , COALESCE (MIFloat_AmountManual.ValueData,0) AS AmountManual
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Child();

     -- снимаем удаление со строк чайлд
     UPDATE MovementItem
     SET isErased = FALSE, Amount = 0
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child();

    CREATE TEMP TABLE tmpData (Id Integer, ParentId Integer, UnitId Integer, AmountOut TFloat, Remains TFloat, AmountIn TFloat, AmountManual TFloat) ON COMMIT DROP;
          INSERT INTO tmpData (Id, ParentId, UnitId, AmountOut, Remains, AmountIn, AmountManual)
          WITH 
               tmpMI_Chil_Manual AS (SELECT tmpMI_Child.ParentId
                                          , SUM (tmpMI_Child.AmountManual) AS AmountManual
                                     FROM tmpMI_Child
                                     WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
                                     GROUP BY tmpMI_Child.ParentId
                                     )
               -- строки мастера с кол-вом для распределения
             , tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , (MovementItem.Amount - COALESCE (tmpMI_Chil_Manual.AmountManual, 0)) AS Amount
                                FROM MovementItem
                                     LEFT JOIN tmpMI_Chil_Manual ON tmpMI_Chil_Manual.ParentId = MovementItem.Id
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
                                , tmpContainer.Amount         AS AmountOut_real
                                , CASE WHEN COALESCE (tmpMI_Child.AmountManual, 0) <> 0 
                                       THEN 0
                                       ELSE (((tmpContainer.Amount /vbDays )*300 - COALESCE (tmpRemains.Amount,0))/300)
                                  END  AS AmountOut
                                , COALESCE (tmpRemains.Amount,0)           AS Remains
                                , tmpMI_Master.Amount         AS Amount_Master
                                , CASE WHEN COALESCE (tmpMI_Child.AmountManual, 0) <> 0 
                                       THEN 0
                                       ELSE SUM (((tmpContainer.Amount /vbDays )*300 - COALESCE (tmpRemains.Amount,0))/300) OVER (PARTITION BY tmpMI_Master.Id)
                                  END  AS AmountOutSUM
                                , COALESCE (tmpMI_Child.AmountManual, 0) AS AmountManual
                           FROM tmpMI_Master
                                LEFT JOIN tmpUnit ON 1=1
                                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                                    AND tmpRemains.UnitId = tmpUnit.UnitId
                                LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                                      AND tmpContainer.UnitId = tmpUnit.UnitId
                                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                                                     AND tmpMI_Child.UnitId = tmpUnit.UnitId
                           WHERE COALESCE (tmpContainer.Amount,0) > 0
                             AND COALESCE (tmpMI_Child.AmountManual, 0) = 0
                           )

             , tmpData1 AS (SELECT tmpData.Id
                                  , tmpData.ParentId
                                  , tmpData.UnitId
                                  , tmpData.AmountManual
                                  , tmpData.AmountOut
                                  , tmpData.AmountOut_real
                                  , tmpData.Remains
                                  , CASE WHEN tmpData.AmountOutSUM <> 0
                                         THEN ROUND ( (tmpData.Amount_Master / tmpData.AmountOutSUM * tmpData.AmountOut, 0)
                                         ELSE 0
                                    END   AS Amount_Calc
                            FROM tmpData
                            WHERE COALESCE (tmpData.AmountManual,0) = 0)

              -- вспомогательные расчеты для распределения заказа
             , tmpData111 AS (SELECT tmpMI_Master.GoodsId
                                   , tmpData1.UnitId
                                   , tmpData1.Id
                                   , tmpMI_Master.Amount          AS Amount_Master
                                   , tmpMI_Master.Id              AS ParentId
                                   , tmpData1.AmountManual
                                   , tmpData1.Amount_Calc
                                   , tmpData1.AmountOut
                                   , tmpData1.AmountOut_real
                                   , tmpData1.Remains
                                   , SUM (tmpData1.Amount_Calc) OVER (PARTITION BY tmpData1.ParentId ORDER BY tmpData1.AmountOut, tmpMI_Master.Id) AS Amount_CalcSUM
                                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.GoodsId/*, tmpMI_Master.Id*/ ORDER BY tmpData1.AmountOut DESC) AS DOrd
                              FROM tmpMI_Master
                                   INNER JOIN tmpData1 AS tmpData1 ON tmpData1.ParentId = tmpMI_Master.Id
                              )
         -- результат
         SELECT DD.Id
              , DD.ParentId
              , DD.UnitId
              , DD.AmountOUT
              , DD.Remains
              , DD.AmountIn
              , DD.AmountManual :: TFloat
         FROM (SELECT DD.Id
                    , DD.ParentId
                    , DD.UnitId
                    , DD.AmountOut_real AS AmountOut
                    , DD.Remains
                    , CASE WHEN DD.Amount_Master - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                                THEN ceil (DD.Amount_Calc)                                           ---ceil
                           ELSE ceil ( DD.Amount_Master - DD.Amount_CalcSUM + DD.Amount_Calc)
                      END AS AmountIn
                    , 0 :: TFloat AS AmountManual
               FROM tmpData111 AS DD
               WHERE DD.Amount_Master - (DD.Amount_CalcSUM - DD.Amount_Calc) > 0
             UNION
               SELECT tmpMI_Child.Id
                    , tmpMI_Child.ParentId
                    , tmpMI_Child.UnitId
                    , tmpContainer.Amount         --AS AmountOut_real
                    , tmpRemains.Amount           AS Remains
                    , 0 AS AmountIn
                    , COALESCE (tmpMI_Child.AmountManual, 0) AS AmountManual
               FROM tmpMI_Child
                    LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                                 
                    LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                        AND tmpRemains.UnitId = tmpMI_Child.UnitId
                                        
                    LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                          AND tmpContainer.UnitId = tmpMI_Child.UnitId
                                          
               WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
               ) AS DD;
           
    --- сохраняем данные чайлд      
    PERFORM lpInsertUpdate_MI_OrderInternalPromoChild (ioId           := COALESCE (tmpData.Id,0)
                                                     , inParentId     := tmpData.ParentId
                                                     , inMovementId   := inMovementId
                                                     , inUnitId       := tmpData.UnitId
                                                     , inAmount       := COALESCE (tmpData.AmountIn,0)   :: TFloat
                                                     , inAmountManual := COALESCE (tmpData.AmountManual,0)   :: TFloat
                                                     , inAmountOut    := COALESCE (tmpData.AmountOut,0)  :: TFloat
                                                     , inRemains      := COALESCE (tmpData.Remains,0)    :: TFloat
                                                     , inUserId       := vbUserId
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
 09.05.19         *
 16.04.19         *
*/



/*

  
        WITH 
tmpMI_Child AS (
       SELECT MovementItem.Id
            , MovementItem.ParentId
            , MovementItem.ObjectId AS UnitId
            , COALESCE (MIFloat_AmountManual.ValueData,0) AS AmountManual
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        WHERE MovementItem.MovementId = 13840564
          AND MovementItem.DescId = zc_MI_Child()
              )
             ,  tmpMI_Chil_Manual AS (SELECT tmpMI_Child.ParentId
                                          , SUM (tmpMI_Child.AmountManual) AS AmountManual
                                     FROM tmpMI_Child
                                     WHERE COALESCE (tmpMI_Child.AmountManual, 0) <> 0
                                     GROUP BY tmpMI_Child.ParentId
                                     )
               -- строки мастера с кол-вом для распределения
             , tmpMI_Master AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId AS GoodsId
                                     , (MovementItem.Amount - COALESCE (tmpMI_Chil_Manual.AmountManual, 0)) AS Amount
                                FROM MovementItem
                                     LEFT JOIN tmpMI_Chil_Manual ON tmpMI_Chil_Manual.ParentId = MovementItem.Id
                                WHERE MovementItem.MovementId = 13840564
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND COALESCE (MovementItem.Amount,0) > 0
                                  AND MovementItem.isErased = FALSE
                                )
             

             , tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.ChildObjectId = 4--vbRetailId
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
                                       AND MIContainer.OperDate > '31.03.2019' AND MIContainer.OperDate < '17.04.2019'
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
                                                                              AND MovementItemContainer.Operdate >= '17.04.2019'
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
                                , tmpContainer.Amount         AS AmountOut_real
                                , ((((tmpContainer.Amount /17 )*300 - COALESCE (tmpRemains.Amount,0))/300) * 17 ) AS AmountOut
                                , COALESCE (tmpRemains.Amount,0)           AS Remains
                                , tmpMI_Master.Amount         AS Amount_Master
                                , SUM ((((tmpContainer.Amount /17 )*300 - COALESCE (tmpRemains.Amount,0))/300)*17) OVER (PARTITION BY tmpMI_Master.Id) AS AmountOutSUM
                                , COALESCE (tmpMI_Child.AmountManual, 0) AS AmountManual
                           FROM tmpMI_Master
                                LEFT JOIN tmpUnit ON 1=1
                                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_Master.GoodsId
                                                    AND tmpRemains.UnitId = tmpUnit.UnitId
                                LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI_Master.GoodsId
                                                      AND tmpContainer.UnitId = tmpUnit.UnitId
                                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
                                                     AND tmpMI_Child.UnitId = tmpUnit.UnitId
                           WHERE COALESCE (tmpContainer.Amount,0) > 0
                              and COALESCE (tmpMI_Child.AmountManual, 0) = 0
                           )


             , tmpData1 AS (SELECT tmpData.Id
                                  , tmpData.ParentId
                                  , tmpData.UnitId
                                  , tmpData.AmountManual
                                  , tmpData.AmountOut
                                  , tmpData.AmountOut_real
                                  , tmpData.Remains
                                  , ROUND ( (tmpData.Amount_Master / tmpData.AmountOutSUM) * tmpData.AmountOut, 0) AS Amount_Calc
, tmpData.AmountOut / tmpData.AmountOutSUM * tmpData.Amount_Master As yyy
                            FROM tmpData
                            WHERE COALESCE (tmpData.AmountManual,0) = 0)

select * from tmpData1

              -- вспомогательные расчеты для распределения заказа
             , tmpData111 AS (SELECT tmpMI_Master.GoodsId
                                   , tmpData1.UnitId
                                   , tmpData1.Id
                                   , tmpMI_Master.Amount          AS Amount_Master
                                   , tmpMI_Master.Id              AS ParentId
                                   , tmpData1.AmountManual
                                   , tmpData1.Amount_Calc
                                   , tmpData1.AmountOut
                                   , tmpData1.AmountOut_real
                                   , tmpData1.Remains
                                   , SUM (tmpData1.Amount_Calc) OVER (PARTITION BY tmpData1.ParentId ORDER BY tmpData1.AmountOut, tmpMI_Master.Id) AS Amount_CalcSUM
                                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.GoodsId/*, tmpMI_Master.Id*/ ORDER BY tmpData1.AmountOut DESC) AS DOrd
                              FROM tmpMI_Master
                                   INNER JOIN tmpData1 AS tmpData1 ON tmpData1.ParentId = tmpMI_Master.Id
                              )
         -- результат
         SELECT DD.Id
              , DD.ParentId
              , DD.UnitId
              , DD.AmountOUT
              , DD.Remains
              , DD.AmountIn
              , DD.AmountManual :: TFloat
         FROM (SELECT DD.Id
                    , DD.ParentId
                    , DD.UnitId
                    , DD.AmountOut_real AS AmountOut
                    , DD.Remains
                    , CASE WHEN DD.Amount_Master - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                                THEN  (DD.Amount_Calc)                                           ---ceil
                           ELSE  ( DD.Amount_Master - DD.Amount_CalcSUM + DD.Amount_Calc)
                      END AS AmountIn
                    , 0 :: TFloat AS AmountManual
               FROM tmpData111 AS DD
               WHERE DD.Amount_Master - (DD.Amount_CalcSUM - DD.Amount_Calc) >= 0
             UNION
               SELECT tmpData.Id
                    , tmpData.ParentId
                    , tmpData.UnitId
                    , tmpData.AmountOut_real AS AmountOut
                    , tmpData.Remains
                    , 0 AS AmountIn
                    , tmpData.AmountManual ::TFloat
               FROM tmpData
               WHERE COALESCE (tmpData.AmountManual,0) <> 0
               ) AS DD;
           
*/