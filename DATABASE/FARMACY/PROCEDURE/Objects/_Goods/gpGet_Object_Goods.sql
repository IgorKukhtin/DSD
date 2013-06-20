-- Function: gpGet_Object_Goods()

--DROP FUNCTION gpGet_Object_Goods();

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
              ExtraChargeCategoriesId Integer, ExtraChargeCategoriesName TVarChar, MeasureId Integer, MeasureName TVarChar,
              NDS TFloat, PartyCount TFloat, Price TFloat, PercentReprice TFloat, isReceiptNeed Boolean, CashName TVarChar) AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)   AS ExtraChargeCategoriesId
           , CAST ('' as TVarChar) AS ExtraChargeCategoriesName  
           , CAST (0 as Integer)   AS MeasureId
           , CAST ('' as TVarChar) AS MeasureName
           , CAST (0 as TFloat)    AS NDS
           , CAST (0 as TFloat)    AS PartyCount
           , CAST (0 as TFloat)    AS Price
           , CAST (0 as TFloat)    AS PercentReprice
           , false                 AS isReceiptNeed
           , CAST ('' as TVarChar) AS CashName
       FROM Object 
       WHERE Object.DescId = zc_Object_Goods();
   ELSE
     RETURN QUERY 
     SELECT 
       Object.Id                                   AS Id 
     , Object.ObjectCode                           AS Code
     , Object.ValueData                            AS Name
     , Object.isErased                             AS isErased
     , ExtraChargeCategories.Id                    AS ExtraChargeCategoriesId
     , ExtraChargeCategories.ValueData             AS ExtraChargeCategoriesName
     , Measure.Id                                  AS MeasureId
     , Measure.ValueData                           AS MeasureName
     , ObjectFloat_Goods_NDS.ValueData             AS NDS
     , ObjectFloat_Goods_PartyCount.ValueData      AS PartyCount
     , ObjectFloat_Goods_Price.ValueData           AS Price
     , ObjectFloat_Goods_PercentReprice.ValueData  AS PercentReprice
     , ObjectBoolean_Goods_isReceiptNeed.ValueData AS isReceiptNeed
     , ObjectString_Goods_CashName.ValueData       AS CashName
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
LEFT JOIN ObjectBoolean AS ObjectString_Goods_CashName
       ON ObjectString_Goods_CashName.ObjectId = Object.Id
      AND ObjectString_Goods_CashName.DescId = zc_ObjectString_Goods_CashName()
    WHERE Object.Id = inId;
  END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Goods(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.13                         *
 11.05.13                                        

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods('2')