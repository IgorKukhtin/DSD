/*
  �������� 
    - ������� ContainerKey ()
    - ������
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ContainerKey(
   ContainerId           INTEGER NOT NULL, 
   Key                   TVarChar NOT NULL, 

   CONSTRAINT pk_ContainerKey             PRIMARY KEY (ContainerId),
   CONSTRAINT fk_ContainerKey_ContainerId FOREIGN KEY (ContainerId) REFERENCES Container(Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */

CREATE UNIQUE INDEX idx_ContainerKey_Key_ContainerId ON ContainerKey (Key, ContainerId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
07.04.14                              *           
*/
