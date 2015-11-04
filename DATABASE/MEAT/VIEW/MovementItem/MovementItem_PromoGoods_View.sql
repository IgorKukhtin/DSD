DROP VIEW IF EXISTS MovementItem_PromoGoods_View;

CREATE OR REPLACE VIEW MovementItem_PromoGoods_View AS
    SELECT
        MovementItem.Id                    AS Id               --идентификатор
      , MovementItem.MovementId            AS MovementId       --ИД документа <Акция>
      , MovementItem.ObjectId              AS GoodsId          --ИД объекта <товар>
      , Object_Goods.ObjectCode::Integer   AS GoodsCode        --код объекта  <товар>
      , Object_Goods.ValueData             AS GoodsName        --наименование объекта <товар>
      , MovementItem.Amount                AS Amount           --% скидки на товар
      , MIFloat_Price.ValueData            AS Price            --Цена в прайсе
      , MIFloat_PriceWithOutVAT.ValueData  AS PriceWithOutVAT  --Цена отгрузки без учета НДС, с учетом скидки, грн
      , MIFloat_PriceWithVAT.ValueData     AS PriceWithVAT     --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , MIFloat_AmountReal.ValueData       AS AmountReal       --Объем продаж в аналогичный период, кг
      , MIFloat_AmountPlanMin.ValueData    AS AmountPlanMin    --Минимум планируемого объема продаж на акционный период (в кг)
      , MIFloat_AmountPlanMax.ValueData    AS AmountPlanMax    --Максимум планируемого объема продаж на акционный период (в кг)
      , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId      --ИД обьекта <Вид товара>
      , Object_GoodsKind.ValueData         AS GoodsKindName    --Наименование обьекта <Вид товара>
      , MovementItem.isErased              AS isErased
      
    FROM  MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                    ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                    ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                    ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMin
                                    ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                    ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
        LEFT JOIN Object AS Object_Goods 
                         ON Object_Goods.Id = MovementItem.ObjectId
        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.ObjectId
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind
                         ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                                        
    WHERE 
        MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_PromoGoods_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 02.11.15                                                         *
*/