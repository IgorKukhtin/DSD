-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReport 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReport (
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,
    IN inOperDate                 TDateTime ,
    IN inPaidKindId               Integer   ,
    IN inJuridicalId              Integer   ,
    IN inBranchId                 Integer   ,
    IN inSession                  TVarChar        -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
       
       
     /*   -- удаляем все документы сформированные автоматически
       PERFORM lpSetErased_Movement (inMovementId:= Movement.Id
                                   , inUserId    := vbUserId)
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_isLoad
                                       ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                      AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                      AND MovementBoolean_isLoad.ValueData = TRUE
       WHERE Movement.DescId = zc_Movement_ProfitLossService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
       ;
      */
      
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

/* if vbUserId = '5' 
 then
     RAISE EXCEPTION 'Ошибка. test <%>'
                  , (SELECT SUM COALESCE (Value, 0)
                     FROM gpReport_CheckBonus (inStartDate   := inStartDate
                                             , inEndDate     := inEndDate
                                             , inPaidKindId  := inPaidKindID
                                             , inJuridicalId := inJuridicalId
                                             , inBranchId    := inBranchId
                                             , inSession     := inSession) AS tmp
                     WHERE Sum_Bonus <> 0
                     AND JuridicalId = 14884 -- БІЛЛА-Україна ПП
                    );
 end if;*/

     -- 
     PERFORM lpInsertUpdate_Movement_ProfitLossService (ioId                := 0
                                                      , inInvNumber         := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                      , inOperDate          := inOperDate
                                                      , inAmountIn          := 0                               :: TFloat
                                                      , inAmountOut         := Sum_Bonus                       :: TFloat
                                                      , inBonusValue        := CAST (Value AS NUMERIC (16, 2)) :: TFloat
                                                      , inAmountCurrency    := COALESCE (Sum_Bonus_curr)       :: TFloat
                                                      , inComment           := Comment                         :: TVarChar
                                                      , inContractId        := ContractId_find
                                                      , inContractMasterId  := ContractId_master
                                                      , inContractChildId   := ContractId_Child
                                                      , inInfoMoneyId       := InfoMoneyId_find
                                                      , inJuridicalId       := CASE WHEN PartnerId > 0 THEN PartnerId ELSE JuridicalId END  -- если выбран контрагент - записываем его а по нему уже понятно кто юр.лицо JuridicalId
                                                      , inPaidKindId        := PaidKindId
                                                      , inUnitId            := 0                               :: Integer
                                                      , inContractConditionKindId   := ConditionKindId
                                                      , inBonusKindId       := BonusKindId
                                                      , inBranchId          := BranchId
                                                      , inCurrencyPartnerId := CurrencyId_child
                                                      , inIsLoad            := TRUE                            :: Boolean
                                                      , inUserId            := vbUserId
                                                       )
     FROM gpReport_CheckBonus (inStartDate   := inStartDate
                             , inEndDate     := inEndDate
                             , inPaidKindID  := inPaidKindId
                             , inJuridicalId := inJuridicalId
                             , inBranchId    := inBranchId
                             , inIsMovement  := FALSE
                             , inisDetail    := FALSE
                             , inisGoods     := FALSE 
                             , inSession     := inSession) AS tmp
     WHERE Sum_Bonus <> 0
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.12.21         * новая gpReport_CheckBonus
 20.05.20         * add inBranchId
 09.12.15         * 
 03.12.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_ByReport (inStartDate := '01.01.2013', inEndDate := '01.01.2013' , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_ByReport(inStartDate := ('01.06.2020')::TDateTime , inEndDate := ('30.06.2020')::TDateTime , inPaidKindId := 3 , inJuridicalId := 0 , inBranchId := 0 ,  inSession := zfCalc_UserAdmin());
