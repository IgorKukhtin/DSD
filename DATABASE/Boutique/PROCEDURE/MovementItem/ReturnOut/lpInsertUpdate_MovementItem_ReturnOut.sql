-- Function: lpInsertUpdate_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товар
    IN inPartionId           Integer   , -- Партия
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inOperPriceList       TFloat    , -- Цена (прайс)
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- сохранили свойство <Цена (прайс)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);
     
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
 10.04.17         *
*/

-- тест
-- 