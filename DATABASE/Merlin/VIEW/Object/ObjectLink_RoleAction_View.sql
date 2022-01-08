-- View: ObjectLink_RoleAction_View

 DROP VIEW IF EXISTS RoleAction_View;
-- DROP VIEW ObjectLink_RoleAction_View;

CREATE OR REPLACE VIEW ObjectLink_RoleAction_View AS 
 SELECT objectlink_roleaction_role.childobjectid AS roleid, 
    objectlink_roleaction_action.childobjectid AS actionid
   FROM objectlink objectlink_roleaction_role
   JOIN objectlink objectlink_roleaction_action ON objectlink_roleaction_action.objectid = objectlink_roleaction_role.objectid AND objectlink_roleaction_action.descid = zc_objectlink_roleaction_action()
  WHERE objectlink_roleaction_role.descid = zc_objectlink_roleaction_role();

ALTER TABLE ObjectLink_RoleAction_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 07.12.13                                        * rename RoleAction_View -> ObjectLink_RoleAction_View
*/

-- òåñò
-- SELECT * FROM ObjectLink_RoleAction_View
