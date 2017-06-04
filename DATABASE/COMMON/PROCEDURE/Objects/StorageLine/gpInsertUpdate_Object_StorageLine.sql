-- Function: gpInsertUpdate_Object_StorageLine()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StorageLine(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StorageLine(
 INOUT ioId             Integer   ,     -- ключ объекта <Места хранения>
    IN inCode           Integer   ,     -- Код объекта
    IN inName           TVarChar  ,     -- Название объекта
    IN inComment        TVarChar  ,     -- Примечание
    IN inUnitId         Integer   ,     -- Подразделение
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StorageLine());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StorageLine());

   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_StorageLine(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StorageLine(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StorageLine(), vbCode_calc, inName);

   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_StorageLine_Comment(), ioId, inComment);
   -- сохранили связь с <Подразделение>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_StorageLine_Unit(), ioId, inUnitId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_StorageLine(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')