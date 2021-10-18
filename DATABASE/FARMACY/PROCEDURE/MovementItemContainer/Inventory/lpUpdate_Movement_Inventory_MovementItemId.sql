-- Function: lpUpdate_Movement_Inventory_MovementItemId (Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_Inventory_MovementItemId (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Inventory_MovementItemId(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbTmp Integer;
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbInventoryDate TDateTime;
   DECLARE vbFullInvent Boolean;
BEGIN


    SELECT MovementLinkObject.ObjectId, ObjectLink_Unit_Juridical.ChildObjectId INTO vbUnitId, vbJuridicalId
    FROM MovementLinkObject
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON MovementLinkObject.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE MovementLinkObject.MovementId = inMovementId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();

    SELECT date_trunc ('day', Movement.OperDate),COALESCE(MovementBoolean_FullInvent.ValueData,False)
    INTO vbInventoryDate, vbFullInvent
    FROM Movement
        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                        ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                       AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = inMovementId;


     -- !!!5.3. формируется свойство <MovementItemId - для созданных партий этой инвентаризацией - ближайший документ прихода, из которого для ВСЕХ отчетов будем считать с/с> !!!
     vbTmp:= (WITH tmpMIContainer AS
                     (SELECT MIContainer.MovementItemId
                           , MIContainer.ContainerId
                           , Container.ObjectId AS GoodsId
                      FROM MovementItemContainer AS MIContainer
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                                                          AND Object_PartionMovementItem.ObjectCode = MIContainer.MovementItemId
                           INNER JOIN Container ON Container.Id = MIContainer.ContainerId
                      WHERE MIContainer.MovementId = inMovementId
                        AND MIContainer.DescId = zc_MIContainer_Count()
                     )
                 , tmpContainer AS (SELECT tmpMIContainer.MovementItemId
                                            , Container.ObjectId   AS GoodsId
                                            , Container.ID
                                       FROM tmpMIContainer
                                           
                                            INNER JOIN Container ON Container.ObjectId = tmpMIContainer.GoodsId
                                                                AND Container.DescId = zc_Container_Count()
                                                                AND Container.WhereObjectId = vbUnitId
                                                                AND Container.ID NOT IN (SELECT DISTINCT tmpMIContainer.ContainerID FROM tmpMIContainer)

                                        )
                 , tmpContainerAll AS (SELECT Container.MovementItemId
                                            , Container.GoodsId
                                            , vbJuridicalId                                                     AS JuridicalId
                                            , COALESCE (MI_Income_find.Id, MI_Income.Id)                        AS MovementItemId_find
                                            , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)        AS IncomeId
                                            , Movement.OperDate
                                       FROM tmpContainer AS Container
                                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                          ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                            -- элемент прихода
                                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                                            LEFT JOIN Movement ON Movement.Id = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                        )
                 , tmpContainerNotFind AS (SELECT tmpMIContainer.*
                                           FROM tmpMIContainer
                                               
                                                LEFT JOIN tmpContainerAll ON tmpContainerAll.MovementItemId = tmpMIContainer.MovementItemId
                                                
                                           WHERE COALESCE(tmpContainerAll.MovementItemId, 0) = 0
                                            )
                 , tmpIncomeNotFind AS (SELECT MI.Id AS MovementItemId_find
                                             , tmpMIContainer.MovementItemId
                                             , tmpMIContainer.GoodsId
                                             , ObjectLink_Unit_Juridical.ChildObjectId      AS JuridicalId
                                             , Movement.Id                                  AS IncomeId
                                             , Movement.OperDate
                                        FROM tmpContainerNotFind AS tmpMIContainer
                                             INNER JOIN Movement ON Movement.DescId = zc_Movement_Income() AND Movement.StatusId = zc_Enum_Status_Complete()
                                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                                   ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                                  -- AND ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId - !!!убрал!!!
                                             INNER JOIN MovementItem AS MI
                                                                     ON MI.MovementId = Movement.Id
                                                                    AND MI.DescId = zc_MI_Master()
                                                                    AND MI.isErased = FALSE
                                                                    AND MI.ObjectId = tmpMIContainer.GoodsId
                                                                    AND MI.Amount <> 0
                                       )
                 , tmpIncomeAll AS (SELECT tmpContainerAll.MovementItemId_find
                                         , tmpContainerAll.MovementItemId
                                         , tmpContainerAll.GoodsId
                                         , tmpContainerAll.JuridicalId
                                         , tmpContainerAll.IncomeId
                                         , tmpContainerAll.OperDate
                                    FROM tmpContainerAll
                                    UNION ALL
                                    SELECT tmpIncomeNotFind.MovementItemId_find
                                         , tmpIncomeNotFind.MovementItemId
                                         , tmpIncomeNotFind.GoodsId
                                         , tmpIncomeNotFind.JuridicalId
                                         , tmpIncomeNotFind.IncomeId
                                         , tmpIncomeNotFind.OperDate
                                    FROM tmpIncomeNotFind
                                   )

                 , tmpIncome AS
                     (SELECT *
                      FROM
                        (SELECT tmpIncomeAll.MovementItemId_find
                              , tmpIncomeAll.MovementItemId
                              , tmpIncomeAll.GoodsId
                              , ROW_NUMBER() OVER (PARTITION BY tmpIncomeAll.MovementItemId, tmpIncomeAll.GoodsId
                                                   ORDER BY CASE WHEN tmpIncomeAll.JuridicalId = vbJuridicalId THEN 0 ELSE 1 END
                                                          , CASE WHEN tmpIncomeAll.OperDate >= vbInventoryDate 
                                                                 THEN tmpIncomeAll.OperDate - vbInventoryDate ELSE vbInventoryDate - tmpIncomeAll.OperDate END
                                                          , tmpIncomeAll.OperDate
                                                  ) AS myRow
                         FROM tmpIncomeAll

                        ) AS tmp
                      WHERE tmp.myRow = 1
                     )
              SELECT MAX (CASE WHEN TRUE = lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), tmpIncome.MovementItemId, tmpIncome.MovementItemId_find) THEN 1 ELSE 0 END)
              FROM tmpIncome
             );

/*    IF inUserId = zfCalc_UserAdmin()::Integer
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inUserId;
    END IF;
*/    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.06.20                                                       *
*/

-- тест
-- select lpUpdate_Movement_Inventory_MovementItemId (inMovementId:= Id, inUserId:= zfCalc_UserAdmin()::Integer) from gpSelect_Movement_Inventory(instartdate := ('06.10.2021')::TDateTime , inenddate := ('18.10.2021')::TDateTime , inIsErased := 'False' ,  inSession := '3');
-- SELECT * FROM lpUpdate_Movement_Inventory_MovementItemId (inMovementId:= 25180677, inUserId:= zfCalc_UserAdmin()::Integer)