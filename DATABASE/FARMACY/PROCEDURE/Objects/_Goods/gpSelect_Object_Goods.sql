-- Function: gpSelect_Object_Goods()

--DROP FUNCTION gpSelect_Object_Goods(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
              ExtraChargeCategoriesName TVarChar, MeasureName TVarChar,
              NDS TFloat, PartyCount TFloat, Price TFloat, PercentReprice TFloat, isReceiptNeed Boolean) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id          AS Id 
   , Object.ObjectCode  AS Code
   , Object.ValueData   AS Name
   , Object.isErased    AS isErased
   , ExtraChargeCategories.ValueData AS ExtraChargeCategoriesName
   , Measure.ValueData AS MeasureName
   , ObjectFloat_Goods_NDS.ValueData AS NDS
   , ObjectFloat_Goods_PartyCount.ValueData AS PartyCount
   , ObjectFloat_Goods_Price.ValueData AS Price
   , ObjectFloat_Goods_PercentReprice.ValueData AS PercentReprice
   , ObjectBoolean_Goods_isReceiptNeed.ValueData AS isReceiptNeed
   FROM Object
LEFT JOIN ObjectLink AS ObjectLink_Goods_ExtraChargeCategories
       ON ObjectLink_Goods_ExtraChargeCategories.ObjectId = Object.Id
      AND ObjectLink_Goods_ExtraChargeCategories.DescId = zc_ObjectLink_Goods_ExtraChargeCategories()
LEFT JOIN Object AS ExtraChargeCategories 
       ON ExtraChargeCategories.Id = ObjectLink_Goods_ExtraChargeCategories.ChildObjectId
LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
       ON ObjectLink_Goods_Measure.ObjectId = Object.Id
      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
LEFT JOIN Object AS Measure 
       ON Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
LEFT JOIN ObjectFloat AS ObjectFloat_Goods_NDS
       ON ObjectFloat_Goods_NDS.ObjectId = Object.Id
      AND ObjectFloat_Goods_NDS.DescId = zc_ObjectFloat_Goods_NDS()
LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PartyCount
       ON ObjectFloat_Goods_PartyCount.ObjectId = Object.Id
      AND ObjectFloat_Goods_PartyCount.DescId = zc_ObjectFloat_Goods_PartyCount()
LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
       ON ObjectFloat_Goods_Price.ObjectId = Object.Id
      AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()
LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentReprice
       ON ObjectFloat_Goods_PercentReprice.ObjectId = Object.Id
      AND ObjectFloat_Goods_PercentReprice.DescId = zc_ObjectFloat_Goods_PercentReprice()
LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isReceiptNeed
       ON ObjectBoolean_Goods_isReceiptNeed.ObjectId = Object.Id
      AND ObjectBoolean_Goods_isReceiptNeed.DescId = zc_ObjectBoolean_Goods_isReceiptNeed()
    WHERE Object.DescId = zc_Object_Goods();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Goods(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup('2')