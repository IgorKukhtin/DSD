-- Function: gpSelect_ObjectHistory_PriceListGoodsItem ()

-- DROP FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id

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
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
         AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
       ;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.13                        *
*/

-- тест
-- SELECT * FROM lfSelect_ObjectHistory_PriceListItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
-- SELECT * FROM lfSelect_ObjectHistory_PriceListItem (zc_PriceList_Basis(), CURRENT_TIMESTAMP)
