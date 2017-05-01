-- Function: lfSelect_ObjectHistory_DiscountPeriodItem ()

-- DROP FUNCTION lfSelect_ObjectHistory_DiscountPeriodItem (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfSelect_ObjectHistory_DiscountPeriodItem(
    IN inUnitId             Integer   , -- ключ 
    IN inOperDate           TDateTime   -- Дата действия
)                              
RETURNS TABLE (Id Integer, GoodsId Integer, StartDate TDateTime, EndDate TDateTime, ValuePrice TFloat)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_DiscountPeriodItem.Id
           , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId

           , ObjectHistory_DiscountPeriodItem.StartDate
           , ObjectHistory_DiscountPeriodItem.EndDate
           , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS ValuePrice

       FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                 ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                   AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                                   AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                         ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

       WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
         AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
         AND ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData <> 0
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_ObjectHistory_DiscountPeriodItem (Integer, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.13                                        * !!!а даты то пересекаются!!!
 21.07.13                                        *
*/

-- тест
-- SELECT * FROM lfSelect_ObjectHistory_DiscountPeriodItem (zc_Unit_ProductionSeparate(), CURRENT_TIMESTAMP)
-- SELECT * FROM lfSelect_ObjectHistory_DiscountPeriodItem (zc_Unit_Basis(), CURRENT_TIMESTAMP)
