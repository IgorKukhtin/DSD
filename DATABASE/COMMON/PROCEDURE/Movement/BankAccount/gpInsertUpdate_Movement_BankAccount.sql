-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount(Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inParentId             Integer   , -- 
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inAmountIn             TFloat    , -- Сумма прихода
    IN inAmountOut            TFloat    , -- Сумма расхода
    IN inAmountSumm           TFloat    , -- Cумма грн, обмен

    IN inBankAccountId        Integer   , -- Расчетный счет
    IN inInvNumberInvoice     TVarChar  , -- Счет(клиента)
    IN inComment              TVarChar  , -- Комментарий
    IN inMoneyPlaceId         Integer   , -- Юр лицо, счет, касса, Ведомости начисления
    IN inPartnerId            Integer   , -- Контрагент
    IN inContractId           Integer   , -- Договора
    IN inInfoMoneyId          Integer   , -- Статьи назначения
    IN inUnitId               Integer   , -- Подразделение
    IN inMovementId_Invoice   Integer   , -- документ счет
    IN inCurrencyId           Integer   , -- Валюта
   OUT outCurrencyValue       TFloat    , -- Курс для перевода в валюту баланса
   OUT outParValue            TFloat    , -- Номинал для перевода в валюту баланса
    IN inCurrencyPartnerValue TFloat    , -- Курс для расчета суммы операции
    IN inParPartnerValue      TFloat    , -- Номинал для расчета суммы операции
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountCurrency TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());

     -- проверка
     IF COALESCE (inAmountIn, 0) = 0 AND COALESCE (inAmountOut, 0) = 0 -- AND COALESCE (inCurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis()
     THEN
        RAISE EXCEPTION 'Ошибка.Введите сумму прихода или расхода';
     END IF;
     -- проверка
     IF COALESCE (inAmountIn, 0) <> 0 AND COALESCE (inAmountOut, 0) <> 0 -- AND COALESCE (inCurrencyId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis()
     THEN
        RAISE EXCEPTION 'Ошибка.Должна быть введена только одна сумма - или <Приход> или <Расход>.';
     END IF;


     -- расчет курса для баланса
     IF inCurrencyId <> zc_Enum_Currency_Basis()
     THEN SELECT Amount, ParValue, Amount, ParValue
                 INTO outCurrencyValue, outParValue
                    , inCurrencyPartnerValue, inParPartnerValue -- !!!меняется значение!!!
          FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDate, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyId,  inPaidKindId:= zc_Enum_PaidKind_FirstForm());
     END IF;

     -- !!!очень важный расчет!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN vbAmountCurrency:= inAmountIn;
             vbAmount := CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2));
        ELSE vbAmount := inAmountIn;
        END IF;
     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN vbAmountCurrency:= -1 * inAmountOut;
             vbAmount := CAST (-1 * inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2));
        ELSE vbAmount := -1 * inAmountOut;
        END IF;
     END IF;

     -- проверка
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма пересчета из валюты <%> в валюту <%> не должна быть = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_BankAccount (ioId                   := ioId
                                               , inInvNumber            := inInvNumber
                                               , inOperDate             := inOperDate
                                               , inServiceDate          := inServiceDate
                                               , inAmount               := vbAmount
                                               , inAmountSumm           := inAmountSumm
                                               , inAmountCurrency       := vbAmountCurrency
                                               , inBankAccountId        := inBankAccountId
                                               , inComment              := inComment
                                               , inMoneyPlaceId         := inMoneyPlaceId
                                               , inPartnerId            := inPartnerId
                                               , inContractId           := inContractId
                                               , inInfoMoneyId          := inInfoMoneyId
                                               , inUnitId               := inUnitId
                                               , inMovementId_Invoice   := inMovementId_Invoice
                                               , inCurrencyId           := inCurrencyId
                                               , inCurrencyValue        := outCurrencyValue
                                               , inParValue             := outParValue
                                               , inCurrencyPartnerValue := inCurrencyPartnerValue
                                               , inParPartnerValue      := inParPartnerValue
                                               , inParentId             := inParentId -- (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId)
                                               , inBankAccountPartnerId := (SELECT MovementItemLinkObject.ObjectId FROM MovementItem 
                                                                             INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id  AND MovementItemLinkObject.DescId = zc_MILinkObject_BankAccount()
                                                                            WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master())
                                               , inUserId               := vbUserId
                                                );


     -- Счет(клиента)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), ioId, inInvNumberInvoice);

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount())
     THEN
          PERFORM lpComplete_Movement_BankAccount (inMovementId := ioId
                                                 , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.07.24         *
 18.09.18         *
 21.07.15         *
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 11.05.14                                        * add ioId:=
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 04.04.14                                        * add lpComplete_Movement_BankAccount
 13.03.14                                        * add vbUserId
 13.03.14                                        * err inParentId NOT NULL
 06.12.13                          *
 09.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
