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
  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя
  DECLARE vbUserId Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer_From Integer;
  DECLARE vbWhereObjectId_Analyzer_To   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= lpGetUserBySession (inSession)  :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Send());
     END IF;

     -- Эти параметры нужны для
     vbMovementDescId:= zc_Movement_Send();


     -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = vbUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = vbUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = vbUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = vbUserId AND View_UserRole.RoleId IN (97837)) -- Бухгалтер ДНЕПР
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Send_CreateTemp();

     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId_From, MemberId_From, BranchId_From, UnitId_To, MemberId_To, BranchId_To
                         , MIContainerId_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, ObjectDescId, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate_From, PartionGoodsDate_To
                         , OperCount
                         , AccountDirectionId_From, AccountDirectionId_To, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , JuridicalId_basis_To, BusinessId_To
                         , StorageId_Item, PartionGoodsId_Item
                         , isPartionCount, isPartionSumm, isPartionDate_From, isPartionDate_To, isPartionGoodsKind_From, isPartionGoodsKind_To
                         , PartionGoodsId_From, PartionGoodsId_To
                         , ProfitLossGroupId, ProfitLossDirectionId, UnitId_ProfitLoss, BranchId_ProfitLoss, BusinessId_ProfitLoss
                          )
        WITH tmpMember AS (SELECT lfSelect.MemberId, lfSelect.UnitId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
           , tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                            , MovementItem.MovementId
                            , Movement.OperDate
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS MemberId_From
                            , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS MemberId_To
                            , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To

                            , Object_Goods.DescId AS ObjectDescId
                            , MovementItem.ObjectId AS GoodsId
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   ELSE 0
                              END AS GoodsKindId
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                            , 0                                              AS AssetId
                            , COALESCE (MILinkObject_Storage.ObjectId, 0)    AS StorageId_Item
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
                              -- Управленческая группа
                            , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
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
                            , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_From
                            , COALESCE (ObjectBoolean_PartionGoodsKind_To.ValueData, TRUE)   AS isPartionGoodsKind_To

                              -- Группы ОПиУ - криво захардкодил
                            , CASE WHEN Movement.OperDate >= '01.05.2017'
                                    AND Object_From.Id IN (8455 , 8456) -- Склад специй + Склад запчастей
                                    AND Object_To_find.DescId = zc_Object_Member()
                                    AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                                , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                 )
                                        THEN COALESCE (lfSelect.ProfitLossGroupId, 1)
                              END AS ProfitLossGroupId
                              -- Аналитики ОПиУ - направления
                            , COALESCE (lfSelect.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

                              -- для ОПиУ
                            , tmpMemberTo.UnitId                                  AS UnitId_ProfitLoss
                              -- для ОПиУ
                            , ObjectLink_UnitTo_Branch_ProfitLoss.ChildObjectId   AS BranchId_ProfitLoss
                              -- для ОПиУ
                            , ObjectLink_UnitTo_Business_ProfitLoss.ChildObjectId AS BusinessId_ProfitLoss

                        FROM Movement
                             JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                              ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                              ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()

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
                             LEFT JOIN Object AS Object_To_find ON Object_To_find.Id = MovementLinkObject_To.ObjectId

                             -- для затрат
                             LEFT JOIN tmpMember AS tmpMemberTo ON tmpMemberTo.MemberId = MovementLinkObject_To.ObjectId
                             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect ON lfSelect.UnitId = tmpMemberTo.UnitId
                             LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch_ProfitLoss
                                                  ON ObjectLink_UnitTo_Branch_ProfitLoss.ObjectId = tmpMemberTo.UnitId
                                                 AND ObjectLink_UnitTo_Branch_ProfitLoss.DescId = zc_ObjectLink_Unit_Branch()
                             LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business_ProfitLoss
                                                  ON ObjectLink_UnitTo_Business_ProfitLoss.ObjectId = tmpMemberTo.UnitId
                                                 AND ObjectLink_UnitTo_Business_ProfitLoss.DescId = zc_ObjectLink_Unit_Business()

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

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_From
                                                     ON ObjectBoolean_PartionGoodsKind_From.ObjectId = MovementLinkObject_From.ObjectId
                                                    AND ObjectBoolean_PartionGoodsKind_From.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_To
                                                     ON ObjectBoolean_PartionGoodsKind_To.ObjectId = MovementLinkObject_To.ObjectId
                                                    AND ObjectBoolean_PartionGoodsKind_To.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

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

                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                             ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                       THEN -- !!!временно захардкодил!!! - Капитальные инвестиции + Производственное оборудование
                                                                                                            zc_Enum_InfoMoney_70102()
                                                                                                  ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                             END
                        WHERE Movement.Id = inMovementId
                          AND Movement.DescId = zc_Movement_Send()
                          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       )
