-- Function: gpGet_Object_ProdEngine()

DROP FUNCTION IF EXISTS gpGet_Object_ProdEngine(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdEngine(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Power TFloat, Volume TFloat
             , Comment TVarChar
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdEngine());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdEngine())   AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 AS TFloat)     AS Power
           , CAST (0 AS TFloat)     AS Volume
           , CAST ('' AS TVarChar)  AS Comment
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ProdEngine.Id             AS Id 
         , Object_ProdEngine.ObjectCode     AS Code
         , Object_ProdEngine.ValueData      AS Name

         , ObjectFloat_Power.ValueData      AS Power
         , ObjectFloat_Volume.ValueData     AS Volume
         , ObjectString_Comment.ValueData   AS Comment
        
     FROM Object AS Object_ProdEngine
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdEngine.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdEngine_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume()

       WHERE Object_ProdEngine.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdEngine(0, '2')