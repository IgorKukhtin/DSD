-- Function: gpGet_Object_Retail()

DROP FUNCTION IF EXISTS gpGet_Object_Retail(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Retail(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GLNCode TVarChar 
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Retail()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS GLNCode
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS NAME
           , GLNCode.ValueData AS GLNCode
           , Object.isErased   AS isErased
       FROM Object
        LEFT JOIN ObjectString AS GLNCode
                               ON GLNCode.ObjectId = Object.Id 
                              AND GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Retail(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.14         * add GLNCode
 23.05.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Retail (0, '2')