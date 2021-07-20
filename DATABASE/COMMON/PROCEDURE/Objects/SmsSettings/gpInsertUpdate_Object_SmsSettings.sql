-- 

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SmsSettings (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SmsSettings(
 INOUT ioId              Integer,       -- ключ объекта <>
    IN inCode            Integer,       -- свойство <Код >
    IN inName            TVarChar,      -- 
    IN inLogin           TVarChar,      --
    IN inMessage         TVarChar,      --
    IN inPassword        TVarChar,      --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SmsSettings());
   vbUserId:= lpGetUserBySession (inSession);


   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_SmsSettings()); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_SmsSettings(), inCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SmsSettings_Login(), ioId, inLogin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SmsSettings_Message(), ioId, inMessage);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SmsSettings_Password(), ioId, inPassword);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_SmsSettings()