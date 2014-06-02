-- Function: gpGet_Object_ProvinceCity()

DROP FUNCTION IF EXISTS gpGet_Object_ProvinceCity(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProvinceCity(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CityId Integer, CityCode Integer, CityName TVarChar
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
           , lfGet_ObjectCode(0, zc_Object_ProvinceCity()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS CityId
           , CAST (0 as Integer)    AS CityCode
           , CAST ('' as TVarChar)  AS CityName

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_ProvinceCity.Id         AS Id
           , Object_ProvinceCity.ObjectCode AS Code
           , Object_ProvinceCity.ValueData  AS Name

           , Object_City.Id            AS CityId
           , Object_City.ObjectCode    AS CityCode
           , Object_City.ValueData     AS CityName        

           , Object_ProvinceCity.isErased   AS isErased

       FROM Object AS Object_ProvinceCity
            LEFT JOIN ObjectLink AS ObjectLink_ProvinceCity_City 
                                 ON ObjectLink_ProvinceCity_City.ObjectId = Object_ProvinceCity.Id
                                AND ObjectLink_ProvinceCity_City.DescId = zc_ObjectLink_ProvinceCity_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_ProvinceCity_City.ChildObjectId

       WHERE Object_ProvinceCity.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ProvinceCity(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.05.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_ProvinceCity (0, '2')