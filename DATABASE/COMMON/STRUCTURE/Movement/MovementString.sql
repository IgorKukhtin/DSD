/*
  �������� 
    - ������� MovementString (�������� �������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementString(
   DescId                INTEGER NOT NULL,
   MovementId              INTEGER NOT NULL,
   ValueData             TVarChar,

   CONSTRAINT pk_MovementString          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementString_DescId   FOREIGN KEY(DescId) REFERENCES MovementStringDesc(Id),
   CONSTRAINT fk_MovementString_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */


CREATE UNIQUE INDEX idx_MovementString_MovementId_DescId ON MovementString (MovementId, DescId);
CREATE INDEX idx_MovementString_ValueData_DescId ON MovementString (ValueData, DescId); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
14.06.2013
*/