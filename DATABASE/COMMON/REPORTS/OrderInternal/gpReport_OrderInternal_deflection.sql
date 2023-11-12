-- Function: gpReport_OrderInternal_choice()

DROP FUNCTION IF EXISTS gpReport_OrderInternal_deflection (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_OrderInternal_deflection(
    IN inMovementId        Integer   , --
    IN inIsShowAll          Boolean   , -- свернуть и показать остатки  
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                      Integer
             , ContainerId             Integer
             , GoodsId                 Integer
             , GoodsCode               Integer
             , GoodsName               TVarChar
             , GoodsKindName           TVarChar
             , GoodsKindName_child     TVarChar
             , MeasureName             TVarChar
             , GoodsGroupName          TVarChar
             , GoodsGroupNameFull      TVarChar
             , Amount                  TFloat
             , Amount_child            TFloat
             
             , AmountRemains           TFloat
             , AmountRemains_child     TFloat
             , AmountRemains_calc      TFloat
             , AmountRemains_child_calc TFloat
             , AmountRemains_diff      TFloat     
             , PartionGoodsDate        TDateTime
              )
AS
$BODY$
   DECLARE vbUserId   Integer; 
   DECLARE vbOperDate TDateTime; 
   DECLARE vbFromId   Integer;
   DECLARE vbToId     Integer;
   DECLARE vbIsPack     Boolean;
   DECLARE vbIsBasis    Boolean;
   DECLARE vbIsTushenka Boolean;   
BEGIN

     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbFromId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId; 

    -- расчет, временно захардкодил - To = Цех Упаковки
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- Цех Упаковки
    -- расчет, временно захардкодил - From = ЦЕХ колбаса+дел-сы + ЦЕХ Тушенка
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND (ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp) OR ObjectId = 2790412) ); -- ЦЕХ колбаса+дел-сы + ЦЕХ Тушенка
    -- расчет, временно захардкодил - To = ЦЕХ Тушенка
    vbIsTushenka:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 2790412); -- ЦЕХ Тушенка

    -- остатки
     -- таблица
    CREATE TEMP TABLE tmpContainer_Count (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, Amount_next TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;
    
    --
    -- Список партий кол-во для всех подразделений (группа "От кого" + группа "Кому")
    INSERT INTO tmpContainer_Count (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount)
                                 WITH tmpUnit AS (SELECT UnitId, zc_MI_Master() AS MIDescId
                                                  FROM lfSelect_Object_Unit_byGroup (vbFromId) AS lfSelect_Object_Unit_byGroup
                                                  WHERE lfSelect_Object_Unit_byGroup.UnitId <> 1078643 -- Склад Карантин Тушенка
                                                    AND lfSelect_Object_Unit_byGroup.UnitId <> 9558031 -- Склад Неликвид

                                                 UNION
                                                  -- Склад Поклейки этикетки
                                                  SELECT 9073781 AS UnitId, zc_MI_Master() AS MIDescId
                                                  WHERE vbFromId = 8457 -- Склады База + Реализации

                                                 UNION
                                                  SELECT UnitId, zc_MI_Child() AS MIDescId
                                                  FROM lfSelect_Object_Unit_byGroup (vbToId) AS lfSelect
                                                  WHERE (lfSelect.UnitId <> vbToId
                                                      OR (vbToId          = 2790412 -- ЦЕХ Тушенка
                                                      AND lfSelect.UnitId = vbToId
                                                      AND vbIsBasis       = FALSE
                                                         ))
                                                    AND UnitId <> 1078643 -- Склад Карантин Тушенка
                                                 )
                                      -- Документ Инвентаризации
                                    , tmpInventory AS (SELECT Movement.Id AS MovementId, Movement.OperDate, MLO_From.ObjectId AS UnitId
                                                       FROM Movement
                                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From() AND MLO_From.ObjectId = vbFromId
                                                       WHERE Movement.OperDate < vboperdate
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                                         AND Movement.DescId = zc_Movement_Inventory()
                                                         AND vbIsBasis = TRUE
                                                       ORDER BY Movement.OperDate DESC
                                                       LIMIT 1
                                                      )
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                        , Object_InfoMoney_View.InfoMoneyDestinationId
                                                        , Object_InfoMoney_View.InfoMoneyId
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30102()            -- Доходы + Продукция + Тушенка
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье + запечена...
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = FALSE AND vbIsTushenka = FALSE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = FALSE AND vbIsTushenka = TRUE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- Доходы + Мясное сырье + Мясное сырье
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = TRUE AND vbIsBasis = FALSE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                                           -- OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Незавершенное производство
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = TRUE)
                                                  )
                               -- Элементы Инвентаризации - все (даже удаленные нужны) - и все это надо что б остатки разделить по видам, а в проводках этой инфы нет
                             , tmpMI_Inventory_all AS (SELECT MovementItem.ObjectId AS GoodsId
                                                            , CASE WHEN tmpGoods.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- Основное сырье
                                                                                                          , zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                                            )
                                                                    AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis()
                                                                        THEN 0 
                                                                   ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                              END AS GoodsKindId
                                                            , SUM (MovementItem.Amount) AS Amount
                                                            , MovementItem.isErased
                                                       FROM tmpInventory
                                                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpInventory.MovementId
                                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                                 --AND MovementItem.isErased   = FALSE
                                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                       GROUP BY MovementItem.ObjectId
                                                              , CASE WHEN tmpGoods.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- Основное сырье
                                                                                                            , zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                                                             )
                                                                      AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis()
                                                                          THEN 0 
                                                                     ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                END
                                                              , MovementItem.isErased, tmpGoods.InfoMoneyDestinationId
                                                      )
                            -- Элементы
                          , tmpContainer_list AS
                               (SELECT DISTINCT Container.Id AS ContainerId
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND Container.Amount = 0
                                     INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId

                                     LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                   ON CLO_Account.ContainerId = Container.Id
                                                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                     LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = Container.Id
                                                                                   AND MIContainer.OperDate >= vbOperDate
                                WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                                  AND MIContainer.ContainerId > 0
                               )
                            -- Элементы Инвентаризации - НЕ все - по которым надо считать ост вперед ... "по видам"
                          , tmpMI_Inventory AS (SELECT tmp.GoodsId, tmp.GoodsKindId, SUM (tmp.Amount) AS Amount
                                                FROM 
                                                      (-- добавили обычные остатки на начало - только для товаров с "видом"
                                                       SELECT tmpMI_Inventory_all.GoodsId, tmpMI_Inventory_all.GoodsKindId, tmpMI_Inventory_all.Amount
                                                       FROM tmpMI_Inventory_all
                                                       WHERE tmpMI_Inventory_all.isErased = FALSE AND tmpMI_Inventory_all.GoodsId IN (SELECT tmpMI_Inventory_all.GoodsId FROM tmpMI_Inventory_all WHERE tmpMI_Inventory_all.GoodsKindId > 0)
                                                      UNION ALL
                                                       -- добавили 0 остаток с пустым видом - нужен в списке что б считать по нему движение
                                                       SELECT tmpMI_Inventory_all.GoodsId, 0 AS GoodsKindId, 0 AS Amount
                                                       FROM tmpMI_Inventory_all
                                                       WHERE tmpMI_Inventory_all.isErased = FALSE AND tmpMI_Inventory_all.GoodsId IN (SELECT tmpMI_Inventory_all.GoodsId FROM tmpMI_Inventory_all WHERE tmpMI_Inventory_all.GoodsKindId > 0)
                                                      UNION ALL
                                                       -- добавили удаленные c 0 остатком и обязательно с видом - так криво, т.к. если ост.=0, то он помечается удаленным при проведении
                                                       SELECT tmpMI_Inventory_all.GoodsId, tmpMI_Inventory_all.GoodsKindId AS GoodsKindId, 0 AS Amount
                                                       FROM tmpMI_Inventory_all
                                                       WHERE tmpMI_Inventory_all.GoodsKindId > 0
                                                         AND tmpMI_Inventory_all.isErased = TRUE -- !!!удаленные!!!
                                                      ) AS tmp
                                                       GROUP BY tmp.GoodsId, tmp.GoodsKindId
                                                      )
                                -- Результат
                                SELECT tmpUnit.MIDescId
                                     , Container.Id                         AS ContainerId
                                     , Container.ObjectId                   AS GoodsId
                                     , CASE WHEN tmpGoods.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                                 THEN zc_GoodsKind_Basis()
                                                 ELSE COALESCE (CLO_GoodsKind.ObjectId, 0)
                                       END AS GoodsKindId
                                     , Container.Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                                         AND Container.ObjectId NOT IN (SELECT tmpMI_Inventory.GoodsId FROM tmpMI_Inventory)
                                                       --AND Container.Amount <> 0
                                     INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId

                                     LEFT JOIN tmpContainer_list ON tmpContainer_list.ContainerId = Container.Id
                                     
                                     LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                   ON CLO_Account.ContainerId = Container.Id
                                                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                                  AND (Container.Amount <> 0 OR tmpContainer_list.ContainerId > 0)
                               UNION ALL
                                -- !!!только для производства!!!
                                SELECT   zc_MI_Master() AS MIDescId
                                       , 0 AS ContainerId
                                       , tmpMI_Inventory.GoodsId
                                       , tmpMI_Inventory.GoodsKindId
                                       , tmpMI_Inventory.Amount
                                FROM tmpMI_Inventory
                               ;

       --
       -- Остатки кол-во для всех подразделений
       INSERT INTO tmpContainer (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start, Amount_next)
                                 -- Документ Инвентаризации
                                 WITH tmpInventory AS (SELECT Movement.Id AS MovementId, Movement.OperDate, MLO_From.ObjectId AS UnitId
                                                       FROM Movement
                                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From() AND MLO_From.ObjectId = vbFromId
                                                       WHERE Movement.OperDate < vbOperDate
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                                         AND Movement.DescId   = zc_Movement_Inventory()
                                                       ORDER BY Movement.OperDate DESC
                                                       LIMIT 1
                                                      )
                  , tmpMIContainer AS (SELECT MovementItem.ObjectId AS GoodsId
                                            , CASE -- !!!все!!! приходы - захардкодил, НЕ временно :)
                                                   WHEN MLO_From.ObjectId = 8445 -- Склад МИНУСОВКА
                                                        THEN 8338 -- морож.
                                                   -- !!!только!!! если он в нашем списке, иначе свернем его движение в GoodsKindId = 0
                                                   WHEN tmpContainer_Count.GoodsKindId > 0
                                                        THEN tmpContainer_Count.GoodsKindId
                                                   ELSE 0
                                              END AS GoodsKindId
                                            , SUM (CASE WHEN Movement.DescId = zc_Movement_Send() AND MLO_From.ObjectId = tmpInventory.UnitId AND MLO_To.ObjectId <> tmpInventory.UnitId
                                                             THEN -1 * MovementItem.Amount
                                                        WHEN Movement.DescId = zc_Movement_Send() AND MLO_From.ObjectId <> tmpInventory.UnitId AND MLO_To.ObjectId = tmpInventory.UnitId
                                                             THEN  1 * MovementItem.Amount
                                                        WHEN Movement.DescId = zc_Movement_ProductionUnion() AND MovementItem.DescId = zc_MI_Master()
                                                             THEN  1 * MovementItem.Amount
                                                        WHEN Movement.DescId = zc_Movement_ProductionUnion() AND MovementItem.DescId = zc_MI_Child()
                                                             THEN -1 * MovementItem.Amount
                                                        ELSE 0
                                                   END ) AS Amount
                                       FROM tmpInventory
                                            INNER JOIN Movement ON Movement.OperDate BETWEEN tmpInventory.OperDate + INTERVAL '1 DAY' AND vbOperDate - INTERVAL '1 DAY'
                                                               AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN MovementLinkObject AS MLO_To   ON MLO_To.MovementId   = Movement.Id AND MLO_To.DescId   = zc_MovementLinkObject_To()
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased   = FALSE
                                                                   AND MovementItem.ObjectId IN (SELECT tmpContainer_Count.GoodsId FROM tmpContainer_Count WHERE tmpContainer_Count.ContainerId = 0)
                                            LEFT JOIN MovementItem AS MI_Master
                                                                   ON MI_Master.MovementId = Movement.Id
                                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                                  AND MI_Master.Id         = MovementItem.ParentId
                                                                  AND MI_Master.isErased   = FALSE	
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                                AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                            LEFT JOIN tmpContainer_Count ON tmpContainer_Count.GoodsId     = MovementItem.ObjectId
                                                                        AND tmpContainer_Count.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                                                        AND tmpContainer_Count.ContainerId = 0
                                       WHERE (MLO_From.ObjectId = tmpInventory.UnitId OR MLO_To.ObjectId = tmpInventory.UnitId)
                                         AND (MovementItem.DescId = zc_MI_Master()
                                           OR (MovementItem.DescId = zc_MI_Child() AND MI_Master.Id > 0)
                                             )
                                       GROUP BY MovementItem.ObjectId
                                              , CASE WHEN MLO_From.ObjectId = 8445 -- Склад МИНУСОВКА
                                                          THEN 8338 -- морож.
                                                     WHEN tmpContainer_Count.GoodsKindId > 0
                                                          THEN tmpContainer_Count.GoodsKindId
                                                     ELSE 0
                                                END
                                      )
                                  -- Результат
                                  SELECT   tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount - SUM (COALESCE(MIContainer.Amount, 0))  AS Amount_start
                                         , SUM (CASE WHEN vbIsPack  = FALSE -- !!!только для производства!!!
                                                      AND vbIsBasis = FALSE -- !!!только для производства!!!
                                                      AND MIContainer.OperDate >= vbOperDate
                                                      AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      AND MIContainer.isActive = TRUE
                                                          THEN COALESCE (MIContainer.Amount,0)
                                                     ELSE 0
                                                END)  AS Amount_next
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= vbOperDate
                                  WHERE tmpContainer_Count.ContainerId > 0
                                  GROUP BY tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  HAVING  (tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                     /*   OR SUM (CASE WHEN vbIsPack  = FALSE -- !!!только для производства!!!
                                                      AND vbIsBasis = FALSE -- !!!только для производства!!!
                                                      AND MIContainer.OperDate >= vbOperDate
                                                      AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      AND MIContainer.isActive = TRUE
                                                          THEN MIContainer.Amount
                                                     ELSE 0
                                                END) <> 0       */
                                 UNION ALL
                                  -- !!!только для производства!!!
                                  SELECT   tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount + SUM (COALESCE (tmpMIContainer.Amount, 0))  AS Amount_start
                                         , 0 AS Amount_next
                                  FROM tmpContainer_Count
                                       LEFT JOIN tmpMIContainer ON tmpMIContainer.GoodsId     = tmpContainer_Count.GoodsId
                                                               AND tmpMIContainer.GoodsKindId = tmpContainer_Count.GoodsKindId
                                  WHERE tmpContainer_Count.ContainerId = 0
                                  GROUP BY tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  HAVING tmpContainer_Count.Amount + COALESCE (SUM (tmpMIContainer.Amount), 0) <> 0
                                  ;


     RETURN QUERY
     WITH 
      --Данные из заявки
     tmpMI_master AS (SELECT /*MovementItem.Id                                       AS MovementItemId
                        ,*/ COALESCE (MILinkObject_Goods.ObjectId
                                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                              THEN MovementItem.ObjectId
                                         ELSE 0
                                    END
                                   )AS GoodsId
                        , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis
                        , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                              THEN zc_GoodsKind_Basis()
                                         ELSE 0
                                    END
                                   ) AS GoodsKindId_complete
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                        , SUM (MovementItem.Amount)                                   AS Amount
                        --, SUM (CASE WHEN ABS (COALESCE (MIFloat_AmountRemains.ValueData, 0)) < 1 THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) ELSE CAST (COALESCE (MIFloat_AmountRemains.ValueData, 0) AS NUMERIC (16, 1)) END) :: TFloat AS AmountRemains
                        , SUM (COALESCE (MIFloat_AmountRemains.ValueData, 0))   AS AmountRemains
                        , MIFloat_ContainerId.ValueData                         AS ContainerId
                        , MAX (CASE WHEN ObjectFloat_TaxLoss.ValueData > 0 THEN 1 - ObjectFloat_TaxLoss.ValueData / 100 ELSE 1 END) AS KoeffLoss   
                        
                   FROM MovementItem
                        LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                    ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                       AND  = Object_InfoMoney_View.InfoMoneyId

                        LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                    ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                         ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsBasis.DescId = zc_MILinkObject_GoodsBasis()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                         ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                        LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                    ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                         ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                        LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                              ON ObjectFloat_TaxLoss.ObjectId = MILinkObject_Receipt.ObjectId
                                             AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Master()
                     AND MovementItem.isErased   = FALSE
                   GROUP BY COALESCE (MILinkObject_Goods.ObjectId
                          , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                   THEN MovementItem.ObjectId
                              ELSE 0
                         END )
                        , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0) 
                        , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                        , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                    THEN zc_GoodsKind_Basis()
                               ELSE 0
                          END) 
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                        , MIFloat_ContainerId.ValueData  
                   )
      --  
     , tmpGoods_params AS (SELECT tmpMI_master.GoodsId_basis, MAX (tmpMI_master.KoeffLoss) AS KoeffLoss
                           FROM tmpMI_master
                           GROUP BY tmpMI_master.GoodsId_basis
                          )
                                
     , tmpMI_child AS (SELECT MovementItem.Id                                       AS MovementItemId
                            , MovementItem.ObjectId                                 AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete
                            , MIFloat_ContainerId.ValueData                         AS ContainerId
                            --, MovementItem.Amount                                   AS Amount  
                            , CASE WHEN ABS (MovementItem.Amount) < 1 THEN MovementItem.Amount ELSE CAST (MovementItem.Amount AS NUMERIC (16, 1)) END :: TFloat AS Amount 
                            , CAST (MovementItem.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1)) :: TFloat AS Amount_calc
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                            LEFT JOIN tmpGoods_params ON tmpGoods_params.GoodsId_basis = MovementItem.ObjectId
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       )

     , tmpContainer_master AS (-- остатки для zc_MI_Master - группируются
                                                   SELECT tmpContainer.GoodsId
                                                        , tmpContainer.GoodsKindId
                                                        , SUM (tmpContainer.Amount_start) AS Amount_start
                                                   FROM tmpContainer
                                                   WHERE tmpContainer.MIDescId = zc_MI_Master()
                                                   GROUP BY tmpContainer.GoodsId
                                                          , tmpContainer.GoodsKindId
                                                   HAVING SUM (tmpContainer.Amount_start) <> 0
                                                  )
     , tmpContainer_child AS (-- остатки для zc_MI_Child
                              SELECT tmpContainer.ContainerId
                                   , tmpContainer.GoodsId
                                   , tmpContainer.GoodsKindId
                                   , tmpContainer.Amount_start
                                   , tmpContainer.Amount_next
                              FROM tmpContainer
                              WHERE MIDescId = zc_MI_Child()
                             )

     , tmpData AS (SELECT *
                   FROM (-- результат - для zc_MI_Master
                        SELECT zc_MI_Master()                                          AS MIDescId
                             , 0                                                       AS ContainerId
                             , COALESCE (tmpContainer.GoodsId, tmpMI.GoodsId)          AS GoodsId
                             , COALESCE (tmpContainer.GoodsKindId, tmpMI.GoodsKindId)  AS GoodsKindId 
                             , tmpMI.Amount                                            AS Amount
                             , 0                                                       AS Amount_calc
                             , COALESCE (tmpMI.AmountRemains, 0)       ::TFloat        AS AmountRemains  -- из документа      
                             , COALESCE (tmpContainer.Amount_start, 0)                 AS AmountRemains_calc       --расчетній остаток
                        FROM tmpContainer_master AS tmpContainer
                           FULL JOIN tmpMI_master AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                                          AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
                      UNION ALL
                        -- результат - для zc_MI_Child
                        SELECT zc_MI_Child()                                           AS MIDescId
                             , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                             , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId 
                             , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId 
                             , tmpMI.Amount                                            AS Amount
                             , tmpMI.Amount_calc
                             , 0                                                                  AS AmountRemains
                             , COALESCE (tmpContainer.Amount_start + tmpContainer.Amount_next, 0) AS AmountRemains_calc
                        FROM tmpContainer_child AS tmpContainer
                           FULL JOIN tmpMI_child AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
                        ) AS tmp
                   WHERE (COALESCE (tmp.AmountRemains_calc,0) <> (COALESCE (tmp.AmountRemains,0) + COALESCE (tmp.Amount_calc,0))) 
                         OR inisShowAll = TRUE
                   ) 
                      

       -- Результат
       SELECT
             0                                          AS Id
           , tmpData.ContainerId        ::Integer       AS ContainerId
           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName  
                      
           , CASE WHEN tmpData.MIDescId = zc_MI_Child() THEN Object_GoodsKind.ValueData ELSE NULL END ::TVarChar AS GoodsKindName
           , CASE WHEN tmpData.MIDescId = zc_MI_Master()  THEN Object_GoodsKind.ValueData ELSE NULL END ::TVarChar AS GoodsKindName_child
           , Object_Measure.ValueData                   AS MeasureName
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           --
           , CASE WHEN tmpData.MIDescId = zc_MI_Master() THEN tmpData.Amount ELSE 0 END ::TFloat AS Amount
           , CASE WHEN tmpData.MIDescId = zc_MI_Child()  THEN tmpData.Amount ELSE 0 END ::TFloat AS Amount_child
              
           , tmpData.AmountRemains           ::TFloat 
           , tmpData.Amount_calc             ::TFloat AS AmountRemains_child     --ост произв.
           
           , CASE WHEN tmpData.MIDescId = zc_MI_Master() THEN tmpData.AmountRemains_calc ELSE 0 END ::TFloat AS AmountRemains_calc 
           , CASE WHEN tmpData.MIDescId = zc_MI_Child()  THEN tmpData.AmountRemains_calc ELSE 0 END ::TFloat AS AmountRemains_child_calc
           
           , ((COALESCE (tmpData.AmountRemains,0) + COALESCE (tmpData.Amount_calc,0)) - COALESCE (tmpData.AmountRemains_calc ,0))  ::TFloat AS AmountRemains_diff
           
           , ObjectDate_Value.ValueData ::TDateTime AS  PartionGoodsDate

       FROM tmpData
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId 
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId  
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull() 
          
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                        ON CLO_PartionGoods.ContainerId = tmpData.ContainerId
                                       AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                  AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.23         *
*/

-- тест
--SELECT * FROM gpReport_OrderInternal_deflection (inMovementId:= 26370680  ::integer , inIsShowAll := false::boolean, inSession:= zfCalc_UserAdmin()::tvarchar)
--where GoodsCode = 54