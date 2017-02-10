-- Function: lpInsertUpdate_MI_ProductionUnionTech_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnionTech_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inParentId            Integer   , -- Главный элемент документа
    IN inAmountReceipt       TFloat    , -- Количество по рецептуре на 1 кутер 
    IN inPartionGoodsDate    TDateTime , -- Партия товара
    IN inComment             TVarChar  , -- Примечание
    IN inGoodsKindId         Integer   , -- Виды товаров  
    IN inGoodsKindCompleteId Integer   , -- Виды товаров ГП           
    IN inUserId              Integer     -- пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;

BEGIN
   -- меняем параметр
   IF (inPartionGoodsDate <= '01.01.1900') OR COALESCE (inGoodsKindId, 0) <> zc_GoodsKind_WorkProgress() THEN inPartionGoodsDate:= NULL; END IF;

   -- проверка
   IF COALESCE (inGoodsId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Название (расход)> не установлено.';
   END IF;

   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
   -- сохранили свойство <Количество по рецептуре на 1 кутер>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReceipt(), ioId, inAmountReceipt);
   
   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили связь с <Виды товаров ГП>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.03.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnionTech_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
