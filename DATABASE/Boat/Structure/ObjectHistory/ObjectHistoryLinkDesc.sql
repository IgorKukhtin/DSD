/*
  �������� 
    - ������� ObjectHistoryLinkDesc (����� ������� o�������)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectHistoryLinkDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   DescId                Integer NOT NULL,
   ObjectDescId          Integer,

   CONSTRAINT fk_ObjectHistoryLinkDesc_DescId       FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id),
   CONSTRAINT fk_ObjectHistoryLinkDesc_ObjectDescId  FOREIGN KEY(ObjectDescId)  REFERENCES ObjectDesc(Id));

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */



/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 29.06.13             * SERIAL
*/
