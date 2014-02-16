-- Function: gpSelect_Object_RoleUser()

--DROP FUNCTION gpSelect_Object_RoleUser(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RoleUser(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, RoleId Integer, UserRoleId Integer) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     ObjectUser.Id         AS Id 
   , ObjectUser.ObjectCode AS Code
   , ObjectUser.ValueData  AS Name
   , ObjectLink_UserRole_Role.ChildObjectId AS RoleId
   , ObjectLink_UserRole_User.ObjectId      AS UserRoleId
   FROM ObjectLink AS ObjectLink_UserRole_Role
   JOIN ObjectLink AS ObjectLink_UserRole_User ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
    AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()

   JOIN Object AS ObjectUser ON ObjectUser.Id = ObjectLink_UserRole_User.ChildObjectId
   WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role();        
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RoleUser(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Role('2')
/*SELECT  
  Role.ItemName AS RoleName,
  Process.ItemName AS ProcessName
FROM 
  Object 
  JOIN ObjectEnum RoleRight_Role 
    ON RoleRight_Role.ObjectId = Object.Id AND RoleRight_Role.DescId = zc_Object_RoleRight_Role()
  JOIN Enum Role 
    ON Role.Id = RoleRight_Role.EnumId
  JOIN ObjectEnum RoleRight_Process
    ON RoleRight_Process.ObjectId = Object.Id AND RoleRight_Process.DescId = zc_Object_RoleRight_Process()
  JOIN Enum Process 
    ON Process.Id = RoleRight_Process.EnumId


WHERE Object.DescId = zc_Object_RoleRight()*/
