-- View: ObjectLink_UserRole_View

 DROP VIEW IF EXISTS UserRole_View;
-- DROP VIEW IF EXISTS ObjectLink_UserRole_View;

CREATE OR REPLACE VIEW ObjectLink_UserRole_View AS 
   SELECT ObjectLink_UserRole_Role.ChildObjectId AS RoleId
        , ObjectLink_UserRole_User.ChildObjectId AS UserId
   FROM ObjectLink AS ObjectLink_UserRole_Role
        JOIN ObjectLink AS ObjectLink_UserRole_User
                        ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                       AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
   WHERE ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
  ;

ALTER TABLE ObjectLink_UserRole_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        *
*/

-- òåñò
-- SELECT * FROM ObjectLink_UserRole_View
