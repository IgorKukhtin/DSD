-- TRUNCATE TABLE SoldTable;
-- TRUNCATE TABLE MovementItemContainer;

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
VACUUM MovementProtocol;
VACUUM MovementProtocol_arc;
VACUUM MovementItemProtocol;
VACUUM MovementItemProtocol_arc;
VACUUM ANALYZE MovementProtocol;
VACUUM ANALYZE MovementProtocol_arc;
VACUUM ANALYZE MovementItemProtocol;
VACUUM ANALYZE MovementItemProtocol_arc;

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

VACUUM Movement;
VACUUM ANALYZE Movement;

VACUUM MovementBoolean;
VACUUM ANALYZE MovementBoolean;

VACUUM MovementDate;
VACUUM ANALYZE MovementDate;

VACUUM MovementFloat;
VACUUM ANALYZE MovementFloat;

VACUUM MovementString;
VACUUM ANALYZE MovementString;

VACUUM MovementLinkObject;
VACUUM ANALYZE MovementLinkObject;


-- 1.2. - MovementItem

VACUUM MovementItem;         -- !!!
VACUUM ANALYZE MovementItem; -- !!!

VACUUM MovementItemBoolean;
VACUUM ANALYZE MovementItemBoolean;

VACUUM MovementItemDate;
VACUUM ANALYZE MovementItemDate;

VACUUM MovementItemFloat;
VACUUM ANALYZE MovementItemFloat;

VACUUM MovementItemString;
VACUUM ANALYZE MovementItemString;

VACUUM MovementItemLinkObject;
VACUUM ANALYZE MovementItemLinkObject;



-- 2. - Object

VACUUM object;         -- !!!
VACUUM ANALYZE object; -- !!!

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
