-- Function: gpSelect_MovementItem_ChangePercent()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChangePercent (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ChangePercent (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ChangePercent(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, CountForPrice TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar, MeasureName TVarChar
             , AmountSumm TFloat
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

       SELECT
             MovementItem.Id				AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
           , Object_Goods.Id          			AS GoodsId
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData   			AS GoodsName
           , MovementItem.Amount			    AS Amount
           , MIFloat_Price.ValueData 			AS Price
           , MIFloat_CountForPrice.ValueData 	AS CountForPrice

           , Object_GoodsKind.Id        		AS GoodsKindId
           , Object_GoodsKind.ValueData 		AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)		AS AmountSumm

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

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ChangePercent (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')
