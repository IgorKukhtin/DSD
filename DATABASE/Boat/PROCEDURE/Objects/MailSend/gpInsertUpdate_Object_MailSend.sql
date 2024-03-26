-- Function: gpInsertUpdate_Object_MailSend (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MailSend (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MailSend(
 INOUT ioId                       Integer   ,    -- Ключ объекта <> 
 INOUT ioCode                     Integer   ,    -- Код объекта <> 
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inComment                  TVarChar  ,    -- Примечание
    IN inMailKindId               Integer   ,    -- 
    IN inUserId                   Integer   ,    -- 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MailSend());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его как последний+1
   ioCode:=lfGet_ObjectCode (ioCode, zc_Object_User()); 

   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MailSend(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MailSend(), ioCode, inName);

   -- сохранили Примечание
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MailSend_Comment(), ioId, inComment);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MailSend_MailKind(), ioId, inMailKindId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MailSend_User(), ioId, inUserId);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
26.03.24          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MailSend()