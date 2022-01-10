/*
  �������� 
    - ������� ObjectDateHistoryDesc (�������� ������� o������� ���� TDate)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectHistoryDateDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectHistoryDateDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id) );

                                     

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
