-- Function: gpGet_Object_Street (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Street (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Street(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , PostalCode TVarChar
             , StreetKindId Integer, StreetKindName TVarChar
             , CityId Integer, CityName TVarChar
             , ProvinceCityId Integer, ProvinceCityName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Street());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_Street.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS PostalCode

           , CAST (0 as Integer)    AS StreetKindId
           , CAST ('' as TVarChar)  AS StreetKindName
          
           , CAST (0 as Integer)    AS CityId
           , CAST ('' as TVarChar)  AS CityName

           , CAST (0 as Integer)    AS ProvinceCityId
           , CAST ('' as TVarChar)  AS ProvinceCityName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_Street
       WHERE Object_Street.DescId = zc_Object_Street();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Street.Id          AS Id
           , Object_Street.ObjectCode  AS Code
           , Object_Street.ValueData   AS Name
           
           , PostalCode.ValueData      AS PostalCode
           
           , Object_StreetKind.Id           AS StreetKindId
           , Object_StreetKind.ValueData    AS StreetKindName
         
           , Object_City.Id                 AS CityId
           , Object_City.ValueData          AS CityName

           , View_ProvinceCity.PersonalId   AS ProvinceCityId
           , View_ProvinceCity.PersonalName AS ProvinceCityName
           
           , Object_Street.isErased AS isErased
           
       FROM Object AS Object_Street
       
            LEFT JOIN ObjectString AS PostalCode
                                   ON PostalCode.ObjectId = Object_Street.Id 
                                  AND PostalCode.DescId = zc_ObjectString_Street_PostalCode()
                                                             
            LEFT JOIN ObjectLink AS Street_StreetKind 
                                 ON Street_StreetKind.ObjectId = Object_Street.Id
                                AND Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
            LEFT JOIN Object AS Object_StreetKind ON Object_StreetKind.Id = Street_StreetKind.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Street_City
                                 ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Street_City.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity 
                                 ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
            LEFT JOIN Object_Personal_View AS View_ProvinceCity ON View_ProvinceCity.PersonalId = ObjectLink_Street_ProvinceCity.ChildObjectId
            
       WHERE Object_Street.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Street (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_Street (2, '')
