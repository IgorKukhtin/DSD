/*
  �������� 
    - ������� BranchService_Send_Id (�������� ID ��� �������� �����������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_Send_Id(
   Id             BIGINT    NOT NULL, 

   Transaction_Id BIGINT,
   Table_Name     TEXT,

   ValueId        Integer,
   DescId         Integer,
   Last_Modified  TIMESTAMP WITHOUT TIME ZONE,

   isInsert       Boolean    NOT NULL DEFAULT False,    
   
   CONSTRAINT pk_BranchService_Send_Id  PRIMARY KEY (Id)
   );

/*-------------------------------------------------------------------------------*/

-- ���������� �����
/*DO $$
BEGIN


  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Send_Id' AND c.column_name ILIKE 'isInsert')
  THEN
    ALTER TABLE _replica.BranchService_Send_Id ADD isInsert Boolean NOT NULL DEFAULT False;
  END IF;

END $$;*/

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������ �.�.
 29.06.23                                          * 
*/