-- Function: lpGet_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_PriceListItem (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_PriceListItem(
    IN inOperDate           TDateTime , -- Дата действия
    IN inPriceListId        Integer   , -- ключ 
    IN inGoodsId            Integer     -- Товар
)                              
RETURNS TABLE (Id Integer, CurrencyId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
             , isDiscount Boolean
              )
AS
$BODY$
   DECLARE vbCurrencyId_pl Integer;
BEGIN

     -- Получили валюту для прайса
     vbCurrencyId_pl:= (SELECT COALESCE (OL_currency.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl
                        FROM ObjectLink AS OL_pl
                             LEFT JOIN ObjectLink AS OL_currency ON OL_currency.ObjectId = OL_pl.ChildObjectId
                                                                AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()
                        WHERE OL_pl.ObjectId = inPriceListId
                          AND OL_pl.DescId   = zc_ObjectLink_Unit_PriceList()
                       ); 

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id AS Id
           , COALESCE (ObjectHistoryLink_Currency.ObjectId, vbCurrencyId_pl) :: Integer AS CurrencyId
           , ObjectLink_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_Value.ValueData AS ValuePrice

             -- Цена со скидкой (1-Да, 0-НЕТ)
           , CASE WHEN COALESCE (ObjectHistoryFloat_isDiscount.ValueData, 0) = 1 THEN TRUE ELSE FALSE END :: Boolean AS isDiscount

       FROM ObjectLink AS ObjectLink_Goods
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_PriceList
                                  ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                 AND ObjectLink_PriceList.ChildObjectId = inPriceListId
                                 AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                         ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_isDiscount
                                         ON ObjectHistoryFloat_isDiscount.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_isDiscount.DescId          = zc_ObjectHistoryFloat_PriceListItem_isDiscount()

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                        ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                       AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()

       WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
         AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.05.15                                        *
*/

-- тест
-- SELECT * FROM lpGet_ObjectHistory_PriceListItem (CURRENT_TIMESTAMP, zc_PriceList_Basis(), 0)
