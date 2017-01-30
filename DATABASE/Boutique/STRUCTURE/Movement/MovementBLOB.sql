/*
  �������� 
    - ������� MovementBLOB (�������� �������� ���� TBLOB)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementBLOB(
   DescId                INTEGER NOT NULL,
   MovementId              INTEGER NOT NULL,
   ValueData             TBLOB,

   CONSTRAINT pk_MovementBLOB           PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementBLOB_DescId    FOREIGN KEY(DescId) REFERENCES MovementBLOBDesc(Id),
   CONSTRAINT fk_MovementBLOB_MovementId  FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */

CREATE UNIQUE INDEX idx_MovementBLOB_MovementId_DescId ON MovementBLOB (MovementId, DescId); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.


*/