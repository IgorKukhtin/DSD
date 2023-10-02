/*
  �������� 
    - ������� _replica.MovementProtocol_Rewiring (������ ��� ������������ �� MovementItemContainer)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.MovementProtocol_Rewiring(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Transaction_Id        BIGINT,

   MovementId            INTEGER,
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 
   isInsert              Boolean,

   CONSTRAINT fk_MovementProtocol_Rewiring_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementProtocol_Rewiring_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

CREATE INDEX IF NOT EXISTS idx_MovementProtocol_Rewiring_MovementId ON _replica.MovementProtocol_Rewiring (MovementId);
CREATE INDEX IF NOT EXISTS idx_MovementProtocol_Rewiring_Transaction_Id ON _replica.MovementProtocol_Rewiring (Transaction_Id);


/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������ �.�.
 19.09.23                                          * 
*/