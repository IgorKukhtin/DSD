-- Function: gpInsertUpdate_MovementItem_ChangePercent()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChangePercent (integer, integer, integer, tfloat, tfloat, tfloat, integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChangePercent(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
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
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChangePercent());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_ChangePercent (ioId            := ioId
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := inGoodsId
                                                   , inAmount        := inAmount
                                                   , inPrice         := inPrice
                                                   , ioCountForPrice := ioCountForPrice
                                                   , inGoodsKindId   := inGoodsKindId
                                                   , inUserId        := vbUserId
                                                    ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/

-- тест
--