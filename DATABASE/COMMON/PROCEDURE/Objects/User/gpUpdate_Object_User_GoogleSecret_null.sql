-- Function: gpUpdate_Object_User_GoogleSecret_null()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_GoogleSecret_null (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_GoogleSecret_null(
    IN inUserId   Integer,       --
    IN inSession  TVarChar       -- сессия пользователя
)
  RETURNS Void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
  vbUserId:= lpGetUserBySession (inSession);


  PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_SMS(), inUserId, '');

  -- Cохранили протокол
  PERFORM lpInsert_ObjectProtocol (inObjectId:= inUserId, inUserId:= vbUserId);

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
-- SELECT * FROM gpUpdate_Object_User_GoogleSecret_null ('5', '5')