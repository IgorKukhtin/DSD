-- Function: lpComplete_Movement_FounderService (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_FounderService (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_FounderService(
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
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId
                         , IsActive, IsMaster
                          )
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения - не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения - не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения - не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0  AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , 0 AS AnalyzerId

             , CASE WHEN -1 * MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId IN (zc_Movement_FounderService())
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 OR _tmpItem.ObjectDescId NOT IN (zc_Object_Founder()))
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Учредитель> . Проведение невозможно.';
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
             , zc_Enum_Account_100301() AS ObjectId -- Собственный капитал + Прибыль текущего периода
             , zc_Object_Account()      AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId                         -- сформируем позже
             , zc_Enum_Account_100301() AS AccountId                                -- Собственный капитал + Прибыль текущего периода

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения - не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения - не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения - не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0  AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо - из предыдущей проводки
             , _tmpItem.JuridicalId_Basis

             , 0 AS UnitId -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , TRUE AS IsActive -- NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
       ;


     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_FounderService()
                                , inUserId     := inUserId
                                 );


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.09.14         *

*/


-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 4139, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 4139, inSession:= zfCalc_UserAdmin())
