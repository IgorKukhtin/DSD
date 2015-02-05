-- Function: gpInsertUpdate_MovementItem_SendOnPrice()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendOnPrice_Value(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SendOnPrice_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountChangePercent TFloat    , -- Количество c учетом % скидки
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inPrice               TFloat    , -- Цена
    IN ioCountForPrice       TFloat    , -- Цена за количество
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- сохранили
     SELECT tmp.ioId INTO ioId
     FROM lpInsertUpdate_MovementItem_SendOnPrice
                                           (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= inAmountChangePercent
                                          , inChangePercentAmount:= inChangePercentAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inUserId             := inUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.02.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
