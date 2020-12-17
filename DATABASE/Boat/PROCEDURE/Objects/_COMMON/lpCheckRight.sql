-- Function: gpSelect_Object_Process()

DROP FUNCTION IF EXISTS lpCheckRight (TVarChar, Integer, Date);

CREATE OR REPLACE FUNCTION lpCheckRight(
    IN inSession     TVarChar     , -- сессия пользователя
    IN inProcessId   Integer      , --
    IN inOperDate    Date DEFAULT current_Date)
RETURNS Integer
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
  --
  vbUserId := lpGetUserBySession (inSession);

  -- для Админа  - Все Права
  IF EXISTS (SELECT 1
             FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                      JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                      ON Object_UserRole_Role.DescId        = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId      = Object_UserRole_User.ObjectId
                                     AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
             WHERE Object_UserRole_User.DescId        = zc_ObjectLink_UserRole_User()
               AND Object_UserRole_User.ChildObjectId = vbUserId
            )
     -- кроме тех Админов  - где "некоторые" Права забрали :)
     AND NOT EXISTS (SELECT 1
                     FROM Object_Role_Process_View
                     WHERE -- Т.е. этот процесс есть в списке Роли с zc_Enum_Process_AccessKey_Check
                           Object_Role_Process_View.ProcessId = inProcessId
                       AND Object_Role_Process_View.RoleId    IN (-- Вот они Роли + Пользователи: с проверкой прав = НЕЛЬЗЯ
                                                                  SELECT Object_RoleAccessKey_View.RoleId 
                                                                  FROM Object_RoleAccessKey_View
                                                                  WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                                                                    AND Object_RoleAccessKey_View.UserId      = vbUserId
                                                                 )
                    )
  THEN
     RETURN vbUserId;
  ELSE

      IF NOT EXISTS (SELECT 1
                     FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                          JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                          ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                         AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                                         AND Object_UserRole_Role.ChildObjectId NOT IN
                                                                  -- Вот они Роли + Пользователи: с проверкой прав = НЕЛЬЗЯ
                                                                 (SELECT Object_RoleAccessKey_View.RoleId 
                                                                  FROM Object_RoleAccessKey_View
                                                                  WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                                                                    AND Object_RoleAccessKey_View.UserId      = vbUserId
                                                                 )
                          JOIN ObjectLink AS RoleRight_Role -- Связь роли с объектом процессы ролей
                                          ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
                                         AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                          JOIN ObjectLink AS RoleRight_Process -- Связь процесса с объектом процессы ролей
                                          ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId
                                         AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                                         AND RoleRight_Process.ChildObjectId = inProcessId -- !!!Вот ПРОВЕРКА!!!
                     WHERE Object_UserRole_User.DescId        = zc_ObjectLink_UserRole_User()
                       AND Object_UserRole_User.ChildObjectId = vbUserId)
      THEN
         --RAISE EXCEPTION 'Пользователь <%> не имеет прав на %', lfGet_Object_ValueData_sh (vbUserId), lfGet_Object_ValueData_sh (inProcessId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Пользователь <%> не имеет прав на <%>' :: TVarChar
                                               , inProcedureName := 'lpCheckRight                         :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := lfGet_Object_ValueData_sh (vbUserId)    :: TVarChar
                                               , inParam2        := lfGet_Object_ValueData_sh (inProcessId) :: TVarChar
                                               );
      ELSE
         RETURN vbUserId;

      END IF;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckRight (TVarChar, Integer, Date)  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.13                                        * для Админа  - Все Права
 23.09.13                         *
*/

-- тест
-- SELECT * FROM lpCheckRight (zfCalc_UserAdmin())
