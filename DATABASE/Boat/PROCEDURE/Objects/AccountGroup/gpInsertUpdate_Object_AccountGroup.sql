-- Function: gpInsertUpdate_Object_AccountGroup(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_AccountGroup (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccountGroup(
 INOUT ioId             Integer,       -- Ключ объекта <Группы управленческих счетов>
    IN inCode           Integer,       -- свойство <Код Группы управленческих счетов>
    IN inName           TVarChar,      -- свойство <Наименование Группы управленческих счетов>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_calc Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AccountGroup());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_AccountGroup()); 
   
   -- проверка уникальности для свойства <Наименование Группы управленческих счетов>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_AccountGroup(), inName);
   -- проверка уникальности для свойства <Код Группы управленческих счетов>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_AccountGroup(), Code_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_AccountGroup(), Code_calc, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
a
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_AccountGroup()
