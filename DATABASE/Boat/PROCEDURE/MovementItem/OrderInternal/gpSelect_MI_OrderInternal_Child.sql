-- Function: gpSelect_MI_Send_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_Send_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Send_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Article TVarChar
             , Amount TFloat, AmountReserv TFloat, AmountSend TFloat 
             , UnitId Integer, UnitName TVarChar
             , isErased Boolean

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
 
        -- Результат
        SELECT MovementItem.Id
             , MovementItem.ParentId
             , MovementItem.GoodsId            AS GoodsId
             , Object_Goods.ObjectCode         AS GoodsCode
             , Object_Goods.ValueData          AS GoodsName
             , ObjectString_Article.ValueData  AS Article
             , MovementItem.Amount            ::TFloat AS Amount
             , MIFloat_AmountReserv.ValueData ::TFloat AS AmountReserv
             , MIFloat_AmountSend.ValueData   ::TFloat AS AmountSend
             , MovementItem.isErased

        FROM tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit() 
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountReserv
                                        ON MIFloat_AmountReserv.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountReserv.DescId = zc_MIFloat_AmountReserv()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSend
                                        ON MIFloat_AmountSend.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend()

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/

-- тест
-- SELECT * from gpSelect_MI_Send_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
