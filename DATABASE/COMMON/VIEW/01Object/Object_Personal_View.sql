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
