-- Function: lpInsertUpdate_MovementItem_OrderGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество кг
    IN inAmountSecond        TFloat    , -- Количество шт
    IN inPrice               TFloat    , --
    IN inComment             TVarChar  , -- 
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbId_child Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не определен.';
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     --проверка если изменяют вид товара или кол-во сохраняем zc_MI_Child
     IF vbIsInsert = FALSE
     THEN
         vbAmount := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.DescId = zc_MI_Master());
         --vbGoodsKindId := (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKind());

         IF COALESCE (vbAmount,0) <> COALESCE (inAmount,0) --OR COALESCE (vbGoodsKindId,0) <> COALESCE (inGoodsKindId,0)
         THEN
             -- сохранили новую строку
             vbId_child := lpInsertUpdate_MovementItem (0, zc_MI_Child(), inUserId, inMovementId, vbAmount, ioId);
             -- сохранили связь с <Виды товаров>
             --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbId_child, vbGoodsKindId);
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_child, CURRENT_TIMESTAMP);
         END IF;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили связь с <Виды товаров>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


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
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderGoods (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 
 08.06.21         *
*/

-- тест
--