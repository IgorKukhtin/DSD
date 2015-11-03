DROP FUNCTION IF EXISTS lpComplete_Movement_Payment (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Payment(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPaymentDate TDateTime;
BEGIN
    
    --Проверяем, что бы все оплаты соответствовали тем, что в документе
    PERFORM
        gpInsertUpdate_MovementItem_Payment(
                                            ioId             := MI_Payment.Id, -- Ключ объекта <Элемент документа>
                                            inMovementId     := MI_Payment.MovementId, -- Ключ объекта <Документ>
                                            inIncomeId       := MI_Payment.IncomeId, -- Ключ документа <приходная накладная>
                                            ioBankAccountId  := MI_Payment.BankAccountId, -- Ключ документа <Оплата по банку>
                                            ioAccountId      := MI_Payment.AccountId, -- Ключ обьекта <Расчетный счет>
                                            inSummaPay       := MI_Payment.SummaPay    , -- Сумма платежа
                                            inNeedPay        := MI_Payment.NeedPay  , -- Нужно платить
                                            inSession        := inUserId::TVarChar    -- сессия пользователя
                                            )

    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId;



    -- создаются временные таблицы - для формирование данных для проводок
    PERFORM lpComplete_Movement_Finance_CreateTemp();
    -- проводим оплаты
    PERFORM
        lpComplete_Movement_BankAccount (inMovementId := MI_Payment.BankAccountId
                                       , inUserId     := inUserId)
    FROM
        MovementItem_Payment_View AS MI_Payment
    WHERE
        MI_Payment.MovementId = inMovementId
        AND
        MI_Payment.NeedPay = TRUE
        AND
        COALESCE(MI_Payment.BankAccountId,0) > 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 13.10.15                                                                     * 
*/