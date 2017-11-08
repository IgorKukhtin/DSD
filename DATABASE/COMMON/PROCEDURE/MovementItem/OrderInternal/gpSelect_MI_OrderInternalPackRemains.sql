-- Function: gpSelect_MI_OrderInternalPackRemains()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPackRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId   Integer;
   DECLARE vbToId     Integer;
   DECLARE vbDayCount Integer;
   DECLARE vbMonth    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbDayCount, vbMonth, vbFromId, vbToId
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


     --
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, ContainerId Integer
                                    , ReceiptId Integer, GoodsId Integer, GoodsKindId Integer, MeasureId Integer
                                    , GoodsId_complete Integer, GoodsKindId_complete Integer
                                    , ReceiptId_basis Integer, GoodsId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat
                                    , AmountRemains TFloat, Remains_CEH TFloat, Remains_CEH_Next TFloat, Remains TFloat, Remains_pack TFloat
                                    , AmountPartnerPrior TFloat, AmountPartnerPriorPromo TFloat, AmountPartner TFloat, AmountPartnerPromo TFloat
                                    , AmountForecast TFloat, AmountForecastPromo TFloat, AmountForecastOrder TFloat, AmountForecastOrderPromo TFloat
                                    , CountForecast TFloat, CountForecastOrder TFloat
                                    , Income_CEH TFloat, Income_PACK TFloat
                                    , TermProduction TFloat, PartionGoods_start TDateTime, PartionDate_pf TDateTime, GoodsKindId_pf Integer, GoodsKindCompleteId_pf Integer, UnitId_pf Integer
                                    , isErased Boolean
                                     ) ON COMMIT DROP;
     -- Сохранили
        WITH tmpMI AS (SELECT MovementItem.Id                                       AS MovementItemId
                            , COALESCE (MIFloat_ContainerId.ValueData, 0)           AS ContainerId

                            , COALESCE (MILinkObject_Receipt.ObjectId, 0)           AS ReceiptId
                            , MovementItem.ObjectId                                 AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                            , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0)  AS MeasureId


                            , COALESCE (MILinkObject_GoodsComplete.ObjectId, 0)     AS GoodsId_complete
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete

                            , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis
                            , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis

                            , MovementItem.Amount                                   AS Amount
                            , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                              -- Ост.
                            , CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                   THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                   ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                              END AS AmountRemains
                              -- Ост. начальн. - произв.
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0
                                    AND ObjectFloat_TaxExit.ValueData > 0 AND ObjectFloat_Value.ValueData > 0 AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: Integer :: TVarChar || ' DAY') :: INTERVAL
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_CEH
                              -- Ост. начальн. - произв.
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0
                                    AND ObjectFloat_TaxExit.ValueData > 0 AND ObjectFloat_Value.ValueData > 0 AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: Integer :: TVarChar || ' DAY') :: INTERVAL
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_CEH_Next
                              -- Ост. нач. - НЕ упакованный
                            , CASE WHEN COALESCE (MILinkObject_GoodsComplete.ObjectId, 0) = 0 AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains
                              -- Ост. нач. - упакованный
                            , CASE WHEN NOT (COALESCE (MILinkObject_GoodsComplete.ObjectId, 0) = 0 OR COALESCE (MIFloat_ContainerId.ValueData, 0) > 0)
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_pack

                            , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)         * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPrior
                            , COALESCE (MIFloat_AmountPartnerPriorPromo.ValueData, 0)    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPriorPromo
                            , COALESCE (MIFloat_AmountPartner.ValueData, 0)              * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartner
                            , COALESCE (MIFloat_AmountPartnerPromo.ValueData, 0)         * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPromo

                            , COALESCE (MIFloat_AmountForecast.ValueData, 0)             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecast
                            , COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecastPromo
                            , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecastOrder
                            , COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecastOrderPromo

                            , CASE WHEN vbDayCount <> 0 THEN COALESCE (MIFloat_AmountForecast.ValueData, 0)      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbDayCount ELSE 0 END AS CountForecast
                            , CASE WHEN vbDayCount <> 0 THEN COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbDayCount ELSE 0 END AS CountForecastOrder

                            , COALESCE (MIFloat_TermProduction.ValueData, 0)  AS TermProduction
                            , vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: INteger :: TVarChar || ' DAY') :: INTERVAL AS PartionGoods_start
                            , ObjectDate_Value.ValueData                      AS PartionDate_pf
                            , CLO_GoodsKind.ObjectId                          AS GoodsKindId_pf
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0 THEN COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) END AS GoodsKindCompleteId_pf
                            , CLO_Unit.ObjectId                               AS UnitId_pf

                            , MovementItem.isErased                                 AS isErased

                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                AND  = Object_InfoMoney_View.InfoMoneyId

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()
                            LEFT JOIN MovementItemFloat AS MIFloat_TermProduction
                                                        ON MIFloat_TermProduction.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TermProduction.DescId         = zc_MIFloat_TermProduction()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                        ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPrior.DescId         = zc_MIFloat_AmountPartnerPrior()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                        ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecast.DescId         = zc_MIFloat_AmountForecast()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                        ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecastOrder.DescId         = zc_MIFloat_AmountForecastOrder()
                            --
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPromo
                                                        ON MIFloat_AmountPartnerPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPromo.DescId         = zc_MIFloat_AmountPartnerPromo()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPriorPromo
                                                        ON MIFloat_AmountPartnerPriorPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPriorPromo.DescId         = zc_MIFloat_AmountPartnerPriorPromo()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                                        ON MIFloat_AmountForecastPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecastPromo.DescId         = zc_MIFloat_AmountForecastPromo()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                                        ON MIFloat_AmountForecastOrderPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecastOrderPromo.DescId         = zc_MIFloat_AmountForecastOrderPromo()
                            --
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                             ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                             ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                             ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Receipt.DescId         = zc_MILinkObject_Receipt()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                             ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_ReceiptBasis.DescId         = zc_MILinkObject_ReceiptBasis()

                            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                                  ON ObjectFloat_TaxExit.ObjectId = MILinkObject_Receipt.ObjectId
                                                 AND ObjectFloat_TaxExit.DescId   = zc_ObjectFloat_Receipt_TaxExit()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = MILinkObject_Receipt.ObjectId
                                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()

                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

                            LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                          ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                            LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                    AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                 ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                                AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                      )
             -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
           , tmpUnit_CEH   AS (SELECT UnitId, TRUE AS isContainer FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
             -- хардкодим - Склады База + Реализации
           , tmpUnit_SKLAD AS (SELECT UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
             -- хардкодим - Цех Упаковки
           , tmpUnit_PACK  AS (SELECT 8451 AS UnitId)
             -- Приход - с Цеха Упаковки
           , tmpPACK AS (SELECT MIContainer.ObjectId_Analyzer                    AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , -1 * SUM (MIContainer.Amount)                  AS Amount
                                , MIContainer.WhereObjectId_Analyzer             AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD   ON tmpUnit_SKLAD.UnitId   = MIContainer.ObjectExtId_Analyzer
                                -- Цех Упаковки
                                INNER JOIN tmpUnit_PACK ON tmpUnit_PACK.UnitId = MIContainer.WhereObjectId_Analyzer
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
                             AND MIContainer.MovementDescId = zc_Movement_Send()
                             -- AND 1=0
                             AND MIContainer.isActive       = FALSE
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , MIContainer.WhereObjectId_Analyzer
                          )
             -- Приход пр-во (ФАКТ)
           , tmpIncome AS (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (MIContainer.Amount)                       AS Amount
                                , MIContainer.ObjectExtId_Analyzer               AS UnitId_pf
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
                             -- AND 1=0
                             AND MIContainer.isActive       = TRUE
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , MIContainer.ObjectExtId_Analyzer
                          )
     -- Результат
     INSERT INTO _tmpMI_master (MovementItemId, ContainerId
                              , ReceiptId, GoodsId, GoodsKindId, MeasureId
                              , GoodsId_complete, GoodsKindId_complete
                              , ReceiptId_basis, GoodsId_basis
                              , Amount, AmountSecond
                              , AmountRemains, Remains_CEH, Remains_CEH_Next, Remains, Remains_pack
                              , AmountPartnerPrior, AmountPartnerPriorPromo, AmountPartner, AmountPartnerPromo
                              , AmountForecast, AmountForecastPromo, AmountForecastOrder, AmountForecastOrderPromo
                              , CountForecast, CountForecastOrder
                              , Income_CEH, Income_PACK
                              , TermProduction, PartionGoods_start, PartionDate_pf, GoodsKindId_pf, GoodsKindCompleteId_pf, UnitId_pf
                              , isErased
                               )
        -- Данные MI
        SELECT tmpMI.MovementItemId, tmpMI.ContainerId
             , tmpMI.ReceiptId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.MeasureId
             , tmpMI.GoodsId_complete, tmpMI.GoodsKindId_complete
             , tmpMI.ReceiptId_basis, tmpMI.GoodsId_basis
             , tmpMI.Amount, tmpMI.AmountSecond
             , tmpMI.AmountRemains, tmpMI.Remains_CEH, tmpMI.Remains_CEH_Next, tmpMI.Remains, tmpMI.Remains_pack
             , tmpMI.AmountPartnerPrior, tmpMI.AmountPartnerPriorPromo, tmpMI.AmountPartner, tmpMI.AmountPartnerPromo
             , tmpMI.AmountForecast, tmpMI.AmountForecastPromo, tmpMI.AmountForecastOrder, tmpMI.AmountForecastOrderPromo
             , tmpMI.CountForecast, tmpMI.CountForecastOrder
             , 0 AS Income_CEH
             , 0 AS Income_PACK
             , tmpMI.TermProduction, tmpMI.PartionGoods_start, tmpMI.PartionDate_pf, tmpMI.GoodsKindId_pf, tmpMI.GoodsKindCompleteId_pf, tmpMI.UnitId_pf
             , tmpMI.isErased
        FROM tmpMI

       UNION ALL
        -- Приход пр-во (ФАКТ)
        SELECT 0 AS MovementItemId
             , 0 AS ContainerId
             , 0 AS ReceiptId
             , tmpIncome.GoodsId
             , tmpIncome.GoodsKindId
             , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
             , 0 AS GoodsId_complete, 0 AS GoodsKindId_complete
             , 0 AS ReceiptId_basis, 0 AS GoodsId_basis
             , 0 AS Amount, 0 AS AmountSecond
             , 0 AS AmountRemains, 0 AS Remains_CEH, 0 AS Remains_CEH_Next, 0 AS Remains, 0 AS Remains_pack
             , 0 AS AmountPartnerPrior, 0 AS AmountPartnerPriorPromo, 0 AS AmountPartner, 0 AS AmountPartnerPromo
             , 0 AS AmountForecast, 0 AS AmountForecastPromo, 0 AS AmountForecastOrder, 0 AS AmountForecastOrderPromo
             , 0 AS CountForecast, 0 AS CountForecastOrder
             , tmpIncome.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Income_CEH
             , 0 AS Income_PACK
             , 0 AS TermProduction, NULL :: TDateTime AS PartionGoods_start, NULL :: TDateTime AS PartionDate_pf, 0 AS GoodsKindId_pf, 0 AS GoodsKindCompleteId_pf
             , tmpIncome.UnitId_pf
             , FALSE AS isErased
        FROM tmpIncome
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpIncome.GoodsId
                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpIncome.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
       UNION ALL
        -- Приход - с Цеха Упаковки
        SELECT 0 AS MovementItemId
             , 0 AS ContainerId
             , 0 AS ReceiptId
             , tmpPACK.GoodsId
             , tmpPACK.GoodsKindId
             , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
             , 0 AS GoodsId_complete, 0 AS GoodsKindId_complete
             , 0 AS ReceiptId_basis, 0 AS GoodsId_basis
             , 0 AS Amount, 0 AS AmountSecond
             , 0 AS AmountRemains, 0 AS Remains_CEH, 0 AS Remains_CEH_Next, 0 AS Remains, 0 AS Remains_pack
             , 0 AS AmountPartnerPrior, 0 AS AmountPartnerPriorPromo, 0 AS AmountPartner, 0 AS AmountPartnerPromo
             , 0 AS AmountForecast, 0 AS AmountForecastPromo, 0 AS AmountForecastOrder, 0 AS AmountForecastOrderPromo
             , 0 AS CountForecast, 0 AS CountForecastOrder
             , 0 AS Income_CEH
             , tmpPACK.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Income_PACK
             , 0 AS TermProduction, NULL :: TDateTime AS PartionGoods_start, NULL :: TDateTime AS PartionDate_pf, 0 AS GoodsKindId_pf, 0 AS GoodsKindCompleteId_pf
             , tmpPACK.UnitId_pf
             , FALSE AS isErased
        FROM tmpPACK
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpPACK.GoodsId
                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpPACK.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
       ;


-- RAISE EXCEPTION '<%>', (select count(*) from _tmpMI_master where _tmpMI_master.GoodsId = 4965 and _tmpMI_master.GoodsKindId = zc_GoodsKind_Basis() );

       --
       OPEN Cursor1 FOR
       WITH tmpMI_all AS (SELECT * FROM _tmpMI_master
                          WHERE _tmpMI_master.Income_CEH       = 0 -- отбросили Приход пр-во (ФАКТ)
                            AND _tmpMI_master.Income_PACK      = 0 -- отбросили Приход с Цеха Упаковки
                            AND _tmpMI_master.GoodsId_complete = 0 -- т.е. НЕ упакованный
                            AND _tmpMI_master.ContainerId      = 0 -- отбросили остатки на ПР-ВЕ
                            -- AND _tmpMI_master.GoodsId_basis    > 0 -- отбросили Ирну (временно)
                         )
        -- Приход пр-во (ФАКТ)
      , tmpIncome AS (SELECT * FROM _tmpMI_master WHERE _tmpMI_master.Income_CEH <> 0)
           -- Ост. на произв-ве
         , tmpCEH AS (SELECT _tmpMI_master.GoodsId
                           , _tmpMI_master.GoodsKindCompleteId_pf
                           , SUM (_tmpMI_master.Remains_CEH)      AS Remains_CEH
                           , SUM (_tmpMI_master.Remains_CEH_Next) AS Remains_CEH_Next
                      FROM _tmpMI_master
                      WHERE _tmpMI_master.Remains_CEH <> 0 OR _tmpMI_master.Remains_CEH_Next <> 0
                      GROUP BY _tmpMI_master.GoodsId
                             , _tmpMI_master.GoodsKindCompleteId_pf
                     )
         -- Итого по данным из Курсора-2
       , tmpChild AS (SELECT CASE WHEN _tmpMI_master.GoodsId_complete = 0
                                       THEN _tmpMI_master.GoodsId
                                  ELSE _tmpMI_master.GoodsId_complete
                             END AS GoodsId
                           , CASE WHEN _tmpMI_master.GoodsId_complete = 0
                                       THEN _tmpMI_master.GoodsKindId
                                  ELSE _tmpMI_master.GoodsKindId_complete
                             END AS GoodsKindId

                           , SUM (_tmpMI_master.Remains_pack)             AS Remains_pack
                           , SUM (_tmpMI_master.Income_PACK)              AS Income_PACK

                           , SUM (_tmpMI_master.AmountPartnerPrior)       AS AmountPartnerPrior
                           , SUM (_tmpMI_master.AmountPartnerPriorPromo)  AS AmountPartnerPriorPromo
                           , SUM (_tmpMI_master.AmountPartner)            AS AmountPartner
                           , SUM (_tmpMI_master.AmountPartnerPromo)       AS AmountPartnerPromo

                           , SUM (_tmpMI_master.AmountForecast)           AS AmountForecast
                           , SUM (_tmpMI_master.AmountForecastPromo)      AS AmountForecastPromo
                           , SUM (_tmpMI_master.AmountForecastOrder)      AS AmountForecastOrder
                           , SUM (_tmpMI_master.AmountForecastOrderPromo) AS AmountForecastOrderPromo

                           , SUM (_tmpMI_master.CountForecast)      AS CountForecast
                           , SUM (_tmpMI_master.CountForecastOrder) AS CountForecastOrder

                      FROM _tmpMI_master
                      -- WHERE _tmpMI_master.Remains_pack <> 0
                      GROUP BY CASE WHEN _tmpMI_master.GoodsId_complete = 0
                                         THEN _tmpMI_master.GoodsId
                                    ELSE _tmpMI_master.GoodsId_complete
                              END
                            , CASE WHEN _tmpMI_master.GoodsId_complete = 0
                                         THEN _tmpMI_master.GoodsKindId
                                    ELSE _tmpMI_master.GoodsKindId_complete
                               END
                     )
          , tmpMI AS (SELECT tmpMI_all.MovementItemId, tmpMI_all.ContainerId
                           , tmpMI_all.ReceiptId, tmpMI_all.GoodsId
                           , tmpMI_all.GoodsKindId
                           , tmpMI_all.MeasureId
                           , tmpMI_all.GoodsId_complete, tmpMI_all.GoodsKindId_complete
                           , tmpMI_all.ReceiptId_basis
                           , tmpMI_all.GoodsId_basis
                           , tmpMI_all.Amount, tmpMI_all.AmountSecond
                           , tmpMI_all.AmountRemains, tmpMI_all.Remains_CEH, tmpMI_all.Remains_CEH_Next, tmpMI_all.Remains, tmpMI_all.Remains_pack
                           , tmpMI_all.AmountPartnerPrior, tmpMI_all.AmountPartnerPriorPromo, tmpMI_all.AmountPartner, tmpMI_all.AmountPartnerPromo
                           , tmpMI_all.AmountForecast, tmpMI_all.AmountForecastPromo, tmpMI_all.AmountForecastOrder, tmpMI_all.AmountForecastOrderPromo
                           , tmpMI_all.CountForecast, tmpMI_all.CountForecastOrder
                           , tmpMI_all.Income_CEH
                           , tmpMI_all.TermProduction, tmpMI_all.PartionGoods_start, tmpMI_all.PartionDate_pf, tmpMI_all.GoodsKindId_pf, tmpMI_all.GoodsKindCompleteId_pf, tmpMI_all.UnitId_pf
                           , tmpMI_all.isErased
                      FROM tmpMI_all
                     UNION
                      SELECT _tmpMI_master.MovementItemId, _tmpMI_master.ContainerId
                           , _tmpMI_master.ReceiptId, _tmpMI_master.GoodsId
                           , _tmpMI_master.GoodsKindId
                           -- , _tmpMI_master.GoodsKindCompleteId_pf AS GoodsKindId
                           , _tmpMI_master.MeasureId
                           , _tmpMI_master.GoodsId_complete, _tmpMI_master.GoodsKindId_complete
                           , _tmpMI_master.ReceiptId_basis
                           , _tmpMI_master.GoodsId_basis
                           -- , _tmpMI_master.GoodsId AS GoodsId_basis
                           , _tmpMI_master.Amount, _tmpMI_master.AmountSecond
                           , _tmpMI_master.AmountRemains, _tmpMI_master.Remains_CEH, _tmpMI_master.Remains_CEH_Next, _tmpMI_master.Remains, _tmpMI_master.Remains_pack
                           , _tmpMI_master.AmountPartnerPrior, _tmpMI_master.AmountPartnerPriorPromo, _tmpMI_master.AmountPartner, _tmpMI_master.AmountPartnerPromo
                           , _tmpMI_master.AmountForecast, _tmpMI_master.AmountForecastPromo, _tmpMI_master.AmountForecastOrder, _tmpMI_master.AmountForecastOrderPromo
                           , _tmpMI_master.CountForecast, _tmpMI_master.CountForecastOrder
                           , _tmpMI_master.Income_CEH
                           , _tmpMI_master.TermProduction, _tmpMI_master.PartionGoods_start, _tmpMI_master.PartionDate_pf, _tmpMI_master.GoodsKindId_pf, _tmpMI_master.GoodsKindCompleteId_pf, _tmpMI_master.UnitId_pf
                           , _tmpMI_master.isErased
                      FROM _tmpMI_master
                           LEFT JOIN tmpMI_all ON tmpMI_all.GoodsId_basis = _tmpMI_master.GoodsId
                                              AND tmpMI_all.GoodsKindId   = _tmpMI_master.GoodsKindCompleteId_pf
                      WHERE (_tmpMI_master.Remains_CEH <> 0 OR _tmpMI_master.Remains_CEH_Next  <> 0)
                        AND tmpMI_all.GoodsId_basis IS NULL
                     )
       -- Результат
       SELECT
             tmpMI.MovementItemId   AS Id
           , (tmpMI.GoodsId :: TVarChar || '_' || tmpMI.GoodsKindId :: TVarChar) :: TVarChar AS KeyId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Goods_basis.Id               AS GoodsId_basis
           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
           , Object_Goods_basis.ValueData        AS GoodsName_basis

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_basis.ValueData      AS MeasureName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_basis AND tmpMI.GoodsId_basis > 0 THEN TRUE ELSE FALSE END AS isCheck_basis

           , tmpMI.Amount                        :: TFloat AS Amount        -- ***Ост. на УПАК
           , tmpMI.AmountSecond                  :: TFloat AS AmountSecond  -- ***План ПР-ВО на УПАК
           , (tmpMI.Amount + tmpMI.AmountSecond) :: TFloat AS AmountTotal   -- ***План ПР-ВО на УПАК

           , (CAST (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH ELSE COALESCE (tmpCEH.Remains_CEH, 0) END
              - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 1))) :: TFloat AS Amount_result
           , (CAST (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + 0
              - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 1))) :: TFloat AS Amount_result_two

             -- Приход пр-во (ФАКТ)
           , tmpIncome.Income_CEH    :: TFloat AS Income_CEH
             -- Приход - с Цеха Упаковки
           , tmpChild.Income_PACK

             -- Ост. нач. - НЕ упак.
           , tmpMI.Remains
             -- Ост. начальн. - упакованный
           , COALESCE (tmpChild.Remains_pack, 0) :: TFloat AS Remains_pack -- tmpMI.Remains_pack

             -- Ост. начальн. - произв. (СЕГОДНЯ)
           , CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH      ELSE tmpCEH.Remains_CEH      END :: TFloat AS Remains_CEH
             -- Ост. начальн. - произв. (ПОЗЖЕ)
           , CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH_Next ELSE tmpCEH.Remains_CEH_Next END :: TFloat AS Remains_CEH_Next

              -- неотгуж. заявка
           , CAST (COALESCE (tmpChild.AmountPartnerPrior, 0)       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (COALESCE (tmpChild.AmountPartnerPriorPromo, 0)  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
           , CAST (COALESCE (tmpChild.AmountPartnerPrior, 0) + COALESCE (tmpChild.AmountPartnerPriorPromo, 0) AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorTotal

            -- сегодня заявка
           , CAST (COALESCE (tmpChild.AmountPartner, 0)            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (COALESCE (tmpChild.AmountPartnerPromo, 0)       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo
           , CAST (COALESCE (tmpChild.AmountPartner, 0) + COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerTotal

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpChild.AmountForecast) < 1           THEN tmpChild.AmountForecast           ELSE CAST (COALESCE (tmpChild.AmountForecast, 0)           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
           , CASE WHEN ABS (tmpChild.AmountForecastPromo) < 1      THEN tmpChild.AmountForecastPromo      ELSE CAST (COALESCE (tmpChild.AmountForecastPromo, 0)      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpChild.AmountForecastOrder) < 1      THEN tmpChild.AmountForecastOrder      ELSE CAST (COALESCE (tmpChild.AmountForecastOrder, 0)      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpChild.AmountForecastOrderPromo) < 1 THEN tmpChild.AmountForecastOrderPromo ELSE CAST (COALESCE (tmpChild.AmountForecastOrderPromo, 0) AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

             -- Норм 1д (по пр.) без К
           , CAST (tmpChild.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast
             -- Норм 1д (по зв.) без К
           , CAST (tmpChild.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpChild.CountForecast > 0
                             THEN (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0)) / tmpChild.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpChild.CountForecastOrder > 0
                             THEN (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0)) / tmpChild.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName

           , tmpMI.isErased

       FROM tmpMI
            -- Приход пр-во (ФАКТ)
            FULL JOIN tmpIncome
                   ON tmpIncome.GoodsId     = tmpMI.GoodsId
                  AND tmpIncome.GoodsKindId = tmpMI.GoodsKindId

            -- Ост. на произв-ве
            LEFT JOIN tmpCEH
                   ON tmpCEH.GoodsId                = tmpMI.GoodsId_basis
                  AND tmpCEH.GoodsKindCompleteId_pf = tmpMI.GoodsKindId
            -- Итого по данным из Курсора-2
            LEFT JOIN tmpChild
                   ON tmpChild.GoodsId              = COALESCE (tmpMI.GoodsId, tmpIncome.GoodsId)
                  AND tmpChild.GoodsKindId          = COALESCE (tmpMI.GoodsKindId, tmpIncome.GoodsKindId)

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmpMI.GoodsId_basis
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = COALESCE (tmpMI.GoodsId, tmpIncome.GoodsId)
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = COALESCE (tmpMI.GoodsKindId, tmpIncome.GoodsKindId)

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (tmpMI.MeasureId, tmpIncome.MeasureId)

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods_basis.Id
                                AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId   = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId

      ;

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
       SELECT
             tmpMI.MovementItemId   AS Id
           , tmpMI.ContainerId      AS ContainerId
           , CASE WHEN tmpMI.GoodsId_complete = 0
                       THEN tmpMI.GoodsId :: TVarChar || '_' || tmpMI.GoodsKindId :: TVarChar
                  ELSE tmpMI.GoodsId_complete :: TVarChar || '_' || tmpMI.GoodsKindId_complete :: TVarChar
             END  :: TVarChar AS KeyId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.ValueData            AS MeasureName

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount                        :: TFloat AS Amount         -- ***План заказ на УПАК (с Ост.)
           , tmpMI.AmountSecond                  :: TFloat AS AmountSecond   -- ***План заказ на УПАК (с Цеха)
           , (tmpMI.Amount + tmpMI.AmountSecond) :: TFloat AS AmountTotal    -- ***План заказ на УПАК (ИТОГО)
           
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.Remains_CEH - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result_two

             -- Приход - с Цеха Упаковки
           , tmpMI.Income_PACK
             -- Ост. начальн. - НЕ упакованный
           , tmpMI.Remains
             -- Ост. нач. - упакованный
           , tmpMI.Remains_pack

              -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
           , CAST (tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerPriorPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorTotal
            -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo
           , CAST (tmpMI.AmountPartner + tmpMI.AmountPartnerPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerTotal

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

             -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast
             -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis

           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = tmpMI.MeasureId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
        WHERE tmpMI.Income_CEH = 0

       ;
       RETURN NEXT Cursor2;

       OPEN Cursor3 FOR
       SELECT
             tmpMI.MovementItemId   AS Id
           , tmpMI.ContainerId      AS ContainerId

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Goods_complete.Id            AS GoodsId_complete
           , Object_Goods_complete.ObjectCode    AS GoodsCode_complete
           , Object_Goods_complete.ValueData     AS GoodsName_complete

           , Object_Goods_basis.Id               AS GoodsId_basis
           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
           , Object_Goods_basis.ValueData        AS GoodsName_basis

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_complete.Id        AS GoodsKindId_complete
           , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete

           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_complete.ValueData   AS MeasureName_complete
           , Object_Measure_basis.ValueData      AS MeasureName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId_complete = 0 AND tmpMI.GoodsId <> tmpMI.GoodsId_basis AND tmpMI.GoodsId_basis > 0
                       THEN TRUE
                  WHEN tmpMI.GoodsId_complete <> tmpMI.GoodsId_basis AND tmpMI.GoodsId_basis > 0
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isCheck_basis

           , tmpMI.Amount                        :: TFloat AS Amount        -- ***План выдачи с Ост. на УПАК
           , tmpMI.AmountSecond                  :: TFloat AS AmountSecond  -- ***План выдачи с Цеха на УПАК
           , (tmpMI.Amount + tmpMI.AmountSecond) :: TFloat AS AmountTotal   -- ***План выдачи ИТОГО на УПАК

           , CAST (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.Remains_CEH - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result_two

             -- Приход пр-во (ФАКТ)
           , tmpMI.Income_CEH    :: TFloat AS Income_CEH
             -- Приход - с Цеха Упаковки
           , tmpMI.Income_PACK

             -- Ост. начальн. - произв. (СЕГОДНЯ)
           , tmpMI.Remains_CEH
             -- Ост. начальн. - произв. (ПОЗЖЕ)
           , tmpMI.Remains_CEH_Next
             -- Ост. начальн. - НЕ упакованный
           , tmpMI.Remains
             -- Ост. начальн. - упакованный
           , tmpMI.Remains_pack

              -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
           , CAST (tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerPriorPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorTotal
            -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo
           , CAST (tmpMI.AmountPartner + tmpMI.AmountPartnerPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerTotal

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

             -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast
             -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName

           , Object_GoodsKind_pf.ValueData             AS GoodsKindName_pf
           , Object_GoodsKindComplete_pf.ValueData     AS GoodsKindCompleteName_pf
           , tmpMI.PartionDate_pf                      AS PartionDate_pf
           , tmpMI.PartionGoods_start                  AS PartionGoods_start
           , tmpMI.TermProduction                      AS TermProduction

           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods              ON Object_Goods.Id          = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Goods_complete     ON Object_Goods_complete.Id = tmpMI.GoodsId_complete
            LEFT JOIN Object AS Object_Goods_basis        ON Object_Goods_basis.Id    = tmpMI.GoodsId_basis

            LEFT JOIN Object AS Object_GoodsKind          ON Object_GoodsKind.Id          = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = tmpMI.GoodsKindId_complete

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_complete
                                 ON ObjectLink_Goods_Measure_complete.ObjectId = Object_Goods_complete.Id
                                AND ObjectLink_Goods_Measure_complete.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_complete ON Object_Measure_complete.Id = ObjectLink_Goods_Measure_complete.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind_pf ON Object_GoodsKind_pf.Id = tmpMI.GoodsKindId_pf
            LEFT JOIN Object AS Object_GoodsKindComplete_pf ON Object_GoodsKindComplete_pf.Id = tmpMI.GoodsKindCompleteId_pf

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods_basis.Id
                                AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId   = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.UnitId_pf ELSE ObjectLink_OrderType_Unit.ChildObjectId END
           ;

       RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.17         *
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
