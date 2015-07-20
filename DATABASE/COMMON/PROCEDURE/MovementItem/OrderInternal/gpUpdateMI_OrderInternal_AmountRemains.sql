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

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- пересчет Рецептур, временно захардкодил
    PERFORM lpUpdate_Object_Receipt_Total (Object.Id, zfCalc_UserAdmin() :: Integer) FROM Object WHERE DescId = zc_Object_Receipt();
    -- пересчет Рецептур, временно захардкодил
    PERFORM lpUpdate_Object_Receipt_Parent (0, 0, 0);

    -- расчет, временно захардкодил
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- Цех Упаковки
    -- расчет, временно захардкодил
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp)); -- ЦЕХ колбаса+дел-сы


    -- таблица
    CREATE TEMP TABLE tmpContainer_Count (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, Amount_next TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;
    
    --
    -- Список партий кол-во для всех подразделений (группа "От кого" + группа "Кому")
    INSERT INTO tmpContainer_Count (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount)
                                 WITH tmpUnit AS (SELECT UnitId, zc_MI_Master() AS MIDescId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup
                                                 UNION
                                                  SELECT UnitId, zc_MI_Child() AS MIDescId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup WHERE UnitId <> inToId)
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE ((Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция + Готовая продукция and Тушенка and Хлеб
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Продукция + запечена...
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = FALSE)
                                                   OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = TRUE AND vbIsBasis = FALSE)
                                                   OR ((Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                                        -- OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Незавершенное производство
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = TRUE)
                                                  )
                                SELECT tmpUnit.MIDescId
                                     , Container.Id                         AS ContainerId
                                     , Container.ObjectId                   AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , Container.Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId

                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind();

       --
       -- Остатки кол-во для всех подразделений
       INSERT INTO tmpContainer (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start, Amount_next)
                                  SELECT 
                                           tmpContainer_Count.MIDescId
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
                         , tmpMI_master AS (SELECT MovementItemId, MIDescId, GoodsId, GoodsKindId, Amount, ContainerId FROM tmpMI WHERE MIDescId = zc_MI_Master())
                         , tmpMI_child AS (SELECT MovementItemId, MIDescId, GoodsId, GoodsKindId, Amount, ContainerId FROM tmpMI WHERE MIDescId = zc_MI_Child())
                         , tmpContainer_master AS (-- остатки для zc_MI_Master - группируются
                                                   SELECT tmpContainer.GoodsId
                                                        , tmpContainer.GoodsKindId
                                                        , SUM (tmpContainer.Amount_start) AS Amount_start
                                                   FROM tmpContainer
                                                   WHERE tmpContainer.MIDescId = zc_MI_Master()
                                                   GROUP BY tmpContainer.GoodsId
                                                          , tmpContainer.GoodsKindId
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


       -- добавили в мастер "новые" товары, т.к. по ним нет движения
       INSERT INTO tmpAll (MovementItemId, MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start)
          WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                            FROM Object_InfoMoney_View
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                     AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                            WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция + Готовая продукция and Тушенка and Хлеб
                               OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна 
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


       -- сохранили zc_MI_Master
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.Amount_start * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountRemains()
                                                 , inAmount_ParamOrder  := NULL
                                                 , inDescId_ParamOrder  := NULL
                                                 , inIsPack             := CASE WHEN vbIsBasis = FALSE
                                                                                     THEN vbIsPack
                                                                                ELSE NULL
                                                                           END
                                                 , inUserId             := vbUserId
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
