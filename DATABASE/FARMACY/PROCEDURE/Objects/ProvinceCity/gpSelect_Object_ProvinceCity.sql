-- Function: gpSelect_Object_ProvinceCity()

DROP FUNCTION IF EXISTS gpSelect_Object_ProvinceCity(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProvinceCity(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProvinceCity()());

   RETURN QUERY
   SELECT
          Object_ProvinceCity.Id         AS Id
        , Object_ProvinceCity.ObjectCode AS Code
        , Object_ProvinceCity.ValueData  AS Name

        , Object_ProvinceCity.isErased   AS isErased
   FROM Object AS Object_ProvinceCity
   WHERE Object_ProvinceCity.DescId = zc_Object_ProvinceCity();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 08.08.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProvinceCity('2')