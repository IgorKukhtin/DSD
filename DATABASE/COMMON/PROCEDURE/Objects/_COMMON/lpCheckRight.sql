-- Function: lpCheckRight()

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
                                      ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                                     AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
             WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
               AND Object_UserRole_User.ChildObjectId = vbUserId)
     -- Расчет с/с
     OR vbUserId = zc_Enum_Process_Auto_PrimeCost()
     -- 
     OR zfCalc_User_isIrna (vbUserId) = TRUE
  THEN
      RETURN vbUserId;

  ELSE
      IF NOT EXISTS (SELECT 1
                     FROM -- Связь пользователя с объектом роли пользователя
                          ObjectLink AS Object_UserRole_User
                          -- Связь ролей с объектом роли пользователя
                          JOIN ObjectLink AS Object_UserRole_Role 
                                          ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                         AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                          -- Связь роли с объектом процессы ролей
                          JOIN ObjectLink AS RoleRight_Role 
                                          ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
                                         AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                          -- Связь процесса с объектом процессы ролей
                          JOIN ObjectLink AS RoleRight_Process 
                                          ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId
                                         AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                                         -- !!!Вот ПРОВЕРКА!!!
                                         AND RoleRight_Process.ChildObjectId = inProcessId
                     WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                       AND Object_UserRole_User.ChildObjectId = vbUserId)
      THEN
         RAISE EXCEPTION 'Пользователь <%> не имеет прав на %', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (inProcessId);
      ELSE
         RETURN vbUserId;
      END IF;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.13                                        * для Админа  - Все Права
 23.09.13                         *
*/

-- тест
-- SELECT * FROM lpCheckRight('2')
