-- 
DROP FUNCTION IF EXISTS gpGet_Object_TranslateObject (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TranslateObject(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LanguageId Integer, LanguageName TVarChar
             , ObjectId Integer, ObjectName TVarChar
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TranslateObject());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_TranslateObject())   AS Code
           , '' :: TVarChar           AS Name
           , 0 :: Integer             AS LanguageId
           , '' :: TVarChar           AS LanguageName
           , 0 :: Integer             AS ObjectId
           , '' :: TVarChar           AS ObjectName
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_TranslateObject.Id          AS Id
           , Object_TranslateObject.ObjectCode  AS Code
           , Object_TranslateObject.ValueData   AS Name
           , Object_Language.Id                 AS LanguageId
           , Object_Language.ValueData          AS LanguageName
           , Object_Object.Id                   AS ObjectId
           , Object_Object.ValueData            AS ObjectName
       FROM Object AS Object_TranslateObject
          LEFT JOIN ObjectLink AS ObjectLink_Language
                               ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                              AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
          LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_Language.ChilObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChilObjectId
       WHERE Object_TranslateObject.Id = inId;
   END IF;

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
-- SELECT * FROM gpGet_Object_TranslateObject (1 ::integer,'2'::TVarChar)
