-- Function: lpComplete_Movement_MobileBills (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_MobileBills (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_MobileBills(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.1. долг поставщику услуг - Юр Лицу
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (Object.Id, 0)      AS ObjectId
             , COALESCE (Object.DescId, 0)  AS ObjectDescId
             , -1 * MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , Object_Unit.Id   AS UnitId -- здесь НЕ используется (нужен для следующей проводки)
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению или "Главный филиал" (здесь не используется, нужен для следующей проводки)
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , COALESCE (MLO_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_FirstForm()        AS PaidKindId -- !!!захардкодил-БН!!!

             , 0 AS AnalyzerId -- не надо, т.к. это обычные услуги
               -- приоритет:
             , CASE -- 1) если это учредитель - На кого "переносятся" затраты
                    WHEN Object_ObjectTo.DescId = zc_Object_Founder()
                         THEN Object_ObjectTo.Id
                    -- 2) если это Сотрудник - На кого "переносятся" затраты
                    WHEN Object_ObjectTo.DescId = zc_Object_Personal()
                         THEN Object_ObjectTo.Id
                    -- 3) Сотрудник/Подразделение/Учредитель ИЛИ На кого "переносятся" затраты
                    ELSE COALESCE (MILinkObject_Employee.ObjectId, Object_ObjectTo.Id)
               END AS ObjectIntId_Analyzer

             , TRUE AS IsActive -- всегда такая
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

             LEFT JOIN MovementLinkObject AS MLO_Contract
                                          ON MLO_Contract.MovementId = MovementItem.MovementId
                                         AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = MLO_Contract.ObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney ON ObjectLink_Contract_InfoMoney.ObjectId = MLO_Contract.ObjectId
                                                                  AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MLO_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

             -- Сотрудник/Подразделение/Учредитель
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee
                                              ON MILinkObject_Employee.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Employee.DescId = zc_MILinkObject_Employee()
             LEFT JOIN Object AS Object_Employee ON Object_Employee.Id = MILinkObject_Employee.ObjectId
             -- нашли Физ лицо
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = MILinkObject_Employee.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             -- если у Физ лица установлено - На кого "переносятся" затраты в "Налоги с ЗП" или в "Мобильная связь"
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id = ObjectLink_Member_ObjectTo.ChildObjectId

             -- если "Сотрудник" - у него определяется "Подразделение"
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                  ON ObjectLink_Personal_Unit.ObjectId = COALESCE (Object_ObjectTo.Id, MILinkObject_Employee.ObjectId)
                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE -- если На кого "переносятся" затраты = Подразделение
                                                                      WHEN Object_ObjectTo.DescId = zc_Object_Unit()
                                                                           THEN Object_ObjectTo.Id
                                                                      -- если нашли Сотрудника или Телефон привязан к подразделению
                                                                      WHEN ObjectLink_Personal_Unit.ChildObjectId > 0 OR Object_Employee.DescId = zc_Object_Unit()
                                                                           THEN COALESCE (ObjectLink_Personal_Unit.ChildObjectId, Object_Employee.Id)
                                                                      -- иначе захардкодим - Подразделение "Административный"
                                                                      ELSE 8383
                                                                 END
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_MobileBills()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- !!!сохранили связь с <InfoMoney> !!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), _tmpItem.MovementItemId, _tmpItem.InfoMoneyId)
     FROM _tmpItem;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION 'В документе не определен <Договор>. Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'У не установлено <Главное юр лицо.> Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.2.1. ОПиУ по "услуги полученные" - для Сотрудник/Подразделение или временно хардкодим "Админ" - если вдруг будет пусто
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 *  _tmpItem.OperSumm
               -- !!!уменьшили на "Перелимит"
             - CASE WHEN Object_Employee.DescId = zc_Object_Personal()
                         THEN COALESCE (MIFloat_Overlimit.ValueData, 0)
                    ELSE 0
               END AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

               -- Группы ОПиУ
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ:
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId            -- используется, для аналитики WhereObjectId_Analyzer
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению
             , _tmpItem.BranchId_ProfitLoss AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0 AS AnalyzerId -- не надо, т.к. это ОПиУ
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это ОПиУ

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN Object AS Object_Employee ON Object_Employee.Id = _tmpItem.ObjectIntId_Analyzer

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId

             LEFT JOIN MovementItemFloat AS MIFloat_Overlimit
                                         ON MIFloat_Overlimit.MovementItemId = _tmpItem.MovementItemId
                                        AND MIFloat_Overlimit.DescId = zc_MIFloat_Overlimit()

        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL                                -- если НЕ Перевыставление
          AND (Object_Employee.Id IS NULL OR Object_Employee.DescId <> zc_Object_Founder()) -- если НЕ Учредитель

       UNION ALL
         -- 1.2.2. Перевыставление затрат на Юр Лицо
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: всегда "Главный филиал" (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: здесь не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , ObjectLink_Unit_Contract.ChildObjectId     AS ContractId
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId

             , 0 AS AnalyzerId -- не надо, т.к. это Перевыставление
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это Перевыставление

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                              AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN Object AS Object_Employee ON Object_Employee.Id     = _tmpItem.ObjectIntId_Analyzer
                                                AND Object_Employee.DescId = zc_Object_Founder()

        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0
          AND Object_Employee.Id IS NULL

       UNION ALL
         -- 1.2.3. Перевыставление затрат на Учредителя
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_Employee.Id     AS ObjectId
             , Object_Employee.DescId AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения - не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения - не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения - не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , 0 AS AnalyzerId -- не надо, т.к. это Перевыставление
             , 0  As ObjectIntId_Analyzer -- не надо, т.к. это Перевыставление
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             INNER JOIN Object AS Object_Employee ON Object_Employee.Id     = _tmpItem.ObjectIntId_Analyzer
                                                 AND Object_Employee.DescId = zc_Object_Founder()

       UNION
        -- 1.2.4. Уменьшили долг по ЗП
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_Employee.Id               AS ObjectId
             , Object_Employee.DescId           AS ObjectDescId
             , 1 * MIFloat_Overlimit.ValueData AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , View_InfoMoney.InfoMoneyGroupId
               -- Управленческие назначения
             , View_InfoMoney.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , View_InfoMoney.InfoMoneyId

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId
             , ObjectLink_Personal_Position.ChildObjectId            AS PositionId
             , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , _tmpItem.BranchId_ProfitLoss AS BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , lpInsertFind_Object_ServiceDate (inOperDate:= DATE_TRUNC ('MONTH', _tmpItem.OperDate)) AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , zc_Enum_AnalyzerId_MobileBills_Personal() AS AnalyzerId -- надо, т.к. это удержания с ЗП
             , 0 AS ObjectIntId_Analyzer -- не надо, т.к. 

             , NOT _tmpItem.IsActive -- всегда такая
             , FALSE AS IsMaster
        FROM _tmpItem
             INNER JOIN Object AS Object_Employee ON Object_Employee.Id     = _tmpItem.ObjectIntId_Analyzer
                                                 AND Object_Employee.DescId = zc_Object_Personal()
             INNER JOIN MovementItemFloat AS MIFloat_Overlimit
                                          ON MIFloat_Overlimit.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_Overlimit.DescId = zc_MIFloat_Overlimit()

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                  ON ObjectLink_Personal_Position.ObjectId = _tmpItem.ObjectIntId_Analyzer
                                 AND ObjectLink_Personal_Position.DescId   = zc_ObjectLink_Personal_Position()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = _tmpItem.ObjectIntId_Analyzer
                                 AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101() -- 60101 Заработная плата + Заработная плата

        WHERE MIFloat_Overlimit.ValueData <> 0
          AND ObjectLink_Unit_Contract.ChildObjectId IS NULL
       ;


     -- 5.0. ФИНИШ - если это "последний" документ - на основании него update - Discard
     IF COALESCE ((SELECT MAX (Movement.OperDate) FROM Movement WHERE Movement.DescId = zc_Movement_MobileBills() AND Movement.StatusId = zc_Enum_Status_Complete()), zc_DateStart())
        <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
     THEN
         PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MobileEmployee_Discard(), Object_MobileEmployee.Id, CASE WHEN MovementItem.ObjectId > 0 THEN FALSE ELSE TRUE END)
         FROM Object AS Object_MobileEmployee
              LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.ObjectId   = Object_MobileEmployee.Id
         WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee();

     END IF;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MobileBills()
                                , inUserId     := inUserId
                                 );


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.14                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_MobileBills (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
