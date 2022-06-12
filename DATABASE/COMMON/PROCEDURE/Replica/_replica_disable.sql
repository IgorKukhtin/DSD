/*
DO $$
BEGIN

 LOCK TABLE _replica.table_update_data IN SHARE UPDATE EXCLUSIVE MODE;

insert into _replica.table_update_data22 select * from _replica.table_update_data where Id >= 1883346402;

truncate table _replica.table_update_data;
truncate table _replica.table_ddl;

END $$;
*/

-- project_slave
-- ALTER TABLE objectLink DISABLE TRIGGER all;
-- ALTER TABLE movement DISABLE TRIGGER All;
-- ALTER TABLE movementItem DISABLE TRIGGER All;
-- ALTER TABLE movementlinkobject DISABLE TRIGGER All;
-- ALTER TABLE movementItemlinkobject DISABLE TRIGGER All;
-- ALTER TABLE movementlinkmovement DISABLE TRIGGER All;

-- ALTER TABLE MovementProtocol_arc DISABLE TRIGGER All;
-- ALTER TABLE MovementItemProtocol_arc DISABLE TRIGGER All;

-- select * from _replica.table_update_data order by id desc limit 100
-- select count(*) from _replica.table_update_data 

-- CREATE EVENT TRIGGER etg ON DDL_COMMAND_END
--    EXECUTE PROCEDURE _replica.notice_ddl();

ALTER TABLE objectlinkdesc DISABLE TRIGGER trigger_notify_changes_objectlinkdesc;
ALTER TABLE movementitemlinkobjectdesc DISABLE TRIGGER trigger_notify_changes_movementitemlinkobjectdesc;
ALTER TABLE MovementBlob DISABLE TRIGGER trigger_notify_changes_MovementBlob;

ALTER TABLE periodclose DISABLE TRIGGER trigger_notify_changes_periodclose;


ALTER TABLE LockProtocol DISABLE TRIGGER trigger_notify_changes_LockProtocol;
-- ALTER TABLE LockUnique DISABLE TRIGGER trigger_notify_changes_LockUnique;
ALTER TABLE resourseprotocol DISABLE TRIGGER trigger_notify_changes_resourseprotocol;
ALTER TABLE reportprotocol DISABLE TRIGGER trigger_notify_changes_reportprotocol;


ALTER TABLE containerlinkobject DISABLE TRIGGER trigger_notify_changes_containerlinkobject;
ALTER TABLE container DISABLE TRIGGER trigger_notify_changes_container;

ALTER TABLE movementitemcontainer DISABLE TRIGGER trigger_notify_changes_movementitemcontainer;

ALTER TABLE movement DISABLE TRIGGER trigger_notify_changes_movement;
ALTER TABLE movementFloat DISABLE TRIGGER trigger_notify_changes_movementFloat;
ALTER TABLE movementString DISABLE TRIGGER trigger_notify_changes_movementString;
ALTER TABLE movementDate DISABLE TRIGGER trigger_notify_changes_movementDate;
ALTER TABLE movementBoolean DISABLE TRIGGER trigger_notify_changes_movementBoolean;
ALTER TABLE movementLinkObject DISABLE TRIGGER trigger_notify_changes_movementLinkObject;
ALTER TABLE movementLinkMovement DISABLE TRIGGER trigger_notify_changes_movementLinkMovement;

ALTER TABLE movementItem DISABLE TRIGGER trigger_notify_changes_movementItem;
ALTER TABLE movementItemFloat DISABLE TRIGGER trigger_notify_changes_movementItemFloat;
ALTER TABLE movementItemString DISABLE TRIGGER trigger_notify_changes_movementItemString;
ALTER TABLE movementItemDate DISABLE TRIGGER trigger_notify_changes_movementItemDate;
ALTER TABLE movementItemBoolean DISABLE TRIGGER trigger_notify_changes_movementItemBoolean;
ALTER TABLE movementItemLinkObject DISABLE TRIGGER trigger_notify_changes_movementItemLinkObject;

ALTER TABLE historycost DISABLE TRIGGER trigger_notify_changes_historycost;

ALTER TABLE objectProtocol DISABLE TRIGGER trigger_notify_changes_objectProtocol;
ALTER TABLE MovementProtocol DISABLE TRIGGER trigger_notify_changes_MovementProtocol;
ALTER TABLE MovementItemProtocol DISABLE TRIGGER trigger_notify_changes_MovementItemProtocol;
ALTER TABLE loginprotocol DISABLE TRIGGER trigger_notify_changes_loginprotocol;
ALTER TABLE Userprotocol DISABLE TRIGGER trigger_notify_changes_Userprotocol;
--
-- ALTER TABLE MovementProtocol_arc DISABLE TRIGGER trigger_notify_changes_MovementProtocol_arc;
-- ALTER TABLE MovementItemProtocol_arc DISABLE TRIGGER trigger_notify_changes_MovementItemProtocol_arc;


ALTER TABLE SoldTable DISABLE TRIGGER trigger_notify_changes_SoldTable;

ALTER TABLE objecthistory DISABLE TRIGGER trigger_notify_changes_objecthistory;
ALTER TABLE objecthistoryDate DISABLE TRIGGER trigger_notify_changes_objecthistoryDate;
ALTER TABLE objecthistoryFloat DISABLE TRIGGER trigger_notify_changes_objecthistoryFloat;
ALTER TABLE objecthistoryString DISABLE TRIGGER trigger_notify_changes_objecthistoryString;
ALTER TABLE objecthistoryLink DISABLE TRIGGER trigger_notify_changes_objecthistoryLink;

ALTER TABLE object DISABLE TRIGGER trigger_notify_changes_object;
ALTER TABLE objectBlob DISABLE TRIGGER trigger_notify_changes_objectBlob;
ALTER TABLE objectBoolean DISABLE TRIGGER trigger_notify_changes_objectBoolean;
ALTER TABLE objectDate DISABLE TRIGGER trigger_notify_changes_objectDate;
ALTER TABLE objectFloat DISABLE TRIGGER trigger_notify_changes_objectFloat;
ALTER TABLE objectString DISABLE TRIGGER trigger_notify_changes_objectString;
ALTER TABLE objectLink DISABLE TRIGGER trigger_notify_changes_objectLink;

ALTER TABLE wms_mi_incoming DISABLE TRIGGER trigger_notify_changes_wms_mi_incoming;
ALTER TABLE wms_message DISABLE TRIGGER trigger_notify_changes_wms_message;
ALTER TABLE wms_tohostheader DISABLE TRIGGER trigger_notify_changes_wms_tohostheader;
ALTER TABLE wms_tohostdetail DISABLE TRIGGER trigger_notify_changes_wms_tohostdetail;
ALTER TABLE wms_Movement_weighingproduction DISABLE TRIGGER trigger_notify_changes_wms_Movement_weighingproduction;
ALTER TABLE wms_mi_weighingproduction DISABLE TRIGGER trigger_notify_changes_wms_mi_weighingproduction;
ALTER TABLE wms_object_goodsbygoodskind DISABLE TRIGGER trigger_notify_changes_wms_object_goodsbygoodskind;

