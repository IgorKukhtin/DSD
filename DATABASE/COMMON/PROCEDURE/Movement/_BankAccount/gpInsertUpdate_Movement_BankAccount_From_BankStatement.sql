-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_BankAccount_From_BankStatement(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankAccount_From_BankStatement(
 INOUT inMovementId          Integer   , -- Ключ объекта <Документ> BankStatement
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());
     vbUserId := inSession;
    

     -- распроводим Документы
     PERFORM lpUnComplete_Movement (inMovementId := Movement_BankAccount.Id
                                  , inUserId     := vbUserId)
     FROM Movement
          JOIN Movement AS Movement_BankAccount
                        ON Movement_BankAccount.ParentId = Movement.Id
                       AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                       AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()
     WHERE Movement.DescId = zc_Movement_BankStatementItem()
       AND Movement.ParentId = inMovementId;



     -- Выбираем все данные и сразу вызываем процедуры
     PERFORM             
       lpInsertUpdate_Movement_BankAccount(ioId := COALESCE(Movement_BankAccount.Id, 0), 
               inInvNumber := Movement.InvNumber, 
               inOperDate := Movement.OperDate, 
               inAmount := MovementFloat_Amount.ValueData, 
               inBankAccountId := MovementLinkObject_BankAccount.ObjectId,  
               inComment := MovementString_Comment.ValueData, 
               inMoneyPlaceId := MovementLinkObject_Juridical.ObjectId, 
               inContractId := MovementLinkObject_Contract.ObjectId, 
               inInfoMoneyId := MovementLinkObject_InfoMoney.ObjectId, 
               inUnitId := MovementLinkObject_Unit.ObjectId, 
               inCurrencyId := MovementLinkObject_Currency.ObjectId, 
               inParentId := Movement.Id)

       FROM Movement
            LEFT JOIN Movement AS Movement_BankAccount 
                   ON Movement_BankAccount.ParentId = Movement.Id
                  AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                         ON MovementLinkObject_BankAccount.MovementId = Movement.ParentId
                                        AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()


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
 
       WHERE Movement.DescId = zc_Movement_BankStatementItem()
         AND Movement.ParentId = inMovementId;


     -- 5.1. таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- 5.2. таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, BranchId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;


     -- 5.3. проводим Документ
     PERFORM lpComplete_Movement_BankAccount (inMovementId := Movement_BankAccount.Id
                                            , inUserId     := vbUserId)
     FROM Movement
         JOIN Movement AS Movement_BankAccount
                       ON Movement_BankAccount.ParentId = Movement.Id
                      AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
         JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id AND MovementItem.DescId = zc_MI_Master()
         JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                     ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                    AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                     AND MILinkObject_MoneyPlace.ObjectId > 0
     WHERE Movement.DescId = zc_Movement_BankStatementItem()
       AND Movement.ParentId = inMovementId;

     -- Ставим статус у документа выписки
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
         WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.01.14                        *  меняем статус после загрузки
 22.01.14                                        * add IsMaster
 16.01.13                                        * add lpComplete_Movement_BankAccount
 06.12.13                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_BankAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
