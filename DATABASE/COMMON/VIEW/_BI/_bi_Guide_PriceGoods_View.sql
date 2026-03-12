-- View: _bi_Guide_PriceGoods_View

DROP VIEW IF EXISTS _bi_Guide_PriceGoods_View;

-- Справочник Price
/*          
-- Id элемента Товар
GoodsId
GoodsCode
GoodsName

--Id элемента Вид Товара
GoodsKindId
GoodsKindCode
GoodsKindName

-- Единица измерения
MeasureId
MeasureName

-- Прайс-лист
PriceListId
PriceListName
-- % НДС
VATPercent
isPriceWithVAT
-- Валюта
CurrencyId
CurrencyName

-- Дата цены
StartDate
-- Цена в грн без НДС
ValuePrice_sh
ValuePrice_ves

-- Цена в валюте без НДС
ValuePrice_curr_sh
ValuePrice_curr_ves

-- Курс
ValueCurrency

*/


CREATE OR REPLACE VIEW _bi_Guide_PriceGoods_View
AS
       WITH tmpCurrency_value AS (SELECT MILinkObject_CurrencyTo.ObjectId AS CurrencyId_to
                                       , MovementItem.ObjectId            AS CurrencyId_grn
                                       , MovementItem.Amount / CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS Amount
                                       , MIFloat_ParValue.ValueData       AS ParValue
                                       , Object_Currency.ValueData        AS CurrencyName_to
                                       , Movement.OperDate
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_CurrencyTo.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                                  FROM Object AS Object_Currency
                                       INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                         ON MILinkObject_CurrencyTo.ObjectId = Object_Currency.Id
                                                                        AND MILinkObject_CurrencyTo.DescId   = zc_MILinkObject_Currency()
                                       INNER JOIN MovementItem ON MovementItem.Id       = MILinkObject_CurrencyTo.MovementItemId
                                                              AND MovementItem.DescId   = zc_MI_Master()
                                                              AND MovementItem.isErased = FALSE
                                                              AND MovementItem.ObjectId = zc_Enum_Currency_Basis()
                                       INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                          AND Movement.DescId   = zc_Movement_Currency()
                                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                       LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                                   ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()

                                  WHERE Object_Currency.DescId = zc_Object_Currency()
                                 )
                                  

       SELECT
             -- Товар
             Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
            -- Вид Товара
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ObjectCode        AS GoodsKindCode
           , Object_GoodsKind.ValueData         AS GoodsKindName

            -- Единица измерения
           , Object_Measure.Id                  AS MeasureId
           , Object_Measure.ValueData           AS MeasureName


            -- Прайс-лист
           , Object_PriceList.Id                  AS PriceListId
           , Object_PriceList.ValueData           AS PriceListName
             -- Св-во "% НДС"
           , COALESCE (ObjectFloat_PriceList_VATPercent.ValueData, 0) :: TFloat AS VATPercent
            -- Св-во "Цена с НДС (да/нет)"
           , COALESCE (ObjectBoolean_PriceList_PriceWithVAT.ValueData, FALSE) :: Boolean AS isPriceWithVAT
            -- Валюта
           , Object_Currency.Id                  AS CurrencyId
           , Object_Currency.ValueData           AS CurrencyName
             -- Св-во "Дата цены"
           , ObjectHistory_PriceListItem.StartDate  AS StartDate
             -- Цена в грн без НДС
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                       THEN ObjectHistoryFloat_PriceListItem_Value.ValueData
                          -- если Цена с НДС
                          / CASE WHEN ObjectBoolean_PriceList_PriceWithVAT.ValueData = TRUE THEN (1 + COALESCE (ObjectFloat_PriceList_VATPercent.ValueData, 0)/100) ELSE 1 END
                  ELSE 0
             END AS ValuePrice_sh
           , CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                       THEN CASE WHEN ObjectFloat_Weight.ValueData > 0 THEN ObjectHistoryFloat_PriceListItem_Value.ValueData / ObjectFloat_Weight.ValueData ELSE 0 END
                          -- если Цена с НДС
                          / CASE WHEN ObjectBoolean_PriceList_PriceWithVAT.ValueData = TRUE THEN (1 + COALESCE (ObjectFloat_PriceList_VATPercent.ValueData, 0)/100) ELSE 1 END
                  ELSE ObjectHistoryFloat_PriceListItem_Value.ValueData
                     -- если Цена с НДС
                     / CASE WHEN ObjectBoolean_PriceList_PriceWithVAT.ValueData = TRUE THEN (1 + COALESCE (ObjectFloat_PriceList_VATPercent.ValueData, 0)/100) ELSE 1 END
             END AS ValuePrice_ves


       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            -- Прайс-лист
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_PriceListItem_PriceList.ChildObjectId
            -- Валюта
            LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency
                                 ON ObjectLink_PriceList_Currency.ObjectId = Object_PriceList.Id
                                AND ObjectLink_PriceList_Currency.DescId   = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_PriceList_Currency.ChildObjectId
            
            LEFT JOIN tmpCurrency_value ON tmpCurrency_value.CurrencyId_to = ObjectLink_PriceList_Currency.ChildObjectId
                                       AND tmpCurrency_value.Ord           = 1
            -- Св-во "% НДС"
            LEFT JOIN ObjectFloat AS ObjectFloat_PriceList_VATPercent
                                  ON ObjectFloat_PriceList_VATPercent.ObjectId = Object_PriceList.Id
                                 AND ObjectFloat_PriceList_VATPercent.DescId   = zc_ObjectFloat_PriceList_VATPercent()
            -- Св-во "Цена с НДС (да/нет)"
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceList_PriceWithVAT
                                    ON ObjectBoolean_PriceList_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceList_PriceWithVAT.DescId   = zc_ObjectBoolean_PriceList_PriceWithVAT()

            -- Товар
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_PriceListItem_Goods.ChildObjectId

            -- Единица измерения
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            -- Вес товара
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

            -- Вид Товара
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_PriceListItem_GoodsKind.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   -- Последняя цена
                                   AND ObjectHistory_PriceListItem.EndDate = zc_DateEnd()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
    ;

ALTER TABLE _bi_Guide_PriceGoods_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.05.25         *
*/

-- тест
-- SELECT * FROM _bi_Guide_PriceGoods_View
