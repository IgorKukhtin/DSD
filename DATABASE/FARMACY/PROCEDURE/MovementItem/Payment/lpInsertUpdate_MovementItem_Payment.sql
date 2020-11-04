-- Function: lpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIncomeId            Integer   , -- Ключ документа <приходная накладная>
    IN inBankAccountId       Integer   , -- Ключ обьекта <Расчетный счет>
    IN inCurrencyId          Integer   , -- Ключ обьекта <Валюта>
    IN inSummaPay            TFloat    , -- Сумма платежа
    IN inSummaCorrBonus      TFloat    , -- Сумма Корректировки долга по бонусу
    IN inSummaCorrReturnOut  TFloat    , -- Сумма Корректировки долга по возвратам
    IN inSummaCorrOther      TFloat    , -- Сумма Корректировки долга по прочим причинам
    IN inNeedPay             Boolean   , -- Нужно платить
    IN inisPartialPay        Boolean = FALSE , -- Частичная оплата
    IN inNeedRecalcSumm      Boolean = TRUE  , --Пересчитать суммы
    IN inUserId              Integer = 0 -- пользователь
)
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbBankAccountInvNumber TVarChar;
   DECLARE vbBankAccountOperDate TDateTime;
   DECLARE vbBankAccountJuridicalId Integer;
   DECLARE vbBankAccountContractId Integer;
   DECLARE vbChildId Integer;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), NULL, inMovementId, inSummaPay, NULL);
    --сохранили связь с документом <приходная накладная>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inIncomeId::TFloat);
    --сохранили свойство <корректировка по бонусу>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CorrBonus(), ioId, inSummaCorrBonus);
    --сохранили свойство <корректировка по Возвратам>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CorrReturnOut(), ioId, inSummaCorrReturnOut);
    --сохранили свойство <корректировка по прочим причинам>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CorrOther(), ioId, inSummaCorrOther);
    --сохранили связь с объектом <Расчетный счет>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankAccount(), ioId, inBankAccountId);
    --сохранили связь с объектом <Валюта>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), ioId, inCurrencyId);
    --Сохранили свойство <Нужно платить>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_NeedPay(), ioId, inNeedPay);
    --Сохранили свойство <Частичная оплата>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartialPay(), ioId, inisPartialPay);
    
    IF inNeedRecalcSumm 
    THEN
      --Пересчитали суммы по документу
      PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);
    END IF;  

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 13.10.15                                                                       *
 */