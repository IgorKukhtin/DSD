/*
  �������� 
    - ������� Object_Print(o������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_Print(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   ObjectId               Integer   NOT NULL,
   ReportKindId           Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   Value                  TFloat,
   ValueDate              TDateTime,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_Print_UserId ON Object_Print (UserId);
CREATE UNIQUE INDEX idx_Object_Print_ObjectId_ReportKindId_UserId ON Object_Print (ObjectId, ReportKindId, UserId); 

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.09.24                                        *
*/
