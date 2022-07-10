-- Function: lpInsertUpdate_MI_OrderExternal_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderExternal_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderExternal_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа> 
    IN inParentId            Integer   , -- Ключ объекта
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество резерв с остатка или с прихода 
    IN inAmountRemains       TFloat    , -- Количество остаток расч. 
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inMovementId_Send     Integer   , -- № документа приход
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
 BEGIN
 
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

     -- сохранили свойство <MovementId>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, COALESCE (inMovementId_Send, 0));

     -- сохранили свойство <Количество остаток расч.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), ioId, inAmountRemains);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


     IF 1=0 AND (inUserId = 9457 OR inUserId = 5)
     THEN
         RAISE EXCEPTION 'Ошибка.Админ ничего не меняет';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.22         *
*/

-- тест
--