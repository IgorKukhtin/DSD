-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettingsItems(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inImportSettingsId        Integer   ,    -- ссылка на главное юр.лицо
    IN inImportTypeItemsId       Integer   ,    -- ссылка на 
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());

   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportTypeItems(), inName);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportTypeItems(), 0, inName);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportSettings(), ioId, inImportSettingsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportTypeItems(), ioId, inImportTypeItemsId);
     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportSettingsItems ()                            
