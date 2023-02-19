-- Function: gpUpdate_Unit_SendErrorTelegramBot()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SendErrorTelegramBot(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SendErrorTelegramBot(
    IN inId                     Integer   ,    -- ключ объекта <Подразделение>
    IN inisSendErrorTelegramBot Boolean   ,    -- Отправлять ошибки отправки чеков в телеграм бот
    IN inSession                TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 OR 
      COALESCE((SELECT ObjectBoolean_SendErrorTelegramBot.ValueData 
                FROM ObjectBoolean AS ObjectBoolean_SendErrorTelegramBot
                WHERE ObjectBoolean_SendErrorTelegramBot.ObjectId = COALESCE(inId, 0)
                  AND ObjectBoolean_SendErrorTelegramBot.DescId = zc_ObjectBoolean_Unit_SendErrorTelegramBot()), False) <>
      inisSendErrorTelegramBot
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SendErrorTelegramBot(), inId, not inisSendErrorTelegramBot);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.06.22                                                       *
*/

-- select * from gpUpdate_Unit_SendErrorTelegramBot(inId := 13338606 , inisSendErrorTelegramBot := 'False' ,  inSession := '3');