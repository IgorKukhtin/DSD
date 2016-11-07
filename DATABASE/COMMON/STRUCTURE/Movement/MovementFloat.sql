/*
  �������� 
    - ������� MovementFloat (�������� o������� ���� TFloat)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementFloat(
   DescId     INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ValueData  TFloat,

   CONSTRAINT pk_MovementFloat          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementFloat_DescId   FOREIGN KEY(DescId)   REFERENCES MovementFloatDesc(Id),
   CONSTRAINT fk_MovementFloat_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
-- CREATE INDEX idx_MovementFloat_DescId ON MovementFloat (DescId); 
-- DROP INDEX idx_MovementFloat_DescId ON MovementFloat; 
CREATE UNIQUE INDEX idx_MovementFloat_MovementId_DescId ON MovementFloat (MovementId, DescId); 
CREATE INDEX idx_MovementFloat_ValueData_DescId ON MovementFloat (ValueData, DescId); 


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
               ������� �.�.   ������ �.�.   ���������� �.�.
22.03.2015                                       * set UNIQUE
14.06.2013                                       
*/