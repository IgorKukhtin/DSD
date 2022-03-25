-- Function: gpInsertUpdate_MovementItem_PaymentMulti()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer,  Integer, Integer, TFloat, TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PaymentMulti(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIncomeId            Integer   , -- Ключ документа <приходная накладная>
    IN inBankAccountId       Integer   , -- Ключ обьекта <Расчетный счет>
    IN inCurrencyId          Integer   , -- Ключ обьекта <Валюта>
    IN inSummaPay            TFloat    , -- Сумма платежа
    IN inSummaCorrBonus      TFloat    , -- Сумма Корректировки долга по бонусу
    IN inSummaCorrReturnOut  TFloat    , -- Сумма Корректировки долга по возвратам
    IN inSummaCorrOther      TFloat    , -- Сумма Корректировки долга по прочим причинам
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --проверили расчетный счет
    
    IF COALESCE (inId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM  MovementItemFloat 
                WHERE MovementItemFloat.DescId = zc_MIFloat_MovementId()
                  AND MovementItemFloat.MovementItemId in (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = inMovementId)
                  AND MovementItemFloat.ValueData = inIncomeId)
      THEN
        RAISE EXCEPTION 'Ошибка! Приходная накладная <%> уже использована в оплате.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inIncomeId);      
      END IF;
    END IF;
    
    PERFORM lpInsertUpdate_MovementItem_Payment (ioId               := inId
                                            , inMovementId          := inMovementId
                                            , inIncomeId            := inIncomeId
                                            , inBankAccountId       := inBankAccountId
                                            , inCurrencyId          := inCurrencyId
                                            , inSummaPay            := inSummaPay
                                            , inSummaCorrBonus      := inSummaCorrBonus
                                            , inSummaCorrReturnOut  := inSummaCorrReturnOut
                                            , inSummaCorrOther      := inSummaCorrOther
                                            , inSummaCorrPartialPay := 0
                                            , inNeedPay             := TRUE
                                            , inNeedRecalcSumm      := FALSE
                                            , inUserId              := vbUserId
                                             );
    -- PERFORM gpInsertUpdate_MovementItem_Payment(ioId             := inId, -- Ключ объекта <Элемент документа>
                                                -- inMovementId     := inMovementId, -- Ключ объекта <Документ>
                                                -- inIncomeId       := inIncomeId, -- Ключ документа <приходная накладная>
                                                -- ioBankAccountId  := inBankAccountId, -- Ключ обьекта <Расчетный счет>
                                                -- inSummaPay       := inSummaPay, -- Сумма платежа
                                                -- inNeedPay        := TRUE, -- Нужно платить
                                                -- inSession        := inSession-- сессия пользователя
                                            -- );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PaymentMulti (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat,TFloat,TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 07.12.15                                                                         *
*/