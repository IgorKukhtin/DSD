-- Function: gpSelect_MovementItem_Income()

--DROP FUNCTION gpSelect_MovementItem_Income(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
IN inMovementId          Integer,       
IN inShowAll             Boolean,
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Amount TFloat, isErased boolean, 
               Price TFloat, Summ TFloat) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

  IF inShowAll THEN 

     RETURN QUERY 
     SELECT 
       MovementItem.ObjectId,
       Object_Goods.ObjectCode  AS Code,
       Object_Goods.ValueData   AS Name,
       MovementItem.Amount,
       MovementItem.isErased,
       MovementItemFloat_Price.ValueData AS Price,
       CAST (MovementItem.Amount * MovementItemFloat_Price.ValueData AS TFloat) AS AmountSumm
     FROM Object AS Object_Goods
LEFT JOIN MovementItem
       ON MovementItem.ObjectId = Object_Goods.Id 
      AND MovementItem.MovementId = inMovementId
      AND MovementItem.DescId =  zc_MovementItem_Goods()
LEFT JOIN MovementItemLinkObject AS MovementItemLink_GoodsKind
       ON MovementItemLink_GoodsKind.MovementItemId = MovementItem.Id AND MovementItemLink_GoodsKind.DescId = zc_MovementItemLink_GoodsKind()
LEFT JOIN Object AS Object_GoodsKind
       ON Object_GoodsKind.Id = MovementItemLink_GoodsKind.ObjectId
LEFT JOIN MovementItemLinkObject AS MovementItemLink_Partion
       ON MovementItemLink_Partion.MovementItemId = MovementItem.Id AND MovementItemLink_Partion.DescId = zc_MovementItemLink_Partion()
LEFT JOIN Object AS Object_Partion
       ON Object_Partion.Id = MovementItemLink_Partion.ObjectId
LEFT JOIN MovementItemFloat AS MovementItemFloat_AmountPartner
       ON MovementItemFloat_AmountPartner.MovementItemId = MovementItem.Id AND MovementItemFloat_AmountPartner.DescId = zc_MovementItemFloat_AmountPartner()
LEFT JOIN MovementItemFloat AS MovementItemFloat_Price
       ON MovementItemFloat_Price.MovementItemId = MovementItem.Id AND MovementItemFloat_Price.DescId = zc_MovementItemFloat_Price()
LEFT JOIN MovementItemFloat AS MovementItemFloat_CountForPrice
       ON MovementItemFloat_CountForPrice.MovementItemId = MovementItem.Id AND MovementItemFloat_CountForPrice.DescId = zc_MovementItemFloat_CountForPrice()
LEFT JOIN MovementItemFloat AS MovementItemFloat_LiveWeight
       ON MovementItemFloat_LiveWeight.MovementItemId = MovementItem.Id AND MovementItemFloat_LiveWeight.DescId = zc_MovementItemFloat_LiveWeight()
LEFT JOIN MovementItemFloat AS MovementItemFloat_HeadCount
       ON MovementItemFloat_HeadCount.MovementItemId = MovementItem.Id AND MovementItemFloat_HeadCount.DescId = zc_MovementItemFloat_HeadCount()
    WHERE Object_Goods.DescId = zc_Object_Goods();

  ELSE
  
     RETURN QUERY 
     SELECT 
       MovementItem.ObjectId,
       Object_Goods.ObjectCode  AS GoodsCode,
       Object_Goods.ValueData   AS GoodsName,
       MovementItem.Amount,
       MovementItem.isErased,
       MovementItemFloat_Price.ValueData AS Price,
       CAST (MovementItem.Amount * MovementItemFloat_Price.ValueData AS TFloat) AS AmountSumm
     FROM MovementItem
LEFT JOIN Object AS Object_Goods
       ON Object_Goods.Id = MovementItem.ObjectId
LEFT JOIN MovementItemLinkObject AS MovementItemLink_GoodsKind
       ON MovementItemLink_GoodsKind.MovementItemId = MovementItem.Id AND MovementItemLink_GoodsKind.DescId = zc_MovementItemLink_GoodsKind()
LEFT JOIN Object AS Object_GoodsKind
       ON Object_GoodsKind.Id = MovementItemLink_GoodsKind.ObjectId
LEFT JOIN MovementItemLinkObject AS MovementItemLink_Partion
       ON MovementItemLink_Partion.MovementItemId = MovementItem.Id AND MovementItemLink_Partion.DescId = zc_MovementItemLink_Partion()
LEFT JOIN Object AS Object_Partion
       ON Object_Partion.Id = MovementItemLink_Partion.ObjectId
LEFT JOIN MovementItemFloat AS MovementItemFloat_AmountPartner
       ON MovementItemFloat_AmountPartner.MovementItemId = MovementItem.Id AND MovementItemFloat_AmountPartner.DescId = zc_MovementItemFloat_AmountPartner()
LEFT JOIN MovementItemFloat AS MovementItemFloat_Price
       ON MovementItemFloat_Price.MovementItemId = MovementItem.Id AND MovementItemFloat_Price.DescId = zc_MovementItemFloat_Price()
LEFT JOIN MovementItemFloat AS MovementItemFloat_CountForPrice
       ON MovementItemFloat_CountForPrice.MovementItemId = MovementItem.Id AND MovementItemFloat_CountForPrice.DescId = zc_MovementItemFloat_CountForPrice()
LEFT JOIN MovementItemFloat AS MovementItemFloat_LiveWeight
       ON MovementItemFloat_LiveWeight.MovementItemId = MovementItem.Id AND MovementItemFloat_LiveWeight.DescId = zc_MovementItemFloat_LiveWeight()
LEFT JOIN MovementItemFloat AS MovementItemFloat_HeadCount
       ON MovementItemFloat_HeadCount.MovementItemId = MovementItem.Id AND MovementItemFloat_HeadCount.DescId = zc_MovementItemFloat_HeadCount()
    WHERE MovementItem.MovementId = inMovementId;
      --AND MovementItem.DescId =  zc_MovementItem_Goods();
 
  END IF;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_MovementItem_Income(Integer, Boolean, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_MovementItem_Income('2')