-- Function: gpSelect_MovementItem_SendOnPrice()

-- DROP FUNCTION gpSelect_MovementItem_SendOnPrice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendOnPrice(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat, Amount_byChangePercent TFloat, AmountPartner TFloat, ChangePercentAmount TFloat
             , Price TFloat, CountForPrice TFloat,  HeadCount TFloat
             , PartionGoods TVarChar, GoodsKindName  TVarChar
             , AmountSumm TFloat, isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendOnPrice());

     IF inShowAll THEN 

     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName

           , CAST (NULL AS TFloat) AS Amount
           , CAST (NULL AS TFloat) AS Amount_byChangePercent
           , CAST (NULL AS TFloat) AS AmountPartner
           , CAST (NULL AS TFloat) AS ChangePercentAmount

           , CAST (NULL AS TFloat) AS Price
           , CAST (NULL AS TFloat) AS CountForPrice

           , CAST (NULL AS TFloat) AS HeadCount

           , CAST (NULL AS TVarChar) AS PartionGoods

           , Object_GoodsKind.ValueData AS GoodsKindName

           , CAST (NULL AS TFloat) AS AmountSumm
           , FALSE AS isErased

       FROM Object AS Object_Goods
            LEFT JOIN lfSelect_Object_GoodsByGoodsKind() AS lfObject_GoodsByGoodsKind ON lfObject_GoodsByGoodsKind.GoodsId = Object_Goods.Id
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = lfObject_GoodsByGoodsKind.GoodsKindId

            LEFT JOIN MovementItem
                   ON MovementItem.ObjectId = Object_Goods.Id
                  AND MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId =  zc_MI_Master()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            AND MILinkObject_GoodsKind.ObjectId = lfObject_GoodsByGoodsKind.GoodsKindId

       WHERE Object_Goods.DescId = zc_Object_Goods()
         AND (MILinkObject_GoodsKind.ObjectId IS NULL OR (MovementItem.MovementId IS NULL AND lfObject_GoodsByGoodsKind.GoodsId IS NULL))
      UNION ALL
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName

           , MovementItem.Amount
           , CAST (MovementItem.Amount * (1 - COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) / 100) AS TFloat) AS Amount_byChangePercent
           , MIFloat_AmountPartner.ValueData       AS AmountPartner
           , MIFloat_ChangePercentAmount.ValueData AS ChangePercentAmount

           , MIFloat_Price.ValueData AS Price
           , MIFloat_CountForPrice.ValueData AS CountForPrice

           , MIFloat_HeadCount.ValueData AS HeadCount

           , MIString_PartionGoods.ValueData AS PartionGoods

           , Object_GoodsKind.ValueData AS GoodsKindName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm
           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                        ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();

     ELSE
  
     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName

           , MovementItem.Amount
           , CAST (MovementItem.Amount * (1 - COALESCE (MIFloat_ChangePercentAmount.ValueData, 0) / 100) AS TFloat) AS Amount_byChangePercent
           , MIFloat_AmountPartner.ValueData       AS AmountPartner
           , MIFloat_ChangePercentAmount.ValueData AS ChangePercentAmount

           , MIFloat_Price.ValueData AS Price
           , MIFloat_CountForPrice.ValueData AS CountForPrice

           , MIFloat_HeadCount.ValueData AS HeadCount

           , MIString_PartionGoods.ValueData AS PartionGoods

           , Object_GoodsKind.ValueData AS GoodsKindName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) ) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm
           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                        ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();
 
     END IF;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SendOnPrice (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.09.13                                        * add ChangePercentAmount
 15.07.13         * SendOnPrice              
 12.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SendOnPrice (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_SendOnPrice (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
