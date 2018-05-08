-- Function: gpSelect_Object_UnitCategory()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitCategory(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitCategory(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitCategory()());

   RETURN QUERY
   SELECT
          Object_UnitCategory.Id         AS Id
        , Object_UnitCategory.ObjectCode AS Code
        , Object_UnitCategory.ValueData  AS Name

        , Object_UnitCategory.isErased   AS isErased
   FROM Object AS Object_UnitCategory
   WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.05.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitCategory('3')