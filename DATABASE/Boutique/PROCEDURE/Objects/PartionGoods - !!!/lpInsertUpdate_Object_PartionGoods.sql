-- Function: lpInsertUpdate_Object_PartionGoods

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                           );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionGoods(
    IN inMovementItemId         Integer,       -- Ключ партии
    IN inMovementId             Integer,       -- Ключ Документа
    IN inSybaseId               Integer,       -- Ключ партии в Sybase
    IN inPartnerId              Integer,       -- Поcтавщики
    IN inUnitId                 Integer,       -- Подразделение(прихода)
    IN inOperDate               TDateTime,     -- Дата прихода
    IN inGoodsId                Integer,       -- Товары
    IN inGoodsItemId            Integer,       -- Товары с размерами
    IN inCurrencyId             Integer,       -- Валюта для цены прихода
    IN inAmount                 TFloat,        -- Кол-во приход
    IN inOperPrice              TFloat,        -- Цена прихода
    IN inPriceSale              TFloat,        -- Цена продажи, !!!грн!!!
    IN inBrandId                Integer,       -- Торговая марка
    IN inPeriodId               Integer,       -- Сезон
    IN inPeriodYear             Integer,       -- Год
    IN inFabrikaId              Integer,       -- Фабрика производитель
    IN inGoodsGroupId           Integer,       -- Группы товаров
    IN inMeasureId              Integer,       -- Единицы измерения
    IN inCompositionId          Integer,       -- Состав товара
    IN inGoodsInfoId            Integer,       -- Описание товара
    IN inLineFabricaId          Integer,       -- Линия коллекции
    IN inLabelId                Integer,       -- Название для ценника
    IN inCompositionGroupId     Integer,       -- Группа для состава товара
    IN inGoodsSizeId            Integer,       -- Размер товара
    IN inJuridicalId            Integer,       -- Юр.лицо(наше)
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN
       -- изменили элемент - по значению <Ключ партии>
       UPDATE Object_PartionGoods
              SET MovementId           = inMovementId
                , SybaseId             = CASE WHEN inSybaseId > 0 THEN inSybaseId ELSE SybaseId END -- !!!если что - оставим без изменения!!!
                , PartnerId            = inPartnerId
                , UnitId               = inUnitId
                , OperDate             = inOperDate
                , GoodsId              = inGoodsId
                , GoodsItemId          = inGoodsItemId -- ***
                , CurrencyId           = inCurrencyId
                , Amount               = inAmount
                , OperPrice            = inOperPrice
                , PriceSale            = inPriceSale
                , BrandId              = inBrandId
                , PeriodId             = inPeriodId
                , PeriodYear           = inPeriodYear
                , FabrikaId            = zfConvert_IntToNull (inFabrikaId)
                , GoodsGroupId         = inGoodsGroupId
                , MeasureId            = inMeasureId
                , CompositionId        = zfConvert_IntToNull (inCompositionId)
                , GoodsInfoId          = zfConvert_IntToNull (inGoodsInfoId)
                , LineFabricaId        = zfConvert_IntToNull (inLineFabricaId)
                , LabelId              = inLabelId
                , CompositionGroupId   = zfConvert_IntToNull (inCompositionGroupId)
                , GoodsSizeId          = inGoodsSizeId
                , JuridicalId          = zfConvert_IntToNull (inJuridicalId)
       WHERE Object_PartionGoods.MovementItemId = inMovementItemId ;
                                     
                                     
       -- если такой элемент не был найден
       IF NOT FOUND THEN             
          -- добавили новый элемент
          INSERT INTO Object_PartionGoods (MovementItemId, MovementId, SybaseId, PartnerId, UnitId, OperDate, GoodsId, GoodsItemId
                                         , CurrencyId, Amount, OperPrice, PriceSale, BrandId, PeriodId, PeriodYear
                                         , FabrikaId, GoodsGroupId, MeasureId
                                         , CompositionId, GoodsInfoId, LineFabricaId
                                         , LabelId, CompositionGroupId, GoodsSizeId, JuridicalId)
                                   VALUES (inMovementItemId, inMovementId, inSybaseId, inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId
                                         , inCurrencyId, inAmount, inOperPrice, inPriceSale, inBrandId, inPeriodId, inPeriodYear
                                         , zfConvert_IntToNull (inFabrikaId), inGoodsGroupId, inMeasureId
                                         , zfConvert_IntToNull (inCompositionId), zfConvert_IntToNull (inGoodsInfoId), zfConvert_IntToNull (inLineFabricaId)
                                         , inLabelId, zfConvert_IntToNull (inCompositionGroupId), inGoodsSizeId, zfConvert_IntToNull (inJuridicalId));
       END IF; -- if NOT FOUND       

       -- !!!меняем у остальных партий - все св-ва!!!
       UPDATE Object_PartionGoods SET FabrikaId              = zfConvert_IntToNull (inFabrikaId)
                                    , GoodsGroupId           = inGoodsGroupId
                                    , MeasureId              = inMeasureId
                                    , CompositionId          = zfConvert_IntToNull (inCompositionId)
                                    , GoodsInfoId            = zfConvert_IntToNull (inGoodsInfoId)
                                    , LineFabricaId          = zfConvert_IntToNull (inLineFabricaId)
                                    , LabelId                = inLabelId
                                    , CompositionGroupId     = zfConvert_IntToNull (inCompositionGroupId)
                                      -- только для документа inMovementId
                                    , JuridicalId            = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN zfConvert_IntToNull (inJuridicalId) ELSE Object_PartionGoods.JuridicalId END
                                    , OperPrice              = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inOperPrice                         ELSE Object_PartionGoods.OperPrice   END
                                    , PriceSale              = CASE WHEN Object_PartionGoods.MovementId = inMovementId THEN inPriceSale                         ELSE Object_PartionGoods.PriceSale   END
       WHERE Object_PartionGoods.MovementItemId <> inMovementItemId
         AND Object_PartionGoods.GoodsId        = inGoodsId;
                                     
                                     
END;                                 
$BODY$                               
                                     
LANGUAGE plpgsql VOLATILE;           
                                     
/*------------------------------     -------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.17                                         * all
11.04.17          * lp
15.03.17                                                          *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PartionGoods()
