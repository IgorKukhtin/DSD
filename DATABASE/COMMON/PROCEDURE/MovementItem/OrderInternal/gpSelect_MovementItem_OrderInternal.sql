-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal(
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

   DECLARE vbOperDate TDateTime;
   DECLARE vbDayCount Integer;
   DECLARE vbMonth Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
            INTO vbOperDate, vbDayCount, vbMonth
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     -- 
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId_detail Integer, GoodsKindId_detail Integer, GoodsId Integer, GoodsId_basis Integer, GoodsKindId_complete Integer
                                    , ReceiptId Integer, ReceiptId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat, AmountPartnerPrior TFloat, AmountPartner TFloat
                                    , AmountForecast TFloat, AmountForecastOrder TFloat
                                    , CuterCount TFloat, Koeff TFloat, TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, GoodsId_detail, GoodsKindId_detail, GoodsId, GoodsId_basis, GoodsKindId_complete
                              , ReceiptId , ReceiptId_basis
                              , Amount, AmountSecond, AmountRemains, AmountPartnerPrior, AmountPartner
                              , AmountForecast, AmountForecastOrder
                              , CuterCount, Koeff, TermProduction, NormInDays, StartProductionInDays
                              , isErased)
                              SELECT MovementItem.Id                                       AS MovementItemId
                                   , CASE WHEN inShowAll = TRUE THEN MovementItem.ObjectId                         ELSE 0 END AS GoodsId_detail
                                   , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId_detail

                                   , COALESCE (MILinkObject_Goods.ObjectId, 0)             AS GoodsId
                                   , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis
                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete
                                   , COALESCE (MILinkObject_Receipt.ObjectId, 0)           AS ReceiptId
                                   , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis

                                   , MovementItem.Amount                                   AS Amount
                                   , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                                   , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                   , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)    AS AmountPartnerPrior
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0)         AS AmountPartner
                                   , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast
                                   , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)   AS AmountForecastOrder
                                   , COALESCE (MIFloat_CuterCount.ValueData, 0)            AS CuterCount
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
 
                                   LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                               ON MIFloat_CuterCount.MovementItemId = MovementItem.Id 
                                                              AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
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

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                    ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                                    ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                             ;


     -- 
     CREATE TEMP TABLE _tmpMI_child (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, PartionGoodsDate TDateTime, ContainerId Integer, Amount TFloat) ON COMMIT DROP;
     -- 
     INSERT INTO _tmpMI_child (MovementItemId, GoodsId, GoodsKindId, GoodsKindId_complete, PartionGoodsDate, ContainerId, Amount)
             SELECT MovementItem.Id                                       AS MovementItemId
                  , MovementItem.ObjectId                                 AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete
                  , MIDate_PartionGoods.ValueData                         AS PartionGoodsDate
                  , MIFloat_ContainerId.ValueData                         AS ContainerId
                  , MovementItem.Amount                                   AS Amount
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                              ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                             AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                   ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.isErased   = FALSE;

       --
       OPEN Cursor1 FOR
        WITH tmpMI_master_find AS (SELECT MAX (tmpMI_master.MovementItemId) AS MovementItemId
                                   FROM _tmpMI_master AS tmpMI_master
                                   WHERE tmpMI_master.isErased = FALSE
                                   GROUP BY tmpMI_master.GoodsId_basis, tmpMI_master.GoodsKindId_complete
                                  )
           , tmpMIPartion_master AS (SELECT tmpMI_master.MovementItemId
                                          , SUM (CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                                                           THEN _tmpMI_child.Amount
                                                      ELSE 0
                                                 END) AS AmountProduction_old
                                          , SUM (CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                                                           THEN _tmpMI_child.Amount
                                                      ELSE 0
                                                 END) AS AmountProduction_next
                                          , MIN (CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateEnd()
                                                 END) AS StartDate_old
                                          , MAX (CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateStart()
                                                 END) AS EndDate_old
                                          , MIN (CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateEnd()
                                                 END) AS StartDate_next
                                          , MAX (CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateStart()
                                                 END) AS EndDate_next
                                     FROM tmpMI_master_find
                                          INNER JOIN _tmpMI_master AS tmpMI_master ON tmpMI_master.MovementItemId = tmpMI_master_find.MovementItemId
                                          INNER JOIN _tmpMI_child ON _tmpMI_child.GoodsId              = tmpMI_master.GoodsId_basis
                                                                 AND _tmpMI_child.GoodsKindId_complete = tmpMI_master.GoodsKindId_complete
                                     GROUP BY tmpMI_master.MovementItemId
                                    )

       SELECT
             tmpMI.MovementItemId :: Integer     AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods_basis.Id                       AS GoodsId_basis
           , Object_Goods_basis.ObjectCode               AS GoodsCode_basis
           , Object_Goods_basis.ValueData                AS GoodsName_basis
           , Object_Goods_detail.ObjectCode              AS GoodsCode_detail
           , Object_Goods_detail.ValueData               AS GoodsName_detail
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_basis THEN TRUE ELSE FALSE END AS isCheck_basis

           , tmpMI.Amount       :: TFloat AS Amount
           , tmpMI.AmountSecond :: TFloat AS AmountSecond

           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner + tmpMI.AmountProduction_old  + tmpMI.AmountProduction_next AS NUMERIC (16, 1)) :: TFloat AS AmountRemains_calc
           , CAST (tmpMI.NormInDays * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognoz_calc
           , CAST (tmpMI.NormInDays * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrder_calc

           , CAST (tmpMI.AmountProduction_old  AS NUMERIC (16, 1)) :: TFloat AS AmountProduction_old
           , CAST (tmpMI.AmountProduction_next AS NUMERIC (16, 1)) :: TFloat AS AmountProduction_next
           , CASE WHEN tmpMI.StartDate_old  = zc_DateEnd()                                                THEN NULL ELSE tmpMI.StartDate_old  END :: TDateTime AS StartDate_old
           , CASE WHEN tmpMI.EndDate_old    = zc_DateStart() OR tmpMI.EndDate_old = tmpMI.StartDate_old   THEN NULL ELSE tmpMI.EndDate_old    END :: TDateTime AS EndDate_old
           , CASE WHEN tmpMI.StartDate_next = zc_DateEnd()                                                THEN NULL ELSE tmpMI.StartDate_next END :: TDateTime AS StartDate_next
           , CASE WHEN tmpMI.EndDate_next   = zc_DateStart() OR tmpMI.EndDate_next = tmpMI.StartDate_next THEN NULL ELSE tmpMI.EndDate_next   END :: TDateTime AS EndDate_next

           , CAST (tmpMI.AmountRemains       AS NUMERIC (16, 1)) :: TFloat AS AmountRemains
           , CAST (tmpMI.AmountPartnerPrior  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartner       AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountForecast      AS NUMERIC (16, 1)) :: TFloat AS AmountForecast
           , CAST (tmpMI.AmountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS AmountForecastOrder

           , CAST (tmpMI.CountForecast AS NUMERIC (16, 2))      :: TFloat AS CountForecast
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 2)) :: TFloat AS CountForecastOrder
           , CAST (tmpMI.CountForecast * tmpMI.Koeff AS NUMERIC (16, 2))      :: TFloat AS CountForecastK
           , CAST (tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 2)) :: TFloat AS CountForecastOrderK

           , CAST (CASE WHEN tmpMI.CountForecast > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecast * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecastOrder * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , tmpMI.Koeff                 :: TFloat AS Koeff
           , tmpMI.TermProduction        :: TFloat AS TermProduction
           , tmpMI.NormInDays            :: TFloat AS NormInDays 
           , tmpMI.StartProductionInDays :: TFloat AS StartProductionInDays 

           , tmpMI.CuterCount :: TFloat          AS CuterCount

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_detail.ValueData   AS GoodsKindName_detail
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_basis.ValueData      AS MeasureName_basis
           , Object_Measure_detail.ValueData     AS MeasureName_detail

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName 

           , CASE WHEN tmpMI.AmountRemains <= 0
                       THEN 1118719 -- clRed
                  ELSE 0 -- clBlack
             END :: Integer AS Color_remains

           , 14862279 :: Integer AS ColorB_DayCountForecast -- $00E2C7C7
           , 11987626 :: Integer AS ColorB_AmountPartner    -- $00B6EAAA

           , tmpMI.isErased

       FROM (SELECT CASE WHEN inShowAll = TRUE THEN tmpMI_master.MovementItemId ELSE 0 END AS MovementItemId
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail
                  , SUM (tmpMI_master.Amount)       AS Amount
                  , SUM (tmpMI_master.AmountSecond) AS AmountSecond
                  , SUM (tmpMI_master.CuterCount)   AS CuterCount

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
                  , tmpMI_master.GoodsId_basis
                  , tmpMI_master.GoodsKindId_complete

                  , MIN (COALESCE (tmpMIPartion_master.StartDate_old,  zc_DateEnd()))   AS StartDate_old
                  , MAX (COALESCE (tmpMIPartion_master.EndDate_old,    zc_DateStart())) AS EndDate_old
                  , MIN (COALESCE (tmpMIPartion_master.StartDate_next, zc_DateEnd()))   AS StartDate_next
                  , MAX (COALESCE (tmpMIPartion_master.EndDate_next,   zc_DateStart())) AS EndDate_next
                  , SUM (COALESCE (tmpMIPartion_master.AmountProduction_old, 0))  AS AmountProduction_old
                  , SUM (COALESCE (tmpMIPartion_master.AmountProduction_next, 0)) AS AmountProduction_next

                  , tmpMI_master.isErased
             FROM _tmpMI_master AS tmpMI_master
                  LEFT JOIN tmpMIPartion_master ON tmpMIPartion_master.MovementItemId = tmpMI_master.MovementItemId
             GROUP BY CASE WHEN inShowAll = TRUE THEN tmpMI_master.MovementItemId ELSE 0 END
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , tmpMI_master.GoodsId
                  , tmpMI_master.GoodsId_basis
                  , tmpMI_master.GoodsKindId_complete

                  , tmpMI_master.isErased
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods_detail ON Object_Goods_detail.Id = tmpMI.GoodsId_detail
            LEFT JOIN Object AS Object_GoodsKind_detail ON Object_GoodsKind_detail.Id = tmpMI.GoodsKindId_detail
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_detail
                                 ON ObjectLink_Goods_Measure_detail.ObjectId = Object_Goods_detail.Id
                                AND ObjectLink_Goods_Measure_detail.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_detail ON Object_Measure_detail.Id = ObjectLink_Goods_Measure_detail.ChildObjectId

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
 
            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmpMI.GoodsId_basis
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId_complete

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure_basis.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS OrderType_Unit
                                 ON OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = OrderType_Unit.ChildObjectId
          ;

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
        WITH tmpMI_master_find AS (SELECT MAX (tmpMI_master.MovementItemId) AS MovementItemId, tmpMI_master.GoodsId_basis, tmpMI_master.GoodsKindId_complete
                                   FROM _tmpMI_master AS tmpMI_master
                                   WHERE tmpMI_master.isErased = FALSE
                                   GROUP BY tmpMI_master.GoodsId_basis, tmpMI_master.GoodsKindId_complete
                                  )
       SELECT
             _tmpMI_child.MovementItemId         AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKindComplete.Id         AS GoodsKindId_complete
           , Object_GoodsKindComplete.ValueData  AS GoodsKindName_complete
           , Object_Measure.ValueData            AS MeasureName
           , _tmpMI_child.PartionGoodsDate
           , _tmpMI_child.Amount
           , CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                       THEN _tmpMI_child.Amount
                  ELSE 0
             END AS Amount_old
           , CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - tmpMI_master.TermProduction :: Integer)
                       THEN _tmpMI_child.Amount
                  ELSE 0
             END AS Amount_next
           , _tmpMI_child.ContainerId
           , FALSE AS isErased
       FROM _tmpMI_child
             LEFT JOIN tmpMI_master_find ON tmpMI_master_find.GoodsId_basis = _tmpMI_child.GoodsId
                                        AND tmpMI_master_find.GoodsKindId_complete = _tmpMI_child.GoodsKindId_complete
             LEFT JOIN _tmpMI_master AS tmpMI_master ON tmpMI_master.MovementItemId = tmpMI_master_find.MovementItemId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpMI_child.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpMI_child.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpMI_child.GoodsKindId_complete

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = _tmpMI_child.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
       ;
       RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
