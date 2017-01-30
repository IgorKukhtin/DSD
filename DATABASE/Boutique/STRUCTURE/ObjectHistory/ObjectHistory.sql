/*
  �������� 
    - ������� ObjectHistory (o������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectHistory(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                Integer NOT NULL,
   StartDate             TDateTime NOT NULL,
   EndDate               TDateTime NOT NULL,
   ObjectId              Integer NOT NULL,

   /* ����� � �������� <ObjectDesc> - ����� ������� */
   CONSTRAINT fk_ObjectHistory_DescId FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id),
   CONSTRAINT fk_ObjectHistory_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */


CREATE UNIQUE INDEX idx_ObjectHistory_ObjectId_DescId_StartDate_EndDate ON ObjectHistory(ObjectId, DescId, StartDate, EndDate);

/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
13.06.02              *                *
*/
