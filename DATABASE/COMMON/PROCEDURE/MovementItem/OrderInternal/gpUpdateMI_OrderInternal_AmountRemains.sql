-- Function: gpUpdateMI_OrderInternal_AmountRemains()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemains (Integer, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemains (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountRemains(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inToId                Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;

   DECLARE vbIsPack     Boolean;
   DECLARE vbIsBasis    Boolean;
   DECLARE vbIsTushenka Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры 
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- расчет, временно захардкодил - To = Цех Упаковки
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- Цех Упаковки
    -- расчет, временно захардкодил - From = ЦЕХ колбаса+дел-сы + ЦЕХ Тушенка
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject
                        WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId
                          AND (-- ЦЕХ колбаса+дел-сы
                               ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp)
                               -- ЦЕХ Тушенка
                            OR ObjectId = 2790412
                               -- ЦЕХ колбасный (Ирна)
                            OR ObjectId = 8020711
                              )
                       );
    -- расчет, временно захардкодил - To = ЦЕХ Тушенка
    vbIsTushenka:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 2790412); -- ЦЕХ Тушенка

    -- таблица
    CREATE TEMP TABLE tmpContainer_Count (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, Amount_next TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;
    
    --
    -- Список партий кол-во для всех подразделений (группа "От кого" + группа "Кому")
    INSERT INTO tmpContainer_Count (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount)
                                 WITH tmpUnit AS (SELECT UnitId, zc_MI_Master() AS MIDescId
                                                  FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup
                                                  WHERE lfSelect_Object_Unit_byGroup.UnitId <> 1078643 -- Склад Карантин Тушенка
                                                    AND lfSelect_Object_Unit_byGroup.UnitId <> 9558031 -- Склад Неликвид

                                                 UNION
                                                  -- Склад Поклейки этикетки
                                                  SELECT 9073781 AS UnitId, zc_MI_Master() AS MIDescId
                                                  WHERE inFromId = 8457 -- Склады База + Реализации

                                                 UNION
                                                  SELECT UnitId, zc_MI_Child() AS MIDescId
                                                  FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect
                                                  WHERE (lfSelect.UnitId <> inToId
                                                      OR inToId           = 8020711 -- ЦЕХ колбасный (Ирна)
                                                      OR (inToId          = 2790412 -- ЦЕХ Тушенка
                                                      AND lfSelect.UnitId = inToId
                                                      AND vbIsBasis       = FALSE
                                                         ))
                                                    AND UnitId <> 1078643 -- Склад Карантин Тушенка
                                                 )
                                      -- Документ Инвентаризации
                                    , tmpInventory AS (SELECT Movement.Id AS MovementId, Movement.OperDate, MLO_From.ObjectId AS UnitId
                                                       FROM Movement
                                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From() AND MLO_From.ObjectId = inFromId
                                                       WHERE Movement.OperDate < inOperDate
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
                                                                                   AND MIContainer.OperDate >= inOperDate
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
                                                            INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id AND MLO_From.DescId = zc_MovementLinkObject_From() AND MLO_From.ObjectId = inFromId
                                                       WHERE Movement.OperDate < inOperDate
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
                                            INNER JOIN Movement ON Movement.OperDate BETWEEN tmpInventory.OperDate + INTERVAL '1 DAY' AND inOperDate - INTERVAL '1 DAY'
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
                                         , tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_start
                                         , SUM (CASE WHEN vbIsPack  = FALSE -- !!!только для производства!!!
                                                      AND vbIsBasis = FALSE -- !!!только для производства!!!
                                                      AND MIContainer.OperDate >= inOperDate
                                                      AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      AND MIContainer.isActive = TRUE
                                                          THEN MIContainer.Amount
                                                     ELSE 0
                                                END)  AS Amount_next
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inOperDate
                                  WHERE tmpContainer_Count.ContainerId > 0
                                  GROUP BY tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  HAVING  (tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                        OR SUM (CASE WHEN vbIsPack  = FALSE -- !!!только для производства!!!
                                                      AND vbIsBasis = FALSE -- !!!только для производства!!!
                                                      AND MIContainer.OperDate >= inOperDate
                                                      AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      AND MIContainer.isActive = TRUE
                                                          THEN MIContainer.Amount
                                                     ELSE 0
                                                END) <> 0
                                 UNION ALL
                                  -- !!!только для производства!!!
                                  SELECT   tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount + COALESCE (SUM (tmpMIContainer.Amount), 0)  AS Amount_start
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
          --
          -- объединение существующих элементов документа + остатки
          INSERT INTO tmpAll (MovementItemId, MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start)
                      WITH -- существующие элементы документа
                           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                          , MovementItem.DescId                           AS MIDescId
                                          , MovementItem.ObjectId                         AS GoodsId
                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , MovementItem.Amount                           AS Amount
                                          , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId
                                            -- № п/п
                                          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                          , COALESCE (MIFloat_ContainerId.ValueData, 0)
                                                               ORDER BY MovementItem.Id DESC
                                                              ) AS Ord
                                     FROM MovementItem
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                                          AND MovementItem.DescId                   = zc_MI_Master()
                                          LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                      ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                                     AND MovementItem.DescId                = zc_MI_Child()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.isErased   = FALSE
                                    )
                         , tmpMI_master AS (SELECT MovementItemId, MIDescId, GoodsId, GoodsKindId, Amount, ContainerId
                                            FROM tmpMI
                                            WHERE MIDescId = zc_MI_Master() AND Ord = 1)
                         , tmpMI_child AS (SELECT MovementItemId, MIDescId, GoodsId, GoodsKindId, Amount, ContainerId FROM tmpMI WHERE MIDescId = zc_MI_Child())
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
                                                   SELECT ContainerId, GoodsId, GoodsKindId, Amount_start, Amount_next FROM tmpContainer WHERE MIDescId = zc_MI_Child()
                                                  )
                      -- результат - для zc_MI_Master
                      SELECT tmpMI.MovementItemId
                           , zc_MI_Master()                                          AS MIDescId
                           , 0                                                       AS ContainerId
                           , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                           , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
                      FROM tmpContainer_master AS tmpContainer
                           FULL JOIN tmpMI_master AS tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                                          AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
                     UNION ALL
                      -- результат - для zc_MI_Child
                      SELECT tmpMI.MovementItemId
                           , zc_MI_Child()                                           AS MIDescId
                           , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                           , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                           , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpContainer.Amount_start + tmpContainer.Amount_next, 0) AS Amount_start
                      FROM tmpContainer_child AS tmpContainer
                           FULL JOIN tmpMI_child AS tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
                     ;

