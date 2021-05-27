-- Function: gpInsertUpdate_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderExternal(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderExternal(Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderExternal(Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMainGoodsId         Integer   , -- Товары
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inPartionGoodsDate    TDateTime , -- Партия товара
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inMainGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <Сумма заказа>
 --    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- сохранили связь с <Товаром из прайса>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     
     -- сохранили связь с <Данные поставщика>
     PERFORM lpInsertUpdate_MovementItemString  (zc_MIString_Maker()        , ioId, Object_Goods_Juridical.MakerName)
           , lpInsertUpdate_MovementItemString  (zc_MIString_GoodsCode()    , ioId, Object_Goods_Juridical.Code)
           , lpInsertUpdate_MovementItemString  (zc_MIString_GoodsName()    , ioId, Object_Goods_Juridical.Name)
     FROM Object_Goods_Juridical
     WHERE Object_Goods_Juridical.ID = inGoodsId;
     

     IF NOT (inPartionGoodsDate IS NULL) THEN 
        -- сохранили свойство <Партия товара>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     END IF;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
 
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.11.14                         *
 01.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderExternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')