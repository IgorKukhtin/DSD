-- Function: gpInsertUpdate_Movement_ProfitLossService_From_Report 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_From_Report (tdatetime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_From_Report (
   OUT ioId                       Integer   ,
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmount                   TFloat    , -- Сумма операции
    IN inContractId               Integer   , -- Договор
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    --IN inUnitId                 Integer   , -- Подразделение
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$

   DECLARE vbId Integer;

BEGIN
     IF inAmount <> 0 THEN
       
    
       SELECT
             Movement.Id
       INTO vbId 
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE 
                                  AND MovementItem.ObjectId = inJuridicalId
           
            JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                        AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId

            JOIN MovementItemLinkObject AS MILinkObject_Contract
                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                       AND MILinkObject_Contract.ObjectId = 16211 --inContractId
          /*LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId*/

            JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                            AND  MILinkObject_PaidKind.ObjectId = inPaidKindId
      
            JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                                            AND MILinkObject_ContractConditionKind.ObjectId = inContractConditionKindId
            
            JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                             ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
                                            AND MILinkObject_BonusKind.ObjectId = inBonusKindId
       WHERE Movement.DescId = zc_Movement_ProfitLossService()
         AND Movement.OperDate BETWEEN inOperDate AND inOperDate
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete());

       ioId :=  gpInsertUpdate_Movement_ProfitLossService (ioId              := COALESCE (vbId,0)
                                                         , inInvNumber       := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                         , inOperDate        := inOperDate
                                                         , inAmountIn        := 0
                                                         , inAmountOut       := inAmount
                                                         , inComment         := 'По отчету'
                                                         , inContractId      := inContractId
                                                         , inInfoMoneyId     := inInfoMoneyId
                                                         , inJuridicalId     := inJuridicalId
                                                         , inPaidKindId      := inPaidKindId
                                                         , inUnitId          := 0
                                                         , inContractConditionKindId   := inContractConditionKindId
                                                         , inBonusKindId     := inBonusKindId
                                                         , inSession         := inSession
                                                         );


     ELSE
        ioId := 0 ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.05.14         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_From_Report (ioId := 0 , inInvNumber := '-1' , inOperDate := '01.01.2013', inAmountIn:= 20 , inAmountOut := 0 , inComment := '' , inContractId :=1 ,      inInfoMoneyId := 0,     inJuridicalId:= 1,       inPaidKindId:= 1,   inUnitId:= 0,   inContractConditionKindId:=0,     inSession:= '2')
