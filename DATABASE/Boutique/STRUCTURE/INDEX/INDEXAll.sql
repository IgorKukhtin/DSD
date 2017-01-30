DROP INDEX IF EXISTS idx_Container_ObjectId_DescId_Id;
DROP INDEX IF EXISTS idx_Container_ParentId_ObjectId_DescId_Id; 
DROP INDEX IF EXISTS idx_Container_Id_ObjectId_DescId;
DROP INDEX IF EXISTS idx_Container_DescId;
DROP INDEX IF EXISTS idx_Container_ObjectId_DescId;
DROP INDEX IF EXISTS idx_Container_ParentId;

CREATE INDEX idx_Container_ObjectId_DescId ON Container (ObjectId, DescId);
CREATE INDEX idx_Container_DescId ON Container (DescId);
CREATE INDEX idx_Container_ParentId ON Container (ParentId); 
------------

DROP INDEX IF EXISTS idx_Movement_OperDate_DescId;
DROP INDEX IF EXISTS idx_Movement_ParentId; 
DROP INDEX IF EXISTS idx_Movement_StatusId; -- ÍÓÌÒÚÂÈÌÚ
DROP INDEX IF EXISTS idx_Movement_DescId_InvNumber;

CREATE INDEX idx_Movement_OperDate_DescId ON Movement(OperDate, DescId);
CREATE INDEX idx_Movement_ParentId ON Movement(ParentId); 
CREATE INDEX idx_Movement_StatusId ON Movement(StatusId); -- ÍÓÌÒÚÂÈÌÚ
CREATE INDEX idx_Movement_DescId_InvNumber ON Movement(DescId, zfConvert_StringToNumber(InvNumber));
------------

CREATE INDEX idx_MovementLinkMovement_All ON MovementLinkMovement(MovementId, DescId, MovementChildId); 
CREATE INDEX idx_MovementLinkMovement_MovementChildId ON MovementLinkMovement(MovementChildId); 

CREATE INDEX idx_MovementString_MovementId_DescId ON MovementString (MovementId, DescId);
CREATE INDEX idx_MovementBLOB_MovementId_DescId ON MovementBLOB (MovementId, DescId); 
CREATE INDEX idx_MovementFloat_MovementId_DescId ON MovementFloat (MovementId, DescId); 

CREATE UNIQUE INDEX idx_MovementLinkMovement_MovementId_DescId ON MovementLinkMovement (MovementId, DescId);
CREATE INDEX idx_MovementLinkMovement_MovementChildId_DescId ON MovementLinkMovement (MovementChildId, DescId);
CREATE INDEX idx_MovementLinkMovement_DescId ON MovementLinkMovement (DescId,MovementId);

CREATE UNIQUE INDEX idx_MovementLinkObject_MovementId_DescId ON MovementLinkObject (MovementId, DescId);
CREATE INDEX idx_MovementLinkObject_ObjectId_DescId ON MovementLinkObject(ObjectId, DescId); -- –¥–ª—è –∫–æ–Ω—Å—Ç—Ä–µ–π–Ω—Ç–∞

CREATE UNIQUE INDEX idx_MovementBoolean_MovementId_DescId ON MovementBoolean (MovementId, DescId); 
CREATE INDEX idx_MovementBoolean_ValueData_DescId ON MovementBoolean (ValueData, DescId); 

CREATE UNIQUE INDEX idx_MovementDate_MovementId_DescId ON MovementDate (MovementId, DescId); 
CREATE INDEX idx_MovementDate_ValueData_DescId ON MovementDate (ValueData, DescId); 

------------

CREATE INDEX idx_MovementLinkObject_ObjectId ON MovementLinkObject(ObjectId); -- –¥–ª—è –∫–æ–Ω—Å—Ç—Ä–µ–π–Ω—Ç–∞
------------

DROP INDEX IF EXISTS idx_Object_DescId;
DROP INDEX IF EXISTS idx_Object_DescId_ValueData;
DROP INDEX IF EXISTS idx_Object_DescId_ObjectCode;

