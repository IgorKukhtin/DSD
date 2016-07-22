-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_Check_View;

CREATE OR REPLACE VIEW MovementItem_Check_View AS
       SELECT
             MovementItem.Id                     AS Id
           , MovementItem.ObjectId               AS GoodsId
           , Object_Goods.goodscodeInt           AS GoodsCode
           , Object_Goods.goodsname              AS GoodsName
           , MovementItem.Amount                 AS Amount
           , MIFloat_Price.ValueData             AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , MovementItem.isErased               AS isErased
           , MovementItem.MovementId             AS MovementId
           , MovementItem.ParentId               AS ParentId
           , Object_Goods.NDS                    AS NDS
           , MIFloat_PriceSale.ValueData         AS PriceSale
           , MIFloat_ChangePercent.ValueData     AS ChangePercent
           , MIFloat_SummChangePercent.ValueData AS SummChangePercent
           -- , Object_DiscountCard.Id              AS DiscountCardId
           -- , Object_DiscountCard.ValueData       AS DiscountCardName

       FROM  MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
            /*LEFT JOIN MovementItemLinkObject AS MILO_DiscountCard
                                             ON MILO_DiscountCard.MovementItemId = MovementItem.Id
                                            AND MILO_DiscountCard.DescId = zc_MILinkObject_DiscountCard()
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MILO_DiscountCard.ObjectId*/

            LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

   WHERE MovementItem.DescId     = zc_MI_Master();


ALTER TABLE MovementItem_Check_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 26.05.15                        *
*/

-- òåñò
-- SELECT * FROM MovementItem_Check_View where MovementId >= 12590 Order By MovementId
--Select Max(MovementId) from MovementItem_Check_View
