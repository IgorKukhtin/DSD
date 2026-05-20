-- Function: lfSelect_ObjectHistory_PricePlanItem ()

-- DROP FUNCTION lfSelect_ObjectHistory_PricePlanItem (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfSelect_ObjectHistory_PricePlanItem(
    IN inPriceListId        Integer   , -- ключ 
    IN inOperDate           TDateTime   -- Дата действия
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsKindId Integer, StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_PricePlanItem.Id
           , ObjectLink_PricePlanItem_Goods.ChildObjectId     AS GoodsId
           , ObjectLink_PricePlanItem_GoodsKind.ChildObjectId AS GoodsKindId

           , ObjectHistory_PricePlanItem.StartDate
           , ObjectHistory_PricePlanItem.EndDate
           , ObjectHistoryFloat_PricePlanItem_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_PricePlanItem_PriceList
            LEFT JOIN ObjectLink AS ObjectLink_PricePlanItem_Goods
                                 ON ObjectLink_PricePlanItem_Goods.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                AND ObjectLink_PricePlanItem_Goods.DescId = zc_ObjectLink_PricePlanItem_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_PricePlanItem_GoodsKind
                                 ON ObjectLink_PricePlanItem_GoodsKind.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                AND ObjectLink_PricePlanItem_GoodsKind.DescId   = zc_ObjectLink_PricePlanItem_GoodsKind()

            INNER JOIN ObjectHistory AS ObjectHistory_PricePlanItem
                                     ON ObjectHistory_PricePlanItem.ObjectId = ObjectLink_PricePlanItem_PriceList.ObjectId
                                    AND ObjectHistory_PricePlanItem.DescId = zc_ObjectHistory_PricePlanItem()
                                    AND inOperDate >= ObjectHistory_PricePlanItem.StartDate AND inOperDate < ObjectHistory_PricePlanItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PricePlanItem_Value
                                         ON ObjectHistoryFloat_PricePlanItem_Value.ObjectHistoryId = ObjectHistory_PricePlanItem.Id
                                        AND ObjectHistoryFloat_PricePlanItem_Value.DescId = zc_ObjectHistoryFloat_PricePlanItem_Value()

       WHERE ObjectLink_PricePlanItem_PriceList.DescId = zc_ObjectLink_PricePlanItem_PriceList()
         AND ObjectLink_PricePlanItem_PriceList.ChildObjectId = inPriceListId
         AND ObjectHistoryFloat_PricePlanItem_Value.ValueData <> 0
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.26         *
*/

-- тест
-- SELECT * FROM lfSelect_ObjectHistory_PricePlanItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP)
-- SELECT * FROM lfSelect_ObjectHistory_PricePlanItem (zc_PriceList_Basis(), CURRENT_TIMESTAMP)
