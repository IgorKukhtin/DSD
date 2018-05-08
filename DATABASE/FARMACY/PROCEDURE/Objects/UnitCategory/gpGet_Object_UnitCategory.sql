-- Function: gpGet_Object_UnitCategory()

DROP FUNCTION IF EXISTS gpGet_Object_UnitCategory(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_UnitCategory(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
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
           , lfGet_ObjectCode(0, zc_Object_UnitCategory()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_UnitCategory.Id         AS Id
           , Object_UnitCategory.ObjectCode AS Code
           , Object_UnitCategory.ValueData  AS Name
           , Object_UnitCategory.isErased   AS isErased

       FROM Object AS Object_UnitCategory
       WHERE Object_UnitCategory.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.05.18         *

*/

-- тест
-- SELECT * FROM gpGet_Object_UnitCategory (0, '3')