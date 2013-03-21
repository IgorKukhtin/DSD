CREATE OR REPLACE FUNCTION lpCheckRight(
IN inSession TVarChar, 
IN inProcessId integer, 
IN inOperDate date DEFAULT current_date)
RETURNS void AS
$BODY$  
DECLARE 
  UserName TVarChar;
  ProcessName TVarChar;
BEGIN

  IF NOT EXISTS (SELECT 1
	  FROM ObjectLink Object_UserRole_User -- Связь пользователя с объектом роли пользователя
	  JOIN ObjectLink Object_UserRole_Role -- Связь ролей с объектом роли пользователя
	    ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
	   AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
	  JOIN ObjectLink RoleRight_Role -- Связь роли с объектом процессы ролей
	    ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
	   AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
	  JOIN ObjectLink RoleRight_Process -- Связь процесса с объектом процессы ролей
	    ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId 
	   AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
	 WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
	   AND Object_UserRole_User.ChildObjectId = to_number(inSession, '00000000000')
	   AND RoleRight_Process.ChildObjectId = inProcessId) 
  THEN
     SELECT ValueData INTO UserName FROM Object WHERE Id = to_number(inSession, '00000000000');
     SELECT ValueData INTO ProcessName FROM Object WHERE Id = inProcessId;
     RAISE EXCEPTION 'Пользователь "%" не имеет прав на операцию "%" ' ,UserName, ProcessName;
  END IF;
    
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpCheckRight(TVarChar, integer, date)
  OWNER TO postgres;
