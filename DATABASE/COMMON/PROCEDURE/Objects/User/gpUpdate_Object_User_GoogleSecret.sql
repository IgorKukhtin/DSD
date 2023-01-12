-- Function: gpUpdate_Object_User_GoogleSecret()

 DROP FUNCTION IF EXISTS gpUpdate_Object_User_GoogleSecret (TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_GoogleSecret(
    IN inGoogleSecret   TVarChar,      -- Секркт сотрудника
    IN inSession        TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
  vbUserId:= lpGetUserBySession (inSession);


  PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_SMS(), vbUserId, inGoogleSecret);

  -- Cохранили протокол
  PERFORM lpInsert_ObjectProtocol (inObjectId:= vbUserId, inUserId:= vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.12.22                                                       *              
*/

-- тест
-- SELECT * FROM gpUpdate_Object_User_GoogleSecret ('', '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')
