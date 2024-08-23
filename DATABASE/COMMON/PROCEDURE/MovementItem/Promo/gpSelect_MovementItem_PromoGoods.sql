-- Function: gpSelect_MovementItem_PromoGoods()

-- DROP FUNCTION IF EXISTS gpSelect_MI_PromoGoods_Plan (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор
      , MovementId          Integer --ИД документа <Акция>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения
      , TradeMarkId Integer, TradeMarkName       TVarChar --Торговая марка 
      , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar, GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar 
      , GoodsGroupDirectionId Integer, GoodsGroupDirectionName TVarChar

      , Amount              TFloat --% скидки на товар
      , MainDiscount        TFloat -- Общая скидка для покупателя, %
      , Price               TFloat --Цена в прайсе c учетом скидки по договору
      , OperPriceList       TFloat --Цена в прайсе
      , PriceSale           TFloat --Цена на полке
      , PriceWithOutVAT     Numeric (16,8) --Цена отгрузки без учета НДС, с учетом скидки, грн
      , PriceWithVAT        Numeric (16,8) --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , PriceCorr           TFloat --На сколько корректируется Цена (из-за округлений)
      , CountForPrice       TFloat --Цена отгрузки с учетом НДС, с учетом скидки, грн
      , AmountReal          TFloat --Объем продаж в аналогичный период, кг
      , AmountRealWeight    TFloat --Объем продаж в аналогичный период, кг Вес
      , AmountRealPromo     TFloat --Объем Акционных продаж в аналогичный период, кг
      , AmountRealPromoWeight TFloat --Объем Акционных продаж в аналогичный период, кг Вес
      , AmountReal_diff     TFloat --Объем НЕ Акционных продаж в аналогичный период, кг
      , AmountRealWeight_diff TFloat --Объем НЕ Акционных продаж в аналогичный период, кг Вес
      , AmountRetIn         TFloat --Объем возврат в аналогичный период, кг
      , AmountRetInWeight   TFloat --Объем возврат в аналогичный период, кг Вес
      , AmountPlanMin       TFloat --Минимум планируемого объема продаж на акционный период (в кг)
      , AmountPlanMinWeight TFloat --Минимум планируемого объема продаж на акционный период (в кг) Вес
      , AmountPlanMax       TFloat --Максимум планируемого объема продаж на акционный период (в кг)
      , AmountPlanMaxWeight TFloat --Максимум планируемого объема продаж на акционный период (в кг) Вес
      , AmountOrder         TFloat --Кол-во заявка (факт)
      , AmountOrderWeight   TFloat --Кол-во заявка (факт) Вес
      , AmountOut           TFloat --Кол-во реализация (факт)
      , AmountOutWeight     TFloat --Кол-во реализация (факт) Вес
      , AmountIn            TFloat --Кол-во возврат (факт)
      , AmountInWeight      TFloat --Кол-во возврат (факт) Вес

      , TaxRetIn            TFloat -- % возврат
      , AmountPlan1         TFloat -- Кол-во план отгрузки за пн.
      , AmountPlan2         TFloat -- Кол-во план отгрузки за вт.
      , AmountPlan3         TFloat -- Кол-во план отгрузки за ср.
      , AmountPlan4         TFloat -- Кол-во план отгрузки за чт.
      , AmountPlan5         TFloat -- Кол-во план отгрузки за пт.
      , AmountPlan6         TFloat -- Кол-во план отгрузки за сб.
      , AmountPlan7         TFloat -- Кол-во план отгрузки за вс.

      , PriceTender         TFloat -- Цена Тендер без учета НДС, с учетом скидки, грн

      , AmountMarket  TFloat     --Кол-во факт (маркет бюджет)
      , SummOutMarket TFloat     --Сумма факт кредит(маркет бюджет)
      , SummInMarket  TFloat     --Сумма факт дебет(маркет бюджет)

      , GoodsKindId            Integer --ИД обьекта <Вид товара>
      , GoodsKindName          TVarChar --Наименование обьекта <Вид товара>
      , GoodsKindCompleteId    Integer --ИД обьекта <Вид товара (примечание)>
      , GoodsKindCompleteName  TVarChar --Наименование обьекта <Вид товара(примечание)>
      , GoodsKindName_List     TVarChar --Наименование обьекта <Вид товара (справочно)>
      , Comment                TVarChar --Комментарий       
      , isErased               Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);


    CREATE TEMP TABLE _tmpPromoPartner (PartnerId Integer) ON COMMIT DROP;
    INSERT INTO _tmpPromoPartner (PartnerId)
            SELECT MI_PromoPartner.ObjectId        AS PartnerId   --ИД объекта <партнер>
            FROM Movement AS Movement_PromoPartner
                 INNER JOIN MovementItem AS MI_PromoPartner
                                         ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                        AND MI_PromoPartner.DescId = zc_MI_Master()
                                        AND MI_PromoPartner.IsErased = FALSE
            WHERE Movement_PromoPartner.ParentId = inMovementId
              AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner();

    CREATE TEMP TABLE _tmpGoodsKind_inf (GoodsId Integer, ValueData TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpGoodsKind_inf (GoodsId, ValueData)
            SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , STRING_AGG (DISTINCT ObjectString_GoodsKind.ValueData :: TVarChar, ',') AS ValueData
            FROM _tmpPromoPartner
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                      ON ObjectLink_GoodsListSale_Partner.ChildObjectId = _tmpPromoPartner.PartnerId
                                     AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()

                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                      ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                     AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                 INNER JOIN (SELECT MovementItem.ObjectId
                             FROM MovementItem
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.isErased = FALSE) AS MI_Master ON MI_Master.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                 INNER JOIN ObjectString AS ObjectString_GoodsKind
                                         ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                        AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                        AND ObjectString_GoodsKind.ValueData <> ''
            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId;

    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList)
            SELECT DISTINCT _tmpGoodsKind_inf.ValueData AS WordList
            FROM _tmpGoodsKind_inf;

    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);


    RETURN QUERY
        WITH
        tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, STRING_AGG (DISTINCT Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                         FROM _tmpWord_Split_to
                              LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                         GROUP BY _tmpWord_Split_to.WordList
                         )
      , tmpGoodsKind_list AS (SELECT _tmpGoodsKind_inf.GoodsId
                                   , STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName_List :: TVarChar, ',')  AS GoodsKindName_List
                              FROM _tmpGoodsKind_inf
                                   LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = _tmpGoodsKind_inf.ValueData
                              GROUP BY _tmpGoodsKind_inf.GoodsId
                             )

        SELECT MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения
             , Object_TradeMark.Id                    AS TradeMarkId
             , Object_TradeMark.ValueData                AS TradeMark           --Торговая марка   
             , Object_GoodsGroupProperty.Id              AS GoodsGroupPropertyId
             , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
             , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
             , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent
             , Object_GoodsGroupDirection.Id             AS GoodsGroupDirectionId
             , Object_GoodsGroupDirection.ValueData      AS GoodsGroupDirectionName
            
             , MovementItem.Amount                    AS Amount              --% скидки на товар
             , MIFloat_MainDiscount.ValueData ::TFloat AS MainDiscount       -- Общая скидка для покупателя, %
             , MIFloat_Price.ValueData                AS Price               --Цена в прайсе с учетом скидки по договору
             , MIFloat_OperPriceList.ValueData ::TFloat AS OperPriceList     -- Цена в прайсе
             , MIFloat_PriceSale.ValueData            AS PriceSale           --Цена на полке

               --Цена отгрузки без учета НДС, с учетом скидки, грн
             , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_PriceWithOutVAT.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_PriceWithOutVAT.ValueData END AS Numeric (16, 8)) AS PriceWithOutVAT
               --Цена отгрузки с учетом НДС, с учетом скидки, грн
             , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_PriceWithVAT.ValueData    / MIFloat_CountForPrice.ValueData ELSE MIFloat_PriceWithVAT.ValueData    END AS Numeric (16, 8)) AS PriceWithVAT

                -- На сколько корректируется Цена (из-за округлений)
             ,  MIFloat_PriceCorr.ValueData AS PriceCorr
             
               -- CountForPrice
             , MIFloat_CountForPrice.ValueData        AS CountForPrice

             , MIFloat_AmountReal.ValueData           AS AmountReal          --Объем продаж в аналогичный период, кг
             , (MIFloat_AmountReal.ValueData
                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

             , MIFloat_AmountRealPromo.ValueData      AS AmountRealPromo          --Объем Акционных продаж в аналогичный период, кг
             , (MIFloat_AmountRealPromo.ValueData
                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealPromoWeight    --Объем Акционных продаж в аналогичный период, кг Вес

             , (COALESCE (MIFloat_AmountReal.ValueData,0) - COALESCE (MIFloat_AmountRealPromo.ValueData,0)) ::TFloat      AS AmountReal_diff          --Объем НЕ Акционных продаж в аналогичный период, кг
             , ((COALESCE (MIFloat_AmountReal.ValueData,0) - COALESCE (MIFloat_AmountRealPromo.ValueData,0))
                 * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight_diff    --Объем не Акционных продаж в аналогичный период, кг Вес


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

             , MIFloat_TaxRetIn.ValueData             AS TaxRetIn               -- % возврат

             , MIFloat_Plan1.ValueData                AS AmountPlan1
             , MIFloat_Plan2.ValueData                AS AmountPlan2
             , MIFloat_Plan3.ValueData                AS AmountPlan3
             , MIFloat_Plan4.ValueData                AS AmountPlan4
             , MIFloat_Plan5.ValueData                AS AmountPlan5
             , MIFloat_Plan6.ValueData                AS AmountPlan6
             , MIFloat_Plan7.ValueData                AS AmountPlan7

             , MIFloat_PriceTender.ValueData          AS PriceTender
             --
             , MIFloat_AmountMarket.ValueData  ::TFloat AS AmountMarket
             , MIFloat_SummOutMarket.ValueData ::TFloat AS SummOutMarket
             , MIFloat_SummInMarket.ValueData  ::TFloat AS SummInMarket


             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId                 --ИД обьекта <Вид товара>
             , Object_GoodsKind.ValueData             AS GoodsKindName               --Наименование обьекта <Вид товара>
             , Object_GoodsKindComplete.Id            AS GoodsKindCompleteId         --ИД Вид товара(Примечание)
             , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName       --Наименование обьекта <Вид товара(Примечание)>
             , tmpGoodsKind_list.GoodsKindName_List ::TVarChar                       -- Наименование обьекта <Вид товара (справочно)>

             , MIString_Comment.ValueData             AS Comment                     -- Примечание
             , MovementItem.isErased                  AS isErased                    -- Удален
             --, CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceCorr
                                         ON MIFloat_PriceCorr.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceCorr.DescId = zc_MIFloat_PriceCorr()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                         ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                         ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
             LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                         ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                         ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                        AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
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
             LEFT JOIN MovementItemFloat AS MIFloat_AmountRealPromo
                                         ON MIFloat_AmountRealPromo.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountRealPromo.DescId = zc_MIFloat_AmountRealPromo()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountRetIn
                                         ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMin
                                         ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                         ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

             LEFT JOIN MovementItemFloat AS MIFloat_TaxRetIn
                                         ON MIFloat_TaxRetIn.MovementItemId = MovementItem.Id
                                        AND MIFloat_TaxRetIn.DescId = zc_MIFloat_TaxRetIn()

             LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                         ON MIFloat_Plan1.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                         ON MIFloat_Plan2.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                         ON MIFloat_Plan3.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                         ON MIFloat_Plan4.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                         ON MIFloat_Plan5.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                         ON MIFloat_Plan6.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                         ON MIFloat_Plan7.MovementItemId = MovementItem.Id
                                        AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7()

             LEFT JOIN MovementItemFloat AS MIFloat_PriceTender
                                         ON MIFloat_PriceTender.MovementItemId = MovementItem.Id
                                        AND MIFloat_PriceTender.DescId = zc_MIFloat_PriceTender()

             LEFT JOIN MovementItemFloat AS MIFloat_MainDiscount
                                         ON MIFloat_MainDiscount.MovementItemId = MovementItem.Id
                                        AND MIFloat_MainDiscount.DescId = zc_MIFloat_MainDiscount()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountMarket
                                         ON MIFloat_AmountMarket.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountMarket.DescId = zc_MIFloat_AmountMarket()
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
             LEFT JOIN Object AS Object_Measure
                              ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                         ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                        AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MovementItem.ObjectId

             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupProperty
                                              ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --                                
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupDirection
                                              ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection() 
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)

        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 22.10.20         * add TaxRetIn
 14.07.20         * add OperPriceList
 06.07.20         * add AmountRealPromo
 01.07.20         * add MainDiscount
 24.01.18         * add PriceTender
 28.11.17         * add GoodsKindComplete
 10.11.17         *
 05.11.15                                                          *
*/
-- тест
-- SELECT * FROM gpSelect_MovementItem_PromoGoods (5083159 , FALSE, zfCalc_UserAdmin());
