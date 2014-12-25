-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_Income_View;

CREATE OR REPLACE VIEW MovementItem_Income_View AS 
       SELECT
             MovementItem.Id                    AS Id
           , MovementItem.ObjectId              AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MILinkObject_Goods.ObjectId        AS PartnerGoodsId
           , Object_PartnerGoods.GoodsCode      AS PartnerGoodsCode
           , Object_PartnerGoods.GoodsName      AS PartnerGoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_Price.ValueData            AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , MovementItem.isErased              AS isErased
           , MovementItem.MovementId            AS MovementId

       FROM  MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

            LEFT JOIN Object_Goods_View AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

   WHERE MovementItem.DescId     = zc_MI_Master();


ALTER TABLE MovementItem_Income_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 11.12.14                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Income_View where id = 805