/*if inSession = '5'
then
    RAISE EXCEPTION 'Ошибка.<%>  %', (select lfGet_Object_ValueData_sh (max (tmpAll.GoodsKindId)) FROM tmpAll where tmpAll.GoodsId =  536184  )
    , (    select count(*) 
          FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       WHERE tmpAll.MIDescId = zc_MI_Master()
and tmpAll.GoodsId =  536184  );
-- select * from Object where id = 340523  
-- 926389
end if;
*/


       -- добавили в мастер "новые" товары, т.к. по ним нет движения
       INSERT INTO tmpAll (MovementItemId, MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start)
          WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                            FROM Object_InfoMoney_View
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                     AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                            WHERE ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                 OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                 OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна 
                                   )
                                   AND vbIsTushenka = FALSE)

                               OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                   )
                                   AND vbIsTushenka = TRUE)
                           )
          SELECT 0              AS MovementItemId
               , zc_MI_Master() AS MIDescId
               , 0              AS ContainerId
               , Object_GoodsByGoodsKind_View.GoodsId
               , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
               , 0              AS Amount_start
          FROM ObjectBoolean AS ObjectBoolean_Order
               INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
               INNER JOIN tmpGoods ON tmpGoods.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
               LEFT JOIN tmpAll ON tmpAll.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
                               AND tmpAll.GoodsKindId = COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)
          WHERE ObjectBoolean_Order.ValueData = TRUE
            AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
            AND tmpAll.GoodsId IS NULL
            AND vbIsPack  = FALSE -- !!!только для производства!!!
            AND vbIsBasis = FALSE -- !!!только для производства!!!
       ;

