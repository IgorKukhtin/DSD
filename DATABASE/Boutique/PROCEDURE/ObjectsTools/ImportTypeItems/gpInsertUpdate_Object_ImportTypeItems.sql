-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, TVarChar, Integer, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, TVarChar, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportTypeItems(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inParamNumber             Integer   ,    -- Номер параметра
    IN inName                    TVarChar  ,    -- Название параметра
    IN inParamType               TVarChar  ,    -- Тип параметра
    IN inUserParamName           TVarChar  ,    -- Название параметра для пользователя
    IN inImportTypeId            Integer   ,    -- ссылка на главное юр.лицо
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportTypeItems(), inParamNumber, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportType(), ioId, inImportTypeId);
   
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportTypeItems_ParamType(), ioId, inParamType);  
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportTypeItems_UserParamName(), ioId, inUserParamName);  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.14                          * 
 02.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportTypeItems ()                            
