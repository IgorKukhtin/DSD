-- Function: lpComplete_Movement_LossPersonal (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossPersonal (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossPersonal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- проверка
     IF NOT EXISTS (SELECT 1
                    FROM Movement
                    WHERE Movement.Id     = inMovementId
                      AND Movement.DescId = zc_Movement_LossPersonal()
                      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

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
        -- 1.1. долг сотруднику по ЗП
        SELECT Movement.DescId
             , Movement.OperDate
             , MovementItem.ObjectId     AS ObjectId
             , Object.DescId             AS ObjectDescId
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

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , COALESCE (MILinkObject_Unit.ObjectId, 0)                AS UnitId
             , COALESCE (MILinkObject_Position.ObjectId, 0)            AS PositionId
             , COALESCE (MILinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , COALESCE (MILinkObject_Branch.ObjectId, 0) AS BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений - есть
             , lpInsertFind_Object_ServiceDate (inOperDate:= MovementDate_ServiceDate.ValueData) AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0                     AS AnalyzerId           -- не надо, т.к. это обычная ЗП
             , MovementItem.ObjectId AS ObjectIntId_Analyzer -- надо, сохраним "оригинал"

             -- , CASE WHEN -1 * MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsActive -- всегда такая
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId

             LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                    ON MovementDate_ServiceDate.MovementId = Movement.Id
                                   AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Branch.DescId         = zc_MILinkObject_Branch()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                              ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

        WHERE Movement.Id         = inMovementId
          AND Movement.DescId     = zc_Movement_LossPersonal()
          AND Movement.StatusId   IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          AND MovementItem.Amount <> 0
       ;

     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION 'В документе не определен <Сотрудник>. Проведение невозможно.';
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
        -- 1.2.1. ОПиУ по ЗП (кроме перевыставления и Учредителя)
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

               -- Группы ОПиУ - Дополнительная прибыль
             , zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления - Списание задолженности по ЗП
             , zc_Enum_ProfitLossDirection_70500() AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId            -- используется, для аналитики WhereObjectId_Analyzer
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению
             , _tmpItem.BranchId_Balance AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0 AS AnalyzerId               -- не надо, т.к. это ОПиУ
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это ОПиУ
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId

       ;

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LossPersonal()
                                , inUserId     := inUserId
                                 );
                                 
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.02.18         * 
*/
