-- Function: gpUpdate_Object_Cash_UserAll()

DROP FUNCTION IF EXISTS gpUpdate_Object_Cash_UserAll (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Cash_UserAll(
    IN inId                  Integer   ,  -- ключ объекта <> 
    IN inisUserAll           Boolean   , 
   OUT outisUserAll          Boolean   , 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Cash_UserAll());
   --vbUserId:= lpGetUserBySession (inSession);

   outisUserAll:= NOT inisUserAll;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Cash_UserAll(), inId, outisUserAll);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         *
*/

-- тест
--