-- Function: gpSelect_MI_MarginCategory()

DROP FUNCTION IF EXISTS gpSelect_MI_MarginCategory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_MarginCategory(
    IN inMovementId          Integer,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

    OPEN Cursor1 FOR
       SELECT
              MovementItem.Id			AS Id
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.GoodsCodeInt         AS GoodsCode
            , Object_Goods.GoodsName            AS GoodsName
            , Object_Goods.GoodsGroupName
 
            , Object_Goods.isClose
            , Object_Goods.isTOP
            , Object_Goods.isFirst
            , Object_Goods.isSecond

            , MovementItem.Amount               AS Amount
            , MIFloat_Amount.ValueData          AS AmountAnalys
            , MIString_Comment.ValueData        AS Comment
            
            , MovementItem.isErased             AS isErased
            
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                         ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                        AND MIFloat_Amount.DescId = zc_MIFloat_Amount()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()
           ;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR

       SELECT
              MovementItem.Id	                AS Id
            , MovementItem.ParentId	        AS ParentId
            , Object_MarginCategory.Id          AS MarginCategoryId
            , Object_MarginCategory.ValueData   AS MarginCategoryName
            
            , MovementItem.Amount               AS Amount
            , MIString_Comment.ValueData        AS Comment
           
            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = MovementItem.ObjectId
             LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                         ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                        AND MIFloat_Amount.DescId = zc_MIFloat_Amount()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.11.17         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_MarginCategory (inMovementId:= 1, inisErased:= FALSE, inSession:= '2')
