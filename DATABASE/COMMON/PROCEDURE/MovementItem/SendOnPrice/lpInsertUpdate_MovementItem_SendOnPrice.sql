-- Function: gpInsertUpdate_MovementItem_SendOnPrice()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SendOnPrice(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountChangePercent TFloat    , -- Количество c учетом % скидки
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная 

    IN inCount               TFloat    , -- Количество батонов (расход)
    IN inCountPartner        TFloat    , -- Количество батонов(приход)
    
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inUnitId              Integer   , -- Подразделение
    IN inCountPack           TFloat    , -- Количество упаковок (расчет)
    IN inWeightTotal         TFloat    , -- Вес 1 ед. продукции + упаковка
    IN inWeightPack          TFloat    , -- Вес упаковки для 1-ой ед. продукции
    IN inIsBarCode           Boolean   , -- 
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Количество c учетом % скидки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), ioId, inAmountChangePercent);
     -- сохранили свойство <% скидки для кол-ва>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);


     -- сохранили свойство <Количество упаковок (расчет)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- сохранили свойство <Вес 1 ед. продукции + упаковка>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTotal(), ioId, inWeightTotal);
     -- сохранили свойство <Вес упаковки для 1-ой ед. продукции>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightPack);

     -- сохранили свойство <Количество батонов (расход)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- сохранили свойство <Количество батонов (приход)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPartner(), ioId, inCountPartner);
     
     -- сохранили свойство <По сканеру>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);


     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     IF inGoodsId <> 0
     THEN
         -- создали объект <Связи Товары и Виды товаров>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * inPrice AS NUMERIC (16, 2))
                      END;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.08.22         * add inCount, inCountPartner
 13.11.15                                        *
 04.06.15         * add inUnitId
 05.05.14                                                        *
 08.02.14                                        *
 04.02.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
