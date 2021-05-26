-- Function: gpInsertUpdate_Object_Action()

-- DROP FUNCTION gpInsertUpdate_Object_Action();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Action(
 INOUT ioId	        Integer   ,     -- ключ объекта <Действия> 
    IN inCode           Integer   ,     -- Код объекта <Действия> 
    IN inName           TVarChar  ,     -- Название объекта <Действия>
    IN inSession        TVarChar        -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Action());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode(inCode, zc_Object_Action()); 
   
   -- проверка уникальности для свойства <Наименование Действия>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Action(), inName);
   -- проверка уникальности для свойства <Код Марки Действия>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Action(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Action(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Action()
