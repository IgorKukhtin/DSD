-- Function: gpInsertUpdate_Movement_ProfitIncomeService_ByReport 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitIncomeService_ByReport (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitIncomeService_ByReport (
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitIncomeService());
       
       
     /*   -- удаляем все документы сформированные автоматически
       PERFORM lpSetErased_Movement (inMovementId:= Movement.Id
                                   , inUserId    := vbUserId)
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_isLoad
                                       ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                      AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                      AND MovementBoolean_isLoad.ValueData = TRUE
       WHERE Movement.DescId = zc_Movement_ProfitIncomeService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
       ;
      */
      
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     CREATE TEMP TABLE _tmpReport ON COMMIT DROP AS
     SELECT tmp.Sum_Bonus                        :: TFloat
          , CAST (tmp.Value AS NUMERIC (16, 2))  :: TFloat AS Value
          , COALESCE (tmp.Comment, '') :: TVarChar AS Comment
          , tmp.ContractId_find
          , tmp.ContractId_master
          , tmp.ContractId_Child
          , tmp.InfoMoneyId_find
          , CASE WHEN PartnerId > 0 THEN PartnerId ELSE JuridicalId END  AS JuridicalId -- если выбран контрагент - записываем его а по нему уже понятно кто юр.лицо JuridicalId
          , tmp.PaidKindId
          , tmp.ConditionKindId
          , COALESCE (tmp.BonusKindId,0) :: Integer AS BonusKindId
          , COALESCE (tmp.BranchId,0) :: Integer    AS BranchId
     FROM gpReport_CheckBonus_Income (inStartDate   := inStartDate
                                    , inEndDate     := inEndDate
                                    , inPaidKindId  := inPaidKindId
                                    , inJuridicalId := inJuridicalId
                                    , inBranchId    := inBranchId
                                    , inSession     := inSession) AS tmp
     WHERE COALESCE (tmp.Sum_Bonus,0) <> 0
     ;     
     
     IF EXISTS (SELECT 1 FROM _tmpReport)
     THEN
          -- 
          PERFORM lpInsertUpdate_Movement_ProfitIncomeService (ioId                := 0
                                                             , inInvNumber         := CAST (NEXTVAL ('movement_ProfitIncomeService_seq') AS TVarChar) 
                                                             , inOperDate          := inEndDate
                                                             , inAmountIn          := tmp.Sum_Bonus    :: TFloat
                                                             , inAmountOut         := 0                :: TFloat
                                                             , inBonusValue        := tmp.Value        :: TFloat
                                                             , inComment           := tmp.Comment      :: TVarChar
                                                             , inContractId        := tmp.ContractId_find
                                                             , inContractMasterId  := tmp.ContractId_master
                                                             , inContractChildId   := tmp.ContractId_Child
                                                             , inInfoMoneyId       := tmp.InfoMoneyId_find
                                                             , inJuridicalId       := tmp.JuridicalId
                                                             , inPaidKindId        := tmp.PaidKindId
                                                             , inContractConditionKindId := tmp.ConditionKindId
                                                             , inBonusKindId       := tmp.BonusKindId
                                                             , inBranchId          := tmp.BranchId
                                                             , inIsLoad            := TRUE             :: Boolean
                                                             , inUserId            := vbUserId
                                                              )
          FROM _tmpReport AS tmp;
     ELSE
         RAISE EXCEPTION 'Ошибка.Данных для формирования документов нет.';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         *
*/

-- тест
--