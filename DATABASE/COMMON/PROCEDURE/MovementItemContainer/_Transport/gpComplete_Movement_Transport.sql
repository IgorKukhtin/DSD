-- Function: gpComplete_Movement_Transport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbCarId Integer;
  DECLARE vbBranchId Integer;

  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId Integer;

BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Transport());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.OperDate
          , _tmp.CarId, _tmp.BranchId
          , _tmp.JuridicalId_Basis, _tmp.BusinessId
            INTO vbOperDate
               , vbCarId, vbBranchId
               , vbJuridicalId_Basis, vbBusinessId
     FROM (SELECT Movement.OperDate
                , MovementLinkObject_Car.ObjectId AS CarId
                , COALESCE (ObjectLink_UnitCar_Branch.ChildObjectId, 0)    AS BranchId
                , COALESCE (ObjectLink_UnitCar_Juridical.ChildObjectId, 0) AS JuridicalId_Basis
                , COALESCE (ObjectLink_UnitCar_Business.ChildObjectId, 0)  AS BusinessId
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                             ON MovementLinkObject_Car.MovementId = Movement.Id
                                            AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                     ON ObjectLink_Car_Unit.ObjectId = MovementLinkObject_Car.ObjectId
                                    AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Branch
                                     ON ObjectLink_UnitCar_Branch.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Juridical
                                     ON ObjectLink_UnitCar_Juridical.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Business
                                     ON ObjectLink_UnitCar_Business.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Business.DescId = zc_ObjectLink_Unit_Business()
           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_Transport()
          ) AS _tmp;


     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, UnitId_ProfitLoss Integer
                               , ContainerId_Goods Integer, GoodsId Integer, AssetId Integer
                               , OperCount TFloat
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, BusinessId_ProfitLoss Integer
                                ) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, UnitId_ProfitLoss
                         , ContainerId_Goods, GoodsId, AssetId
                         , OperCount
                         , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, BusinessId_ProfitLoss
                          )
        SELECT
              _tmp.MovementItemId
            , _tmp.UnitId_ProfitLoss
            , 0 AS ContainerId_Goods -- сформируем позже
            , _tmp.GoodsId
            , _tmp.AssetId
            , _tmp.OperCount
            , _tmp.ProfitLossGroupId      -- Группы ОПиУ
            , _tmp.ProfitLossDirectionId  -- Аналитики ОПиУ  - направления
            , _tmp.InfoMoneyDestinationId -- Управленческие назначения
            , _tmp.InfoMoneyId            -- Статьи назначения
              -- значение Бизнес !!!выбирается!!! из 1)Автомобиля
            , vbBusinessId AS BusinessId 
              -- Бизнес для ОПиУ
            , _tmp.BusinessId_ProfitLoss

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                   , ObjectLink_Route_Unit.ChildObjectId AS UnitId_ProfitLoss
                     -- для Автомобиля это Вид топлива
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , MovementItem.Amount AS OperCount
                     -- Группы ОПиУ
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
                     -- Аналитики ОПиУ - направления
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
                     -- Управленческие назначения
                   , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- Статьи назначения
                   , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                     -- Бизнес для ОПиУ
                   , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
                   JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.Id = MovementItem.ParentId AND MovementItem_Parent.isErased = FALSE
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                        ON ObjectLink_Route_Unit.ObjectId = MovementItem_Parent.ObjectId
                                       AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                        ON ObjectLink_Unit_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                       AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
                   -- здесь нужны все
                   LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = ObjectLink_Route_Unit.ChildObjectId
                   -- здесь нужен только 20401; "ГСМ";
                   LEFT JOIN lfGet_Object_InfoMoney (zc_Enum_InfoMoney_20401()) AS lfObject_InfoMoney ON 1 = 1

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Transport()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
        ;

     -- для теста
     -- RETURN QUERY SELECT _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.JuridicalId_From, _tmpItem.isCorporate, _tmpItem.PersonalId_From, _tmpItem.UnitId, _tmpItem.BranchId_Unit, _tmpItem.PersonalId_Packer, _tmpItem.PaidKindId, _tmpItem.ContractId, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.OperCount, _tmpItem.tmpOperSumm_Partner, _tmpItem.OperSumm_Partner, _tmpItem.tmpOperSumm_Packer, _tmpItem.OperSumm_Packer, _tmpItem.AccountDirectionId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.InfoMoneyDestinationId_isCorporate, _tmpItem.InfoMoneyId_isCorporate, _tmpItem.JuridicalId_basis, _tmpItem.BusinessId                         , _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.PartionMovementId, _tmpItem.PartionGoodsId FROM _tmpItem;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := NULL
                                                                                , inCarId                  := vbCarId
                                                                                , inPersonalId             := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := 0
                                                                                , inIsPartionCount         := FALSE
                                                                                , inPartionGoodsId         := 0
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 );
     -- 1.1.2. формируются Проводки для количественного учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, MovementItemId, ContainerId_Goods, 0 AS ParentId, -1 * OperCount, vbOperDate, TRUE
       FROM _tmpItem;


     -- 1.2.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss, ContainerId, AccountId, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss
            , Container_Summ.Id AS ContainerId
            , Container_Summ.ObjectId AS AccountId
            , SUM (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0)) AS OperSumm -- убрал ABS
        FROM _tmpItem
             -- так находим для остальных
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN HistoryCost ON HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0 -- здесь нули !!!НЕ НУЖНЫ!!! 
          AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId;

     -- 1.2.2. формируются Проводки для суммового учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId, 0 AS ParentId, -1 * _tmpItemSumm.OperSumm, vbOperDate, TRUE
       FROM _tmpItemSumm;


     -- 2.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss = _tmpItem_byContainer.ContainerId_ProfitLoss
     FROM _tmpItem
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_ProfitLoss
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.ProfitLossDirectionId
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_ProfitLoss

           FROM (SELECT lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                      , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                      , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                      , inInfoMoneyId            := NULL
                                                      , inUserId                 := vbUserId
                                                       ) AS ProfitLossId
                      , _tmpItem_group.ProfitLossDirectionId
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_ProfitLoss

                 FROM (SELECT _tmpItem.ProfitLossGroupId
                            , _tmpItem.ProfitLossDirectionId
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_ProfitLoss
                       FROM _tmpItemSumm
                            JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                       GROUP BY _tmpItem.ProfitLossGroupId
                              , _tmpItem.ProfitLossDirectionId
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_ProfitLoss
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byContainer ON _tmpItem_byContainer.ProfitLossDirectionId  = _tmpItem.ProfitLossDirectionId
                                   AND _tmpItem_byContainer.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                   AND _tmpItem_byContainer.BusinessId_ProfitLoss  = _tmpItem.BusinessId_ProfitLoss
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss
            ) AS _tmpItem_group;


     -- 3. формируются Проводки для отчета (Аналитики: Товар и ОПиУ - разнице в весе)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItemSumm.ContainerId_ProfitLoss
                                              , inPassiveContainerId := _tmpItemSumm.ContainerId
                                              , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                              , inPassiveAccountId   := _tmpItemSumm.AccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItemSumm.ContainerId_ProfitLoss
                                                                                                    , inPassiveContainerId := _tmpItemSumm.ContainerId
                                                                                                    , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                                    , inPassiveAccountId   := _tmpItemSumm.AccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItemSumm.ContainerId_ProfitLoss
                                                                                                             , inPassiveContainerId := _tmpItemSumm.ContainerId
                                                                                                             , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                                             , inPassiveAccountId   := _tmpItemSumm.AccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItemSumm.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM _tmpItemSumm
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
     WHERE _tmpItemSumm.OperSumm <> 0;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Transport() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Transport (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= '2')
