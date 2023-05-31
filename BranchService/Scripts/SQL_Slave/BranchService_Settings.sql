/*
  �������� 
    - ������� _replica.BranchService_Settings (��������� ������ �������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_Settings(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   
   ReplServerId          Integer,     --    
   
   DateSnapshot          TIMESTAMP WITHOUT TIME ZONE,   -- ���� �������� ������ (�������)

   DateSend              TIMESTAMP WITHOUT TIME ZONE,   -- ���� ������ �������� ������
   SendLastId            BIGINT,                        -- Id ��������� ������ ���� ��������� �������� ������

   DateEqualization      TIMESTAMP WITHOUT TIME ZONE,   -- ���� ������ ��������� ���������
   EqualizationLastId    BIGINT,                        -- Id ��������� ������ ���� ��������� �������� �������

   OffsetTimeEnd         Integer NOT NULL DEFAULT 10    -- �������� ������� ����� �������������
      
   );

/*-------------------------------------------------------------------------------*/

-- ���������� �����
DO $$
BEGIN

  
  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Settings' AND c.column_name ILIKE 'DateEqualization')
  THEN
    ALTER TABLE _replica.BranchService_Settings ADD DateEqualization      TIMESTAMP WITHOUT TIME ZONE;
  END IF;

  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Settings' AND c.column_name ILIKE 'SendLastId')
  THEN
    ALTER TABLE _replica.BranchService_Settings ADD SendLastId            BIGINT;
  END IF;

  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Settings' AND c.column_name ILIKE 'EqualizationLastId')
  THEN
    ALTER TABLE _replica.BranchService_Settings ADD EqualizationLastId            BIGINT;
  END IF;

  IF NOT EXISTS(SELECT * FROM _replica.BranchService_Settings)
  THEN
    INSERT INTO _replica.BranchService_Settings (Id) VALUES (1);
  END IF;

END $$; 

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������ �.�.
 02.03.23                                          * 
*/