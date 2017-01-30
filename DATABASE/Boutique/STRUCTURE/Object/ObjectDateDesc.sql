/*
  �������� 
    - ������� ObjectDateDesc (�������� ������� o������� ���� TDate)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectDateDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectDateDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) );



/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */



/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 27.06.13             * SERIAL
*/
