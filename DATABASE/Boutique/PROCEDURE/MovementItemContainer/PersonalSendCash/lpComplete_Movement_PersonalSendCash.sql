-- Function: lpComplete_Movement_PersonalSendCash (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalSendCash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalSendCash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbMemberId_From Integer;
  DECLARE vbUnitId_Forwarding Integer;

  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId_PersonalFrom Integer;
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.MovementDescId
          , _tmp.MemberId_From, _tmp.UnitId_Forwarding
          , _tmp.JuridicalId_Basis, _tmp.BusinessId_PersonalFrom
            INTO vbMovementDescId
               , vbMemberId_From, vbUnitId_Forwarding
               , vbJuridicalId_Basis, vbBusinessId_PersonalFrom -- эти аналитики берутся у подразделения за которым числится сотрудник (кто выдавал деньги)
     FROM (SELECT Movement.DescId AS MovementDescId
                , COALESCE (ObjectLink_Personal_Member.ChildObjectId, 0)   AS MemberId_From
                , COALESCE (MovementLinkObject_UnitForwarding.ObjectId, 0) AS UnitId_Forwarding
                , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0)    AS JuridicalId_Basis
                , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0)     AS BusinessId_PersonalFrom
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                             ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                            AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                     ON ObjectLink_Personal_Unit.ObjectId = MovementLinkObject_Personal.ObjectId
                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = MovementLinkObject_Personal.ObjectId
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                     ON ObjectLink_Unit_Business.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                    AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()

           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_PersonalSendCash()
          ) AS _tmp;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, OperDate, UnitId_ProfitLoss, BranchId_ProfitLoss, UnitId_Route, BranchId_Route
                         , ContainerId_From, AccountId_From, ContainerId_To, AccountId_To, ContainerId_ProfitLoss, AccountId_ProfitLoss, MemberId_To, CarId_To
                         , OperSumm
                         , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_PersonalTo, BusinessId_Route
                          )
        SELECT
              _tmp.MovementItemId
            , _tmp.OperDate
            , _tmp.UnitId_ProfitLoss
            , _tmp.BranchId_ProfitLoss
            , _tmp.UnitId_Route
            , _tmp.BranchId_Route
            , 0 AS ContainerId_From -- сформируем позже
            , 0 AS AccountId_From   -- сформируем позже
            , 0 AS ContainerId_To   -- сформируем позже
            , 0 AS AccountId_To     -- сформируем позже
            , 0 AS ContainerId_ProfitLoss   -- сформируем позже
            , 0 AS AccountId_ProfitLoss     -- сформируем позже
            , _tmp.MemberId_To
            , _tmp.CarId_To
            , _tmp.OperSumm
            , _tmp.ProfitLossGroupId      -- Группы ОПиУ
            , _tmp.ProfitLossDirectionId  -- Аналитики ОПиУ  - направления
            , _tmp.InfoMoneyDestinationId -- Управленческие назначения
            , _tmp.InfoMoneyId            -- Статьи назначения
              -- Бизнес для долг Физ.лица (Водитель) !!!не используется!!!
            , _tmp.BusinessId_PersonalTo
              -- Бизнес для Прибыль
            , _tmp.BusinessId_Route

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                   , MIDate_OperDate.ValueData AS OperDate
                   -- , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)       AS UnitId_ProfitLoss   -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на ObjectLink_Car_Unit, тогда затраты будут по принадлежности авто к подразделению
                   -- , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на ObjectLink_UnitCar_Branch, тогда затраты будут по принадлежности авто к подразделению
                   , CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                               THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- если "пустой" филиал, тогда затраты по принадлежности маршрута к подразделению
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению
                          ELSE vbUnitId_Forwarding -- иначе Подразделение (Место отправки)
                     END AS UnitId_ProfitLoss
                   , CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению и к филиалу
                          ELSE 0 -- иначе затраты без принадлежности к филиалу
                     END AS BranchId_ProfitLoss
                   , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)       AS UnitId_Route
                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_Route
                   , COALESCE (ObjectLink_Personal_Member.ChildObjectId, 0)  AS MemberId_To
                   , COALESCE (MILinkObject_Car.ObjectId, 0)                 AS CarId_To
                   , MovementItem.Amount AS OperSumm
                     -- Группы ОПиУ
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
                     -- Аналитики ОПиУ - направления
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
                     -- Управленческие назначения
                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- Статьи назначения
                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                     -- Бизнес для долг Физ.лица, эта аналитика берется у подразделения за которым числится сотрудник (кто получил деньги)
                   , COALESCE (ObjectLink_UnitPersonal_Business.ChildObjectId, 0) AS BusinessId_PersonalTo
                     -- Бизнес для Прибыль, эта аналитика всегда берется по принадлежности маршрута к подразделению
                   , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId_Route

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                   LEFT JOIN MovementItemDate AS MIDate_OperDate
                                              ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                             AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                    ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                   LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                        ON ObjectLink_Car_Unit.ObjectId = MILinkObject_Car.ObjectId
                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Branch
                                        ON ObjectLink_UnitCar_Branch.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                       AND ObjectLink_UnitCar_Branch.DescId = zc_ObjectLink_Unit_Branch()

                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                        ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                        ON ObjectLink_Personal_Unit.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonal_Business
                                        ON ObjectLink_UnitPersonal_Business.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonal_Business.DescId = zc_ObjectLink_Unit_Business()

                   -- здесь нужны все
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                    ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Branch
                                        ON ObjectLink_Route_Branch.ObjectId = MILinkObject_Route.ObjectId
                                       AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                        ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                       AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                        ON ObjectLink_UnitRoute_Branch.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                        ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()
                   -- для затрат
                   LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId
                   = CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                               THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- если "пустой" филиал, тогда затраты по принадлежности маршрута к подразделению
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению
                          ELSE vbUnitId_Forwarding -- иначе Подразделение (Место отправки)
                     END

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_PersonalSendCash()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
         WHERE _tmp.OperSumm <> 0;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. определяется Счет для проводок суммового учета по счету долг Физ.лица (Водитель)
     UPDATE _tmpItem SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- Физ.лица (подотчетные лица)
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId FROM _tmpItem GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyId = _tmpItem_byAccount.InfoMoneyId;


     -- 1.1.2. определяется Счет для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
     WHERE _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_21201() -- 21201; "Коммандировочные";
     ;


     -- 1.2.1. определяется ContainerId_To для проводок суммового учета по счету долг Физ.лица (Водитель)
     UPDATE _tmpItem SET ContainerId_To = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := _tmpItem_group.AccountId_To
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId_PersonalFrom
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                        , inObjectId_1        := _tmpItem_group.MemberId_To
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := _tmpItem_group.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_3        := zc_Branch_Basis()
                                        , inDescId_4          := zc_ContainerLinkObject_Car()
                                        , inObjectId_4        := _tmpItem_group.CarId_To
                                         ) AS ContainerId
                , _tmpItem_group.MemberId_To
                , _tmpItem_group.CarId_To
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_To
                      , _tmpItem.MemberId_To
                      , _tmpItem.CarId_To
                      , _tmpItem.InfoMoneyId
                 FROM _tmpItem
                 GROUP BY _tmpItem.AccountId_To
                        , _tmpItem.MemberId_To
                        , _tmpItem.CarId_To
                        , _tmpItem.InfoMoneyId
                ) AS _tmpItem_group
          ) AS _tmpItem_byContainer
      WHERE _tmpItem.MemberId_To = _tmpItem_byContainer.MemberId_To
        AND _tmpItem.CarId_To      = _tmpItem_byContainer.CarId_To
        AND _tmpItem.InfoMoneyId   = _tmpItem_byContainer.InfoMoneyId;


     -- 1.2.2. определяется ContainerId_ProfitLoss для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ContainerId_ProfitLoss = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_Route -- !!!подставляем Бизнес для Прибыль!!!
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := _tmpItem_byProfitLoss.BranchId_ProfitLoss -- !!!подставляем Филиал для Прибыль!!!
                                         ) AS ContainerId
                , _tmpItem_byProfitLoss.ProfitLossDirectionId
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_Route
                , _tmpItem_byProfitLoss.BranchId_ProfitLoss
           FROM (SELECT lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                      , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                      , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                      , inInfoMoneyId            := NULL
                                                      , inUserId                 := inUserId
                                                       ) AS ProfitLossId
                      , _tmpItem_group.ProfitLossDirectionId
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_Route
                      , _tmpItem_group.BranchId_ProfitLoss
                 FROM (SELECT _tmpItem.ProfitLossGroupId
                            , _tmpItem.ProfitLossDirectionId
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_Route
                            , _tmpItem.BranchId_ProfitLoss
                       FROM _tmpItem
                       WHERE _tmpItem.AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                       GROUP BY _tmpItem.ProfitLossGroupId
                              , _tmpItem.ProfitLossDirectionId
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_Route
                              , _tmpItem.BranchId_ProfitLoss
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byContainer
      WHERE _tmpItem.ProfitLossDirectionId  = _tmpItem_byContainer.ProfitLossDirectionId
        AND _tmpItem.InfoMoneyDestinationId = _tmpItem_byContainer.InfoMoneyDestinationId
        AND _tmpItem.BusinessId_Route       = _tmpItem_byContainer.BusinessId_Route
        AND _tmpItem.BranchId_ProfitLoss    = _tmpItem_byContainer.BranchId_ProfitLoss;

     -- 1.3. формируются Проводки суммового учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- по счету долг Физ.лица (Водитель)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , ContainerId_To
            , AccountId_To                            AS AccountId              -- счет есть всегда
            , 0                                       AS AnalyzerId             -- нет аналитики
            , MemberId_To                             AS ObjectId_Analyzer      -- Физ лицо
            , CarId_To                                AS WhereObjectId_Analyzer -- !!!Автомобиль!!! а можно было б и Подразделение
            , ContainerId_From                        AS ContainerId_Analyzer   -- Контейнер-Корреспондент
            , UnitId_ProfitLoss                       AS ObjectIntId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , OperSumm
            , OperDate
            , CASE WHEN OperSumm > 0 THEN TRUE ELSE FALSE END AS IsActive
       FROM _tmpItem
      UNION ALL
       -- тут же списание с него по счету долг Физ.лица (Водитель) (!!!если Прибыль!!!)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , ContainerId_To
            , AccountId_To                            AS AccountId              -- счет есть всегда
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- относится к ОПиУ
            , MemberId_To                             AS ObjectId_Analyzer      -- Физ лицо
            , CarId_To                                AS WhereObjectId_Analyzer -- !!!Автомобиль!!! а можно было б и Подразделение
            , ContainerId_ProfitLoss                  AS ContainerId_Analyzer   -- статья ОПиУ
            , UnitId_ProfitLoss                       AS ObjectIntId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , BranchId_ProfitLoss                     AS ObjectExtId_Analyzer   -- Филиал (ОПиУ), а могло быть BranchId_Route
            , 0                                       AS ParentId
            , -1 * OperSumm
            , OperDate
            , CASE WHEN -1 * OperSumm > 0 THEN TRUE ELSE FALSE END AS IsActive
       FROM _tmpItem
       WHERE AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
      UNION ALL
       -- по счету Прибыль
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId              -- прибыль текущего периода
            , 0                                       AS AnalyzerId             -- в ОПиУ не нужена аналитика, т.к. большинство отчетов строится на AnalyzerId <> 0
            , MemberId_To                             AS ObjectId_Analyzer      -- Физ лицо
            , CarId_To                                AS WhereObjectId_Analyzer -- !!!Автомобиль!!! а можно было б и Подразделение
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , UnitId_ProfitLoss                       AS ObjectIntId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , BranchId_ProfitLoss                     AS ObjectExtId_Analyzer   -- Филиал (ОПиУ), а могло быть BranchId_Route
            , 0                                       AS ParentId
            , OperSumm
            , OperDate
            , FALSE                                   AS IsActive               -- !!!ОПиУ всегда по Кредиту!!!
       FROM _tmpItem
       WHERE AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
     ;


     -- 2.1. определяется Счет для проводок суммового учета по долг Физ.лица (От кого)
     UPDATE _tmpItem SET AccountId_From = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- Физ.лица (подотчетные лица)
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT _tmpItem.InfoMoneyDestinationId FROM _tmpItem GROUP BY _tmpItem.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.2. определяется ContainerId_From для проводок суммового учета по долг Физ.лица (От кого)
     UPDATE _tmpItem SET ContainerId_From = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := _tmpItem_group.AccountId_From
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId_PersonalFrom
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                        , inObjectId_1        := vbMemberId_From
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := _tmpItem_group.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_3        := zc_Branch_Basis()
                                        , inDescId_4          := zc_ContainerLinkObject_Car()
                                        , inObjectId_4        := 0 -- для Физ.лица (подотчетные лица) !!!именно здесь последняя аналитика всегда значение = 0!!!
                                         ) AS ContainerId
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_From
                      , _tmpItem.InfoMoneyId
                 FROM _tmpItem
                 GROUP BY _tmpItem.AccountId_From
                        , _tmpItem.InfoMoneyId
                ) AS _tmpItem_group
          ) AS _tmpItem_byContainer
      WHERE _tmpItem.InfoMoneyId = _tmpItem_byContainer.InfoMoneyId;

     -- 2.3. формируются Проводки суммового учета по долг Физ.лица (От кого) + !!!добавлен MovementItemId!!! + !!!добавлен ContainerId_To!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , ContainerId_From
            , AccountId_From                          AS AccountId              -- счет есть всегда
            , 0                                       AS AnalyzerId             -- нет аналитики
            , vbMemberId_From                         AS ObjectId_Analyzer      -- Физ лицо
            , 0                                       AS WhereObjectId_Analyzer -- т.к. у Физ.лица нет Подразделения
            , ContainerId_To                          AS ContainerId_Analyzer   -- Контейнер-Корреспондент
            , 0                                       AS ParentId
            , -1 * OperSumm
            , OperDate
            , CASE WHEN -1 * OperSumm > 0 THEN TRUE ELSE FALSE END AS IsActive
       FROM _tmpItem;


     -- 3.1. формируются Проводки для отчета (Аналитики: Физ.лицо (От кого) и Физ.лицо (Водитель))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                              )
                                              , inAmount   := _tmpItem.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM (SELECT CASE WHEN _tmpItem.OperSumm > 0 THEN _tmpItem.ContainerId_To ELSE _tmpItem.ContainerId_From END AS ActiveContainerId
                , CASE WHEN _tmpItem.OperSumm < 0 THEN _tmpItem.ContainerId_To ELSE _tmpItem.ContainerId_From END AS PassiveContainerId
                , CASE WHEN _tmpItem.OperSumm > 0 THEN _tmpItem.AccountId_To ELSE _tmpItem.AccountId_From END AS ActiveAccountId
                , CASE WHEN _tmpItem.OperSumm < 0 THEN _tmpItem.AccountId_To ELSE _tmpItem.AccountId_From END AS PassiveAccountId
                , ABS (_tmpItem.OperSumm) AS OperSumm
                , _tmpItem.MovementItemId
                , _tmpItem.OperDate
           FROM _tmpItem
           WHERE _tmpItem.OperSumm <> 0
          ) AS _tmpItem;


     -- 3.2. формируются Проводки для отчета (Аналитики: Физ.лицо (Водитель) и ОПиУ)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                              )
                                              , inAmount   := _tmpItem.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM (SELECT CASE WHEN _tmpItem.OperSumm > 0 THEN _tmpItem.ContainerId_ProfitLoss ELSE _tmpItem.ContainerId_To END AS ActiveContainerId
                , CASE WHEN _tmpItem.OperSumm < 0 THEN _tmpItem.ContainerId_ProfitLoss ELSE _tmpItem.ContainerId_To END AS PassiveContainerId
                , CASE WHEN _tmpItem.OperSumm > 0 THEN _tmpItem.AccountId_ProfitLoss ELSE _tmpItem.AccountId_To END AS ActiveAccountId
                , CASE WHEN _tmpItem.OperSumm < 0 THEN _tmpItem.AccountId_ProfitLoss ELSE _tmpItem.AccountId_To END AS PassiveAccountId
                , ABS (_tmpItem.OperSumm) AS OperSumm
                , _tmpItem.MovementItemId
                , _tmpItem.OperDate
           FROM _tmpItem
           WHERE _tmpItem.OperSumm <> 0
             AND _tmpItem.AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
          ) AS _tmpItem;


     -- !!!4.1. формируются свойства в документе из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JuridicalBasis(), inMovementId, vbJuridicalId_Basis);
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Business(), inMovementId, vbBusinessId_PersonalFrom);

     -- !!!4.2. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), tmp.MovementItemId, tmp.UnitId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, tmp.BranchId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_UnitRoute(), tmp.MovementItemId, tmp.UnitId_Route)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BranchRoute(), tmp.MovementItemId, tmp.BranchId_Route)
     FROM (SELECT _tmpItem.MovementItemId, _tmpItem.UnitId_ProfitLoss, _tmpItem.BranchId_ProfitLoss, _tmpItem.UnitId_Route, _tmpItem.BranchId_Route
           FROM _tmpItem
           WHERE AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
           GROUP BY _tmpItem.MovementItemId, _tmpItem.UnitId_ProfitLoss, _tmpItem.BranchId_ProfitLoss, _tmpItem.UnitId_Route, _tmpItem.BranchId_Route
          UNION ALL
           SELECT _tmpItem.MovementItemId, 0 AS UnitId_ProfitLoss, 0 AS BranchId_ProfitLoss, 0 AS UnitId_Route, 0 AS BranchId_Route
           FROM _tmpItem
           WHERE AccountId_ProfitLoss <> zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
           GROUP BY _tmpItem.MovementItemId, _tmpItem.UnitId_ProfitLoss, _tmpItem.BranchId_ProfitLoss, _tmpItem.UnitId_Route, _tmpItem.BranchId_Route
          ) AS tmp;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalSendCash()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.09.14                                        * add zc_ContainerLinkObject_Branch
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 26.01.14                                        * правильные проводки по филиалу
 21.12.13                                        * Personal -> Member
 14.11.13                                        * add calc ActiveContainerId and PassiveContainerId
 04.11.13                                        * add OperDate
 03.11.13                                        * err
 02.11.13                                        * идеологически правильный lpComplete_Movement_PersonalSendCash
 02.11.13                                        * add zc_MILinkObject_Branch, zc_MILinkObject_UnitRoute, zc_MILinkObject_BranchRoute
 29.10.13                                        * add !!!обязательно!!! очистили таблицу...
 14.10.13                                        * add lpInsertUpdate_MovementItemLinkObject
 06.10.13                                        * add inUserId
 03.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 601, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_PersonalSendCash (inMovementId:= 601, inUserId:= 2)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 601, inSession:= '2')
