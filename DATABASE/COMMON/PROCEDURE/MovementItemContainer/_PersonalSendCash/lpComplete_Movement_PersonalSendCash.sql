-- Function: lpComplete_Movement_PersonalSendCash (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalSendCash (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalSendCash (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalSendCash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbPersonalId_From Integer;

  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId_PersonalFrom Integer;
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.PersonalId_From
          , _tmp.JuridicalId_Basis, _tmp.BusinessId_PersonalFrom
            INTO vbPersonalId_From
               , vbJuridicalId_Basis, vbBusinessId_PersonalFrom -- эти аналитики берутся у подразделения за которым числится сотрудник (кто выдавал деньги)
     FROM (SELECT COALESCE (MovementLinkObject_Personal.ObjectId, 0)    AS PersonalId_From
                , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) AS JuridicalId_Basis
                , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0)  AS BusinessId_PersonalFrom
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                     ON ObjectLink_Personal_Unit.ObjectId = MovementLinkObject_Personal.ObjectId
                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Car_Unit()

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
                         , ContainerId_From, AccountId_From, ContainerId_To, AccountId_To, ContainerId_ProfitLoss, AccountId_ProfitLoss, PersonalId_To, CarId_To
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
            , _tmp.PersonalId_To
            , _tmp.CarId_To
            , _tmp.OperSumm
            , _tmp.ProfitLossGroupId      -- Группы ОПиУ
            , _tmp.ProfitLossDirectionId  -- Аналитики ОПиУ  - направления
            , _tmp.InfoMoneyDestinationId -- Управленческие назначения
            , _tmp.InfoMoneyId            -- Статьи назначения
              -- Бизнес для долг Сотрудника (Водитель) !!!не используется!!!
            , _tmp.BusinessId_PersonalTo
              -- Бизнес для Прибыль
            , _tmp.BusinessId_Route

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                   , MIDate_OperDate.ValueData AS OperDate
                   , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)       AS UnitId_ProfitLoss   -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на ObjectLink_Car_Unit, тогда затраты будут по принадлежности авто к подразделению
                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на ObjectLink_UnitCar_Branch, тогда затраты будут по принадлежности авто к подразделению
                   , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)       AS UnitId_Route
                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_Route
                   , MovementItem.ObjectId                     AS PersonalId_To
                   , COALESCE (MILinkObject_Car.ObjectId, 0)   AS CarId_To
                   , MovementItem.Amount AS OperSumm
                     -- Группы ОПиУ
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
                     -- Аналитики ОПиУ - направления
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
                     -- Управленческие назначения
                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- Статьи назначения
                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                     -- Бизнес для долг Сотрудника, эта аналитика берется у подразделения за которым числится сотрудник (кто получил деньги)
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
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                        ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                       AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                        ON ObjectLink_UnitRoute_Branch.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                        ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()
                   -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на ObjectLink_Car_Unit, тогда затраты будут по принадлежности авто к подразделению
                   LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = ObjectLink_Route_Unit.ChildObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_PersonalSendCash()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
         WHERE _tmp.OperSumm <> 0;


     -- для теста
     -- RETURN QUERY SELECT _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.JuridicalId_From, _tmpItem.isCorporate, _tmpItem.PersonalId_From, _tmpItem.UnitId, _tmpItem.BranchId_Unit, _tmpItem.PersonalId_Packer, _tmpItem.PaidKindId, _tmpItem.ContractId, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.OperCount, _tmpItem.tmpOperSumm_Partner, _tmpItem.OperSumm_Partner, _tmpItem.tmpOperSumm_Packer, _tmpItem.OperSumm_Packer, _tmpItem.AccountDirectionId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.InfoMoneyDestinationId_isCorporate, _tmpItem.InfoMoneyId_isCorporate, _tmpItem.JuridicalId_basis, _tmpItem.BusinessId                         , _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.PartionMovementId, _tmpItem.PartionGoodsId FROM _tmpItem;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. определяется Счет для проводок суммового учета по счету долг Сотрудника (Водитель)
     UPDATE _tmpItem SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
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


     -- 1.2.1. определяется ContainerId_To для проводок суммового учета по счету долг Сотрудника (Водитель)
     UPDATE _tmpItem SET ContainerId_To = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := _tmpItem_group.AccountId_To
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId_PersonalFrom
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Personal()
                                        , inObjectId_1        := _tmpItem_group.PersonalId_To
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := _tmpItem_group.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Car()
                                        , inObjectId_3        := _tmpItem_group.CarId_To
                                         ) AS ContainerId
                , _tmpItem_group.PersonalId_To
                , _tmpItem_group.CarId_To
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_To
                      , _tmpItem.PersonalId_To
                      , _tmpItem.CarId_To
                      , _tmpItem.InfoMoneyId
                 FROM _tmpItem
                 GROUP BY _tmpItem.AccountId_To
                        , _tmpItem.PersonalId_To
                        , _tmpItem.CarId_To
                        , _tmpItem.InfoMoneyId
                ) AS _tmpItem_group
          ) AS _tmpItem_byContainer
      WHERE _tmpItem.PersonalId_To = _tmpItem_byContainer.PersonalId_To
        AND _tmpItem.CarId_To      = _tmpItem_byContainer.CarId_To
        AND _tmpItem.InfoMoneyId   = _tmpItem_byContainer.InfoMoneyId;


     -- 1.2.2. определяется ContainerId_ProfitLoss для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem SET ContainerId_ProfitLoss = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_Route -- !!!подставляем Бизнес для Прибыль!!!
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                         ) AS ContainerId
                , _tmpItem_byProfitLoss.ProfitLossDirectionId
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_Route
           FROM (SELECT lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                      , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                      , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                      , inInfoMoneyId            := NULL
                                                      , inUserId                 := inUserId
                                                       ) AS ProfitLossId
                      , _tmpItem_group.ProfitLossDirectionId
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_Route
                 FROM (SELECT _tmpItem.ProfitLossGroupId
                            , _tmpItem.ProfitLossDirectionId
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_Route
                       FROM _tmpItem
                       WHERE _tmpItem.AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                       GROUP BY _tmpItem.ProfitLossGroupId
                              , _tmpItem.ProfitLossDirectionId
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_Route
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byContainer
      WHERE _tmpItem.ProfitLossDirectionId  = _tmpItem_byContainer.ProfitLossDirectionId
        AND _tmpItem.InfoMoneyDestinationId = _tmpItem_byContainer.InfoMoneyDestinationId
        AND _tmpItem.BusinessId_Route       = _tmpItem_byContainer.BusinessId_Route;

     -- 1.3. формируются Проводки суммового учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- по счету долг Сотрудника (Водитель)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem.MovementItemId, ContainerId_To, 0 AS ParentId, OperSumm, OperDate, TRUE AS IsActive FROM _tmpItem
      UNION ALL
       -- тут же списание с него по счету долг Сотрудника (Водитель) (!!!если Прибыль!!!)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem.MovementItemId, ContainerId_To, 0 AS ParentId, -1 * OperSumm, OperDate, FALSE AS IsActive
       FROM _tmpItem
       WHERE AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
      UNION ALL
       -- по счету Прибыль
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem.MovementItemId, ContainerId_ProfitLoss, 0 AS ParentId, OperSumm, OperDate, FALSE AS IsActive
       FROM _tmpItem
       WHERE AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
     ;


     -- 2.1. определяется Счет для проводок суммового учета по долг Сотрудника (От кого)
     UPDATE _tmpItem SET AccountId_From = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT _tmpItem.InfoMoneyDestinationId FROM _tmpItem GROUP BY _tmpItem.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.2. определяется ContainerId_From для проводок суммового учета по долг Сотрудника (От кого)
     UPDATE _tmpItem SET ContainerId_From = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := _tmpItem_group.AccountId_From
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId_PersonalFrom
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Personal()
                                        , inObjectId_1        := vbPersonalId_From
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := _tmpItem_group.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Car()
                                        , inObjectId_3        := 0 -- для Сотрудники(подотчетные лица) !!!имеено здесь последняя аналитика всегда значение = 0!!!
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

     -- 2.3. формируются Проводки суммового учета по долг Сотрудника (От кого)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_From, 0 AS ParentId, -1 * OperSumm, OperDate, FALSE
       FROM (SELECT _tmpItem.ContainerId_From
                  , _tmpItem.OperDate
                  , SUM (_tmpItem.OperSumm) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_From
                    , _tmpItem.OperDate
            ) AS _tmpItem_group;



     -- 3.1. формируются Проводки для отчета (Аналитики: Сотрудник (От кого) и Сотрудник (Водитель))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ContainerId_To
                                              , inPassiveContainerId := _tmpItem.ContainerId_From
                                              , inActiveAccountId    := _tmpItem.AccountId_To
                                              , inPassiveAccountId   := _tmpItem.AccountId_From
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ContainerId_To
                                                                                                    , inPassiveContainerId := _tmpItem.ContainerId_From
                                                                                                    , inActiveAccountId    := _tmpItem.AccountId_To
                                                                                                    , inPassiveAccountId   := _tmpItem.AccountId_From
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ContainerId_To
                                                                                                             , inPassiveContainerId := _tmpItem.ContainerId_From
                                                                                                             , inActiveAccountId    := _tmpItem.AccountId_To
                                                                                                             , inPassiveAccountId   := _tmpItem.AccountId_From
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM _tmpItem
     WHERE _tmpItem.OperSumm <> 0;


     -- 3.2. формируются Проводки для отчета (Аналитики: Сотрудник (Водитель) и ОПиУ)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ContainerId_ProfitLoss
                                              , inPassiveContainerId := _tmpItem.ContainerId_To
                                              , inActiveAccountId    := _tmpItem.AccountId_ProfitLoss
                                              , inPassiveAccountId   := _tmpItem.AccountId_To
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ContainerId_ProfitLoss
                                                                                                    , inPassiveContainerId := _tmpItem.ContainerId_To
                                                                                                    , inActiveAccountId    := _tmpItem.AccountId_ProfitLoss
                                                                                                    , inPassiveAccountId   := _tmpItem.AccountId_To
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ContainerId_ProfitLoss
                                                                                                             , inPassiveContainerId := _tmpItem.ContainerId_To
                                                                                                             , inActiveAccountId    := _tmpItem.AccountId_ProfitLoss
                                                                                                             , inPassiveAccountId   := _tmpItem.AccountId_To
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM _tmpItem
     WHERE _tmpItem.OperSumm <> 0
       AND AccountId_ProfitLoss = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
     ;


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

     -- 5.2. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_PersonalSendCash() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
