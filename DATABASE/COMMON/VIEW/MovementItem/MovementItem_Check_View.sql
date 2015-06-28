-- View: Object_Unit_View

DROP VIEW IF EXISTS MovementItem_Check_View;

CREATE OR REPLACE VIEW MovementItem_Check_View AS
       SELECT
             MovementItem.Id                    AS Id
           , MovementItem.ObjectId              AS GoodsId
           , Object_Goods.goodscode             AS GoodsCode
           , Object_Goods.goodsname             AS GoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_Price.ValueData            AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , MovementItem.isErased              AS isErased
           , MovementItem.MovementId            AS MovementId
           , MovementItem.ParentId              AS ParentId
           , object_goods.NDS                   AS NDS

       FROM  MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

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
