/*
  �������� 
    - ������� Object_GoodsItem (o������)
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_GoodsItem(
   Id                     SERIAL NOT NULL PRIMARY KEY, 
   GoodsId                Integer NOT NULL,
   GoodsSizeId            Integer NOT NULL,
   IsErased               Boolean NOT NULL DEFAULT false,
   isArc                  Boolean NOT NULL DEFAULT false

   /* ����� � �������� <ObjectDesc> - ����� ������� */
 
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_GoodsItem_GoodsId ON Object_GoodsItem(GoodsId);
CREATE INDEX idx_Object_GoodsItem_GoodsSizeId ON Object_GoodsItem(GoodsSizeId);


CLUSTER object_pkey ON Object_GoodsItem; 

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 


*/




