DROP VIEW IF EXISTS MovementItem_Reprice_View;

CREATE OR REPLACE VIEW MovementItem_Reprice_View AS
    SELECT
        MovementItem.Id                                   AS Id
      , MovementItem.ObjectId                             AS GoodsId
      , Object_Goods.ObjectCode::INTEGER                  AS GoodsCode
      , Object_Goods.ValueData                            AS GoodsName
      , COALESCE(MovementItem.Amount,0)::TFloat           AS Amount
      , MIFloat_Price.ValueData                           AS PriceOld
      , MIFloat_PriceSale.ValueData                       AS PriceNew
      , (MovementItem.Amount*
          (COALESCE(MIFloat_PriceSale.ValueData,0)
           -COALESCE(MIFloat_Price.ValueData,0)))::TFloat AS SummReprice
      , MovementItem.MovementId                           AS MovementId
    FROM  MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN Object AS Object_Goods 
                         ON Object_Goods.Id = MovementItem.ObjectId
    WHERE 
        MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_Reprice_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 13.10.15                                                         *
*/