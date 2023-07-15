-- Function: gpSelect_Object_City()

DROP FUNCTION IF EXISTS gpSelect_Object_City(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_City(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_full TVarChar
             , CityKindId Integer, CityKindCode Integer, CityKindName TVarChar 
             , RegionId Integer, RegionCode Integer, RegionName TVarChar
             , ProvinceId Integer, ProvinceCode Integer, ProvinceName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City()());

   RETURN QUERY
   SELECT
          Object_City.Id         AS Id
        , Object_City.ObjectCode AS Code
        , Object_City.ValueData  AS Name  
        
        , ( CASE WHEN COALESCE (Object_Region.ValueData,'')   <> '' THEN COALESCE (Object_Region.ValueData,'') ||' обл., ' ELSE ''  END
              ||CASE WHEN COALESCE (Object_Province.ValueData,'') <> '' THEN COALESCE (Object_Province.ValueData,'') ||' район, ' ELSE ''  END
              ||CASE WHEN COALESCE (Object_CityKind.ValueData,'') <> '' THEN COALESCE (Object_CityKind.ValueData,'') ||' ' ELSE ''  END
              ||COALESCE (Object_City.ValueData,'')
             ) ::TVarChar AS Name_full

        , Object_CityKind.Id          AS CityKindId
        , Object_CityKind.ObjectCode  AS CityKindCode
        , Object_CityKind.ValueData   AS CityKindName

        , Object_Region.Id            AS RegionId
        , Object_Region.ObjectCode    AS RegionCode
        , Object_Region.ValueData     AS RegionName        

        , Object_Province.Id          AS ProvinceId
        , Object_Province.ObjectCode  AS ProvinceCode
        , Object_Province.ValueData   AS ProvinceName

        , Object_City.isErased             AS isErased
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

   WHERE Object_City.DescId = zc_Object_City();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_City(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 31.05.14         * add CityKind, Region, Province 
 14.01.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_City('2')