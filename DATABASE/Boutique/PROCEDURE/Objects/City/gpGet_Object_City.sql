-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_Object_City(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_City(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CityKindId Integer, CityKindName TVarChar 
             , RegionId Integer, RegionName TVarChar
             , ProvinceId Integer, ProvinceName TVarChar
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
           , lfGet_ObjectCode(0, zc_Object_City()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS CityKindId
           , CAST ('' as TVarChar)  AS CityKindName

           , CAST (0 as Integer)    AS RegionId
           , CAST ('' as TVarChar)  AS RegionName
          
           , CAST (0 as Integer)    AS ProvinceId
           , CAST ('' as TVarChar)  AS ProvinceName

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_City.Id         AS Id
           , Object_City.ObjectCode AS Code
           , Object_City.ValueData  AS Name

           , Object_CityKind.Id          AS CityKindId
           , Object_CityKind.ValueData   AS CityKindName

           , Object_Region.Id            AS RegionId
           , Object_Region.ValueData     AS RegionName        

           , Object_Province.Id          AS ProvinceId
           , Object_Province.ValueData   AS ProvinceName

           , Object_City.isErased   AS isErased

       FROM Object AS Object_City
            LEFT JOIN ObjectLink AS ObjectLink_City_CityKind
                                 ON ObjectLink_City_CityKind.ObjectId = Object_City.Id
                                AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
            LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_City_Region 
                                 ON ObjectLink_City_Region.ObjectId = Object_City.Id
                                AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_City_Province
                                 ON ObjectLink_City_Province.ObjectId = Object_City.Id
                                AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
            LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId

       WHERE Object_City.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_City(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 31.05.14         * add CityKind, Region, Province 
 14.01.14                                                         *

*/

-- тест
-- SELECT * FROM gpGet_Object_City (0, '2')