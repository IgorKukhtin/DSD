-- Function: gpInsertUpdate_MovementItem_IncomeFuel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeFuel (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_IncomeFuel(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := inSession;

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- сохранили <Элемент документа> и вернули параметры
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_IncomeFuel (ioId            := ioId
                                                , inMovementId    := inMovementId
                                                , inGoodsId       := inGoodsId
                                                , inAmount        := inAmount
                                                , inPrice         := inPrice
                                                , ioCountForPrice := ioCountForPrice
                                                , inUserId        := vbUserId
                                                 ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        * add lfCheck_Movement_Parent
 04.10.13                                        * lpInsertUpdate_MovementItem_IncomeFuel
 29.09.13                                        * add zc_MIFloat_AmountPartner and recalc inCountForPrice
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_IncomeFuel (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
