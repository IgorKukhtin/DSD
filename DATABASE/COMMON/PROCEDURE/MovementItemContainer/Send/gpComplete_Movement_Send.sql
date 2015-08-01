-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean DEFAULT False, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbWhereObjectId_Analyzer_From Integer;
  DECLARE vbWhereObjectId_Analyzer_To Integer;

  DECLARE vbMovementDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= inSession :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Send());
     END IF;

     -- Эти параметры нужны для 
     inIsLastComplete:= TRUE;
     vbMovementDescId:= zc_Movement_Send();


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Send_CreateTemp();

     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId_From, MemberId_From, BranchId_From, UnitId_To, MemberId_To, BranchId_To
                         , MIContainerId_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate_From, PartionGoodsDate_To
                         , OperCount
                         , AccountDirectionId_From, AccountDirectionId_To, InfoMoneyDestinationId, InfoMoneyId
                         , JuridicalId_basis_To, BusinessId_To
                         , UnitId_Item, StorageId_Item, PartionGoodsId_Item, UnitId_Partion, Price_Partion
                         , isPartionCount, isPartionSumm, isPartionDate_From, isPartionDate_To
                         , PartionGoodsId_From, PartionGoodsId_To)
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementId
            , _tmp.OperDate
            , _tmp.UnitId_From
            , _tmp.MemberId_From
            , _tmp.BranchId_From
            , _tmp.UnitId_To
            , _tmp.MemberId_To
            , _tmp.BranchId_To

            , 0 AS MIContainerId_To
            , 0 AS ContainerId_GoodsFrom
            , 0 AS ContainerId_GoodsTo
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate_From
            , _tmp.PartionGoodsDate_To

            , _tmp.OperCount

              -- Аналитики счетов - направления (От Кого)
            , _tmp.AccountDirectionId_From
              -- Аналитики счетов - направления (Кому)
            , _tmp.AccountDirectionId_To
              -- Управленческие назначения (?От Кого? и Кому)
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения (?От Кого? и Кому)
            , _tmp.InfoMoneyId

            , _tmp.JuridicalId_basis_To
            , _tmp.BusinessId_To

             , _tmp.UnitId_Item
             , _tmp.StorageId_Item
             , _tmp.PartionGoodsId_Item
             , CASE WHEN _tmp.MemberId_From <> 0 AND _tmp.MemberId_To <> 0 THEN _tmp.UnitId_Partion
                    WHEN _tmp.UnitId_From <> 0 AND _tmp.MemberId_To <> 0 THEN _tmp.UnitId_From
                    ELSE 0
               END AS UnitId_Partion
             , _tmp.Price_Partion

            , _tmp.isPartionCount
            , _tmp.isPartionSumm
            , _tmp.isPartionDate_From
            , _tmp.isPartionDate_To
              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId_From
            , 0 AS PartionGoodsId_To
        FROM 
             (SELECT
                    MovementItem.Id AS MovementItemId
                  , MovementItem.MovementId
                  , Movement.OperDate
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS MemberId_From
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS MemberId_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To

                  , MovementItem.ObjectId AS GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId_Item
                  , COALESCE (MILinkObject_Storage.ObjectId, 0) AS StorageId_Item
                  , COALESCE (MILinkObject_PartionGoods.ObjectId, 0) AS PartionGoodsId_Item
                  , COALESCE (ObjectFloat_PartionGoods_Price.ValueData, 0) AS Price_Partion
                  , COALESCE (ObjectLink_PartionGoods_Unit.ChildObjectId, 0) AS UnitId_Partion
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate_From
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate_To

                  , MovementItem.Amount AS OperCount

                  -- Аналитики счетов - направления (От Кого)
                  , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                       THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                   WHEN Object_From.DescId = zc_Object_Member()
                                       THEN CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "Общефирменные"; 20700; "Товары"
                                                                                                  , zc_Enum_InfoMoneyDestination_20900() -- "Общефирменные"; 20900; "Ирна"
                                                                                                  , zc_Enum_InfoMoneyDestination_21000() -- "Общефирменные"; 21000; "Чапли"
                                                                                                  , zc_Enum_InfoMoneyDestination_21100() -- "Общефирменные"; 21100; "Дворкин"
                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                  , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                   )
                                                     THEN 0 -- !!!всё в сотрудники (МО), а здесь ошибка!!! zc_Enum_AccountDirection_20600() -- "Запасы"; 20600; "сотрудники (экспедиторы)"
                                                 ELSE zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                                            END
                              END, 0) AS AccountDirectionId_From
                  -- Аналитики счетов - направления (Кому)
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()
                                       THEN ObjectLink_UnitTo_AccountDirection.ChildObjectId
                                   WHEN Object_To.DescId = zc_Object_Member()
                                       THEN CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
                                                                                                  , zc_Enum_InfoMoneyDestination_20700() -- "Общефирменные"; 20700; "Товары"
                                                                                                  , zc_Enum_InfoMoneyDestination_20900() -- "Общефирменные"; 20900; "Ирна"
                                                                                                  , zc_Enum_InfoMoneyDestination_21000() -- "Общефирменные"; 21000; "Чапли"
                                                                                                  , zc_Enum_InfoMoneyDestination_21100() -- "Общефирменные"; 21100; "Дворкин"
                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                  , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                   )
                                                     THEN 0 -- !!!всё в сотрудники (МО), а здесь ошибка!!! zc_Enum_AccountDirection_20600() -- "Запасы"; 20600; "сотрудники (экспедиторы)"
                                                 ELSE zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                                            END
                              END, 0) AS AccountDirectionId_To
                  -- Управленческие назначения (?От Кого? и Кому)
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                  -- Статьи назначения (?От Кого? и Кому)
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                  , COALESCE (ObjectLink_UnitTo_Juridical.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_basis_To
                    -- Берем Бизнес из товара или Подраделения
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, COALESCE (ObjectLink_UnitTo_Business.ChildObjectId, 0)) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm
                  , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE) AS isPartionDate_From
                  , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE)   AS isPartionDate_To

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                    ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                    ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
                   LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                         ON ObjectFloat_PartionGoods_Price.ObjectId = MILinkObject_PartionGoods.ObjectId
                                        AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
                   LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Unit
                                        ON ObjectLink_PartionGoods_Unit.ObjectId = MILinkObject_PartionGoods.ObjectId
                                       AND ObjectLink_PartionGoods_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver_from
                                        ON ObjectLink_Car_PersonalDriver_from.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_Car_PersonalDriver_from.DescId = zc_ObjectLink_Car_PersonalDriver()
                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_from
                                        ON ObjectLink_Personal_Member_from.ObjectId = ObjectLink_Car_PersonalDriver_from.ChildObjectId
                                       AND ObjectLink_Personal_Member_from.DescId = zc_ObjectLink_Personal_Member()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (ObjectLink_Personal_Member_from.ChildObjectId, MovementLinkObject_From.ObjectId)

                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                        ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       AND Object_From.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                        ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                       AND Object_From.DescId = zc_Object_Unit()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                   LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver_to
                                        ON ObjectLink_Car_PersonalDriver_to.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_Car_PersonalDriver_to.DescId = zc_ObjectLink_Car_PersonalDriver()
                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_to
                                        ON ObjectLink_Personal_Member_to.ObjectId = ObjectLink_Car_PersonalDriver_to.ChildObjectId
                                       AND ObjectLink_Personal_Member_to.DescId = zc_ObjectLink_Personal_Member()
                   LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (ObjectLink_Personal_Member_to.ChildObjectId, MovementLinkObject_To.ObjectId)

                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                        ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                        ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                                        ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                                        ON ObjectLink_UnitTo_Business.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()
                                       AND Object_To.DescId = zc_Object_Unit()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                           ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_To
                                           ON ObjectBoolean_PartionDate_To.ObjectId = MovementLinkObject_To.ObjectId
                                          AND ObjectBoolean_PartionDate_To.DescId = zc_ObjectBoolean_Unit_PartionDate()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_From = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.isPartionDate_From = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (PartionGoodsDate_From)
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                        THEN _tmpItem.PartionGoodsId_Item
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
                         , PartionGoodsId_To = CASE WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.isPartionDate_To = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate_To)
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                        THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.UnitId_Partion ELSE NULL END
                                                                                             , inGoodsId       := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.GoodsId ELSE NULL END
                                                                                             , inStorageId     := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.StorageId_Item ELSE NULL END
                                                                                             , inInvNumber     := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.PartionGoods ELSE NULL END
                                                                                             , inOperDate      := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.PartionGoodsDate_To ELSE NULL END
                                                                                             , inPrice         := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.Price_Partion ELSE NULL END
                                                                                              )
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
     ;

     -- определили
     vbWhereObjectId_Analyzer_From:= CASE WHEN (SELECT UnitId_From   FROM _tmpItem GROUP BY UnitId_From)   <> 0 THEN (SELECT UnitId_From   FROM _tmpItem GROUP BY UnitId_From)
                                          WHEN (SELECT MemberId_From FROM _tmpItem GROUP BY MemberId_From) <> 0 THEN (SELECT MemberId_From FROM _tmpItem GROUP BY MemberId_From) END;
     vbWhereObjectId_Analyzer_To:= CASE WHEN (SELECT UnitId_To   FROM _tmpItem GROUP BY UnitId_To)   <> 0 THEN (SELECT UnitId_To   FROM _tmpItem GROUP BY UnitId_To)
                                        WHEN (SELECT MemberId_To FROM _tmpItem GROUP BY MemberId_To) <> 0 THEN (SELECT MemberId_To FROM _tmpItem GROUP BY MemberId_To) END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. определяется для количественного учета
     UPDATE _tmpItem SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_From <> 0 THEN _tmpItem.UnitId_Item ELSE _tmpItem.UnitId_From END
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := _tmpItem.MemberId_From
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                    , inBranchId               := _tmpItem.BranchId_From
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     )
                       , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.UnitId_Item ELSE _tmpItem.UnitId_To END
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := _tmpItem.MemberId_To
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                    , inBranchId               := _tmpItem.BranchId_To
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     );

     -- 1.1.2. формируются Проводки для количественного учета - Кому + определяется MIContainer.Id (количественный)
     UPDATE _tmpItem SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                                                , inDescId         := zc_MIContainer_Count()
                                                                                , inMovementDescId := vbMovementDescId
                                                                                , inMovementId     := _tmpItem.MovementId
                                                                                , inMovementItemId := _tmpItem.MovementItemId
                                                                                , inParentId       := NULL
                                                                                , inContainerId    := _tmpItem.ContainerId_GoodsTo            -- был опеределен выше
                                                                                , inAccountId               := 0                              -- нет счета
                                                                                , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                                                , inObjectId_Analyzer       := _tmpItem.GoodsId               -- Товар
                                                                                , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- Подраделение или...
                                                                                , inContainerId_Analyzer    := _tmpItem.ContainerId_GoodsFrom -- количественный Контейнер-Корреспондент (т.е. из расхода)
                                                                                , inObjectIntId_Analyzer    := 0                              -- вид товара
                                                                                , inObjectExtId_Analyzer    := 0                              -- покупатель / физ.лицо / Подраделение "От кого"
                                                                                , inAmount         := _tmpItem.OperCount
                                                                                , inOperDate       := _tmpItem.OperDate
                                                                                , inIsActive       := TRUE                                                                                 );
     -- 1.1.3. формируются Проводки для количественного учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, _tmpItem.MovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsFrom
            , 0                                       AS AccountId              -- нет счета
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem.ContainerId_GoodsTo            AS ContainerId_Analyzer   -- количественный Контейнер-Корреспондент (т.е. из прихода)
            , _tmpItem.MIContainerId_To               AS ParentId
            , -1 * _tmpItem.OperCount
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem;


     -- 1.2. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItemSumm (MovementItemId, MIContainerId_To, ContainerId_To, AccountId_To, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , SUM (ABS (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))) AS OperSumm
        FROM _tmpItem
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- ContainerObjectCost_Basis.ObjectCostId
                                  AND _tmpItem.OperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE /*zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          -- AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * HistoryCost.Price) <> 0) -- !!!ОБЯЗАТЕЛЬНО!!! вставляем нули если это не последний раз (они нужны для расчета с/с)
          AND*/ (_tmpItem.OperCount * HistoryCost.Price) <> 0 -- !!!НЕ!!! вставляем нули
          AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
        ;


     -- для теста
     -- RETURN QUERY SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.MIContainerId_To, _tmpItemSumm.ContainerId_From, _tmpItemSumm.InfoMoneyId_Detail_From, _tmpItemSumm.OperSumm FROM _tmpItemSumm;
     -- return;


     -- 1.3.1. определяется Счет для проводок по суммовому учету - Кому
     UPDATE _tmpItemSumm SET AccountId_To = CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                     THEN _tmpItemSumm.AccountId_From -- !!!т.е. счет не меняется!!!
                                                  ELSE _tmpItem_byAccount.AccountId
                                            END
     FROM _tmpItem
          JOIN (SELECT CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                 THEN 0
                            ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                            , inAccountDirectionId     := CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                                                                                                    THEN zc_Enum_AccountDirection_20900() -- 20900; "Оборотная тара"
                                                                                               ELSE _tmpItem_group.AccountDirectionId_To
                                                                                          END
                                                            , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                            , inInfoMoneyId            := NULL
                                                            , inUserId                 := vbUserId
                                                             )
                        END AS AccountId
                     , _tmpItem_group.AccountDirectionId_To
                     , _tmpItem_group.InfoMoneyDestinationId
                FROM (SELECT _tmpItem.AccountDirectionId_To
                           , _tmpItem.InfoMoneyDestinationId
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  WHEN (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- Запасы + на упаковке AND Основное сырье + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
                      GROUP BY _tmpItem.AccountDirectionId_To
                             , _tmpItem.InfoMoneyDestinationId
                             , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                      OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                      OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                      OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                    WHEN (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- Запасы + на упаковке AND Основное сырье + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                    ELSE _tmpItem.InfoMoneyDestinationId
                               END
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.AccountDirectionId_To = _tmpItem.AccountDirectionId_To
                                      AND _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 1.3.2. определяется ContainerId для проводок по суммовому учету - Кому  + формируется Аналитика <элемент с/с>
     UPDATE _tmpItemSumm SET ContainerId_To = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := _tmpItem.OperDate
                                                                                , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN _tmpItem.UnitId_Item ELSE _tmpItem.UnitId_To END
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := _tmpItem.MemberId_To
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := _tmpItemSumm.AccountId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTo
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 1.3.3. формируются Проводки для суммового учета - Кому + определяется MIContainer.Id
     UPDATE _tmpItemSumm SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                                                    , inDescId         := zc_MIContainer_Summ()
                                                                                    , inMovementDescId := vbMovementDescId
                                                                                    , inMovementId     := MovementId
                                                                                    , inMovementItemId := _tmpItem.MovementItemId 
                                                                                    , inParentId       := NULL
                                                                                    , inContainerId    := _tmpItemSumm.ContainerId_To
                                                                                    , inAccountId               := _tmpItemSumm.AccountId_To      -- счет есть всегда
                                                                                    , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                                                    , inObjectId_Analyzer       := _tmpItem.GoodsId               -- Товар
                                                                                    , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- Подраделение или...
                                                                                    , inContainerId_Analyzer    := _tmpItemSumm.ContainerId_From  -- суммовой Контейнер-Корреспондент (т.е. из расхода)
                                                                                    , inObjectIntId_Analyzer    := 0                              -- вид товара
                                                                                    , inObjectExtId_Analyzer    := 0                              -- покупатель / физ.лицо / Подраделение "От кого"
                                                                                    , inAmount         := OperSumm
                                                                                    , inOperDate       := OperDate
                                                                                    , inIsActive       := TRUE
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 1.3.4. формируются Проводки для суммового учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, MovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_From
            , _tmpItemSumm.AccountId_From             AS AccountId              -- счет есть всегда
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm.ContainerId_To             AS ContainerId_Analyzer   -- суммовой Контейнер-Корреспондент (т.е. из прихода)
            , _tmpItemSumm.MIContainerId_To           AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;


     -- 2. формируются Проводки для отчета (Аналитики: Товар расход и Товар приход)
     INSERT INTO _tmpMIReport_insert (Id, MovementDescId, MovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate)
        SELECT 0, vbMovementDescId, inMovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate
        FROM (SELECT tmpMIReport.MovementItemId
                   , tmpMIReport.ActiveContainerId
                   , tmpMIReport.PassiveContainerId
                   , tmpMIReport.ActiveAccountId
                   , tmpMIReport.PassiveAccountId
                   , lpInsertFind_ReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                 , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                 , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                 , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                  ) AS ReportContainerId
                   , lpInsertFind_ChildReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                      , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                      , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                      , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                      --, inAccountKindId_1    := NULL
                                                      --, inContainerId_1      := NULL
                                                      --, inAccountId_1        := NULL
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , tmpMIReport.OperDate
              FROM (SELECT (tmpCalc.OperSumm)       AS OperSumm
                         , tmpCalc.ContainerId_To   AS ActiveContainerId
                         , tmpCalc.ContainerId_From AS PassiveContainerId
                         , tmpCalc.AccountId_To     AS ActiveAccountId
                         , tmpCalc.AccountId_From   AS PassiveAccountId
                         , tmpCalc.OperDate
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItem.OperDate
                               , _tmpItemSumm.MovementItemId
                               , _tmpItemSumm.ContainerId_From
                               , _tmpItemSumm.AccountId_From
                               , _tmpItemSumm.ContainerId_To
                               , _tmpItemSumm.AccountId_To
                               , (_tmpItemSumm.OperSumm) AS OperSumm
                          FROM _tmpItemSumm
                              JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     -- !!!формируется свойство <Цена>!!!
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), tmp.PartionGoodsId, tmp.Price)
     FROM (SELECT _tmpItem.PartionGoodsId_To AS PartionGoodsId, SUM (tmp.OperSumm) / SUM (_tmpItem.OperCount) AS Price
           FROM _tmpItem
                INNER JOIN (SELECT _tmpItemSumm.MovementItemId, SUM (_tmpItemSumm.OperSumm) AS OperSumm FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                           ) AS tmp ON tmp.MovementItemId = _tmpItem.MovementItemId
           WHERE _tmpItem.PartionGoodsId_To > 0
             AND _tmpItem.OperCount > 0
             AND (_tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                    , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                    , zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                     )
                  )
           GROUP BY _tmpItem.PartionGoodsId_To
          ) AS tmp;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();
     -- 5.2. ФИНИШ - Обязательно сохраняем Проводки для Отчета
     PERFORM lpInsertUpdate_MIReport_byTable ();

     -- 5.3. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Send()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.14                                        * add MovementDescId
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 05.08.14                                        * add UnitId_Item and ...
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 15.09.13                                        * add zc_Enum_Account_20901
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsLastComplete
 10.08.13                                        * в проводках для количественного и суммового учета: Master - приход, Child - расход (т.к. перемещение то связь 1:1)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 24.07.13                                        * !ОБЯЗАТЕЛЬНО! вставляем нули
 20.07.13                                        * add MovementItemId
 20.07.13                                        * all Партии товара, ЕСЛИ надо ...
 19.07.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
