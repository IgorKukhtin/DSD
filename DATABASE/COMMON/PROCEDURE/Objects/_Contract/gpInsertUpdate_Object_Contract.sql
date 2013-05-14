-- Function: gpInsertUpdate_Object_Contract()

-- DROP FUNCTION gpInsertUpdate_Object_Contract (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId             Integer,       -- Ключ объекта <Договор>
    IN inInvNumber      TVarChar,      -- свойство <Номер договора>
    IN inComment        TVarChar,      -- свойство <Комментарий>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN


   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Contract());
   UserId := inSession;

   -- проверка прав уникальности для свойства <Номер договора>
   PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Contract_InvNumber(), inInvNumber);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), 0, '');
   
   -- сохранили свойство <Номер договора>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_InvNumber(), ioId, inInvNumber);

   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Contract (Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract()
