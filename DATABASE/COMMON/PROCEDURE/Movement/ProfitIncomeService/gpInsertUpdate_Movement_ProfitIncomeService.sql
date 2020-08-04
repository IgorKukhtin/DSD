-- Function: gpInsertUpdate_Movement_ProfitIncomeService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitIncomeService (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TVarChar
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitIncomeService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmountIn                 TFloat    , -- Сумма операции
    IN inAmountOut                TFloat    , -- Сумма операции
    IN inBonusValue               TFloat    , -- % бонуса
    IN inComment                  TVarChar  , -- Комментарий
    IN inContractId               Integer   , -- Договор
    IN inContractMasterId         Integer   , -- Договор(условия)
    IN inContractChildId          Integer   , -- Договор(база)
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPartnerId                Integer   , -- Контрагент
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
    IN inBranchId                 Integer   , -- филиал
    IN inIsLoad                   Boolean   , -- Сформирован автоматически (по отчету)
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitIncomeService());
     
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ProfitIncomeService (ioId                := ioId
                                                      , inInvNumber         := inInvNumber
                                                      , inOperDate          := inOperDate
                                                      , inAmountIn          := inAmountIn
                                                      , inAmountOut         := inAmountOut
                                                      , inBonusValue        := inBonusValue
                                                      , inComment           := inComment
                                                      , inContractId        := inContractId
                                                      , inContractMasterId  := inContractMasterId
                                                      , inContractChildId   := inContractChildId
                                                      , inInfoMoneyId       := inInfoMoneyId
                                                      , inJuridicalId       := CASE WHEN inPartnerId > 0 THEN inPartnerId ELSE inJuridicalId END  -- если выбран контрагент - записываем его а по нему уже понятно кто юр.лицо
                                                      , inPaidKindId        := inPaidKindId
                                                      , inContractConditionKindId := inContractConditionKindId
                                                      , inBonusKindId       := inBonusKindId
                                                      , inBranchId          := inBranchId
                                                      , inIsLoad            := inIsLoad
                                                      , inUserId            := vbUserId
                                                       );

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