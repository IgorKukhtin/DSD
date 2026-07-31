-- Function: gpSelect_MovementItem_PromoSaleGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoSaleGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoSaleGoods(
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
      , TradeMarkName       TVarChar 
      --, Amount              TFloat --% скидки на товар
      , Price               TFloat --Цена в прайсе c учетом скидки по договору
      , OperPriceList       TFloat --Цена в прайсе
      , PriceSale           TFloat --Цена на полке
      , PriceWithOutVAT     Numeric (16,8) --Цена отгрузки без учета НДС, с учетом скидки, грн
      , PriceWithVAT        Numeric (16,8) --Цена отгрузки с учетом НДС, с учетом скидки, грн
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
   DECLARE vbUserId            Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoSaleGoods());
    vbUserId:= lpGetUserBySession (inSession);


    CREATE TEMP TABLE _tmpPromoSalePartner (PartnerId Integer) ON COMMIT DROP;
    INSERT INTO _tmpPromoSalePartner (PartnerId)
            SELECT MI_PromoSalePartner.ObjectId        AS PartnerId   --ИД объекта <партнер>
            FROM Movement AS Movement_PromoSalePartner
                 INNER JOIN MovementItem AS MI_PromoSalePartner
                                         ON MI_PromoSalePartner.MovementId = Movement_PromoSalePartner.ID
                                        AND MI_PromoSalePartner.DescId = zc_MI_Master()
                                        AND MI_PromoSalePartner.IsErased = FALSE
            WHERE Movement_PromoSalePartner.ParentId = inMovementId
              AND Movement_PromoSalePartner.DescId = zc_Movement_PromoSalePartner();

    CREATE TEMP TABLE _tmpGoodsKind_inf (GoodsId Integer, ValueData TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpGoodsKind_inf (GoodsId, ValueData)
            SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , STRING_AGG (DISTINCT ObjectString_GoodsKind.ValueData :: TVarChar, ',') AS ValueData
            FROM _tmpPromoSalePartner
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                      ON ObjectLink_GoodsListSale_Partner.ChildObjectId = _tmpPromoSalePartner.PartnerId
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
             , Object_TradeMark.ValueData             AS TradeMarkName
             --, MovementItem.Amount                    AS Amount              --% скидки на товар
             , MIFloat_Price.ValueData         ::TFloat AS Price               --Цена в прайсе с учетом скидки по договору
             , MIFloat_OperPriceList.ValueData ::TFloat AS OperPriceList     -- Цена в прайсе
             , MIFloat_PriceSale.ValueData              AS PriceSale           --Цена на полке

               -- Цена отгрузки без учета НДС, с учетом скидки, грн
             , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_PriceWithOutVAT.ValueData / MIFloat_CountForPrice.ValueData
                          ELSE MIFloat_PriceWithOutVAT.ValueData
                     END AS Numeric (16, 8)
                    ) AS PriceWithOutVAT
               -- Цена отгрузки с учетом НДС, с учетом скидки, грн
             , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN MIFloat_PriceWithVAT.ValueData    / MIFloat_CountForPrice.ValueData
                          ELSE MIFloat_PriceWithVAT.ValueData
                     END AS Numeric (16, 8)
                    ) AS PriceWithVAT

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
     
             , MILinkObject_GoodsKind.ObjectId        AS GoodsKindId                 --ИД обьекта <Вид товара>
             , Object_GoodsKind.ValueData             AS GoodsKindName               --Наименование обьекта <Вид товара>
             , Object_GoodsKindComplete.Id            AS GoodsKindCompleteId         --ИД Вид товара(Примечание)
             , Object_GoodsKindComplete.ValueData     AS GoodsKindCompleteName       --Наименование обьекта <Вид товара(Примечание)>
             , tmpGoodsKind_list.GoodsKindName_List ::TVarChar                       -- Наименование обьекта <Вид товара (справочно)>

             , MIString_Comment.ValueData             AS Comment                     -- Примечание
             , MovementItem.isErased                  AS isErased                    -- Удален
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
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

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MovementItem.ObjectId
        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.26         * 
*/
-- тест
-- SELECT * FROM gpSelect_MovementItem_PromoSaleGoods (5083159 , FALSE, zfCalc_UserAdmin());
