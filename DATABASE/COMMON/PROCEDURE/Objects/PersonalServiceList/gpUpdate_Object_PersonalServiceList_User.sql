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


   IF -- если есть Ограничения - только разрешенные ведомости ЗП
      EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657326)
      -- + если есть Ограничения - доступ к просмотру ведомость Админ ЗП
   OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
   THEN
       RAISE EXCEPTION 'Ошибка.1.Нет прав.';
   END IF;

   -- IF inisUser = TRUE THEN RAISE EXCEPTION 'Ошибка.2.Нет прав.'; END IF;

   -- доступ Документы-меню (управленцы) + ЗП просмотр ВСЕ
   IF NOT EXISTS (SELECT 1 FROM Constant_User_LevelMax01_View WHERE Constant_User_LevelMax01_View.UserId = vbUserId)
   THEN
       RAISE EXCEPTION 'Ошибка.3.Нет прав.';
   END IF;

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