/*
  �������� 
    - ������� ObjectBooleanDesc (�������� ������� o������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBooleanDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectBooleanDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) 
);

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
