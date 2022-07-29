-- Function: lpInsertUpdate_MI_OrderClient_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Reserv (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Reserv(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , -- 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPartionId           Integer   , -- Партия
    IN inObjectId            Integer   , -- Комплектующие
    IN inAmount              TFloat    , -- Количество резерв
    IN inOperPrice           TFloat    , -- Цена вх без НДС
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inUnitId              Integer   , -- Подразделение - на котором происходит резерв
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- проверка - ParentId
     IF COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Главный элемент>.';
     END IF;
     -- проверка - PartionId
     IF COALESCE (inPartionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Партия>.';
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Reserv(), inObjectId, inPartionId, inMovementId, inAmount, inParentId, inUserId);

     -- сохранили свойство <Цена со скидкой>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за кол.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     -- сохранили связь с <Подразделение> - на котором происходит резерв
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.21         *
 05.04.21         * inOperPriceList
 15.02.21         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_OrderClient_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inGoodsName = '', inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
