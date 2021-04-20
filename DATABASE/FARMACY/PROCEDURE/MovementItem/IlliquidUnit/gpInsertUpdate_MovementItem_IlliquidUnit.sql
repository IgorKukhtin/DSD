-- Function: gpInsertUpdate_MovementItem_IlliquidUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IlliquidUnit(Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_IlliquidUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementIncomeId Integer;
   DECLARE vbAmountIncome TFloat;
   DECLARE vbAmountOther TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IlliquidUnit());
     vbUserId := inSession;
     
     ioId := lpInsertUpdate_MovementItem_IlliquidUnit(ioId, inMovementId, inGoodsId, inAmount, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_IlliquidUnit (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
