-- Function: lpInsertUpdate_MI_SaleCOMDOC()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SaleCOMDOC (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SaleCOMDOC(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId      Integer   , -- Ключ объекта 
    IN inGoodsId             Integer   , -- Товар
    IN inGoodsKindId         Integer   , -- 
    IN inAmountPartner       TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inUserId              Integer     -- пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- Проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У элемента документа нет связи с товаром <EDI>.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (inMovementItemId, 0) = 0;

     IF COALESCE (inMovementItemId, 0) = 0
     THEN 
         -- сохранили <Элемент документа>
         inMovementItemId := lpInsertUpdate_MovementItem (inMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
         -- сохранили связь с <Виды товаров>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inMovementItemId, inGoodsKindId);
         -- сохранили свойство <Цена>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), inMovementItemId, inPrice);
     END IF;

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), inMovementItemId, inAmountPartner);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.14                                        * ALL
 29.05.14                         * 
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_SaleCOMDOC (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
