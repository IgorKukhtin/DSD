-- Function: gpSelect_Object_TelegramGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_TelegramGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TelegramGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TelegramId TVarChar, TelegramBotToken TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TelegramGroup()());

   RETURN QUERY 
   SELECT 
          Object_TelegramGroup.Id         AS Id 
        , Object_TelegramGroup.ObjectCode AS Code
        , Object_TelegramGroup.ValueData  AS Name  
        , ObjectString_TelegramGroup_Id.ValueData       ::TVarChar  AS TelegramId
        , ObjectString_TelegramGroup_BotToken.ValueData ::TVarChar AS TelegramBotToken
        , Object_TelegramGroup.isErased   AS isErased
   FROM Object AS Object_TelegramGroup
        LEFT JOIN ObjectString AS ObjectString_TelegramGroup_Id
                               ON ObjectString_TelegramGroup_Id.ObjectId = Object_TelegramGroup.Id
                              AND ObjectString_TelegramGroup_Id.DescId = zc_ObjectString_TelegramGroup_Id()
        LEFT JOIN ObjectString AS ObjectString_TelegramGroup_BotToken
                               ON ObjectString_TelegramGroup_BotToken.ObjectId = Object_TelegramGroup.Id
                              AND ObjectString_TelegramGroup_BotToken.DescId = zc_ObjectString_TelegramGroup_BotToken()
   WHERE Object_TelegramGroup.DescId = zc_Object_TelegramGroup();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.22         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_TelegramGroup('2')