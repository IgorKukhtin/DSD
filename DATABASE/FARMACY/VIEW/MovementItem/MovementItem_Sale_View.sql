DROP VIEW IF EXISTS MovementItem_Sale_View;

CREATE OR REPLACE VIEW MovementItem_Sale_View AS
    SELECT
        MovementItem.Id                    AS Id
      , MovementItem.ObjectId              AS GoodsId
      , Object_Goods.GoodsCodeInt          AS GoodsCode
      , Object_Goods.GoodsName             AS GoodsName
      , Object_Goods.NDS                   AS NDS
      , MovementItem.Amount                AS Amount
      , MIFloat_Price.ValueData            AS Price
      , MIFloat_Summ.ValueData             AS Summ
      , MovementItem.isErased              AS isErased
      , MovementItem.MovementId            AS MovementId
    FROM  MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                    ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                   AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
        LEFT JOIN Object_Goods_View AS Object_Goods 
                                    ON Object_Goods.Id = MovementItem.ObjectId
    WHERE 
        MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_Sale_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 13.10.15                                                         *
*/