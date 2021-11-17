-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReport_Journal 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport_Journal (TDateTime, TDateTime
                                                                                  , TFloat, TFloat, TFloat, TFloat, TFloat
                                                                                  , Integer, Integer, Integer, Integer, Integer
                                                                                  , Integer, Integer, Integer, Integer, Integer 
                                                                                  , Integer, Integer, Integer
                                                                                  , TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReport_Journal (
    IN inOperDate               TDateTime ,
    IN inServiceDate            TDateTime ,
    IN inSum_Bonus              TFloat ,
    IN inValue                  TFloat ,
    IN inTotalSumm              TFloat ,  -- Сумма база
    IN inPercentRet             TFloat ,  -- % возврата факт (Вес)
    IN inPartKg                 TFloat ,  -- Доля продаж
    IN inContractId_find        Integer ,
    IN inContractId_master      Integer ,
    IN inContractId_Child       Integer ,
    IN inInfoMoneyId_find       Integer ,
    IN inJuridicalId            Integer,
    IN inPartnerId              Integer,
    IN inPaidKindId             Integer,
    IN inPaidKindId_child       Integer,
    IN inConditionKindId        Integer,
    IN inBonusKindId            Integer,
    IN inBranchId               Integer,
    IN inPersonalTradeId        Integer,  -- Сотрудники (торговый)
    IN inPersonalMainId         Integer,  -- Сотрудники (супервайзер)
    IN inComment                TVarChar ,
    IN inSession                TVarChar        -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
       
     IF COALESCE (inSum_Bonus,0) = 0
     THEN
         RETURN;
     END IF;
      
     -- 
     vbId := lpInsertUpdate_Movement_ProfitLossService (ioId                := 0
                                                      , inInvNumber         := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                      , inOperDate          := inOperDate
                                                      , inAmountIn          := 0                                 :: TFloat
                                                      , inAmountOut         := inSum_Bonus                       :: TFloat
                                                      , inBonusValue        := CAST (inValue AS NUMERIC (16, 2)) :: TFloat
                                                      , inAmountCurrency    := 0    :: TFloat
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
                                                      , inCurrencyPartnerId := 0
                                                      , inIsLoad            := TRUE                            :: Boolean
                                                      , inUserId            := vbUserId
                                                       )
     ;
     
     -- + новые параметры
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), vbId, inServiceDate);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), vbId, inTotalSumm);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PercentRet(), vbId, inPercentRet);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PartKg(), vbId, inPartKg);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), vbId, inPersonalTradeId);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalMain(), vbId, inPersonalMainId);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), vbId, inPaidKindId_child);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.21         *
*/

-- тест