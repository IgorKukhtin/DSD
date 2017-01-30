/*
  �������� 
    - ������� ContainerObjectCost()
    - ������
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ContainerObjectCost(
   ObjectCostDescId      INTEGER NOT NULL,
   ContainerId           INTEGER NOT NULL,
   ObjectCostId          INTEGER NOT NULL,

   CONSTRAINT fk_ContainerObjectCost_PK PRIMARY KEY (ContainerId),
   CONSTRAINT fk_ContainerObjectCost_Container FOREIGN KEY (ContainerId)  REFERENCES Container (Id),
   CONSTRAINT fk_ContainerObjectCost_ObjectCostDescId FOREIGN KEY (ObjectCostDescId)  REFERENCES ObjectCostDesc(Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */

--CREATE INDEX idx_ContainerLinkObject_ContainerId_DescId_ObjectId ON ContainerLinkObject(ContainerId, DescId, ObjectId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   

 11.07.13                              *
*/