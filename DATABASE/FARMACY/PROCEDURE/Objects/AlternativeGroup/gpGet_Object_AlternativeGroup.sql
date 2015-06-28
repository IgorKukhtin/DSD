DROP FUNCTION IF EXISTS gpGet_Object_AlternativeGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AlternativeGroup(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased Boolean) AS
$BODY$
BEGIN

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
           Object_AlternativeGroup_View.Id
           ,Object_AlternativeGroup_View.Name
           ,Object_AlternativeGroup_View.isErased

       FROM Object_AlternativeGroup_View
       WHERE Object_AlternativeGroup_View.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AlternativeGroup (Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 28.06.15                                                          *
*/

-- тест
-- SELECT * FROM gpGet_Object_AlternativeGroup (0, '')
