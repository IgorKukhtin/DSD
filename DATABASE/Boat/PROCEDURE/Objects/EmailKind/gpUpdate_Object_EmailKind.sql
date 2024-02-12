-- Function: gpUpdate_Object_EmailKind(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_EmailKind(Integer,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_EmailKind(
    IN inId	                 Integer,       -- ключ объекта 
    IN inDropBox             TVarChar,      -- Директория сохранения в DropBox
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

 
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_EmailKind_DropBox(), inId, inDropBox);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.24         * 

*/

-- тест
--