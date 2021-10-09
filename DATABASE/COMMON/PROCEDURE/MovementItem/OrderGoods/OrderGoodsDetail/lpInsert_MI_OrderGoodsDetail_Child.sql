-- Function: lpInsert_MI_OrderGoodsDetail_Child()

DROP FUNCTION IF EXISTS lpInsert_MI_OrderGoodsDetail_Child (Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsert_MI_OrderGoodsDetail_Child(
    IN inId                        Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                Integer   , -- Ключ объекта
    IN inParentId                  Integer   , -- 
    IN inGoodsId                   Integer   , -- Товары
    IN inGoodsKindId               Integer   , 
    IN inAmount                    TFloat    , -- Количество
    IN inUserId                    Integer     -- сессия пользователя                                                
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- Проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Параметр <Товар> не определен.';
     END IF;

     -- сохранили <Элемент документа>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
--