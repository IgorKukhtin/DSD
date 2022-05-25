-- Function: gpUpdate_Object_InfoMoney_isService()

DROP FUNCTION IF EXISTS gpUpdate_Object_InfoMoney_isService (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_InfoMoney_isService(
    IN inId                  Integer   ,  -- ключ объекта <> 
    IN inisService           Boolean   , 
   OUT outisService          Boolean   , 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_InfoMoney_Service());
   vbUserId:= lpGetUserBySession (inSession);

   outisService:= NOT inisService;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_InfoMoney_Service(), inId, outisService);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.05.22         *
*/

-- тест
--