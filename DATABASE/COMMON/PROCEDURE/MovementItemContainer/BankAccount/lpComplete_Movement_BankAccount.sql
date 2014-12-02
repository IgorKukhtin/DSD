-- Function: lpComplete_Movement_BankAccount (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_BankAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_BankAccount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS void
--  RETURNS TABLE (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, ContainerId Integer, AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, JuridicalId_Basis Integer, UnitId Integer, ContractId Integer, PaidKindId Integer, IsActive Boolean)
AS
$BODY$
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency, OperSumm_Diff
                         , MovementItemId, ContainerId, ContainerId_Currency, ContainerId_Diff, ProfitLossId_Diff
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , MovementItem.Amount AS OperSumm
             , COALESCE (MovementFloat_AmountCurrency.ValueData, 0) AS OperSumm_Currency
             , 0 AS OperSumm_Diff
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS ContainerId_Currency                                            -- сформируем позже
             , 0 AS ContainerId_Diff, 0 AS ProfitLossId_Diff                        -- сформируем позже
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

               -- Главное Юр.лицо всегда из р/сч.
             , COALESCE (BankAccount_Juridical.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

               -- Валюта
             , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyId

             , CASE WHEN MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster

        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

             LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                     ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                    AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS BankAccount_Juridical ON BankAccount_Juridical.ObjectId = MovementItem.ObjectId
                                                          AND BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_BankAccount()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен расчетный счет.Проведение невозможно.';
     END IF;
   
     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.У расчетного счета не установлено главное юр лицо.Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency, OperSumm_Diff
                         , MovementItemId, ContainerId, ContainerId_Currency, ContainerId_Diff, ProfitLossId_Diff
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, COALESCE (MILinkObject_MoneyPlace.ObjectId, 0)) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , CASE WHEN _tmpItem.CurrencyId = zc_Enum_Currency_Basis()
                     AND _tmpItem.isActive = TRUE
                     AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                         THEN -1 * COALESCE (MovementFloat_Amount.ValueData, 0)
                    WHEN _tmpItem.CurrencyId = zc_Enum_Currency_Basis()
                         THEN -1 * _tmpItem.OperSumm
                    ELSE -1 * /*CASE WHEN _tmpItem.IsActive = TRUE THEN -1 ELSE 1 END*/ CAST (_tmpItem.OperSumm_Currency * MovementFloat_CurrencyPartnerValue.ValueData / MovementFloat_ParPartnerValue.ValueData AS NUMERIC (16, 2))
               END AS OperSumm
             , CASE WHEN Object.DescId IN (zc_Object_Juridical(), zc_Object_Partner())
                         THEN -1 * _tmpItem.OperSumm_Currency
                    ELSE 0
               END AS OperSumm_Currency
             , CASE WHEN _tmpItem.CurrencyId = zc_Enum_Currency_Basis()
                     AND _tmpItem.isActive = TRUE
                     AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                         THEN COALESCE (MovementFloat_Amount.ValueData, 0) - _tmpItem.OperSumm
                    WHEN _tmpItem.CurrencyId = zc_Enum_Currency_Basis()
                         THEN 0
                    ELSE -1 * _tmpItem.OperSumm + 1 * /*CASE WHEN _tmpItem.IsActive = TRUE THEN -1 ELSE 1 END*/ CAST (_tmpItem.OperSumm_Currency * MovementFloat_CurrencyPartnerValue.ValueData / MovementFloat_ParPartnerValue.ValueData AS NUMERIC (16, 2))
               END AS OperSumm_Diff
 
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS ContainerId_Currency                                      -- сформируем позже
             , 0 AS ContainerId_Diff                                          -- сформируем позже

             , CASE WHEN Object.DescId IN (zc_Object_BankAccount(), zc_Object_Cash())
                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                         THEN zc_Enum_ProfitLoss_80105() -- Разница при покупке/продаже валюты
                    ELSE zc_Enum_ProfitLoss_80103() -- Курсовая разница
               END AS ProfitLossId_Diff

             , 0 AS AccountGroupId, 0 AS AccountDirectionId                   -- сформируем позже

             , CASE WHEN Object.DescId IN (zc_Object_BankAccount(), zc_Object_Cash())
                         THEN zc_Enum_Account_110301() -- Транзит + расчетный счет
                    ELSE 0
               END AS AccountId -- ... или сформируем позже

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

               -- Бизнес Баланс: всегда из р/сч. (а значение кстати=0)
             , _tmpItem.BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из р/сч.
             , _tmpItem.JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: всегда из р/сч. (а значение кстати=0)
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss

               -- Месяц начислений: пока нет
             , 0 AS ServiceDateId

             , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
             , zc_Enum_PaidKind_FirstForm() AS PaidKindId -- Всегда БН

             , CASE WHEN Object.DescId IN (zc_Object_Juridical(), zc_Object_Partner())
                     AND _tmpItem.CurrencyId <> zc_Enum_Currency_Basis()
                     AND _tmpItem.isActive = FALSE
                     AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_41000() -- Покупка/продажа валюты
                         THEN zc_Enum_Currency_Basis() -- !!!меняется валюта!!!
                    WHEN Object.DescId IN (zc_Object_Juridical(), zc_Object_Partner())
                         THEN _tmpItem.CurrencyId
                    ELSE 0
               END AS CurrencyId

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementFloat AS MovementFloat_Amount
                                     ON MovementFloat_Amount.MovementId = inMovementId
                                    AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
             LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                     ON MovementFloat_CurrencyPartnerValue.MovementId = inMovementId
                                    AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
             LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                     ON MovementFloat_ParPartnerValue.MovementId = inMovementId
                                    AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                              ON MILinkObject_MoneyPlace.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

             LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                                  ON ObjectLink_Founder_InfoMoney.ChildObjectId = _tmpItem.InfoMoneyId
                                 AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()

             LEFT JOIN Object ON Object.Id = COALESCE (ObjectLink_Founder_InfoMoney.ObjectId, MILinkObject_MoneyPlace.ObjectId)
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = MILinkObject_Unit.ObjectId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = MILinkObject_Unit.ObjectId
                                                                                                          AND Object.Id IS NULL -- !!!нужен только для затрат!!!
       ;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_BankAccount()
                                , inUserId     := inUserId
                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.14                                        * add zc_ObjectLink_Founder_InfoMoney
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 22.01.14                                        * add IsMaster
 16.01.13                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_BankAccount (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
