-- Function: gpGet_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsTag(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsTag(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsGroupAnalystId Integer, GoodsGroupAnalystName TVarChar
             , ColorReport TFloat, ColorBgReport TFloat
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsTag()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS GoodsGroupAnalystId
           , CAST ('' as TVarChar)  AS GoodsGroupAnalystName  

           , CAST (0 as TFloat)     AS ColorReport
           , CAST (0 as TFloat)     AS ColorBgReport
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsTag.Id         AS Id
           , Object_GoodsTag.ObjectCode AS Code
           , Object_GoodsTag.ValueData  AS NAME
           
           , Object_GoodsGroupAnalyst.Id           AS GoodsGroupAnalystId
           , Object_GoodsGroupAnalyst.ValueData    AS GoodsGroupAnalystName  

           , ObjectFloat_ColorReport.ValueData     AS ColorReport
           , ObjectFloat_ColorBgReport.ValueData   AS ColorBgReport
           
           , Object_GoodsTag.isErased   AS isErased
           
       FROM Object AS Object_GoodsTag
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                ON ObjectFloat_ColorReport.ObjectId = Object_GoodsTag.Id 
                               AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsTag_ColorReport()
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorBgReport
                                ON ObjectFloat_ColorBgReport.ObjectId = Object_GoodsTag.Id 
                               AND ObjectFloat_ColorBgReport.DescId = zc_ObjectFloat_GoodsTag_ColorBgReport()

          LEFT JOIN ObjectLink AS ObjectLink_GoodsTag_GoodsGroupAnalyst
                               ON ObjectLink_GoodsTag_GoodsGroupAnalyst.ObjectId = Object_GoodsTag.Id 
                              AND ObjectLink_GoodsTag_GoodsGroupAnalyst.DescId = zc_ObjectLink_GoodsTag_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_GoodsTag_GoodsGroupAnalyst.ChildObjectId  
          
       WHERE Object_GoodsTag.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsTag (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.16         * 
 12.01.15         * add GoodsGroupAnalyst
 15.09.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsTag (0, '2')