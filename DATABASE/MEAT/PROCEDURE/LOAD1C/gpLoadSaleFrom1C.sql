-- Function: gpInsertUpdate_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpLoadSaleFrom1C (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpLoadSaleFrom1C(
    IN inStartDate           TDateTime  , -- Начальная дата переноса
    IN inEndDate             TDateTime  , -- Конечная дата переноса
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSaleCount Integer;
   DECLARE vbCount Integer;
   DECLARE cursMovement refcursor;
   DECLARE cursMovementItem refcursor;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;  
   DECLARE vbMovementId Integer;
   DECLARE vbUnitId Integer;
BEGIN
	
     -- проверка прав пользователя на вызов процедуры
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount_From_BankS());

     -- Проверка что все для переноса установлено
     SELECT COUNT(*) INTO vbSaleCount 
      FROM Sale1C  
     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate;

     SELECT COUNT(*) INTO vbCount
      FROM Sale1C
      JOIN Object AS Object_DeliveryPoint ON Sale1C.ClientCode = Object_DeliveryPoint.ObjectCode
       AND Object_DeliveryPoint.DescId =  zc_Object_Partner1CLink()
      JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
        ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_DeliveryPoint.Id
       AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
       AND ObjectLink_Partner1CLink_Branch.ChildObjectId = zfGetUnitId(Sale1C.UnitId)
      JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
        ON ObjectLink_Partner1CLink_Partner.ObjectId = ObjectLink_Partner1CLink_Branch.ObjectId
       AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
      JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId


      JOIN Object AS Object_GoodsByGoodsKind1CLink ON Sale1C.GoodsCode = Object_GoodsByGoodsKind1CLink.ObjectCode
       AND Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
       
      JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
        ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
       AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
       AND ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId = zfGetUnitId(Sale1C.UnitId)
      JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind
        ON ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId
       AND ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind()
      JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsByGoodsKind.ChildObjectId
     WHERE Sale1C.OperDate BETWEEN inStartDate AND inEndDate;

--     IF vbSaleCount > vbCount THEN 
  --      RAISE EXCEPTION 'Не все записи засинхронизированы. Перенос не возможен'; 
  --   END IF;

     -- Помечаем на удаление загруженных Sale

    PERFORM gpSetErased_Movement(Movement.Id, inSession) 
       FROM Movement  
       JOIN MovementLinkObject AS MIO_From ON MIO_From.movementid = Movement.id
        AND MIO_From.descid = zc_MovementLinkObject_From() 
        AND MIO_From.objectid IN (SELECT zfGetUnitFromUnitId(UnitId) FROM Sale1C GROUP BY zfGetUnitFromUnitId(UnitId))
       JOIN movementboolean AS movementboolean_isLoad 
         ON movementboolean_isLoad.movementid = Movement.id
        AND movementboolean_isLoad.descid = zc_movementBoolean_isLoad()
        AND movementboolean_isLoad.valuedata = true 
      WHERE Movement.descid = zc_movement_sale()
        AND Movement.OperDate BETWEEN inStartDate AND inEndDate; 


     OPEN cursMovement FOR 
        SELECT InvNumber, OperDate, zfGetUnitFromUnitId(UnitId) 
          FROM Sale1C 
         WHERE OperDate BETWEEN inStartDate AND inEndDate; --открываем курсор
     LOOP --начинаем цикл по курсору
          --извлекаем данные из строки и записываем их в переменные
        FETCH cursMovement INTO vbInvNumber, vbOperDate, vbUnitId;
        --если такого периода и не возникнет, то мы выходим
        IF NOT FOUND THEN 
           EXIT;
        END IF;
        vbMovementId := lpInsertUpdate_Movement_Sale(ioId := 0, inInvNumber := vbInvNumber, inInvNumberPartner := '', inInvNumberOrder := '', 
                          inOperDate := vbOperDate, inOperDatePartner := vbOperDate, inChecked := false, inPriceWithVAT := true, inVATPercent := 20, 
                          inChangePercent := 0, inFromId := vbUnitId, inToId := 0, inPaidKindId := 0, inContractId := 0, inRouteSortingId := 0, inUserId := vbUserId);
     END LOOP;--заканчиваем цикл по курсору
     CLOSE cursMovement; --закрываем курсор
    
     -- Выбираем все данные и сразу вызываем процедуры
/*     PERFORM             
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
                             AND Movement_BankAccount.StatusId = zc_Enum_Status_UnComplete()

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
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
         WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
*/

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.02.14                        *  
*/

-- тест
-- SELECT * FROM gpLoadSaleFrom1C('01-01-2013'::TDateTime, '01-01-2014'::TDateTime, '')