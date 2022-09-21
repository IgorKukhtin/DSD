-- Function: gpGet_Object_TelegramGroup()

DROP FUNCTION IF EXISTS gpGet_Object_TelegramGroup(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TelegramGroup(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TelegramId TVarChar, TelegramBotToken TVarChar
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_TelegramGroup()) AS Code
           , CAST ('' AS TVarChar)  AS Name 
           , CAST ('' as TVarChar)  AS TelegramId
           , CAST ('' AS TVarChar)  AS TelegramBotToken
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_TelegramGroup.Id         AS Id
           , Object_TelegramGroup.ObjectCode AS Code
           , Object_TelegramGroup.ValueData  AS Name
           , ObjectString_TelegramGroup_Id.ValueData       ::TVarChar AS TelegramId
           , ObjectString_TelegramGroup_BotToken.ValueData ::TVarChar AS TelegramBotToken
       FROM Object AS Object_TelegramGroup
        LEFT JOIN ObjectString AS ObjectString_TelegramGroup_Id
                               ON ObjectString_TelegramGroup_Id.ObjectId = Object_TelegramGroup.Id
                              AND ObjectString_TelegramGroup_Id.DescId = zc_ObjectString_TelegramGroup_Id()
        LEFT JOIN ObjectString AS ObjectString_TelegramGroup_BotToken
                               ON ObjectString_TelegramGroup_BotToken.ObjectId = Object_TelegramGroup.Id
                              AND ObjectString_TelegramGroup_BotToken.DescId = zc_ObjectString_TelegramGroup_BotToken()
       WHERE Object_TelegramGroup.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.22         *

*/

-- тест
--SELECT * FROM gpGet_Object_TelegramGroup (1, '2')