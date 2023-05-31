/*
  �������� 
    - ������� _replica.BranchService_Reserve_Movement (������ ID � InvNumber ��� ������� Movement)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_Reserve_Movement(
   DescId     integer   NOT NULL, -- DesecId - ��� InvNumber 
                                  --       0 - Movement
                                  --      -1 - MovementItem

   Id         INTEGER NOT NULL, 
   
   
   isUsed     boolean   NOT NULL DEFAULT False,  -- ������������
   isSend     boolean   NOT NULL DEFAULT False,  -- �������� ���������

   CONSTRAINT pk_BranchService_Reserve_Movement  PRIMARY KEY (DescId, Id)
   );

CREATE INDEX IF NOT EXISTS idx_BranchService_Reserve_Movement_Used_DescId_Id ON _replica.BranchService_Reserve_Movement (isUsed, DescId, Id); 

/*-------------------------------------------------------------------------------*/

-- ���������� �����
DO $$
BEGIN


  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Reserve_Movement' AND c.column_name ILIKE 'DescId')
  THEN
    ALTER TABLE _replica.BranchService_Reserve_Movement ADD DescId  integer   NOT NULL;
  END IF;

END $$; 

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������ �.�.
 10.04.23                                          * 
*/