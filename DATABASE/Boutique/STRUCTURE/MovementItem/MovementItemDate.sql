/*
  �������� 
    - ������� MovementItemDate (�������� o������� ���� TDate)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementItemDate(
   DescId                INTEGER NOT NULL,
   MovementItemId        INTEGER NOT NULL,
   ValueData             TDateTime,

   CONSTRAINT pk_MovementItemDate          PRIMARY KEY (MovementItemId, DescId),
   CONSTRAINT fk_MovementItemDate_DescId   FOREIGN KEY(DescId)   REFERENCES MovementItemDateDesc(Id),
   CONSTRAINT fk_MovementItemDate_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */


CREATE UNIQUE INDEX idx_MovementItemDate_MovementItemId_DescId_ValueData ON MovementItemDate(MovementItemId, DescId, ValueData); 
CREATE INDEX idx_MovementItemDate_ValueData_DescId ON MovementItemDate(ValueData, DescId); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�. 
14.06.02                                       
*/