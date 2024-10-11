 -- Function: gpInsertUpdate_Movement_BankAccount_From_BankStatement ()

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
                                               , inInvNumber            := tmpBankStatementItem.InvNumber
                                               , inOperDate             := tmpBankStatementItem.OperDate
                                               , inServiceDate          := tmpBankStatementItem.ServiceDate
                                               , inAmount               := tmpBankStatementItem.Amount
                                               , inAmountSumm           := tmpBankStatementItem.AmountSumm
                                               , inAmountCurrency       := tmpBankStatementItem.AmountCurrency
                                               , inBankAccountId        := tmpBankStatementItem.BankAccountId
                                               , inComment              := tmpBankStatementItem.Comment
                                               , inMoneyPlaceId         := tmpBankStatementItem.MoneyPlaceId
                                               , inPartnerId            := tmpBankStatementItem.PartnerId
                                               , inContractId           := tmpBankStatementItem.ContractId
                                               , inInfoMoneyId          := tmpBankStatementItem.InfoMoneyId
                                               , inUnitId               := tmpBankStatementItem.UnitId
                                               , inMovementId_Invoice   := tmpBankStatementItem.MovementId_Invoice
                                               , inCurrencyId           := tmpBankStatementItem.CurrencyId
                                               , inCurrencyValue        := tmpBankStatementItem.CurrencyValue
                                               , inParValue             := tmpBankStatementItem.ParValue
                                               , inCurrencyPartnerValue := tmpBankStatementItem.CurrencyPartnerValue
                                               , inParPartnerValue      := tmpBankStatementItem.ParPartnerValue
                                               , inParentId             := tmpBankStatementItem.MovementId
                                               , inBankAccountPartnerId := lpInsertFind_BankAccount (tmpBankStatementItem.BankAccountName, tmpBankStatementItem.BankMFO, tmpBankStatementItem.BankName, tmpBankStatementItem.MoneyPlaceId, vbUserId)
                                               , inUserId               := vbUserId
                                                )
       FROM (WITH tmpBankStatementItem_all AS (SELECT Movement.Id AS MovementId
                                                    , Movement.InvNumber
                                                    , Movement.OperDate
                                                    , MovementDate_ServiceDate.ValueData           AS ServiceDate
                                                    , MovementFloat_Amount.ValueData               AS Amount
                                                    , MovementFloat_Amount_BankAccount.ValueData   AS AmountSumm -- !!!значение при перезаливки не меняется!!!
                                                    , MovementFloat_AmountCurrency.ValueData       AS AmountCurrency
                                                    , MovementLinkObject_BankAccount.ObjectId      AS BankAccountId
                                                    , MovementString_Comment.ValueData             AS Comment
                                                    , MovementLinkObject_Juridical.ObjectId        AS MoneyPlaceId
                                                    , MovementLinkObject_Partner.ObjectId          AS PartnerId
                                                    , MovementLinkObject_Contract.ObjectId         AS ContractId
                                                    , MovementLinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                                                    , MovementLinkObject_Unit.ObjectId             AS UnitId
                                                    , MLM_Invoice.MovementChildId                  AS MovementId_Invoice          -- док.счет
                                                    , MovementLinkObject_Currency.ObjectId         AS CurrencyId
                                                    , MovementFloat_CurrencyValue.ValueData        AS CurrencyValue
                                                    , MovementFloat_ParValue.ValueData             AS ParValue
                                                    , MovementFloat_CurrencyPartnerValue.ValueData AS CurrencyPartnerValue
                                                    , MovementFloat_ParPartnerValue.ValueData      AS ParPartnerValue
                                                    , MovementString_BankAccount.ValueData         AS BankAccountName
                                                    , MovementString_BankMFO.ValueData             AS BankMFO
                                                    , MovementString_BankName.ValueData            AS BankName
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
 
                                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                                  ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                                                 AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()

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
                                                  AND Movement.ParentId = inMovementId
                                               )
             -- Результат
             SELECT tmpBankStatementItem_all.MovementId
                  , tmpBankStatementItem_all.InvNumber
                  , tmpBankStatementItem_all.OperDate
                  , tmpBankStatementItem_all.ServiceDate
                  , tmpBankStatementItem_all.Amount
                    -- !!!значение при перезаливки не меняется!!!
                  , tmpBankStatementItem_all.AmountSumm
                    --
                  , tmpBankStatementItem_all.AmountCurrency
                  , tmpBankStatementItem_all.BankAccountId
                  , tmpBankStatementItem_all.Comment
                  , tmpBankStatementItem_all.MoneyPlaceId 
                  , tmpBankStatementItem_all.PartnerId
                  , tmpBankStatementItem_all.ContractId
                  , tmpBankStatementItem_all.InfoMoneyId
                  , tmpBankStatementItem_all.UnitId
                    -- док.счет
                  , tmpBankStatementItem_all.MovementId_Invoice
                    --
                  , tmpBankStatementItem_all.CurrencyId
                  , tmpBankStatementItem_all.CurrencyValue
                  , tmpBankStatementItem_all.ParValue
                  , tmpBankStatementItem_all.CurrencyPartnerValue
                  , tmpBankStatementItem_all.ParPartnerValue
                  , tmpBankStatementItem_all.BankAccountName
                  , tmpBankStatementItem_all.BankMFO
                  , tmpBankStatementItem_all.BankName
             FROM tmpBankStatementItem_all
                  LEFT JOIN Object ON Object.Id     = tmpBankStatementItem_all.MoneyPlaceId
                                  AND Object.DescId = zc_Object_PersonalServiceList()
             WHERE Object.Id IS NULL

            UNION ALL
             SELECT MAX (tmpBankStatementItem_all.MovementId)     AS MovementId
                  , MAX (tmpBankStatementItem_all.InvNumber)      AS InvNumber
                  , tmpBankStatementItem_all.OperDate
                  , tmpBankStatementItem_all.ServiceDate
                  , SUM (tmpBankStatementItem_all.Amount)         AS Amount
                  , SUM (tmpBankStatementItem_all.AmountSumm)     AS AmountSumm -- !!!значение при перезаливки не меняется!!!
                  , SUM (tmpBankStatementItem_all.AmountCurrency) AS AmountCurrency
                  , tmpBankStatementItem_all.BankAccountId
                  , MAX (tmpBankStatementItem_all.Comment)        AS Comment
                  , tmpBankStatementItem_all.MoneyPlaceId
                  , tmpBankStatementItem_all.PartnerId
                  , tmpBankStatementItem_all.ContractId
                  , tmpBankStatementItem_all.InfoMoneyId
                  , tmpBankStatementItem_all.UnitId
                  , tmpBankStatementItem_all.MovementId_Invoice
                  , tmpBankStatementItem_all.CurrencyId
                  , tmpBankStatementItem_all.CurrencyValue
                  , tmpBankStatementItem_all.ParValue
                  , tmpBankStatementItem_all.CurrencyPartnerValue
                  , tmpBankStatementItem_all.ParPartnerValue
                  , MAX (tmpBankStatementItem_all.BankAccountName) AS BankAccountName
                  , MAX (tmpBankStatementItem_all.BankMFO)         AS BankMFO
                  , MAX (tmpBankStatementItem_all.BankName)        AS BankName
             FROM tmpBankStatementItem_all
                  INNER JOIN Object ON Object.Id     = tmpBankStatementItem_all.MoneyPlaceId
                                   AND Object.DescId = zc_Object_PersonalServiceList()
             GROUP BY tmpBankStatementItem_all.OperDate
                    , tmpBankStatementItem_all.ServiceDate
                    , tmpBankStatementItem_all.BankAccountId
                    , tmpBankStatementItem_all.MoneyPlaceId  
                    , tmpBankStatementItem_all.PartnerId
                    , tmpBankStatementItem_all.ContractId
                    , tmpBankStatementItem_all.InfoMoneyId
                    , tmpBankStatementItem_all.UnitId
                    , tmpBankStatementItem_all.MovementId_Invoice
                    , tmpBankStatementItem_all.CurrencyId
                    , tmpBankStatementItem_all.CurrencyValue
                    , tmpBankStatementItem_all.ParValue
                    , tmpBankStatementItem_all.CurrencyPartnerValue
                    , tmpBankStatementItem_all.ParPartnerValue
                  --, tmpBankStatementItem_all.BankAccountName
                  --, tmpBankStatementItem_all.BankMFO
                  --, tmpBankStatementItem_all.BankName
            ) AS tmpBankStatementItem
                 LEFT JOIN Movement AS Movement_BankAccount 
                                    ON Movement_BankAccount.ParentId = tmpBankStatementItem.MovementId
                                   AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                                   AND Movement_BankAccount.StatusId = zc_Enum_Status_UnComplete()
                                  ;


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


if vbUserId = 5 AND 1=1 -- OR  inMovementId = 15504781
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
 04.07.24         *
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
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount_From_BankStatement (inMovementId:= 0, inSession:= '5')
