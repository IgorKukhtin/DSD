-- 
DROP FUNCTION IF EXISTS gpSelect_Object_TranslateObject (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_TranslateObject (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TranslateObject(
    IN inLanguageId    Integer,
    IN inObjectDescId  Integer,
    IN inIsShowAll     Boolean,            -- признак показать удаленные да / нет 
    IN inSession       TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LanguageId Integer, LanguageName TVarChar
             , ObjectId Integer, ObjectName TVarChar, ObjectDescName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TranslateObject());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
                 
       -- результат
       SELECT
             Object_TranslateObject.Id          AS Id
           , Object_TranslateObject.ObjectCode  AS Code
           , Object_TranslateObject.ValueData   AS Name

           , Object_Language.Id                 AS LanguageId
           , Object_Language.ValueData          AS LanguageName

           , Object_Object.Id                   AS ObjectId
           , Object_Object.ValueData            AS ObjectName
           , ObjectDesc.ItemName                AS ObjectDescName

           , Object_Insert.ValueData            AS InsertName
           , ObjectDate_Insert.ValueData        AS InsertDate
           , Object_TranslateObject.isErased    AS isErased
       FROM Object AS Object_TranslateObject

          LEFT JOIN ObjectLink AS ObjectLink_Language
                               ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                              AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
          LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_Language.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_TranslateObject.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_TranslateObject.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

       WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
         AND (Object_TranslateObject.isErased = FALSE OR inIsShowAll = TRUE)
         AND (Object_Language.Id = inLanguageId OR inLanguageId = 0)
         AND (Object_Object.DescId = inObjectDescId OR inObjectDescId = 0)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TranslateObject (inLanguageId:=178, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())