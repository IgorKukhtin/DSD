/*
  �������� 
    - ������� ObjectHistoryDate (�������� o������� ���� TDate)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectHistoryDate(
   DescId                INTEGER NOT NULL,
   ObjectHistoryId       INTEGER NOT NULL,
   ValueData             TDateTime,

   CONSTRAINT pk_ObjectHistoryDate          PRIMARY KEY (ObjectHistoryId, DescId),
   CONSTRAINT fk_ObjectHistoryDate_DescId   FOREIGN KEY(DescId)   REFERENCES ObjectHistoryDateDesc(Id),
   CONSTRAINT fk_ObjectHistoryDate_ObjectHistoryId FOREIGN KEY(ObjectHistoryId) REFERENCES ObjectHistory(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */


CREATE UNIQUE INDEX idx_ObjectHistoryDate_ObjectHistoryId_DescId_ValueData ON ObjectHistoryDate(ObjectHistoryId, DescId, ValueData); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�. 
14.06.02                                       
*/