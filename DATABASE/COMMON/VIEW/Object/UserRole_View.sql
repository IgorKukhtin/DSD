-- View: userrole_view

-- DROP VIEW userrole_view;

CREATE OR REPLACE VIEW userrole_view AS 
 SELECT objectlink_userrole_role.childobjectid AS roleid, 
    objectlink_userrole_user.childobjectid AS userid
   FROM objectlink objectlink_userrole_role
   JOIN objectlink objectlink_userrole_user ON objectlink_userrole_user.objectid = objectlink_userrole_role.objectid AND objectlink_userrole_user.descid = zc_objectlink_userrole_user()
  WHERE objectlink_userrole_role.descid = zc_objectlink_userrole_role();

ALTER TABLE userrole_view
  OWNER TO postgres;