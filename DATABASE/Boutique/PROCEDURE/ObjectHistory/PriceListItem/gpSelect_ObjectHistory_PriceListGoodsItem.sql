-- Function: gpSelect_ObjectHistory_PriceListGoodsItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListGoodsItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListGoodsItem(
    IN inPriceListId        Integer   , -- Прайс-Лист 
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat, isErased Boolean)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_PriceListItem.Id
           , CASE WHEN ObjectHistory_PriceListItem.StartDate = zc_DateStart() OR ObjectHistory_PriceListItem.StartDate < '01.01.1980' THEN NULL ELSE ObjectHistory_PriceListItem.StartDate END :: TDateTime AS StartDate
           , CASE WHEN ObjectHistory_PriceListItem.EndDate   = zc_DateEnd() THEN NULL ELSE ObjectHistory_PriceListItem.EndDate END :: TDateTime AS EndDate
           , ObjectHistoryFloat_Value.ValueData AS ValuePrice
           , FALSE AS isErased
       FROM ObjectLink AS ObjectLink_PriceList
            INNER JOIN ObjectLink AS ObjectLink_Goods
                                  ON ObjectLink_Goods.ObjectId      = ObjectLink_PriceList.ObjectId
                                 AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                 AND ObjectLink_Goods.ChildObjectId = inGoodsId

            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceList.ObjectId
                                   AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                         ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                        AND ObjectHistoryFloat_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()

       WHERE ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
         AND ObjectLink_PriceList.ChildObjectId = inPriceListId
         -- AND ObjectHistoryFloat_Value.ValueData <> 0
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListGoodsItem (inPriceListId:= 372, inGoodsId:= 406, inSession:= zfCalc_UserAdmin());
