/*
  �������� 
    - ������� ObjectLink (����� o�������)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectHistoryLink(
   DescId                INTEGER NOT NULL,
   ObjectHistoryId       INTEGER NOT NULL,
   ObjectId              INTEGER,

   CONSTRAINT pk_ObjectHistoryLink                PRIMARY KEY (ObjectHistoryId, DescId),
   CONSTRAINT fk_ObjectHistoryLink_DescId         FOREIGN KEY(DescId) REFERENCES ObjectHistoryLinkDesc(Id),
   CONSTRAINT fk_ObjectHistoryLink_ObjectHistoryId       FOREIGN KEY(ObjectHistoryId) REFERENCES ObjectHistory(Id),
   CONSTRAINT fk_ObjectHistoryLink_ObjectId  FOREIGN KEY(ObjectId) REFERENCES Object(Id));
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

CREATE UNIQUE INDEX idx_ObjectHistoryLink_ObjectHistoryId_DescId_ChildObjectId  ON ObjectHistoryLink(ObjectHistoryId, DescId, ObjectId);
CREATE UNIQUE INDEX idx_ObjectHistoryLink_ObjectId_DescId_ObjectHistoryId  ON ObjectHistoryLink(ObjectId, DescId, ObjectHistoryId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.
13.06.02                                      
*/
