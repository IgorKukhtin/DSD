/*
  �������� 
    - ������� _replica.BranchService_DescId_Movement (�������� ���������� ��� �������� � �����������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_DescId_Movement(
   DescId               INTEGER NOT NULL PRIMARY KEY, 
   
   isEqualization       boolean   NOT NULL DEFAULT False,  -- �������� � ���� ���������
   isInsert             boolean   NOT NULL DEFAULT False,  -- ��������� ���������

   MovementDescMax      Integer  NOT NULL DEFAULT 300,  -- �������������� ������� ���������� ��� ������ DescId
   MovementDescMin      Integer  NOT NULL DEFAULT 100   -- ����������� ���������� ������� ��� ������ DescId

   );

/*-------------------------------------------------------------------------------*/

-- ���������� �����
DO $$
BEGIN

  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_DescId_Movement' AND c.column_name ILIKE 'MovementDescMax')
  THEN
    ALTER TABLE _replica.BranchService_DescId_Movement ADD MovementDescMax Integer  NOT NULL DEFAULT 300;
  END IF;

  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_DescId_Movement' AND c.column_name ILIKE 'MovementDescMin')
  THEN
    ALTER TABLE _replica.BranchService_DescId_Movement ADD MovementDescMin  Integer  NOT NULL DEFAULT 100;
  END IF;
  
  IF NOT EXISTS (SELECT * FROM _replica.BranchService_DescId_Movement WHERE _replica.BranchService_DescId_Movement.DescId = 0)
  THEN
    INSERT INTO _replica.BranchService_DescId_Movement (DescId, MovementDescMax, MovementDescMin) VALUES (0, 1000, 100);
  END IF;

  IF NOT EXISTS (SELECT * FROM _replica.BranchService_DescId_Movement WHERE _replica.BranchService_DescId_Movement.DescId = -1)
  THEN
    INSERT INTO _replica.BranchService_DescId_Movement (DescId, MovementDescMax, MovementDescMin) VALUES (-1, 3000, 300);
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