-- Function: gpComplete_Movement_Inventory()

-- DROP FUNCTION gpComplete_Movement_Inventory (Integer, TVarChar);
-- DROP FUNCTION gpComplete_Movement_Inventory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Inventory(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean              , -- это последнее проведение после расчета с/с
    IN inSession           TVarChar               -- сессия пользователя
)                              
 RETURNS VOID
--  RETURNS TABLE (ProfitLossGroupId Integer, ProfitLossDirectionId Integer, MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId Integer, PersonalId Integer, BranchId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, OperSumm TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, isPartionDate Boolean, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId Integer;
  DECLARE vbPersonalId Integer;
  DECLARE vbProfitLossGroupId Integer;
  DECLARE vbProfitLossDirectionId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Inventory());
     vbUserId:=2; -- CAST (inSession AS Integer);

     -- Эти параметры нужны для расчета остатка
     SELECT Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0)
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0)
            INTO vbOperDate, vbUnitId, vbPersonalId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

     WHERE Movement.Id = inMovementId;

     -- Эти параметры нужны для проводок по прибыли
     SELECT lfObject_Unit_byProfitLossDirection.ProfitLossGroupId
          , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId
            INTO vbProfitLossGroupId, vbProfitLossDirectionId
     FROM lfGet_Object_Unit_byProfitLossDirection (vbUnitId) AS lfObject_Unit_byProfitLossDirection;


     -- таблица - Аналитики остатка
     CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- таблица - Аналитики <элемент с/с>
     CREATE TEMP TABLE _tmpObjectCost (DescId Integer, ObjectId Integer) ON COMMIT DROP;

     -- таблица - количественный остаток
     CREATE TEMP TABLE _tmpRemainsCount (MovementItemId Integer, ContainerId_Goods Integer, GoodsId Integer, OperCount TFloat) ON COMMIT DROP;
     -- таблица - суммовой остаток
     CREATE TEMP TABLE _tmpRemainsSumm (ContainerId_Goods Integer, ContainerId Integer, GoodsId Integer, OperSumm TFloat) ON COMMIT DROP;

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId Integer, PersonalId Integer, BranchId Integer
                               , ContainerId_Goods Integer, ContainerId_Summ Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperSumm TFloat
                               , AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyId_Detail Integer
                               , JuridicalId_basis Integer, BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isPartionDate Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId, PersonalId, BranchId
                         , ContainerId_Goods, ContainerId_Summ, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperSumm
                         , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyId_Detail
                         , JuridicalId_basis, BusinessId
                         , isPartionCount, isPartionSumm, isPartionDate
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementId
            , _tmp.OperDate
            , _tmp.UnitId
            , _tmp.PersonalId
            , _tmp.BranchId

            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_Summ
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

            , _tmp.OperCount
            , _tmp.OperSumm

              -- Аналитики счетов - направления
            , _tmp.AccountDirectionId
              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId
            , _tmp.InfoMoneyId AS InfoMoneyId_Detail

            , _tmp.JuridicalId_basis
            , _tmp.BusinessId

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 
            , _tmp.isPartionDate
              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId
        FROM 
             (SELECT
                    MovementItem.Id AS MovementItemId
                  , MovementItem.MovementId
                  , Movement.OperDate
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS PersonalId
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId

                  , MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                  , MovementItem.Amount AS OperCount
                  , COALESCE (MIFloat_Summ.ValueData, 0) AS OperSumm

                    -- Аналитики счетов - направления
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                       THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                   WHEN Object_From.DescId = zc_Object_Personal() 
                                       THEN CASE WHEN lfObject_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "Общефирменные"; 20700; "Товары"
                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- "Доходы"; 30100; "Продукция"
                                                                                                   )
                                                     THEN zc_Enum_AccountDirection_20600() -- "Запасы"; 20600; "сотрудники (экспедиторы)"
                                                 ELSE zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                                            END
                              END, 0) AS AccountDirectionId
                    -- Управленческие назначения
                  , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_basis
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm
                  , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)  AS isPartionDate

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId


                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                        ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                       AND Object_From.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                        ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                                        ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                       AND Object_From.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Business
                                        ON ObjectLink_UnitFrom_Business.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                                       AND Object_From.DescId = zc_Object_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Unit
                                        ON ObjectLink_PersonalFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_PersonalFrom_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                       AND Object_From.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Branch
                                        ON ObjectLink_UnitPersonalFrom_Branch.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonalFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       AND Object_From.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Juridical
                                        ON ObjectLink_UnitPersonalFrom_Juridical.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonalFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                       AND Object_From.DescId = zc_Object_Personal()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Business
                                        ON ObjectLink_UnitPersonalFrom_Business.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                                       AND ObjectLink_UnitPersonalFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                                       AND Object_From.DescId = zc_Object_Personal()


                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                           ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Inventory()
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
             ) AS _tmp;


     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                AND _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_20200() -- "Запасы"; 20200; "на складах"
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)
                                               WHEN _tmpItem.isPartionDate
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "Доходы"; 30100; "Продукция"
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "Доходы"; 30100; "Продукция"
     ;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                          -- 0)Товар 1)Подразделение 2)!Партия товара!
                                                          -- 0)Товар 1)Сотрудник (МО или Эксп.) 2)!Партия товара!
                                                     THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                , inParentId:= NULL
                                                                                , inObjectId:= _tmpItem.GoodsId
                                                                                , inJuridicalId_basis:= NULL
                                                                                , inBusinessId       := NULL
                                                                                , inObjectCostDescId := NULL
                                                                                , inObjectCostId     := NULL
                                                                                , inDescId_1   := CASE WHEN _tmpItem.PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                , inObjectId_1 := CASE WHEN _tmpItem.PersonalId <> 0 THEN _tmpItem.PersonalId ELSE _tmpItem.UnitId END
                                                                                , inDescId_2   := zc_ContainerLinkObject_PartionGoods()
                                                                                , inObjectId_2 := CASE WHEN _tmpItem.isPartionCount THEN _tmpItem.PartionGoodsId ELSE NULL END
                                                                                 )
                                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                          -- 0)Товар 1)Подразделение 2)Основные средства(для которого закуплено ТМЦ)
                                                          -- 0)Товар 1)Сотрудник (МО или Эксп.) 2)Основные средства(для которого закуплено ТМЦ)
                                                     THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                , inParentId:= NULL
                                                                                , inObjectId:= _tmpItem.GoodsId
                                                                                , inJuridicalId_basis:= NULL
                                                                                , inBusinessId       := NULL
                                                                                , inObjectCostDescId := NULL
                                                                                , inObjectCostId     := NULL
                                                                                , inDescId_1   := CASE WHEN _tmpItem.PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                , inObjectId_1 := CASE WHEN _tmpItem.PersonalId <> 0 THEN _tmpItem.PersonalId ELSE _tmpItem.UnitId END
                                                                                , inDescId_2   := zc_ContainerLinkObject_AssetTo()
                                                                                , inObjectId_2 := _tmpItem.AssetId
                                                                                 )
                                                  WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- Товары    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                                         , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                          -- 0)Товар 1)Подразделение 2)Вид товара 3)!!!Партия товара!!!
                                                          -- 0)Товар 1)Сотрудник (МО или Эксп.) 2)Вид товара 3)!!!Партия товара!!!
                                                     THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                , inParentId:= NULL
                                                                                , inObjectId:= _tmpItem.GoodsId
                                                                                , inJuridicalId_basis:= NULL
                                                                                , inBusinessId       := NULL
                                                                                , inObjectCostDescId := NULL
                                                                                , inObjectCostId     := NULL
                                                                                , inDescId_1   := CASE WHEN _tmpItem.PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                , inObjectId_1 := CASE WHEN _tmpItem.PersonalId <> 0 THEN _tmpItem.PersonalId ELSE _tmpItem.UnitId END
                                                                                , inDescId_2   := zc_ContainerLinkObject_GoodsKind()
                                                                                , inObjectId_2 := _tmpItem.GoodsKindId
                                                                                , inDescId_3   := CASE WHEN _tmpItem.PartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                                                , inObjectId_3 := CASE WHEN _tmpItem.PartionGoodsId <> 0 THEN _tmpItem.PartionGoodsId ELSE NULL END
                                                                                 )
                                                          -- 0)Товар 1)Подразделение
                                                     ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                , inParentId:= NULL
                                                                                , inObjectId:= _tmpItem.GoodsId
                                                                                , inJuridicalId_basis:= NULL
                                                                                , inBusinessId       := NULL
                                                                                , inObjectCostDescId := NULL
                                                                                , inObjectCostId     := NULL
                                                                                , inDescId_1   := CASE WHEN _tmpItem.PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                , inObjectId_1 := CASE WHEN _tmpItem.PersonalId <> 0 THEN _tmpItem.PersonalId ELSE _tmpItem.UnitId END
                                                                                 )
                                             END;


     -- заполняем таблицу - количественный остаток на конец vbOperDate
     INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, GoodsId, OperCount)
        SELECT COALESCE (_tmpItem_find.MovementItemId, 0) AS MovementItemId
             , _tmpContainer.ContainerId_Goods
             , _tmpContainer.GoodsId
             , _tmpContainer.OperCount
        FROM (SELECT _tmpContainerLinkObject_From.ContainerId AS ContainerId_Goods
                   , Container.ObjectId AS GoodsId
                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperCount
              FROM (SELECT ContainerId FROM ContainerLinkObject WHERE ObjectId =  vbUnitId AND DescId = zc_ContainerLinkObject_Unit() AND vbUnitId <> 0
                   UNION
                    SELECT ContainerId FROM ContainerLinkObject WHERE ObjectId =  vbPersonalId AND DescId = zc_ContainerLinkObject_Personal() AND vbPersonalId <> 0
                   ) AS _tmpContainerLinkObject_From
                   -- !!!обязательно JOIN, что б "учавствовали" только товарные операции!!!
                   JOIN Container ON Container.Id = _tmpContainerLinkObject_From.ContainerId
                                 AND Container.DescId = zc_Container_Count()
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.Containerid = Container.Id
                                                  AND MIContainer.OperDate > vbOperDate
              GROUP BY _tmpContainerLinkObject_From.ContainerId
                     , Container.ObjectId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
             ) AS _tmpContainer
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.ContainerId_Goods FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods)
                       AS _tmpItem_find ON _tmpItem_find.ContainerId_Goods = _tmpContainer.ContainerId_Goods
     ;

     -- заполняем таблицу - суммовой остаток на конец vbOperDate
     INSERT INTO _tmpRemainsSumm (ContainerId_Goods, ContainerId, GoodsId, OperSumm)
        SELECT _tmpContainer.ContainerId_Goods
             , _tmpContainer.ContainerId
             , Container_Count.ObjectId
             , _tmpContainer.OperSumm
        FROM (SELECT _tmpContainerLinkObject_From.ContainerId
                   , Container.ParentId AS ContainerId_Goods
                   , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperSumm
              FROM (SELECT ContainerId FROM ContainerLinkObject WHERE ObjectId =  vbUnitId AND DescId = zc_ContainerLinkObject_Unit() AND vbUnitId <> 0
                   UNION
                    SELECT ContainerId FROM ContainerLinkObject WHERE ObjectId =  vbPersonalId AND DescId = zc_ContainerLinkObject_Personal() AND vbPersonalId <> 0
                   ) AS _tmpContainerLinkObject_From
                   -- !!!обязательно JOIN and ParentId, что б "учавствовали" только товарные операции!!!
                   JOIN Container ON Container.Id = _tmpContainerLinkObject_From.ContainerId
                                 AND Container.DescId = zc_Container_Summ()
                                 AND Container.ParentId IS NOT NULL
                   LEFT JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.Containerid = Container.Id
                                                  AND MIContainer.OperDate > vbOperDate
              GROUP BY _tmpContainerLinkObject_From.ContainerId
                     , Container.ParentId
                     , Container.Amount
              HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
             ) AS _tmpContainer
             LEFT JOIN Container AS Container_Count ON Container_Count.Id = _tmpContainer.ContainerId_Goods
     ;

     -- добавляем из суммовой остаток в количественный остаток те, которых нет
     INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, GoodsId, OperCount)
        SELECT 0 AS MovementItemId
             , _tmpRemainsSumm.ContainerId_Goods
             , _tmpRemainsSumm.GoodsId
             , 0 AS OperCount
        FROM _tmpRemainsSumm
             LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
        WHERE _tmpRemainsCount.ContainerId_Goods IS NULL
        GROUP BY _tmpRemainsSumm.ContainerId_Goods
               , _tmpRemainsSumm.GoodsId;

     -- добавляем в строчную часть (MovementItem) те товары, по которым есть остаток но нет в строчной части
     UPDATE _tmpRemainsCount SET MovementItemId = lpInsertUpdate_MovementItem (ioId:= 0
                                                                             , inDescId:= zc_MI_Master()
                                                                             , inObjectId:= _tmpRemainsCount.GoodsId
                                                                             , inMovementId:= inMovementId
                                                                             , inAmount:= 0
                                                                             , inParentId:= NULL
                                                                              )
     WHERE _tmpRemainsCount.MovementItemId = 0;

     -- добавляем в список для проводок те товары, которые только что были добавлены в строчную часть (MovementItem), причем !!!без!!! аналитик бля суммовых проводок
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId, PersonalId, BranchId
                         , ContainerId_Goods, ContainerId_Summ, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperSumm
                         , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyId_Detail
                         , JuridicalId_basis, BusinessId
                         , isPartionCount, isPartionSumm, isPartionDate
                         , PartionGoodsId)
        SELECT _tmpRemainsCount.MovementItemId
             , inMovementId
             , vbOperDate
             , vbUnitId
             , vbPersonalId
             , 0 AS BranchId
             , _tmpRemainsCount.ContainerId_Goods
             , 0 AS ContainerId_Summ
             , _tmpRemainsCount.GoodsId
             , ContainerLinkObject_GoodsKind.ObjectId AS GoodsKindId
             , ContainerLinkObject_AssetTo.ObjectId AS AssetId
             , '' AS PartionGoods
             , zc_DateEnd() AS PartionGoodsDate
             , 0 AS OperCount
             , 0 AS OperSumm
             , 0 AS AccountDirectionId
             , 0 AS InfoMoneyDestinationId
             , 0 AS InfoMoneyId
             , 0 AS InfoMoneyId_Detail
             , 0 AS JuridicalId_basis
             , 0 AS BusinessId
             , TRUE AS isPartionCount
             , TRUE AS isPartionSumm
             , TRUE AS isPartionDate
             , ContainerLinkObject_PartionGoods.ObjectId AS PartionGoodsId
        FROM _tmpRemainsCount
             LEFT JOIN _tmpItem ON _tmpItem.ContainerId_Goods = _tmpRemainsCount.ContainerId_Goods
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                           ON ContainerLinkObject_GoodsKind.ContainerId = _tmpRemainsCount.ContainerId_Goods
                                          AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PartionGoods
                                           ON ContainerLinkObject_PartionGoods.ContainerId = _tmpRemainsCount.ContainerId_Goods
                                          AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_AssetTo
                                           ON ContainerLinkObject_AssetTo.ContainerId = _tmpRemainsCount.ContainerId_Goods
                                          AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
        WHERE _tmpItem.ContainerId_Goods IS NULL;


     -- формируются Проводки для количественного учета !!!только!!! если есть разница по остатку
     PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                 , inDescId:= zc_MIContainer_Count()
                                                 , inMovementId:= _tmpItem.MovementId
                                                 , inMovementItemId:= _tmpItem.MovementItemId
                                                 , inParentId:= NULL
                                                 , inContainerId:= _tmpItem.ContainerId_Goods -- был опеределен выше
                                                 , inAmount:= _tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)
                                                 , inOperDate:= _tmpItem.OperDate
                                                 , inIsActive:= CASE WHEN (_tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)) > 0 THEN TRUE
                                                                     WHEN (_tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)) < 0 THEN FALSE
                                                                END
                                                  )
     FROM _tmpItem
          LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.MovementItemId = _tmpItem.MovementItemId
     WHERE (_tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)) <> 0
     ;


     -- для теста
     -- RETURN QUERY SELECT CAST (vbProfitLossGroupId AS Integer) AS ProfitLossGroupId, CAST (vbProfitLossDirectionId AS Integer) AS ProfitLossDirectionId, _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.UnitId, _tmpItem.PersonalId, _tmpItem.BranchId, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.OperCount, _tmpItem.OperSumm, _tmpItem.AccountDirectionId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.InfoMoneyId_Detail, _tmpItem.JuridicalId_basis, _tmpItem.BusinessId, _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.isPartionDate, _tmpItem.PartionGoodsId FROM _tmpItem;


     -- созаем контейнеры для суммового учета + Аналитика <элемент с/с>, причем !!!только!!! для строчной части (MovementItem), а для остатка они итак есть
     UPDATE _tmpItem SET ContainerId_Summ                        = CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)!Партии товара! 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО или Эксп.) 2)Товар 3)!Партии товара! 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                           THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                      , inParentId:= ContainerId_Goods
                                                                                                      , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                                , inAccountDirectionId     := AccountDirectionId
                                                                                                                                                , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                                , inInfoMoneyId            := NULL
                                                                                                                                                , inUserId                 := vbUserId
                                                                                                                                                 )
                                                                                                      , inJuridicalId_basis:= JuridicalId_basis
                                                                                                      , inBusinessId       := BusinessId
                                                                                                      , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!Подразделение! 5)Товар 6)!Партии товара! 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО или Эксп.) 5)Товар 6)!Партии товара! 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                      , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                     , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                     , inObjectId_1 := JuridicalId_basis
                                                                                                                                                     , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                     , inObjectId_2 := BusinessId
                                                                                                                                                     , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                     , inObjectId_3 := BranchId
                                                                                                                                                     , inDescId_4   := CASE WHEN PersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                                                                                     , inObjectId_4 := CASE WHEN PersonalId <> 0 AND OperDate >= zc_DateStart_ObjectCostOnUnit() THEN PersonalId WHEN OperDate >= zc_DateStart_ObjectCostOnUnit() THEN UnitId ELSE NULL END
                                                                                                                                                     , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                     , inObjectId_5 := GoodsId
                                                                                                                                                     , inDescId_6   := zc_ObjectCostLink_PartionGoods()
                                                                                                                                                     , inObjectId_6 := CASE WHEN isPartionSumm THEN PartionGoodsId ELSE NULL END
                                                                                                                                                     , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                     , inObjectId_7 := InfoMoneyId
                                                                                                                                                     , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                     , inObjectId_8 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END
                                                                                                                                                      )
                                                                                                      , inDescId_1   := CASE WHEN PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                                      , inObjectId_1 := CASE WHEN PersonalId <> 0 THEN PersonalId ELSE UnitId END
                                                                                                      , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                      , inObjectId_2 := GoodsId
                                                                                                      , inDescId_3   := zc_ContainerLinkObject_PartionGoods()
                                                                                                      , inObjectId_3 := CASE WHEN isPartionSumm THEN PartionGoodsId ELSE NULL END
                                                                                                      , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_4 := InfoMoneyId
                                                                                                      , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      , inObjectId_5 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                       )
                                                                        WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Основные средства(для которого закуплено ТМЦ) 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО или Эксп.) 2)Товар 3)Основные средства(для которого закуплено ТМЦ) 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                           THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                      , inParentId:= ContainerId_Goods
                                                                                                      , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                                , inAccountDirectionId     := AccountDirectionId
                                                                                                                                                , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                                , inInfoMoneyId            := NULL
                                                                                                                                                , inUserId                 := vbUserId
                                                                                                                                                 )
                                                                                                      , inJuridicalId_basis:= JuridicalId_basis
                                                                                                      , inBusinessId       := BusinessId
                                                                                                      , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!Подразделение! 5)Товар 6)Основные средства(для которого закуплено ТМЦ) 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО или Эксп.) 5)Товар 6)Основные средства(для которого закуплено ТМЦ) 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                      , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                     , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                     , inObjectId_1 := JuridicalId_basis
                                                                                                                                                     , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                     , inObjectId_2 := BusinessId
                                                                                                                                                     , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                     , inObjectId_3 := BranchId
                                                                                                                                                     , inDescId_4   := CASE WHEN PersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                                                                                     , inObjectId_4 := CASE WHEN PersonalId <> 0 AND OperDate >= zc_DateStart_ObjectCostOnUnit() THEN PersonalId WHEN OperDate >= zc_DateStart_ObjectCostOnUnit() THEN UnitId ELSE NULL END
                                                                                                                                                     , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                     , inObjectId_5 := GoodsId
                                                                                                                                                     , inDescId_6   := zc_ObjectCostLink_AssetTo()
                                                                                                                                                     , inObjectId_6 := AssetId
                                                                                                                                                     , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                     , inObjectId_7 := InfoMoneyId
                                                                                                                                                     , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                     , inObjectId_8 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                      )
                                                                                                      , inDescId_1   := CASE WHEN PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                                      , inObjectId_1 := CASE WHEN PersonalId <> 0 THEN PersonalId ELSE UnitId END
                                                                                                      , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                      , inObjectId_2 := GoodsId
                                                                                                      , inDescId_3   := zc_ContainerLinkObject_AssetTo()
                                                                                                      , inObjectId_3 := AssetId
                                                                                                      , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_4 := InfoMoneyId
                                                                                                      , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      , inObjectId_5 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                       )
                                                                        WHEN InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- Товары    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                                                      , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)!!!Партии товара!!! 4)Виды товаров 5)Статьи назначения 6)Статьи назначения(детализация с/с)
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО или Эксп.) 2)Товар 3)!!!Партии товара!!! 4)Виды товаров 5)Статьи назначения 6)Статьи назначения(детализация с/с)
                                                                           THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                      , inParentId:= ContainerId_Goods
                                                                                                      , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                                , inAccountDirectionId     := AccountDirectionId
                                                                                                                                                , inInfoMoneyDestinationId := CASE WHEN GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE InfoMoneyDestinationId END
                                                                                                                                                , inInfoMoneyId            := NULL
                                                                                                                                                , inUserId                 := vbUserId
                                                                                                                                                 )
                                                                                                      , inJuridicalId_basis:= JuridicalId_basis
                                                                                                      , inBusinessId       := BusinessId
                                                                                                      , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Подразделение 5)Товар 6)!!!Партии товара!!! 7)Виды товаров 8)Статьи назначения 9)Статьи назначения(детализация с/с)
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО или Эксп.) 5)Товар 6)!!!Партии товара!!! 7)Виды товаров 8)Статьи назначения 9)Статьи назначения(детализация с/с)
                                                                                                      , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                     , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                     , inObjectId_1 := JuridicalId_basis
                                                                                                                                                     , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                     , inObjectId_2 := BusinessId
                                                                                                                                                     , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                     , inObjectId_3 := BranchId
                                                                                                                                                     , inDescId_4   := zc_ObjectCostLink_Unit()
                                                                                                                                                     , inObjectId_4 := UnitId
                                                                                                                                                     , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                     , inObjectId_5 := GoodsId
                                                                                                                                                     , inDescId_6   := CASE WHEN PartionGoodsId <> 0 THEN zc_ObjectCostLink_PartionGoods() ELSE NULL END
                                                                                                                                                     , inObjectId_6 := CASE WHEN PartionGoodsId <> 0 THEN PartionGoodsId ELSE NULL END
                                                                                                                                                     , inDescId_7   := zc_ObjectCostLink_GoodsKind()
                                                                                                                                                     , inObjectId_7 := GoodsKindId
                                                                                                                                                     , inDescId_8   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                     , inObjectId_8 := InfoMoneyId
                                                                                                                                                     , inDescId_9   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                     , inObjectId_9 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                      )
                                                                                                      , inDescId_1   := CASE WHEN PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                                      , inObjectId_1 := CASE WHEN PersonalId <> 0 THEN PersonalId ELSE UnitId END
                                                                                                      , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                      , inObjectId_2 := GoodsId
                                                                                                      , inDescId_3   := CASE WHEN PartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                                                                      , inObjectId_3 := CASE WHEN PartionGoodsId <> 0 THEN PartionGoodsId ELSE NULL END
                                                                                                      , inDescId_4   := zc_ContainerLinkObject_GoodsKind()
                                                                                                      , inObjectId_4 := GoodsKindId
                                                                                                      , inDescId_5   := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_5 := InfoMoneyId
                                                                                                      , inDescId_6   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      , inObjectId_6 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                       )
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО или Эксп.) 2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
                                                                           ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                      , inParentId:= ContainerId_Goods
                                                                                                      , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                                , inAccountDirectionId     := AccountDirectionId
                                                                                                                                                , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                                , inInfoMoneyId            := NULL
                                                                                                                                                , inUserId                 := vbUserId
                                                                                                                                                 )
                                                                                                      , inJuridicalId_basis:= JuridicalId_basis
                                                                                                      , inBusinessId       := BusinessId
                                                                                                      , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!!!Подразделение!!! 5)Товар 6)Статьи назначения 7)Статьи назначения(детализация с/с)
                                                                                                                              -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО или Эксп.) 5)Товар 6)Статьи назначения 7)Статьи назначения(детализация с/с)
                                                                                                      , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                     , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                     , inObjectId_1 := JuridicalId_basis
                                                                                                                                                     , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                     , inObjectId_2 := BusinessId
                                                                                                                                                     , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                     , inObjectId_3 := BranchId
                                                                                                                                                     , inDescId_4   := CASE WHEN PersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                                                                                     , inObjectId_4 := CASE WHEN PersonalId <> 0 AND OperDate >= zc_DateStart_ObjectCostOnUnit() THEN PersonalId WHEN OperDate >= zc_DateStart_ObjectCostOnUnit() THEN UnitId ELSE NULL END
                                                                                                                                                     , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                     , inObjectId_5 := GoodsId
                                                                                                                                                     , inDescId_6   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                     , inObjectId_6 := InfoMoneyId
                                                                                                                                                     , inDescId_7   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                     , inObjectId_7 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                      )
                                                                                                      , inDescId_1   := CASE WHEN PersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                                                      , inObjectId_1 := CASE WHEN PersonalId <> 0 THEN PersonalId ELSE UnitId END
                                                                                                      , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                      , inObjectId_2 := GoodsId
                                                                                                      , inDescId_3   := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3 := InfoMoneyId
                                                                                                      , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      , inObjectId_4 := CASE WHEN zc_isHistoryCost_byInfoMoneyDetail() THEN InfoMoneyId_Detail ELSE 0 END -- CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                       )
                                                                   END
     WHERE OperSumm <> 0
       AND zc_isHistoryCost() = TRUE;

     -- формируются Проводки для суммового учета !!!только!!! если есть разница по остатку
     PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                 , inDescId:= zc_MIContainer_Summ()
                                                 , inMovementId:= inMovementId
                                                 , inMovementItemId:= _tmp.MovementItemId
                                                 , inParentId:= NULL
                                                 , inContainerId:= _tmp.ContainerId
                                                 , inAmount:= _tmp.OperSumm
                                                 , inOperDate:= vbOperDate
                                                 , inIsActive:= CASE WHEN _tmp.OperSumm > 0 THEN TRUE
                                                                     WHEN _tmp.OperSumm < 0 THEN FALSE
                                                                END
                                                  )
     FROM (SELECT _tmp_All.MovementItemId, _tmp_All.ContainerId, SUM (_tmp_All.OperSumm) AS OperSumm
           FROM (SELECT _tmpRemainsCount.MovementItemId
                      , _tmpRemainsSumm.ContainerId
                      , -1 * _tmpRemainsSumm.OperSumm AS OperSumm
                 FROM _tmpRemainsSumm
                      LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
                 WHERE _tmpRemainsSumm.OperSumm <> 0
                UNION ALL
                 SELECT MovementItemId, ContainerId_Summ AS ContainerId, OperSumm FROM _tmpItem WHERE OperSumm <> 0
                ) AS _tmp_All
           GROUP BY _tmp_All.MovementItemId, _tmp_All.ContainerId
          ) AS _tmp
     WHERE _tmp.OperSumm <> 0
       AND zc_isHistoryCost() = TRUE;


     -- формируются Проводки - Прибыль !!!только!!! если есть разница по остатку
     PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                 , inDescId:= zc_MIContainer_Summ()
                                                 , inMovementId:= inMovementId
                                                 , inMovementItemId:= _tmp.MovementItemId
                                                 , inParentId:= NULL
                                                 , inContainerId:= lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                         , inParentId:= NULL
                                                                                         , inObjectId:= zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                         , inJuridicalId_basis:= _tmp.JuridicalId_basis
                                                                                         , inBusinessId       := _tmp.BusinessId
                                                                                         , inObjectCostDescId := NULL
                                                                                         , inObjectCostId     := NULL
                                                                                         , inDescId_1   := zc_ContainerLinkObject_ProfitLoss()
                                                                                         , inObjectId_1 := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := vbProfitLossGroupId
                                                                                                                                         , inProfitLossDirectionId  := vbProfitLossDirectionId
                                                                                                                                         , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                         , inInfoMoneyId            := NULL
                                                                                                                                         , inUserId                 := vbUserId
                                                                                                                                          )
                                                                                          )
                                                 , inAmount:= _tmp.OperSumm
                                                 , inOperDate:= vbOperDate
                                                 , inIsActive:= CASE WHEN _tmp.OperSumm > 0 THEN TRUE
                                                                     WHEN _tmp.OperSumm < 0 THEN FALSE
                                                                END
                                                  )
     FROM (SELECT _tmp_All.MovementItemId, _tmp_All.JuridicalId_basis, _tmp_All.BusinessId, _tmp_All.InfoMoneyDestinationId, -1 * SUM(_tmp_All.OperSumm) AS OperSumm
           FROM (SELECT _tmpRemainsCount.MovementItemId
                      , _tmpItem.JuridicalId_basis
                      , _tmpItem.BusinessId
                      , _tmpItem.InfoMoneyDestinationId
                      , -1 * _tmpRemainsSumm.OperSumm AS OperSumm
                 FROM _tmpRemainsSumm
                      LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
                      LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpRemainsCount.MovementItemId
                 WHERE _tmpRemainsSumm.OperSumm <> 0
                UNION ALL
                 SELECT MovementItemId, JuridicalId_basis, BusinessId, InfoMoneyDestinationId, OperSumm FROM _tmpItem WHERE OperSumm <> 0
                ) AS _tmp_All
           GROUP BY _tmp_All.MovementItemId, _tmp_All.JuridicalId_basis, _tmp_All.BusinessId, _tmp_All.InfoMoneyDestinationId
          ) AS _tmp
     WHERE _tmp.OperSumm <> 0
       AND zc_isHistoryCost() = TRUE;


     -- ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Inventory() AND StatusId = zc_Enum_Status_UnComplete();


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 23.08.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 29120, inSession:= '2')
 SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 29120, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 29120, inSession:= '2')
