-- Function: gpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionGoods (Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionGoods(
 INOUT ioMovementItemId         Integer,       -- Ключ партии            
    IN inMovementId             Integer,       -- Ключ Документа             
    IN inPartnerId              Integer,       -- Поcтавщики
    IN inUnitId                 Integer,       -- Подразделение(прихода)
    IN inOperDate               TDateTime,     -- Дата прихода
    IN inGoodsId                Integer,       -- Товары
    IN inGoodsItemId            Integer,       -- Товары с размерами
    IN inCurrencyId             Integer,       -- Валюта для цены прихода
    IN inAmount                 TFloat,        -- Кол-во приход
    IN inOperPrice              TFloat,        -- Цена прихода
    IN inCountForPrice          TFloat,        -- Цена за количество
    IN inOperPriceList          TFloat,        -- Цена продажи, !!!грн!!!
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
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);
   

   RAISE EXCEPTION 'Пока незачем вызывать эту проц на уровне Приложения, потом для изменения inGoodsSizeId - ПОНАДОБИТСЯ';



   IF NOT EXISTS (SELECT 1 FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioMovementItemId) THEN
      -- добавили новый элемент справочника и вернули значение <Ключ объекта>
      RAISE EXCEPTION 'добавили новый элемент справочника и вернули значение <Ключ объекта>';
   ELSE
     -- cохраняем Object_PartionGoods + Update св-ва у остальных партий этого vbGoodsId
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId := ioMovementItemId
                                               , inMovementId     := inMovementId
                                               , inPartnerId      := vbPartnerId
                                               , inUnitId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inOperDate       := vbOperDate
                                               , inGoodsId        := vbGoodsId
                                               , inGoodsItemId    := vbGoodsItemId
                                               , inCurrencyId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument())
                                               , inAmount         := inAmount
                                               , inOperPrice      := inOperPrice
                                               , inCountForPrice  := inCountForPrice
                                               , inOperPriceList  := inOperPriceList
                                               , inBrandId        := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Brand())
                                               , inPeriodId       := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Period())
                                               , inPeriodYear     := (SELECT ObF.ValueData FROM ObjectFloat AS ObF WHERE ObF.ObjectId = vbPartnerId AND ObF.DescId = zc_ObjectFloat_Partner_PeriodYear()) :: Integer
                                               , inFabrikaId      := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Fabrika())
                                               , inGoodsGroupId   := inGoodsGroupId
                                               , inMeasureId      := inMeasureId
                                               , inCompositionId  := vbCompositionId
                                               , inGoodsInfoId    := vbGoodsInfoId
                                               , inLineFabricaId  := vbLineFabricaId
                                               , inLabelId        := vbLabelId
                                               , inCompositionGroupId := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbCompositionId AND OL.DescId = zc_ObjectLink_Composition_CompositionGroup())
                                               , inGoodsSizeId    := vbGoodsSizeId
                                               , inJuridicalId    := inJuridicalId
                                               , inUserId         := vbUserId
                                                );

   END IF; -- if COALESCE (ioMovementItemId, 0) = 0  


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
15.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PartionGoods()
