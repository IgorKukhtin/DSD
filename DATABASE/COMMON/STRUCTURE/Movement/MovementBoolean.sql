/*
  �������� 
    - ������� MovementBoolean (�������� �������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementBoolean(
   DescId                INTEGER NOT NULL,
   MovementId            INTEGER NOT NULL,
   ValueData             Boolean,

   CONSTRAINT pk_MovementBoolean          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementBoolean_DescId   FOREIGN KEY(DescId) REFERENCES MovementBooleanDesc(Id),
   CONSTRAINT fk_MovementBoolean_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE UNIQUE INDEX idx_MovementBoolean_MovementId_DescId ON MovementBoolean (MovementId, DescId); 
CREATE INDEX idx_MovementBoolean_ValueData_DescId ON MovementBoolean (ValueData, DescId); 


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
22.03.2015                                       * add idx_MovementBoolean_MovementId_DescId
*/