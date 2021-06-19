-- alter table movement DROP CONSTRAINT  fk_movement_parentid;
-- alter table container DROP CONSTRAINT  fk_container_parentid_container;
-- alter table movementitem DROP CONSTRAINT  fk_movementitem_movementid;
-- alter table movementlinkmovement DROP CONSTRAINT  fk_movementlinkmovement_movementchild;

-- alter table movementlinkobject DROP CONSTRAINT  fk_movementlinkobject_object;
-- alter table movementitemlinkobject DROP CONSTRAINT  fk_movementitemlinkobject_object;


alter table movement DROP CONSTRAINT  fk_movement_parentid;
alter table containerlinkobject DROP CONSTRAINT  fk_containerlinkobject_container;
alter table historycost DROP CONSTRAINT  fk_historycost_containerid;
alter table movementitemcontainer DROP CONSTRAINT  fk_movementitemcontainer_containerid;
alter table container DROP CONSTRAINT  fk_container_descid_containerdesc;
alter table container DROP CONSTRAINT  fk_container_parentid_container;
alter table containerlinkobject DROP CONSTRAINT  fk_containerlinkobject_desc;
alter table defaultvalue DROP CONSTRAINT  fk_defaultvalue_defaultkeyid;
alter table movementblob DROP CONSTRAINT  fk_movementblob_movementid;
alter table movementdate DROP CONSTRAINT  fk_movementdate_movementid;
alter table movementfloat DROP CONSTRAINT  fk_movementfloat_movementid;
alter table movementitem DROP CONSTRAINT  fk_movementitem_movementid;
alter table movementitemcontainer DROP CONSTRAINT  fk_movementitemcontainer_movementid;
alter table movementlinkmovement DROP CONSTRAINT  fk_movementlinkmovement_movement;
alter table movementlinkmovement DROP CONSTRAINT  fk_movementlinkmovement_movementchild;
alter table movementlinkobject DROP CONSTRAINT  fk_movementlinkobject_movement;
alter table movementprotocol_arc DROP CONSTRAINT  fk_movementprotocol_arc_movementid;
alter table movementprotocol DROP CONSTRAINT  fk_movementprotocol_movementid;

alter table movementboolean DROP CONSTRAINT  pk_movementboolean_movementid;
alter table movementstring DROP CONSTRAINT  pk_movementstring_movementid;

alter table movementblob DROP CONSTRAINT  fk_movementblob_descid;

alter table movementboolean DROP CONSTRAINT  pk_movementboolean_descid;

alter table movementdate DROP CONSTRAINT  fk_movementdate_descid;
alter table movement DROP CONSTRAINT  fk_movement_movementdesc;

alter table movementitemcontainer DROP CONSTRAINT  movementitemcontainer_movementdescid_fkey;

alter table movementfloat DROP CONSTRAINT  fk_movementfloat_descid;
alter table movementitem DROP CONSTRAINT  fk_movementitem_parentid;
alter table movementitemcontainer DROP CONSTRAINT  fk_movementitemcontainer_movementitemid;
alter table movementitemdate DROP CONSTRAINT  fk_movementitemdate_movementitemid;
alter table movementitemfloat DROP CONSTRAINT  fk_movementitemfloat_movementitemid;
alter table movementitemlinkobject DROP CONSTRAINT  fk_movementitemlinkobject_movementitem;
alter table movementitemprotocol_arc DROP CONSTRAINT  fk_movementitemprotocol_arc_movementitemid;
alter table movementitemprotocol DROP CONSTRAINT  fk_movementitemprotocol_movementitemid;

alter table movementitemboolean DROP CONSTRAINT  pk_movementitemboolean_movementitemid;
alter table movementitemstring DROP CONSTRAINT  pk_movementitemstring_movementitemid;
alter table movementitemboolean DROP CONSTRAINT  pk_movementitemboolean_descid;

alter table movementitemcontainer DROP CONSTRAINT  fk_movementitemcontainer_parentid;
alter table movementitemcontainer DROP CONSTRAINT  fk_movementitemcontainer_descid;
alter table movementitemdate DROP CONSTRAINT  fk_movementitemdate_descid;
alter table movementitem DROP CONSTRAINT  fk_movementitem_descid;
alter table movementitemfloat DROP CONSTRAINT  fk_movementitemfloat_descid;
alter table movementitemlinkobject DROP CONSTRAINT  fk_movementitemlinkobject_descid;

alter table movementitemstring DROP CONSTRAINT  pk_movementitemstring_descid;

alter table movementlinkmovement DROP CONSTRAINT  fk_movementlinkmovement_descid;
alter table movementlinkobject DROP CONSTRAINT  fk_movementlinkobject_descid;

alter table movementstring DROP CONSTRAINT  pk_movementstring_descid;

