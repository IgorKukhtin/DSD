-- Function: gpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, tdatetime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmountIn                 TFloat    , -- Сумма операции
    IN inAmountOut                TFloat    , -- Сумма операции
    IN inComment                  TVarChar  , -- Комментарий
    IN inContractId               Integer   , -- Договор
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inUnitId                   Integer   , -- Подразделение
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
    IN inIsLoad                   Boolean   , -- Сформирован автоматически (по отчету)
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());

     -- таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
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

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ProfitLossService (ioId              := ioId
                                                      , inInvNumber       := inInvNumber
                                                      , inOperDate        := inOperDate
                                                      , inAmountIn        := inAmountIn
                                                      , inAmountOut       := inAmountOut
                                                      , inComment         := inComment
                                                      , inContractId      := inContractId
                                                      , inInfoMoneyId     := inInfoMoneyId
                                                      , inJuridicalId     := inJuridicalId
                                                      , inPaidKindId      := inPaidKindId
                                                      , inUnitId          := inUnitId
                                                      , inContractConditionKindId := inContractConditionKindId
                                                      , inBonusKindId     := inBonusKindId
                                                      , inIsLoad          := inIsLoad
                                                      , inUserId          := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.05.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService (ioId := 0 , inInvNumber := '-1' , inOperDate := '01.01.2013', inAmountIn:= 20 , inAmountOut := 0 , inComment := '' , inContractId :=1 ,      inInfoMoneyId := 0,     inJuridicalId:= 1,       inPaidKindId:= 1,   inUnitId:= 0,   inContractConditionKindId:=0,     inSession:= zfCalc_UserAdmin() :: Integer)
