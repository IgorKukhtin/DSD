-- Function: gpInsertUpdate_MovementItem_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TechnicalRediscount(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TechnicalRediscount(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , --
    IN inRemains_Amount      TFloat    , --
   OUT outDiffSumm           TFloat    , --
   OUT outRemains_FactAmount TFloat    , --
   OUT outRemains_FactSumm   TFloat    , --
   OUT outDeficit            TFloat    , --
   OUT outDeficitSumm        TFloat    , --
   OUT outProficit           TFloat    , --
   OUT outProficitSumm       TFloat    , --
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TechnicalRediscount());

     IF ROUND(inRemains_Amount + inAmount, 4) < 0
     THEN
       RAISE EXCEPTION 'Ошибка.Фактическое количество не может быть ментше 0.';
     END IF;

     ioId := lpInsertUpdate_MovementItem_TechnicalRediscount(ioId, inMovementId, inGoodsId, inAmount, vbUserId);

     outDiffSumm           := inAmount * inPrice;
     outRemains_FactAmount := inRemains_Amount + inAmount;
     outRemains_FactSumm   := (inRemains_Amount + inAmount) * inPrice;
     outDeficit            := CASE WHEN inAmount < 0 THEN - inAmount ELSE 0 END;
     outDeficitSumm        := CASE WHEN inAmount < 0 THEN - inAmount * inPrice ELSE 0 END;
     outProficit           := CASE WHEN inAmount > 0 THEN inAmount ELSE 0 END;
     outProficitSumm       := CASE WHEN inAmount > 0 THEN inAmount * inPrice ELSE 0 END;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.02.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_TechnicalRediscount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')