-- Function: gpSelect_Object_RoleUser()

DROP FUNCTION IF EXISTS gpSelect_Object_RoleUser (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RoleUser(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, RoleId Integer, UserRoleId Integer             
             , UnitCode Integer, UnitName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
         Object_User.Id         AS Id 
       , Object_User.ObjectCode AS Code
       , Object_User.ValueData  AS Name
       , ObjectLink_UserRole_Role.ChildObjectId AS RoleId
       , ObjectLink_UserRole_User.ObjectId      AS UserRoleId

       , Object_Unit.ObjectCode    AS UnitCode
       , Object_Unit.ValueData     AS UnitName
     
       , Object_User.isErased       AS isErased

   FROM ObjectLink AS ObjectLink_UserRole_Role
        JOIN ObjectLink AS ObjectLink_UserRole_User 
                        ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                       AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()

        JOIN Object AS Object_User ON Object_User.Id = ObjectLink_UserRole_User.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                             ON ObjectLink_User_Unit.ObjectId = Object_User.Id
                            AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId

   WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role();        
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
 24.03.18         *
 06.05.17                                                          *
 23.09.13                         *

*/

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

-- тест
-- SELECT * FROM gpSelect_Object_RoleUser (zfCalc_UserAdmin())
