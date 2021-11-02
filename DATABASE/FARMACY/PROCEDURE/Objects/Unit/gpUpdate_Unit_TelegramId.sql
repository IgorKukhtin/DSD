-- Function: gpUpdate_Unit_TelegramId()

DROP FUNCTION IF EXISTS gpUpdate_Unit_TelegramId(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_TelegramId(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inTelegramId          TVarChar  ,    -- ID аптеки в Telegram	
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
      
   -- ID аптеки в Telegram
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_TelegramId(), inId, TRIM(inTelegramId));

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.11.21                                                       *
*/

-- select * from gpUpdate_Unit_TelegramId(inId := 10779386 , inTelegramId := '2089181519' ,  inSession := '3');