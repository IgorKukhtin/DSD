-- Function: gpInsertUpdate_Object_MCRequest(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MCRequest (Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MCRequest(
 INOUT ioId             Integer,       -- Ключ объекта <Виды форм оплаты>
    IN inCode           Integer,       -- свойство <Код Вида формы оплаты>
    IN inName           TVarChar,      -- свойство <Наименование Вида формы оплаты>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MCRequest());
   
   -- проверка прав уникальности для свойства <Наименование Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MCRequest(), inName);
   -- проверка прав уникальности для свойства <Код Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MCRequest(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MCRequest(), Code_max, inName);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.22                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MCRequest(0, 1, '', '3');