-- Function: gpInsertUpdate_MovementItem_Payment()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer,  Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Payment(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inIncomeId            Integer   , -- Ключ документа <приходная накладная>
 INOUT ioBankAccountId       Integer   , -- Ключ обьекта <Расчетный счет>
   OUT outBankAccountName    TVarChar  , -- название обьекта <Расчетный счет>
   OUT outBankName           TVarChar  , -- Наименование банка
    IN inSummaPay            TFloat    , -- Сумма платежа
    IN inNeedPay             Boolean   , -- Нужно платить
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCurrencyId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Payment());
    vbUserId := inSession;
    --проверили расчетный счет
    SELECT
        Object_BankAccount.Id
       ,Object_BankAccount.Name
       ,Object_BankAccount.BankName
       ,Object_BankAccount.CurrencyId
    INTO
       ioBankAccountId
      ,outBankAccountName
      ,outBankName
      ,vbCurrencyId
    FROM
        Object_BankAccount_View AS Object_BankAccount
    WHERE
        (
            Object_BankAccount.Id = COALESCE(ioBankAccountId,0)
            or
            COALESCE(ioBankAccountId,0) = 0
        )
        AND
        JuridicalId = (Select Movement_Payment_View.JuridicalId from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);

    IF COALESCE(ioBankAccountId) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Для юрлица <%> не создано ни одного расчетного счета',(Select Movement_Payment_View.JuridicalName from Movement_Payment_View Where Movement_Payment_View.Id = inMovementId);
    END IF;
    -- сохранили

    ioId := lpInsertUpdate_MovementItem_Payment (ioId              := ioId
                                            , inMovementId         := inMovementId
                                            , inIncomeId           := inIncomeId
                                            , inBankAccountId      := ioBankAccountId
                                            , inCurrencyId         := vbCurrencyId
                                            , inSummaPay           := inSummaPay
                                            , inNeedPay            := inNeedPay
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Payment (Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 13.10.15                                                                         *
*/