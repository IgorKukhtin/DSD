-- Function: gpUpdate_Object_PersonalServiceList_User()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_User (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_User(
    IN inId             Integer   ,     -- ключ объекта <> 
    IN inisUser         Boolean   ,     -- 
   OUT outisUser        Boolean   ,     --
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_User());

   -- изменили значение
   outisUser:= Not inisUser;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_User(), inId, outisUser);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.07.24         *
*/

-- тест
--