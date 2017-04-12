-- Function: lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer
                                                          , TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                          , Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionGoods(
 INOUT ioMovementItemId         Integer,       -- Ключ партии            
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
    IN inUserId                 Integer       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
BEGIN

   IF COALESCE (ioMovementItemId, 0) = 0 THEN
      -- добавили новый элемент справочника и вернули значение <Ключ объекта>
      INSERT INTO Object_PartionGoods (MovementId, SybaseId, PartnerId, UnitId, OperDate, GoodsId, GoodsItemId, CurrencyId, Amount, OperPrice, PriceSale, BrandId, PeriodId, PeriodYear, FabrikaId, GoodsGroupId, MeasureId, CompositionId, GoodsInfoId, LineFabricaId, LabelId, CompositionGroupId, GoodsSizeId )
                  VALUES (inMovementId, inSybaseId, inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId, inCurrencyId, inAmount, inOperPrice, inPriceSale, inBrandId, inPeriodId, inPeriodYear, inFabrikaId, inGoodsGroupId, inMeasureId, inCompositionId, inGoodsInfoId, inLineFabricaId, inLabelId, inCompositionGroupId, inGoodsSizeId) 
      RETURNING Id INTO ioMovementItemId;

   ELSE
       -- изменили элемент справочника по значению <Ключ объекта>
       UPDATE Object_PartionGoods 
              SET MovementId    = inMovementId
                , SybaseId      = inSybaseId
                , PartnerId     = inPartnerId
                , UnitId        = inUnitId
                , OperDate      = inOperDate
                , GoodsId       = inGoodsId
                , GoodsItemId   = inGoodsItemId
                , CurrencyId    = inCurrencyId
                , Amount        = inAmount
                , OperPrice     = inOperPrice
                , PriceSale     = inPriceSale
                , BrandId       = inBrandId
                , PeriodId      = inPeriodId
                , PeriodYear    = inPeriodYear
                , FabrikaId     = inFabrikaId
                , GoodsGroupId  = inGoodsGroupId
                , MeasureId     = inMeasureId
                , CompositionId = inCompositionId
                , GoodsInfoId   = inGoodsInfoId
                , LineFabricaId = inLineFabricaId
                , LabelId       = inLabelId
                , CompositionGroupId = inCompositionGroupId
                , GoodsSizeId   = inGoodsSizeId 
       WHERE Id = ioMovementItemId ;

       -- если такой элемент не был найден
       IF NOT FOUND THEN
          -- добавили новый элемент справочника со значением <Ключ объекта>
          INSERT INTO Object_PartionGoods (MovementItemId, MovementId, SybaseId, PartnerId, UnitId, OperDate, GoodsId, GoodsItemId, CurrencyId, Amount, OperPrice, PriceSale, BrandId, PeriodId, PeriodYear, FabrikaId, GoodsGroupId, MeasureId, CompositionId, GoodsInfoId, LineFabricaId, LabelId, CompositionGroupId, GoodsSizeId)
                     VALUES (ioMovementItemId, inMovementId, inSybaseId, inPartnerId, inUnitId, inOperDate, inGoodsId, inGoodsItemId, inCurrencyId, inAmount, inOperPrice, inPriceSale, inBrandId, inPeriodId, inPeriodYear, inFabrikaId, inGoodsGroupId, inMeasureId, inCompositionId, inGoodsInfoId, inLineFabricaId, inLabelId, inCompositionGroupId, inGoodsSizeId);
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioMovementItemId, 0) = 0  


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
11.04.17          * lp
15.03.17                                                          *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_PartionGoods()
