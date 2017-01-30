DROP INDEX IF EXISTS idx_Object_DescId;
DROP INDEX IF EXISTS idx_Object_DescId_ValueData;
DROP INDEX IF EXISTS idx_Object_DescId_ObjectCode;

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_DescId ON Object(DescId);
CREATE INDEX idx_Object_DescId_ValueData ON Object(DescId, ValueData);
CREATE INDEX idx_Object_DescId_ObjectCode ON Object(DescId, ObjectCode);

CLUSTER object_pkey ON Object; 

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
27.06.13              *

*/
