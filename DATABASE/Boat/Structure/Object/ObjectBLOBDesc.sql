/*
  �������� 
    - ������� ObjectBLOBDesc (�������� ������� o������� ���� TVarChar)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectBLOBDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL,
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   CONSTRAINT fk_ObjectBLOBDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id));

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