alter table container DROP CONSTRAINT  fk_container_objectid_object;
alter table defaultvalue DROP CONSTRAINT  fk_defaultvalue_userkeyid;
alter table loginprotocol DROP CONSTRAINT  fk_loginprotocol_userid;
alter table movement DROP CONSTRAINT  fk_movement_statusid;
alter table movementitem DROP CONSTRAINT  fk_movementitem_objectid;
alter table movementitemlinkobject DROP CONSTRAINT  fk_movementitemlinkobject_object;
alter table movementitemprotocol_arc DROP CONSTRAINT  fk_movementitemprotocol_arc_userid;
alter table movementitemprotocol DROP CONSTRAINT  fk_movementitemprotocol_userid;
alter table movementlinkobject DROP CONSTRAINT  fk_movementlinkobject_object;
alter table movementprotocol_arc DROP CONSTRAINT  fk_movementprotocol_arc_userid;
alter table movementprotocol DROP CONSTRAINT  fk_movementprotocol_userid;
alter table objectblob DROP CONSTRAINT  fk_objectblob_objectid;
alter table objectdate DROP CONSTRAINT  fk_objectdate_objectid;
alter table objectfloat DROP CONSTRAINT  fk_objectfloat_objectid;
alter table objecthistory DROP CONSTRAINT  fk_objecthistory_objectid;
alter table objecthistorylink DROP CONSTRAINT  fk_objecthistorylink_objectid;
alter table objectlink DROP CONSTRAINT  fk_objectlink_childobjectid;
alter table objectlink DROP CONSTRAINT  fk_objectlink_objectid;
alter table objectprotocol DROP CONSTRAINT  fk_objectprotocol_objectid;
alter table objectprotocol DROP CONSTRAINT  fk_objectprotocol_userid;
alter table periodclose DROP CONSTRAINT  fk_periodclose_roleid;
alter table periodclose DROP CONSTRAINT  fk_periodclose_unitid;
alter table periodclose DROP CONSTRAINT  fk_periodclose_userid;
alter table reportprotocol DROP CONSTRAINT  fk_reportprotocol_userid;
alter table userprotocol DROP CONSTRAINT  fk_userprotocol_userid;

alter table movementdesc DROP CONSTRAINT  movementdesc_formid_fkey;
alter table objectboolean DROP CONSTRAINT  pk_objectboolean_objectid;
alter table objectstring DROP CONSTRAINT  pk_objectstring_objectid;

alter table objectblob DROP CONSTRAINT  fk_objectblob_descid;

alter table objectboolean DROP CONSTRAINT  pk_objectboolean_descid;

alter table objectdate DROP CONSTRAINT  fk_objectdate_descid;
alter table containerlinkobjectdesc DROP CONSTRAINT  fk_containerlinkobjectdesc_objectdescid;
alter table object DROP CONSTRAINT  fk_object_descid;
alter table objectblobdesc DROP CONSTRAINT  fk_objectblobdesc_descid;
alter table objectbooleandesc DROP CONSTRAINT  fk_objectbooleandesc_descid;
alter table objectdatedesc DROP CONSTRAINT  fk_objectdatedesc_descid;
alter table objectfloatdesc DROP CONSTRAINT  fk_objectfloatdesc_descid;
alter table objecthistorylinkdesc DROP CONSTRAINT  fk_objecthistorylinkdesc_objectdescid;
alter table objectlinkdesc DROP CONSTRAINT  fk_objectlinkdesc_childobjectdescid;
alter table objectlinkdesc DROP CONSTRAINT  fk_objectlinkdesc_descid;
alter table objectstringdesc DROP CONSTRAINT  fk_objectstringdesc_descid;
alter table objectfloat DROP CONSTRAINT  fk_objectfloat_descid;
alter table objecthistorydate DROP CONSTRAINT  fk_objecthistorydate_objecthistoryid;
alter table objecthistoryfloat DROP CONSTRAINT  fk_objecthistoryfloat_objecthistoryid;
alter table objecthistorylink DROP CONSTRAINT  fk_objecthistorylink_objecthistoryid;
alter table objecthistorystring DROP CONSTRAINT  fk_objecthistorystring_objecthistoryid;
alter table objecthistorydate DROP CONSTRAINT  fk_objecthistorydate_descid;
alter table objecthistory DROP CONSTRAINT  fk_objecthistory_descid;
alter table objecthistorydatedesc DROP CONSTRAINT  fk_objecthistorydatedesc_descid;
alter table objecthistoryfloatdesc DROP CONSTRAINT  fk_objecthistoryfloatdesc_descid;
alter table objecthistorylinkdesc DROP CONSTRAINT  fk_objecthistorylinkdesc_descid;
alter table objecthistorystringdesc DROP CONSTRAINT  fk_objecthistorystringdesc_descid;
alter table objecthistoryfloat DROP CONSTRAINT  fk_objecthistoryfloat_descid;
alter table objecthistorylink DROP CONSTRAINT  fk_objecthistorylink_descid;
alter table objecthistorystring DROP CONSTRAINT  fk_objecthistorystring_descid;
alter table objectlink DROP CONSTRAINT  fk_objectlink_descid;

alter table objectstring DROP CONSTRAINT  pk_objectstring_descid;
