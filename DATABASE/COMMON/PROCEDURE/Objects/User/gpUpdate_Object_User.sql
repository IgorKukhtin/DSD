-- Function: gpUpdate_Object_User()

DROP FUNCTION IF EXISTS gpUpdate_Object_User (Integer, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User(
    IN inId          Integer   ,    -- ключ объекта <Пользователь> 
    IN inSign        TVarChar  ,    -- Электронная подпись
    IN inSeal        TVarChar  ,    -- Электронная печать
    IN inKey         TVarChar  ,    -- Электроный Ключ 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
   vbUserId:= lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Sign(), inId, inSign);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Seal(), inId, inSeal);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Key(), inId, inKey);
  
   -- Cохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_User ('2')