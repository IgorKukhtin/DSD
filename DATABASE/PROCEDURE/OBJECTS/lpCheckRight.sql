CREATE OR REPLACE FUNCTION lpCheckRight(
IN inSession TVarChar, 
IN inProcessId integer, 
IN inOperDate date DEFAULT current_date)
RETURNS void AS
$BODY$  
DECLARE 
  Res TVarChar;
  UserName TVarChar;
  ProcessName TVarChar;
BEGIN

  IF NOT EXISTS (SELECT 1
	  FROM ObjectLink Object_UserRole_User -- Связь пользователя с объектом роли пользователя
	  JOIN ObjectEnum Object_UserRole_Role -- Связь ролей с объектом роли пользователя
	    ON Object_UserRole_Role.DescId = zc_Object_UserRole_Role()
	   AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ParentObjectId
	  JOIN ObjectEnum RoleRight_Role -- Связь роли с объектом процессы ролей
	    ON RoleRight_Role.EnumId = Object_UserRole_Role.EnumId 
	   AND RoleRight_Role.DescId = zc_Object_RoleRight_Role()
	  JOIN ObjectEnum RoleRight_Process -- Связь процесса с объектом процессы ролей
	    ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId 
	   AND RoleRight_Process.DescId = zc_Object_RoleRight_Process()
	 WHERE Object_UserRole_User.DescId = zc_Object_UserRole_User()
	   AND Object_UserRole_User.ChildObjectId = to_number(inSession, '0')
	   AND RoleRight_Process.EnumId = inProcessId) THEN
   SELECT ValueData INTO UserName FROM Object WHERE Id = to_number(inSession, '0');
     SELECT ItemName INTO ProcessName FROM Enum WHERE Id = inProcessId;
     RAISE EXCEPTION 'Пользователь "%" не имеет прав на операцию "%" ' ,UserName, ProcessName;
  END IF;
    
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpCheckRight(TVarChar, integer, date)
  OWNER TO postgres;
