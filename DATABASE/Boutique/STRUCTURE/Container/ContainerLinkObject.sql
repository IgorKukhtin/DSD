/*
  �������� 
    - ������� ContainerLinkObject ()
    - ������
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ContainerLinkObject(
   DescId                INTEGER NOT NULL,
   ContainerId           INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,

   CONSTRAINT fk_ContainerLinkObject_PK PRIMARY KEY (ObjectId, DescId, ContainerId),
   CONSTRAINT fk_ContainerLinkObject_Container FOREIGN KEY (ContainerId)  REFERENCES Container (Id),
   CONSTRAINT fk_ContainerLinkObject_Desc FOREIGN KEY (DescId) REFERENCES ContainerLinkObjectDesc (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */

CREATE UNIQUE INDEX idx_ContainerLinkObject_ContainerId_ObjectId_DescId ON ContainerLinkObject (ContainerId, ObjectId, DescId);
CREATE        INDEX idx_ContainerLinkObject_ContainerId_DescId_ObjectId ON ContainerLinkObject (ContainerId, DescId, ObjectId);
CREATE        INDEX idx_ContainerLinkObject_ObjectId_DescId_ContainerId ON ContainerLinkObject (ObjectId, DescId, ContainerId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
19.09.02              * chage index
03.07.13              * del CONSTRAINT fk_ContainerLinkObject_Object
*/