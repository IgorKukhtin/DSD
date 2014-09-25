-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (integer, tvarchar, tdatetime, TDateTime, TVarChar, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Service (integer, tvarchar, tdatetime, TDateTime, TVarChar, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inOperDatePartner          TDateTime , -- Дата акта(контрагента)
    IN inInvNumberPartner         TVarChar  , -- Номер акта (контрагента)
    IN inAmountIn                 TFloat    , -- Сумма операции 
    IN inAmountOut                TFloat    , -- Сумма операции 
    IN inComment                  TVarChar  , -- Комментарий
    IN inBusinessId               Integer   , -- Бизнес    
    IN inContractId               Integer   , -- Договор
    IN inInfoMoneyId              Integer   , -- Статьи назначения 
    IN inJuridicalId              Integer   , -- Юр. лицо	
    IN inPartnerId                Integer   , -- Контрагент
    IN inJuridicalBasisId         Integer   , -- Главное юр. лицо	
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    IN inUnitId                   Integer   , -- Подразделение

    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Service());

     -- проверка
     IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
        RAISE EXCEPTION 'Введите сумму.';
     END IF;
     -- проверка
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION 'Должна быть введена только одна сумма: <Дебет> или <Кредит>.';
     END IF;
     -- проверка
     IF inPaidKindId = zc_Enum_PaidKind_SecondForm()
        AND NOT EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE ChildObjectId = inJuridicalId AND DescId = zc_ObjectLink_Partner_Juridical() GROUP BY ChildObjectId HAVING COUNT(*) = 1)
     THEN
         RAISE EXCEPTION 'Ошибка. Для формы оплаты <%> должен быть установлен <Контрагент>.', lfGet_Object_ValueData (inPaidKindId);
     END IF;

     -- расчет
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Service())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Service(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), CASE WHEN inPartnerId <> 0 AND inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN inPartnerId ELSE inJuridicalId END, ioId, vbAmount, NULL);
    
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
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), vbMovementItemId, inContractConditionKindId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

     -- 5.1. таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

     -- 5.2. таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Service())
     THEN
          PERFORM lpComplete_Movement_Service (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.09.14                                        * add inPartnerId
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 10.05.14                                        * add lpInsert_MovementItemProtocol
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner
 19.01.14         * del ContractConditionKind
 28.01.14         * add ContractConditionKind
 22.01.14                                        * add IsMaster
 26.12.13                                        * add lpComplete_Movement_Service
 24.12.13                        *
 11.08.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Service (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inJuridicalId:= 1, inJuridicalBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inSession:= '2')
