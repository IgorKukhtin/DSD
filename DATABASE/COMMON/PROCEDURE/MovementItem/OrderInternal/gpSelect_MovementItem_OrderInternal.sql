-- Function: gpSelect_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderInternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountSecond TFloat
             , AmountRemains TFloat, AmountPartnerPrior TFloat, AmountPartner TFloat, AmountForecast TFloat, AmountForecastOrder TFloat
             , CountForecast TFloat, CountForecastOrder TFloat, CountForecastK TFloat, CountForecastOrderK TFloat
             , DayCountForecast TFloat, DayCountForecastOrder TFloat
             , Koeff TFloat, TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat
             , CuterCount TFloat
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , ContainerId TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDayCount Integer;
   DECLARE vbMonth Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     --
     SELECT 1 + EXTRACT (DAY FROM (MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
            INTO vbDayCount, vbMonth
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     IF inShowAll THEN

     RETURN QUERY
       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountSecond
           , CAST (NULL AS TFloat)      AS AmountRemains
           , CAST (NULL AS TFloat)      AS AmountPartnerPrior
           , CAST (NULL AS TFloat)      AS AmountPartner 

           , CAST (NULL AS TFloat)      AS AmountForecast
           , CAST (NULL AS TFloat)      AS AmountForecastOrder
           , CAST (NULL AS TFloat)      AS CountForecast
           , CAST (NULL AS TFloat)      AS CountForecastOrder
           , CAST (NULL AS TFloat)      AS CountForecastK
           , CAST (NULL AS TFloat)      AS CountForecastOrderK

           , CAST (NULL AS TFloat)      AS DayCountForecast
           , CAST (NULL AS TFloat)      AS DayCountForecastOrder

           , CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END :: TFloat AS Koeff
           , ObjectFloat_TermProduction.ValueData        AS TermProduction
           , ObjectFloat_NormInDays.ValueData            AS NormInDays 
           , ObjectFloat_StartProductionInDays.ValueData AS StartProductionInDays 

           , CAST (NULL AS TFloat)      AS CuterCount

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , CAST (NULL AS Integer)     AS ReceiptId
           , CAST (NULL AS TVarChar)    AS ReceiptCode
           , CAST (NULL AS TVarChar)    AS ReceiptName

           , Object_Unit.Id             AS UnitId
           , Object_Unit.ObjectCode     AS UnitCode
           , Object_Unit.ValueData      AS UnitName 

           , CAST (NULL AS TFloat)     AS ContainerId

           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , zc_Enum_GoodsKind_Main()  AS GoodsKindId
                  -- , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE

             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = tmpGoods.GoodsId
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                  ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                 AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                             WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                             WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                             WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                             WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                             WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                             WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                             WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                             WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                             WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                             WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                             WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                END
           LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                               ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
           LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                               ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays() 
           LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                               ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 
           LEFT JOIN ObjectLink AS OrderType_Unit
                                ON OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                               AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = OrderType_Unit.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , MovementItem.Amount                AS Amount
           , MIFloat_AmountSecond.ValueData     AS AmountSecond

           , MIFloat_AmountRemains.ValueData        AS AmountRemains
           , MIFloat_AmountPartnerPrior.ValueData   AS AmountPartnerPrior
           , MIFloat_AmountPartner.ValueData        AS AmountPartner
           , MIFloat_AmountForecast.ValueData       AS AmountForecast
           , MIFloat_AmountForecastOrder.ValueData  AS AmountForecastOrder

           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END AS NUMERIC (16, 2))) :: TFloat AS CountForecast
           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END AS NUMERIC (16, 2))) :: TFloat AS CountForecastOrder
           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS CountForecastK
           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS CountForecastOrderK

           , (CAST (CASE WHEN (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END) > 0
                              THEN MIFloat_AmountRemains.ValueData
                                / (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END)
                          ELSE 0
                    END
              AS NUMERIC (16, 1))) :: TFloat AS DayCountForecast
           , (CAST (CASE WHEN (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END) > 0
                              THEN MIFloat_AmountRemains.ValueData
                                / (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END)
                          ELSE 0
                    END
              AS NUMERIC (16, 1))) :: TFloat AS DayCountForecastOrder

           , CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END :: TFloat AS Koeff
           , ObjectFloat_TermProduction.ValueData        AS TermProduction
           , ObjectFloat_NormInDays.ValueData            AS NormInDays 
           , ObjectFloat_StartProductionInDays.ValueData AS StartProductionInDays 

           , MIFloat_CuterCount.ValueData        AS CuterCount
           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.ValueData            AS MeasureName
           , Object_Receipt.Id                   AS ReceiptId
           , ObjectString_Receipt_Code.ValueData AS ReceiptCode
           , Object_Receipt.ValueData            AS ReceiptName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , Object_Unit.ValueData               AS UnitName 

           , MIFloat_ContainerId.ValueData  AS ContainerId

           , MovementItem.isErased               AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

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

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                             ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                 AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = MovementItem.ObjectId
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                  ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                 AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                             WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                             WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                             WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                             WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                             WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                             WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                             WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                             WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                             WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                             WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                             WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                END
           LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                               ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
           LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                               ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays() 
           LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                               ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 
           LEFT JOIN ObjectLink AS OrderType_Unit
                                ON OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                               AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = OrderType_Unit.ChildObjectId
          ;

     ELSE

     RETURN QUERY
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , MovementItem.Amount                AS Amount
           , MIFloat_AmountSecond.ValueData     AS AmountSecond

           , MIFloat_AmountRemains.ValueData        AS AmountRemains
           , MIFloat_AmountPartnerPrior.ValueData   AS AmountPartnerPrior
           , MIFloat_AmountPartner.ValueData        AS AmountPartner
           , MIFloat_AmountForecast.ValueData       AS AmountForecast
           , MIFloat_AmountForecastOrder.ValueData  AS AmountForecastOrder

           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END AS NUMERIC (16, 2))) :: TFloat AS CountForecast
           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END AS NUMERIC (16, 2))) :: TFloat AS CountForecastOrder
           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS CountForecastK
           , (CAST (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS CountForecastOrderK

           , (CAST (CASE WHEN (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END) > 0
                              THEN MIFloat_AmountRemains.ValueData
                                / (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecast.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END)
                          ELSE 0
                    END
              AS NUMERIC (16, 1))) :: TFloat AS DayCountForecast
           , (CAST (CASE WHEN (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END) > 0
                              THEN MIFloat_AmountRemains.ValueData
                                / (CASE WHEN vbDayCount <> 0 THEN MIFloat_AmountForecastOrder.ValueData / vbDayCount ELSE 0 END * CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END)
                          ELSE 0
                    END
              AS NUMERIC (16, 1))) :: TFloat AS DayCountForecastOrder

           , CASE WHEN ObjectFloat_Koeff.ValueData > 0 THEN ObjectFloat_Koeff.ValueData ELSE 1 END :: TFloat AS Koeff
           , ObjectFloat_TermProduction.ValueData        AS TermProduction
           , ObjectFloat_NormInDays.ValueData            AS NormInDays 
           , ObjectFloat_StartProductionInDays.ValueData AS StartProductionInDays 

           , MIFloat_CuterCount.ValueData        AS CuterCount     
           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.ValueData            AS MeasureName
           , Object_Receipt.Id                   AS ReceiptId
           , ObjectString_Receipt_Code.ValueData AS ReceiptCode
           , Object_Receipt.ValueData            AS ReceiptName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , Object_Unit.ValueData               AS UnitName 

           , MIFloat_ContainerId.ValueData  AS ContainerId

           , MovementItem.isErased               AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                        ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                        ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                        ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                        ON MIFloat_CuterCount.MovementItemId = MovementItem.Id 
                                       AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                      
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                             ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = MovementItem.ObjectId
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                  ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                 AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                             WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                             WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                             WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                             WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                             WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                             WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                             WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                             WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                             WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                             WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                             WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                END
           LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                               ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
           LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                               ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays() 
           LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                               ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                              AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 
           LEFT JOIN ObjectLink AS OrderType_Unit
                                ON OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                               AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = OrderType_Unit.ChildObjectId
          ;
     END IF;

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
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderInternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
