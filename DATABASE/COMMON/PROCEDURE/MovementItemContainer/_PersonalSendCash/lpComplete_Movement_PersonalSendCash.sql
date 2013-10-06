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
  DECLARE vbOperDate TDateTime;
  DECLARE vbPersonalId_From Integer;

  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId Integer;
BEGIN

     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.OperDate
          , _tmp.PersonalId_From
          , _tmp.JuridicalId_Basis, _tmp.BusinessId
            INTO vbOperDate
               , vbPersonalId_From
               , vbJuridicalId_Basis, vbBusinessId
     FROM (SELECT Movement.OperDate
                , COALESCE (MovementLinkObject_Personal.ObjectId, 0)       AS PersonalId_From
                , COALESCE (MovementLinkObject_JuridicalBasis.ObjectId, 0) AS JuridicalId_Basis
                , COALESCE (MovementLinkObject_Business.ObjectId, 0)       AS BusinessId
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_JuridicalBasis
                                             ON MovementLinkObject_JuridicalBasis.MovementId = Movement.Id
                                            AND MovementLinkObject_JuridicalBasis.DescId = zc_MovementLinkObject_JuridicalBasis()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                             ON MovementLinkObject_Business.MovementId = Movement.Id
                                            AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_PersonalSendCash()
          ) AS _tmp;


     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, UnitId_ProfitLoss Integer
                               , ContainerId_From Integer, AccountId_From Integer, ContainerId_To Integer, AccountId_To Integer, PersonalId_To Integer, CarId_To Integer
                               , OperSumm TFloat
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Route Integer
                                ) ON COMMIT DROP;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, UnitId_ProfitLoss
                         , ContainerId_From, AccountId_From, ContainerId_To, AccountId_To, PersonalId_To, CarId_To
                         , OperSumm
                         , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Route
                          )
        SELECT
              _tmp.MovementItemId
            , _tmp.UnitId_ProfitLoss
            , 0 AS ContainerId_From -- сформируем позже
            , 0 AS AccountId_From   -- сформируем позже
            , 0 AS ContainerId_To   -- сформируем позже
            , 0 AS AccountId_To     -- сформируем позже
            , _tmp.PersonalId_To
            , _tmp.CarId_To
            , _tmp.OperSumm
            , _tmp.ProfitLossGroupId      -- Группы ОПиУ
            , _tmp.ProfitLossDirectionId  -- Аналитики ОПиУ  - направления
            , _tmp.InfoMoneyDestinationId -- Управленческие назначения
            , _tmp.InfoMoneyId            -- Статьи назначения
              -- Бизнес для долг Сотрудника (Водитель) или Прибыль
            , _tmp.BusinessId_Route

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                   , ObjectLink_Route_Unit.ChildObjectId     AS UnitId_ProfitLoss
                   , MovementItem.ObjectId                   AS PersonalId_To
                   , COALESCE (MILinkObject_Car.ObjectId, 0) AS CarId_To
                   , MovementItem.Amount AS OperSumm
                     -- Группы ОПиУ
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
                     -- Аналитики ОПиУ - направления
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
                     -- Управленческие назначения
                   , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- Статьи назначения
                   , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                     -- Бизнес для долг Сотрудника (Водитель) или Прибыль
                   , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_Route

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                    ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                   -- здесь нужны все
                   LEFT JOIN lfSelect_Object_InfoMoney () AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                    ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                        ON ObjectLink_Route_Unit.ObjectId = MILinkObject_Route.ObjectId
                                       AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                        ON ObjectLink_Unit_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
                   -- здесь нужны все
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

     -- 1.1. определяется Счет для проводок суммового учета по долг Сотрудника (Водитель) или Прибыль
     UPDATE _tmpItem SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN InfoMoneyId = zc_Enum_InfoMoney_20401() -- 20401; "ГСМ";
                            THEN lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                                            , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
                                                            , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                            , inInfoMoneyId            := NULL
                                                            , inUserId                 := inUserId
                                                             )
                       ELSE zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                  END AS AccountId
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId FROM _tmpItem GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyId = _tmpItem_byAccount.InfoMoneyId;


     -- 1.2. определяется ContainerId_To для проводок суммового учета по долг Сотрудника (Водитель) или Прибыль
     UPDATE _tmpItem SET ContainerId_To = _tmpItem_byContainer.ContainerId
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := _tmpItem_group.AccountId_To
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                                                 -- !!!подставляем Бизнес для долг Сотрудника (Водитель) или Прибыль!!!
                                        , inBusinessId        := _tmpItem_group.BusinessId_Route
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Personal()
                                        , inObjectId_1        := _tmpItem_group.PersonalId_To
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := _tmpItem_group.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Car()
                                        , inObjectId_3        := _tmpItem_group.CarId_To
                                         ) AS ContainerId
                , _tmpItem_group.MovementItemId
           FROM (SELECT _tmpItem.MovementItemId
                      , _tmpItem.AccountId_To
                      , _tmpItem.PersonalId_To
                      , _tmpItem.CarId_To
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_Route
                 FROM _tmpItem
                 GROUP BY _tmpItem.MovementItemId
                        , _tmpItem.AccountId_To
                        , _tmpItem.PersonalId_To
                        , _tmpItem.CarId_To
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_Route
                ) AS _tmpItem_group
          ) AS _tmpItem_byContainer
      WHERE _tmpItem.MovementItemId = _tmpItem_byContainer.MovementItemId;

     -- 1.3. формируются Проводки суммового учета по долг Сотрудника (Водитель) или Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem.MovementItemId, ContainerId_To, 0 AS ParentId, OperSumm, vbOperDate
            , CASE WHEN AccountId_To = zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                       THEN FALSE
                   ELSE TRUE
              END AS IsActive
       FROM _tmpItem;


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
                                        , inBusinessId        := vbBusinessId
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
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_From, 0 AS ParentId, -1 * OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItem.ContainerId_From
                  , SUM (_tmpItem.OperSumm) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_From
            ) AS _tmpItem_group;



     -- 3. формируются Проводки для отчета (Аналитики: Товар и ОПиУ - разнице в весе)
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
                                              , inOperDate := vbOperDate
                                               )
     FROM _tmpItem
     WHERE _tmpItem.OperSumm <> 0;


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
 06.10.13                                        * add inUserId
 03.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149721, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_PersonalSendCash (inMovementId:= 149721, inUserId:= 2)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149721, inSession:= '2')
