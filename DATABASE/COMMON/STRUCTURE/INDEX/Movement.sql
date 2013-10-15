DROP INDEX IF EXISTS idx_Movement_OperDate_DescId;
DROP INDEX IF EXISTS idx_Movement_ParentId; 
DROP INDEX IF EXISTS idx_Movement_StatusId; -- констрейнт
DROP INDEX IF EXISTS idx_Movement_DescId_InvNumber;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

-- Index: idx_Movement_OperDate_DescId

-- DROP INDEX idx_Movement_OperDate_DescId;

CREATE INDEX idx_Movement_OperDate_DescId ON Movement(OperDate, DescId);
CREATE INDEX idx_Movement_ParentId ON Movement(ParentId); 
CREATE INDEX idx_Movement_StatusId ON Movement(StatusId); -- констрейнт
CREATE INDEX idx_Movement_DescId_InvNumber ON Movement(DescId, zfConvert_StringToNumber(InvNumber));

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
