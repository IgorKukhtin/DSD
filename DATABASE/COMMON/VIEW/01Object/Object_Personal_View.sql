-- View: Object_Personal_View

-- DROP VIEW Object_Personal_View;

CREATE OR REPLACE VIEW Object_Personal_View
AS 
 SELECT object_personal.id AS personalid,
    object_personal.descid,
    objectlink_personal_member.childobjectid AS memberid,
    object_personal.objectcode AS personalcode,
    object_personal.valuedata AS personalname,
    object_personal.accesskeyid,
    object_personal.iserased,
    COALESCE(objectlink_personal_position.childobjectid, 0) AS positionid,
    object_position.objectcode AS positioncode,
    object_position.valuedata AS positionname,
    COALESCE(objectlink_personal_positionlevel.childobjectid, 0) AS positionlevelid,
    object_positionlevel.objectcode AS positionlevelcode,
    object_positionlevel.valuedata AS positionlevelname,
    object_branch.id AS branchid,
    object_branch.objectcode AS branchcode,
    object_branch.valuedata AS branchname,
    COALESCE(objectlink_personal_unit.childobjectid, 0) AS unitid,
    object_unit.objectcode AS unitcode,
    object_unit.valuedata AS unitname,
    objectlink_personal_personalgroup.childobjectid AS personalgroupid,
    object_personalgroup.objectcode AS personalgroupcode,
    object_personalgroup.valuedata AS personalgroupname,
    objectdate_datein.valuedata AS datein,
    objectdate_dateout.valuedata AS dateout,
        CASE
            WHEN COALESCE(objectdate_dateout.valuedata, zc_dateend())::timestamp with time zone = zc_dateend()::timestamp with time zone OR object_personal.iserased = true THEN NULL::timestamp with time zone
            ELSE objectdate_dateout.valuedata::timestamp with time zone
        END::tdatetime AS dateout_user,
        CASE
            WHEN COALESCE(objectdate_dateout.valuedata, zc_dateend())::timestamp with time zone = zc_dateend()::timestamp with time zone THEN false
            ELSE true
        END AS isdateout,
    COALESCE(objectboolean_main.valuedata, false) AS ismain,
    COALESCE(objectboolean_official.valuedata, false) AS isofficial,
    COALESCE(object_storageline.id, 0) AS storagelineid,
    object_storageline.objectcode AS storagelinecode,
    object_storageline.valuedata AS storagelinename,
    object_member_refer.id AS member_referid,
    object_member_refer.objectcode AS member_refercode,
    object_member_refer.valuedata AS member_refername,
    object_member_mentor.id AS member_mentorid,
    object_member_mentor.objectcode AS member_mentorcode,
    object_member_mentor.valuedata AS member_mentorname,
    object_reasonout.id AS reasonoutid,
    object_reasonout.objectcode AS reasonoutcode,
    object_reasonout.valuedata AS reasonoutname,
    objectstring_comment.valuedata AS comment,
    objectdate_send.valuedata AS datesend,
        CASE
            WHEN COALESCE(objectdate_send.valuedata, zc_dateend())::timestamp with time zone = zc_dateend()::timestamp with time zone THEN false
            ELSE true
        END AS isdatesend
   FROM object object_personal
     LEFT JOIN objectlink objectlink_personal_member ON objectlink_personal_member.objectid = object_personal.id AND objectlink_personal_member.descid = zc_objectlink_personal_member()
     LEFT JOIN object object_member ON object_member.id = objectlink_personal_member.childobjectid
     LEFT JOIN objectlink objectlink_personal_position ON objectlink_personal_position.objectid = object_personal.id AND objectlink_personal_position.descid = zc_objectlink_personal_position()
     LEFT JOIN object object_position ON object_position.id = objectlink_personal_position.childobjectid
     LEFT JOIN objectlink objectlink_personal_positionlevel ON objectlink_personal_positionlevel.objectid = object_personal.id AND objectlink_personal_positionlevel.descid = zc_objectlink_personal_positionlevel()
     LEFT JOIN object object_positionlevel ON object_positionlevel.id = objectlink_personal_positionlevel.childobjectid
     LEFT JOIN objectlink objectlink_personal_unit ON objectlink_personal_unit.objectid = object_personal.id AND objectlink_personal_unit.descid = zc_objectlink_personal_unit()
     LEFT JOIN object object_unit ON object_unit.id = objectlink_personal_unit.childobjectid
     LEFT JOIN objectlink objectlink_unit_branch ON objectlink_unit_branch.objectid = object_unit.id AND objectlink_unit_branch.descid = zc_objectlink_unit_branch()
     LEFT JOIN object object_branch ON object_branch.id = objectlink_unit_branch.childobjectid
     LEFT JOIN objectlink objectlink_personal_personalgroup ON objectlink_personal_personalgroup.objectid = object_personal.id AND objectlink_personal_personalgroup.descid = zc_objectlink_personal_personalgroup()
     LEFT JOIN object object_personalgroup ON object_personalgroup.id = objectlink_personal_personalgroup.childobjectid
     LEFT JOIN objectlink objectlink_personal_storageline ON objectlink_personal_storageline.objectid = object_personal.id AND objectlink_personal_storageline.descid = zc_objectlink_personal_storageline()
     LEFT JOIN object object_storageline ON object_storageline.id = objectlink_personal_storageline.childobjectid
     LEFT JOIN objectlink objectlink_personal_member_refer ON objectlink_personal_member_refer.objectid = object_personal.id AND objectlink_personal_member_refer.descid = zc_objectlink_personal_member_refer()
     LEFT JOIN object object_member_refer ON object_member_refer.id = objectlink_personal_member_refer.childobjectid
     LEFT JOIN objectlink objectlink_personal_member_mentor ON objectlink_personal_member_mentor.objectid = object_personal.id AND objectlink_personal_member_mentor.descid = zc_objectlink_personal_member_mentor()
     LEFT JOIN object object_member_mentor ON object_member_mentor.id = objectlink_personal_member_mentor.childobjectid
     LEFT JOIN objectlink objectlink_personal_reasonout ON objectlink_personal_reasonout.objectid = object_personal.id AND objectlink_personal_reasonout.descid = zc_objectlink_personal_reasonout()
     LEFT JOIN object object_reasonout ON object_reasonout.id = objectlink_personal_reasonout.childobjectid
     LEFT JOIN objectdate objectdate_datein ON objectdate_datein.objectid = object_personal.id AND objectdate_datein.descid = zc_objectdate_personal_in()
     LEFT JOIN objectdate objectdate_dateout ON objectdate_dateout.objectid = object_personal.id AND objectdate_dateout.descid = zc_objectdate_personal_out()
     LEFT JOIN objectdate objectdate_send ON objectdate_send.objectid = object_personal.id AND objectdate_send.descid = zc_objectdate_personal_send()
     LEFT JOIN objectboolean objectboolean_main ON objectboolean_main.objectid = object_personal.id AND objectboolean_main.descid = zc_objectboolean_personal_main()
     LEFT JOIN objectboolean objectboolean_official ON objectboolean_official.objectid = objectlink_personal_member.childobjectid AND objectboolean_official.descid = zc_objectboolean_member_official()
     LEFT JOIN objectstring objectstring_comment ON objectstring_comment.objectid = object_personal.id AND objectstring_comment.descid = zc_objectstring_personal_comment()
  WHERE object_personal.descid = zc_object_personal()
;

ALTER TABLE Object_Personal_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 21.12.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Personal_View
