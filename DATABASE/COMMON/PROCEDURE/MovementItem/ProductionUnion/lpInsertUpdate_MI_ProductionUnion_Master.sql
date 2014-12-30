-- Function: lpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TVarChar,TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TVarChar,TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionClose	     Boolean   , -- партия закрыта (да/нет)
    IN inCount	             TFloat    , -- Количество батонов или упаковок
    IN inRealWeight          TFloat    , -- Фактический вес(информативно)
    IN inCuterCount          TFloat    , -- Количество кутеров
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inComment             TVarChar  , -- Комментарий
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inReceiptId           Integer   , -- Рецептуры
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
  DECLARE vbIsInsert Boolean;

BEGIN

   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   -- сохранили связь с <Рецептуры>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioId, inReceiptId);

   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Виды товаров ГП>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   -- сохранили свойство <партия закрыта (да/нет)>
   PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_PartionClose(), ioId, inPartionClose);

   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_PartionGoods(), ioId, inPartionGoods);

   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
   -- сохранили свойство <Количество батонов или упаковок>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount);
   -- сохранили свойство <Фактический вес(информативно)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- сохранили свойство <Количество кутеров>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_CuterCount(), ioId, inCuterCount);


   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 11.12.14         * из gp

*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
