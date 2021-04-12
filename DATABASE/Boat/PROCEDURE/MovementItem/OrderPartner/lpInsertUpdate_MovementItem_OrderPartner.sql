-- Function: gpInsertUpdate_MovementItem_OrderPartner()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderPartner(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderPartner(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Комплектующие
    IN inAmount              TFloat    , -- Количество
 INOUT ioOperPrice           TFloat    , -- Цена со скидкой
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inComment             TVarChar  , 
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbIsInsert Boolean;
    DECLARE vbDiscountTax TFloat;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

/*     vbDiscountTax := (SELECT (COALESCE (MovementFloat_DiscountTax.ValueData,0)
                             + COALESCE (MovementFloat_DiscountNextTax.ValueData,0) ) ::TFloat AS DiscountTax
                       FROM Movement
                           LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                                   ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                                  AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
                           LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                                   ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                                  AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()
                       WHERE Movement.Id = inMovementId
                       );
     -- рассчитываем цену со скидкой
     ioOperPrice := (CASE WHEN COALESCE (vbDiscountTax,0) > 0 THEN zfCalc_SummDiscountTax (inOperPriceList, vbDiscountTax)  ELSE inOperPriceList END );
*/


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- сохранили свойство <Цена со скидкой>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, ioOperPrice);
     -- сохранили свойство <Цена за кол.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     -- 
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

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
 12.04.21         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inGoodsName = '', inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
