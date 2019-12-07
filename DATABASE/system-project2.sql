-- VACUUM pg_toast.pg_toast_1107196 ;
-- select count(*) from pg_toast.pg_toast_1107196
-- VACUUM ANALYZE pg_toast.pg_toast_1107196 ;
/*-- SELECT pg_total_relation_size('pg_toast.pg_toast_1107196') / 1024 / 1024 / 1024
SELECT nspname || '.' || relname AS "relation",
       pg_size_pretty(pg_relation_size(C.oid)) AS "size"
     FROM pg_class C
     LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
     WHERE nspname NOT IN ('pg_catalog', 'information_schema')
     ORDER BY pg_relation_size(C.oid) DESC
     LIMIT 20;
-- select zc_MovementFloat_TotalSumm() -- select zc_MovementDate_OperDatePartner()
*/

-- TRUNCATE TABLE SoldTable;
-- TRUNCATE TABLE MovementItemContainer;
/*
INSERT INTO MovementProtocol_arc
SELECT * FROM MovementProtocol     where Id <= 265248861; -- SELECT max (Id) FROM MovementProtocol 
INSERT INTO MovementItemProtocol_arc
SELECT * FROM MovementItemProtocol where Id <= 328723447; -- SELECT max (Id) FROM MovementItemProtocol 

delete FROM MovementProtocol     where Id <= 265248861;
delete FROM MovementItemProtocol where Id <= 328723447;

INSERT INTO MovementProtocol_arc
SELECT * FROM MovementProtocol ;
 TRUNCATE TABLE MovementProtocol;

INSERT INTO MovementItemProtocol_arc
SELECT * FROM MovementItemProtocol ; -- where OperDate < CURRENT_DATE;
 TRUNCATE TABLE MovementItemProtocol;

*/

VACUUM pg_toast.pg_toast_1107196 ;
VACUUM ANALYZE pg_toast.pg_toast_1107196 ;


-- Protocol...
VACUUM ObjectProtocol;
VACUUM MovementProtocol;
VACUUM MovementProtocol_arc;
VACUUM MovementItemProtocol;
VACUUM MovementItemProtocol_arc;
VACUUM loginprotocol;
VACUUM userprotocol;
VACUUM resourseprotocol;
VACUUM reportprotocol;


VACUUM ANALYZE ObjectProtocol;
VACUUM ANALYZE MovementProtocol;
VACUUM ANALYZE MovementProtocol_arc;
VACUUM ANALYZE MovementItemProtocol;
VACUUM ANALYZE MovementItemProtocol_arc;
VACUUM ANALYZE loginprotocol;
VACUUM ANALYZE userprotocol;
VACUUM ANALYZE resourseprotocol;
VACUUM ANALYZE reportprotocol;

-- MovementItemContainer
VACUUM MovementItemContainer;
VACUUM ANALYZE MovementItemContainer;
-- Container
VACUUM Container  ;
VACUUM ANALYZE Container;
VACUUM ContainerLinkObject;
VACUUM ANALYZE ContainerLinkObject;
-- Other
VACUUM HistoryCost;
VACUUM ANALYZE HistoryCost;
--
VACUUM SoldTable;
VACUUM ANALYZE SoldTable;
--
VACUUM ReplObject;
VACUUM ANALYZE ReplObject;

VACUUM ResourseProtocol;
VACUUM ANALYZE ResourseProtocol;

--
-- VACUUM pg_toast.pg_toast_1107196;
-- VACUUM ANALYZE pg_toast.pg_toast_1107196 ;



-- 1.1. - Movement

VACUUM Movement; -- ++
VACUUM ANALYZE Movement; -- ++

VACUUM movementblob;
VACUUM ANALYZE movementblob;

VACUUM MovementBoolean;
VACUUM ANALYZE MovementBoolean;

VACUUM MovementDate;
VACUUM ANALYZE MovementDate;

VACUUM MovementFloat;
VACUUM ANALYZE MovementFloat;

VACUUM MovementString;
VACUUM ANALYZE MovementString;

VACUUM MovementLinkObject; -- ++
VACUUM ANALYZE MovementLinkObject; -- ++

VACUUM MovementLinkMovement;
VACUUM ANALYZE MovementLinkMovement;


-- 1.2. - MovementItem

VACUUM MovementItem;         -- !!!
VACUUM ANALYZE MovementItem; -- !!!

VACUUM MovementItemBoolean; -- ++
VACUUM ANALYZE MovementItemBoolean; -- ++

VACUUM MovementItemDate; -- ++
VACUUM ANALYZE MovementItemDate; -- ++

VACUUM MovementItemFloat;
VACUUM ANALYZE MovementItemFloat;

VACUUM MovementItemString; -- ++
VACUUM ANALYZE MovementItemString; -- ++

VACUUM MovementItemLinkObject;
VACUUM ANALYZE MovementItemLinkObject;



-- 2. - Object
VACUUM objecthistory;         -- !!!
VACUUM ANALYZE objecthistory; -- !!!

VACUUM objecthistoryDate;         -- !!!
VACUUM ANALYZE objecthistoryDate; -- !!!

VACUUM objecthistoryFloat;         -- !!!
VACUUM ANALYZE objecthistoryFloat; -- !!!

VACUUM objecthistoryString;         -- !!!
VACUUM ANALYZE objecthistoryString; -- !!!

VACUUM objecthistoryLink;         -- !!!
VACUUM ANALYZE objecthistoryLink; -- !!!

VACUUM object;         -- !!!
VACUUM ANALYZE object; -- !!!

VACUUM ObjectBlob;
VACUUM ANALYZE ObjectBlob;

VACUUM objectBoolean;
VACUUM ANALYZE objectBoolean;

VACUUM ObjectDate;
VACUUM ANALYZE ObjectDate;

VACUUM ObjectFloat;
VACUUM ANALYZE ObjectFloat;

VACUUM objectString ;
VACUUM ANALYZE objectString;

VACUUM ObjectLink;
VACUUM ANALYZE ObjectLink;


-- VACUUM FULL

VACUUM full historycost_test;
VACUUM ANALYZE historycost_test;

VACUUM full replobject;
VACUUM ANALYZE replobject;

VACUUM full wms_message;
VACUUM ANALYZE wms_message;

VACUUM full remainsolaptable;
VACUUM ANALYZE remainsolaptable;

VACUUM full resourseprotocol;
VACUUM ANALYZE resourseprotocol;

VACUUM full MovementProtocol_arc;
VACUUM ANALYZE MovementProtocol_arc;
VACUUM full MovementItemProtocol_arc;
VACUUM ANALYZE MovementItemProtocol_arc;


VACUUM full wms_tohostheader;
VACUUM ANALYZE wms_tohostheader;
VACUUM full wms_tohostdetail;
VACUUM ANALYZE wms_tohostdetail;
