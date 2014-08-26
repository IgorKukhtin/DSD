-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      , -- ключ Прайс листа
    IN inOperDate    TDateTime    , -- Дата документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountSecond TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , Price TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSumm_Partner TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;
     IF (inPriceListId = 0) THEN inPriceListId := zc_PriceList_Basis();  END IF;

     IF inShowAll THEN

     RETURN QUERY
       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountSecond
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Measure.ValueData   AS MeasureName
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           , CAST (1 AS TFloat)         AS CountForPrice
           , CAST (NULL AS TFloat)      AS AmountSumm
           , CAST (NULL AS TFloat)      AS AmountSumm_Partner
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
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= inOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_AmountSecond.ValueData     AS AmountSecond
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , MIFloat_Price.ValueData            AS Price
           , MIFloat_CountForPrice.ValueData    AS CountForPrice
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)               AS AmountSumm
           , MIFloat_Summ.ValueData             AS AmountSumm_Partner
           , MovementItem.isErased              AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            ;

     ELSE

     RETURN QUERY
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_AmountSecond.ValueData     AS AmountSecond
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , MIFloat_Price.ValueData            AS Price
           , MIFloat_CountForPrice.ValueData    AS CountForPrice
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( ( COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( ( COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)               AS AmountSumm
           , MIFloat_Summ.ValueData             AS AmountSumm_Partner

           , MovementItem.isErased              AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.08.14                                                        *
 18.08.14                                                        *
 06.06.14                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
