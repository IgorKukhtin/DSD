-- Function: gpSelect_MovementItem_Inventory_mobile()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory_mobile (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory_mobile(
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementItemId    Integer
              -- �����
             , GoodsId           Integer
             , GoodsCode         Integer
             , GoodsName         TVarChar
              -- ���
             , GoodsKindId       Integer
             , GoodsKindName     TVarChar
               -- ��� �����
             , Amount            TFloat
               -- ������ ��������
             , PartionCellId     Integer
             , PartionCellName   TVarChar
               -- ������
             , PartionGoodsDate  TDateTime
               -- � ��������
             , PartionNum        Integer
               -- ������
             , BoxId_1           Integer
             , BoxName_1         TVarChar
             , CountTare_1       Integer
             , WeightTare_1      TFloat
               -- ����
             , BoxId_2           Integer
             , BoxName_2         TVarChar
             , CountTare_2       Integer
             , WeightTare_2      TFloat
               -- ����
             , BoxId_3           Integer
             , BoxName_3         TVarChar
             , CountTare_3       Integer
             , WeightTare_3      TFloat
               -- ����
             , BoxId_4           Integer
             , BoxName_4         TVarChar
             , CountTare_4       Integer
             , WeightTare_4      TFloat
               -- ����
             , BoxId_5           Integer
             , BoxName_5         TVarChar
             , CountTare_5       Integer
             , WeightTare_5      TFloat

               -- ����� ���-�� ������
             , CountTare_calc    Integer

               -- ����� ��� ���� ������
             , WeightTare_calc   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
        SELECT
               gpGet.MovementItemId
             , gpGet.GoodsId
             , gpGet.GoodsCode
             , gpGet.GoodsName
             , gpGet.GoodsKindId
             , gpGet.GoodsKindName
               -- ��� �����
             , gpGet.Amount
               -- ������ ��������
             , gpGet.PartionCellId
             , gpGet.PartionCellName
               -- ������
             , gpGet.PartionGoodsDate
               -- � ��������
             , gpGet.PartionNum
               -- ������
             , gpGet.BoxId_1
             , gpGet.BoxName_1
             , gpGet.CountTare_1
             , gpGet.WeightTare_1

               -- ����
             , gpGet.BoxId_1
             , gpGet.BoxName_2
             , gpGet.CountTare_2
             , gpGet.WeightTare_2

               -- ����
             , gpGet.BoxId_3
             , gpGet.BoxName_3
             , gpGet.CountTare_3
             , gpGet.WeightTare_3

               -- ����
             , gpGet.BoxId_4
             , gpGet.BoxName_4
             , gpGet.CountTare_4
             , gpGet.WeightTare_4

               -- ����
             , gpGet.BoxId_5
             , gpGet.BoxName_5
             , gpGet.CountTare_5
             , gpGet.WeightTare_5

               -- ����� ���-�� ������
             , gpGet.CountTare_calc

               -- ����� ��� ���� ������
             , gpGet.WeightTare_calc

        FROM gpGet_MovementItem_Inventory_mobile ('2033173234093', zfCalc_UserAdmin()) AS gpGet
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.02.25                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Inventory_mobile (zfCalc_UserAdmin())
