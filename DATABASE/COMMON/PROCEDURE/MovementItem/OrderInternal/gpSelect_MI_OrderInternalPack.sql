-- Function: gpSelect_MI_OrderInternalPack()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPack (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPack(
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

   DECLARE vbOperDate TDateTime;
   DECLARE vbToId Integer;
   DECLARE vbDayCount Integer;
   DECLARE vbMonth Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId
          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
            INTO vbOperDate, vbToId, vbDayCount, vbMonth
     FROM Movement
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
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId_detail Integer, GoodsKindId_detail Integer, GoodsId Integer, GoodsKindId_complete Integer
                                    , ReceiptId Integer, ReceiptId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat, AmountPartnerPrior TFloat, AmountPartner TFloat
                                    , AmountForecast TFloat, AmountForecastOrder TFloat
                                    , Koeff TFloat, TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, GoodsId_detail, GoodsKindId_detail, GoodsId, GoodsKindId_complete
                              , ReceiptId, ReceiptId_basis
                              , Amount, AmountSecond, AmountRemains, AmountPartnerPrior, AmountPartner
                              , AmountForecast, AmountForecastOrder
                              , Koeff, TermProduction, NormInDays, StartProductionInDays
                              , isErased)
                              SELECT MovementItem.Id AS MovementItemId
                                   , MovementItem.ObjectId AS GoodsId_detail
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_detail

                                   , COALESCE (MILinkObject_Goods.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN MovementItem.ObjectId
                                                    ELSE 0
                                               END
                                              )AS GoodsId

                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN zc_GoodsKind_Basis()
                                                    ELSE 0
                                               END
                                              ) AS GoodsKindId_complete
                                   , COALESCE (MILinkObject_Receipt.ObjectId, 0)           AS ReceiptId
                                   , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis

                                   , MovementItem.Amount                                   AS Amount
                                   , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                                   , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                   , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)    AS AmountPartnerPrior
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0)         AS AmountPartner
                                   , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast
                                   , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)   AS AmountForecastOrder
                                   , COALESCE (MIFloat_Koeff.ValueData, 0)                 AS Koeff
                                   , COALESCE (MIFloat_TermProduction.ValueData, 0)        AS TermProduction
                                   , COALESCE (MIFloat_NormInDays.ValueData, 0)            AS NormInDays
                                   , COALESCE (MIFloat_StartProductionInDays.ValueData, 0) AS StartProductionInDays
                                   , MovementItem.isErased                                 AS isErased

                              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = tmpIsErased.isErased
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
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                               ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                               ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                               ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()
 
                                   LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                               ON MIFloat_Koeff.MovementItemId = MovementItem.Id 
                                                              AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TermProduction
                                                               ON MIFloat_TermProduction.MovementItemId = MovementItem.Id 
                                                              AND MIFloat_TermProduction.DescId = zc_MIFloat_TermProduction()
                                   LEFT JOIN MovementItemFloat AS MIFloat_NormInDays
                                                               ON MIFloat_NormInDays.MovementItemId = MovementItem.Id 
                                                              AND MIFloat_NormInDays.DescId = zc_MIFloat_NormInDays()
                                   LEFT JOIN MovementItemFloat AS MIFloat_StartProductionInDays
                                                               ON MIFloat_StartProductionInDays.MovementItemId = MovementItem.Id 
                                                              AND MIFloat_StartProductionInDays.DescId = zc_MIFloat_StartProductionInDays()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                    ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                    ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                                    ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                             ;


     -- 
     CREATE TEMP TABLE _tmpMI_child (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
     -- 
     INSERT INTO _tmpMI_child (MovementItemId, GoodsId, GoodsKindId, Amount)
             SELECT MovementItem.Id                                       AS MovementItemId
                  , MovementItem.ObjectId                                 AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                  , MovementItem.Amount                                   AS Amount
             FROM MovementItem
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.isErased   = FALSE;

       --
       OPEN Cursor1 FOR
        WITH tmpMI_master_find AS (SELECT MAX (tmpMI_master.MovementItemId) AS MovementItemId
                                   FROM _tmpMI_master AS tmpMI_master
                                   WHERE tmpMI_master.isErased = FALSE
                                   GROUP BY tmpMI_master.GoodsId_detail, tmpMI_master.GoodsKindId_detail
                                  )
           , tmpMIPartion_master AS (SELECT tmpMI_master.MovementItemId
                                          , SUM (_tmpMI_child.Amount) AS AmountRemains
                                     FROM tmpMI_master_find
                                          INNER JOIN _tmpMI_master AS tmpMI_master ON tmpMI_master.MovementItemId = tmpMI_master_find.MovementItemId
                                          INNER JOIN _tmpMI_child ON _tmpMI_child.GoodsId    = tmpMI_master.GoodsId_detail
                                                                 AND _tmpMI_child.GoodsKindId = tmpMI_master.GoodsKindId_detail
                                     GROUP BY tmpMI_master.MovementItemId
                                    )
            -- хардкодим - ЦЕХ колбаса+дел-сы
          , tmpUnitFrom AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Реализации
          , tmpUnitTo   AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
          , tmpMI_Send AS (SELECT 
                                  tmpMI.GoodsId                          AS GoodsId
                                , COALESCE (CLO_GoodsKindId.ObjectId, 0) AS GoodsKindId
                                , SUM (tmpMI.Amount)                     AS Amount
                                , SUM (tmpMI.Amount_baza)                AS Amount_baza

                           FROM (SELECT MIContainer.ObjectId_Analyzer AS GoodsId
                                      , MIContainer.ContainerId       AS ContainerId
                                      , -1 * SUM (MIContainer.Amount) AS Amount
                                      , 0                             AS Amount_baza
                                 FROM MovementItemContainer AS MIContainer
                                 WHERE MIContainer.OperDate   = vbOperDate
                                   AND MIContainer.DescId     = zc_MIContainer_Count()
                                   AND MIContainer.WhereObjectId_Analyzer = vbToId
                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                   AND MIContainer.isActive = FALSE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                        , MIContainer.ContainerId
                                UNION ALL
                                 SELECT MIContainer.ObjectId_Analyzer AS GoodsId
                                      , MIContainer.ContainerId       AS ContainerId
                                      , 0                             AS Amount
                                      , 1 * SUM (MIContainer.Amount)  AS Amount_baza
                                 FROM MovementItemContainer AS MIContainer
                                      -- ЦЕХ колбаса+дел-сы
                                      INNER JOIN tmpUnitFrom ON tmpUnitFrom.UnitId = MIContainer.ObjectExtId_Analyzer -- AnalyzerId
                                      -- Склады База + Реализации
                                      INNER JOIN tmpUnitTo   ON tmpUnitTo.UnitId   = MIContainer.WhereObjectId_Analyzer
                                 WHERE MIContainer.OperDate       = vbOperDate
                                   AND MIContainer.DescId         = zc_MIContainer_Count()
                                   AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                   AND MIContainer.isActive       = TRUE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                        , MIContainer.ContainerId
                                ) AS tmpMI
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKindId
                                                              ON CLO_GoodsKindId.ContainerId = tmpMI.ContainerId
                                                             AND CLO_GoodsKindId.DescId      = zc_ContainerLinkObject_GoodsKind()
                            GROUP BY tmpMI.GoodsId
                                   , CLO_GoodsKindId.ObjectId
                          )
       SELECT
             tmpMI.MovementItemId :: Integer     AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods_detail.ObjectCode              AS GoodsCode_detail
           , Object_Goods_detail.ValueData               AS GoodsName_detail
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_detail THEN TRUE ELSE FALSE END AS isCheck_detail

           , tmpMI.Amount           :: TFloat AS Amount           -- Заказ на пр-во
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- Дозаказ на пр-во

           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner                             AS NUMERIC (16, 1)) :: TFloat AS AmountRemains_calc      -- Прогн. ост.
           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner + tmpMI.AmountRemains_child AS NUMERIC (16, 1)) :: TFloat AS AmountRemainsChild_calc -- *Прогн. ост. c учетом на упак.

           , CAST (tmpMI.NormInDays     * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognoz_calc          -- Норма запас (по пр.)
           , CAST (tmpMI.NormInDays     * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrder_calc     -- Норма запас (по зв.)
           , CAST (tmpMI.TermProduction * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozTerm_calc      -- *Норма зап. на срок (по пр.)
           , CAST (tmpMI.TermProduction * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrderTerm_calc -- *Норма зап. на срок (по зв.)

           , CAST (tmpMI.AmountRemains_child  AS NUMERIC (16, 1)) :: TFloat AS AmountRemains_child  -- Остаток на упак.

           , CASE WHEN ABS (tmpMI.AmountRemains) < 1 THEN tmpMI.AmountRemains ELSE CAST (tmpMI.AmountRemains AS NUMERIC (16, 1)) END :: TFloat AS AmountRemains -- Ост. начальн.
           , CAST (tmpMI.AmountPartnerPrior  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior  -- неотгуж. заявка
           , CAST (tmpMI.AmountPartner       AS NUMERIC (16, 2)) :: TFloat AS AmountPartner       -- сегодня заявка
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1      THEN tmpMI.AmountForecast      ELSE CAST (tmpMI.AmountForecast AS NUMERIC (16, 1))      END :: TFloat AS AmountForecast      -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1 THEN tmpMI.AmountForecastOrder ELSE CAST (tmpMI.AmountForecastOrder AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder -- Прогноз по заяв.

           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast                     -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder                -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecast * tmpMI.Koeff AS NUMERIC (16, 1))      :: TFloat AS CountForecastK      -- Норм 1д (по пр.)
           , CAST (tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrderK -- Норм 1д (по зв.)

           , CAST (CASE WHEN tmpMI.CountForecast > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecast * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast      -- Ост. в днях (по прод.) 
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecastOrder * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder -- Ост. в днях (по зв.)

           , tmpMI.Koeff                 :: TFloat AS Koeff                 -- Коэфф.
           , tmpMI.TermProduction        :: TFloat AS TermProduction        -- Срок произв. в дн.
           , tmpMI.NormInDays            :: TFloat AS NormInDays            -- Норма запас в дн.
           , tmpMI.StartProductionInDays :: TFloat AS StartProductionInDays -- Нач. произв. в дн.

           , CASE WHEN ObjectLink_Goods_Measure_detail.ChildObjectId = zc_Measure_Sh() THEN tmpMI_Send.Amount ELSE 0 END AS AmountSend_sh
           , tmpMI_Send.Amount * CASE WHEN ObjectLink_Goods_Measure_detail.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight_detail.ValueData, 0) ELSE 1 END AS AmountSend_Weight

           , CASE WHEN ObjectLink_Goods_Measure_detail.ChildObjectId = zc_Measure_Sh() THEN tmpMI_Send.Amount_baza ELSE 0 END AS AmountBaza_sh
           , tmpMI_Send.Amount_baza * CASE WHEN ObjectLink_Goods_Measure_detail.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight_detail.ValueData, 0) ELSE 1 END AS AmountBaza_Weight

           , CASE WHEN tmpMI_Send.Amount > 0 AND (tmpMI.Amount + tmpMI.AmountSecond) = 0
                       THEN -100
                  WHEN COALESCE (tmpMI_Send.Amount, 0) = 0 AND (tmpMI.Amount + tmpMI.AmountSecond) <> 0
                       THEN 0
                  WHEN COALESCE (tmpMI_Send.Amount, 0) = 0 AND (tmpMI.Amount + tmpMI.AmountSecond) = 0
                       THEN 0
                  ELSE CAST (100 * tmpMI_Send.Amount / (tmpMI.Amount + tmpMI.AmountSecond) AS NUMERIC (16, 0))
              END AS Percent_diff
           , CASE WHEN COALESCE (tmpMI_Send.Amount, 0) = 0 AND (tmpMI.Amount + tmpMI.AmountSecond) = 0
                       THEN FALSE
                  WHEN (tmpMI.Amount + tmpMI.AmountSecond) = 0
                       THEN TRUE
                  WHEN CAST (100 * tmpMI_Send.Amount / (tmpMI.Amount + tmpMI.AmountSecond) AS NUMERIC (16, 0)) = 100
                       THEN FALSE
                  ELSE TRUE
              END :: Boolean AS isPercent_diff

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_detail.ValueData   AS GoodsKindName_detail
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_detail.ValueData     AS MeasureName_detail

           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , Object_Receipt_basis.ObjectCode           AS ReceiptCode_code_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis

           , Object_Receipt.Id                         AS ReceiptId
           , Object_Receipt.ObjectCode                 AS ReceiptCode_code
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName

           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName 

           , CASE WHEN tmpMI.AmountRemains <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remains
           , CASE WHEN tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remains_calc
           , CASE WHEN tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner + tmpMI.AmountRemains_child <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remainsChild_calc

           , zc_Color_Blue() AS Color_send
           , CASE WHEN tmpMI_Send.Amount > 0 AND (tmpMI.Amount + tmpMI.AmountSecond) = 0
                       THEN zc_Color_Red()
                  WHEN COALESCE (tmpMI_Send.Amount, 0) = 0 AND (tmpMI.Amount + tmpMI.AmountSecond) <> 0
                       THEN zc_Color_Red()
                  WHEN COALESCE (tmpMI_Send.Amount, 0) = 0 AND (tmpMI.Amount + tmpMI.AmountSecond) = 0
                       THEN zc_Color_Black()
                  WHEN CAST (100 * tmpMI_Send.Amount / (tmpMI.Amount + tmpMI.AmountSecond) AS NUMERIC (16, 0)) < 100
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
              END AS Color_Percent_diff
           , CASE WHEN COALESCE (tmpMI_Send.Amount, 0) = 0 AND (tmpMI.Amount + tmpMI.AmountSecond) <> 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_White()
              END AS ColorB_Percent_diff

           , zc_Color_Aqua()   :: Integer AS ColorB_const
           , zc_Color_Cyan()   :: Integer AS ColorB_DayCountForecast
           , zc_Color_GreenL() :: Integer AS ColorB_AmountPartner
           , zc_Color_Yelow()  :: Integer AS ColorB_AmountPrognoz

           , tmpMI.isErased

       FROM (SELECT tmpMI_master.MovementItemId AS MovementItemId
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail
                  , SUM (tmpMI_master.Amount)           AS Amount
                  , SUM (tmpMI_master.AmountSecond)     AS AmountSecond

                  , SUM (tmpMI_master.AmountRemains)       AS AmountRemains
                  , SUM (tmpMI_master.AmountPartnerPrior)  AS AmountPartnerPrior
                  , SUM (tmpMI_master.AmountPartner)       AS AmountPartner
                  , SUM (tmpMI_master.AmountForecast)      AS AmountForecast
                  , SUM (tmpMI_master.AmountForecastOrder) AS AmountForecastOrder

                  , CASE WHEN vbDayCount <> 0 THEN SUM (tmpMI_master.AmountForecast) / vbDayCount      ELSE 0 END AS CountForecast
                  , CASE WHEN vbDayCount <> 0 THEN SUM (tmpMI_master.AmountForecastOrder) / vbDayCount ELSE 0 END AS CountForecastOrder

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , tmpMI_master.GoodsId
                  , tmpMI_master.GoodsKindId_complete

                  , SUM (COALESCE (tmpMIPartion_master.AmountRemains, 0))  AS AmountRemains_child

                  , tmpMI_master.isErased
             FROM _tmpMI_master AS tmpMI_master
                  LEFT JOIN tmpMIPartion_master ON tmpMIPartion_master.MovementItemId = tmpMI_master.MovementItemId
             GROUP BY tmpMI_master.MovementItemId
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , tmpMI_master.GoodsId
                  , tmpMI_master.GoodsKindId_complete

                  , tmpMI_master.isErased
            ) AS tmpMI

            LEFT JOIN tmpMI_Send ON tmpMI_Send.GoodsId = tmpMI.GoodsId_detail
                                AND tmpMI_Send.GoodsKindId = tmpMI.GoodsKindId_detail

            LEFT JOIN Object AS Object_Goods_detail ON Object_Goods_detail.Id = tmpMI.GoodsId_detail
            LEFT JOIN Object AS Object_GoodsKind_detail ON Object_GoodsKind_detail.Id = tmpMI.GoodsKindId_detail
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_detail
                                 ON ObjectLink_Goods_Measure_detail.ObjectId = Object_Goods_detail.Id
                                AND ObjectLink_Goods_Measure_detail.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_detail ON Object_Measure_detail.Id = ObjectLink_Goods_Measure_detail.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight_detail
                                  ON ObjectFloat_Weight_detail.ObjectId = tmpMI.GoodsId_detail
                                 AND ObjectFloat_Weight_detail.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
 
            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId_complete

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = COALESCE (Object_Goods.Id, Object_Goods_detail.Id)
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId
          ;

       RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalPack (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalPack (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPack (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
