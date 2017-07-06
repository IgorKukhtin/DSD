-- Function: lpUpdate_Object_PartionGoods_Goods

DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_Goods (Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_Goods (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_PartionGoods_Goods(
    IN inGoodsId                Integer,       -- Товар
    IN inGoodsGroupId           Integer,       -- Группа товара
    IN inMeasureId              Integer,       -- Единица измерения
    IN inCompositionId          Integer,       -- Состав
    IN inGoodsInfoId            Integer,       -- Описание
    IN inLineFabricaId          Integer,       -- Линия
    IN inLabelId                Integer,       -- Название в ценнике
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN

       -- изменили во Всех партиях Товара
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.06.17                                         *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_PartionGoods_Goods()
