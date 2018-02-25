/*
  �������� 
    - ������� Object_GoodsPrint(o������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_GoodsPrint(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   PartionId              Integer   NOT NULL,
   UnitId                 Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   Amount                 TFloat    NOT NULL,
   isReprice              Boolean   NOT NULL, 
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_GoodsPrint_InsertDate_UserId ON Object_GoodsPrint (InsertDate, UserId);
CREATE UNIQUE INDEX idx_Object_GoodsPrint_PartionId_UnitId_InsertDate ON Object_GoodsPrint (PartionId, UnitId, InsertDate); 

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.17                                        *
*/
