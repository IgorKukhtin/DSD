-- Function: lpInsertUpdate_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, TFloat, TFloat, TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_Child(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId              Integer   , -- Товары
    IN inAmount               TFloat    , -- Количество
    IN inContainerId          TFloat    , -- 
    IN inPartionGoodsDate     TDateTime , -- Партия товара	
    IN inGoodsKindId          Integer   , -- Виды товаров
    IN inGoodsKindId_complete Integer   , -- Виды товаров
    IN inUserId               Integer     -- пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, NULL);
  
   -- сохранили свойство <ContainerId>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
   
   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindId_complete);

   -- сохранили протокол
   -- !!!что б не росла база!!! PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_OrderInternal_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
