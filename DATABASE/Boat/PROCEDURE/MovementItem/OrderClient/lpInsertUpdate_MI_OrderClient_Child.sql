-- Function: lpInsertUpdate_MI_OrderClient_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , -- 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPartionId           Integer   , -- Комплектующие / Работы/Услуги
    IN inObjectId            Integer   , -- Комплектующие / Работы/Услуги
    IN inGoodsId_Basis       Integer   , -- Комплектующие - какой узел собирается
    IN inGoodsId             Integer   , -- Комплектующие - если была замена, какой узел был в ReceiptProdModel
    IN inAmountBasis         TFloat    , -- Количество 
    IN inAmount              TFloat    , -- Количество резерв
    IN inAmountPartner       TFloat    , -- Количество заказ поставщику
    IN inOperPrice           TFloat    , -- Цена вх без НДС
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inUnitId              Integer   , -- Подразделение - на котором происходит резерв
    IN inPartnerId           Integer   , -- Поставщик - кому уходит заказ поставщика
    IN inColorPatternId      Integer   , -- Шаблон Boat Structure
    IN inProdColorPatternId  Integer   , -- Boat Structure
    IN inProdOptionsId       Integer   , -- Опция
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, inPartionId, inMovementId, inAmount, inParentId, inUserId);

     -- сохранили свойство <AmountBasis>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountBasis(), ioId, inAmountBasis);
     -- сохранили свойство <AmountPartner>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Цена со скидкой>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за кол.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     
     -- сохранили связь с <Комплектующие> - какой узел собирается
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- сохранили связь с <Комплектующие> - если была замена, какой узел был в ReceiptProdModel
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(), ioId, inGoodsId_Basis);
     -- сохранили связь с <Подразделение> - на котором происходит резерв
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <Поставщик> - кому уходит заказ поставщика
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
     -- сохранили связь с <Шаблон Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ColorPattern(), ioId, inColorPatternId);
     -- сохранили связь с <Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdColorPattern(), ioId, inProdColorPatternId);
     -- сохранили связь с <Опция>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdOptions(), ioId, inProdOptionsId);

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
