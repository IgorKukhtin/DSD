-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettingsItems(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inName                    TVarChar  ,    -- Значение параметра
    IN inImportSettingsId        Integer   ,    -- ссылка на настройки импорта
    IN inImportTypeItemsId       Integer   ,    -- ссылка на параметры
    IN inDefaultValue            TVarChar  ,    -- Значение параметра по умолчанию
    IN inConvertFormatInExcel    Boolean   DEFAULT FALSE,  -- Конвертировать формат в Excel
    IN inSession                 TVarChar  DEFAULT ''      -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   -- vbUserId := lpGetUserBySession (inSession); 
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportSettingsItems(), 0, inName);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettingsItems_ImportSettings(), ioId, inImportSettingsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettingsItems_ImportTypeItems(), ioId, inImportTypeItemsId);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportSettingsItems_DefaultValue(), ioId, inDefaultValue);
   
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel(), ioId, inConvertFormatInExcel);
     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar, Boolean, TVarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Подмогильный В.В.
 09.02.18                                                           * 
 10.09.14                         * 
 03.07.14         * 

*/

-- тест
--select * from gpInsertUpdate_Object_ImportSettingsItems(ioId := 0 , inName := 'sfd' , inImportSettingsId := 329 , inImportTypeItemsId := 0 ,  inSession := '8');                            
