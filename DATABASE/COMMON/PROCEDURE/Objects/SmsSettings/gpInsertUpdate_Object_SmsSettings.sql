-- 

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SmsSettings (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SmsSettings (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SmsSettings(
 INOUT ioId              Integer,       -- ключ объекта <>
    IN inDescId          Integer,       -- свойство <Код >
    IN inValue           TVarChar,      -- 
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
 
   --проверка, должна быть одна запись
   IF (SELECT COUNT (*) FROM Object WHERE Object.DescId = zc_Object_SmsSettings()) > 1
   THEN
         RAISE EXCEPTION 'Ошибка.В справочнике уже сохранен элемент';  
   END IF;
 
   -- Если код не установлен, определяем его как последний+1
   --inCode:= lfGet_ObjectCode (inCode, zc_Object_SmsSettings()); 

   -- сохранили <Объект> 
   IF inDescId =  zc_Object_SmsSettings()
   THEN
       --
       ioId := lpInsertUpdate_Object(ioId, zc_Object_SmsSettings(), 0, inValue);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectString(inDescId, ioId, inValue);
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
 04.11.25         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_SmsSettings()