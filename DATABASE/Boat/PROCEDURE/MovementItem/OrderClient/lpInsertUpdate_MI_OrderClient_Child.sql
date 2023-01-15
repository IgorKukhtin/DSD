-- Function: lpInsertUpdate_MI_OrderClient_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inObjectId            Integer   , -- Комплектующие / Работы/Услуги
    IN inGoodsId_Basis       Integer   , -- Комплектующие - если была замена, какой узел был в ReceiptProdModel
    IN inReceiptGoodsId      Integer   , -- шаблон сборки узла
    IN inAmount              TFloat    , -- Количество резерв
    IN inAmountPartner       TFloat    , -- Количество заказ поставщику
    IN inForCount            TFloat    , -- Для кол-во
    IN inOperPrice           TFloat    , -- Цена вх без НДС
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inPartnerId           Integer   , -- Поставщик - кому уходит заказ поставщика
    IN inProdOptionsId       Integer   , -- Опция
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN

     -- Проверка - 
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                      ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Detail()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MILinkObject_GoodsBasis.ObjectId, 0) = inGoodsId_Basis
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент узел %<%>%уже был добавлен для %<%>.'
             , CHR (13)
             , lfGet_Object_ValueData (inObjectId)
             , CHR (13)
             , lfGet_Object_ValueData (inGoodsId_Basis)
             , CHR (13)
               ;
               
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, NULL, inMovementId, inAmount, NULL, inUserId);

     -- сохранили свойство <Для кол-во>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ForCount(), ioId, CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END);
     -- сохранили свойство <AmountPartner>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Цена со скидкой>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за кол.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     -- сохранили связь с <Шаблон сборки узла>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptGoods(), ioId, inReceiptGoodsId);
     
     -- сохранили связь с <Комплектующие> - если была замена, какой узел был в ReceiptProdModel
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(), ioId, inGoodsId_Basis);
     -- сохранили связь с <Поставщик> - кому уходит заказ поставщика
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
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
