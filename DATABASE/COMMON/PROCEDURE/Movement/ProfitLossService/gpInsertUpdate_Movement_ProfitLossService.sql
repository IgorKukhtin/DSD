-- Function: gpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmountIn                 TFloat    , -- Сумма операции
    IN inAmountOut                TFloat    , -- Сумма операции
    IN inBonusValue               TFloat    , -- % бонуса
    IN inAmountCurrency           TFloat    , -- сумма начислений (в валюте) 
    IN inInvNumberInvoice         TVarChar  , -- Счет(клиента)
    IN inComment                  TVarChar  , -- Комментарий
    IN inContractId               Integer   , -- Договор
    IN inContractMasterId         Integer   , -- Договор(условия)
    IN inContractChildId          Integer   , -- Договор(база)
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPartnerId                Integer   , -- Контрагент
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inUnitId                   Integer   , -- Подразделение
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
    IN inBranchId                 Integer   , -- филиал
    IN inCurrencyPartnerId        Integer   , -- Валюта Контрагента 
    IN inTradeMarkId              Integer   , --
    IN inMovementId_doc           Integer   , --
    IN inIsLoad                   Boolean   , -- Сформирован автоматически (по отчету)
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
 
 
      --проверка договор должен быть в Promo, иначе выдавать ошибку  
     IF COALESCE (inMovementId_doc,0) <> 0 
      AND EXISTS (SELECT 1 FROM Movement  WHERE Movement.Id = inMovementId_doc AND Movement.DescId = zc_Movement_PromoTrade())
      AND NOT EXISTS (--Акция
                      --Траде маркетинг
                      SELECT MovementLinkObject_Contract.ObjectId AS ContractId
                      FROM Movement 
                          --для Промо договор из zc_Movement_PromoPartner  
                          LEFT JOIN Movement AS Movement_PromoPartner
                                             ON Movement_PromoPartner.ParentId = Movement.Id
                                            AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                            AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner() 
             
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                       ON MovementLinkObject_Contract.MovementId = CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN Movement.Id ELSE Movement_PromoPartner.Id END
                                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                      WHERE Movement.Id = inMovementId_doc
                        AND MovementLinkObject_Contract.ObjectId <> 0
                      LIMIT 1)
     THEN
          RAISE EXCEPTION 'Ошибка.В документе <%> № <%> от <%> должен быть установлен <Договор база>.'
                        , (SELECT MovementDesc.ItemName
                           FROM Movement 
                                JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                           WHERE Movement.Id = inMovementId_doc
                          )
                        , (SELECT Movement.InvNumber
                           FROM Movement 
                           WHERE Movement.Id = inMovementId_doc
                          )
                        , (SELECT zfConvert_DateToString (Movement.OperDate)
                           FROM Movement 
                           WHERE Movement.Id = inMovementId_doc
                          )
                         ;
     END IF;
        
        
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ProfitLossService (ioId                := ioId
                                                      , inInvNumber         := inInvNumber
                                                      , inOperDate          := inOperDate
                                                      , inAmountIn          := inAmountIn
                                                      , inAmountOut         := inAmountOut
                                                      , inBonusValue        := inBonusValue
                                                      , inAmountCurrency    := inAmountCurrency  
                                                      , inInvNumberInvoice  := inInvNumberInvoice
                                                      , inComment           := inComment
                                                      , inContractId        := inContractId
                                                      , inContractMasterId  := inContractMasterId
                                                      , inContractChildId   := inContractChildId
                                                      , inInfoMoneyId       := inInfoMoneyId
                                                      , inJuridicalId       := CASE WHEN inPartnerId > 0 THEN inPartnerId ELSE inJuridicalId END  -- если выбран контрагент - записываем его а по нему уже понятно кто юр.лицо
                                                      , inPaidKindId        := inPaidKindId
                                                      , inUnitId            := inUnitId
                                                      , inContractConditionKindId := inContractConditionKindId
                                                      , inBonusKindId       := inBonusKindId
                                                      , inBranchId          := inBranchId
                                                      , inCurrencyPartnerId := inCurrencyPartnerId
                                                      , inTradeMarkId       := inTradeMarkId
                                                      , inMovementId_doc    := inMovementId_doc
                                                      , inIsLoad            := inIsLoad
                                                      , inUserId            := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.24         *
 21.05.20         *
 18.02.15         * add ContractMaster, ContractChild
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 08.05.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService (ioId := 0 , inInvNumber := '-1' , inOperDate := '01.01.2013', inAmountIn:= 20 , inAmountOut := 0 , inComment := '' , inContractId :=1 ,      inInfoMoneyId := 0,     inJuridicalId:= 1,       inPaidKindId:= 1,   inUnitId:= 0,   inContractConditionKindId:=0,     inSession:= zfCalc_UserAdmin() :: Integer)
