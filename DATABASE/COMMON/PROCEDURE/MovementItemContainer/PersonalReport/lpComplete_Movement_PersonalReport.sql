-- Function: lpComplete_Movement_PersonalReport (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalReport (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalReport(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS void
AS
$BODY$
  DECLARE vbBranchId_Member Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- для долга !!!определяется Филиал по Пользователю!!!, иначе всегда на Главном филиале
     vbBranchId_Member:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), zc_Branch_Basis());

     -- проверка
     PERFORM lpCheck_Movement_PersonalReport (inMovementId:= inMovementId, inComment:= 'проведен', inUserId:= inUserId);

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, CarId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        -- 1.1. долг Подотчет
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

               -- сформируем позже или...
             , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId
               -- сформируем позже или...
             , 0 AS AccountGroupId, 0 AS AccountDirectionId
             , COALESCE (Container. ObjectId, 0) AS AccountId
               -- здесь не используется
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- 

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

               -- Главное Юр.лицо: неоткуда взять
             , zc_Juridical_Basis()

             , 0 AS UnitId     -- не используется
               -- используется
             , COALESCE (CLO_Car.ObjectId, 0) AS CarId

               -- Филиал Баланс: !!!определяется Филиал по Пользователю!!!, иначе всегда на Главном филиале
             , CASE WHEN inMovementId = 8869232 /*3810 - 31.03.2018 - Івденко Андрій Леонідович*/
                         THEN 0
                    ELSE COALESCE (CLO_Branch.ObjectId, vbBranchId_Member)
               END AS BranchId_Balance

               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                        AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
             LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData :: Integer
             LEFT JOIN ContainerLinkObject AS CLO_Car
                                           ON CLO_Car.ContainerId = Container.Id
                                          AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
             LEFT JOIN ContainerLinkObject AS CLO_Branch
                                           ON CLO_Branch.ContainerId = Container.Id
                                          AND CLO_Branch.DescId      = zc_ContainerLinkObject_Branch()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_PersonalReport()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId <> zc_Object_Member())
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Подотчет (ФИО)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;
   

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, CarId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        -- 1.2.1. ОПиУ или Баланс-Рассчеты
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0
                    -- если установлен, будет 
                    ELSE COALESCE (MILinkObject_MoneyPlace.ObjectId, 0)
               END AS ObjectId

             , CASE -- сразу в ОПиУ - Инвестиции
                    WHEN _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                         THEN 0

                    ELSE COALESCE (Object.DescId, 0)
               END AS ObjectDescId

             , -1 * _tmpItem.OperSumm                             AS OperSumm
             , 0                                                  AS OperSumm_Asset

             , _tmpItem.MovementItemId                            AS MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                   -- сформируем позже
             , 0 AS AccountId                                                 -- сформируем позже

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

               -- Бизнес Баланс: всегда из предыдущей проводки (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: всегда из предыдущей проводки (а значение кстати неоткуда взять)
             , _tmpItem.JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)     AS UnitId
                -- используется - для ГСМ
             , CASE WHEN _tmpItem.ContainerId > 0 AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20401() THEN _tmpItem.CarId ELSE 0 END AS CarId

               -- Филиал Баланс: всегда из предыдущей проводки (нужен для НАЛ долгов) или у контрагента
             , COALESCE (ObjectLink_Partner_Branch.ChildObjectId, _tmpItem.BranchId_Balance)
               -- Филиал ОПиУ: всегда по подразделению !!!+ из предыдущей проводки!!!
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, _tmpItem.BranchId_ProfitLoss) AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId


                -- нет
             -- , (SELECT Object_Contract_View.ContractId FROM Object_Contract_View WHERE Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId AND Object_Contract_View.PaidKindId = zc_Enum_PaidKind_SecondForm() AND Object_Contract_View.isErased = FALSE AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close() ORDER BY Object_Contract_View.ContractId DESC LIMIT 1) AS ContractId
                -- появился
             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
               -- нет
             , zc_Enum_PaidKind_SecondForm() AS PaidKindId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                              ON MILinkObject_MoneyPlace.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

             LEFT JOIN Object ON Object.Id = MILinkObject_MoneyPlace.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch ON ObjectLink_Partner_Branch.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                              AND ObjectLink_Partner_Branch.DescId   = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MILinkObject_Unit.ObjectId
                                                                                                          AND (Object.Id IS NULL -- !!!нужен только для затрат!!!
                                                                                                            OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                                                                                                              )

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()
        -- !!!если НЕ перевыставление!!!
        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL
           -- или Рассчеты
           OR MILinkObject_MoneyPlace.ObjectId > 0


       UNION ALL
         -- 1.2.2. Перевыставление затрат на Юр Лицо
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId

             , -1 * _tmpItem.OperSumm                             AS OperSumm
             , 0                                                  AS OperSumm_Asset

             , _tmpItem.MovementItemId                            AS MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                   -- сформируем позже
             , 0 AS AccountId                                                 -- сформируем позже

               -- Группы ОПиУ
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , 0 AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: всегда из предыдущей проводки (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)     AS UnitId
                -- используется - для ГСМ
             , 0 AS CarId

               -- Филиал Баланс: всегда из предыдущей проводки (нужен для НАЛ долгов) или у контрагента
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению !!!+ из предыдущей проводки!!!
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

                -- появился
             , ObjectLink_Unit_Contract.ChildObjectId AS ContractId
               -- нет
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                              ON MILinkObject_MoneyPlace.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

        -- !!!если перевыставление!!!
        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0
          -- и НЕ Рассчеты
          AND MILinkObject_MoneyPlace.ObjectId IS NULL


       UNION ALL
        -- 2. забаланс
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate

             , COALESCE (MILinkObject_MoneyPlace.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0)                    AS ObjectDescId

             , 0                                                  AS OperSumm
             , -1 * _tmpItem.OperSumm                             AS OperSumm_Asset

             , _tmpItem.MovementItemId                            AS MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                   -- сформируем позже
             , 0 AS AccountId                                                 -- сформируем позже

               -- Группы ОПиУ
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , 0 AS ProfitLossDirectionId

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

               -- Главное Юр.лицо: всегда из предыдущей проводки (а значение кстати неоткуда взять)
             , _tmpItem.JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)     AS UnitId
                -- используется - для ГСМ
             , CASE WHEN _tmpItem.ContainerId > 0 AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20401() THEN _tmpItem.CarId ELSE 0 END AS CarId

               -- Филиал Баланс: всегда из предыдущей проводки (нужен для НАЛ долгов) или у контрагента
             , COALESCE (ObjectLink_Partner_Branch.ChildObjectId, _tmpItem.BranchId_Balance)
               -- Филиал ОПиУ: всегда по подразделению !!!+ из предыдущей проводки!!!
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, _tmpItem.BranchId_ProfitLoss) AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

               -- нет
               -- , (SELECT Object_Contract_View.ContractId FROM Object_Contract_View WHERE Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId AND Object_Contract_View.PaidKindId = zc_Enum_PaidKind_SecondForm() AND Object_Contract_View.isErased = FALSE AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close() ORDER BY Object_Contract_View.ContractId DESC LIMIT 1) AS ContractId
               -- появился
             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
               -- нет
             , zc_Enum_PaidKind_SecondForm() AS PaidKindId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                              ON MILinkObject_MoneyPlace.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

             LEFT JOIN Object ON Object.Id = MILinkObject_MoneyPlace.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch ON ObjectLink_Partner_Branch.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                              AND ObjectLink_Partner_Branch.DescId   = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MILinkObject_Unit.ObjectId
                                                                                                          AND Object.Id IS NULL -- !!!нужен только для затрат!!!
        WHERE _tmpItem.OperDate >= zc_DateStart_Asset() AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
          AND MILinkObject_MoneyPlace.ObjectId > 0
       ;


     -- проверка
     PERFORM lpCheck_Movement_PersonalReport (inMovementId:= -1 * ObjectDescId, inComment:= 'проведен', inUserId:= inUserId)
     FROM _tmpItem
     WHERE _tmpItem.IsMaster = FALSE
       AND NOT EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.ContainerId > 0)
      ;


     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalReport()
                                , inUserId     := inUserId
                                 );


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.09.14                                                        *
*/


-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 4139, inSession:= zfCalc_UserAdmin())
