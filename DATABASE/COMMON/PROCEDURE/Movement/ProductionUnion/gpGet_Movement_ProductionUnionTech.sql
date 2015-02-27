-- Function: gpGet_Movement_ProductionUnionTech()
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnionTech (Integer, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnionTech (Integer, Integer, TDateTime, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnionTech(
    IN inId          Integer,       -- ключ Документа
    IN inMIOrderId   Integer,       -- ключ
    IN inOperDate    TDateTime,     -- дата Документа
    IN inFromId      Integer,
    IN inToId        Integer,
    IN inSession     TVarChar       -- сессия пользователя

)
RETURNS TABLE (Id Integer, /*InvNumber TVarChar,*/ OperDate TDateTime
--             , StatusCode Integer, StatusName TVarChar
--             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsKindCompleteId Integer, GoodsKindCompleteName TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , Comment TVarChar
             , /*Amount TFloat,*/ Count TFloat, RealWeight TFloat,  CuterCount TFloat
             , AmountOrder TFloat,  CuterCountOrder TFloat
             , isErased boolean

               )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId := inSession;
     IF COALESCE (inId, 0) = 0
     THEN
     RETURN QUERY
     SELECT
              0                                                     AS Id
--            , CAST (NEXTVAL ('movement_productionunion_seq') AS TVarChar) AS InvNumber
            , inOperDate                                            AS OperDate
/*
            , Object_Status.Code                                    AS StatusCode
            , Object_Status.Name                                    AS StatusName
            , COALESCE (inFromId, 0)  				                AS FromId
            , COALESCE (Object_From.ValueData,'') 	                AS FromName
            , COALESCE (inToId, 0)   		                        AS ToId
            , COALESCE (Object_To.ValueData,'')                     AS ToName
*/
            , 0   		                                            AS GoodsId
            , 0   		                                            AS GoodsCode
            , CAST ('' AS TVarChar) 				                AS GoodsName
            , 0   		                                            AS GoodsKindId
            , CAST ('' AS TVarChar) 				                AS GoodsKindName

            , CAST (COALESCE(Object_GoodsKind.Id , 0) AS Integer)          AS GoodsKindCompleteId
            , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)  AS GoodsKindCompleteName

            , 0   		                                            AS ReceiptId
            , CAST ('' AS TVarChar)                                 AS ReceiptCode
            , CAST ('' AS TVarChar) 				                AS ReceiptName
            , CAST ('' AS TVarChar) 				                AS Comment
---            , 0   		                                            AS Amount
            , CAST (0 AS TFloat)		                            AS Count
            , CAST (0 AS TFloat)		                            AS RealWeight
            , CAST (0 AS TFloat)   		                            AS CuterCount
            , CAST (COALESCE(MI_Order.Amount,0) + COALESCE(MIF_AmountSecond.ValueData, 0) AS TFloat)  AS AmountOrder
            , CAST (COALESCE(MIF_CuterCountOrder.ValueData, 0) AS TFloat)                             AS CuterCountOrder
            , False                                                 AS isErased


     FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status

     LEFT JOIN Object AS Object_From ON Object_From.Id = inFromId

     LEFT JOIN Object AS Object_To ON Object_To.Id = inToId

     LEFT JOIN MovementItem AS MI_Order
            ON MI_Order.Id         = inMIOrderId
           AND MI_Order.DescId     = zc_MI_Master()

     LEFT JOIN MovementItemFloat AS MIF_AmountSecond
            ON MIF_AmountSecond.MovementItemId = MI_Order.Id
           AND MIF_AmountSecond.DescId = zc_MIFloat_AmountSecond()

     LEFT JOIN MovementItemFloat AS MIF_CuterCountOrder
            ON MIF_CuterCountOrder.MovementItemId = MI_Order.Id
           AND MIF_CuterCountOrder.DescId = zc_MIFloat_CuterCount()

     LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
            ON MILO_GoodsKind.MovementItemId = MI_Order.Id
           AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

     LEFT JOIN Object AS Object_GoodsKind
            ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId
    ;

     ELSE
     RETURN QUERY
     SELECT
              Movement.Id
--            , Movement.InvNumber
            , Movement.OperDate
/*
            , Object_Status.ObjectCode                              AS StatusCode
            , Object_Status.ValueData                               AS StatusName
            , Object_From.Id                                        AS FromId
            , Object_From.ValueData                                 AS FromName
            , Object_To.Id                                          AS ToId
            , Object_To.ValueData                                   AS ToName
*/

            , Object_Goods.Id                                       AS GoodsId
            , Object_Goods.ObjectCode                               AS GoodsCode
            , Object_Goods.ValueData                                AS GoodsName
            , Object_GoodsKind.Id                                   AS GoodsKindId
            , Object_GoodsKind.ValueData                            AS GoodsKindName

            , Object_GoodsKindComplete.Id                           AS GoodsKindCompleteId
            , Object_GoodsKindComplete.ValueData                    AS GoodsKindCompleteName

            , Object_Receipt.Id                                     AS ReceiptId
            , ObjectString_Code.ValueData                           AS ReceiptCode
            , Object_Receipt.ValueData                              AS ReceiptName
            , MIString_Comment.ValueData                            AS Comment
--            , MovementItem.Amount                                   AS Amount
--            , MIBoolean_PartionClose.ValueData                      AS PartionClose
--            , MIString_PartionGoods.ValueData                       AS PartionGoods
            , MIFloat_Count.ValueData                               AS Count
            , MIFloat_RealWeight.ValueData                          AS RealWeight
            , MIFloat_CuterCount.ValueData                          AS CuterCount

            , CAST (COALESCE(MI_Order.Amount,0) + COALESCE(MIF_AmountSecond.ValueData, 0) AS TFloat) AS AmountOrder
            , CAST (COALESCE(MIF_CuterCountOrder.ValueData, 0) AS TFloat)                            AS CuterCountOrder

            , MovementItem.isErased                                 AS isErased


     FROM    MovementItem
             JOIN Movement ON Movement.Id = MovementItem.MovementId
                          AND Movement.DescId = zc_Movement_ProductionUnion()

             LEFT JOIN MovementItem AS MI_Order
                    ON MI_Order.Id         = inMIOrderId
                   AND MI_Order.DescId     = zc_MI_Master()
             LEFT JOIN MovementItemFloat AS MIF_AmountSecond ON MIF_AmountSecond.MovementItemId = MI_Order.Id
                   AND MIF_AmountSecond.DescId = zc_MIFloat_AmountSecond()
             LEFT JOIN MovementItemFloat AS MIF_CuterCountOrder ON MIF_CuterCountOrder.MovementItemId = MI_Order.Id
                   AND MIF_CuterCountOrder.DescId = zc_MIFloat_CuterCount()


             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
--                              AND MovementItem.isErased   = tmpIsErased.isErased

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId
             LEFT JOIN ObjectString AS ObjectString_Code
                                    ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                   AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()


             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                              ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId


             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()

             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

             LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                         ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = MovementItem.Id
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

/*
             LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                           ON MIBoolean_PartionClose.MovementItemId = MovementItem.Id
                                          AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()
             LEFT JOIN MovementItemString AS MIString_PartionGoods
                                          ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                         AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
*/
     WHERE  MovementItem.DescId     = zc_MI_Master()
       AND  MovementItem.Id         = inId
       ;


     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpGet_Movement_ProductionUnionTech (Integer, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.12.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ProductionUnionTech (inMovementId := 0, inOperDate := '01.01.2014', inSession:= '2')