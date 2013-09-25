-- View: roleaction_view

-- DROP VIEW roleaction_view;

CREATE OR REPLACE VIEW roleaction_view AS 
 SELECT objectlink_roleaction_role.childobjectid AS roleid, 
    objectlink_roleaction_action.childobjectid AS actionid
   FROM objectlink objectlink_roleaction_role
   JOIN objectlink objectlink_roleaction_action ON objectlink_roleaction_action.objectid = objectlink_roleaction_role.objectid AND objectlink_roleaction_action.descid = zc_objectlink_roleaction_action()
  WHERE objectlink_roleaction_role.descid = zc_objectlink_roleaction_role();

ALTER TABLE roleaction_view
  OWNER TO postgres;