CREATE INDEX idx_Object_DescId ON Object(DescId);
CREATE INDEX idx_Object_DescId_ValueData ON Object(DescId, ValueData);
CREATE INDEX idx_Object_DescId_ObjectCode ON Object(DescId, ObjectCode);

CLUSTER object_pkey ON Object; 
------------



CREATE UNIQUE INDEX idx_MovementItemDate_MovementItemId_DescId_ValueData ON MovementItemDate(MovementItemId, DescId, ValueData); 
CREATE INDEX idx_MovementItemDate_ValueData_DescId ON MovementItemDate(ValueData, DescId); 

CREATE UNIQUE INDEX idx_MovementItemBoolean_MovementItemId_DescId_ValueData ON MovementItemBoolean (MovementItemId, DescId, ValueData);
CREATE INDEX idx_MovementItemBoolean_ValueData_DescId ON MovementItemBoolean (ValueData, DescId);

CREATE INDEX idx_MovementItemLinkObject_ObjectId ON MovementItemLinkObject(ObjectId); -- –¥–ª—è –∫–æ–Ω—Å—Ç—Ä–µ–π–Ω—Ç–∞

CREATE UNIQUE INDEX idx_MovementItemLinkObject_MovementItemId_DescId ON MovementItemLinkObject (MovementItemId, DescId);

CREATE UNIQUE INDEX idx_MovementItemString_MovementItemId_DescId ON MovementItemString (MovementItemId, DescId);

CREATE INDEX idx_MovementItem_ParentId ON MovementItem (ParentId);
CREATE INDEX idx_MovementItem_MovementId ON MovementItem (MovementId);
CREATE INDEX idx_MovementItem_ObjectId ON MovementItem (ObjectId); -- ÍÓÌÒÚÂÈÌÚ
CLUSTER idx_MovementItem_MovementId ON MovementItem;

CREATE UNIQUE INDEX idx_MovementItemFloat_MovementItemId_DescId ON MovementItemFloat(MovementItemId, DescId); 
CREATE INDEX idx_MovementItemFloat_ValueData_DescId ON MovementItemFloat (ValueData, DescId); 


------------

CREATE INDEX idx_MovementItemContainer_MovementId_DescId ON MovementItemContainer (MovementId, DescId);
CREATE INDEX idx_MovementItemContainer_ContainerId_Analyzer_OperDate ON MovementItemContainer (ContainerId_Analyzer, OperDate);
CREATE INDEX idx_MovementItemContainer_AnalyzerId_OperDate ON MovementItemContainer (AnalyzerId, OperDate);
CREATE INDEX idx_MovementItemContainer_ContainerId_OperDate ON MovementItemContainer (ContainerId, OperDate);
CREATE INDEX idx_MovementItemContainer_OperDate_DescId_MovementDescId_WhereObjectId_Analyzer ON MovementItemContainer (OperDate,DescId,MovementDescId,WhereObjectId_Analyzer);
-- !!! CREATE INDEX idx_MovementItemContainer_ContainerId_OperDate_DescId ON MovementItemContainer (ContainerId, OperDate, DescId);
-- !!! CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate ON MovementItemContainer (ContainerId, DescId, OperDate);
CREATE INDEX idx_MovementItemContainer_MovementItemId ON MovementItemContainer (MovementItemId);
CREATE INDEX idx_MovementItemContainer_ParentId ON MovementItemContainer (ParentId);
-- CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate_Amount ON MovementItemContainer (ContainerId, DescId, OperDate, Amount);
-- 15.05.2016
CREATE INDEX idx_MovementItemContainer_ObjectId_Analyzer_AnalyzerId ON MovementItemContainer (ObjectId_Analyzer, AnalyzerId);












/*
 œ–»Ã≈◊¿Õ»ﬂ:
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »:
 ƒ¿“¿         ¿¬“Œ–
 ----------------
              ‘ÂÎÓÌ˛Í ».¬.      ÎËÏÂÌÚ¸Â‚  .».    ÛıÚËÌ ».¬.   
29.06.16         *
                                        
*/
