-- Function: gpSelect_MI_SaleCommerc_Child (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_SaleCommerc_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_SaleCommerc_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , Amount TFloat, Summ TFloat
             , AmountPromo TFloat, SummPromo TFloat
             , AmountNoPromo TFloat, SummNoPromo TFloat
             , Bonus TFloat, Price TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , Object_Goods.Id                                        AS GoodsId
           , Object_Goods.ObjectCode                                AS GoodsCode
           , Object_Goods.ValueData                                 AS GoodsName
           , Object_GoodsKind.Id                                    AS GoodsKindId
           , Object_GoodsKind.ValueData                             AS GoodsKindName           
           , MovementItem.Amount                           ::TFloat AS Amount
           , COALESCE (MIFloat_Summ.ValueData, 0)          ::TFloat AS Summ
           , COALESCE (MIFloat_AmountPromo.ValueData, 0)   ::TFloat AS AmountPromo
           , COALESCE (MIFloat_SummPromo.ValueData, 0)     ::TFloat AS SummPromo
           , COALESCE (MIFloat_AmountNoPromo.ValueData, 0) ::TFloat AS AmountNoPromo
           , COALESCE (MIFloat_SummNoPromo.ValueData, 0)   ::TFloat AS SummNoPromo
           , COALESCE (MIFloat_Bonus.ValueData, 0)         ::TFloat AS Bonus
           , COALESCE (MIFloat_Price.ValueData, 0)         ::TFloat AS Price

           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPromo
                                        ON MIFloat_AmountPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPromo.DescId = zc_MIFloat_AmountPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_SummPromo
                                        ON MIFloat_SummPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummPromo.DescId = zc_MIFloat_SummPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountNoPromo
                                        ON MIFloat_AmountNoPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountNoPromo.DescId = zc_MIFloat_AmountNoPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_SummNoPromo
                                        ON MIFloat_SummNoPromo.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummNoPromo.DescId = zc_MIFloat_SummNoPromo()
            LEFT JOIN MovementItemFloat AS MIFloat_Bonus
                                        ON MIFloat_Bonus.MovementItemId = MovementItem.Id
                                       AND MIFloat_Bonus.DescId = zc_MIFloat_Bonus()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.26         * 
 
*/

-- тест
-- SELECT * FROM gpSelect_MI_SaleCommerc_Child (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')