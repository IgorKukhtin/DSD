-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReport_ByGrid 

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport_ByGrid (TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer ,Integer ,Integer ,Integer ,Integer ,Integer ,Integer ,TVarChar,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport_ByGrid (TDateTime, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer ,Integer ,Integer ,Integer ,Integer ,Integer ,Integer ,TVarChar,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport_ByGrid (TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer ,Integer ,Integer ,Integer ,Integer , Integer, Integer ,Integer ,TVarChar,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport_ByGrid (TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer ,Integer ,Integer ,Integer ,Integer , Integer, Integer ,Integer ,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReport_ByGrid (
   OUT outId                    Integer ,
    IN inOperDate               TDateTime ,  
    IN inSum_Bonus              TFloat ,
    IN inSumIn                  TFloat ,
    IN inValue                  TFloat , 
    IN inKoeff                  TFloat ,
    IN inAmountCurrency         TFloat ,
    IN inContractId_find        Integer ,
    IN inContractId_master      Integer ,
    IN inContractId_Child       Integer ,
    IN inInfoMoneyId_find       Integer ,
    IN inJuridicalId            Integer,
    IN inPartnerId              Integer,
    IN inPaidKindId             Integer,
    IN inConditionKindId        Integer,
    IN inBonusKindId            Integer,
    IN inBranchId               Integer,
    IN inCurrencyPartnerId      Integer,
    IN inComment                TVarChar ,
    IN inSession                TVarChar        -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
       
     IF COALESCE (inSum_Bonus,0) = 0 AND COALESCE (inSumIn,0)= 0
     THEN
         RETURN;
     END IF;
      
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 
     outId:= lpInsertUpdate_Movement_ProfitLossService (ioId                := 0
                                                      , inInvNumber         := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                      , inOperDate          := inOperDate
                                                      , inAmountIn          := CASE WHEN COALESCE (inKoeff,0) = 0 THEN COALESCE (inSumIn,0)     ELSE CAST (COALESCE (inSumIn,0)     / inKoeff AS NUMERIC (16, 2)) END :: TFloat
                                                      , inAmountOut         := CASE WHEN COALESCE (inKoeff,0) = 0 THEN COALESCE (inSum_Bonus,0) ELSE CAST (COALESCE (inSum_Bonus,0) / inKoeff AS NUMERIC (16, 2)) END :: TFloat
                                                      , inBonusValue        := inValue
                                                      , inAmountCurrency    := COALESCE (inAmountCurrency,0)     :: TFloat
                                                      , inComment           := inComment                         :: TVarChar
                                                      , inContractId        := inContractId_find
                                                      , inContractMasterId  := inContractId_master
                                                      , inContractChildId   := inContractId_Child
                                                      , inInfoMoneyId       := inInfoMoneyId_find
                                                      , inJuridicalId       := CASE WHEN inPartnerId > 0 THEN inPartnerId ELSE inJuridicalId END  -- если выбран контрагент - записываем его а по нему уже понятно кто юр.лицо JuridicalId
                                                      , inPaidKindId        := inPaidKindId
                                                      , inUnitId            := 0                               :: Integer
                                                      , inContractConditionKindId   := inConditionKindId
                                                      , inBonusKindId       := inBonusKindId
                                                      , inBranchId          := inBranchId
                                                      , inCurrencyPartnerId := inCurrencyPartnerId
                                                      , inIsLoad            := TRUE                            :: Boolean
                                                      , inUserId            := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.21         * inSumIn
 17.02.21         *
*/

-- тест