-- Function: lpUpdate_MovementItem_OrderExternal()

--DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_OrderExternal(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAmount              TFloat    , -- 
    IN inAmountRemains       TFloat    , -- 
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID AS--RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   --DECLARE vbinId Integer;   
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- сохранили <Элемент документа>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), inId, inAmountRemains);


     IF vbIsInsert = True                    -- если новая строка
     THEN
         -- сохранили свойство <Цена за количество>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, 1);
     END IF;

     IF inGoodsId <> 0
     THEN
         -- создали объект <Связи Товары и Виды товаров>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;
    
        -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.15         *
*/

-- тест
-- SELECT * FROM lpUpdate_MovementItem_OrderExternal (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
