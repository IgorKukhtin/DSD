-- Function: gpSelect_ObjectHistory_DiscountPeriodGoodsItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodGoodsItem (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriodGoodsItem(
    IN inUnitId             Integer   , -- Подразделение
    IN inGoodsId            Integer   , -- Товар
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , ValuePrice TFloat, ValueNextPrice TFloat
             , isErased Boolean)
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY 
       SELECT
             ObjectHistory_DiscountPeriodItem.Id
           , ObjectHistory_DiscountPeriodItem.StartDate
           , ObjectHistory_DiscountPeriodItem.EndDate
           , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData     AS ValuePrice
           , ObjectHistoryFloat_DiscountPeriodItem_ValueNext.ValueData AS ValueNextPrice
           , False AS isErased
       FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                 ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()

            LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                   AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                         ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_ValueNext
                                         ON ObjectHistoryFloat_DiscountPeriodItem_ValueNext.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_ValueNext.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_ValueNext()

       WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
         AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
         AND ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = inGoodsId;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_DiscountPeriodGoodsItem (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.17         *
*/

-- тест
-- select * from gpSelect_ObjectHistory_DiscountPeriodGoodsItem(inUnitId := 311 , inGoodsId := 271 ,  inSession := '2');