/*
  �������� 
    - ������� ObjectString (�������� �������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectString(
   DescId                INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,
   ValueData             TVarChar,

   CONSTRAINT pk_ObjectString          PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT fk_ObjectString_DescId   FOREIGN KEY(DescId) REFERENCES ObjectStringDesc(Id),
   CONSTRAINT fk_ObjectString_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */


CREATE UNIQUE INDEX idx_ObjectString_ObjectId_DescId ON ObjectString (ObjectId, DescId);
CREATE INDEX idx_ObjectString_ValueData_DescId_ObjectId ON ObjectString (ValueData, DescId, ObjectId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.
14.06.02
*/