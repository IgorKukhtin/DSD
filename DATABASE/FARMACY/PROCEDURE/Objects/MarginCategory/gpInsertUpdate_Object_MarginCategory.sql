-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, Tfloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategory(
    IN ioId             Integer,       -- Ключ объекта <Виды форм оплаты>
    IN inCode           Integer,       -- свойство <Код Вида формы оплаты>
    IN inName           TVarChar,      -- свойство <Наименование Вида формы оплаты>
    IN inPersent        Tfloat,        -- % наценки "общий"
    IN inisSite         Boolean,       -- для сайта
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE(Id INTEGER, Code Integer ) AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MarginCategory());
   
   -- проверка прав уникальности для свойства <Наименование Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MarginCategory(), inName);
   -- проверка прав уникальности для свойства <Код Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MarginCategory(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MarginCategory(), Code_max, inName);
   
   -- сохранили свойство <% наценки "общий">
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginCategory_Percent(), ioId, inPersent);
   -- сохранили свойство <для сайта>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MarginCategory_Site(), ioId, inisSite);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

   RETURN 
      QUERY SELECT ioId AS Id, Code_max AS Code;

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.16         *
 05.04.16         *
 09.04.15                          *

*/

-- тест
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'ау','2'); ROLLBACK
