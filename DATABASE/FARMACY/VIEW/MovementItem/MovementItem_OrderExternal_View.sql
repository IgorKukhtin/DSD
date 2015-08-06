-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_OrderExternal_View;

CREATE OR REPLACE VIEW MovementItem_OrderExternal_View AS 
SELECT 
      MovementItem.Id 
    , ObjectString.ValueData             AS PartnerGoodsCode
    , MILinkObject_Goods.ObjectId        AS PartnerGoodsId
    , Object_Goods.ObjectCode            AS GoodsCode
    , Object_Goods.ValueData             AS GoodsName
    , MovementItem.Amount                AS Amount
    , MIFloat_Price.ValueData            AS Price
    , MovementItem.Amount * MIFloat_Price.ValueData   AS Summ
    , MovementItem.isErased              AS isErased
    , MovementItem.ObjectId              AS GoodsId
    , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
    , MovementItem.MovementId            AS MovementId
    , MIString_Comment.ValueData         AS Comment

FROM MovementItem 
    LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                               ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                              AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                               AND MIFloat_Price.DescId = zc_MIFloat_Price()

    LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

    LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                    AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
 
    LEFT JOIN ObjectString ON ObjectString.ObjectId = MILinkObject_Goods.ObjectId
                          AND ObjectString.DescId = zc_ObjectString_Goods_Code()

    LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
WHERE MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_OrderExternal_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 05.08.15                                                        * +Comment
 11.12.14                        * 
*/

-- тест
-- SELECT * FROM MovementItem_OrderExternal_View where Movementid = 34
