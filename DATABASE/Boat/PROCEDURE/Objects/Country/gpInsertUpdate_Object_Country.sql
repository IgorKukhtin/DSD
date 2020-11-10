-- Страна производитель

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Country (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Country(
 INOUT ioId           Integer,       -- Ключ объекта <Страна >
 INOUT ioCode         Integer,       -- Код Объекта <Страна >
    IN inName         TVarChar,      -- Название объекта <Страна>
    IN inShortName    TVarChar,      -- Краткое название
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Country());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_Country()); 

   -- проверка уникальности для свойства <Наименование Страна>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Country(), inName);
   -- проверка уникальности для свойства <Код Страна>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Country(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Country(), ioCode, inName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Country_ShortName(), ioId, inShortName);

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
 09.11.20          *
*/

-- тест
--