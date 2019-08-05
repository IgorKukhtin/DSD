/*
  �������� 
    - ������� Object_GoodsByGoodsKind (o������)
    - ������
    - ��������
*/
--drop TABLE Object_GoodsByGoodsKind

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
   BoxId               Integer ,
   BoxWeight           TFloat  ,
   WeightOnBox         TFloat  ,
   CountOnBox          TFloat  ,
   isErased            Boolean ,
   WmsCellNum          Integer
   );
/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */



/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������� �.�.    
23.05.19                                            *
*/




