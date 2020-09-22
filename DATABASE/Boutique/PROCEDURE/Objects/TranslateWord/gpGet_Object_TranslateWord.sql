-- Function: gpGet_Object_TranslateWord(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_TranslateWord (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TranslateWord(
    IN inId          Integer,       -- Сотрудники
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, LanguageId Integer, LanguageName TVarChar, ParentId Integer, ParentName TVarChar, UnitId Integer, UnitName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TranslateWord());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , lfGet_ObjectCode(0, zc_Object_TranslateWord()) AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS LanguageId        
           , '' :: TVarChar                            AS LanguageName      
           ,  0 :: Integer                             AS ParentId           
           , '' :: TVarChar                            AS ParentName         
        ;
   ELSE
       RETURN QUERY
      SELECT 
             Object_TranslateWord.Id            AS Id
           , Object_TranslateWord.ObjectCode    AS Code
           , Object_TranslateWord.ValueData     AS Name
           , Object_Language.Id                 AS LanguageId
           , Object_Language.ValueData          AS LanguageName
           , Object_Parent.Id                   AS ParentId
           , Object_Parent.ValueData            AS ParentName
       FROM Object AS Object_TranslateWord
            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                 ON ObjectLink_TranslateWord_Language.ObjectId = Object_TranslateWord.Id
                                AND ObjectLink_TranslateWord_Language.DescId = zc_ObjectLink_TranslateWord_Language()
            LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_TranslateWord_Language.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                 ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                AND ObjectLink_TranslateWord_Parent.DescId = zc_ObjectLink_TranslateWord_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_TranslateWord_Parent.ChildObjectId

      WHERE Object_TranslateWord.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.09.20          *
*/

-- тест
-- SELECT * FROM gpSelect_TranslateWord (1,'2')
