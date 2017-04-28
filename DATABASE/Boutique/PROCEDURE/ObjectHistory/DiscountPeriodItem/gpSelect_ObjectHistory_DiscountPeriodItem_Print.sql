-- Function: gpSelect_ObjectHistory_DiscountPeriodItem_Print ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodItem_Print (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriodItem_Print(
    IN inUnitId             Integer   , -- ключ 
    IN inOperDate           TDateTime , -- Дата действия
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer , ObjectId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar
             )
AS
$BODY$
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbVATPercent_pl TFloat;
BEGIN

     -- Выбираем данные
     RETURN QUERY 
      SELECT
             ObjectHistory_DiscountPeriodItem.Id
           , ObjectHistory_DiscountPeriodItem.ObjectId

           , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId AS GoodsId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
                    
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                     
       FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Unit

                                   
            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                                 ON ObjectLink_DiscountPeriodItem_Goods.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                AND ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
            LEFT JOIN Object AS Object_Goods
                             ON Object_Goods.Id = ObjectLink_DiscountPeriodItem_Goods.ChildObjectId

            LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Unit.ObjectId
                                   AND ObjectHistory_DiscountPeriodItem.DescId = zc_ObjectHistory_DiscountPeriodItem()
                                   AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                         ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                        AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          
       WHERE ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
         AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
         AND (ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData <> 0 ) --OR ObjectHistory_DiscountPeriodItem.StartDate <> zc_DateStart())
         AND Object_Goods.isErased = FAlSE
       ;
       
   END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem_Print (zc_Unit_ProductionSeparate(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem_Print (zc_Unit_Basis(), CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())

--select * from gpSelect_ObjectHistory_DiscountPeriodItem_Print(inUnitId := 18879 , inOperDate := '11.11.2015' ,  inSession := '5');
