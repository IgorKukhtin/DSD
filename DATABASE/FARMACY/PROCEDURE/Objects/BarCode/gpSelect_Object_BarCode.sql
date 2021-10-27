-- Function: gpSelect_Object_BarCode()

DROP FUNCTION IF EXISTS gpSelect_Object_BarCode(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BarCode(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, BarCodeName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               ObjectId Integer, ObjectName TVarChar,
               MaxPrice TFloat, DiscountProcent TFloat, DiscountWithVAT TFloat, DiscountWithoutVAT TFloat,
               isDiscountSite Boolean,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BarCode());

   RETURN QUERY 
       SELECT 
             Object_BarCode.Id           AS Id
           , Object_BarCode.ObjectCode   AS Code
           , Object_BarCode.ValueData    AS BarCodeName
         
           , Object_Goods.Id             AS GoodsId
           , Object_Goods.ObjectCode     AS GoodsCode
           , Object_Goods.ValueData      AS GoodsName 
                     
           , Object_Object.Id            AS ObjectId
           , Object_Object.ValueData     AS ObjectName 
           
           , ObjectFloat_MaxPrice.ValueData  AS MaxPrice 
           , ObjectFloat_DiscountProcent.ValueData     AS DiscountProcent 
           , ObjectFloat_DiscountWithVAT.ValueData     AS DiscountWithVAT 
           , ObjectFloat_DiscountWithoutVAT.ValueData  AS DiscountWithoutVAT 
           , COALESCE (ObjectBoolean_DiscountSite.ValueData, False)   AS isDiscountSite 
           
           , Object_BarCode.isErased     AS isErased
           
       FROM Object AS Object_BarCode
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_BarCode_Goods.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

           LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                 ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
           LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                 ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()
           LEFT JOIN ObjectFloat AS ObjectFloat_DiscountWithVAT
                                 ON ObjectFloat_DiscountWithVAT.ObjectId = Object_BarCode.Id
                                AND ObjectFloat_DiscountWithVAT.DescId = zc_ObjectFloat_BarCode_DiscountWithVAT()
           LEFT JOIN ObjectFloat AS ObjectFloat_DiscountWithoutVAT
                                 ON ObjectFloat_DiscountWithoutVAT.ObjectId = Object_BarCode.Id
                                AND ObjectFloat_DiscountWithoutVAT.DescId = zc_ObjectFloat_BarCode_DiscountWithoutVAT()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_DiscountSite
                                   ON ObjectBoolean_DiscountSite.ObjectId = Object_BarCode.Id
                                  AND ObjectBoolean_DiscountSite.DescId = zc_ObjectBoolean_BarCode_DiscountSite()

       WHERE Object_BarCode.DescId = zc_Object_BarCode();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.09.21                                                       *  
 20.07.16         *

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_BarCode ('3')