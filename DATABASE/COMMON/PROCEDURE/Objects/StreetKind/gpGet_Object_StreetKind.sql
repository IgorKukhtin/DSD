-- Function: gpGet_Object_StreetKind()

DROP FUNCTION IF EXISTS gpGet_Object_StreetKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StreetKind(
    IN inId          Integer,       -- ключ объекта <Вид (улица, проспект>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StreetKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StreetKind()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS ShortName
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS NAME
           , ShortName.ValueData  AS ShortName
           , Object.isErased   AS isErased
       FROM Object
             LEFT JOIN ObjectString AS ShortName
                                    ON ShortName.ObjectId = Object.Id 
                                   AND ShortName.DescId = zc_ObjectString_StreetKind_ShortName()
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_StreetKind(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.14         * add ShortName
 31.05.14         *
*/

-- тест
-- SELECT * FROM gpGet_Object_StreetKind (0, '2')