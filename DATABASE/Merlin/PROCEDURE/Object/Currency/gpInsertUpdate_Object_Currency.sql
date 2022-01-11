-- Function: gpInsertUpdate_Object_Currency()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Currency(
 INOUT ioId                  Integer   ,   	-- ключ объекта <Валюта>
    IN inCode                Integer   ,    -- Международный код объекта <Валюта> 
    IN inName                TVarChar  ,    -- Название объекта <Валюта> 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Currency());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Если код не установлен, определяем его как последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Currency());

   -- проверка прав уникальности для свойства <Наименование Валюты>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Currency(), inName);
   -- проверка прав уникальности для свойства <Код Валюты>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Currency(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Currency(), inCode, inName);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь корр>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);   
   END IF;


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Currency()       