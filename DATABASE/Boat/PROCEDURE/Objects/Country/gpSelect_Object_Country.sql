-- Страна производитель

DROP FUNCTION IF EXISTS gpSelect_Object_Country (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Country(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Country());


   -- результат
   RETURN QUERY
      SELECT Object_Country.Id               AS Id
           , Object_Country.ObjectCode       AS Code
           , Object_Country.ValueData        AS Name
           , COALESCE (ObjectString_ShortName.ValueData, NULL) :: TVarChar AS ShortName
           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Country.isErased         AS isErased
       FROM Object AS Object_Country
           LEFT JOIN ObjectString AS ObjectString_ShortName
                                  ON ObjectString_ShortName.ObjectId = Object_Country.Id
                                 AND ObjectString_ShortName.DescId = zc_ObjectString_Country_ShortName()

           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = Object_Country.Id
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_Insert
                                ON ObjectDate_Insert.ObjectId = Object_Country.Id
                               AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_Country.DescId = zc_Object_Country()
         AND (Object_Country.isErased = FALSE OR inIsShowAll = TRUE)
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
-- SELECT * FROM gpSelect_Object_Country (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
