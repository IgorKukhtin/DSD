-- Function: gpSelect_Scale_Goods()

-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Goods (Boolean, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Goods(
    IN inIsGoodsComplete       Boolean  ,    -- склад ГП/производство/упаковка or обвалка
    IN inOperDate              TDateTime,
    IN inOrderExternalId       Integer,
    IN inPriceListId           Integer,
    IN inDayPrior_PriceReturn  Integer,
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , ChangePercentAmount TFloat
             , Amount_Order TFloat
             , Amount_OrderWeight TFloat
             , Amount_Weighing TFloat
             , Amount_WeighingWeight TFloat
             , Amount_diff TFloat
             , Amount_diffWeight TFloat
             , isTax_diff Boolean
             , Price TFloat
             , Price_Return TFloat
             , CountForPrice         TFloat
             , CountForPrice_Return  TFloat
             , Color_calc            Integer
             , isTare                Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   IF inOrderExternalId <> 0
   THEN
    -- Результат - по заявке
    RETURN QUERY
       WITH tmpMI_Order AS (SELECT MovementItem.ObjectId                                                AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, CASE WHEN inIsGoodsComplete = FALSE THEN 0 ELSE zc_Enum_GoodsKind_Main() END) AS GoodsKindId
                                 , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)   AS Amount
                                 , COALESCE (MIFloat_Price.ValueData, 0)                                AS Price
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , FALSE AS isTare
                            FROM MovementItem
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                             ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            WHERE MovementItem.MovementId = inOrderExternalId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           UNION
                            SELECT Object_Goods.Id AS GoodsId
                                 , CASE WHEN inIsGoodsComplete = FALSE THEN 0 ELSE zc_Enum_GoodsKind_Main() END  AS GoodsKindId
                                 , 0 AS Amount
                                 , 0 AS Price
                                 , 0 AS CountForPrice
                                 , TRUE AS isTare
                            FROM Object_InfoMoney_View AS View_InfoMoney
                                 INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ChildObjectId = View_InfoMoney.InfoMoneyId
                                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                 INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                                  AND Object_Goods.isErased = FALSE
                                                                  AND Object_Goods.ObjectCode > 0
                            WHERE View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                          , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                           )
                              AND vbUserId = 5

                           )
       , tmpMI_Weighing AS (SELECT MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                            FROM MovementLinkMovement
                                 INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId
                                                    AND Movement.DescId = zc_Movement_WeighingPartner()
                                                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            WHERE MovementLinkMovement.MovementChildId = inOrderExternalId
                              AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                           )
                , tmpMI AS (SELECT tmpMI.GoodsId
                                 , tmpMI.GoodsKindId
                                 , tmpMI.Amount AS Amount_Order
                                 , 0            AS Amount_Weighing
                                 , tmpMI.Price
                                 , tmpMI.CountForPrice
                                 , tmpMI.isTare
                            FROM tmpMI_Order AS tmpMI
                           UNION ALL
                            SELECT tmpMI.GoodsId
                                 , tmpMI.GoodsKindId
                                 , 0            AS Amount_Order
                                 , tmpMI.Amount AS Amount_Weighing
                                 , tmpMI.Price
                                 , tmpMI.CountForPrice
                                 , FALSE AS isTare
                            FROM tmpMI_Weighing AS tmpMI
                           )
       -- Результат - по заявке
       SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ValueData    AS MeasureName
            , CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN 1 ELSE 0 END :: TFloat AS ChangePercentAmount
            , tmpMI.Amount_Order :: TFloat    AS Amount_Order
            , (tmpMI.Amount_Order * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat    AS Amount_OrderWeight
            , tmpMI.Amount_Weighing :: TFloat AS Amount_Weighing
            , (tmpMI.Amount_Weighing * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS Amount_WeighingWeight
            , (tmpMI.Amount_Order - tmpMI.Amount_Weighing) :: TFloat AS Amount_diff
            , ((tmpMI.Amount_Order - tmpMI.Amount_Weighing)  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() THEN 1 WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 0 END) :: TFloat AS Amount_diffWeight
            , CASE WHEN tmpMI.Amount_Weighing > tmpMI.Amount_Order
                        THEN CASE WHEN tmpMI.Amount_Order = 0
                                       THEN TRUE
                                  WHEN (tmpMI.Amount_Weighing / tmpMI.Amount_Order * 100 - 100) > 2
                                       THEN TRUE
                                  ELSE FALSE
                             END
                        ELSE FALSE
              END :: Boolean AS isTax_diff
            , tmpMI.Price :: TFloat           AS Price
            , 0 :: TFloat                     AS Price_Return
            , tmpMI.CountForPrice :: TFloat   AS CountForPrice
            , 0 :: TFloat                     AS CountForPrice_Return

            , CASE WHEN (tmpMI.Amount_Order - tmpMI.Amount_Weighing) > 0
                        THEN 1118719 -- clRed
                   WHEN tmpMI.Amount_Weighing > tmpMI.Amount_Order
                        THEN CASE WHEN tmpMI.Amount_Order = 0
                                       THEN 16711680 -- clBlue
                                  WHEN (tmpMI.Amount_Weighing / tmpMI.Amount_Order * 100 - 100) > 2
                                       THEN 16711680 -- clBlue
                                  ELSE 0 -- clBlack
                             END
                   ELSE 0 -- clBlack
              END :: Integer AS Color_calc

            , tmpMI.isTare

       FROM (SELECT tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , SUM (tmpMI.Amount_Order)    AS Amount_Order
                  , SUM (tmpMI.Amount_Weighing) AS Amount_Weighing
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                  , tmpMI.isTare
             FROM tmpMI
             GROUP BY tmpMI.GoodsId
                    , tmpMI.GoodsKindId
                    , tmpMI.Price
                    , tmpMI.CountForPrice
                    , tmpMI.isTare
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       ORDER BY Object_Goods.ValueData
              , Object_GoodsKind.ValueData
              -- , ObjectString_Goods_GoodsGroupFull.ValueData
      ;
   ELSE
    -- Результат - все товары
    RETURN QUERY
       WITH tmpInfoMoney AS (SELECT View_InfoMoney.InfoMoneyId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                             WHERE inIsGoodsComplete = TRUE
                               AND View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна + Ирна
                                                                , zc_Enum_InfoMoney_30101() -- Доходы + Готовая продукция
                                                                , zc_Enum_InfoMoney_30102() -- Доходы + Тушенка
                                                                , zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье
                                                                 )
                            UNION
                             SELECT View_InfoMoney.InfoMoneyId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                             WHERE inIsGoodsComplete = FALSE
                               AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                            )
                            UNION
                             SELECT View_InfoMoney.InfoMoneyId
                             FROM Object_InfoMoney_View AS View_InfoMoney
                             WHERE View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                           , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                            )
                            )
       SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , tmpGoods.GoodsId            AS GoodsId
            , tmpGoods.GoodsCode          AS GoodsCode
            , tmpGoods.GoodsName          AS GoodsName
            , Object_GoodsKind.Id         AS GoodsKindId
            , Object_GoodsKind.ObjectCode AS GoodsKindCode
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ValueData    AS MeasureName
            , CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN 1 ELSE 0 END :: TFloat AS ChangePercentAmount
            , 0 :: TFloat AS Amount_Order
            , 0 :: TFloat AS Amount_OrderWeight
            , 0 :: TFloat AS Amount_Weighing
            , 0 :: TFloat AS Amount_WeighingWeight
            , 0 :: TFloat AS Amount_diff
            , 0 :: TFloat AS Amount_diffWeight
            , FALSE :: Boolean AS isTax_diff
            , lfObjectHistory_PriceListItem.ValuePrice :: TFloat                        AS Price
            , lfObjectHistory_PriceListItem_Return.ValuePrice :: TFloat                 AS Price_Return
            , 1 :: TFloat                 AS CountForPrice
            , 1 :: TFloat                 AS CountForPrice_Return
            , 0                           AS Color_calc -- clBlack
            , FALSE                       AS isTare
       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
             FROM tmpInfoMoney
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = tmpInfoMoney.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                                             AND Object_Goods.ObjectCode <> 0
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND 1=0
            ) AS tmpGoods

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inOperDate - (inDayPrior_PriceReturn :: TVarChar || ' DAY') :: INTERVAL)
                   AS lfObjectHistory_PriceListItem_Return ON lfObjectHistory_PriceListItem_Return.GoodsId = tmpGoods.GoodsId

       ORDER BY tmpGoods.GoodsName
              -- , ObjectString_Goods_GoodsGroupFull.ValueData
      ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Scale_Goods (Boolean, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Goods (inIsGoodsComplete:= TRUE, inOperDate:= '01.01.2015', inOrderExternalId:=0, inPriceListId:=0, inDayPrior_PriceReturn:= 10, inSession:=zfCalc_UserAdmin())
