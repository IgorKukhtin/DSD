-- View: Object_RoleAccessKey_View

-- DROP VIEW IF EXISTS Object_RoleAccess_View;

CREATE OR REPLACE VIEW Object_RoleAccessKey_View AS

   SELECT ObjectLink_RoleProcessAccess_Process.ChildObjectId AS AccessKeyId
        , ObjectLink_RoleProcessAccess_Role.ChildObjectId    AS RoleId
        , 0 AS ProcessId
        , ObjectLink_UserRole_View.UserId
        , Object_Role.ObjectCode AS RoleCode
        , Object_Role.ValueData AS RoleName
   FROM ObjectLink AS ObjectLink_RoleProcessAccess_Process
        JOIN ObjectLink AS ObjectLink_RoleProcessAccess_Role
                        ON ObjectLink_RoleProcessAccess_Role.ObjectId = ObjectLink_RoleProcessAccess_Process.ObjectId
                       AND ObjectLink_RoleProcessAccess_Role.DescId   = zc_ObjectLink_RoleProcessAccess_Role()
        LEFT JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.RoleId = ObjectLink_RoleProcessAccess_Role.ChildObjectId
        LEFT JOIN Object AS Object_Role ON Object_Role.Id = ObjectLink_RoleProcessAccess_Role.ChildObjectId
   WHERE ObjectLink_RoleProcessAccess_Process.DescId = zc_ObjectLink_RoleProcessAccess_Process();
   ;

ALTER TABLE Object_RoleAccessKey_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.18                                        *
*/

-- тест
-- SELECT * FROM Object_RoleAccessKey_View
