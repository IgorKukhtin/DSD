-- Function: gpInsertUpdate_Object_RouteSorting(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_RouteSorting (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RouteSorting(
 INOUT ioId             Integer,       -- Ключ объекта <Сортировка маршрутов>
    IN inCode           Integer,       -- свойство <Код сортировки маршрутов>
    IN inName           TVarChar,      -- свойство <Наименование сортировки маршрутов>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_RouteSorting());
   UserId := inSession;

   -- проверка прав уникальности для свойства <Наименование Сортировки Маршрутов>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_RouteSorting(), inName);
   -- проверка прав уникальности для свойства <Код сортировки маршрутов>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RouteSorting(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RouteSorting(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RouteSorting (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.13          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RouteSorting(1,1,'1','1')
