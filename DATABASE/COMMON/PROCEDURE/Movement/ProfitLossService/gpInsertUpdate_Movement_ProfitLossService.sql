-- Function: gpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (integer, tvarchar, tdatetime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (integer, tvarchar, tdatetime, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (integer, tvarchar, tdatetime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (integer, tvarchar, tdatetime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (integer, tvarchar, tdatetime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (integer, tvarchar, tdatetime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, tvarchar);

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
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbBranchId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
     -- определяем ключ доступа
---     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());

     -- проверка
     IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
        RAISE EXCEPTION 'Введите сумму.';
     END IF;

     -- проверка
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;


     -- расчет
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- 1. Распроводим Документ
     PERFORM gpUnComplete_Movement_ProfitLossService (inMovementId := ioId, inSession := inSession);

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProfitLossService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inJuridicalId, ioId, vbAmount, NULL);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);
     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- сохранили связь с <Типы условий договоров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), vbMovementItemId, inContractConditionKindId);
     -- сохранили связь с <Виды бонусов>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BonusKind(), vbMovementItemId, inBonusKindId);


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
        PERFORM gpComplete_Movement_ProfitLossService (inMovementId := ioId, inIsLastComplete := FALSE, inSession := inSession);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.02.14         * add BonusKind
 18.02.14                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService (ioId := 0 , inInvNumber := '-1' , inOperDate := '01.01.2013', inAmountIn:= 20 , inAmountOut := 0 , inComment := '' , inContractId :=1 ,      inInfoMoneyId := 0,     inJuridicalId:= 1,       inPaidKindId:= 1,   inUnitId:= 0,   inContractConditionKindId:=0,     inSession:= '2')