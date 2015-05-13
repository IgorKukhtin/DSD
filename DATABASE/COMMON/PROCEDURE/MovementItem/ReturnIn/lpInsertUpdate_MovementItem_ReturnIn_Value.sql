-- Function: lpInsertUpdate_MovementItem_ReturnIn_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inPrice               TFloat    , -- Цена
    IN ioCountForPrice       TFloat    , -- Цена за количество
    IN inHeadCount           TFloat    , -- Количество голов
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- сохранили <Элемент документа>
     SELECT tmp.ioId INTO ioId
     FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := inAmount
                                              , inAmountPartner      := inAmountPartner
                                              , inPrice              := inPrice
                                              , ioCountForPrice      := ioCountForPrice
                                              , inHeadCount          := inHeadCount
                                              , inMovementId_Partion := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_MovementId()), 0) :: Integer
                                              , inPartionGoods       := inPartionGoods
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , inUserId             := inUserId
                                               ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 04.02.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
