-- Function: gpGet_Object_BarCode()

DROP FUNCTION IF EXISTS gpGet_Object_BarCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BarCode(
    IN inId          Integer,       --
    IN inSession     TVarChar       --
)
RETURNS TABLE (Id Integer, Code Integer, BarCodeName TVarChar,  
               GoodsId Integer, GoodsName TVarChar,
               ObjectId Integer, ObjectName TVarChar,
               MaxPrice TFloat, DiscountProcent TFloat, isDiscountSite Boolean,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BarCode());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_BarCode()) AS Code
           , CAST ('' as TVarChar)  AS BarCodeName
           
           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName 

           , CAST (0 as Integer)    AS ObjectId
           , CAST ('' as TVarChar)  AS ObjectName 
       
           , CAST (0 as TFloat)     AS MaxPrice
           , CAST (0 as TFloat)     AS DiscountProcent

           , False                  AS isDiscountSite

           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_BarCode.Id           AS Id
           , Object_BarCode.ObjectCode   AS Code
           , Object_BarCode.ValueData    AS BarCodeName
         
           , Object_Goods.Id             AS GoodsId
           , Object_Goods.ValueData      AS GoodsName 
           
           , Object_Object.Id            AS ObjectId
           , Object_Object.ValueData     AS ObjectName 

           , ObjectFloat_MaxPrice.ValueData  AS MaxPrice 
           , ObjectFloat_DiscountProcent.ValueData  AS DiscountProcent 
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

           LEFT JOIN ObjectBoolean AS ObjectBoolean_DiscountSite
                                   ON ObjectBoolean_DiscountSite.ObjectId = Object_BarCode.Id
                                  AND ObjectBoolean_DiscountSite.DescId = zc_ObjectBoolean_BarCode_DiscountSite()

      WHERE Object_BarCode.Id = inId;
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BarCode (Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.09.21                                                       *  
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpGet_Object_BarCode (0, '2')