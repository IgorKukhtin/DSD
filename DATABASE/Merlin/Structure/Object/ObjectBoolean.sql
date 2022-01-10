/*
  �������� 
    - ������� ObjectBoolean (�������� �������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBoolean(
   DescId                INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,
   ValueData             Boolean,

   CONSTRAINT pk_ObjectBoolean          PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT fk_ObjectBoolean_DescId   FOREIGN KEY(DescId) REFERENCES ObjectBooleanDesc(Id),
   CONSTRAINT fk_ObjectBoolean_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */


CREATE UNIQUE INDEX idx_ObjectBoolean_ObjectId_DescId_ValueData ON ObjectBoolean (ObjectId, DescId, ValueData);
CREATE INDEX idx_ObjectBoolean_ValueData_DescId_ObjectId ON ObjectBoolean (ValueData, DescId, ObjectId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.
14.06.02
*/