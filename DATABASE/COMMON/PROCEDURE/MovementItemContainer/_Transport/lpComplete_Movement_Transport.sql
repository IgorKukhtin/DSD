-- Function: lpComplete_Movement_Transport (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Transport (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Transport(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbCarId Integer;
  DECLARE vbBranchId Integer;

  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId Integer;
BEGIN

     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.OperDate
          , _tmp.CarId, _tmp.BranchId
          , _tmp.JuridicalId_Basis, _tmp.BusinessId
            INTO vbOperDate
               , vbCarId, vbBranchId
               , vbJuridicalId_Basis, vbBusinessId
     FROM (SELECT Movement.OperDate
                , COALESCE (MovementLinkObject_Car.ObjectId, 0) AS CarId
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


     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_Transport (MovementItemId Integer, MovementItemId_parent Integer, UnitId_ProfitLoss Integer
                               , ContainerId_Goods Integer, GoodsId Integer, AssetId Integer
                               , OperCount TFloat
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, BusinessId_Route Integer
                                ) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_TransportSumm_Transport (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_Transport (MovementItemId, MovementItemId_parent, UnitId_ProfitLoss
                         , ContainerId_Goods, GoodsId, AssetId
                         , OperCount
                         , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId, BusinessId_Route
                          )
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementItemId_parent
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
              -- Бизнес для Прибыль
            , _tmp.BusinessId_Route

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                   , MovementItem.ParentId AS MovementItemId_parent
                   , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) AS UnitId_ProfitLoss
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
                     -- Бизнес для Прибыль
                   , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_Route

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
     -- RETURN QUERY SELECT _tmpItem_Transport.MovementItemId, _tmpItem_Transport.MovementId, _tmpItem_Transport.OperDate, _tmpItem_Transport.JuridicalId_From, _tmpItem_Transport.isCorporate, _tmpItem_Transport.PersonalId_From, _tmpItem_Transport.UnitId, _tmpItem_Transport.BranchId_Unit, _tmpItem_Transport.PersonalId_Packer, _tmpItem_Transport.PaidKindId, _tmpItem_Transport.ContractId, _tmpItem_Transport.ContainerId_Goods, _tmpItem_Transport.GoodsId, _tmpItem_Transport.GoodsKindId, _tmpItem_Transport.AssetId, _tmpItem_Transport.PartionGoods, _tmpItem_Transport.OperCount, _tmpItem_Transport.tmpOperSumm_Partner, _tmpItem_Transport.OperSumm_Partner, _tmpItem_Transport.tmpOperSumm_Packer, _tmpItem_Transport.OperSumm_Packer, _tmpItem_Transport.AccountDirectionId, _tmpItem_Transport.InfoMoneyDestinationId, _tmpItem_Transport.InfoMoneyId, _tmpItem_Transport.InfoMoneyDestinationId_isCorporate, _tmpItem_Transport.InfoMoneyId_isCorporate, _tmpItem_Transport.JuridicalId_basis, _tmpItem_Transport.BusinessId                         , _tmpItem_Transport.isPartionCount, _tmpItem_Transport.isPartionSumm, _tmpItem_Transport.PartionMovementId, _tmpItem_Transport.PartionGoodsId FROM _tmpItem_Transport;


     -- !!!формируются свойства в Главных элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), tmp.MovementItemId_parent, tmp.UnitId_ProfitLoss)
     FROM (SELECT _tmpItem_Transport.MovementItemId_parent, _tmpItem_Transport.UnitId_ProfitLoss
           FROM _tmpItem_Transport
           GROUP BY _tmpItem_Transport.MovementItemId_parent, _tmpItem_Transport.UnitId_ProfitLoss
          ) AS tmp;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem_Transport SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := NULL
                                                                                , inCarId                  := vbCarId
                                                                                , inPersonalId             := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem_Transport.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem_Transport.GoodsId
                                                                                , inGoodsKindId            := 0
                                                                                , inIsPartionCount         := FALSE
                                                                                , inPartionGoodsId         := 0
                                                                                , inAssetId                := _tmpItem_Transport.AssetId
                                                                                 );
     -- 1.1.2. формируются Проводки для количественного учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, MovementItemId, ContainerId_Goods, 0 AS ParentId, -1 * OperCount, vbOperDate, TRUE
       FROM _tmpItem_Transport;


     -- 1.2.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItem_TransportSumm_Transport (MovementItemId, ContainerId_ProfitLoss, ContainerId, AccountId, OperSumm)
        SELECT
              _tmpItem_Transport.MovementItemId
            , 0 AS ContainerId_ProfitLoss
            , Container_Summ.Id AS ContainerId
            , Container_Summ.ObjectId AS AccountId
            , SUM (_tmpItem_Transport.OperCount * COALESCE (HistoryCost.Price, 0)) AS OperSumm -- убрал ABS
        FROM _tmpItem_Transport
             -- так находим для остальных
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem_Transport.ContainerId_Goods
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN HistoryCost ON HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND _tmpItem_Transport.OperCount * COALESCE (HistoryCost.Price, 0) <> 0 -- здесь нули !!!НЕ НУЖНЫ!!! 
          AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
        GROUP BY _tmpItem_Transport.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId;

     -- 1.2.2. формируются Проводки для суммового учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItem_TransportSumm_Transport.MovementItemId, _tmpItem_TransportSumm_Transport.ContainerId, 0 AS ParentId, -1 * _tmpItem_TransportSumm_Transport.OperSumm, vbOperDate, TRUE
       FROM _tmpItem_TransportSumm_Transport;


     -- 2.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItem_TransportSumm_Transport SET ContainerId_ProfitLoss = _tmpItem_Transport_byContainer.ContainerId_ProfitLoss
     FROM _tmpItem_Transport
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := _tmpItem_Transport_byProfitLoss.BusinessId_Route
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_Transport_byProfitLoss.ProfitLossId
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_Transport_byProfitLoss.ProfitLossDirectionId
                , _tmpItem_Transport_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_Transport_byProfitLoss.BusinessId_Route

           FROM (SELECT lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_Transport_group.ProfitLossGroupId
                                                      , inProfitLossDirectionId  := _tmpItem_Transport_group.ProfitLossDirectionId
                                                      , inInfoMoneyDestinationId := _tmpItem_Transport_group.InfoMoneyDestinationId
                                                      , inInfoMoneyId            := NULL
                                                      , inUserId                 := inUserId
                                                       ) AS ProfitLossId
                      , _tmpItem_Transport_group.ProfitLossDirectionId
                      , _tmpItem_Transport_group.InfoMoneyDestinationId
                      , _tmpItem_Transport_group.BusinessId_Route

                 FROM (SELECT _tmpItem_Transport.ProfitLossGroupId
                            , _tmpItem_Transport.ProfitLossDirectionId
                            , _tmpItem_Transport.InfoMoneyDestinationId
                            , _tmpItem_Transport.BusinessId_Route
                       FROM _tmpItem_TransportSumm_Transport
                            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
                       GROUP BY _tmpItem_Transport.ProfitLossGroupId
                              , _tmpItem_Transport.ProfitLossDirectionId
                              , _tmpItem_Transport.InfoMoneyDestinationId
                              , _tmpItem_Transport.BusinessId_Route
                      ) AS _tmpItem_Transport_group
                ) AS _tmpItem_Transport_byProfitLoss
          ) AS _tmpItem_Transport_byContainer ON _tmpItem_Transport_byContainer.ProfitLossDirectionId  = _tmpItem_Transport.ProfitLossDirectionId
                                   AND _tmpItem_Transport_byContainer.InfoMoneyDestinationId = _tmpItem_Transport.InfoMoneyDestinationId
                                   AND _tmpItem_Transport_byContainer.BusinessId_Route       = _tmpItem_Transport.BusinessId_Route
     WHERE _tmpItem_TransportSumm_Transport.MovementItemId = _tmpItem_Transport.MovementItemId;

     -- 2.2. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_Transport_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_Transport_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                  , SUM (_tmpItem_TransportSumm_Transport.OperSumm) AS OperSumm
             FROM _tmpItem_TransportSumm_Transport
             GROUP BY _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
            ) AS _tmpItem_Transport_group;


     -- 3. формируются Проводки для отчета (Аналитики: Товар и Прибыль)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_Transport.MovementItemId
                                              , inActiveContainerId  := _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                              , inPassiveContainerId := _tmpItem_TransportSumm_Transport.ContainerId
                                              , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                              , inPassiveAccountId   := _tmpItem_TransportSumm_Transport.AccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                                                                                    , inPassiveContainerId := _tmpItem_TransportSumm_Transport.ContainerId
                                                                                                    , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                                    , inPassiveAccountId   := _tmpItem_TransportSumm_Transport.AccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                                                                                             , inPassiveContainerId := _tmpItem_TransportSumm_Transport.ContainerId
                                                                                                             , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                                             , inPassiveAccountId   := _tmpItem_TransportSumm_Transport.AccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem_TransportSumm_Transport.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM _tmpItem_TransportSumm_Transport
          LEFT JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
     WHERE _tmpItem_TransportSumm_Transport.OperSumm <> 0;


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
 14.10.13                                        * add lpInsertUpdate_MovementItemLinkObject
 06.10.13                                        * add inUserId
 02.10.13                                        * add BusinessId_Route
 02.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_Transport (inMovementId:= 149639, inUserId:= 2)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= '2')
