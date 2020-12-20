-- 

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Position(
 INOUT ioId              Integer,       -- ключ объекта <Бренд>
 INOUT ioCode            Integer,       -- свойство <Код Бренда>
    IN inName            TVarChar,      -- главное Название Бренда
    IN inComment         TVarChar,      --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Position());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_Position());

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Position(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Position(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Position_Comment(), ioId, inComment);

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
 25.10.20          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Position()
