--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TranslateObject (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TranslateObject(
 INOUT ioId              Integer,       -- ключ объекта <>
 INOUT ioCode            Integer,       -- свойство <Код 
    IN inName            TVarChar,      -- Название 
    IN inLanguageId      Integer,
    IN inObjectId        Integer,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TranslateObject());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_TranslateObject());

   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_TranslateObject(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_TranslateObject(), ioCode, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_TranslateObject_Language(), ioId, inLanguageId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_TranslateObject_Object(), ioId, inObjectId);


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
 17.02.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TranslateObject()
