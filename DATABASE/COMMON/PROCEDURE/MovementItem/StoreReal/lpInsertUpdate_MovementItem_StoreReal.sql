-- Function: lpInsertUpdate_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StoreReal (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StoreReal (Integer, Integer, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_StoreReal(
 INOUT ioId          Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId  Integer   , -- Ключ объекта <Документ>
    IN inGoodsId     Integer   , -- Товары
    IN inAmount      TFloat    , -- Количество
    IN inGoodsKindId Integer   , -- Виды товаров
    IN inUserId      Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
      -- определяется признак Создание/Корректировка
      vbIsInsert:= COALESCE (ioId, 0) = 0;

      -- сохранили <Элемент документа>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

      -- сохранили связь с <Виды товаров>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

      IF inGoodsId <> 0
      THEN
           -- создали объект <Связи Товары и Виды товаров>
           PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
      END IF;

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.03.17         *
 20.03.17                                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_StoreReal (ioId:= 0, inMovementId:= 5285611, inGoodsId:= 1, inAmount:= 0, inGoodsKindId:= 0, inUserId:= 1)
