DROP VIEW IF EXISTS MovementItem_Sale_View;

CREATE OR REPLACE VIEW MovementItem_Sale_View AS
    SELECT
        MovementItem.Id                    AS Id
      , MovementItem.ObjectId              AS GoodsId
      , Object_Goods.ObjectCode            AS GoodsCode
      , Object_Goods.Name                  AS GoodsName
      , ObjectFloat_NDSKind_NDS.ValueData  AS NDS
      , MovementItem.Amount                AS Amount
      , MIFloat_Price.ValueData            AS Price
      , MIFloat_PriceSale.ValueData        AS PriceSale
      , MIFloat_ChangePercent.ValueData    AS ChangePercent
      , MIFloat_Summ.ValueData             AS Summ
      , MIBoolean_Sp.ValueData             AS isSp
      , MovementItem.isErased              AS isErased
      , MovementItem.MovementId            AS MovementId
      , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)::Integer     AS NDSKindId
    FROM  MovementItem
        LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                      ON MIBoolean_SP.MovementItemId = MovementItem.Id
                                     AND MIBoolean_SP.DescId = zc_MIBoolean_SP()

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                    ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                   AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
        LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                    ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                   AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

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
    WHERE 
        MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_Sale_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».  ¬ÓÓ·Í‡ÎÓ ¿.¿.  ÿ‡·ÎËÈ Œ.¬.
 11.05.20                                                                      *
 09.02.17         *
 13.10.15                                                         *
*/