/*if inSession = '5'
then
    RAISE EXCEPTION 'Ошибка.<%> ', 
(select lfGet_Object_ValueData_sh ((MovementItem.ObjectId))
FROM MovementItem
     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
where MovementItem.MovementId = inMovementId
group by MovementItem.ObjectId
having count(*) > 1
limit 1
);
end if;*/

       -- сохранили zc_MI_Master
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                    := tmpAll.MovementItemId
                                                 , inMovementId            := inMovementId
                                                 , inGoodsId               := tmpAll.GoodsId
                                                 , inGoodsKindId           := tmpAll.GoodsKindId
                                                 , inAmount_Param          := tmpAll.Amount_start * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param          := zc_MIFloat_AmountRemains()
                                                 , inAmount_ParamOrder     := NULL
                                                 , inDescId_ParamOrder     := NULL
                                                 , inAmount_ParamSecond    := NULL
                                                 , inDescId_ParamSecond    := NULL
                                                 , inAmount_ParamAdd       := 0
                                                 , inDescId_ParamAdd       := 0
                                                 , inAmount_ParamNext      := 0
                                                 , inDescId_ParamNext      := 0
                                                 , inAmount_ParamNextPromo := 0
                                                 , inDescId_ParamNextPromo := 0
                                                 , inIsPack                := CASE WHEN vbIsBasis = FALSE THEN vbIsPack ELSE NULL  END
                                                 , inIsParentMulti         := CASE WHEN vbIsBasis = FALSE THEN TRUE     ELSE FALSE END
                                                 , inUserId                := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       WHERE tmpAll.MIDescId = zc_MI_Master();

       -- сохранили zc_MI_Child
       PERFORM lpInsertUpdate_MI_OrderInternal_Child (ioId                   := tmpAll.MovementItemId
                                                    , inMovementId           := inMovementId
                                                    , inGoodsId              := tmpAll.GoodsId
                                                    , inAmount               := tmpAll.Amount_start
                                                    , inContainerId          := tmpAll.ContainerId :: TFloat
                                                    , inPartionGoodsDate     := ObjectDate_Value.ValueData
                                                    , inGoodsKindId          := CLO_GoodsKind.ObjectId
                                                    , inGoodsKindId_complete := CASE WHEN vbIsPack = TRUE THEN 0 ELSE COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) END
                                                    , inUserId               := vbUserId
                                                     ) 
       FROM tmpAll
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                          ON CLO_GoodsKind.ContainerId = tmpAll.ContainerId
                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                          ON CLO_PartionGoods.ContainerId = tmpAll.ContainerId
                                         AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                 ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()

       WHERE tmpAll.MIDescId = zc_MI_Child()
         AND vbIsBasis = FALSE -- !!!для сырья не надо!!!
      ;


if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Ошибка. end <%>  %   %', (select sum (tmpAll.Amount_start) from tmpAll where tmpAll.GoodsId = 7493 AND tmpAll.MIDescId = zc_MI_Child() AND tmpAll.ContainerId > 0)
    , (select count(*) from tmpAll where tmpAll.GoodsId = 7493 AND tmpAll.MIDescId = zc_MI_Child() AND tmpAll.ContainerId > 0 and tmpAll.Amount_start <> 0)
    , (select sum (tmpAll.Amount_start) from tmpAll where tmpAll.GoodsId = 7493 AND tmpAll.MIDescId = zc_MI_Child() AND tmpAll.ContainerId > 0 and tmpAll.Amount_start < 0)
    ;
end if;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        * расчет, временно захардкодил
 19.06.15                                        *
 13.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountRemains (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
-- select * from gpUpdateMI_OrderInternal_AmountRemains(inMovementId := 4084522 , inOperDate := ('24.07.2016')::TDateTime , inFromId := 8447 , inToId := 8447 ,  inSession := '5');
