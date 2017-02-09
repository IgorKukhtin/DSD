-- Function: gpInsertUpdate_Object_ImportType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportGroupItems (Integer, Integer, Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportGroupItems(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inImportSettingsId        Integer   ,    -- 
    IN inImportGroupId           Integer   ,    -- 
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportGroupItems(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportGroupItems_ImportSettings(), ioId, inImportSettingsId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportGroupItems_ImportGroup(), ioId, inImportGroupId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportGroupItems (Integer, Integer, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportType ()                            
