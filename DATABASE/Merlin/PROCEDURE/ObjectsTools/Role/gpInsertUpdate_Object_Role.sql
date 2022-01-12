-- Function: gpInsertUpdate_Object_Role()

-- DROP FUNCTION gpInsertUpdate_Object_Role();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Role(
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
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Role());
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Role());

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN inCode := NEXTVAL ('Object_Role_seq'); END IF; 
   
   -- проверка уникальности для свойства <Наименование Действия>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Role(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Role(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 06.05.17                                                        *
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Role()
