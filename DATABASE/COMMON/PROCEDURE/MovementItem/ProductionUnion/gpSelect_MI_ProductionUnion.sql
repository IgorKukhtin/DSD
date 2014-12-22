-- Function: gpSelect_MI_ProductionUnion()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion(
    IN inMovementId          Integer,
    IN inShowAll             Boolean,
    IN inisErased            Boolean      , --
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_MovementItem_ProductionUnion());
   IF inShowAll THEN
    OPEN Cursor1 FOR
       SELECT
              0                                     AS Id
            , 0                                     AS LineNum
            , tmpGoods.GoodsId                      AS GoodsId
            , tmpGoods.GoodsCode                    AS GoodsCode
            , tmpGoods.GoodsName                    AS GoodsName
            , CAST (NULL AS TFloat)                 AS Amount

            , CAST (NULL AS Boolean)                AS PartionClose
            , CAST (NULL AS TVarchar)               AS PartionGoods

            , CAST (NULL AS TVarchar)               AS Comment
            , CAST (NULL AS TFloat)                 AS Count
            , CAST (NULL AS TFloat)                 AS RealWeight
            , CAST (NULL AS TFloat)                 AS CuterCount
            , CAST (NULL AS Integer)                AS GoodsKindId
            , CAST (NULL AS Integer)                AS GoodsKindCode
            , CAST (NULL AS TVarchar)               AS GoodsKindName
            , CAST (NULL AS Integer)                AS GoodsCompleteKindId
            , CAST (NULL AS Integer)                AS GoodsCompleteKindCode
            , CAST (NULL AS TVarchar)               AS GoodsCompleteKindName

            , CAST (NULL AS Integer)                AS ReceiptId
            , CAST (NULL AS Integer)                AS ReceiptCode
            , CAST (NULL AS TVarchar)               AS ReceiptName

           , FALSE                                  AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods()
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
--           , 0 AS LineNum
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , MovementItem.Amount               AS Amount

            , MIBoolean_PartionClose.ValueData  AS PartionClose
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Count.ValueData           AS Count
            , MIFloat_RealWeight.ValueData      AS RealWeight
            , MIFloat_CuterCount.ValueData      AS CuterCount

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_GoodsCompleteKind.Id         AS GoodsCompleteKindId
            , Object_GoodsCompleteKind.ObjectCode AS GoodsCompleteKindCode
            , Object_GoodsCompleteKind.ValueData  AS GoodsCompleteKindName

            , Object_Receipt.Id                 AS ReceiptId
            , Object_Receipt.ObjectCode         AS ReceiptCode
            , Object_Receipt.ValueData          AS ReceiptName

            , MovementItem.isErased             AS isErased


       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsCompleteKind
                                              ON MILO_GoodsCompleteKind.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsCompleteKind.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsCompleteKind ON Object_GoodsCompleteKind.Id = MILO_GoodsCompleteKind.ObjectId


             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

       ORDER BY 2--MovementItem.Id
            ;
    RETURN NEXT Cursor1;
   ELSE
    OPEN Cursor1 FOR
       SELECT
             MovementItem.Id					AS Id
           , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , MovementItem.Amount               AS Amount

            , MIBoolean_PartionClose.ValueData  AS PartionClose
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment
            , MIFloat_Count.ValueData           AS Count
            , MIFloat_RealWeight.ValueData      AS RealWeight
            , MIFloat_CuterCount.ValueData      AS CuterCount

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , Object_GoodsCompleteKind.Id         AS GoodsCompleteKindId
            , Object_GoodsCompleteKind.ObjectCode AS GoodsCompleteKindCode
            , Object_GoodsCompleteKind.ValueData  AS GoodsCompleteKindName

            , Object_Receipt.Id                 AS ReceiptId
            , Object_Receipt.ObjectCode         AS ReceiptCode
            , Object_Receipt.ValueData          AS ReceiptName

            , MovementItem.isErased             AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsCompleteKind
                                              ON MILO_GoodsCompleteKind.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsCompleteKind.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsCompleteKind ON Object_GoodsCompleteKind.Id = MILO_GoodsCompleteKind.ObjectId


             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()

             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor1;
   END IF;

    OPEN Cursor2 FOR

       SELECT
              MovementItem.Id					AS Id
            , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS INTEGER) AS  LineNum
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , MovementItem.Amount               AS Amount
            , MovementItem.ParentId             AS ParentId

            , MIFloat_AmountReceipt.ValueData   AS AmountReceipt

            , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
            , MIString_PartionGoods.ValueData   AS PartionGoods

            , MIString_Comment.ValueData        AS Comment

            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName

            , Object_GoodsCompleteKind.Id         AS GoodsCompleteKindId
            , Object_GoodsCompleteKind.ObjectCode AS GoodsCompleteKindCode
            , Object_GoodsCompleteKind.ValueData  AS GoodsCompleteKindName

            , Object_Receipt.Id                 AS ReceiptId
            , Object_Receipt.ObjectCode         AS ReceiptCode
            , Object_Receipt.ValueData          AS ReceiptName


            , MovementItem.isErased             AS isErased


       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId

             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                       AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                         AND MIString_PartionGoods.MovementItemId =  MovementItem.Id

             LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                         ON MIFloat_AmountReceipt.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsCompleteKind
                                              ON MILO_GoodsCompleteKind.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsCompleteKind.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsCompleteKind ON Object_GoodsCompleteKind.Id = MILO_GoodsCompleteKind.ObjectId


       ORDER BY MovementItem.Id
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_ProductionUnion (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 02.06.14                                                       *
 27.05.14                                                       * поменял все
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MI_ProductionUnion (inMovementId:= 1, inShowAll:= TRUE, inSession:= '2')
/*
BEGIN;
 select * from gpGet_Movement_ProductionUnion(inMovementId := 385717 , inOperDate := ('02.06.2014')::TDateTime ,  inSession := '5');
COMMIT;
*/