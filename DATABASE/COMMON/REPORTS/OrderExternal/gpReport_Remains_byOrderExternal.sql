-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_Remains_byOrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_byOrderExternal(
    IN inMovementId         Integer   , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromCode Integer, FromName TVarChar
             , GoodsCode_Main Integer, GoodsName_Main TVarChar, GoodsKindName_Main  TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName  TVarChar
             , GoodsCode_pack Integer, GoodsName_pack TVarChar, GoodsKindName_pack  TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , PartionGoods          TVarChar
             , PartionGoods_start    TDateTime
             , TermProduction        Integer
             , Amount                TFloat
             , Amount_Prev           TFloat
             , Amount_Next           TFloat
             , Remains_SKLAD         TFloat
             , Remains_CEH           TFloat
             , Remains_CEH_next      TFloat
             , Income_CEH            TFloat
             , Amount_result         TFloat
             , Amount_result_two     TFloat
             , Amount_result_two_two TFloat
             , ReceiptName           TVarChar
             , ReceiptCode           TVarChar
             , ReceiptName_basis     TVarChar
             , ReceiptCode_basis     TVarChar
             , ReceiptName_pack      TVarChar
             , ReceiptCode_pack      TVarChar
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbOperDate        TDateTime;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbFromId          Integer;
BEGIN
     -- определяется
     SELECT Movement.OperDate
          , MovementDate_OperDatePartner.ValueData
          , ObjectLink_Juridical_Retail.ChildObjectId --  берем торг.сеть  вместо покупателя  -MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbOperDatePartner, vbFromId
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId --Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE Movement.Id = inMovementId;

     RETURN QUERY
     WITH
            -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
            tmpUnit_CEH AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Реализации
          , tmpUnit_SKLAD   AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - ВСЕ
          , tmpUnit_all   AS (SELECT UnitId FROM tmpUnit_CEH UNION SELECT UnitId FROM tmpUnit_SKLAD)

            -- данные - наша Заявка
          , tmpMI AS (SELECT vbFromId                                       AS FromId
                            , MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS Amount
                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                      )
             -- Приход пр-во (ФАКТ)
           , tmpIncome AS (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , MIContainer.ObjectExtId_Analyzer               AS FromId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (MIContainer.Amount)                       AS Amount
                           FROM MovementItemContainer AS MIContainer
                                -- ЦЕХ колбаса+дел-сы
                                INNER JOIN tmpUnit_CEH   ON tmpUnit_CEH.UnitId   = MIContainer.ObjectExtId_Analyzer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MIContainer.WhereObjectId_Analyzer
                                -- убрали Тару
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                    , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                             AND MIContainer.isActive       = TRUE
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , MIContainer.ObjectExtId_Analyzer
                          )
      -- поиск рецептур - что из чего делается
    , tmpReceipt_START AS (SELECT tmpGoods.GoodsId, tmpGoods.GoodsKindId
                                  -- нашли Рецепт - Цех (т.е. в приходе ПФ_ГП, в расходе СЫРЬЕ)
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                  END AS ReceiptId_basis

                                  -- нашли Рецепт - какой товар идет На Упаковку (т.е. в приходе ВЕС, в расходе ПФ_ГП)
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       ELSE 0 -- т.е. этот товар НЕ идет через упаковку, или уровней больше чем надо
                                  END AS ReceiptId_pack

                                  -- Главный рецепт - информативно
                                , Object_Receipt.Id AS ReceiptId

                           FROM tmpMI AS tmpGoods
                                -- Рецепт для Товара из заявки, т.е. из чего он делается (как правило это Упаковка)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                     ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                    AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                      ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                                     AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                                     AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpGoods.GoodsKindId
                                INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND Object_Receipt.isErased = FALSE
                                -- Только Главный рецепт
                                INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                         ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                                        AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                                        AND ObjectBoolean_Main.ValueData = TRUE

                                -- Поднялись на 0 уровень - т.е. из чего делается Товар для Упаковки (как правило это уже ВЕС из ПФ_ГП)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                     ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                    AND ObjectLink_Receipt_Parent_0.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                -- Поднялись на 1 уровень - т.е. из чего делается ПФ_ГП (как правило это ЦЕХ и делается из СЫРЬЯ)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                     ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_1.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                -- Поднялись на 2 уровень - т.е. если предыдущий это НЕ Цех
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                     ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_2.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                -- Поднялись на 3 уровень - т.е. если предыдущий это НЕ Цех
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                     ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_3.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                          )
      -- здесь уже товары - что из чего делается
    , tmpGoodsBasis_START AS (SELECT tmpReceipt.GoodsId
                                   , tmpReceipt.GoodsKindId
                                   , tmpReceipt.ReceiptId

                                   , tmpReceipt.ReceiptId_basis                 AS ReceiptId_basis
                                   , ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId_Basis
                                   , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId_Basis

                                   , tmpReceipt.ReceiptId_pack                       AS ReceiptId_pack
                                   , ObjectLink_Receipt_Goods_pack.ChildObjectId     AS GoodsId_pack
                                   , ObjectLink_Receipt_GoodsKind_pack.ChildObjectId AS GoodsKindId_pack
                              FROM tmpReceipt_START AS tmpReceipt
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ObjectId = tmpReceipt.ReceiptId_basis
                                                       AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = tmpReceipt.ReceiptId_basis
                                                       AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_pack
                                                        ON ObjectLink_Receipt_Goods_pack.ObjectId = tmpReceipt.ReceiptId_pack
                                                       AND ObjectLink_Receipt_Goods_pack.DescId   = zc_ObjectLink_Receipt_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_pack
                                                        ON ObjectLink_Receipt_GoodsKind_pack.ObjectId = tmpReceipt.ReceiptId_pack
                                                       AND ObjectLink_Receipt_GoodsKind_pack.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                             )
       -- поиск рецептур - что из чего делается
     , tmpReceipt_NEXT AS (SELECT tmpGoods.GoodsId, ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId
                                  -- нашли Рецепт - Цех (т.е. в приходе ПФ_ГП, в расходе СЫРЬЕ)
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                  END AS ReceiptId_basis

                                  -- нашли Рецепт - какой товар идет На Упаковку (т.е. в приходе ВЕС, в расходе ПФ_ГП)
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       ELSE 0 -- т.е. этот товар НЕ идет через упаковку, или уровней больше чем надо
                                  END AS ReceiptId_pack

                                  -- Главный рецепт - информативно
                                , Object_Receipt.Id AS ReceiptId

                           FROM (SELECT DISTINCT tmpGoodsBasis_START.GoodsId_Basis AS GoodsId FROM tmpGoodsBasis_START
                                UNION
                                 SELECT DISTINCT tmpGoodsBasis_START.GoodsId_pack  AS GoodsId FROM tmpGoodsBasis_START
                                UNION
                                 SELECT DISTINCT tmpGoodsBasis_START.GoodsId       AS GoodsId FROM tmpGoodsBasis_START
                                ) AS tmpGoods
                                -- Рецепт для Товара из заявки, т.е. из чего он делается (как правило это Упаковка)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                     ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                    AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                      ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                                     AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                                     AND ObjectLink_Receipt_GoodsKind.ChildObjectId <> zc_GoodsKind_WorkProgress()
                                INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND Object_Receipt.isErased = FALSE
                                -- Только Главный рецепт
                                INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                         ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                                        AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                                        AND ObjectBoolean_Main.ValueData = TRUE

                                -- Поднялись на 0 уровень - т.е. из чего делается Товар для Упаковки (как правило это уже ВЕС из ПФ_ГП)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                     ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                    AND ObjectLink_Receipt_Parent_0.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                -- Поднялись на 1 уровень - т.е. из чего делается ПФ_ГП (как правило это ЦЕХ и делается из СЫРЬЯ)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                     ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_1.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                -- Поднялись на 2 уровень - т.е. если предыдущий это НЕ Цех
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                     ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_2.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                -- Поднялись на 3 уровень - т.е. если предыдущий это НЕ Цех
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                     ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_3.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                          )
            -- здесь уже товары - что из чего делается
          , tmpGoodsBasis AS (SELECT tmpGoodsBasis_START.GoodsId
                                   , tmpGoodsBasis_START.GoodsKindId
                                   , tmpGoodsBasis_START.ReceiptId

                                   , tmpGoodsBasis_START.ReceiptId_basis
                                   , tmpGoodsBasis_START.GoodsId_Basis
                                   , tmpGoodsBasis_START.GoodsKindId_Basis

                                   , tmpGoodsBasis_START.ReceiptId_pack
                                   , tmpGoodsBasis_START.GoodsId_pack
                                   , tmpGoodsBasis_START.GoodsKindId_pack
                              FROM tmpGoodsBasis_START
                             UNION
                              SELECT tmpReceipt.GoodsId
                                   , tmpReceipt.GoodsKindId
                                   , tmpReceipt.ReceiptId

                                   , tmpReceipt.ReceiptId_basis                 AS ReceiptId_basis
                                   , ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId_Basis
                                   , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId_Basis

                                   , tmpReceipt.ReceiptId_pack                       AS ReceiptId_pack
                                   , ObjectLink_Receipt_Goods_pack.ChildObjectId     AS GoodsId_pack
                                   , ObjectLink_Receipt_GoodsKind_pack.ChildObjectId AS GoodsKindId_pack
                              FROM tmpReceipt_NEXT AS tmpReceipt
                                   LEFT JOIN tmpGoodsBasis_START ON tmpGoodsBasis_START.GoodsId     = tmpReceipt.GoodsId
                                                                AND tmpGoodsBasis_START.GoodsKindId = tmpReceipt.GoodsKindId
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ObjectId = tmpReceipt.ReceiptId_basis
                                                       AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = tmpReceipt.ReceiptId_basis
                                                       AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_pack
                                                        ON ObjectLink_Receipt_Goods_pack.ObjectId = tmpReceipt.ReceiptId_pack
                                                       AND ObjectLink_Receipt_Goods_pack.DescId   = zc_ObjectLink_Receipt_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_pack
                                                        ON ObjectLink_Receipt_GoodsKind_pack.ObjectId = tmpReceipt.ReceiptId_pack
                                                       AND ObjectLink_Receipt_GoodsKind_pack.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                              WHERE tmpGoodsBasis_START.GoodsId IS NULL
                             )
            -- список товаров - по ним получим Остатки на Складе + в Цехе
          , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId               AS GoodsId FROM tmpMI
                        UNION
                         SELECT DISTINCT tmpGoodsBasis.GoodsId_Basis AS GoodsId FROM tmpGoodsBasis
                        UNION
                         SELECT DISTINCT tmpGoodsBasis.GoodsId_pack  AS GoodsId FROM tmpGoodsBasis
                         )
            -- остатки на НАЧАЛО ДНЯ - на Складе + в Цехе
          , tmpRemains_All AS (SELECT Container.Id         AS ContainerId
                                    , CLO_Unit.ObjectId    AS UnitId
                                    , tmpGoods.GoodsId     AS GoodsId
                                    , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
--                                    , Container.Amount      AS Amount
                                    , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                               FROM tmpGoods
                                    INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                        AND Container.DescId   = zc_Container_Count()
                                                        -- AND Container.Amount <> 0
                                    INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                   ON CLO_Unit.ContainerId = Container.Id
                                                                  AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                    INNER JOIN tmpUnit_all ON tmpUnit_all.UnitId = CLO_Unit.ObjectId

                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= vbOperDate

                                    LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                  ON CLO_GoodsKind.ContainerId = Container.Id
                                                                 AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                    LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                  ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                               WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                               GROUP BY Container.Id
                                      , CLO_Unit.ObjectId
                                      , tmpGoods.GoodsId
                                      , CLO_GoodsKind.ObjectId
                                      , Container.Amount
                               HAVING  Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                              )

            -- остатки на НАЧАЛО ДНЯ - в Цехе
          , tmpRemains_CEH AS (SELECT tmpRemains_All.GoodsId
                                    , tmpRemains_All.GoodsKindId
                                    , tmpRemains_All.UnitId   AS FromId
                                    , COALESCE (ContainerLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                    , vbOperDatePartner - (COALESCE (ObjectFloat_TermProduction.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL AS PartionGoods_start
                                    , COALESCE (ObjectFloat_TermProduction.ValueData, 0) AS TermProduction
                                    , SUM (CASE WHEN ObjectFloat_TaxExit.ValueData > 0 AND ObjectFloat_Value.ValueData > 0 AND COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbOperDatePartner - (COALESCE (ObjectFloat_TermProduction.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                THEN tmpRemains_All.Amount * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData
                                                WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbOperDatePartner - (COALESCE (ObjectFloat_TermProduction.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                THEN -0.1234
                                                ELSE 0
                                           END) AS Amount
                                    , SUM (CASE WHEN ObjectFloat_TaxExit.ValueData > 0 AND ObjectFloat_Value.ValueData > 0 AND COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) > vbOperDatePartner - (COALESCE (ObjectFloat_TermProduction.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                THEN tmpRemains_All.Amount * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData
                                                WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) > vbOperDatePartner - (COALESCE (ObjectFloat_TermProduction.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL
                                                THEN -0.1234
                                                ELSE 0
                                           END) AS Amount_Next
                               FROM tmpRemains_All
                                    INNER JOIN tmpUnit_CEH  ON tmpUnit_CEH.UnitId = tmpRemains_All.UnitId
                                    LEFT JOIN (SELECT tmpGoodsBasis.GoodsId_Basis, MAX (tmpGoodsBasis.ReceiptId_basis) AS ReceiptId FROM tmpGoodsBasis GROUP BY tmpGoodsBasis.GoodsId_Basis
                                              ) AS tmpReceipt ON tmpReceipt.GoodsId_Basis = tmpRemains_All.GoodsId
                                    LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                                          ON ObjectFloat_TaxExit.ObjectId = tmpReceipt.ReceiptId
                                                         AND ObjectFloat_TaxExit.DescId   = zc_ObjectFloat_Receipt_TaxExit()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = tmpReceipt.ReceiptId
                                                         AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()

                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                  ON ContainerLO_PartionGoods.ContainerId = tmpRemains_All.ContainerId
                                                                 AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                    LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                                                         ON ObjectDate_PartionGoods.ObjectId = ContainerLO_PartionGoods.ObjectId
                                                        AND ObjectDate_PartionGoods.DescId   = zc_ObjectDate_PartionGoods_Value()
                                    LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                         ON ObjectLink_OrderType_Goods.ChildObjectId = tmpRemains_All.GoodsId
                                                        AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                                          ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                         AND ObjectFloat_TermProduction.DescId   = zc_ObjectFloat_OrderType_TermProduction()
                               WHERE tmpRemains_All.Amount > 0
                               GROUP BY tmpRemains_All.GoodsId
                                      , tmpRemains_All.GoodsKindId
                                      , tmpRemains_All.UnitId
                                      , COALESCE (ContainerLO_PartionGoods.ObjectId, 0)
                                      , ObjectFloat_TermProduction.ValueData
                              )
            -- остатки на НАЧАЛО ДНЯ - на Складе
          , tmpRemains_SKLAD AS (SELECT tmpRemains_All.GoodsId
                                      , tmpRemains_All.GoodsKindId
                                      , tmpRemains_All.UnitId       AS FromId
                                      , SUM (tmpRemains_All.Amount) AS Amount
                                 FROM tmpRemains_All
                                      INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = tmpRemains_All.UnitId
                                      -- INNER JOIN tmpMI ON tmpMI.GoodsId      = tmpRemains_All.GoodsId
                                      --                 AND tmpMI.GoodsKindId  = tmpRemains_All.GoodsKindId
                                 GROUP BY tmpRemains_All.GoodsId
                                        , tmpRemains_All.GoodsKindId
                                        , tmpRemains_All.UnitId
                                )
            -- ВСЕ Заявки от Покупателя - только Документы
          , tmpOrderExternal AS (SELECT MovementLinkObject_From.ObjectId    AS FromId
                                      /*, CASE WHEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) < vbOperDate
                                              AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) = Movement.OperDate
                                                  THEN NULL
                                             ELSE Movement.Id
                                        END AS MovementId*/
                                      , CASE WHEN MovementDate_OperDatePartner.ValueData < vbOperDate THEN NULL ELSE Movement.Id END AS MovementId
                                      , Movement.OperDate
                                      , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                                 FROM Movement
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                                   AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                      INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MovementLinkObject_To.ObjectId
                                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                            AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                 WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '8 DAY' AND vbOperDate + INTERVAL '0 DAY'
                                   AND MovementDate_OperDatePartner.ValueData >= vbOperDate
                                   AND Movement.DescId   = zc_Movement_OrderExternal()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.Id       <> inMovementId
                                )
            -- ВСЕ Заявки от Покупателя - Товары
          , tmpOrderExternal_MI AS (SELECT Movement.FromId         AS FromId
                                         , Movement.OperDate       AS OperDate
                                         , Movement.OperDate       AS OperDatePartner
                                         -- , MovementItem.Id         AS MovementItemId
                                         , MovementItem.ObjectId   AS GoodsId
                                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                         , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS Amount

                                    FROM tmpOrderExternal AS Movement
                                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.MovementId
                                                                AND MovementItem.DescId     = zc_MI_Master()
                                                                AND MovementItem.isErased   = FALSE
                                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                         LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                     ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                   )

          /*, tmpGoodsKind AS (SELECT MILinkObject_GoodsKind.*
                             FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                             WHERE MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpOrderExternal_MI.MovementItemId FROM tmpOrderExternal_MI)
                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             )

          , tmpMIFloat_AmountSecond AS (SELECT MIFloat_AmountSecond.*
                             FROM MovementItemFloat AS MIFloat_AmountSecond
                             WHERE MIFloat_AmountSecond.MovementItemId IN (SELECT DISTINCT tmpOrderExternal_MI.MovementItemId FROM tmpOrderExternal_MI)
                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                             )*/

            -- ВСЕ Заявки от Покупателя - собрали по 2-м периодам
          , tmpOrderExternal_Its AS (SELECT Movement.FromId                               AS FromId
                                          , Movement.GoodsId                              AS GoodsId
                                          , Movement.GoodsKindId                          AS GoodsKindId
                                          , SUM (CASE WHEN Movement.OperDate <  vbOperDate THEN Movement.Amount ELSE 0 END) AS Amount_Prev
                                          , SUM (CASE WHEN Movement.OperDate >= vbOperDate THEN Movement.Amount ELSE 0 END) AS Amount_Next
                                          -- , SUM (CASE WHEN Movement.OperDate = vbOperDate - INTERVAL '1 DAY' AND Movement.OperDate <> Movement.OperDatePartner THEN Movement.Amount ELSE 0 END) AS Amount_Prev
                                          -- , SUM (CASE WHEN Movement.OperDate = vbOperDate - INTERVAL '1 DAY' AND Movement.OperDate <> Movement.OperDatePartner THEN 0 ELSE Movement.Amount END) AS Amount_Next
                                          -- , SUM (CASE WHEN Movement.OperDate < vbOperDate AND Movement.OperDatePartner = vbOperDate THEN Movement.Amount ELSE 0 END) AS Amount_Prev
                                          -- , SUM (CASE WHEN Movement.OperDate >= vbOperDate OR Movement.OperDatePartner > vbOperDate THEN Movement.Amount ELSE 0 END)                   AS Amount_Next
                                     FROM tmpOrderExternal_MI AS Movement
                                           /*INNER JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (Movement.GoodsKindId, 0)
                                           LEFT JOIN tmpMIFloat_AmountSecond AS MIFloat_AmountSecond
                                                                             ON MIFloat_AmountSecond.MovementItemId = Movement.MovementItemId*/
                                     GROUP BY Movement.FromId
                                            , Movement.GoodsId
                                            , Movement.GoodsKindId
                                    )
            -- ВСЯ ИНФА
          , tmpData AS (SELECT tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.FromId
                             , tmp.PartionGoods
                             , tmp.PartionGoods_start
                             , tmp.TermProduction
                             , SUM (tmp.Amount)             AS Amount
                             , SUM (tmp.Amount_Prev)        AS Amount_Prev
                             , SUM (tmp.Amount_Next)        AS Amount_Next
                             , SUM (tmp.Remains_SKLAD)      AS Remains_SKLAD
                             , SUM (tmp.Remains_CEH)        AS Remains_CEH
                             , SUM (tmp.Remains_CEH_Next)   AS Remains_CEH_Next

                        FROM (-- Текущая заявка
                              SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , tmp.FromId          AS FromId
                                   , tmp.Amount          AS Amount
                                   , 0                   AS Amount_Prev
                                   , 0                   AS Amount_Next
                                   , 0                   AS Remains_SKLAD
                                   , 0                   AS Remains_CEH
                                   , 0                   AS Remains_CEH_Next
                                   , ''                  AS PartionGoods
                                   , NULL :: Integer     AS TermProduction
                                   , NULL :: TDateTime   AS PartionGoods_start
                              FROM tmpMI AS tmp
                            UNION
                              -- ВСе заявки
                              SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , tmp.FromId          AS FromId
                                   , 0                   AS Amount
                                   , tmp.Amount_Prev     AS Amount_Prev
                                   , tmp.Amount_Next     AS Amount_Next
                                   , 0                   AS Remains_SKLAD
                                   , 0                   AS Remains_CEH
                                   , 0                   AS Remains_CEH_Next
                                   , ''                  AS PartionGoods
                                   , NULL :: Integer     AS TermProduction
                                   , NULL :: TDateTime   AS PartionGoods_start
                              FROM tmpOrderExternal_Its AS tmp
                            UNION
                              -- Остаток - Склад
                              SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , tmp.FromId          AS FromId
                                   , 0                   AS Amount
                                   , 0                   AS Amount_Prev
                                   , 0                   AS Amount_Next
                                   , tmp.Amount          AS Remains_SKLAD
                                   , 0                   AS Remains_CEH
                                   , 0                   AS Remains_CEH_Next
                                   , ''                  AS PartionGoods
                                   , NULL :: Integer     AS TermProduction
                                   , NULL :: TDateTime   AS PartionGoods_start
                              FROM tmpRemains_SKLAD AS tmp
                            UNION
                              -- Остаток - Цех
                              SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , tmp.FromId          AS FromId
                                   , 0                   AS Amount
                                   , 0                   AS Amount_Prev
                                   , 0                   AS Amount_Next
                                   , 0                   AS Remains_SKLAD
                                   , tmp.Amount          AS Remains_CEH
                                   , tmp.Amount_Next     AS Remains_CEH_Next
                                   , Object_PartionGoods.ValueData AS PartionGoods
                                   , tmp.TermProduction     AS TermProduction
                                   , tmp.PartionGoods_start AS PartionGoods_start
                              FROM tmpRemains_CEH AS tmp
                                   LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmp.PartionGoodsId
                            UNION
                              -- tmpIncome - Цех
                              SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , tmp.FromId          AS FromId
                                   , 0                   AS Amount
                                   , 0                   AS Amount_Prev
                                   , 0                   AS Amount_Next
                                   , 0                   AS Remains_SKLAD
                                   , 0                   AS Remains_CEH
                                   , 0                   AS Remains_CEH_Next
                                   , ''                  AS PartionGoods
                                   , NULL :: Integer     AS TermProduction
                                   , NULL :: TDateTime   AS PartionGoods_start
                              FROM tmpIncome AS tmp
                              ) AS tmp
                        GROUP BY tmp.GoodsId
                               , tmp.GoodsKindId
                               , tmp.FromId
                               , tmp.PartionGoods
                               , tmp.PartionGoods_start
                               , tmp.TermProduction
                       )
        -- нашли покупателям - Торговую сеть (покупателям), иначе оставим FromId
      , tmpRetail AS (SELECT tmpData.FromId
                           , CASE WHEN tmpData.FromId = vbFromId
                                       THEN vbFromId
                                  WHEN Object.DescId = zc_Object_Partner() AND ObjectLink_Juridical_Retail.ChildObjectId = vbFromId
                                       THEN vbFromId
                                  WHEN Object.DescId = zc_Object_Partner()
                                       THEN 0
                                  WHEN tmpUnit_all.UnitId IS NULL
                                       THEN -1
                                  ELSE tmpData.FromId
                             END AS RetailId
                      FROM (SELECT DISTINCT tmpData.FromId FROM tmpData) AS tmpData
                           LEFT JOIN tmpUnit_all ON tmpUnit_all.UnitId = tmpData.FromId
                           LEFT JOIN Object      ON Object.Id          = tmpData.FromId
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = tmpData.FromId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                      )
        -- сгруппировали по RetailId
      , tmpData_Retail AS (SELECT tmpRetail.RetailId                AS FromId
                                , tmpData.GoodsId                   AS GoodsId
                                , tmpData.GoodsKindId               AS GoodsKindId
                                , tmpData.PartionGoods              AS PartionGoods
                                , tmpData.PartionGoods_start        AS PartionGoods_start
                                , tmpData.TermProduction            AS TermProduction
                                , SUM (tmpData.Amount)              AS Amount
                                , SUM (tmpData.Amount_Prev)         AS Amount_Prev
                                , SUM (tmpData.Amount_Next)         AS Amount_Next
                                , SUM (tmpData.Remains_SKLAD)       AS Remains_SKLAD
                                , SUM (tmpData.Remains_CEH)         AS Remains_CEH
                                , SUM (tmpData.Remains_CEH_next)    AS Remains_CEH_next
                           FROM tmpData
                                LEFT JOIN tmpRetail ON tmpRetail.FromId = tmpData.FromId
                           GROUP By tmpRetail.RetailId
                                  , tmpData.GoodsId
                                  , tmpData.GoodsKindId
                                  , tmpData.PartionGoods
                                  , tmpData.PartionGoods_start
                                  , tmpData.TermProduction
                           )

       -- Результат
       SELECT Object_From.ObjectCode                     AS FromCode
            , CASE WHEN tmpData.FromId = -1 THEN 'ФИЛИАЛ' ELSE COALESCE (Object_From.ValueData, 'ДРУГАЯ Сеть') END :: TVarChar AS FromName

            , COALESCE (Object_Goods_basis.ObjectCode,    Object_Goods.ObjectCode)    :: Integer  AS GoodsCode_Main
            , COALESCE (Object_Goods_basis.ValueData,     Object_Goods.ValueData)     :: TVarChar AS GoodsName_Main
            , COALESCE (Object_GoodsKind_basis.ValueData, Object_GoodsKind.ValueData) :: TVarChar AS GoodsKindName_Main

            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , Object_GoodsKind.ValueData                 AS GoodsKindName

            , Object_Goods_pack.ObjectCode               AS GoodsCode_pack
            , Object_Goods_pack.ValueData                AS GoodsName_pack
            , Object_GoodsKind_pack.ValueData            AS GoodsKindName_pack

            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsGroup.ValueData                AS GoodsGroupName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

            , tmpData.PartionGoods          :: TVarChar  AS PartionGoods
            , tmpData.PartionGoods_start    :: TDateTime AS PartionGoods_start
            , tmpData.TermProduction        :: Integer   AS TermProduction

            , CAST (tmpData.Amount           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Amount
            , CAST (tmpData.Amount_Prev      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Amount_Prev
            , CAST (tmpData.Amount_Next      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Amount_Next
            , CAST (tmpData.Remains_SKLAD    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Remains_SKLAD
            , CAST (tmpData.Remains_CEH      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Remains_CEH
            , CAST (tmpData.Remains_CEH_next * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Remains_CEH_next
            , CAST (tmpIncome.Amount         * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Income_CEH

            , CAST ((tmpData.Remains_SKLAD + tmpData.Remains_CEH            - tmpData.Amount - tmpData.Amount_Prev - tmpData.Amount_Next)
                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Amount_result
            , CAST ((tmpData.Remains_SKLAD + 0                              - tmpData.Amount - tmpData.Amount_Prev - tmpData.Amount_Next)
                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Amount_result_two
            , CAST ((tmpData.Remains_SKLAD + COALESCE (tmpIncome.Amount, 0) - tmpData.Amount - tmpData.Amount_Prev - tmpData.Amount_Next)
                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 0)) :: TFloat AS Amount_result_two_two

            , Object_Receipt.ValueData           AS ReceiptName
            , ObjectString_Code.ValueData        AS ReceiptCode
            , Object_Receipt_basis.ValueData     AS ReceiptName_basis
            , ObjectString_Code_basis.ValueData  AS ReceiptCode_basis
            , Object_Receipt_pack.ValueData      AS ReceiptName_pack
            , ObjectString_Code_pack.ValueData   AS ReceiptCode_pack

       FROM tmpData_Retail AS tmpData

            LEFT JOIN Object AS Object_From      ON Object_From.Id      = tmpData.FromId
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
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

            -- здесь уже товары - что из чего делается
            LEFT JOIN tmpGoodsBasis ON tmpGoodsBasis.GoodsId     = tmpData.GoodsId
                                   AND tmpGoodsBasis.GoodsKindId = tmpData.GoodsKindId
            -- здесь уже товары - что из чего делается
            LEFT JOIN tmpIncome ON tmpIncome.GoodsId     = tmpData.GoodsId
                               AND tmpIncome.GoodsKindId = tmpData.GoodsKindId
                               AND tmpIncome.FromId      = tmpData.FromId

            LEFT JOIN Object AS Object_Goods_basis     ON Object_Goods_basis.Id     = tmpGoodsBasis.GoodsId_Basis
            LEFT JOIN Object AS Object_GoodsKind_basis ON Object_GoodsKind_basis.Id = tmpGoodsBasis.GoodsKindId_Basis

            LEFT JOIN Object AS Object_Goods_pack     ON Object_Goods_pack.Id     = tmpGoodsBasis.GoodsId_pack
            LEFT JOIN Object AS Object_GoodsKind_pack ON Object_GoodsKind_pack.Id = tmpGoodsBasis.GoodsKindId_pack

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpGoodsBasis.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = tmpGoodsBasis.ReceiptId
                                  AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpGoodsBasis.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Code_basis
                                   ON ObjectString_Code_basis.ObjectId = tmpGoodsBasis.ReceiptId_basis
                                  AND ObjectString_Code_basis.DescId = zc_ObjectString_Receipt_Code()
  
            LEFT JOIN Object AS Object_Receipt_pack ON Object_Receipt_pack.Id = tmpGoodsBasis.ReceiptId_pack
            LEFT JOIN ObjectString AS ObjectString_Code_pack
                                   ON ObjectString_Code_pack.ObjectId = tmpGoodsBasis.ReceiptId_pack
                                  AND ObjectString_Code_pack.DescId = zc_ObjectString_Receipt_Code()
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.17         *
*/

-- тест
-- SELECT * FROM gpReport_Remains_byOrderExternal (inMovementId:= 7296373, inSession:= zfCalc_UserAdmin())
