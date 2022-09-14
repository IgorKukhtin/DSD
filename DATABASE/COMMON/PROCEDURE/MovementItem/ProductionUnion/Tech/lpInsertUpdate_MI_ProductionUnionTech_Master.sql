-- Function: lpInsertUpdate_MI_ProductionUnionTech_Master()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnionTech_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inCount	             TFloat    , -- Количество батонов или упаковок 
    IN inCountReal           TFloat    , -- Количество шт. факт только для схемы "Тушенка"
    IN inRealWeight          TFloat    , -- Фактический вес(информативно)
    IN inRealWeightMsg       TFloat    , -- Фактический вес(после массажера)
    IN inRealWeightShp       TFloat    , -- Фактический вес(после шприцевания)
    IN inCuterCount          TFloat    , -- Количество кутеров
    IN inComment             TVarChar  , -- Примечание
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inReceiptId           Integer   , -- Рецептуры
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
BEGIN
   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

   -- сохранили связь с <Рецептуры>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, inReceiptId);
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Виды товаров ГП>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   -- сохранили свойство <партия закрыта (да/нет)>
   -- PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_PartionClose(), ioId, inPartionClose);

   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

   -- сохранили свойство <Количество батонов>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

   -- сохранили свойство <Количество шт. факт только для схемы "Тушенка">
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountReal(), ioId, inCountReal);

   -- сохранили свойство <Фактический вес(информативно)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- сохранили свойство <Количество кутеров>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), ioId, inCuterCount);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightMsg(), ioId, inRealWeightMsg);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightShp(), ioId, inRealWeightShp);

   IF vbIsInsert = TRUE
   THEN
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   ELSE
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
   END IF;

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
 13.09.22         * inCountReal
 02.12.20         *
 21.03.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnionTech_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
