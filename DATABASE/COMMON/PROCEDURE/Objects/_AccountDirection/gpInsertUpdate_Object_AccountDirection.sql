-- Function: gpInsertUpdate_Object_AccountDirection(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_AccountDirection (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccountDirection(
 INOUT ioId             Integer,       -- Ключ объекта <Аналитики управленческих счетов>
    IN inCode           Integer,       -- свойство <Код Аналитики управленческих счетов>
    IN inName           TVarChar,      -- свойство <Наименование Аналитики управленческих счетов>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
 
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_AccountDirection());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_AccountDirection();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- !!! проверка уникальности для свойства <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_AccountDirection(), inName);

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_AccountDirection(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AccountDirection(), Code_max, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AccountDirection (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.13                                        * rem lpCheckUnique_Object_ValueData
 17.06.13          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_AccountDirection()
