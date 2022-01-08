/*
  �������� 
    - ������� MovementItemString (�������� �������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemString(
   DescId                INTEGER NOT NULL,
   MovementItemId              INTEGER NOT NULL,
   ValueData             TVarChar,

   CONSTRAINT pk_MovementItemString          PRIMARY KEY (MovementItemId, DescId),
   CONSTRAINT fk_MovementItemString_DescId   FOREIGN KEY(DescId) REFERENCES MovementItemStringDesc(Id),
   CONSTRAINT fk_MovementItemString_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */


CREATE UNIQUE INDEX idx_MovementItemString_MovementItemId_DescId ON MovementItemString (MovementItemId, DescId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.
14.06.02
*/