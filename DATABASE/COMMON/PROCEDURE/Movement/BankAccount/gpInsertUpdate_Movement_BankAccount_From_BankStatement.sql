-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount_From_BankStatement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount_From_BankStatement(
 INOUT inMovementId          Integer   , -- Ключ объекта <Документ> BankStatement
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount_From_BankS());
/*
if inMovementId = 15504781
then
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
         -- Ставим статус у элементов документа выписки
         PERFORM lpUnComplete_Movement (inMovementId := Movement.Id
                                       , inUserId     := vbUserId)
         FROM Movement
         WHERE ParentId = inMovementId AND DescId = zc_Movement_BankStatementItem();
end if;
*/

     -- проверка
     /*IF EXISTS (SELECT 1
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                                  ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                                 AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
                     INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId
                                                     AND Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                     LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                                    ON MLM_Invoice.MovementId = Movement.Id
                                                   AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                WHERE Movement.DescId = zc_Movement_BankStatementItem()
                  AND Movement.ParentId = inMovementId
                  AND MLM_Invoice.MovementChildId IS NULL
               )
     THEN
        RAISE EXCEPTION 'Ошибка.Для УП статьи <%> необходимо заполнить значение <№ док. Счет>.'
            , lfGet_Object_ValueData
              ((SELECT MovementLinkObject_InfoMoney.ObjectId
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                                  ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                                 AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
                     INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MovementLinkObject_InfoMoney.ObjectId
                                                     AND Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                     LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                                    ON MLM_Invoice.MovementId = Movement.Id
                                                   AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                WHERE Movement.DescId = zc_Movement_BankStatementItem()
                  AND Movement.ParentId = inMovementId
                  AND MLM_Invoice.MovementChildId IS NULL
                LIMIT 1
               ));
     END IF;*/

     -- распроводим Документы
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_BankAccount())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := Movement_BankAccount.Id
                                      , inUserId     := vbUserId)
         FROM Movement
              JOIN Movement AS Movement_BankAccount
                            ON Movement_BankAccount.ParentId = Movement.Id
                           AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                           AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()
         WHERE Movement.DescId = zc_Movement_BankStatementItem()
           AND Movement.ParentId = inMovementId;
     END IF;


     -- Выбираем все данные и сразу вызываем процедуры
     PERFORM lpInsertUpdate_Movement_BankAccount(ioId                   := COALESCE (Movement_BankAccount.Id, 0)
                                               , inInvNumber            := Movement.InvNumber
                                               , inOperDate             := Movement.OperDate
                                               , inServiceDate          := MovementDate_ServiceDate.ValueData
                                               , inAmount               := MovementFloat_Amount.ValueData
                                               , inAmountSumm           := MovementFloat_Amount_BankAccount.ValueData -- !!!значение при перезаливки не меняется!!!
                                               , inAmountCurrency       := MovementFloat_AmountCurrency.ValueData
                                               , inBankAccountId        := MovementLinkObject_BankAccount.ObjectId
                                               , inComment              := MovementString_Comment.ValueData
                                               , inMoneyPlaceId         := MovementLinkObject_Juridical.ObjectId
                                               , inContractId           := MovementLinkObject_Contract.ObjectId
                                               , inInfoMoneyId          := MovementLinkObject_InfoMoney.ObjectId
                                               , inUnitId               := MovementLinkObject_Unit.ObjectId
                                               , inMovementId_Invoice   := MLM_Invoice.MovementChildId          -- док.счет
                                               , inCurrencyId           := MovementLinkObject_Currency.ObjectId
                                               , inCurrencyValue        := MovementFloat_CurrencyValue.ValueData
                                               , inParValue             := MovementFloat_ParValue.ValueData
                                               , inCurrencyPartnerValue := MovementFloat_CurrencyPartnerValue.ValueData
                                               , inParPartnerValue      := MovementFloat_ParPartnerValue.ValueData
                                               , inParentId             := Movement.Id
                                               , inBankAccountPartnerId := lpInsertFind_BankAccount (MovementString_BankAccount.ValueData, MovementString_BankMFO.ValueData, MovementString_BankName.ValueData, MovementLinkObject_Juridical.ObjectId, vbUserId)
                                               , inUserId               := vbUserId
                                                )
       FROM Movement
            LEFT JOIN Movement AS Movement_BankAccount 
                               ON Movement_BankAccount.ParentId = Movement.Id
                              AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                              AND Movement_BankAccount.StatusId = zc_Enum_Status_UnComplete()

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.ParentId
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()

            LEFT JOIN MovementString AS MovementString_BankAccount
                                     ON MovementString_BankAccount.MovementId =  Movement.Id
                                    AND MovementString_BankAccount.DescId = zc_MovementString_BankAccount()

            LEFT JOIN MovementString AS MovementString_BankMFO
                                     ON MovementString_BankMFO.MovementId =  Movement.Id
                                    AND MovementString_BankMFO.DescId = zc_MovementString_BankMFO()

            LEFT JOIN MovementString AS MovementString_BankName
                                     ON MovementString_BankName.MovementId =  Movement.Id
                                    AND MovementString_BankName.DescId = zc_MovementString_BankName()

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId     = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                         ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                        AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Currency
                                         ON MovementLinkObject_Currency.MovementId = Movement.Id
                                        AND MovementLinkObject_Currency.DescId = zc_MovementLinkObject_Currency()
          
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
 
            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
           
            -- !!!значение при перезаливки не меняется!!!
            LEFT JOIN MovementFloat AS MovementFloat_Amount_BankAccount
                                    ON MovementFloat_Amount_BankAccount.MovementId = Movement_BankAccount.Id
                                   AND MovementFloat_Amount_BankAccount.DescId = zc_MovementFloat_Amount()

       WHERE Movement.DescId = zc_Movement_BankStatementItem()
         AND Movement.ParentId = inMovementId;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документы
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_BankAccount())
     THEN
         PERFORM lpComplete_Movement_BankAccount (inMovementId := Movement_BankAccount.Id
                                                , inUserId     := vbUserId)
         FROM Movement
             JOIN Movement AS Movement_BankAccount
                           ON Movement_BankAccount.ParentId = Movement.Id
                          AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                          AND Movement_BankAccount.StatusId = zc_Enum_Status_UnComplete()
             JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id AND MovementItem.DescId = zc_MI_Master()
             JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                         AND MILinkObject_MoneyPlace.ObjectId > 0
         WHERE Movement.DescId = zc_Movement_BankStatementItem()
           AND Movement.ParentId = inMovementId;
     END IF;

     -- Ставим статус у документа выписки
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_BankStatement()
                                , inUserId     := vbUserId);
     -- Ставим статус у элементов документа выписки
     PERFORM lpComplete_Movement (inMovementId := Movement.Id
                                , inDescId     := zc_Movement_BankStatementItem()
                                , inUserId     := vbUserId)
     FROM Movement
     WHERE ParentId = inMovementId AND DescId = zc_Movement_BankStatementItem();


if vbUserId = 5 OR  inMovementId = 15504781
then
    RAISE EXCEPTION 'vbUserId = 5';
    -- 'Повторите действие через 3 мин.'
/*
if vb1 < 0 and exists (select 1 from MovementItem as MI_Child where MI_Child.MovementId = inMovementId
                                               AND MI_Child.DescId = zc_MI_Child()
                                               --AND MI_Child.isErased = FALSE
                                             )
then
    RAISE EXCEPTION 'test2';
    -- 'Повторите действие через 3 мин.'
end if;
*/
end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.07.16         *
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement (... inDescId ...)
 10.05.14                                        * add lpComplete_Movement
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 18.03.14                                        * add Ставим статус у элементов документа выписки
 23.01.14                        *  меняем статус после загрузки
 22.01.14                                        * add IsMaster
 16.01.13                                        * add lpComplete_Movement_BankAccount
 06.12.13                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