, tmpContainer_all AS (SELECT tmpMI.MovementItemId
                            , tmpMI.GoodsId
                            , tmpMI.OperCount   AS Amount
                            , Container.Id      AS ContainerId
                            , Container.Amount  AS Amount_container
                            , SUM (Container.Amount) OVER (PARTITION BY tmpMI.GoodsId ORDER BY COALESCE (ObjectDate_Value.ValueData, zc_DateStart()), Container.Id) AS AmountSUM --
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId ORDER BY COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) DESC, Container.Id DESC) AS Ord       -- !!!Надо отловить ПОСЛЕДНИЙ!!!
                            , CLO_PartionGoods.ObjectId AS PartionGoodsId
                       FROM tmpMI
                            INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                AND Container.DescId   = zc_Container_Count()
                                                AND Container.Amount   > 0
                            INNER JOIN ContainerLinkObject AS CLO_Member
                                                           ON CLO_Member.ContainerId = Container.Id
                                                          AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                          AND CLO_Member.ObjectId    = (SELECT DISTINCT tmpMI.MemberId_From FROM tmpMI WHERE tmpMI.MemberId_From <> 0)
                            INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                           ON CLO_PartionGoods.ContainerId = Container.Id
                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                            LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                    AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                       WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                            , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                            , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                             )
                      )
    , tmpContainer AS (SELECT DD.ContainerId
                            , DD.GoodsId
                            , DD.MovementItemId
                            , DD.PartionGoodsId
                            , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1
                                        THEN DD.Amount_container
                                   ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                              END AS Amount
                       FROM (SELECT * FROM tmpContainer_all) AS DD
                       WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                      )
        -- Результат
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

              -- сформируем позже
            , 0 AS MIContainerId_To
            , COALESCE (tmpContainer.ContainerId, 0) AS ContainerId_Goods -- !!!или подбор партий!!!
            , 0 AS ContainerId_GoodsTo

            , _tmp.ObjectDescId
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.GoodsKindId_complete
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate_From
            , _tmp.PartionGoodsDate_To

            , COALESCE (tmpContainer.Amount, _tmp.OperCount) AS OperCount

              -- Аналитики счетов - направления (От Кого)
            , _tmp.AccountDirectionId_From
              -- Аналитики счетов - направления (Кому)
            , _tmp.AccountDirectionId_To
              -- Управленческая группа
            , _tmp.InfoMoneyGroupId
              -- Управленческие назначения (?От Кого? и Кому)
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения (?От Кого? и Кому)
            , _tmp.InfoMoneyId

            , _tmp.JuridicalId_basis_To
            , _tmp.BusinessId_To

             , _tmp.StorageId_Item
             , COALESCE (tmpContainer.PartionGoodsId, 0) AS PartionGoodsId_Item

            , _tmp.isPartionCount
            , _tmp.isPartionSumm
            , _tmp.isPartionDate_From
            , _tmp.isPartionDate_To
            , _tmp.isPartionGoodsKind_From
            , _tmp.isPartionGoodsKind_To
              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId_From
            , 0 AS PartionGoodsId_To

              -- Группы ОПиУ
            , _tmp.ProfitLossGroupId
              -- Аналитики ОПиУ - направления
            , _tmp.ProfitLossDirectionId
              -- для ОПиУ
            , _tmp.UnitId_ProfitLoss
              -- для ОПиУ
            , _tmp.BranchId_ProfitLoss
              -- для ОПиУ
            , _tmp.BusinessId_ProfitLoss

        FROM tmpMI AS _tmp
             LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = _tmp.MovementItemId
       ;


     -- Проверка - т.к.для этих УП-статей могли искать партии - надо что б товар был уникальным
     IF EXISTS (SELECT _tmpItem.GoodsId
                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.InfoMoneyDestinationId FROM _tmpItem
                     ) AS _tmpItem
                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                        , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                        , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                         )
                GROUP BY _tmpItem.GoodsId
                HAVING COUNT(*) > 1)
     THEN
          RAISE EXCEPTION 'Ошибка.В документе нельзя дублировать товар <%>.'
              , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId
                                         FROM (SELECT _tmpItem.GoodsId
                                               FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.InfoMoneyDestinationId FROM _tmpItem
                                                    ) AS _tmpItem
                                               WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                       , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                       , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                        )
                                               GROUP BY _tmpItem.GoodsId
                                               HAVING COUNT(*) > 1
                                              ) AS _tmpItem
                                              LIMIT 1
                                        ));
     END IF;



     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                         )
                                                      AND _tmpItem.PartionGoodsId_Item > 0
                                                      -- AND _tmpItem.MemberId_From       > 0
                                                        THEN _tmpItem.PartionGoodsId_Item

                                                    WHEN _tmpItem.ObjectDescId     = zc_Object_Asset()
                                                      OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                      OR ((_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                          )
                                                         AND _tmpItem.MemberId_From > 0
                                                         )

                                                         THEN (SELECT CLO_PartionGoods.ObjectId -- ObjectLink_Goods.ObjectId
                                                               FROM ObjectLink AS ObjectLink_Goods
                                                                    INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                                          ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                                                    INNER JOIN ObjectLink AS ObjectLink_Storage
                                                                                          ON ObjectLink_Storage.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                                                    LEFT JOIN Container ON Container.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                                       AND Container.DescId   = zc_Container_Count()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                                                  ON CLO_Member.ContainerId = Container.Id
                                                                                                 AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                               WHERE ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                                 AND ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                                               ORDER BY CASE WHEN CLO_PartionGoods.ObjectId = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 1
                                                                             WHEN COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                                  THEN 2
                                                                             ELSE 3
                                                                        END ASC
                                                                      , Container.Amount DESC
                                                               LIMIT 1
                                                              )
                                                    WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_From = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.isPartionDate_From = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate_From
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                         )
                                                        THEN _tmpItem.PartionGoodsId_Item

                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
                         , PartionGoodsId_To = CASE WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                       OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                         )
                                                      AND _tmpItem.PartionGoodsId_Item > 0
                                                      AND _tmpItem.MemberId_From       > 0
                                                      AND _tmpItem.MemberId_To         > 0
                                                        THEN _tmpItem.PartionGoodsId_Item

                                                    WHEN _tmpItem.ObjectDescId     = zc_Object_Asset()
                                                      OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                      OR ((_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                          )
                                                         AND _tmpItem.MemberId_From > 0
                                                         AND _tmpItem.UnitId_To     = 0
                                                         )
                                                         THEN (SELECT CLO_PartionGoods.ObjectId -- ObjectLink_Goods.ObjectId
                                                               FROM ObjectLink AS ObjectLink_Goods
                                                                    INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                                          ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                                                    INNER JOIN ObjectLink AS ObjectLink_Storage
                                                                                          ON ObjectLink_Storage.ObjectId = ObjectLink_Goods.ObjectId
                                                                                         AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                                                    LEFT JOIN Container ON Container.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                                       AND Container.DescId   = zc_Container_Count()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                                                  ON CLO_Member.ContainerId = Container.Id
                                                                                                 AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                    LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                               WHERE ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                                 AND ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                                               ORDER BY CASE WHEN CLO_PartionGoods.ObjectId = ObjectLink_Goods.ObjectId
                                                                              AND COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                              AND Container.Amount > 0
                                                                                  THEN 1
                                                                             WHEN COALESCE (CLO_Unit.ObjectId, 0)   = _tmpItem.UnitId_From
                                                                              AND COALESCE (CLO_Member.ObjectId, 0) = _tmpItem.MemberId_From
                                                                                  THEN 2
                                                                             ELSE 3
                                                                        END ASC
                                                                      , Container.Amount DESC
                                                               LIMIT 1
                                                              )
                                                    WHEN _tmpItem.OperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.isPartionDate_To = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate_To
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                        THEN CASE WHEN _tmpItem.UnitId_From <> 0 AND _tmpItem.MemberId_To <> 0
                                                                       THEN -- !!!Партия создается, потом надо будет залить цену
                                                                            lpInsertFind_Object_PartionGoods (inUnitId_Partion:= _tmpItem.UnitId_From
                                                                                                            , inGoodsId       := _tmpItem.GoodsId
                                                                                                            , inStorageId     := _tmpItem.StorageId_Item
                                                                                                            , inInvNumber     := _tmpItem.PartionGoods
                                                                                                            , inOperDate      := _tmpItem.OperDate
                                                                                                            , inPrice         := 0
                                                                                                             )
                                                                  WHEN _tmpItem.MemberId_To <> 0
                                                                       THEN -- !!!Партия создается - вдруг изменился StorageId
                                                                            lpInsertFind_Object_PartionGoods (inUnitId_Partion:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem.PartionGoodsId_Item AND OL.DescId = zc_ObjectLink_PartionGoods_Unit())
                                                                                                            , inGoodsId       := CASE WHEN _tmpItem.PartionGoodsId_Item > 0 THEN _tmpItem.GoodsId ELSE 0 END
                                                                                                            , inStorageId     := _tmpItem.StorageId_Item
                                                                                                            , inInvNumber     := (SELECT Object.ValueData FROM Object WHERE Object.Id = _tmpItem.PartionGoodsId_Item)
                                                                                                            , inOperDate      := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem.PartionGoodsId_Item AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                                            , inPrice         := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem.PartionGoodsId_Item AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                                             )
                                                                  WHEN _tmpItem.UnitId_To <> 0
                                                                       THEN -- !!!если вернулось на склад - будет ПУСТАЯ Партия
                                                                            0
                                                                            
                                                                  -- !!!Партия не меняется - т.е. как в расходе, хотя надо бы отследить
                                                                  ELSE _tmpItem.PartionGoodsId_Item
                                                             END
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
        OR _tmpItem.ObjectDescId           = zc_Object_Asset()
    ;

