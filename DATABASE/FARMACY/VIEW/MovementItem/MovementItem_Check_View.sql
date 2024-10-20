-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_Check_View;

CREATE OR REPLACE VIEW MovementItem_Check_View AS
       SELECT
             MovementItem.Id                     AS Id
           , MovementItem.ObjectId               AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.Name                   AS GoodsName
           , MovementItem.Amount                 AS Amount
           , MIFloat_Price.ValueData             AS Price
           , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                             , COALESCE (MB_RoundingDown.ValueData, False)
                             , COALESCE (MB_RoundingTo10.ValueData, False)
                             , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm
           , MovementItem.isErased               AS isErased
           , MovementItem.MovementId             AS MovementId
           , MovementItem.ParentId               AS ParentId
           , ObjectFloat_NDSKind_NDS.ValueData   AS NDS
           , MIFloat_PriceSale.ValueData         AS PriceSale
           , MIFloat_ChangePercent.ValueData     AS ChangePercent
           , MIFloat_SummChangePercent.ValueData AS SummChangePercent
           , MIFloat_AmountOrder.ValueData       AS AmountOrder
           , MIString_UID.ValueData              AS List_UID
           , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)::Integer     AS NDSKindId
           , MIFloat_PriceLoad.ValueData         AS PriceLoad
           -- , Object_DiscountCard.Id              AS DiscountCardId
           -- , Object_DiscountCard.ValueData       AS DiscountCardName

       FROM  MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceLoad
                                        ON MIFloat_PriceLoad.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceLoad.DescId = zc_MIFloat_PriceLoad()
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                        ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
            LEFT JOIN MovementItemString AS MIString_UID
                                         ON MIString_UID.MovementItemId = MovementItem.Id
                                        AND MIString_UID.DescId = zc_MIString_UID()
            LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                      ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                     AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
            LEFT JOIN MovementBoolean AS MB_RoundingDown
                                      ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                     AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
            LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                      ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                     AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
            /*LEFT JOIN MovementItemLinkObject AS MILO_DiscountCard
                                             ON MILO_DiscountCard.MovementItemId = MovementItem.Id
                                            AND MILO_DiscountCard.DescId = zc_MILinkObject_DiscountCard()
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MILO_DiscountCard.ObjectId*/

            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
            LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                             ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                                            
            LEFT JOIN (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()) AS ObjectFloat_NDSKind_NDS
                          ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)

   WHERE MovementItem.DescId     = zc_MI_Master();


ALTER TABLE MovementItem_Check_View
  OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Шаблий О.В.
 02.04.19                                                                       *
 22.07.18                                                                       *
 10.08.16                                                       * MIString_UID.ValueData AS LIST_UID
 26.05.15                        *
*/

-- тест
-- SELECT * FROM MovementItem_Check_View where MovementId >= 29354848  Order By MovementId
--Select Max(MovementId) from MovementItem_Check_View

SELECT * FROM MovementItem_Check_View limit 10