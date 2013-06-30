-- Function: gpSelect_MovementItem_Income()

--DROP FUNCTION gpSelect_MovementItem_Income(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
IN inMovementId          Integer,       
IN inShowAll             Boolean,
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat, 
               Price TFloat, Summ TFloat, isErased boolean) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

  IF inShowAll THEN 

     RETURN QUERY 
     SELECT 
       MovementItem.Id,
       Object_Goods.Id          AS GoodsId,
       Object_Goods.ObjectCode  AS GoodsCode,
       Object_Goods.ValueData   AS GoodsName,
       MovementItem.Amount,
       MIFloat_Price.ValueData AS Price,
       CAST (MovementItem.Amount * MIFloat_Price.ValueData AS TFloat) AS AmountSumm,
       MovementItem.isErased
     FROM Object AS Object_Goods
LEFT JOIN MovementItem
       ON MovementItem.ObjectId = Object_Goods.Id 
      AND MovementItem.MovementId = inMovementId
      AND MovementItem.DescId =  zc_MI_Master()
LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
LEFT JOIN Object AS Object_GoodsKind
       ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

LEFT JOIN MovementItemString AS MIString_PartionGoods
       ON MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
      AND MIString_PartionGoods.MovementItemId =  MovementItem.Id

LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
LEFT JOIN MovementItemFloat AS MIFloat_Price
       ON MIFloat_Price.MovementItemId = MovementItem.Id AND MIFloat_Price.DescId = zc_MIFloat_Price()
LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
    WHERE Object_Goods.DescId = zc_Object_Goods();

  ELSE
  
     RETURN QUERY 
     SELECT 
       MovementItem.Id,
       Object_Goods.Id          AS GoodsId,
       Object_Goods.ObjectCode  AS GoodsCode,
       Object_Goods.ValueData   AS GoodsName,
--       MIString_PartionGoods.ValueData AS PartionGoods,
       MovementItem.Amount,
       MIFloat_Price.ValueData AS Price,
       CAST (MovementItem.Amount * MIFloat_Price.ValueData AS TFloat) AS AmountSumm,
       MovementItem.isErased
     FROM MovementItem
LEFT JOIN Object AS Object_Goods
       ON Object_Goods.Id = MovementItem.ObjectId
LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
LEFT JOIN Object AS Object_GoodsKind
       ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

LEFT JOIN MovementItemString AS MIString_PartionGoods
       ON MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
      AND MIString_PartionGoods.MovementItemId =  MovementItem.Id

LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
LEFT JOIN MovementItemFloat AS MIFloat_Price
       ON MIFloat_Price.MovementItemId = MovementItem.Id AND MIFloat_Price.DescId = zc_MIFloat_Price()
LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId =  zc_MI_Master();
 
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 1, inShowAll:= TRUE, inSession:= '2')
