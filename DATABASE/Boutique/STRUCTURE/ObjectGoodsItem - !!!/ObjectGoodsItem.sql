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
   IsErased               Boolean NOT NULL DEFAULT FALSE,
   isArc                  Boolean NOT NULL DEFAULT FALSE

   /* ����� � �������� <ObjectDesc> - ����� ������� */
 
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_Object_GoodsItem_GoodsId ON Object_GoodsItem(GoodsId);
CREATE INDEX idx_Object_GoodsItem_GoodsSizeId ON Object_GoodsItem(GoodsSizeId);
CREATE UNIQUE INDEX idx_Object_GoodsItem_GoodsId_GoodsSizeId ON Object_GoodsItem (GoodsId, GoodsSizeId); 

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 


*/




