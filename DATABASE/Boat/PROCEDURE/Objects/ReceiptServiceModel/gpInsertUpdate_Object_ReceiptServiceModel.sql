-- 

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptServiceModel (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptServiceModel(
 INOUT ioId           Integer,       -- Ключ объекта < >
 INOUT ioCode         Integer,       -- Код Объекта < >
    IN inName         TVarChar,      -- Название объекта <>
    IN inComment      TVarChar,      --
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptServiceModel());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReceiptServiceModel()); 

   -- проверка уникальности для свойства <Наименование Страна>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReceiptServiceModel(), inName, vbUserId);
   -- проверка уникальности для свойства <Код Страна>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReceiptServiceModel(), ioCode, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptServiceModel(), ioCode, inName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptServiceModel_Comment(), ioId, inComment);

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
 19.03.24          *
*/

-- тест
--