/*
  �������� 
    - ������� MovementDate (�������� o������� ���� TDate)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementDate(
   DescId     INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ValueData  TDateTime,

   CONSTRAINT pk_MovementDate          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementDate_DescId   FOREIGN KEY(DescId)   REFERENCES MovementDateDesc(Id),
   CONSTRAINT fk_MovementDate_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE UNIQUE INDEX idx_MovementDate_MovementId_DescId ON MovementDate (MovementId, DescId); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
22.03.2015                                       * add idx_MovementBoolean_MovementId_DescId
14.06.2013                                       
*/