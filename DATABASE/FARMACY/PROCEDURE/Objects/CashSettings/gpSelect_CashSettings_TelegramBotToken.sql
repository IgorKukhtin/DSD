-- Function: gpSelect_CashSettings_TelegramBotToken()

DROP FUNCTION IF EXISTS gpSelect_CashSettings_TelegramBotToken(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashSettings_TelegramBotToken(
   OUT outTelegramBotToken  TVarChar ,     -- Токен телеграм бота
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TVarChar AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   SELECT ObjectString_CashSettings_TelegramBotToken.ValueData                     AS TelegramBotToken
   INTO outTelegramBotToken
   FROM Object AS Object_CashSettings
        LEFT JOIN ObjectString AS ObjectString_CashSettings_TelegramBotToken
                               ON ObjectString_CashSettings_TelegramBotToken.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_TelegramBotToken.DescId = zc_ObjectString_CashSettings_TelegramBotToken()

   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_CashSettings_TelegramBotToken(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.11.21                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_CashSettings_TelegramBotToken ('3')