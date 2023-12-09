-- Function: gpInsertUpdate_Object_InvoiceKind(Integer, Integer, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_InvoiceKind (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InvoiceKind(
 INOUT ioId             Integer,       -- Ключ объекта <>
    IN inCode           Integer,       -- свойство <>
    IN inName           TVarChar,      -- свойство <Наименование> 
    IN inComment        TVarChar,      -- свойство <Примечание>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InvoiceKind());
   vbUserId := inSession;

    -- Если код не установлен, определяем его как последний+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_Client());
   
   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_InvoiceKind(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_InvoiceKind(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_InvoiceKind(), inCode, inName);   
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_InvoiceKind_Comment(), ioId, inComment);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.23          *

*/

-- тест
--