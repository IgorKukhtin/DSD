/*
  �������� 
    - ������� LoginProtocol (��������)
    - ������
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE LoginProtocol(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 

   CONSTRAINT fk_LoginProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object (Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

CREATE INDEX idx_LoginProtocol_UserId ON LoginProtocol (UserId);
CREATE INDEX idx_LoginProtocol_OperDate ON LoginProtocol (OperDate);


/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 02.09.15             *                                          
*/
