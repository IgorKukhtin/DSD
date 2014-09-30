-- Function: gpInsertUpdate_Object_ImportType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportGroup (Integer, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportGroup(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Группы импорта>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportGroup(), 0, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportGroup_Object(), ioId, vbObjectId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportGroup (Integer, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportType ()                            
