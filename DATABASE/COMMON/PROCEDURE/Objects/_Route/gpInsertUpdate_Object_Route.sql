-- Function: gpInsertUpdate_Object_Route()

-- DROP FUNCTION gpInsertUpdate_Object_Route (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Route(
 INOUT ioId             Integer,       -- Ключ объекта <маршрут>
    IN inCode           Integer,       -- свойство <Код маршрута>
    IN inName           TVarChar,      -- свойство <Наименование маршрута>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN


   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Route());
   UserId := inSession;

   -- проверка прав уникальности для свойства <Маршрут>
   PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_Object_Route(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Route(), inCode, inName);
   
      -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Route (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.13          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Route()
