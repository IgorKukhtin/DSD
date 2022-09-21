-- Function: gpInsertUpdate_Object_TelegramGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TelegramGroup(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TelegramGroup(
 INOUT ioId               Integer   ,     -- ключ объекта <Регионы> 
    IN inCode             Integer   ,     -- Код объекта  
    IN inName             TVarChar  ,     -- Название объекта 
    IN inTelegramId       TVarChar  ,     -- Группа получателей в рассылке Акций
    IN inTelegramBotToken TVarChar  ,     -- Токен отправителя телеграм бота в рассылке Акций
    IN inSession          TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_TelegramGroup());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_TelegramGroup());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_TelegramGroup(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TelegramGroup(), inCode);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TelegramGroup(), inCode, inName);
         
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_TelegramGroup_Id(), ioId, inTelegramId);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_TelegramGroup_BotToken(), ioId, inTelegramBotToken);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.22         *
*/

-- тест
--