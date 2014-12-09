-- Function: gpGet_Object_GoodsQuality (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsQuality (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsQuality(
    IN inId          Integer,       --   Параметры качественного удостоверения
    IN inSession     TVarChar       -- текущий пользователь 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               Value1 TVarChar, Value2 TVarChar, 
               Value3 TVarChar, Value4 TVarChar,
               Value5 TVarChar, Value6 TVarChar, 
               Value7 TVarChar, Value8 TVarChar,
               Value9 TVarChar, Value10 TVarChar,
               GoodsId Integer, GoodsName TVarChar
               ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsQuality()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       
           , CAST ('' as TVarChar)  AS Value1
           , CAST ('' as TVarChar)  AS Value2
           , CAST ('' as TVarChar)  AS Value3
           , CAST ('' as TVarChar)  AS Value4
           , CAST ('' as TVarChar)  AS Value5
           , CAST ('' as TVarChar)  AS Value6
           , CAST ('' as TVarChar)  AS Value7
           , CAST ('' as TVarChar)  AS Value8
           , CAST ('' as TVarChar)  AS Value9
           , CAST ('' as TVarChar)  AS Value10
           
           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsQuality.Id          AS Id
           , Object_GoodsQuality.ObjectCode  AS Code
           , Object_GoodsQuality.ValueData   AS Name
           , Object_GoodsQuality.isErased    AS isErased

           , ObjectString_Value1.ValueData AS Value1
           , ObjectString_Value2.ValueData AS Value2 
           , ObjectString_Value3.ValueData AS Value3
           , ObjectString_Value4.ValueData AS Value4
           , ObjectString_Value5.ValueData AS Value5
           , ObjectString_Value6.ValueData AS Value6
           , ObjectString_Value7.ValueData AS Value7
           , ObjectString_Value8.ValueData AS Value8
           , ObjectString_Value9.ValueData AS Value9           
           , ObjectString_Value10.ValueData AS Value10
                                                      
           , Object_Goods.Id        AS GoodsId
           , Object_Goods.ValueData AS GoodsName 
                     
       FROM Object AS Object_GoodsQuality
           LEFT JOIN ObjectString AS ObjectString_Value1
                               ON ObjectString_Value1.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
           LEFT JOIN ObjectString AS ObjectString_Value2
                               ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
           LEFT JOIN ObjectString AS ObjectString_Value3
                               ON ObjectString_Value3.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()                             
           LEFT JOIN ObjectString AS ObjectString_Value4
                               ON ObjectString_Value4.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
           LEFT JOIN ObjectString AS ObjectString_Value5
                               ON ObjectString_Value5.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()                             
           LEFT JOIN ObjectString AS ObjectString_Value6
                               ON ObjectString_Value6.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
           LEFT JOIN ObjectString AS ObjectString_Value7
                               ON ObjectString_Value7.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
           LEFT JOIN ObjectString AS ObjectString_Value8
                               ON ObjectString_Value8.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()                             
           LEFT JOIN ObjectString AS ObjectString_Value9
                               ON ObjectString_Value9.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()  
           LEFT JOIN ObjectString AS ObjectString_Value10
                               ON ObjectString_Value10.ObjectId = Object_GoodsQuality.Id 
                              AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()
                                                                       
           LEFT JOIN ObjectLink AS GoodsQuality_Goods
                                ON GoodsQuality_Goods.ObjectId = Object_GoodsQuality.Id
                               AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsQuality_Goods.ChildObjectId
                      
       WHERE Object_GoodsQuality.Id = inId;
   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsQuality (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.12.14         * 

*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsQuality (1, zfCalc_UserAdmin())
