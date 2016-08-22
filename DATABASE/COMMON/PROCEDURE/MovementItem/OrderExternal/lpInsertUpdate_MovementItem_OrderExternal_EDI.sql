 -- Function: lpInsertUpdate_MovementItem_OrderExternal_EDI()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderExternal_EDI (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderExternal_EDI(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementItemId_EDI  Integer   , -- 
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountSecond        TFloat    , -- Количество дозаказ
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbPrice TFloat;
   DECLARE vbCountForPrice TFloat;
BEGIN

     -- сохранили
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice
            INTO vbId, vbPrice, vbCountForPrice
     FROM lpInsertUpdate_MovementItem_OrderExternal (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := inAmount
                                                   , inAmountSecond       := inAmountSecond
                                                   , inGoodsKindId        := inGoodsKindId
                                                   , ioPrice              := inPrice
                                                   , ioCountForPrice      := inCountForPrice
                                                   , inUserId             := inUserId
                                                    ) AS tmp;
     -- сохранили
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), inMovementItemId_EDI, vbPrice);
     -- сохранили
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inMovementItemId_EDI, vbCountForPrice);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceEDI(), vbId, COALESCE ((SELECT MovementItemFloat.ValueData FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId = inMovementItemId_EDI AND MovementItemFloat.DescId = zc_MIFloat_Price()), 0));


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.12.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_OrderExternal_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
