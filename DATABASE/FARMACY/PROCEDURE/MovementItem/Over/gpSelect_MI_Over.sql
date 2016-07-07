-- Function: gpSelect_MI_Over()

DROP FUNCTION IF EXISTS gpSelect_MI_Over (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Over(
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

            , MovementItem.Amount               AS Amount

            , MIDate_MinExpirationDate.ValueData AS MinExpirationDate

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Remains.ValueData         AS Remains
            , MIFloat_Price.ValueData           AS Price
            , MIFloat_MCS.ValueData             AS MCS

            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

             LEFT JOIN MovementItemFloat AS MIFloat_MCS
                                         ON MIFloat_MCS.MovementItemId = MovementItem.Id
                                        AND MIFloat_MCS.DescId = zc_MIFloat_MCS()
           
             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemDate AS MIDate_MinExpirationDate
                                        ON MIDate_MinExpirationDate.MovementItemId =  MovementItem.Id
                                       AND MIDate_MinExpirationDate.DescId = zc_MIDate_MinExpirationDate()
           ;

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR

       SELECT
              MovementItem.Id	                AS Id
            , MovementItem.ParentId	        AS ParentId
            , Object_Unit.Id                    AS UnitId
            , Object_Unit.ValueData             AS UnitName
            
            , MovementItem.Amount               AS Amount

            , MIDate_MinExpirationDate.ValueData AS MinExpirationDate

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Remains.ValueData         AS Remains
            , MIFloat_Price.ValueData           AS Price
            , MIFloat_MCS.ValueData             AS MCS

            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

             LEFT JOIN MovementItemFloat AS MIFloat_MCS
                                         ON MIFloat_MCS.MovementItemId = MovementItem.Id
                                        AND MIFloat_MCS.DescId = zc_MIFloat_MCS()
           
             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemDate AS MIDate_MinExpirationDate
                                        ON MIDate_MinExpirationDate.MovementItemId =  MovementItem.Id
                                       AND MIDate_MinExpirationDate.DescId = zc_MIDate_MinExpirationDate()
       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.07.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_Over (inMovementId:= 1, inisErased:= FALSE, inSession:= '2')
