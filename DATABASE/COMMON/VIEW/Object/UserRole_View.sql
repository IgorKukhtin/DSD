-- View: UserRole_View

-- DROP VIEW IF EXISTS UserRole_View;

CREATE OR REPLACE VIEW UserRole_View AS 
   SELECT ObjectLink_UserRole_Role.ChildObjectId AS RoleId
        , ObjectLink_UserRole_User.ChildObjectId AS UserId
   FROM ObjectLink AS ObjectLink_UserRole_Role
        JOIN ObjectLink AS ObjectLink_UserRole_User
                        ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                       AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
   WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
  ;

ALTER TABLE UserRole_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.13                                        *
*/

-- тест
-- SELECT * FROM UserRole_View
