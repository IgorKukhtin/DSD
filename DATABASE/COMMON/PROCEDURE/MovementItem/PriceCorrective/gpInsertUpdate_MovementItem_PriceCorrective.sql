-- Function: gpInsertUpdate_MovementItem_PriceCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceCorrective (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceCorrective (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PriceCorrective(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена -  на сколько корректируется("+"уменьшается или "-"увеличивается) 
    IN inPriceTax_calc       TFloat    , -- Цена продажи (корр.) - оригинальная, которая корректируется
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PriceCorrective());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_PriceCorrective (ioId      := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inPrice              := inPrice
                                          , inPriceTax_calc      := inPriceTax_calc
                                          , ioCountForPrice      := ioCountForPrice
                                          , inGoodsKindId        := inGoodsKindId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.05.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PriceCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')
