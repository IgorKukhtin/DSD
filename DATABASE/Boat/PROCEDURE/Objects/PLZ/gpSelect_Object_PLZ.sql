-- Function: gpSelect_Object_PLZ()

DROP FUNCTION IF EXISTS gpSelect_Object_PLZ (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PLZ(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameFull TVarChar
             , CountryId Integer, CountryName TVarChar
             , City TVarChar, AreaCode TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PLZ());


   -- результат
   RETURN QUERY
      SELECT Object_PLZ.Id                   AS Id
           , Object_PLZ.ObjectCode           AS Code
           , Object_PLZ.ValueData            AS Name         
           --PLZ + Город + Страна
           , TRIM (COALESCE (Object_PLZ.ValueData,'')||' '||ObjectString_City.ValueData||' '||Object_Country.ValueData) ::TVarChar AS NameFull
           , Object_Country.Id               AS CountryId
           , Object_Country.ValueData        AS CountryName
           , ObjectString_City.ValueData     AS City
           , ObjectString_AreaCode.ValueData AS AreaCode
           , ObjectString_Comment.ValueData  AS Comment
           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_PLZ.isErased             AS isErased
       FROM Object AS Object_PLZ
            LEFT JOIN ObjectString AS ObjectString_City
                                   ON ObjectString_City.ObjectId = Object_PLZ.Id
                                  AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()

            LEFT JOIN ObjectString AS ObjectString_AreaCode
                                   ON ObjectString_AreaCode.ObjectId = Object_PLZ.Id
                                  AND ObjectString_AreaCode.DescId = zc_ObjectString_PLZ_AreaCode()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_PLZ.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_PLZ_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Country
                                 ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                                AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
            LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_PLZ.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_PLZ.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_PLZ.DescId = zc_Object_PLZ()
         AND (Object_PLZ.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PLZ (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
