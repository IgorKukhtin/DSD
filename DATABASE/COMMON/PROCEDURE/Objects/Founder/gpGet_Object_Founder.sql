-- Function: gpGet_Object_Founder()

DROP FUNCTION IF EXISTS gpGet_Object_Founder(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Founder(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Founder());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Founder()) AS Code
           , CAST ('' as TVarChar)  AS Name
          
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_Founder.Id         AS Id
           , Object_Founder.ObjectCode AS Code
           , Object_Founder.ValueData  AS Name

           , Object_Founder.isErased   AS isErased

       FROM Object AS Object_Founder
       WHERE Object_Founder.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Founder(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.09.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Founder (0, '2')