/*
  �������� 
    - ������� wms_Object_GoodsByGoodsKind (o������)
    - ������
    - ��������
*/
-- DROP TABLE wms_Object_GoodsByGoodsKind

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_Object_GoodsByGoodsKind(
   ObjectId            Integer  NOT NULL PRIMARY KEY, 
   GoodsId             Integer ,
   GoodsKindId	       Integer ,
   MeasureId           Integer ,
   GoodsTypeKindId_Sh  Integer ,
   GoodsTypeKindId_Nom Integer ,
   GoodsTypeKindId_Ves Integer ,

   GoodsId_link_sh     Integer , -- ***����� (�� ��������� "�������")
   GoodsKindId_link_sh Integer , -- ***��� ������ (�� ��������� "�������")

   WeightAvg_Sh        TFloat  , -- ***������� ��� 1��. ��� ��������� ��.
   WeightAvg_Nom       TFloat  , -- ***������� ��� 1��. ��� ��������� �������
   WeightAvg_Ves       TFloat  , -- ***������� ��� 1��. ��� ��������� ���������
   Tax_Sh              TFloat  , -- ***% ���������� ���� 1��. ��� ��������� ��.
   Tax_Nom             TFloat  , -- ***% ���������� ���� 1��. ��� ��������� �������
   Tax_Ves             TFloat  , -- ***% ���������� ���� 1��. ��� ��������� ���������

   WeightMin_Sh        TFloat  , -- ***calc = ��� ��� 1��. ��� ��������� ��.
   WeightMax_Sh        TFloat  , -- ***calc = ���� ��� 1��. ��� ��������� ��.
   WeightMin_Nom       TFloat  , -- ***calc = ��� ��� 1��. ��� ��������� �������
   WeightMax_Nom       TFloat  , -- ***calc = ���� ��� 1��. ��� ��������� �������
   WeightMin_Ves       TFloat  , -- ***calc = ��� ��� 1��. ��� ��������� ���������
   WeightMax_Ves       TFloat  , -- ***calc = ���� ��� 1��. ��� ��������� ���������

   WeightOnBox_Sh      TFloat  , -- ***calc = ��� ����� � ��. (E2/E3) ��� ��������� ��.
   WeightOnBox_Nom     TFloat  , -- ***calc = ��� ����� � ��. (E2/E3) ��� ��������� 
   WeightOnBox_Ves     TFloat  , -- ***calc = ��� ����� � ��. (E2/E3) ��� ��������� 

   WeightMin           TFloat  , -- calc = ���. ��������� ��� 1��. �� ���� ����������
   WeightMax           TFloat  , -- calc = ����. ��������� ��� 1��. �� ���� ����������
   
   NormInDays          TFloat  , -- C��� ��������, ��.

   Height              TFloat  , -- ������
   Length              TFloat  , -- �����
   Width               TFloat  , -- ������

   WmsCode             Integer , -- ��� ��� - ��� sku_code

   GoodsPropertyBoxId  Integer , -- ���� ���  BoxId + GoodsId + GoodsKindId
   BoxId               Integer , -- 
   BoxWeight           TFloat  , -- ��� ������ ��. (E2/E3)

   WeightOnBox         TFloat  , -- !!!calc = ��� ����� � �� (E2/E3) - �� ���� ����������
   CountOnBox          TFloat  , -- ���-�� ��. � ��. (E2/E3) - !!!����� ������������!!!

   WmsCellNum          Integer , -- � ������ �� ������ ���

   sku_id_Sh           TVarChar, -- sku_id ��� - ��.
   sku_id_Nom          TVarChar, -- sku_id ��� - �������
   sku_id_Ves          TVarChar, -- sku_id ��� - ���������

   sku_code_Sh         TVarChar, -- sku_code - ��.
   sku_code_Nom        TVarChar, -- sku_code - �������
   sku_code_Ves        TVarChar, -- sku_code - ���������

   isErased            Boolean  
  );
/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */
CREATE UNIQUE INDEX idx_wms_Object_GoodsByGoodsKind_ObjectId            ON wms_Object_GoodsByGoodsKind (ObjectId);
CREATE UNIQUE INDEX idx_wms_Object_GoodsByGoodsKind_GoodsId_GoodsKindId ON wms_Object_GoodsByGoodsKind (GoodsId, GoodsKindId);

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
