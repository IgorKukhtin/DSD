-- Function: lpComplete_Movement_PersonalService (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalService(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_check Integer;
BEGIN
     -- таблица - по документам, для lpComplete_Movement_PersonalService_Recalc
     CREATE TEMP TABLE _tmpMovement_Recalc (MovementId Integer, StatusId Integer) ON COMMIT DROP;
     -- таблица - по элементам, для lpComplete_Movement_PersonalService_Recalc
     CREATE TEMP TABLE _tmpMI_Recalc (MovementId_from Integer, MovementItemId_from Integer, MovementItemId_to Integer, SummCardRecalc TFloat) ON COMMIT DROP;


     -- Проверка - других быть не должно
     vbMovementId_check:= (SELECT MovementDate_ServiceDate.MovementId
                           FROM (SELECT MovementDate.MovementId     AS MovementId
                                      , MovementDate.ValueData      AS ServiceDate
                                      , MovementLinkObject.ObjectId AS PersonalServiceListId
                                 FROM MovementDate
                                      LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate.MovementId
                                                                  AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()
                                 WHERE MovementDate.MovementId = inMovementId
                                   AND MovementDate.DescId = zc_MIDate_ServiceDate()
                                 ) tmpMovement
                                INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                        ON MovementDate_ServiceDate.ValueData = tmpMovement.ServiceDate
                                                       AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                       AND MovementDate_ServiceDate.MovementId <> tmpMovement.MovementId
                                INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                              ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                             AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                             AND MovementLinkObject_PersonalServiceList.ObjectId = tmpMovement.PersonalServiceListId
                           LIMIT 1
                          );
     IF vbMovementId_check <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Найдена другая <Ведомость начисления> № <%> от <%> для <%> за <%>.Дублирование запрещено.', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                                                                                                                           , DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                                                                                                                           , lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = vbMovementId_check AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()))
                                                                                                                           , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = vbMovementId_check AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     END IF;


     -- распределение !!!если это БН!!! - <Сумма на карточку (БН) для распределения>
     PERFORM lpComplete_Movement_PersonalService_Recalc (inMovementId := inMovementId
                                                       , inUserId     := inUserId);


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
                         , IsActive, IsMaster
                          )
        -- 1.1. долг сотруднику по ЗП
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
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

             , COALESCE (MILinkObject_Unit.ObjectId, 0)                      AS UnitId
             , COALESCE (MILinkObject_Position.ObjectId, 0)                  AS PositionId
             , COALESCE (MovementLinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , CASE WHEN View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_60000() -- Заработная плата
                         THEN lpInsertFind_Object_ServiceDate (inOperDate:= MovementDate_ServiceDate.ValueData)
                    ELSE 0
               END AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , CASE WHEN -1 * MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

             LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                    ON MovementDate_ServiceDate.MovementId = Movement.Id
                                   AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                          ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                         AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = MILinkObject_Unit.ObjectId
                                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_PersonalService()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
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
                         , IsActive, IsMaster
                          )
         -- 1.2.1. ОПиУ по ЗП
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * _tmpItem.OperSumm
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
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , 0 AS UnitId                -- не используется
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

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId
        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL
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
        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0
       ;

/*
     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     -- 2.1. долг сотруднику по Соц.Выпл
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
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId
             , -1 * (COALESCE (MIFloat_SummSocialIn.ValueData, 0) + COALESCE (MIFloat_SummSocialAdd.ValueData, 0)) AS OperSumm
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
             , _tmpItem.PositionId

               -- Филиал Баланс: всегда по подразделению
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , _tmpItem.ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , FALSE AS IsActive
             , TRUE AS IsMaster
        FROM _tmpItem
              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                          ON MIFloat_SummSocialIn.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                          ON MIFloat_SummSocialAdd.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()                                     
              LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60103() -- Заработная плата + Алименты
       ;
*/

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalService()
                                , inUserId     := inUserId
                                 );

     -- 6. ФИНИШ - распределение !!!если это НЕ БН!!! и находим !!!ведомости БН!!!
     PERFORM lpComplete_Movement_PersonalService_Recalc (inMovementId := tmpMovement.MovementId
                                                       , inUserId     := inUserId)
     FROM (SELECT Movement.Id AS MovementId
           FROM
          (SELECT MovementDate_ServiceDate.ValueData AS ServiceDate
           FROM Movement
                LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                       ON MovementDate_ServiceDate.MovementId = Movement.Id
                                      AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                              ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                             AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                             AND MovementLinkObject_PersonalServiceList.ObjectId NOT IN (293716 -- Ведомость карточки БН Фидо
                                                                                                       , 413454 -- Ведомость карточки БН Пиреус
                                                                                                        )
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_PersonalService()
             AND Movement.StatusId = zc_Enum_Status_Complete()
          ) AS tmpMovement
          INNER JOIN MovementDate AS MovementDate_ServiceDate
                                  ON MovementDate_ServiceDate.ValueData = tmpMovement.ServiceDate
                                 AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
          INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                        ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                       AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                       AND MovementLinkObject_PersonalServiceList.ObjectId IN (293716 -- Ведомость карточки БН Фидо
                                                                                             , 413454 -- Ведомость карточки БН Пиреус
                                                                                              )
          INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                             AND Movement.DescId = zc_Movement_PersonalService()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
          LIMIT 1
          ) AS tmpMovement
    ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.14                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
