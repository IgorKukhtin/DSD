-- Function: gpGet_Movement_ProductionUnionTech()

DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnionTech (Integer, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnionTech(
    IN inMovementId           Integer,       -- ключ
    IN inOperDate             TDateTime,     -- дата Документа
    IN inMovementItemId       Integer,       -- ключ
    IN inMovementItemId_order Integer,       -- ключ
    IN inFromId               Integer,       -- ключ
    IN inToId                 Integer,       -- ключ
    IN inSession              TVarChar       -- сессия пользователя

)
RETURNS TABLE (MovementId Integer, OperDate TDateTime
             , FromId Integer, ToId Integer
             , MovementItemId Integer
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsKindCompleteId Integer, GoodsKindCompleteName TVarChar
             , ReceiptId Integer, ReceiptName TVarChar, ReceiptCode TVarChar
             , Amount_order TFloat, CuterCount_order TFloat
             , RealWeight TFloat, RealWeightMsg TFloat, RealWeightShp TFloat
             , CuterCount TFloat, CuterWeight TFloat, Count TFloat, CountReal TFloat
             , Amount TFloat, AmountForm TFloat, AmountForm_two TFloat
             , Comment TVarChar
               )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnionTech());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0 AND inMovementItemId_order <> 0
     THEN
          RETURN QUERY
          SELECT 0                                  AS MovementId
               , inOperDate                         AS OperDate
               , MLO_To.ObjectId		            AS FromId
               , MLO_To.ObjectId                    AS ToId

               , 0                                   AS MovementItemId
               , Object_Goods.Id                     AS GoodsId
               , Object_Goods.ValueData              AS GoodsName
               , Object_GoodsKind.Id                 AS GoodsKindId
               , Object_GoodsKind.ValueData          AS GoodsKindName
               , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
               , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete

               , Object_Receipt.Id                   AS ReceiptId
               , Object_Receipt.ValueData            AS ReceiptName
               , ObjectString_Receipt_Code.ValueData AS ReceiptCode

               , (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) :: TFloat AS Amount_order
               , (COALESCE (MIFloat_CuterCount.ValueData, 0)  + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)) :: TFloat AS CuterCount_order

               , 0 :: TFloat		           AS RealWeight
               , 0 :: TFloat		           AS RealWeightMsg
               , 0 :: TFloat		           AS RealWeightShp
               , 0 :: TFloat   		           AS CuterCount
               , 0 :: TFloat   		           AS CuterWeight
               , 0 :: TFloat		           AS Count
               , 0 :: TFloat		           AS CountReal
               , 0 :: TFloat		           AS Amount
               , 0 :: TFloat                   AS AmountForm
               , 0 :: TFloat                   AS AmountForm_two
               , '' :: TVarChar                AS Comment

          FROM MovementItem
               LEFT JOIN MovementLinkObject AS MLO_To
                                            ON MLO_To.MovementId = MovementItem.MovementId
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
               LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
               LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                           ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                          AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
               LEFT JOIN MovementItemFloat AS MIFloat_CuterCountSecond
                                           ON MIFloat_CuterCountSecond.MovementItemId = MovementItem.Id
                                          AND MIFloat_CuterCountSecond.DescId = zc_MIFloat_CuterCountSecond()
               LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                                ON MILO_Goods.MovementItemId = MovementItem.Id
                                               AND MILO_Goods.DescId = zc_MILinkObject_Goods()
               LEFT JOIN MovementItemLinkObject AS MILO_ReceiptBasis
                                                ON MILO_ReceiptBasis.MovementItemId = MovementItem.Id
                                               AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
               LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                      ON ObjectString_Receipt_Code.ObjectId = MILO_ReceiptBasis.ObjectId
                                     AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = MILO_ReceiptBasis.ObjectId
                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                    ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = MILO_ReceiptBasis.ObjectId
                                   AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId
               LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis())
               LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILO_ReceiptBasis.ObjectId

          WHERE MovementItem.Id = inMovementItemId_order;

     ELSE
     IF inMovementItemId <> 0
     THEN
          RETURN QUERY
          SELECT MovementItem.MovementId             AS MovementId
               , Movement.OperDate                   AS OperDate
               , MLO_From.ObjectId		     AS FromId
               , MLO_To.ObjectId                     AS ToId

               , MovementItem.Id                     AS MovementItemId
               , Object_Goods.Id                     AS GoodsId
               , Object_Goods.ValueData              AS GoodsName
               , Object_GoodsKind.Id                 AS GoodsKindId
               , Object_GoodsKind.ValueData          AS GoodsKindName
               , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
               , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete

               , Object_Receipt.Id                   AS ReceiptId
               , Object_Receipt.ValueData            AS ReceiptName
               , ObjectString_Receipt_Code.ValueData AS ReceiptCode

               , (MovementItem_Order.Amount + COALESCE (MIFloat_AmountSecond_order.ValueData, 0)) :: TFloat AS Amount_order
               , COALESCE (MIFloat_CuterCount_order.ValueData, 0) :: TFloat                                 AS CuterCount_order

               , MIFloat_RealWeight.ValueData      AS RealWeight
               , MIFloat_RealWeightMsg.ValueData   AS RealWeightMsg
               , MIFloat_RealWeightShp.ValueData   AS RealWeightShp
               , MIFloat_CuterCount.ValueData      AS CuterCount
               , MIFloat_CuterWeight.ValueData     AS CuterWeight
               , MIFloat_Count.ValueData	       AS Count
               , MIFloat_CountReal.ValueData       AS CountReal
               , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN MovementItem.Amount ELSE 0 END :: TFloat AS Amount
               , MIFloat_AmountForm.ValueData     ::TFloat AS AmountForm
               , MIFloat_AmountForm_two.ValueData ::TFloat AS AmountForm_two
               , MIString_Comment.ValueData        AS Comment

          FROM MovementItem
               LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
               LEFT JOIN MovementLinkObject AS MLO_From
                                            ON MLO_From.MovementId = MovementItem.MovementId
                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN MovementLinkObject AS MLO_To
                                            ON MLO_To.MovementId = MovementItem.MovementId
                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
               LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                ON MILO_Receipt.MovementItemId = MovementItem.Id
                                               AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
               LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                               AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

               LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                      ON ObjectString_Receipt_Code.ObjectId = MILO_Receipt.ObjectId
                                     AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId
               LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
               LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILO_Receipt.ObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                    ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

               LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                           ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                          AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
               LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                           ON MIFloat_CuterWeight.MovementItemId = MovementItem.Id
                                          AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()
               LEFT JOIN MovementItemFloat AS MIFloat_Count
                                           ON MIFloat_Count.MovementItemId = MovementItem.Id
                                          AND MIFloat_Count.DescId = zc_MIFloat_Count()
               LEFT JOIN MovementItemFloat AS MIFloat_CountReal
                                           ON MIFloat_CountReal.MovementItemId = MovementItem.Id
                                          AND MIFloat_CountReal.DescId = zc_MIFloat_CountReal()
               LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                           ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                          AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
               LEFT JOIN MovementItemFloat AS MIFloat_RealWeightMsg
                                           ON MIFloat_RealWeightMsg.MovementItemId = MovementItem.Id
                                          AND MIFloat_RealWeightMsg.DescId = zc_MIFloat_RealWeightMsg()
               LEFT JOIN MovementItemFloat AS MIFloat_RealWeightShp
                                           ON MIFloat_RealWeightShp.MovementItemId = MovementItem.Id
                                          AND MIFloat_RealWeightShp.DescId = zc_MIFloat_RealWeightShp()
               LEFT JOIN MovementItemFloat AS MIFloat_AmountForm
                                           ON MIFloat_AmountForm.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountForm.DescId = zc_MIFloat_AmountForm()
               LEFT JOIN MovementItemFloat AS MIFloat_AmountForm_two
                                           ON MIFloat_AmountForm_two.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountForm_two.DescId = zc_MIFloat_AmountForm_two()

               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MovementItem AS MovementItem_Order ON MovementItem_Order.Id = inMovementItemId_order
               LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond_order
                                           ON MIFloat_AmountSecond_order.MovementItemId = MovementItem_Order.Id
                                          AND MIFloat_AmountSecond_order.DescId = zc_MIFloat_AmountSecond()
               LEFT JOIN MovementItemFloat AS MIFloat_CuterCount_order
                                           ON MIFloat_CuterCount_order.MovementItemId = MovementItem_Order.Id
                                          AND MIFloat_CuterCount_order.DescId = zc_MIFloat_CuterCount()

          WHERE MovementItem.Id = inMovementItemId;

     ELSE
          RETURN QUERY
          SELECT 0                               AS MovementId
               , inOperDate                      AS OperDate
               , inFromId	                     AS FromId
               , inToId                          AS ToId

               , 0                               AS MovementItemId
               , 0                               AS GoodsId
               , '' :: TVarChar                  AS GoodsName
               , 0                               AS GoodsKindId
               , '' :: TVarChar                  AS GoodsKindName
               , 0                               AS GoodsKindId_Complete
               , '' :: TVarChar                  AS GoodsKindName_Complete

               , 0                               AS ReceiptId
               , '' :: TVarChar                  AS ReceiptName
               , '' :: TVarChar                  AS ReceiptCode

               , 0 :: TFloat		             AS Amount_order
               , 0 :: TFloat		             AS CuterCount_order

               , 0 :: TFloat		             AS RealWeight
               , 0 :: TFloat		             AS RealWeightMsg
               , 0 :: TFloat		             AS RealWeightShp
               , 0 :: TFloat   		             AS CuterCount
               , 0 :: TFloat   		             AS CuterWeight
               , 0 :: TFloat		             AS Count
               , 0 :: TFloat		             AS CountReal
               , 0 :: TFloat		             AS Amount
               , 0 :: TFloat                     AS AmountForm
               , 0 :: TFloat                     AS AmountForm_two
               , '' :: TVarChar                  AS Comment
         ;

     END IF;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.03.25         * AmountForm_two
 30.07.24         * AmountForm
 13.02.22         *
 02.12.20         *
 13.06.16         * CuterWeight
 15.03.15                                        * all
 12.12.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ProductionUnionTech (inMovementId := 0, inOperDate := '01.01.2014', inMovementItemId:= 0, inMovementItemId_order:= 0, inFromId:=0, inToId:=0, inSession:= '2')
