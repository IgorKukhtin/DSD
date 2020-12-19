/*
  �������� 
    - ������� ObjectBLOB (�������� �������� ���� TBLOB)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBLOB(
   DescId                INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,
   ValueData             TBLOB,

   CONSTRAINT pk_ObjectBLOB           PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT fk_ObjectBLOB_DescId    FOREIGN KEY(DescId) REFERENCES ObjectBLOBDesc(Id),
   CONSTRAINT fk_ObjectBLOB_ObjectId  FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */

CREATE UNIQUE INDEX idx_ObjectBLOB_ObjectId_DescId ON ObjectBLOB (ObjectId, DescId);
CREATE INDEX idx_ObjectBLOB_DescId ON ObjectBLOB (DescId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.


*/