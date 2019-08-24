/*
  �������� 
    - ������� Object_GoodsByGoodsKind (o������)
    - ������
    - ��������
*/
-- DROP TABLE Object_GoodsByGoodsKind

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_GoodsByGoodsKind(
   ObjectId            Integer  NOT NULL PRIMARY KEY, 
   GoodsId             Integer ,
   GoodsKindId	       Integer ,
   MeasureId           Integer ,
   GoodsTypeKindId_Sh  Integer ,
   GoodsTypeKindId_Nom Integer ,
   GoodsTypeKindId_Ves Integer ,
   WeightMin           TFloat  ,
   WeightMax           TFloat  ,
   NormInDays          TFloat  ,
   Height              TFloat  ,
   Length              TFloat  ,
   Width               TFloat  ,
   WmsCode             Integer ,
   GoodsPropertyBoxId  Integer ,   -- ���� ���  BoxId + GoodsId + GoodsKindId
   BoxId               Integer ,   -- 
   BoxWeight           TFloat  ,   -- ��� ������ ��. (E2/E3)
   WeightOnBox         TFloat  ,   -- ���-�� ��. � ��. (E2/E3)
   CountOnBox          TFloat  ,   -- ���-�� ��. � ��. (E2/E3) - ����� ������������
   WmsCellNum          Integer ,
   sku_id_Sh           TVarChar,
   sku_id_Nom          TVarChar,
   sku_id_Ves          TVarChar,
   sku_code_Sh         TVarChar,
   sku_code_Nom        TVarChar,
   sku_code_Ves        TVarChar,
   isErased            Boolean  
  );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE UNIQUE INDEX idx_Object_GoodsByGoodsKind_ObjectId            ON Object_GoodsByGoodsKind (ObjectId);
CREATE UNIQUE INDEX idx_Object_GoodsByGoodsKind_GoodsId_GoodsKindId ON Object_GoodsByGoodsKind (GoodsId, GoodsKindId);

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
              ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19                                       *
 23.05.19         *
*/
