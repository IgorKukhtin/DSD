-- SELECT COUNT(*) FROM MovementProtocol 
-- SELECT COUNT(*) FROM MovementItemProtocol

-- TRUNCATE TABLE MovementProtocol_arc;
-- TRUNCATE TABLE MovementItemProtocol_arc;
/*
INSERT INTO MovementProtocol_arc
SELECT * FROM MovementProtocol where OperDate > CURRENT_DATE;
 -- TRUNCATE TABLE MovementProtocol;

INSERT INTO MovementItemProtocol_arc
SELECT * FROM MovementItemProtocol where OperDate > CURRENT_DATE;
-- TRUNCATE TABLE MovementItemProtocol;
*/

-- Protocol...
VACUUM ANALYZE MovementProtocol;
VACUUM ANALYZE MovementProtocol_arc;
VACUUM ANALYZE MovementItemProtocol;
VACUUM ANALYZE MovementItemProtocol_arc;
VACUUM MovementProtocol;
VACUUM MovementProtocol_arc;
VACUUM MovementItemProtocol;
VACUUM MovementItemProtocol_arc;

-- MovementItemContainer
VACUUM ANALYZE MovementItemContainer;
VACUUM MovementItemContainer;
-- Container
VACUUM ANALYZE Container;
VACUUM Container  ;
VACUUM ANALYZE ContainerLinkObject;
VACUUM ContainerLinkObject;
-- Other
VACUUM ANALYZE HistoryCost;
VACUUM HistoryCost;
--
VACUUM ANALYZE SoldTable;
VACUUM SoldTable;
--
VACUUM ANALYZE ReplObject;
VACUUM ReplObject;
--
-- VACUUM ANALYZE pg_toast.pg_toast_1107196 ;
-- VACUUM pg_toast.pg_toast_1107196;


-- 1.1. - Movement

VACUUM ANALYZE Movement;
VACUUM Movement;

VACUUM ANALYZE MovementBoolean;
VACUUM MovementBoolean;

VACUUM ANALYZE MovementDate;
VACUUM MovementDate;

VACUUM ANALYZE MovementFloat;
VACUUM MovementFloat;

VACUUM ANALYZE MovementString;
VACUUM MovementString;

VACUUM ANALYZE MovementLinkObject;
VACUUM MovementLinkObject;


-- 1.2. - MovementItem

VACUUM ANALYZE MovementItem; -- !!!
VACUUM MovementItem;         -- !!!

VACUUM ANALYZE MovementItemBoolean;
VACUUM MovementItemBoolean;

VACUUM ANALYZE MovementItemDate;
VACUUM MovementItemDate;

VACUUM ANALYZE MovementItemFloat;
VACUUM MovementItemFloat;

VACUUM ANALYZE MovementItemString;
VACUUM MovementItemString;

VACUUM ANALYZE MovementItemLinkObject;
VACUUM MovementItemLinkObject;



-- 2. - Object

VACUUM ANALYZE object; -- !!!
VACUUM object;         -- !!!

VACUUM ANALYZE objectBoolean;
VACUUM objectBoolean;

VACUUM ANALYZE ObjectDate;
VACUUM ObjectDate;

VACUUM ANALYZE ObjectFloat;
VACUUM ObjectFloat;

VACUUM ANALYZE objectString;
VACUUM objectString ;

VACUUM ANALYZE ObjectLink;
VACUUM ObjectLink;
