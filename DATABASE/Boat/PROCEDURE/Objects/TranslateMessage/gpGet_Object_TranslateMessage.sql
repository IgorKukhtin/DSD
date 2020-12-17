-- Function: gpGet_Object_TranslateMessage(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_TranslateMessage (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TranslateMessage(
    IN inId          Integer,       -- Сотрудники
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LanguageId Integer, LanguageName TVarChar
             , ParentId Integer, ParentName TVarChar
             , ProcedureName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TranslateMessage());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                             AS Id
           , lfGet_ObjectCode(0, zc_Object_TranslateMessage()) AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS LanguageId        
           , '' :: TVarChar                            AS LanguageName      
           ,  0 :: Integer                             AS ParentId           
           , '' :: TVarChar                            AS ParentName
           , '' :: TVarChar                            AS ProcedureName         
        ;
   ELSE
       RETURN QUERY
      SELECT 
             Object_TranslateMessage.Id         AS Id
           , Object_TranslateMessage.ObjectCode AS Code
           , Object_TranslateMessage.ValueData  AS Name
           , Object_Language.Id                 AS LanguageId
           , Object_Language.ValueData          AS LanguageName
           , Object_Parent.Id                   AS ParentId
           , Object_Parent.ValueData            AS ParentName
           , ObjectString_Name.ValueData        AS ProcedureName
       FROM Object AS Object_TranslateMessage
            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                 ON ObjectLink_TranslateMessage_Language.ObjectId = Object_TranslateMessage.Id
                                AND ObjectLink_TranslateMessage_Language.DescId = zc_ObjectLink_TranslateMessage_Language()
            LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_TranslateMessage_Language.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                 ON ObjectLink_TranslateMessage_Parent.ObjectId = Object_TranslateMessage.Id
                                AND ObjectLink_TranslateMessage_Parent.DescId = zc_ObjectLink_TranslateMessage_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_TranslateMessage_Parent.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Name
                                   ON ObjectString_Name.ObjectId = Object_TranslateMessage.Id
                                  AND ObjectString_Name.DescId = zc_ObjectString_TranslateMessage_Name()

      WHERE Object_TranslateMessage.Id = inId;

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
-- SELECT * FROM gpGet_Object_TranslateMessage (1, zfCalc_UserAdmin())
