﻿-- Function: gpSelect_Object_PLZ_City()

DROP FUNCTION IF EXISTS gpSelect_Object_PLZ_City (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PLZ_City(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (CountryId Integer, CountryName TVarChar, CountryName_short TVarChar
             , City TVarChar
             , isErased Boolean
             )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PLZ());

   -- Результат
   RETURN QUERY
      SELECT DISTINCT
             Object_Country.Id                AS CountryId
           , Object_Country.ValueData         AS CountryName
           , ObjectString_ShortName.ValueData AS CountryName_short
           , ObjectString_City.ValueData      AS City
           , Object_PLZ.isErased              AS isErased
       FROM Object AS Object_PLZ
            LEFT JOIN ObjectString AS ObjectString_City
                                   ON ObjectString_City.ObjectId = Object_PLZ.Id
                                  AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()

            LEFT JOIN ObjectLink AS ObjectLink_Country
                                 ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                                AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
            LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = Object_Country.Id
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_Country_ShortName()

       WHERE Object_PLZ.DescId = zc_Object_PLZ()
         AND Object_PLZ.isErased = FALSE
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PLZ_City (inSession:= zfCalc_UserAdmin())
