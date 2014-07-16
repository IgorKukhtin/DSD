-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportTypeItems(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
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

   -- Если код не установлен, определяем его как последний+1 
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_ImportTypeItems());
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportTypeItems(), vbCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportType(), ioId, inImportTypeId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportTypeItems ()                            
