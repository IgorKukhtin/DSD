/*
  �������� 
    - ������� ObjectCostLink (��������� �������� "������� �/�.")
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectCostLink(
   DescId                INTEGER NOT NULL,
   ObjectCostDescId      INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,
   ObjectCostId          INTEGER NOT NULL,

   CONSTRAINT pk_ObjectCostLink                    PRIMARY KEY (ObjectCostId, ObjectId, DescId, ObjectCostDescId),
   CONSTRAINT fk_ObjectCostLink_DescId             FOREIGN KEY(DescId) REFERENCES ObjectCostLinkDesc(Id),
   CONSTRAINT fk_ObjectCostLink_ObjectCostDescId   FOREIGN KEY(ObjectCostDescId) REFERENCES ObjectCostDesc(Id)
);
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

CREATE INDEX idx_ObjectCostLink_ObjectId_DescId_ObjectCostDescId  ON ObjectCostLink (ObjectId, DescId, ObjectCostDescId);
CREATE INDEX idx_ObjectCostLink_ObjectCostDescId_ObjectId_DescId  ON ObjectCostLink (ObjectCostDescId, ObjectId, DescId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.
19.09.02              * chage index
14.07.13              * rem fk_ObjectCostLink_ObjectId
11.07.13                               *       
*/
