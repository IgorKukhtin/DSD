-- 
DROP FUNCTION IF EXISTS gpSelect_Object_MeasureCode (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MeasureCode(
    IN inLanguageId  Integer,
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Name_translate TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MeasureCode());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       WITH
       tmpMeasureCode AS (SELECT Object_MeasureCode.*
                          FROM Object AS Object_MeasureCode
                          WHERE Object_MeasureCode.DescId = zc_Object_MeasureCode()
                            AND (Object_MeasureCode.isErased = FALSE OR inIsShowAll = TRUE)
                          )
       
       , tmpTranslate AS (SELECT ObjectLink_Object.ChildObjectId   AS MeasureCodeId
                               , Object_TranslateObject.ValueData AS Value
                          FROM Object AS Object_TranslateObject
                               INNER JOIN ObjectLink AS ObjectLink_Language
                                                     ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                    AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                    AND ObjectLink_Language.ChildObjectId = inLanguageId

                               LEFT JOIN ObjectLink AS ObjectLink_Object
                                                    ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                   AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                               INNER JOIN tmpMeasureCode ON tmpMeasureCode.Id = ObjectLink_Object.ChildObjectId
                          WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                            AND Object_TranslateObject.isErased = FALSE
                          )
                 
                 
                 
       -- результат
       SELECT
             Object_MeasureCode.Id              AS Id
           , Object_MeasureCode.ObjectCode      AS Code
           , Object_MeasureCode.ValueData       AS Name
           , tmpTranslate.Value  ::TVarChar     AS Name_translate

           , Object_Insert.ValueData            AS InsertName
           , ObjectDate_Insert.ValueData        AS InsertDate
           , Object_MeasureCode.isErased        AS isErased
       FROM tmpMeasureCode AS Object_MeasureCode
          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_MeasureCode.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_MeasureCode.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
                              
          LEFT JOIN tmpTranslate ON tmpTranslate.MeasureCodeId = Object_MeasureCode.Id
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
-- SELECT * FROM gpSelect_Object_MeasureCode (inLanguageId:=178, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())