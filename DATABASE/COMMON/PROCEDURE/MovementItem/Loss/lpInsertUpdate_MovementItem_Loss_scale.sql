-- Function: lpInsertUpdate_MovementItem_Loss_scale() - !!!сделана т.к. для печати из scale нужны цены и суммы!!!

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss_scale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss_scale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loss_scale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Loss_scale(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inPartionGoodsDate    TDateTime , -- Дата партии/Дата перемещения
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Loss (ioId                  := ioId
                                            , inMovementId          := inMovementId
                                            , inGoodsId             := inGoodsId
                                            , inAmount              := inAmount
                                            , inCount               := 0    -- !!!не ошибка, здесь не формируется!!!
                                            , inHeadCount           := 0    -- !!!не ошибка, здесь не формируется!!! 
                                            , inPrice               := inPrice
                                            , inPartionGoodsDate    := inPartionGoodsDate
                                            , inPartionGoods        := inPartionGoods
                                            , inPartNumber          := Null ::TVarChar
                                            , inGoodsKindId         := inGoodsKindId
                                            , inGoodsKindCompleteId := NULL -- !!!не ошибка, здесь не формируется!!!
                                            , inAssetId             := inAssetId
                                            , inPartionGoodsId      := NULL -- !!!не ошибка, здесь не формируется!!! 
                                            , inStorageId           := NULL -- 
                                            , inPartionModelId      := NULL -- 
                                            , inUserId              := inUserId
                                             );

     -- сохранили свойство <Цена>
     --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Loss_scale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
