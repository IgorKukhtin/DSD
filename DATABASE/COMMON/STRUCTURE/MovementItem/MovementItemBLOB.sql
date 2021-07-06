/*
  �������� 
    - ������� MovementItemBLOB (�������� �������� ���� TBLOB)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemBLOB(
   DescId                INTEGER NOT NULL,
   MovementItemId        INTEGER NOT NULL,
   ValueData             TBLOB,

   CONSTRAINT pk_MovementItemBLOB                 PRIMARY KEY (MovementItemId, DescId),
   CONSTRAINT fk_MovementItemBLOB_DescId          FOREIGN KEY (DescId) REFERENCES MovementItemBLOBDesc(Id),
   CONSTRAINT fk_MovementItemBLOB_MovementItemId  FOREIGN KEY (MovementItemId) REFERENCES MovementItem(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */

CREATE UNIQUE INDEX idx_MovementItemBLOB_MovementItemId_DescId ON MovementItemBLOB (MovementItemId, DescId); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.  ������ �.�. 
 27.06.13                                         *

*/