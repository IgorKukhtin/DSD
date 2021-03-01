-- Function: lpUpdate_Object_PartionGoods_Goods

DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_Goods (Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_Goods (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_PartionGoods_Goods(
    IN inGoodsId                Integer,       -- �����
    IN inGoodsGroupId           Integer,       -- ������ ������
    IN inMeasureId              Integer,       -- ������� ���������
    IN inCompositionId          Integer,       -- ������
    IN inGoodsInfoId            Integer,       -- ��������
    IN inLineFabricaId          Integer,       -- �����
    IN inLabelId                Integer,       -- �������� � �������
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN

       -- �������� �� ���� ������� ������
       UPDATE Object_PartionGoods SET GoodsGroupId         = inGoodsGroupId
                                    , MeasureId            = inMeasureId
                                    , CompositionId        = zfConvert_IntToNull (inCompositionId)
                                    , GoodsInfoId          = zfConvert_IntToNull (inGoodsInfoId)
                                    , LineFabricaId        = zfConvert_IntToNull (inLineFabricaId)
                                    , LabelId              = inLabelId
       WHERE Object_PartionGoods.GoodsId = inGoodsId;
                                     
END;                                 
$BODY$                               
  LANGUAGE plpgsql VOLATILE;           
                                     
/*------------------------------     -------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
06.06.17                                         *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_PartionGoods_Goods()
