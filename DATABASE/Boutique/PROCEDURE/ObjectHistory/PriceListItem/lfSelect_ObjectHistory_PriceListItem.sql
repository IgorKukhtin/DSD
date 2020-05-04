-- Function: lfSelect_ObjectHistory_PriceListItem ()

-- DROP FUNCTION lfSelect_ObjectHistory_PriceListItem (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ключ 
    IN inOperDate           TDateTime   -- Дата действия
)                              
RETURNS TABLE (Id Integer, CurrencyId Integer, GoodsId Integer
             , StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat
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
             ObjectHistory_PriceListItem.Id
           , COALESCE (ObjectHistoryLink_Currency.ObjectId, vbCurrencyId_pl) :: Integer AS CurrencyId
           , ObjectLink_PriceListItem_Goods.ChildObjectId AS GoodsId

           , ObjectHistory_PriceListItem.StartDate
           , ObjectHistory_PriceListItem.EndDate
           , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                 ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                   AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                        ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                       AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_ObjectHistory_PriceListItem (Integer, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.13                                        * !!!а даты то пересекаются!!!
 21.07.13                                        *
*/

-- тест
-- SELECT * FROM lfSelect_ObjectHistory_PriceListItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
-- SELECT * FROM lfSelect_ObjectHistory_PriceListItem (zc_PriceList_Basis(), CURRENT_TIMESTAMP)
