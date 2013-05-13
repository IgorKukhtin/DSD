-- Function: gpSelect_MovementItem_Income()

--DROP FUNCTION gpSelect_MovementItem_Income();

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
IN inMovementId          Integer,       
IN inShowAll             Boolean,
IN inSession             TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

  IF inShowAll THEN 

     RETURN QUERY 
     SELECT 
       ObjectId,
       Goods.ObjectCode  AS GoodsCode,
       Goods.ValueData   AS GoodsName,
       Amount,
       Erased
     FROM Object AS Goods
LEFT JOIN MovementItem
       ON MovementItem.ObjectId = Goods.Id 
      AND MovementItem.MovementId = inMovementId
      AND MovementItem.DescId =  zc_MovementItem_Goods()
LEFT JOIN MovementItemLinkObject AS MovementItemLink_GoodsKind
       ON MovementItemLink_GoodsKind.MovementItemId = MovementItem.Id AND MovementItemLink_GoodsKind.DescId = zc_MovementItemLink_GoodsKind()
LEFT JOIN Object AS GoodsKind
       ON GoodsKind.Id = MovementItemLink_GoodsKind.ObjectId
LEFT JOIN MovementItemLinkObject AS MovementItemLink_Partion
       ON MovementItemLink_Partion.MovementItemId = MovementItem.Id AND MovementItemLink_Partion.DescId = zc_MovementItemLink_Partion()
LEFT JOIN Object AS Partion
       ON Partion.Id = MovementItemLink_Partion.ObjectId
LEFT JOIN MovementItemFloat AS AmountPartner
       ON AmountPartner.MovementItemId = MovementItem.Id AND AmountPartner.DescId = zc_MovementItemFloat_AmountPartner()
LEFT JOIN MovementItemFloat AS Price
       ON Price.MovementItemId = MovementItem.Id AND Price.DescId = zc_MovementItemFloat_Price()
LEFT JOIN MovementItemFloat AS CountForPrice
       ON CountForPrice.MovementItemId = MovementItem.Id AND CountForPrice.DescId = zc_MovementItemFloat_CountForPrice()
LEFT JOIN MovementItemFloat AS LiveWeight
       ON LiveWeight.MovementItemId = MovementItem.Id AND LiveWeight.DescId = zc_MovementItemFloat_LiveWeight()
LEFT JOIN MovementItemFloat AS HeadCount
       ON HeadCount.MovementItemId = MovementItem.Id AND HeadCount.DescId = zc_MovementItemFloat_HeadCount()
    WHERE Goods.DescId = zc_Object_Goods();

  ELSE
  
     RETURN QUERY 
     SELECT 
       ObjectId,
       Goods.ObjectCode  AS GoodsCode,
       Goods.ValueData   AS GoodsName,
       Amount,
       Erased
     FROM MovementItem
LEFT JOIN Object AS Goods
       ON Goods.Id = MovementItem.ObjectId
LEFT JOIN MovementItemLinkObject AS MovementItemLink_GoodsKind
       ON MovementItemLink_GoodsKind.MovementItemId = MovementItem.Id AND MovementItemLink_GoodsKind.DescId = zc_MovementItemLink_GoodsKind()
LEFT JOIN Object AS GoodsKind
       ON GoodsKind.Id = MovementItemLink_GoodsKind.ObjectId
LEFT JOIN MovementItemLinkObject AS MovementItemLink_Partion
       ON MovementItemLink_Partion.MovementItemId = MovementItem.Id AND MovementItemLink_Partion.DescId = zc_MovementItemLink_Partion()
LEFT JOIN Object AS Partion
       ON Partion.Id = MovementItemLink_Partion.ObjectId
LEFT JOIN MovementItemFloat AS AmountPartner
       ON AmountPartner.MovementItemId = MovementItem.Id AND AmountPartner.DescId = zc_MovementItemFloat_AmountPartner()
LEFT JOIN MovementItemFloat AS Price
       ON Price.MovementItemId = MovementItem.Id AND Price.DescId = zc_MovementItemFloat_Price()
LEFT JOIN MovementItemFloat AS CountForPrice
       ON CountForPrice.MovementItemId = MovementItem.Id AND CountForPrice.DescId = zc_MovementItemFloat_CountForPrice()
LEFT JOIN MovementItemFloat AS LiveWeight
       ON LiveWeight.MovementItemId = MovementItem.Id AND LiveWeight.DescId = zc_MovementItemFloat_LiveWeight()
LEFT JOIN MovementItemFloat AS HeadCount
       ON HeadCount.MovementItemId = MovementItem.Id AND HeadCount.DescId = zc_MovementItemFloat_HeadCount()
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId =  zc_MovementItem_Goods();
 
  END IF;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_MovementItem_Income(Integer, Boolean, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_MovementItem_Income('2')