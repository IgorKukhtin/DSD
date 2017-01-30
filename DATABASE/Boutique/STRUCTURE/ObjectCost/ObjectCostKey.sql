/*
  �������� 
    - ������� ObjectCostKey (���� ��� ������ �������������)
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectCostKey(
   ObjectCostId          INTEGER  NOT NULL,
   Key                   TVarChar NOT NULL, 

   CONSTRAINT pk_ObjectCostKey                     PRIMARY KEY (ObjectCostId)
);
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */

CREATE INDEX idx_ObjectCostKey_Key_ObjectCostId  ON ObjectCostKey (Key, ObjectCostId);

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.
08.04.14                               * 
*/
