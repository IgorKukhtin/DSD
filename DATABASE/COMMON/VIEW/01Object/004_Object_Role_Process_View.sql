-- View: Object_Role_Process_View

-- DROP VIEW IF EXISTS Object_Role_Process_View;

CREATE OR REPLACE VIEW Object_Role_Process_View AS

   SELECT ObjectLink_UserRole_Role.ChildObjectId     AS RoleId
        , ObjectLink_UserRole_User.ChildObjectId     AS UserId
        , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
        , Object_Role.ObjectCode AS RoleCode
        , Object_Role.ValueData AS RoleName
        , Object_User.ObjectCode AS UserCode
        , Object_User.ValueData AS UserName
        , Object_Process.ObjectCode AS ProcessCode
        , Object_Process.ValueData AS ProcessName
   FROM ObjectLink AS ObjectLink_UserRole_User -- Связь пользователя с объектом роли пользователя

        INNER JOIN ObjectLink AS ObjectLink_UserRole_Role -- Связь ролей с объектом роли пользователя
                              ON ObjectLink_UserRole_Role.ObjectId = ObjectLink_UserRole_User.ObjectId
                             AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()

        INNER JOIN ObjectLink AS ObjectLink_RoleRight_Role -- Связь роли с объектом процессы ролей
                              ON ObjectLink_RoleRight_Role.ChildObjectId = ObjectLink_UserRole_Role.ChildObjectId
                             AND ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()

        INNER JOIN ObjectLink AS ObjectLink_RoleRight_Process -- Связь процесса с объектом процессы ролей
                              ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId 
                             AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()

        LEFT JOIN Object AS Object_Role    ON Object_Role.Id = ObjectLink_UserRole_Role.ChildObjectId
        LEFT JOIN Object AS Object_User    ON Object_User.Id = ObjectLink_UserRole_User.ChildObjectId
        LEFT JOIN Object AS Object_Process ON Object_Process.Id = ObjectLink_RoleRight_Process.ChildObjectId

   WHERE ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User();

ALTER TABLE Object_Role_Process_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.14                                        *
*/

-- тест
-- SELECT * FROM Object_Role_Process_View
