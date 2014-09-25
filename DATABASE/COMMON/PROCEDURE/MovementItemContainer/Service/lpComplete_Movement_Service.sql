-- Function: lpComplete_Movement_Service (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Service (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS void
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbIsAccount_50401 Boolean;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- нужен тип документа, т.к. проведение для двух разных видов документов
     SELECT Movement.DescId
          , CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                 THEN TRUE
                 ELSE FALSE
            END
            INTO vbMovementDescId, vbIsAccount_50401 -- Расходы будущих периодов + Услуги по маркетингу
     FROM Movement
          JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
     WHERE Movement.Id = inMovementId;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- сформируем позже, или ...
             , CASE WHEN vbMovementDescId = zc_Movement_ProfitLossService() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- Расходы будущих периодов + Маркетинг
                    ELSE 0
               END AS AccountId 

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0  AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: пока "Главный филиал" (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                              ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId NOT IN (zc_Object_Juridical(), zc_Object_Partner()))
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Юридическое лицо>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У документе не определена <Форма оплаты>. Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE
                         THEN _tmpItem.ObjectId -- из предыдущей проводки
                    ELSE 0 -- значит попадет в ОПиУ
               END AS ObjectId
             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE
                         THEN _tmpItem.ObjectDescId -- из предыдущей проводки
                    ELSE 0 -- значит попадет в ОПиУ
               END AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- сформируем позже, или ...
             , CASE WHEN vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE
                         THEN zc_Enum_Account_50401() -- Расходы будущих периодов - Маркетинг
                    ELSE 0
               END AS AccountId 

               -- Группы ОПиУ (для затрат)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления (для затрат)
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из предыдущей проводки (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , _tmpItem.JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: всегда из предыдущей проводки
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , _tmpItem.ContractId -- из предыдущей проводки
             , _tmpItem.PaidKindId -- из предыдущей проводки

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MILinkObject_Unit.ObjectId
                                                                                                          AND NOT (vbMovementDescId = zc_Movement_Service() AND vbIsAccount_50401 = TRUE) -- !!!нужен только для затрат!!!
       ;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 21.03.14                                        * add zc_Enum_InfoMoneyDestination_21500
 10.03.14                                        * add zc_Movement_ProfitLossService
 22.01.14                                        * add IsMaster
 28.12.13                                        *
*/

-- тест
/*
     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean
                                ) ON COMMIT DROP;
 SELECT * FROM lpComplete_Movement_Service (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
*/
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 4139, inSession:= zfCalc_UserAdmin())
