/*
  �������� 
    - ������� ObjectCostLinkDesc (���� �������� ��� ������� �\�)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectCostLinkDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar,
   ItemName              TVarChar,
   ObjectDescId          INTEGER NOT NULL,

   CONSTRAINT fk_ObjectCostDesc_ObjectDescId FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id)
);



/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */



/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 11.07.13             
*/
