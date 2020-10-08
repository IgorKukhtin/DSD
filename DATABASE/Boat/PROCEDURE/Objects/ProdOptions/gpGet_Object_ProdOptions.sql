-- Function: gpGet_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpGet_Object_ProdOptions(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdOptions(
    IN inId          Integer,       -- Названия Опций
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Level TFloat
             , Comment TVarChar
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdOptions());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdOptions())   AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 AS TFloat)     AS Level
           , CAST ('' AS TVarChar)  AS Comment
           
       FROM Object 
       WHERE Object.DescId = zc_Object_ProdOptions();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_ProdOptions.Id          AS Id 
         , Object_ProdOptions.ObjectCode  AS Code
         , Object_ProdOptions.ValueData   AS Name

         , ObjectFloat_Level.ValueData    AS Level
         , ObjectString_Comment.ValueData AS Comment
        
     FROM Object AS Object_ProdOptions
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptions_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_Level
                                ON ObjectFloat_Level.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_Level.DescId = zc_ObjectFloat_ProdOptions_Level()

       WHERE Object_ProdOptions.Id = inId;
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
-- SELECT * FROM gpGet_Object_ProdOptions(0, '2')