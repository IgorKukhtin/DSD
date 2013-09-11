-- Function: gpInsertUpdate_Object_TradeMark(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TradeMark(
 INOUT ioId             Integer,       -- Ключ объекта <маршрут>
    IN inCode           Integer,       -- свойство <Код маршрута>
    IN inName           TVarChar,      -- свойство <Наименование маршрута>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
 
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_TradeMark());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_TradeMark();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка уникальности для свойства <Наименование Маршрута>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_TradeMark(), inName);
   -- проверка уникальности для свойства <Код маршрута>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TradeMark(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TradeMark(), Code_max, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.09.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TradeMark()
