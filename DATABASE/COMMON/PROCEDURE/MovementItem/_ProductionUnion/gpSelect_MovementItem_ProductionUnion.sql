-- Function: gpSelect_MovementItem_ProductionUnion()

--DROP FUNCTION gpSelect_MovementItem_ProductionUnion();

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProductionUnion(
IN inMovementId          Integer,       
IN inShowAll             Boolean,
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS SETOF refcursor AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());


    OPEN Cursor1 FOR 
        SELECT 
          MovementItem.Id,
          MovementItem.ObjectId,
          Object_Goods.ObjectCode  AS GoodsCode,
          Object_Goods.ValueData   AS GoodsName,
          MovementItem.Amount,
          MovementItem.isErased,
          Object_Receipt.ValueData AS ReceiptName,
          Object_Partion.ValueData AS PartionName,
          MovementItemFloat_Count.ValueData AS Count,
          MovementItemFloat_RealWeight.ValueData AS RealWeight,
          MovementItemFloat_CuterCount.ValueData AS CuterCount,
          MovementItemBoolean_PartionClose.ValueData AS PartionClose,
          MovementItemString_Comment.ValueData AS Comment
        FROM MovementItem 
   LEFT JOIN Object AS Object_Goods
          ON Object_Goods.Id = MovementItem.ObjectId
   LEFT JOIN MovementItemLinkObject AS MovementItemLink_Receipt
          ON MovementItemLink_Receipt.MovementItemId = MovementItem.Id 
         AND MovementItemLink_Receipt.DescId = zc_MovementItemLink_Receipt()
   LEFT JOIN Object AS Object_Receipt
          ON Object_Receipt.Id = MovementItemLink_Receipt.ObjectId
   LEFT JOIN MovementItemLinkObject AS MovementItemLink_Partion
          ON MovementItemLink_Partion.MovementItemId = MovementItem.Id AND MovementItemLink_Partion.DescId = zc_MovementItemLink_Partion()
   LEFT JOIN Object AS Object_Partion
          ON Object_Partion.Id = MovementItemLink_Partion.ObjectId
   LEFT JOIN MovementItemFloat AS MovementItemFloat_Count
          ON MovementItemFloat_Count.MovementItemId = MovementItem.Id AND MovementItemFloat_Count.DescId = zc_MovementItemFloat_Count()
   LEFT JOIN MovementItemFloat AS MovementItemFloat_RealWeight
          ON MovementItemFloat_RealWeight.MovementItemId = MovementItem.Id AND MovementItemFloat_RealWeight.DescId = zc_MovementItemFloat_RealWeight()
   LEFT JOIN MovementItemFloat AS MovementItemFloat_CuterCount
          ON MovementItemFloat_CuterCount.MovementItemId = MovementItem.Id AND MovementItemFloat_CuterCount.DescId = zc_MovementItemFloat_CuterCount()
   LEFT JOIN MovementItemBoolean AS MovementItemBoolean_PartionClose
          ON MovementItemBoolean_PartionClose.MovementItemId = MovementItem.Id AND MovementItemBoolean_PartionClose.DescId = zc_MovementItemBoolean_PartionClose()
   LEFT JOIN MovementItemString AS MovementItemString_Comment
          ON MovementItemString_Comment.MovementItemId = MovementItem.Id AND MovementItemString_Comment.DescId = zc_MovementItemString_Comment()
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MovementItem_In();
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR 
        SELECT 
          MovementItem.Id,
          MovementItem.ObjectId,
          Object_Goods.ObjectCode  AS GoodsCode,
          Object_Goods.ValueData   AS GoodsName,
          MovementItem.Amount,
          MovementItem.isErased,
          MovementItem.ParentId,
          Object_Partion.ValueData AS PartionName,
          MovementItemFloat_AmountReceipt.ValueData AS AmountReceipt,
          MovementItemString_Comment.ValueData AS Comment
        FROM MovementItem 
   LEFT JOIN Object AS Object_Goods
          ON Object_Goods.Id = MovementItem.ObjectId
   LEFT JOIN MovementItemLinkObject AS MovementItemLink_Partion
          ON MovementItemLink_Partion.MovementItemId = MovementItem.Id AND MovementItemLink_Partion.DescId = zc_MovementItemLink_Partion()
   LEFT JOIN Object AS Object_Partion
          ON Object_Partion.Id = MovementItemLink_Partion.ObjectId
   LEFT JOIN MovementItemFloat AS MovementItemFloat_AmountReceipt
          ON MovementItemFloat_AmountReceipt.MovementItemId = MovementItem.Id AND MovementItemFloat_AmountReceipt.DescId = zc_MovementItemFloat_AmountReceipt()
   LEFT JOIN MovementItemString AS MovementItemString_Comment
          ON MovementItemString_Comment.MovementItemId = MovementItem.Id AND MovementItemString_Comment.DescId = zc_MovementItemString_Comment()
       WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MovementItem_Out();
    RETURN NEXT Cursor2;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_MovementItem_ProductionUnion(Integer, Boolean, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_MovementItem_ProductionUnion('2')