-- if inMovementId = 7259158 
-- then
--    RAISE EXCEPTION '<%>  %', (select distinct _tmpItem.PartionGoodsId_from from _tmpItem where _tmpItem.GoodsId = 1105050)
--    , (select count(*) from _tmpItem where _tmpItem.GoodsId = 1105050);
--
-- end if;
     -- определили
     vbWhereObjectId_Analyzer_From:= CASE WHEN (SELECT DISTINCT UnitId_From   FROM _tmpItem)   <> 0 THEN (SELECT DISTINCT UnitId_From   FROM _tmpItem)
                                          WHEN (SELECT DISTINCT MemberId_From FROM _tmpItem) <> 0 THEN (SELECT DISTINCT MemberId_From FROM _tmpItem) END;
     vbWhereObjectId_Analyzer_To:= CASE WHEN (SELECT DISTINCT UnitId_To   FROM _tmpItem)   <> 0 THEN (SELECT DISTINCT UnitId_To   FROM _tmpItem)
                                        WHEN (SELECT DISTINCT MemberId_To FROM _tmpItem) <> 0 THEN (SELECT DISTINCT MemberId_To FROM _tmpItem) END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. определяется для количественного учета
     UPDATE _tmpItem SET ContainerId_GoodsFrom = CASE WHEN _tmpItem.ContainerId_GoodsFrom > 0 THEN _tmpItem.ContainerId_GoodsFrom
                                                  ELSE
                                                 lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_From <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_From END
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := _tmpItem.MemberId_From
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                    , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                                  CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                                  FROM Container
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_From
                                                                                                                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                      ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                                  WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                    AND Container.DescId   = zc_Container_Count()
                                                                                                                                  ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                                  LIMIT 1
                                                                                                                                 )
                                                                                                                       ELSE _tmpItem.AssetId
                                                                                                                  END
                                                                                    , inBranchId               := _tmpItem.BranchId_From
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     )
                                                 END
                       , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := _tmpItem.OperDate
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_To END
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := _tmpItem.MemberId_To
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                    , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                                  CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                            THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                                  FROM Container
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_To
                                                                                                                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                       INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                      ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                     AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                                  WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                    AND Container.DescId   = zc_Container_Count()
                                                                                                                                  ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                                  LIMIT 1
                                                                                                                                 )
                                                                                                                       ELSE _tmpItem.AssetId
                                                                                                                  END
                                                                                    , inBranchId               := _tmpItem.BranchId_To
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     );



     -- 1.2. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItemSumm (MovementItemId, MIContainerId_To, ContainerId_To, AccountId_To, ContainerId_ProfitLoss, ContainerId_GoodsFrom, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , 0 AS ContainerId_ProfitLoss
            , _tmpItem.ContainerId_GoodsFrom
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , SUM ( CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) -- ABS
                 /*+ CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                        ELSE 0
                   END*/) AS OperSumm
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
          AND vbIsHistoryCost= TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.ContainerId_GoodsFrom
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
        ;



     -- 1.3.1. определяется Счет для проводок по суммовому учету - Кому
     UPDATE _tmpItemSumm SET AccountId_To = CASE WHEN _tmpItemSumm.AccountId_From IN (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- Прибыль будущих периодов
                                                     THEN _tmpItemSumm.AccountId_From -- !!!т.е. счет не меняется!!!

                                                 WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
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
                FROM (SELECT DISTINCT
                             _tmpItem.AccountDirectionId_To
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
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.AccountDirectionId_To  = _tmpItem.AccountDirectionId_To
                                      AND _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom;


     -- 1.3.2. определяется ContainerId для проводок по суммовому учету - Кому  + определяется контейнер для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss =
                               CASE WHEN _tmpItem.ProfitLossGroupId <> 0
                                         THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                    , inParentId          := NULL
                                                                    , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                                    , inJuridicalId_basis := _tmpItem.JuridicalId_Basis_To
                                                                    , inBusinessId        := _tmpItem.BusinessId_ProfitLoss -- !!!подставляем Бизнес для Прибыль!!!
                                                                    , inObjectCostDescId  := NULL
                                                                    , inObjectCostId      := NULL
                                                                    , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                    , inObjectId_1        := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                                                                           , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                                                                           , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                                                           , inInfoMoneyId            := NULL
                                                                                                                           , inUserId                 := vbUserId
                                                                                                                            )
                                                                    , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                    , inObjectId_2        := _tmpItem.BranchId_ProfitLoss
                                                                     )
                               END
                           , ContainerId_To = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := _tmpItem.OperDate
                                                                                , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 /*_tmpItem.UnitId_Item*/ ELSE _tmpItem.UnitId_To END
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
                                                                                , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId_To
                                                                                                                                                                 AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                                  ON CLO_AssetTo.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                              WHERE Container.ObjectId = _tmpItem.GoodsId
                                                                                                                                AND Container.DescId   = zc_Container_Count()
                                                                                                                              ORDER BY Container.Amount DESC, COALESCE (CLO_AssetTo.ObjectId, 0) DESC
                                                                                                                              LIMIT 1
                                                                                                                             )
                                                                                                                   ELSE _tmpItem.AssetId
                                                                                                              END
                                                                                 )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       ;



     -- 1.1.2. формируются Проводки для количественного учета - Кому + определяется MIContainer.Id (количественный) - !!!после прибыли, т.к. нужен ContainerId_ProfitLoss!!!
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
                                                                                , inContainerId_Analyzer    := CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END -- Контейнер ОПиУ - статья ОПиУ
                                                                                , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- вид товара
                                                                                , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- Подраделение "От кого"
                                                                                , inContainerIntId_Analyzer := _tmpItem.ContainerId_GoodsFrom -- количественный Контейнер-Корреспондент (т.е. из расхода)
                                                                                , inAmount         := _tmpItem.OperCount
                                                                                , inOperDate       := _tmpItem.OperDate
                                                                                , inIsActive       := TRUE
                                                                                 );
     -- 1.1.3. формируются Проводки для количественного учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, _tmpItem.MovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsFrom
            , 0                                       AS AccountId              -- нет счета
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , CASE WHEN _tmpItem.ProfitLossGroupId > 0 THEN (SELECT _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId LIMIT 1) ELSE 0 END AS ContainerId_Analyzer -- Контейнер ОПиУ - статья ОПиУ
            , _tmpItem.ContainerId_GoodsTo            AS ContainerIntId_Analyzer   -- количественный Контейнер-Корреспондент (т.е. из прихода)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , _tmpItem.MIContainerId_To               AS ParentId
            , -1 * _tmpItem.OperCount
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem;


     -- 1.3.3. формируются Проводки для суммового учета - Кому + определяется MIContainer.Id
     UPDATE _tmpItemSumm SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                                                    , inDescId         := zc_MIContainer_Summ()
                                                                                    , inMovementDescId := vbMovementDescId
                                                                                    , inMovementId     := MovementId
                                                                                    , inMovementItemId := _tmpItem.MovementItemId
                                                                                    , inParentId       := NULL
                                                                                    , inContainerId    := _tmpItemSumm.ContainerId_To
                                                                                    , inAccountId               := _tmpItemSumm.AccountId_To      -- счет есть всегда
                                                                                    , inAnalyzerId              := CASE WHEN _tmpItem.ProfitLossGroupId <> 0 THEN zc_Enum_AnalyzerId_ProfitLoss() ELSE vbWhereObjectId_Analyzer_From END  -- "иногда" есть аналитика, но для ускорения отчетов будет Подраделение "От кого" или...
                                                                                    , inObjectId_Analyzer       := _tmpItem.GoodsId               -- Товар
                                                                                    , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- Подраделение или...
                                                                                    , inContainerId_Analyzer    := _tmpItemSumm.ContainerId_ProfitLoss -- Контейнер ОПиУ - статья ОПиУ
                                                                                    , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- вид товара
                                                                                    , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- Подраделение "От кого"
                                                                                    , inContainerIntId_Analyzer := _tmpItemSumm.ContainerId_From  -- суммовой Контейнер-Корреспондент (т.е. из расхода)
                                                                                    , inAmount         := OperSumm
                                                                                    , inOperDate       := OperDate
                                                                                    , inIsActive       := TRUE
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       ;

     -- 1.3.4. формируются Проводки для суммового учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, MovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_From
            , _tmpItemSumm.AccountId_From             AS AccountId              -- счет есть всегда
            , CASE WHEN _tmpItem.ProfitLossGroupId <> 0 THEN zc_Enum_AnalyzerId_ProfitLoss() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- "иногда" есть аналитика, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm.ContainerId_ProfitLoss     AS ContainerId_Analyzer   -- Контейнер ОПиУ - статья ОПиУ
            , _tmpItemSumm.ContainerId_To             AS ContainerIntId_Analyzer-- суммовой Контейнер-Корреспондент (т.е. из прихода)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , _tmpItemSumm.MIContainerId_To           AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
                             ;


     -- 1.3.5. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ContainerIntId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- прибыль текущего периода
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItemSumm_group.GoodsId              AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Физ лицо на кого переместили ...
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , 0                                       AS ContainerIntId_Analyzer-- в ОПиУ не нужен
            , _tmpItemSumm_group.GoodsKindId          AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItemSumm_group.UnitId_ProfitLoss    AS ObjectExtId_Analyzer   -- Подраделение к которому относится Физ лицо - т.к. оно определяет чьи это затраты
            , 0                                       AS ParentId
            , _tmpItemSumm_group.OperSumm
            , _tmpItemSumm_group.OperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_ProfitLoss
                  , _tmpItem.GoodsId
                  , _tmpItem.GoodsKindId
                  , _tmpItem.UnitId_ProfitLoss
                  , _tmpItem.OperDate
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE _tmpItemSumm.ContainerId_ProfitLoss <> 0
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
                    , _tmpItem.UnitId_ProfitLoss
                    , _tmpItem.OperDate
            ) AS _tmpItemSumm_group
      UNION ALL
       -- тут же списали с остатка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, MovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_To
            , _tmpItemSumm.AccountId_To               AS AccountId              -- счет есть всегда
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm.ContainerId_ProfitLoss     AS ContainerId_Analyzer   -- Контейнер ОПиУ - статья ОПиУ
            , 0                                       AS ContainerIntId_Analyzer-- здесь не нужен
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , NULL                                    AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , _tmpItem.OperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       WHERE _tmpItemSumm.ContainerId_ProfitLoss <> 0;


     -- !!!формируется свойство <Цена> - у партии ТМЦ!!!
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), tmp.PartionGoodsId, tmp.Price)
     FROM (SELECT _tmpItem.PartionGoodsId_To AS PartionGoodsId, SUM (tmp.OperSumm) / SUM (_tmpItem.OperCount) AS Price
           FROM _tmpItem
                INNER JOIN (SELECT _tmpItemSumm.MovementItemId, SUM (_tmpItemSumm.OperSumm) AS OperSumm FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                           ) AS tmp ON tmp.MovementItemId = _tmpItem.MovementItemId
           WHERE _tmpItem.UnitId_From <> 0 AND _tmpItem.MemberId_To <> 0 -- Только если переместили на МО
             AND _tmpItem.PartionGoodsId_To > 0
             AND _tmpItem.OperCount > 0
             AND (_tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                    , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
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

/*
Форма Перемещение МО - новый селект - по остаткам ПАРТИЙ на "МО от кого" - показать в гриде партии zc_ContainerLinkObject_AssetTo + zc_ContainerLinkObject_PartionGoods : zc_ObjectLink_PartionGoods_Unit + zc_ObjectLink_PartionGoods_Storage = Место хранения + Object.ValueData = Инв Номер + zc_ObjectDate_PartionGoods_Value = Дата перемещения + zc_ObjectFloat_PartionGoods_Price = "Цена списания" и сохранять в gpInsertUpdate_MovementItem_SendMember ТОЛЬКО 1) inGoodsId + inGoodsKindId + inAssetId + inPartionGoodsDate + ioPartionGoods + inUnitId + inStorageId - ОСТАЛЬНОЕ УБИРАЕМ + из селекта тоже + в гриде меняются для партии только StorageId , Т.Е. на показать ВСЕ - SELECT Container union all  MovementItem где парам партии + товар +inAssetId  это ключ и строчки не должны дублироваться + Если это перемещение со склада НА МО - тогда в zc_ContainerLinkObject_PartionGoods для склада = нулл , и берем это св-во из проводок для МО, а если не проведен тогда  а на "показать ВСЕ" ключ будет GoodsId + GoodsKindId
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 5854348, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= zfCalc_UserAdmin())
