-- Function: gpInsertUpdate_Object_DriverSun()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DriverSun(Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DriverSun(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DriverSun(
 INOUT ioId             Integer   ,     -- ключ объекта <Водитель> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название объекта 
    IN inPhone          TVarChar  ,     -- Телефон
    IN inChatIDSendVIP  Integer   ,     -- Чат ID для отправки сообщений в Telegram по перемещениям VIP
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_DriverSun());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DriverSun());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_DriverSun(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DriverSun(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DriverSun(), vbCode_calc, inName);
   
   -- сохранили Телефон
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DriverSun_Phone(), ioId, inPhone);
   
   -- сохранили Чат ID для отправки сообщений в Telegram по перемещениям VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DriverSun_ChatIDSendVIP(), ioId, inChatIDSendVIP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.05.20                                                       *
 05.03.20                                                       *
*/

-- тест
-- 