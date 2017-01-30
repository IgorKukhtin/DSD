DROP INDEX IF EXISTS idx_Movement_OperDate_DescId;
DROP INDEX IF EXISTS idx_Movement_ParentId; 
DROP INDEX IF EXISTS idx_Movement_StatusId; -- ����������
DROP INDEX IF EXISTS idx_Movement_DescId_InvNumber;

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

-- Index: idx_Movement_OperDate_DescId

-- DROP INDEX idx_Movement_OperDate_DescId;

CREATE INDEX idx_Movement_OperDate_DescId ON Movement(OperDate, DescId);
CREATE INDEX idx_Movement_ParentId ON Movement(ParentId); 
CREATE INDEX idx_Movement_StatusId ON Movement(StatusId); -- ����������
CREATE INDEX idx_Movement_DescId_InvNumber ON Movement(DescId, zfConvert_StringToNumber(InvNumber));

/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
