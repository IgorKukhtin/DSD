-- Function: lpInsertUpdate_MI_OrderClient_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Detail(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inObjectId            Integer   , -- Комплектующие / Работы/Услуги / Boat Structure
    IN inGoodsId             Integer   , -- Комплектующие - узел
    IN inGoodsId_basis       Integer   , -- Комплектующие - Первоначальный Узел
    IN inAmount              TFloat    , -- Количество для сборки Узла
    IN inAmountPartner       TFloat    , -- Количество заказ поставщику
    IN inForCount            TFloat    , -- Для кол-во
    IN inOperPrice           TFloat    , -- Цена вх без НДС
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inPartnerId           Integer   , -- Поставщик - кому уходит заказ поставщика
    IN inProdOptionsId       Integer   , -- Опция
    IN inColorPatternId      Integer   , -- Шаблон Boat Structure
    IN inProdColorPatternId  Integer   , -- Boat Structure
    IN inReceiptLevelId      Integer   , -- ReceiptLevel
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
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                      ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                     -- какой Узел собирается 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                     -- какой "Виртуальный" Узел собирается 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                      ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                     -- ReceiptLevel
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                      ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Detail()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.ObjectId   = inObjectId
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
                  AND COALESCE (MILinkObject_ProdColorPattern.ObjectId, 0) = inProdColorPatternId
                  AND COALESCE (MILinkObject_Goods.ObjectId, 0)            = inGoodsId
                  AND COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)       = inGoodsId_basis
                  AND COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)     = inReceiptLevelId
               )
      --AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент Сборки узла уже существует %<%> %<%> %<%> %<%> %<%>.'
             , CHR (13)
             , lfGet_Object_ValueData (inObjectId)
             , CHR (13)
             , lfGet_Object_ValueData (inGoodsId)
             , CHR (13)
             , lfGet_Object_ValueData (inGoodsId_basis)
             , CHR (13)
             , lfGet_Object_ValueData (inReceiptLevelId)
             , CHR (13)
             , lfGet_Object_ValueData_pcp (inProdColorPatternId)
              ;
     END IF;
     

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inObjectId, NULL, inMovementId, inAmount, NULL, inUserId);

     -- сохранили свойство <Для кол-во>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ForCount(), ioId, CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END);
     -- сохранили свойство <AmountPartner>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Цена со скидкой>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- сохранили свойство <Цена за кол.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     
     -- сохранили связь с <Комплектующие - какой Узел собирается>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- сохранили связь с <Комплектующие - какой "Виртуальный" Узел собирается>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(), ioId, inGoodsId_basis);
     -- сохранили связь с <Этап сборки>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptLevel(), ioId, inReceiptLevelId);

     
     -- сохранили связь с <Поставщик> - кому уходит заказ поставщика
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
     -- сохранили связь с <Опция>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdOptions(), ioId, inProdOptionsId);
     -- сохранили связь с <Шаблон Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ColorPattern(), ioId, inColorPatternId);
     -- сохранили связь с <Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdColorPattern(), ioId, inProdColorPatternId);


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
