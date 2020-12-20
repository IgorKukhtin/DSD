-- Торговая марка

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsTag(
 INOUT ioId              Integer,       -- ключ объекта <>
 INOUT ioCode            Integer,       -- свойство <Код 
    IN inName            TVarChar,      -- Название 
    IN inComment         TVarChar,      --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_GoodsTag());

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsTag(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsTag(), ioCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsTag_Comment(), ioId, inComment);

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
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsTag()
