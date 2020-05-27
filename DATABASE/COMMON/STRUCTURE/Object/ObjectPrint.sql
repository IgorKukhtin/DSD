/*
  �������� 
    - ������� ObjectPrint(o������)
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectPrint(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   ObjectId               Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   Amount                 Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_ObjectPrint_InsertDate_UserId ON ObjectPrint (InsertDate, UserId);
CREATE UNIQUE INDEX idx_ObjectPrint_ObjectId_InsertDate ON ObjectPrint (ObjectId, InsertDate); 

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.20                                        *
*/
