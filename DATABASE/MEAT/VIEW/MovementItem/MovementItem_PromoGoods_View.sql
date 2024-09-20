--

DROP VIEW IF EXISTS MovementItem_PromoGoods_View;

CREATE OR REPLACE VIEW MovementItem_PromoGoods_View AS
    SELECT
        MovementItem.Id                        AS Id                  --идентификатор
      , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
      , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
      , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
      , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
      , Object_Measure.Id                      AS MeasureId           --Единица измерения
      , Object_Measure.ValueData               AS Measure             --Единица измерения
      , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
      , MovementItem.Amount                    AS Amount              --% скидки на товар
      , (MIFloat_Price.ValueData           / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END) :: TFloat               AS Price               --Цена в прайсе с учетом скидки по договору
      , CAST (MIFloat_PriceWithOutVAT.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS Numeric (16,8))  AS PriceWithOutVAT     --Цена отгрузки без учета НДС, с учетом скидки, грн
      , CAST (MIFloat_PriceWithVAT.ValueData    / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS Numeric (16,8))  AS PriceWithVAT        --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END :: TFloat AS CountForPrice
      , MIFloat_PriceWithOutVAT.ValueData      AS PriceWithOutVAT_orig--Цена отгрузки без учета НДС, с учетом скидки, грн
      , MIFloat_PriceWithVAT.ValueData         AS PriceWithVAT_orig   --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , MIFloat_PriceSale.ValueData            AS PriceSale           --Цена на полке

      , MIFloat_AmountReal.ValueData           AS AmountReal          --Объем продаж в аналогичный период, кг
      , (MIFloat_AmountReal.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

      , MIFloat_AmountRetIn.ValueData          AS AmountRetIn          --Объем возврат в аналогичный период, кг
      , (MIFloat_AmountRetIn.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRetInWeight    --Объем возврат в аналогичный период, кг Вес

      , MIFloat_AmountPlanMin.ValueData        AS AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
      , (MIFloat_AmountPlanMin.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
      , MIFloat_AmountPlanMax.ValueData        AS AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
      , (MIFloat_AmountPlanMax.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
      , MIFloat_AmountOrder.ValueData          AS AmountOrder         --Кол-во заявка (факт)
      , (MIFloat_AmountOrder.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOrderWeight   --Кол-во заявка (факт) Вес
      , MIFloat_AmountOut.ValueData            AS AmountOut           --Кол-во реализация (факт)
      , (MIFloat_AmountOut.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOutWeight     --Кол-во реализация (факт) Вес
      , MIFloat_AmountIn.ValueData             AS AmountIn            --Кол-во возврат (факт)
      , (MIFloat_AmountIn.ValueData
          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountInWeight      --Кол-во возврат (факт) Вес
      , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId         --ИД обьекта <Вид товара>
      , Object_GoodsKind.ValueData             AS GoodsKindName       --Наименование обьекта <Вид товара>
      , MIString_Comment.ValueData             AS Comment             -- Примечание
      , MovementItem.isErased                  AS isErased            -- Удален
      , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес
      , MILinkObject_GoodsKindComplete.ObjectId        AS GoodsKindCompleteId         --ИД обьекта <Вид товара (примечание)>
      , Object_GoodsKindComplete.ValueData             AS GoodsKindCompleteName       --Наименование обьекта <Вид товара (примечание)>
      , MIFloat_MainDiscount.ValueData   ::TFloat AS MainDiscount       -- Общая скидка для покупателя, %
      , (MIFloat_OperPriceList.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END)  ::TFloat AS OperPriceList      -- Цена в прайсе
      , MIFloat_ContractCondition.ValueData    AS ContractCondition      -- Бонус сети, %

      , (COALESCE (MIFloat_SummOutMarket.ValueData, 0) - COALESCE (MIFloat_SummInMarket.ValueData, 0)) :: TFloat AS SummOutMarket

    FROM MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                    ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                   AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                    ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                    ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                    ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                   AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

        LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                    ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                    ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountIn
                                    ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                    ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountRetIn
                                    ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMin
                                    ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
        LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                    ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

        LEFT JOIN MovementItemFloat AS MIFloat_MainDiscount
                                    ON MIFloat_MainDiscount.MovementItemId = MovementItem.Id 
                                   AND MIFloat_MainDiscount.DescId = zc_MIFloat_MainDiscount()

        LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                    ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                   AND MIFloat_SummOutMarket.DescId = zc_MIFloat_SummOutMarket()
        LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                    ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                   AND MIFloat_SummInMarket.DescId = zc_MIFloat_SummInMarket()

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                         ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
        LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId

        LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MovementItem.ID
                                          AND MIString_Comment.DescId = zc_MIString_Comment()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                             ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
        LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                    ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                   AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN MovementItemFloat AS MIFloat_ContractCondition
                                    ON MIFloat_ContractCondition.MovementItemId = MovementItem.Id
                                   AND MIFloat_ContractCondition.DescId = zc_MIFloat_ContractCondition()
                                                     
    WHERE MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_PromoGoods_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 02.11.15                                                         *
*/

-- тест
-- SELECT * FROM MovementItem_PromoGoods_View WHERE MovementId = 2641111
