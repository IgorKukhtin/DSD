-- Function: gpGet_Object_ReplObject()

DROP FUNCTION IF EXISTS gpGet_Object_ReplObject(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReplObject(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ReplObject()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_ReplObject.Id         AS Id
            , Object_ReplObject.ObjectCode AS Code
            , Object_ReplObject.ValueData  AS Name
            , Object_ReplObject.isErased   AS isErased
       FROM Object AS Object_ReplObject
       WHERE Object_ReplObject.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.18         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReplObject (0, '2')