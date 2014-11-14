-- View: Object_Goods_View

-- DROP VIEW IF EXISTS Object_Process_User_View;

CREATE OR REPLACE VIEW Object_Process_User_View AS

         SELECT Object_UserRole_Role.ChildObjectId AS RoleId
              , RoleRight_Process.ChildObjectId    AS ProcessId
              , Object_UserRole_User.ChildObjectId AS UserId
         FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
              INNER JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                    ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                   AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
              INNER JOIN ObjectLink AS RoleRight_Role -- Связь роли с объектом процессы ролей
                                    ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
                                   AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
              INNER JOIN ObjectLink AS RoleRight_Process -- Связь процесса с объектом процессы ролей
                                    ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId 
                                   AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
         WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User();


ALTER TABLE Object_Process_User_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.13                                        *
*/

-- тест
-- SELECT Object_Role.*, Object_User.*, Object_Process.* FROM Object_Process_User_View LEFT JOIN Object AS Object_Role ON Object_Role.Id = RoleId LEFT JOIN Object AS Object_Process ON Object_Process.Id = ProcessId LEFT JOIN Object AS Object_User ON Object_User.Id = UserId ORDER BY 3, 9, 15
