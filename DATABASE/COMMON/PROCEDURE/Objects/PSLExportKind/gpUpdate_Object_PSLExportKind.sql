-- Function: gpUpdate_Object_PSLExportKind(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpUpdate_Object_PSLExportKind (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PSLExportKind(
    IN inId             Integer,       -- Ключ объекта <>
    IN inCode           Integer,       -- свойство <>
    IN inName           TVarChar,      -- свойство <>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PSLExportKind());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- сохранили <Объект>
   PERFORM lpInsertUpdate_Object (ioId, zc_Object_PSLExportKind(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.21         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PSLExportKind(2, 2,'ау','2')
