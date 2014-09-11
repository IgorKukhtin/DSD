-- Function: gpInsertUpdate_Movement_PersonalService()

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TDateTime, Integer, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalService (integer, tvarchar, tdatetime, tdatetime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalService (integer, tvarchar, tdatetime, Integer, tfloat, TVarChar, integer, integer, integer, integer, TDateTime, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalService(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPersonalId          Integer   , -- Сотрудник
    IN inAmount              TFloat    , -- Сумма операции 
    IN inComment             TVarChar  , -- Комментерий
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inUnitId              Integer   , -- Подразделение 	
    IN inPositionId          Integer   , -- Должность
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inServiceDate         TDateTime , -- Дата начисления
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());

     -- 1. Распроводим Документ
     IF ioMovementId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_PersonalService())
        -- это временно
        AND EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- расчет
     IF inInvNumber = '' THEN
        inInvNumber := (NEXTVAL ('Movement_PersonalService_seq')) :: TVarChar;
     END IF;


     -- сохранили <Документ>
     ioMovementId := lpInsertUpdate_Movement (ioMovementId, zc_Movement_PersonalService(), inInvNumber, inOperDate, NULL);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inPersonalId, ioMovementId, inAmount, NULL);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- сохранили связь с <Должность>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), vbMovementItemId, inPositionId);
     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);
     -- сохранили связь с <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);


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

     -- это временно
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- 5.3. проводим Документ
         IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Cash())
         THEN
              PERFORM lpComplete_Movement_PersonalService (inMovementId := ioMovementId
                                                         , inUserId     := vbUserId);
         END IF;
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.14                         *
 17.02.14                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PersonalService (ioMovementId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
