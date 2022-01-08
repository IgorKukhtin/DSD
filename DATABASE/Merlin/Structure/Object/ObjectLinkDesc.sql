/*
  �������� 
    - ������� ObjectLinkDesc (����� ������� o�������)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectLinkDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   DescId                Integer NOT NULL,
   ChildObjectDescId     Integer,

   CONSTRAINT fk_ObjectLinkDesc_DescId       FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id),
   CONSTRAINT fk_ObjectLinkDesc_ChildObjectDescId  FOREIGN KEY(ChildObjectDescId)  REFERENCES ObjectDesc(Id));

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
