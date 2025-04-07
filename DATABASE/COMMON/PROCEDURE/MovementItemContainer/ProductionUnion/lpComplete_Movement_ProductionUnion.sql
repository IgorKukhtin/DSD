-- Function: lpComplete_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsHistoryCost     Boolean              , -- параметр что б ускорить ввод док-тов произв и не формировать проводки с/с
    IN inUserId            Integer                -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя

  DECLARE vbWhereObjectId_Analyzer_From Integer;
  DECLARE vbWhereObjectId_Analyzer_To Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbBranchId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_Unit_From Boolean;
  DECLARE vbIsPartionGoodsKind_Unit_From Boolean;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;

  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit_To Boolean;
  DECLARE vbIsPartionGoodsKind_Unit_To Boolean;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;

  DECLARE vbIsPartionCell_from Boolean;
  DECLARE vbIsPartionCell_to   Boolean;

  DECLARE vbIsPeresort Boolean;
  DECLARE vbIsBranch   Boolean;
  DECLARE vbProcessId Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - количественные Master(приход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_pr;
     -- !!!обязательно!!! очистили таблицу - суммовые Master(приход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm_pr;
     -- !!!обязательно!!! очистили таблицу - количественные Child(расход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemChild;
     -- !!!обязательно!!! очистили таблицу - суммовые Child(расход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSummChild;


     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT Movement.DescId, Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN ObjectLink_UnitFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From

            -- Аналитики счетов - направления !!!нужны только для подразделения!!!
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                           WHEN Object_From.DescId IN (zc_Object_Personal(), zc_Object_Member())
                                THEN zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                      END, 0) AS AccountDirectionId_From -- !!!не окончательное значение, т.к. еще может зависить от Товара!!!

          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)     AS isPartionDate_Unit_From
          , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_Unit_From

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN zc_Juridical_Basis() WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN 0                    WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId  WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId  ELSE 0 END, 0) AS BusinessId_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()   THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN MovementLinkObject_To.ObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()   THEN ObjectLink_UnitTo_Branch.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_To

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitTo_AccountDirection.ChildObjectId
                           WHEN Object_To.DescId IN (zc_Object_Personal(), zc_Object_Member())
                                THEN zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                      END, 0) AS AccountDirectionId_To -- !!!не окончательное значение, т.к. еще может зависить от Товара!!!

          , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE)     AS isPartionDate_Unit_To

          , COALESCE (ObjectBoolean_PartionGoodsKind_To.ValueData, TRUE) AS isPartionGoodsKind_Unit_To

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN zc_Juridical_Basis() WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN 0                    WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId  WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId  ELSE 0 END, 0) AS BusinessId_To

          , COALESCE (MovementBoolean_Peresort.ValueData, FALSE) AS isPeresort
          , CASE WHEN ObjectLink_UnitFrom_Branch.ChildObjectId = ObjectLink_UnitTo_Branch.ChildObjectId
                  AND ObjectLink_UnitFrom_Branch.ChildObjectId > 0
                  AND ObjectLink_UnitFrom_Branch.ChildObjectId <> zc_Branch_Basis()
                      THEN TRUE
                 ELSE FALSE
            END AS isBranch

          , COALESCE (MovementLinkObject_User.ObjectId, 0)       AS ProcessId

            INTO vbMovementDescId, vbOperDate, vbUnitId_From, vbMemberId_From, vbBranchId_From, vbAccountDirectionId_From, vbIsPartionDate_Unit_From, vbIsPartionGoodsKind_Unit_From, vbJuridicalId_Basis_From, vbBusinessId_From
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbAccountDirectionId_To, vbIsPartionDate_Unit_To, vbIsPartionGoodsKind_Unit_To, vbJuridicalId_Basis_To, vbBusinessId_To
               , vbIsPeresort, vbIsBranch, vbProcessId
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                    ON MovementBoolean_Peresort.MovementId = Movement.Id
                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                       ON MovementLinkObject_User.MovementId = Movement.Id
                                      AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                               ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                  ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_From
                                  ON ObjectBoolean_PartionGoodsKind_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionGoodsKind_From.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
                                 AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                               ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Business
                               ON ObjectLink_UnitFrom_Business.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Member
                               ON ObjectLink_PersonalFrom_Member.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Unit
                               ON ObjectLink_PersonalFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Unit.DescId = zc_ObjectLink_Personal_Unit()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Juridical
                               ON ObjectLink_UnitPersonalFrom_Juridical.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalFrom_Business
                               ON ObjectLink_UnitPersonalFrom_Business.ObjectId = ObjectLink_PersonalFrom_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_From.DescId = zc_Object_Personal()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                               ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                               ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_To.DescId = zc_Object_Unit()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_To
                                  ON ObjectBoolean_PartionDate_To.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_PartionDate_To.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_To
                                  ON ObjectBoolean_PartionGoodsKind_To.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_PartionGoodsKind_To.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
                                 AND Object_To.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                               ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                               ON ObjectLink_UnitTo_Business.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_To.DescId = zc_Object_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Member
                               ON ObjectLink_PersonalTo_Member.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PersonalTo_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Unit
                               ON ObjectLink_PersonalTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PersonalTo_Unit.DescId = zc_ObjectLink_Personal_Unit()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Branch
                               ON ObjectLink_UnitPersonalTo_Branch.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Juridical
                               ON ObjectLink_UnitPersonalTo_Juridical.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Business
                               ON ObjectLink_UnitPersonalTo_Business.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalTo_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_To.DescId = zc_Object_Personal()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionUnion()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- Если учет по ячейкам - РАСХОД - Учет будет для От КОГО
     vbIsPartionCell_from:= (inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
                         AND vbUnitId_From = zc_Unit_RK()
                         AND vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                            )
                         OR (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                         AND vbUnitId_From = zc_Unit_RK()
                            )
                           ;
     -- Если учет по ячейкам - РАСХОД - Учет будет для От КОГО
     vbIsPartionCell_to:= (inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
                         AND vbUnitId_To = zc_Unit_RK()
                         AND vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                            )
                         OR (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                         AND vbUnitId_To = zc_Unit_RK()
                            )
                           ;

     -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
        OR vbOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '0 DAY')
     THEN
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         /*IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- Бухгалтер ДНЕПР
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;*/
         vbIsHistoryCost:= FALSE;
     END IF;


     -- заполняем таблицу - количественные Master(приход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_pr (MovementItemId
                            , MIContainerId_To, MIContainerId_count, ContainerId_GoodsTo, ContainerId_count, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                            , OperCount, OperCountCount
                            , InfoMoneyDestinationId, InfoMoneyId
                            , BusinessId_To
                            , UnitId_Item, StorageId_Item
                            , isPartionCount, isPartionSumm
                            , PartionGoodsId
                            , PartNumber, PartionModelName
                            , isAsset, ObjectDescId
                             )
        SELECT _tmp.MovementItemId

             , 0 AS MIContainerId_To
             , 0 AS MIContainerId_count
             , 0 AS ContainerId_GoodsTo
             , 0 AS ContainerId_count
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , _tmp.GoodsKindId_complete
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

             , _tmp.OperCount
             , _tmp.OperCountCount

               -- Управленческие назначения
             , _tmp.InfoMoneyDestinationId
               -- Статьи назначения
             , _tmp.InfoMoneyId

               -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
             , CASE WHEN _tmp.BusinessId_To = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId_To END AS BusinessId_To

             , 0 AS UnitId_Item
             , CASE WHEN _tmp.isAsset = TRUE THEN _tmp.StorageId ELSE 0 END AS StorageId_Item

             , _tmp.isPartionCount
             , _tmp.isPartionSumm

               -- Партии товара, сформируем позже
             , 0 AS PartionGoodsId

             , _tmp.PartNumber
             , _tmp.PartionModelName
             , _tmp.isAsset
             , _tmp.ObjectDescId

        FROM
             (SELECT MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                          WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- Тушенка
                           AND MILinkObject_GoodsKind.ObjectId <> zc_GoodsKind_Basis()
                           AND vbUnitId_From IN (8006902 -- ЦЕХ упаковки Тушенки
                                               , 8451    -- ЦЕХ упаковки
                                                )
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                           AND vbIsPartionGoodsKind_Unit_To = TRUE
                           AND _tmpList_Goods_1942.GoodsId IS NULL
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                           AND View_InfoMoney.InfoMoneyId NOT IN (zc_Enum_InfoMoney_10105()  -- Прочее мясное сырье
                                                                , zc_Enum_InfoMoney_10106()  -- Сыр
                                                                 )
                           AND vbIsPartionDate_Unit_To = TRUE
                           AND MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress()
                               -- !!!замена!!!
                               THEN zc_GoodsKind_Basis()

                          ELSE 0
                     END AS GoodsKindId

                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete

                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MILinkObject_Storage.ObjectId, 0) AS StorageId
                   , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                   , CASE WHEN vbIsPeresort = TRUE THEN COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) ELSE Movement.OperDate END AS PartionGoodsDate

                     -- OperCount
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- Тушенка
                           AND vbUnitId_From IN (2790412) -- ЦЕХ Тушенка
                           AND MIFloat_CountReal.ValueData > 0
                               -- замена
                               THEN MIFloat_CountReal.ValueData

                          ELSE MovementItem.Amount
                     END AS OperCount

                   , COALESCE (MIFloat_Count.ValueData, 0) AS OperCountCount

                  -- Управленческие назначения
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                  -- Статьи назначения
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0)  AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)  AS isPartionSumm

                  , MIString_PartNumber.ValueData                          AS PartNumber
                  , MIString_Model.ValueData                               AS PartionModelName
                  , CASE WHEN Object_Goods.DescId = zc_Object_Asset() THEN TRUE ELSE COALESCE (ObjectBoolean_Asset.ValueData, FALSE) END AS isAsset
                    --
                  , Object_Goods.DescId AS ObjectDescId

              FROM Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                                          AND MovementItem.Amount     <> 0

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                    ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()

                   LEFT JOIN MovementItemFloat AS MIFloat_Count
                                               ON MIFloat_Count.MovementItemId = MovementItem.Id
                                              AND MIFloat_Count.DescId         = zc_MIFloat_Count()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountReal
                                               ON MIFloat_CountReal.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountReal.DescId         = zc_MIFloat_CountReal()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                   LEFT JOIN MovementItemString AS MIString_Model
                                                ON MIString_Model.MovementItemId = MovementItem.Id
                                               AND MIString_Model.DescId         = zc_MIString_Model()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Asset
                                           ON ObjectBoolean_Asset.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_Asset.DescId   = zc_ObjectBoolean_Goods_Asset()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                          THEN zc_Enum_InfoMoney_70101() -- Инвестиции
                                                                                                          ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                                     END

                   LEFT JOIN _tmpList_Goods_1942 ON _tmpList_Goods_1942.GoodsId = MovementItem.ObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_ProductionUnion()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- !!!Важно: перед заполннением таблицы - количественные Child(расход)-элементы документа!!!
     IF vbIsPartionDate_Unit_From = TRUE AND vbIsPartionDate_Unit_To = FALSE AND vbOperDate >= '01.07.2015'
       AND (vbUnitId_To = 8458 -- Склад База ГП
            OR (vbUnitId_From =  981821  -- ЦЕХ шприц. мясо
            AND vbUnitId_To   =  951601) -- ЦЕХ упаковки мясо
            OR (vbUnitId_From =  8447    -- ЦЕХ колбасный
            AND vbUnitId_To   =  8445)   -- Склад МИНУСОВКА
            OR (vbUnitId_From =  8020711 -- ЦЕХ колбаса + деликатесы (Ирна)
            AND vbUnitId_To   =  8020714)-- Склад База ГП (Ирна)
           )
     THEN -- Расход партий П/Ф (ГП) по Рецептуре
          PERFORM lpComplete_Movement_ProductionUnion_Partion (inMovementId:= inMovementId
                                                             , inFromId    := vbUnitId_From
                                                             , inToId      := vbUnitId_To
                                                             , inUserId    := inUserId
                                                              );
     END IF;


     -- !!!Важно: перед заполннением таблицы - количественные Child(расход)-элементы документа - расход этикетки!!!
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Etiketka() AND MB.ValueData = TRUE)
     THEN
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Etiketka(), tmpMI.MovementItemId, TRUE)
          FROM

            (SELECT lpInsertUpdate_MI_ProductionUnion_Child (ioId               := tmpMI.MovementItemId
                                                           , inMovementId       := inMovementId
                                                           , inGoodsId          := tmpMI.GoodsId_child
                                                           , inAmount           := tmpMI.OperCount
                                                           , inParentId         := tmpMI.MovementItemId_parent
                                                           , inPartionGoodsDate := NULL
                                                           , inPartionGoods     := NULL
                                                           , inPartNumber       := NULL
                                                           , inModel            := NULL
                                                           , inGoodsKindId      := tmpMI.GoodsKindId_child
                                                           , inGoodsKindCompleteId := NULL
                                                           , inStorageId        := NULL
                                                           , inCount_onCount    := 0
                                                           , inUserId           := inUserId
                                                            ) AS MovementItemId
             FROM (WITH -- Все Child
                        tmpItem_child_all AS (SELECT MovementItem.Id                               AS MovementItemId
                                                   , MovementItem.ParentId                         AS ParentId
                                                   , MovementItem.ObjectId                         AS GoodsId
                                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                                   , COALESCE (MIB_Etiketka.ValueData, FALSE)      AS isEtiketka
                                              FROM MovementItem
                                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                
                                                   LEFT JOIN MovementItemBoolean AS MIB_Etiketka
                                                                                 ON MIB_Etiketka.MovementItemId = MovementItem.Id
                                                                                AND MIB_Etiketka.DescId         = zc_MIBoolean_Etiketka()
                                              WHERE MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE
                                             )
                        -- Только Этикетка
                      , tmpItem_child AS (SELECT tmpItem_child_all.MovementItemId
                                               , tmpItem_child_all.ParentId
                                               , tmpItem_child_all.GoodsId
                                               , tmpItem_child_all.GoodsKindId
                                                 -- № п/п
                                               , ROW_NUMBER() OVER (PARTITION BY tmpItem_child_all.ParentId, tmpItem_child_all.GoodsId, tmpItem_child_all.GoodsKindId) AS Ord
                                          FROM tmpItem_child_all
                                               INNER JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = tmpItem_child_all.ParentId
                                          -- с таким Признаком
                                          WHERE tmpItem_child_all.isEtiketka = TRUE
                                         )
                         -- Все Master
                       , tmpItem_master_all AS (SELECT _tmpItem_pr.MovementItemId
                                                     , _tmpItem_pr.OperCount
                                                     , _tmpItem_pr.GoodsId
                                                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                                FROM _tmpItem_pr
                                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                      ON MILinkObject_GoodsKind.MovementItemId = _tmpItem_pr.MovementItemId
                                                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                               )
                      -- Поиск Receipt для Master
                    , tmpReceiptChild AS (SELECT Object_Receipt.Id AS ReceiptId
                                               , tmpGoods.GoodsId
                                               , tmpGoods.GoodsKindId
                                               , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId_child
                                               , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_child
                                               , ObjectFloat_Value_Receipt.ValueData             AS Value_Receipt
                                               , ObjectFloat_Value.ValueData                     AS Value_ReceiptChild
                                          FROM (SELECT DISTINCT tmpItem_master_all.GoodsId
                                                              , tmpItem_master_all.GoodsKindId
                                                FROM tmpItem_master_all
                                               ) AS tmpGoods
                                               INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                                     ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                               -- Не удален
                                               INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                                  AND Object_Receipt.isErased = FALSE
                                               INNER JOIN ObjectFloat AS ObjectFloat_Value_Receipt
                                                                      ON ObjectFloat_Value_Receipt.ObjectId = Object_Receipt.Id
                                                                     AND ObjectFloat_Value_Receipt.DescId = zc_ObjectFloat_Receipt_Value()
                                                                     AND ObjectFloat_Value_Receipt.ValueData <> 0
                                               -- Главный
                                               INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                        ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                                       AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                                       AND ObjectBoolean_Main.ValueData = TRUE
                                               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          
                                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                                    ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                               -- Не удален
                                               INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                                       AND Object_ReceiptChild.isErased = FALSE
                                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                                    ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                                   AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                                    ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                                   AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                               INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                      ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                                     AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                                     AND ObjectFloat_Value.ValueData <> 0
          
                                               -- Этикетка
                                               INNER JOIN ObjectBoolean AS ObjectBoolean_Etiketka
                                                                        ON ObjectBoolean_Etiketka.ObjectId  = Object_ReceiptChild.Id 
                                                                       AND ObjectBoolean_Etiketka.DescId    = zc_ObjectBoolean_ReceiptChild_Etiketka()
                                                                       -- с таким Признаком
                                                                       AND ObjectBoolean_Etiketka.ValueData = TRUE
          
                                          WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpGoods.GoodsKindId
                                         )

                 -- нашли где будет расход Этикетки
               , tmpItem_ReceiptChild AS (SELECT _tmpItem_pr.MovementItemId AS MovementItemId_parent
                                               , _tmpItem_pr.OperCount
                                               , tmpReceiptChild.GoodsId_child
                                               , tmpReceiptChild.GoodsKindId_child
                                               , tmpReceiptChild.Value_Receipt
                                               , tmpReceiptChild.Value_ReceiptChild
                                          FROM tmpItem_master_all AS _tmpItem_pr
                                               INNER JOIN tmpReceiptChild ON tmpReceiptChild.GoodsId     = _tmpItem_pr.GoodsId
                                                                         AND tmpReceiptChild.GoodsKindId = _tmpItem_pr.GoodsKindId
                                         )
                   -- Расчет расход Этикетки
                   SELECT tmpItem_child.MovementItemId                                                  AS MovementItemId
                        , COALESCE (tmpItem_child.ParentId, tmpItem_ReceiptChild.MovementItemId_parent) AS MovementItemId_parent
                        , COALESCE (tmpItem_child.GoodsId, tmpItem_ReceiptChild.GoodsId_child)          AS GoodsId_child
                        , COALESCE (tmpItem_child.GoodsKindId, tmpItem_ReceiptChild.GoodsKindId_child)  AS GoodsKindId_child
                        , CASE WHEN COALESCE (tmpItem_child.Ord, 0) > 1 OR tmpItem_ReceiptChild.GoodsId_child IS NULL
                                    THEN 0
                               --WHEN CAST (tmpItem_ReceiptChild.OperCount * tmpItem_ReceiptChild.Value_ReceiptChild / tmpItem_ReceiptChild.Value_Receipt AS NUMERIC (16, 0)) > 1
                               --     THEN CAST (tmpItem_ReceiptChild.OperCount * tmpItem_ReceiptChild.Value_ReceiptChild / tmpItem_ReceiptChild.Value_Receipt AS NUMERIC (16, 0))
                               ELSE CAST (tmpItem_ReceiptChild.OperCount * tmpItem_ReceiptChild.Value_ReceiptChild / tmpItem_ReceiptChild.Value_Receipt AS NUMERIC (16, 0))
                          END AS OperCount
                   FROM tmpItem_ReceiptChild
                        -- нашли здесь MovementItemId
                        FULL JOIN tmpItem_child ON tmpItem_child.ParentId    = tmpItem_ReceiptChild.MovementItemId_parent
                                               AND tmpItem_child.GoodsId     = tmpItem_ReceiptChild.GoodsId_child
                                               AND tmpItem_child.GoodsKindId = tmpItem_ReceiptChild.GoodsKindId_child

                  ) AS tmpMI
                  ) AS tmpMI
                 ;

     -- пересорт нар. 180 -> нар. 200
     ELSEIF vbUnitId_From = zc_Unit_RK() AND vbUnitId_To = zc_Unit_RK()
     THEN
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Etiketka(), tmpMI.MovementItemId, TRUE)
          FROM

            (SELECT lpInsertUpdate_MI_ProductionUnion_Child (ioId               := tmpMI.MovementItemId
                                                           , inMovementId       := inMovementId
                                                           , inGoodsId          := tmpMI.GoodsId_child
                                                           , inAmount           := tmpMI.OperCount
                                                           , inParentId         := tmpMI.MovementItemId_parent
                                                           , inPartionGoodsDate := NULL
                                                           , inPartionGoods     := NULL
                                                           , inPartNumber       := NULL
                                                           , inModel            := NULL
                                                           , inGoodsKindId      := tmpMI.GoodsKindId_child
                                                           , inGoodsKindCompleteId := NULL
                                                           , inStorageId        := NULL
                                                           , inCount_onCount    := 0
                                                           , inUserId           := inUserId
                                                            ) AS MovementItemId
             FROM (WITH -- Все Child
                        tmpItem_child_all AS (SELECT MovementItem.Id                               AS MovementItemId
                                                   , MovementItem.ParentId                         AS ParentId
                                                   , MovementItem.ObjectId                         AS GoodsId
                                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                                   , COALESCE (MIB_Etiketka.ValueData, FALSE)      AS isEtiketka
                                              FROM MovementItem
                                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                
                                                   LEFT JOIN MovementItemBoolean AS MIB_Etiketka
                                                                                 ON MIB_Etiketka.MovementItemId = MovementItem.Id
                                                                                AND MIB_Etiketka.DescId         = zc_MIBoolean_Etiketka()
                                              WHERE MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased   = FALSE
                                             )
                        -- Child - Только Этикетка
                      , tmpItem_child AS (SELECT tmpItem_child_all.MovementItemId
                                               , tmpItem_child_all.ParentId
                                               , tmpItem_child_all.GoodsId
                                               , tmpItem_child_all.GoodsKindId
                                                 -- № п/п
                                               , ROW_NUMBER() OVER (PARTITION BY tmpItem_child_all.ParentId, tmpItem_child_all.GoodsId, tmpItem_child_all.GoodsKindId) AS Ord
                                          FROM tmpItem_child_all
                                               INNER JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = tmpItem_child_all.ParentId
                                          -- с таким Признаком
                                          WHERE tmpItem_child_all.isEtiketka  = TRUE
                                         )
                    -- дополнительно - Схема Этикетка
                  , tmpGoods_Etiketka AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId       AS GoodsId
                                               , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId   AS GoodsKindId
                                          FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                               INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                                           AND Object_GoodsByGoodsKind.isErased = FALSE
                                               
                                               INNER JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Etiketka
                                                                        ON ObjectBoolean_GoodsByGoodsKind_Etiketka.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                       AND ObjectBoolean_GoodsByGoodsKind_Etiketka.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Etiketka()
                                                                       -- с таким Признаком
                                                                       AND ObjectBoolean_GoodsByGoodsKind_Etiketka.ValueData = TRUE
                                               
                                          WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                            AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId > 0

                                         )
                         -- Master - нар. 200 + Сhild нар. 180
                       , tmpItem_master_all AS (SELECT DISTINCT
                                                       _tmpItem_pr.MovementItemId
                                                     , _tmpItem_pr.OperCount
                                                     , _tmpItem_pr.GoodsId
                                                     , _tmpItem_pr.GoodsKindId
                                                FROM _tmpItem_pr
                                                     JOIN tmpItem_child_all ON tmpItem_child_all.ParentId    = _tmpItem_pr.MovementItemId
                                                                           -- еще условие
                                                                           AND tmpItem_child_all.GoodsKindId = 7462698 -- нар. 180
                                                -- еще условие
                                                WHERE _tmpItem_pr.GoodsKindId = 6899005 -- нар. 200

                                               UNION
                                                -- еще Схема Этикетка
                                                SELECT DISTINCT
                                                       _tmpItem_pr.MovementItemId
                                                     , _tmpItem_pr.OperCount
                                                     , _tmpItem_pr.GoodsId
                                                     , _tmpItem_pr.GoodsKindId
                                                FROM _tmpItem_pr
                                                     JOIN tmpGoods_Etiketka ON tmpGoods_Etiketka.GoodsId     = _tmpItem_pr.GoodsId
                                                                           AND tmpGoods_Etiketka.GoodsKindId = _tmpItem_pr.GoodsKindId
                                               )
                      -- Поиск Receipt для Master
                    , tmpReceiptChild AS (SELECT Object_Receipt.Id AS ReceiptId
                                               , tmpGoods.GoodsId
                                               , tmpGoods.GoodsKindId
                                               , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId_child
                                               , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_child
                                               , ObjectFloat_Value_Receipt.ValueData             AS Value_Receipt
                                               , ObjectFloat_Value.ValueData                     AS Value_ReceiptChild
                                          FROM (SELECT DISTINCT tmpItem_master_all.GoodsId
                                                              , tmpItem_master_all.GoodsKindId
                                                FROM tmpItem_master_all
                                               ) AS tmpGoods
                                               INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                                     ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                               -- Не удален
                                               INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                                  AND Object_Receipt.isErased = FALSE
                                               INNER JOIN ObjectFloat AS ObjectFloat_Value_Receipt
                                                                      ON ObjectFloat_Value_Receipt.ObjectId = Object_Receipt.Id
                                                                     AND ObjectFloat_Value_Receipt.DescId = zc_ObjectFloat_Receipt_Value()
                                                                     AND ObjectFloat_Value_Receipt.ValueData <> 0
                                               -- Главный
                                               INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                        ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                                       AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                                       AND ObjectBoolean_Main.ValueData = TRUE
                                               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          
                                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                                    ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                               -- Не удален
                                               INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                                       AND Object_ReceiptChild.isErased = FALSE
                                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                                    ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                                   AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                                    ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                                   AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                               INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                      ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                                     AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                                     AND ObjectFloat_Value.ValueData <> 0
          
                                               -- Этикетка
                                               INNER JOIN ObjectBoolean AS ObjectBoolean_Etiketka
                                                                        ON ObjectBoolean_Etiketka.ObjectId  = Object_ReceiptChild.Id 
                                                                       AND ObjectBoolean_Etiketka.DescId    = zc_ObjectBoolean_ReceiptChild_Etiketka()
                                                                       -- с таким Признаком
                                                                       AND ObjectBoolean_Etiketka.ValueData = TRUE
          
                                          WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpGoods.GoodsKindId
                                         )

                 -- нашли где будет расход Этикетки
               , tmpItem_ReceiptChild AS (SELECT _tmpItem_pr.MovementItemId AS MovementItemId_parent
                                               , _tmpItem_pr.OperCount
                                               , tmpReceiptChild.GoodsId_child
                                               , tmpReceiptChild.GoodsKindId_child
                                               , tmpReceiptChild.Value_Receipt
                                               , tmpReceiptChild.Value_ReceiptChild
                                          FROM tmpItem_master_all AS _tmpItem_pr
                                               INNER JOIN tmpReceiptChild ON tmpReceiptChild.GoodsId     = _tmpItem_pr.GoodsId
                                                                         AND tmpReceiptChild.GoodsKindId = _tmpItem_pr.GoodsKindId
                                         )
                   -- Расчет расход Этикетки
                   SELECT tmpItem_child.MovementItemId                                                  AS MovementItemId
                        , COALESCE (tmpItem_child.ParentId, tmpItem_ReceiptChild.MovementItemId_parent) AS MovementItemId_parent
                        , COALESCE (tmpItem_child.GoodsId, tmpItem_ReceiptChild.GoodsId_child)          AS GoodsId_child
                        , COALESCE (tmpItem_child.GoodsKindId, tmpItem_ReceiptChild.GoodsKindId_child)  AS GoodsKindId_child
                        , CASE WHEN COALESCE (tmpItem_child.Ord, 0) > 1 OR tmpItem_ReceiptChild.GoodsId_child IS NULL
                                    THEN 0
                               --WHEN CAST (tmpItem_ReceiptChild.OperCount * tmpItem_ReceiptChild.Value_ReceiptChild / tmpItem_ReceiptChild.Value_Receipt AS NUMERIC (16, 0)) > 1
                               --     THEN CAST (tmpItem_ReceiptChild.OperCount * tmpItem_ReceiptChild.Value_ReceiptChild / tmpItem_ReceiptChild.Value_Receipt AS NUMERIC (16, 0))
                               ELSE CAST (tmpItem_ReceiptChild.OperCount * tmpItem_ReceiptChild.Value_ReceiptChild / tmpItem_ReceiptChild.Value_Receipt AS NUMERIC (16, 0))
                          END AS OperCount
                   FROM tmpItem_ReceiptChild
                        -- нашли здесь MovementItemId
                        FULL JOIN tmpItem_child ON tmpItem_child.ParentId    = tmpItem_ReceiptChild.MovementItemId_parent
                                               AND tmpItem_child.GoodsId     = tmpItem_ReceiptChild.GoodsId_child
                                               AND tmpItem_child.GoodsKindId = tmpItem_ReceiptChild.GoodsKindId_child

                  ) AS tmpMI
                  ) AS tmpMI
                 ;
     ELSE
         -- Удаление
         PERFORM lpSetErased_MovementItem (inMovementItemId:= tmpMI.MovementItemId, inUserId:= inUserId)
         FROM (WITH tmpItem_child_all AS (SELECT MovementItem.Id                               AS MovementItemId
                                               , COALESCE (MIB_Etiketka.ValueData, FALSE)      AS isEtiketka
                                          FROM (SELECT MovementItem.Id AS MovementItemId
                                                FROM MovementItem
                                                WHERE MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                                               ) AS _tmpItem_pr
                                               INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                                      AND MovementItem.DescId     = zc_MI_Child()
                                                                      AND MovementItem.ParentId   = _tmpItem_pr.MovementItemId
                                                                      AND MovementItem.isErased   = FALSE
                                               LEFT JOIN MovementItemBoolean AS MIB_Etiketka
                                                                             ON MIB_Etiketka.MovementItemId = MovementItem.Id
                                                                            AND MIB_Etiketka.DescId         = zc_MIBoolean_Etiketka()
                                         )
                --
                SELECT tmpItem_child_all.MovementItemId
                FROM tmpItem_child_all
                WHERE tmpItem_child_all.isEtiketka = TRUE
              ) AS tmpMI
              ;
     END IF;


     -- заполняем таблицу - количественные Child(расход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItemChild (MovementItemId_Parent, MovementItemId
                              , ContainerId_GoodsFrom, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                              , OperCount, OperCountCount
                              , InfoMoneyDestinationId, InfoMoneyId
                              , BusinessId_From
                              , UnitId_Item, PartionGoodsId_container
                              , isPartionCount, isPartionSumm
                              , PartionGoodsId
                              , isAsset_master, ObjectDescId
                              , OperCount_start
                              )
        WITH tmpMI AS
             (SELECT MovementItem.ParentId AS MovementItemId_Parent
                   , MovementItem.Id AS MovementItemId

                   , MovementItem.ObjectId AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                          WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- Тушенка
                           AND MILinkObject_GoodsKind.ObjectId <> zc_GoodsKind_Basis()
                           AND vbUnitId_To <> 2790412 -- ЦЕХ Тушенка -- 8006902 -- ЦЕХ упаковки Тушенки
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                           AND vbIsPartionGoodsKind_Unit_From = TRUE
                           AND _tmpList_Goods_1942.GoodsId IS NULL
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          ELSE 0
                     END AS GoodsKindId

                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                               THEN COALESCE (MILinkObject_GoodsKindComplete.ObjectId, CASE WHEN _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress() THEN _tmpItem_pr.GoodsKindId ELSE 0 END)
                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                           AND vbIsPartionGoodsKind_Unit_From = TRUE
                           AND _tmpList_Goods_1942.GoodsId IS NULL
                               THEN COALESCE (MILinkObject_GoodsKindComplete.ObjectId, CASE WHEN _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress() THEN _tmpItem_pr.GoodsKindId ELSE 0 END)
                          ELSE 0
                     END AS GoodsKindId_complete

                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                   , MovementItem.Amount AS OperCount
                   , COALESCE (MIFloat_Count.ValueData, 0) AS OperCountCount

                     -- Управленческие назначения
                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- Статьи назначения
                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                     -- Бизнес из Товара
                   , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                   , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)     AS isPartionCount
                   , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)      AS isPartionSumm

                   , COALESCE (_tmpItem_pr.isAsset, FALSE) AS isAsset_master
                   , Object_Goods.DescId                   AS ObjectDescId

              -- FROM Movement
              --     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
              FROM _tmpItem_pr
                   INNER JOIN MovementItem ON MovementItem.ParentId = _tmpItem_pr.MovementItemId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
                                          AND MovementItem.MovementId = inMovementId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemFloat AS MIFloat_Count
                                               ON MIFloat_Count.MovementItemId = MovementItem.Id
                                              AND MIFloat_Count.DescId         = zc_MIFloat_Count()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                          THEN zc_Enum_InfoMoney_70101() -- Инвестиции
                                                                                                          ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                                     END
                   LEFT JOIN _tmpList_Goods_1942 ON _tmpList_Goods_1942.GoodsId = MovementItem.ObjectId

              -- WHERE Movement.Id = inMovementId
              --   AND Movement.DescId = zc_Movement_ProductionUnion()
              --   AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             )
  -- сначала партии для итого расхода
, tmpMI_summ  AS (SELECT tmpMI.GoodsId, 0 AS GoodsKindId, SUM (tmpMI.OperCount) AS OperCount, tmpMI.isAsset_master
                       , FALSE AS is_30100
                  FROM tmpMI
                  WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                       , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                       , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                        )
                     -- или новая схема - товары ОС или zc_Object_Asset
                     OR tmpMI.isAsset_master = TRUE

                  GROUP BY tmpMI.GoodsId, tmpMI.isAsset_master

                 -- !!! учет - партии по датам + ячейки
                 UNION ALL
                  SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, SUM (tmpMI.OperCount) AS OperCount, FALSE AS isAsset_master
                       , TRUE AS is_30100
                  FROM tmpMI
                  WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                       , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                        )
                        --!!!
                    AND vbIsPartionCell_from = TRUE
                  GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.isAsset_master
                 )
               -- !!! - 01 - по партиям для Общефирменные
             , tmp_01 AS (SELECT DISTINCT Container.Id               AS ContainerId
                                        , Container.ObjectId         AS GoodsId
                                        , tmpMI.GoodsKindId          AS GoodsKindId
                                        , CLO_PartionGoods.ObjectId  AS PartionGoodsId
                                        , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                        , Container.Amount           AS Amount
                          FROM tmpMI_summ AS tmpMI
                               INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountAsset())
                                                 -- нет ограничения
                                                 --AND Container.Amount   > 0
                               LEFT JOIN ContainerLinkObject AS CLO_Member
                                                             ON CLO_Member.ContainerId = Container.Id
                                                            AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                               LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                             ON CLO_Unit.ContainerId = Container.Id
                                                            AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                               LEFT JOIN ContainerLinkObject AS CLO_AssetTo
                                                             ON CLO_AssetTo.ContainerId = Container.Id
                                                            AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                          WHERE ((CLO_Member.ObjectId    = vbMemberId_From
                              AND vbMemberId_From        > 0
                                 )
                              OR (CLO_Unit.ObjectId = vbUnitId_From
                              AND vbUnitId_From     > 0
                              AND Container.DescId  = zc_Container_CountAsset()
                                 ))
                            AND (CLO_PartionGoods.ObjectId > 0 OR CLO_AssetTo.ContainerId > 0 OR tmpMI.isAsset_master = TRUE)
                            AND vbIsPartionCell_from = FALSE
                         )
               -- !!! - 02 - учет для ГП - партии по датам + ячейки
             , tmp_02 AS (SELECT DISTINCT Container.Id               AS ContainerId
                                        , tmpMI.GoodsId              AS GoodsId
                                        , tmpMI.GoodsKindId          AS GoodsKindId
                                        , CLO_PartionGoods.ObjectId  AS PartionGoodsId
                                        , CASE WHEN ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()
                                               -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                                               THEN zc_DateStart()
                                               ELSE COALESCE (ObjectDate_Value.ValueData, zc_DateStart())
                                          END AS PartionGoodsDate
                                        , Container.Amount           AS Amount
                          FROM tmpMI_summ AS tmpMI
                               INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.DescId   = zc_Container_Count()
                                                   -- есть ограничение
                                                   AND Container.Amount   > 0
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ObjectId    = vbUnitId_From
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                               -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                               LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId = CLO_PartionGoods.ObjectId
                                                                             AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()

                          WHERE vbIsPartionCell_from = TRUE
                            -- по видам
                            AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                            --!!! не должны попадать партии из следующего периода
                            AND (COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                              OR CLO_PartionGoods.ContainerId IS NULL
                                )
                            --!!!не пустая пратия!!!
                            AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)
                         )
               -- !!! - 03 - учет для ГП - партии по датам + ячейки
             , tmp_03 AS (SELECT DISTINCT Container.Id               AS ContainerId
                                        , tmpMI.GoodsId              AS GoodsId
                                        , tmpMI.GoodsKindId          AS GoodsKindId
                                        , CLO_PartionGoods.ObjectId  AS PartionGoodsId
                                        , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                                        , Container.Amount           AS Amount
                                          -- !!!Надо отловить ОДИН!!!
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY Container.Id) AS Ord
                          FROM tmpMI_summ AS tmpMI
                               -- !!!
                               LEFT JOIN tmp_02 ON tmp_02.GoodsId     = tmpMI.GoodsId
                                               AND tmp_02.GoodsKindId = tmpMI.GoodsKindId
                               INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.DescId   = zc_Container_Count()
                                                   -- минуса или 0 если не нашли > 0
                                                   AND Container.Amount   <= 0
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = Container.Id
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ObjectId    = vbUnitId_From
                               -- !!!
                               LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                             ON CLO_GoodsKind.ContainerId = Container.Id
                                                            AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                               -- если zc_PartionCell_RK, НЕ списываем партию здесь вообще
                               LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId      = CLO_PartionGoods.ObjectId
                                                                             AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                                             AND ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()
                          WHERE vbIsPartionCell_from = TRUE
                            AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                            --!!!
                            AND tmp_02.GoodsId IS NULL
                            --!!! не должны попадать партии из следующего периода
                            AND (COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                              OR CLO_PartionGoods.ContainerId IS NULL
                                )
                            --!!!не пустая партия!!!
                            AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)
                            -- НЕ списываем ЭТУ партию - здесь вообще
                            AND ObjectLink_PartionCell.ObjectId IS NULL
                        )

  , tmpContainer_list AS (-- по партиям для Общефирменные
                          SELECT tmp_01.ContainerId
                               , tmp_01.GoodsId
                               , tmp_01.GoodsKindId
                               , tmp_01.PartionGoodsId
                               , tmp_01.PartionGoodsDate
                               , tmp_01.Amount
                          FROM tmp_01
                         UNION ALL
                          -- учет для ГП - партии по датам + ячейки
                          SELECT tmp_02.ContainerId
                               , tmp_02.GoodsId
                               , tmp_02.GoodsKindId
                               , tmp_02.PartionGoodsId
                               , tmp_02.PartionGoodsDate
                               , tmp_02.Amount
                          FROM tmp_02

                         UNION ALL
                          -- учет для ГП - партии по датам + ячейки
                          SELECT tmp_03.ContainerId
                               , tmp_03.GoodsId
                               , tmp_03.GoodsKindId
                               , tmp_03.PartionGoodsId
                               , tmp_03.PartionGoodsDate
                                 -- подставили как будто есть остаток
                               , 0.01 AS Amount
                          FROM tmp_03
                          -- только одна партия с остатком <=0
                          WHERE tmp_03.Ord = 1
                         )
     -- остаток с учетом движения, временно кроме РК
   , tmpContainer_rem AS (SELECT tmpContainer_list.ContainerId
                               , tmpContainer_list.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_rem
                          FROM tmpContainer_list
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = tmpContainer_list.ContainerId
                                                              -- !!!на конец дня
                                                              AND MIContainer.OperDate    > vbOperDate
                          -- для скорости - для РК + ГП не надо - будет ошибка для МНМА и т.п.
                          WHERE vbIsPartionCell_from = FALSE
                          GROUP BY tmpContainer_list.ContainerId, tmpContainer_list.Amount
                          HAVING tmpContainer_list.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) > 0
                         )
     -- для остатка с учетом Инвентаризации, только для РК
   , tmpContainer_rem_RK AS (SELECT tmpContainer_list.ContainerId
                                    -- добавится списание или минус приход
                                  , -1 * SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_invent
                             FROM tmpContainer_list
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer_list.ContainerId
                                                                  -- !!!все
                                                                  AND MIContainer.OperDate       >= DATE_TRUNC ('MONTH', vbOperDate)
                                                                  AND MIContainer.MovementDescId = zc_Movement_Inventory()
                             -- для РК
                             WHERE vbIsPartionCell_from = TRUE
                             GROUP BY tmpContainer_list.ContainerId
                             --HAVING SUM (COALESCE (MIContainer.Amount, 0)) <> 0
                             -- !!! -- select * from gpComplete_All_Sybase(28658170,False,'444873')
                             HAVING SUM (COALESCE (MIContainer.Amount, 0)) < 0
                            )
     -- будет подбор партий
   , tmpContainer_all AS (SELECT tmpMI.GoodsId
                               , tmpMI.GoodsKindId
                               , Container.ContainerId
                                 -- Кол-во
                               , tmpMI.OperCount        AS Amount
                                 -- Остаток + без учета Инвентаризации для ГП
                               , COALESCE (tmpContainer_rem.Amount_rem, Container.Amount) + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) AS Amount_container
                                 -- накопительно
                               , SUM (Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0))
                                                        OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                              ORDER BY CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END
                                                                     , CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END
                                                                     , CASE WHEN tmpMI.is_30100 = TRUE THEN Container.PartionGoodsDate ELSE zc_DateStart() END ASC
                                                                       --
                                                                       --
                                                                     , CASE WHEN tmpContainer_rem.Amount_rem > 0 THEN Container.ContainerId ELSE 0 END DESC
                                                                       --
                                                                     , COALESCE (tmpContainer_rem.Amount_rem, 0) DESC
                                                                       --
                                                                     , CASE WHEN COALESCE (Object_PartionGoods.ValueData, '') = ''
                                                                              OR COALESCE (Object_PartionGoods.ValueData, '') = '0'
                                                                                 THEN 0
                                                                            WHEN Object_PartionGoods.ValueData ILIKE 'уп%' THEN 2
                                                                            ELSE 1
                                                                       END ASC
                                                                     , Container.PartionGoodsDate ASC
                                                                     , Container.ContainerId ASC
                                                             ) AS AmountSUM
                                 -- !!!Надо отловить ПОСЛЕДНИЙ!!!
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                    ORDER BY CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END
                                                           , CASE WHEN tmpMI.is_30100 = TRUE AND Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END
                                                             -- наоборот
                                                           , CASE WHEN tmpMI.is_30100 = TRUE THEN Container.PartionGoodsDate ELSE zc_DateStart() END DESC
                                                             --
                                                             -- наоборот
                                                           , CASE WHEN tmpContainer_rem.Amount_rem > 0 THEN Container.ContainerId ELSE 0 END ASC
                                                             -- наоборот
                                                           , COALESCE (tmpContainer_rem.Amount_rem, 0) ASC
                                                             -- наоборот
                                                           , CASE WHEN COALESCE (Object_PartionGoods.ValueData, '') = ''
                                                                    OR COALESCE (Object_PartionGoods.ValueData, '') = '0'
                                                                       THEN 0
                                                                  WHEN Object_PartionGoods.ValueData ILIKE 'уп%' THEN 2
                                                                  ELSE 1
                                                             END DESC
                                                             -- наоборот
                                                           , Container.PartionGoodsDate DESC
                                                             -- наоборот
                                                           , Container.ContainerId DESC
                                                   ) AS Ord
                                 -- партия
                               , Container.PartionGoodsId
   
                          FROM tmpMI_summ AS tmpMI
                               INNER JOIN tmpContainer_list AS Container
                                                            ON Container.GoodsId     = tmpMI.GoodsId
                                                           AND Container.GoodsKindId = tmpMI.GoodsKindId
                               LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = Container.PartionGoodsId
   
                               LEFT JOIN tmpContainer_rem ON tmpContainer_rem.ContainerId = Container.ContainerId
                               LEFT JOIN tmpContainer_rem_RK ON tmpContainer_rem_RK.ContainerId = Container.ContainerId
                                                            AND tmpContainer_rem.ContainerId IS NULL
                               -- какой нашли
                               /*LEFT JOIN tmp_03 AS tmpContainer_rem_find
                                                ON tmpContainer_rem_find.GoodsId     = tmpMI.GoodsId
                                               AND tmpContainer_rem_find.GoodsKindId = tmpMI.GoodsKindId
                                               AND tmpContainer_rem_find.Ord         = 1*/
                          WHERE COALESCE (tmpContainer_rem.Amount_rem, Container.Amount) > 0
                             -- для РК + ГП -любой
                             OR tmpMI.is_30100 = TRUE
                         )
      -- итого кол-во разбили по партиям
    , tmpContainer_partion AS (SELECT DD.ContainerId
                                    , DD.GoodsId
                                    , DD.GoodsKindId
                                    , DD.PartionGoodsId
                                    , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1 -- !!!- изменилась сортировка НАОБОРОТ!!!
                                                THEN DD.Amount_container
                                           ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                                      END AS Amount
                                FROM (SELECT * FROM tmpContainer_all) AS DD
                               WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                              )
      -- получили накопительные суммы
    , tmpContainer_sum AS (SELECT tmpContainer.ContainerId
                                , tmpContainer.GoodsId
                                , tmpContainer.GoodsKindId
                                , tmpContainer.PartionGoodsId
                                , tmpContainer.Amount
                                  -- сортировка по ContainerId
                                , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpContainer.GoodsId, tmpContainer.GoodsKindId ORDER BY tmpContainer.ContainerId ASC) AS AmountSUM
                           FROM tmpContainer_partion AS tmpContainer
                          )
      -- получили № п/п, чтоб сформировать накопительные периоды
    , tmpContainer_NUMBER AS (SELECT tmpContainer.ContainerId
                                   , tmpContainer.GoodsId
                                   , tmpContainer.GoodsKindId
                                   , tmpContainer.PartionGoodsId
                                   , tmpContainer.Amount
                                   , tmpContainer.AmountSUM
                                     -- макс кол-во будет с № п/п = 1
                                   , ROW_NUMBER() OVER (PARTITION BY tmpContainer.GoodsId, tmpContainer.GoodsKindId ORDER BY tmpContainer.AmountSUM DESC) AS Ord
                              FROM tmpContainer_sum AS tmpContainer
                             )
      -- накопительные периоды
    , tmpContainer_group AS (SELECT tmpContainer.ContainerId
                                  , tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , tmpContainer.PartionGoodsId
                                  , tmpContainer.Amount
                                  , tmpContainer.AmountSUM
                                  , tmpContainer.Ord
                                    -- с минимального
                                  , COALESCE (tmpContainer_old.AmountSUM, 0) AS Amount_min
                                    -- увеличим последнее кол-во, если партий не хватит, что б все упало на этот ContainerId (хотя оно и так упалов запросе tmpContainer_partion)
                                  , CASE WHEN tmpContainer.Ord = 1 THEN tmpContainer.AmountSUM * 1000 ELSE tmpContainer.AmountSUM END AS Amount_max
                              FROM tmpContainer_NUMBER AS tmpContainer
                                   LEFT JOIN tmpContainer_NUMBER AS tmpContainer_old
                                                                 ON tmpContainer_old.GoodsId     = tmpContainer.GoodsId
                                                                AND tmpContainer_old.GoodsKindId = tmpContainer.GoodsKindId
                                                                AND tmpContainer_old.Ord         = tmpContainer.Ord + 1
                             )
      -- накопительные MI
    , tmpMI_group AS (SELECT tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.OperCount
                             -- сортировка по MovementItemId
                           , SUM (tmpMI.OperCount) OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.MovementItemId ASC) AS AmountSUM
                      FROM tmpMI
                     )

     -- партии прикрутили к MI -  ???"пропорционально"???
   , tmpContainer_res_1 AS (SELECT tmpMI_group.MovementItemId
                                 , tmpMI_group.GoodsId
                                 , tmpMI_group.GoodsKindId
     
                                   -- подставили из MI - ERROR
                               --, tmpMI_group.OperCount AS Amount
     
                                   -- НЕ подставили из Container
                               --, tmpContainer_group.Amount AS Amount
      
                                  -- подставили из Container - пропорционально
                                 , CAST (tmpContainer_group.Amount * tmpMI_group.OperCount / tmpMI_summ.OperCount AS NUMERIC(16,4)) AS Amount
                                  --
                                 , tmpContainer_group.ContainerId
                                 , tmpContainer_group.PartionGoodsId
     
                                   -- № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY tmpContainer_group.ContainerId ORDER BY tmpMI_group.OperCount DESC) AS Ord

                            FROM tmpMI_group
                                 LEFT JOIN tmpContainer_group ON tmpContainer_group.GoodsId     = tmpMI_group.GoodsId
                                                             AND tmpContainer_group.GoodsKindId = tmpMI_group.GoodsKindId
                                                           -- !!!убрал, будет пропорция!!!
                                                           --AND tmpMI_group.AmountSUM > tmpContainer_group.Amount_min AND tmpMI_group.AmountSUM <= tmpContainer_group.Amount_max
                                 LEFT JOIN tmpMI_summ ON tmpMI_summ.GoodsId     = tmpMI_group.GoodsId
                                                     AND tmpMI_summ.GoodsKindId = tmpMI_group.GoodsKindId
                            WHERE tmpMI_summ.OperCount > 0
                           )
      -- корректируем на разницу
    , tmpContainer_res_2 AS (SELECT tmpContainer_res_1.MovementItemId
                                  , tmpContainer_res_1.GoodsId
                                  , tmpContainer_res_1.GoodsKindId

                                    -- было пропорционально и добавили разницу
                                  , tmpContainer_res_1.Amount + CASE WHEN tmpContainer_res_1.Ord = 1
                                                                          THEN tmpContainer_partion.Amount - tmpContainer_res_sum.Amount
                                                                     ELSE 0
                                                                END AS Amount
                                    --
                                  , tmpContainer_res_1.ContainerId
                                  , tmpContainer_res_1.PartionGoodsId

                             FROM tmpContainer_res_1
                                  -- сколько было изначально по ContainerId
                                  LEFT JOIN tmpContainer_partion ON tmpContainer_partion.ContainerId = tmpContainer_res_1.ContainerId
                                                                -- только 1
                                                                AND tmpContainer_res_1.Ord           = 1
                                  -- итого получилось по ContainerId
                                  LEFT JOIN (SELECT tmpContainer_res_1.ContainerId
                                                  , SUM (tmpContainer_res_1.Amount) AS Amount
                                             FROM tmpContainer_res_1
                                             GROUP BY tmpContainer_res_1.ContainerId
                                            ) AS tmpContainer_res_sum
                                              ON tmpContainer_res_sum.ContainerId = tmpContainer_res_1.ContainerId
                                             -- только 1
                                             AND tmpContainer_res_1.Ord           = 1
                            )
      -- партии прикрутили к MI
    , tmpContainer AS (SELECT tmpMI_group.MovementItemId
                            , tmpMI_group.GoodsId
                            , tmpMI_group.GoodsKindId
                              -- значение
                            , tmpMI_group.Amount
                              --
                            , tmpMI_group.ContainerId
                            , tmpMI_group.PartionGoodsId

                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI_group.MovementItemId ORDER BY tmpMI_group.ContainerId DESC) AS Ord

                      FROM tmpContainer_res_2 AS tmpMI_group
                     )
        --
        SELECT _tmp.MovementItemId_Parent
             , _tmp.MovementItemId

               -- !!!или подбор партий!!!
             , COALESCE (tmpContainer.ContainerId, 0) AS ContainerId_GoodsFrom
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , _tmp.GoodsKindId_complete
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

               -- !!!или подбор партий!!!
             , COALESCE (tmpContainer.Amount, _tmp.OperCount) AS OperCount
             , _tmp.OperCountCount                            AS OperCountCount
-- , (select Amount from tmpContainer where GoodsId = 5810441 and ord= 1 ) AS OperCountCount
-- , (select ord from tmpContainer_all where GoodsId = 5765 and ContainerId = 2536789 ) AS OperCountCount

               -- Управленческие назначения
             , _tmp.InfoMoneyDestinationId
               -- Статьи назначения
             , _tmp.InfoMoneyId

               -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
             , CASE WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

             , 0 AS UnitId_Item
               -- !!!подбор партий!!!
             , COALESCE (tmpContainer.PartionGoodsId, 0) AS PartionGoodsId_container
             , _tmp.isPartionCount
             , _tmp.isPartionSumm
               -- Партии товара, сформируем позже
             , 0 AS PartionGoodsId
               --
             , _tmp.isAsset_master
             , _tmp.ObjectDescId

            , _tmp.OperCount AS OperCount_start

        FROM tmpMI AS _tmp
             LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = _tmp.MovementItemId
       ;

IF 1=0
THEN
-- , (select CLO_PartionGoods.ObjectId from ContainerLinkObject AS CLO_PartionGoods where CLO_PartionGoods.ContainerId = Container.ContainerId AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()) as PartionGoodsId

    RAISE EXCEPTION 'Ошибка.<%>  <%>   <%>'
, (select Container.Amount from Container WHERE Container.Id = 5810441 )
, (select coalesce (_tmpItemChild.PartionGoodsId_container ::TVarChar , '') || ' - ' || coalesce (CLO_PartionGoods.ObjectId ::TVarChar , '') || ' - ' || coalesce (_tmpItemChild.GoodsId ::TVarChar , '') || ' - ' || coalesce (_tmpItemChild.OperCount ::TVarChar , '')  || ' - ' || coalesce (_tmpItemChild.OperCountCount ::TVarChar , '')
   from _tmpItemChild
        LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                      ON CLO_PartionGoods.ContainerId = _tmpItemChild.ContainerId_GoodsFrom
                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
   WHERE _tmpItemChild.MovementItemId = 289864869
  )
, (select _tmpItemChild.ContainerId_GoodsFrom from _tmpItemChild WHERE _tmpItemChild.MovementItemId = 289864869 )
;
end if;


     -- Проверка - 2 - Подбор партий
     IF vbIsPartionCell_from = TRUE
        AND EXISTS (SELECT 1
                    FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                          FROM (SELECT DISTINCT _tmpItemChild.MovementItemId, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.OperCount_start
                                FROM _tmpItemChild
                                WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                         )
                               ) AS tmpItem_start
                          GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                         ) AS tmpItem_start
                         FULL JOIN (SELECT _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, SUM (_tmpItemChild.OperCount) AS OperCount
                                    FROM _tmpItemChild
                                    WHERE _tmpItemChild.ContainerId_GoodsFrom > 0
                                    GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                   ) AS tmpItem
                                     ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                    AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                    WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                   )
        AND inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
        --AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Подбор партий.% % № <%> от <%> %Товар = <%> %Вид = <%> %Кол-во = <%> %Кол-во по партиям = <%> %Id = <%>'
                       , CHR (13)
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData (tmpItem_start.GoodsId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItemChild.MovementItemId, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.OperCount_start
                                      FROM _tmpItemChild
                                      WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                               , SUM (_tmpItemChild.OperCount) AS OperCount
                                          FROM _tmpItemChild
                                          WHERE _tmpItemChild.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- GoodsKindId
                       , (SELECT lfGet_Object_ValueData_sh (tmpItem_start.GoodsKindId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItemChild.MovementItemId, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.OperCount_start
                                      FROM _tmpItemChild
                                      WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                               , SUM (_tmpItemChild.OperCount) AS OperCount
                                          FROM _tmpItemChild
                                          WHERE _tmpItemChild.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.1. OperCount_start
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount_start)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItemChild.MovementItemId, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.OperCount_start
                                      FROM _tmpItemChild
                                      WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                               , SUM (_tmpItemChild.OperCount) AS OperCount
                                          FROM _tmpItemChild
                                          WHERE _tmpItemChild.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.2. OperCount - calc
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItemChild.MovementItemId, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.OperCount_start
                                      FROM _tmpItemChild
                                      WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                               , SUM (_tmpItemChild.OperCount) AS OperCount
                                          FROM _tmpItemChild
                                          WHERE _tmpItemChild.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- MovementItemId
                       , (SELECT COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId) :: TVarChar || ' - ' || COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId) :: TVarChar
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start) AS OperCount_start
                                FROM (SELECT DISTINCT _tmpItemChild.MovementItemId, _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId, _tmpItemChild.OperCount_start
                                      FROM _tmpItemChild
                                      WHERE _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                               , SUM (_tmpItemChild.OperCount) AS OperCount
                                          FROM _tmpItemChild
                                          WHERE _tmpItemChild.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItemChild.GoodsId, _tmpItemChild.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0) <> COALESCE (tmpItem.OperCount, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                        ;
     END IF;


     -- формируются Партии товара для Child(расход)-элементы, ЕСЛИ надо ...
     UPDATE _tmpItemChild SET PartionGoodsId = CASE WHEN vbIsPartionCell_from = TRUE
                                                     AND _tmpItemChild.PartionGoodsId_container > 0
                                                     AND _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                                , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                 )
                                                         THEN _tmpItemChild.PartionGoodsId_container

                                                    WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItemChild.isPartionCount = TRUE OR _tmpItemChild.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItemChild.PartionGoods)

                                                    -- Упаковка Мяса (тоже ПФ-ГП)
                                                    WHEN vbIsPartionDate_Unit_From = TRUE
                                                     AND vbUnitId_From <> vbUnitId_To
                                                     AND _tmpItemChild.PartionGoodsDate <> zc_DateEnd()
                                                     -- и это НЕ группа - ЦЕХ колбаса+дел-сы
                                                      -- AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbUnitId_From AND OL.ChildObjectId = 8446 AND OL.DescId = zc_ObjectLink_Unit_Parent())
                                                     -- AND EXISTS (SELECT 1 FROM _tmpItem_pr WHERE _tmpItem_pr.MovementItemId = _tmpItemChild.MovementItemId_Parent AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100())
                                                     AND _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- Основное сырье + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItemChild.PartionGoodsDate
                                                                                             , inGoodsKindId_complete := _tmpItemChild.GoodsKindId_complete
                                                                                              )
                                                    -- Основное сырье (тоже ПФ-ГП)
                                                    WHEN vbIsPartionDate_Unit_From = TRUE
                                                     AND _tmpItemChild.PartionGoodsDate <> zc_DateEnd()
                                                     AND _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- Основное сырье + Мясное сырье
                                                     -- + Учет по дате партии - для док Произ-смешивание(расход)
                                                     AND EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = _tmpItemChild.GoodsId AND OB.DescId = zc_ObjectBoolean_Goods_PartionDate() AND OB.ValueData = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItemChild.PartionGoodsDate
                                                                                             , inGoodsKindId_complete := _tmpItemChild.GoodsKindId_complete
                                                                                              )
                                                    -- Производство ПФ-ГП
                                                    WHEN vbIsPartionDate_Unit_From = TRUE
                                                     AND _tmpItemChild.PartionGoodsDate <> zc_DateEnd()
                                                     AND _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                                , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                                , zc_Enum_InfoMoneyDestination_30200()  -- Доходы + Мясное сырье
                                                                                                 )
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItemChild.PartionGoodsDate
                                                                                             , inGoodsKindId_complete := _tmpItemChild.GoodsKindId_complete
                                                                                              )
                                                    WHEN _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                                , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                                , zc_Enum_InfoMoneyDestination_30200()  -- Доходы + Мясное сырье
                                                                                                 )
                                                        THEN 0

                                                    WHEN _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                      OR _tmpItemChild.isAsset_master = TRUE                                         -- или новая схема - ОС
                                                         THEN _tmpItemChild.PartionGoodsId_container

                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
        -- или новая схема - ОС
        OR _tmpItemChild.isAsset_master = TRUE
     ;


     -- определили
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From END;
     vbWhereObjectId_Analyzer_To:= CASE WHEN vbUnitId_To <> 0 THEN vbUnitId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;


     -- формируются Партии товара для Master(ПРИХОД)-элементы, новая схема - ОС
     UPDATE _tmpItem_pr SET PartionGoodsId = CASE WHEN tmpItemChild.is_30100 = TRUE
                                                  THEN lpInsertFind_Object_PartionGoods (inOperDate             := COALESCE (ObjectDate_Value.ValueData, tmpItemChild.PartionGoodsDate, zc_DateEnd())
                                                                                         -- виртуальный параметр, т.к. иначе параметры пересекаются с другой проц
                                                                                       , inGoodsKindId_complete := NULL
                                                                                         -- Ячейка
                                                                                       , inPartionCellId        := NULL
                                                                                        )
                                                  WHEN _tmpItem_pr.ObjectDescId = zc_Object_Asset()
                                                  THEN lpInsertFind_Object_PartionGoods (inMovementId     := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = tmpItemChild.PartionGoodsId)
                                                                                       , inGoodsId        := _tmpItem_pr.GoodsId
                                                                                       , inUnitId         := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = tmpItemChild.PartionGoodsId AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                                       , inStorageId      := _tmpItem_pr.StorageId_Item
                                                                                       , inInvNumber      := (SELECT Object.ValueData FROM Object WHERE Object.Id = tmpItemChild.PartionGoodsId)
                                                                                        )
                                                  ELSE lpInsertFind_Object_PartionGoods (inUnitId_Partion := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = tmpItemChild.PartionGoodsId AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                                       , inGoodsId        := _tmpItem_pr.GoodsId
                                                                                       , inStorageId      := _tmpItem_pr.StorageId_Item
                                                                                       , inPartionModelId := lpInsertFind_Object_PartionModel (_tmpItem_pr.PartionModelName, inUserId)
                                                                                       , inInvNumber      := _tmpItem_pr.PartionGoods
                                                                                       , inPartNumber      := _tmpItem_pr.PartNumber
                                                                                       , inOperDate       := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = tmpItemChild.PartionGoodsId AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                       , inPrice          := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = tmpItemChild.PartionGoodsId AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                        )
                                             END
     FROM (SELECT _tmpItemChild.MovementItemId_Parent, MAX (_tmpItemChild.PartionGoodsId) AS PartionGoodsId, NULL :: TDateTime AS PartionGoodsDate, FALSE AS is_30100
           FROM _tmpItemChild
           -- если новая схема - ОС
           WHERE _tmpItemChild.isAsset_master = TRUE
           GROUP BY _tmpItemChild.MovementItemId_Parent
           HAVING COUNT(*) = 1
          UNION
           -- взять ОДНУ партию, хотя в Child могло разбиться по нескольким партиям дата
           SELECT _tmpItemChild.MovementItemId_Parent, MAX (_tmpItemChild.PartionGoodsId) AS PartionGoodsId, MAX (_tmpItemChild.PartionGoodsDate) AS PartionGoodsDate, TRUE AS is_30100
           FROM _tmpItemChild
           WHERE vbIsPartionCell_from = TRUE AND vbIsPartionCell_to = TRUE
             -- !!!если нашли партию!!!
             AND _tmpItemChild.PartionGoodsId > 0
             AND _tmpItemChild.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                        , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                         )
           GROUP BY _tmpItemChild.MovementItemId_Parent
          ) AS tmpItemChild
          LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = tmpItemChild.PartionGoodsId
                                                  AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

     WHERE _tmpItem_pr.MovementItemId = tmpItemChild.MovementItemId_Parent
    ;

/*  RAISE EXCEPTION 'Ошибка.<%>  <%>', (select _tmpItem_pr.PartionGoodsId from _tmpItem_pr where _tmpItem_pr.MovementItemId = 285994073)
  , (select _tmpItemChild.PartionGoodsDate from _tmpItemChild where _tmpItemChild.MovementItemId = 285994075)
  ;*/

     -- переносятся Партии товара для Child(расход)-элементы, новая схема - ОС
     UPDATE _tmpItemChild SET PartionGoodsId = _tmpItem_pr.PartionGoodsId
     FROM _tmpItem_pr
     WHERE _tmpItem_pr.MovementItemId = _tmpItemChild.MovementItemId_Parent
       AND _tmpItem_pr.PartionGoodsId > 0
       AND COALESCE (_tmpItemChild.PartionGoodsId, 0) = 0
       AND _tmpItemChild.isAsset_master = TRUE
    ;

     -- формируются Партии товара для Master(ПРИХОД)-элементы, ЕСЛИ надо ...
     UPDATE _tmpItem_pr SET PartionGoodsId_child = tmpItemChild.PartionGoodsId
     FROM (SELECT _tmpItemChild.MovementItemId_Parent, MAX (_tmpItemChild.PartionGoodsId) AS PartionGoodsId
           FROM _tmpItemChild
           WHERE _tmpItemChild.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
             AND _tmpItemChild.PartionGoodsId > 0
             -- НЕ новая схема - ОС
             AND _tmpItemChild.isAsset_master = FALSE
           GROUP BY _tmpItemChild.MovementItemId_Parent
           HAVING COUNT(*) = 1
          ) AS tmpItemChild
     WHERE _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
       AND _tmpItem_pr.MovementItemId = tmpItemChild.MovementItemId_Parent
    ;


     -- формируются Партии товара для Master(ПРИХОД)-элементы, ЕСЛИ надо ...
     UPDATE _tmpItem_pr SET PartionGoodsId = CASE -- 
                                                  WHEN _tmpItem_pr.PartionGoodsId > 0 AND vbIsPartionCell_to = TRUE
                                                       -- какую нашли
                                                       THEN _tmpItem_pr.PartionGoodsId
                                                  -- новая схема - ОС
                                                  WHEN _tmpItem_pr.isAsset = TRUE
                                                       -- оставляем какую нашли
                                                       THEN _tmpItem_pr.PartionGoodsId
                                                  -- Спецодежда
                                                  WHEN _tmpItem_pr.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem_pr.PartionGoodsId_child > 0
                                                       AND 0 < (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem_pr.PartionGoodsId_child AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                       THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem_pr.PartionGoodsId_child AND OL.DescId  = zc_ObjectLink_PartionGoods_Unit())
                                                                                            , inGoodsId       := _tmpItem_pr.GoodsId
                                                                                            , inStorageId     := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = _tmpItem_pr.PartionGoodsId_child AND OL.DescId  = zc_ObjectLink_PartionGoods_Storage())
                                                                                            , inInvNumber     := _tmpItem_pr.PartionGoods
                                                                                            , inOperDate      := (SELECT OD.ValueData  FROM ObjectDate  AS OD  WHERE OD.ObjectId  = _tmpItem_pr.PartionGoodsId_child AND OD.DescId  = zc_ObjectDate_PartionGoods_Value())
                                                                                            , inPrice         := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = _tmpItem_pr.PartionGoodsId_child AND OFl.DescId = zc_ObjectFloat_PartionGoods_Price())
                                                                                             )
                                                  -- Спецодежда
                                                  WHEN _tmpItem_pr.InfoMoneyId = zc_Enum_InfoMoney_20202()
                                                       THEN lpInsertFind_Object_PartionGoods (inValue       := _tmpItem_pr.PartionGoods
                                                                                            , inOperDate    := zc_DateStart()
                                                                                            , inInfoMoneyId := zc_Enum_InfoMoney_20202()
                                                                                             )

                                               WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                AND (_tmpItem_pr.isPartionCount = TRUE OR _tmpItem_pr.isPartionSumm = TRUE)
                                                    THEN lpInsertFind_Object_PartionGoods (_tmpItem_pr.PartionGoods)

                                               -- Упаковка Мяса (тоже ПФ-ГП)
                                               WHEN vbIsPartionDate_Unit_To      = TRUE
                                                AND ((vbIsPartionGoodsKind_Unit_To = TRUE
                                                      AND vbUnitId_To NOT IN (8447    -- ЦЕХ ковбасних виробів
                                                                            , 8449    -- Цех сирокопчених ковбас
                                                                            , 8448    -- Дільниця делікатесів
                                                                            , 2790412 -- ЦЕХ Тушенка
                                                                              --
                                                                            , 8020711 -- ЦЕХ колбасный (Ирна)
                                                                            , 8020708 -- Склад МИНУСОВКА (Ирна)
                                                                            , 8020709 -- Склад ОХЛАЖДЕНКА (Ирна)
                                                                            , 8020710 -- Участок мясного сырья (Ирна)
                                                                             )
                                                     )
                                                  -- ИЛИ это группа - ЦЕХ колбаса+дел-сы
                                                  OR (EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbUnitId_From AND OL.ChildObjectId = 8446 AND OL.DescId = zc_ObjectLink_Unit_Parent())
                                                  -- select * from Object where DescId = zc_Object_Goods() and ObjectCode = 1256
                                                  AND _tmpItem_pr.GoodsId IN (1138737  -- !!!надо для 1256 ШКУРА СВ замоч. Чапли!!!!
                                                                            , 10691948 -- !!!надо для 4074 КОВБАСА ДЛЯ СМАЖЕННЯ ДОМАШНЯ н/ф зі свинини охолоджений!!!!
                                                                             )
                                                                           
                                                   --AND _tmpItem_pr.InfoMoneyId = zc_Enum_InfoMoney_10102() -- Основное сырье + Мясное сырье + Свинина - !!!надо для ШКУРА СВ замоч. Чапли!!!!
                                                     )
                                                    )
                                                AND vbIsPeresort = FALSE
                                                AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- Основное сырье + Мясное сырье
                                                AND NOT EXISTS (SELECT 1 FROM _tmpList_Goods_1942 WHERE _tmpList_Goods_1942.GoodsId = _tmpItem_pr.GoodsId)

                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem_pr.PartionGoodsDate
                                                                                        , inGoodsKindId_complete := _tmpItem_pr.GoodsKindId_complete
                                                                                         )
                                               -- Производство ПФ-ГП - !!!Мясное сырье!!!
                                               WHEN vbIsPartionDate_Unit_To = TRUE
                                                AND _tmpItem_pr.PartionGoodsDate <> zc_DateEnd()
                                                AND _tmpItem_pr.GoodsKindId IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis())
                                                AND _tmpItem_pr.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Основное сырье + Мясное сырье
                                                                                          )
                                                AND _tmpItem_pr.InfoMoneyId NOT IN (zc_Enum_InfoMoney_10105()  -- Прочее мясное сырье
                                                                                  , zc_Enum_InfoMoney_10106()  -- Сыр
                                                                                   )
                                                AND vbUnitId_To NOT IN (8447    -- ЦЕХ ковбасних виробів
                                                                      , 8449    -- Цех сирокопчених ковбас
                                                                      , 8448    -- Дільниця делікатесів
                                                                      , 2790412 -- ЦЕХ Тушенка
                                                                        --
                                                                      , 8020711 -- ЦЕХ колбасный (Ирна)
                                                                      , 8020708 -- Склад МИНУСОВКА (Ирна)
                                                                      , 8020709 -- Склад ОХЛАЖДЕНКА (Ирна)
                                                                      , 8020710 -- Участок мясного сырья (Ирна)
                                                                       )
                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem_pr.PartionGoodsDate
                                                                                        , inGoodsKindId_complete := _tmpItem_pr.GoodsKindId_complete
                                                                                         )
                                               -- Производство ПФ-ГП
                                               WHEN vbIsPartionDate_Unit_To = TRUE
                                                AND _tmpItem_pr.PartionGoodsDate <> zc_DateEnd()
                                                AND _tmpItem_pr.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                         , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                         , zc_Enum_InfoMoneyDestination_30200()  -- Доходы + Мясное сырье
                                                                                          )
                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem_pr.PartionGoodsDate
                                                                                        , inGoodsKindId_complete := _tmpItem_pr.GoodsKindId_complete
                                                                                         )
                                               --
                                               WHEN _tmpItem_pr.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                         , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                         , zc_Enum_InfoMoneyDestination_30200()  -- Доходы + Мясное сырье
                                                                                          )
                                                   THEN 0

                                               --
                                               WHEN (_tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                  OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                  OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                    )
                                                AND _tmpItem_pr.UnitId_Item > 0
                                                    THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= _tmpItem_pr.UnitId_Item
                                                                                         , inGoodsId       := _tmpItem_pr.GoodsId
                                                                                         , inStorageId     := _tmpItem_pr.StorageId_Item
                                                                                         , inInvNumber     := _tmpItem_pr.PartionGoods
                                                                                         , inOperDate      := _tmpItem_pr.PartionGoodsDate
                                                                                         , inPrice         := NULL
                                                                                          )
                                               --
                                               WHEN (_tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                  OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                  OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                    )
                                                AND vbUnitId_To > 0
                                                    THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                         , inGoodsId       := NULL
                                                                                         , inStorageId     := NULL
                                                                                         , inInvNumber     := NULL
                                                                                         , inOperDate      := NULL
                                                                                         , inPrice         := NULL
                                                                                          )
                                               /*WHEN _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                AND vbUnitId_To > 0
                                                    THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                         , inGoodsId       := NULL
                                                                                         , inStorageId     := NULL
                                                                                         , inInvNumber     := NULL
                                                                                         , inOperDate      := NULL
                                                                                         , inPrice         := NULL
                                                                                          )*/
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
      --OR (_tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
      --   AND vbUnitId_To > 0)
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
     ;

--  RAISE EXCEPTION 'Ошибка.<%>', (select _tmpItem_pr.PartionGoodsId from _tmpItem_pr);
-- select * from objectDate where objectId = 80132


IF inMovementId = 25575925  AND 1=0
THEN
    RAISE EXCEPTION '<%>   %', (select count(*) from _tmpItem_pr where _tmpItem_pr.MovementItemId = 261990876)
                           , (select count(*) from _tmpItemChild where _tmpItemChild.MovementItemId_Parent = 261990876)
                           ;
    -- 'Повторите действие через 3 мин.'
END IF;




     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1. определяется ContainerId_GoodsFrom для Child(расход)-элементы количественного учета
     UPDATE _tmpItemChild SET ContainerId_GoodsFrom = CASE WHEN _tmpItemChild.ContainerId_GoodsFrom > 0 THEN _tmpItemChild.ContainerId_GoodsFrom
                                                      ELSE
                                                      lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                         , inUnitId                 := CASE WHEN vbMemberId_From <> 0 THEN _tmpItemChild.UnitId_Item ELSE vbUnitId_From END
                                                                                         , inCarId                  := NULL
                                                                                         , inMemberId               := vbMemberId_From
                                                                                         , inInfoMoneyDestinationId := _tmpItemChild.InfoMoneyDestinationId
                                                                                         , inGoodsId                := _tmpItemChild.GoodsId
                                                                                         , inGoodsKindId            := _tmpItemChild.GoodsKindId
                                                                                         , inIsPartionCount         := _tmpItemChild.isPartionCount
                                                                                         , inPartionGoodsId         := _tmpItemChild.PartionGoodsId
                                                                                         , inAssetId                := _tmpItemChild.AssetId
                                                                                         , inBranchId               := vbBranchId_From
                                                                                         , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                          )
                                                      END;
     -- 1.2. определяется ContainerId_count для Child(расход)-Остатки количественного учета батонов
     UPDATE _tmpItemChild SET ContainerId_count = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                        , inParentId          := _tmpItemChild.ContainerId_GoodsFrom
                                                                        , inObjectId          := _tmpItemChild.GoodsId
                                                                        , inJuridicalId_basis := NULL
                                                                        , inBusinessId        := NULL
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                         )
     WHERE _tmpItemChild.OperCountCount <> 0;

     -- 2.1. определяется ContainerId_GoodsTo для Master(приход)-элементы количественного учета
     UPDATE _tmpItem_pr SET ContainerId_GoodsTo = CASE WHEN _tmpItem_pr.ObjectDescId = zc_Object_Asset()
                                                  THEN
                                                  lpInsertUpdate_ContainerCount_Asset (inOperDate               := vbOperDate
                                                                                     , inUnitId                 := vbUnitId_To
                                                                                     , inCarId                  := NULL
                                                                                     , inMemberId               := vbMemberId_To
                                                                                     , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                     , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                     , inGoodsKindId            := _tmpItem_pr.GoodsKindId
                                                                                     , inIsPartionCount         := _tmpItem_pr.isPartionCount
                                                                                     , inPartionGoodsId         := _tmpItem_pr.PartionGoodsId
                                                                                     , inAssetId                := (SELECT MAX (CLO_AssetTo.ObjectId)
                                                                                                                    FROM _tmpItemChild
                                                                                                                         INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                                        ON CLO_AssetTo.ContainerId = _tmpItemChild.ContainerId_GoodsFrom
                                                                                                                                                       AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                                                    WHERE _tmpItemChild.MovementItemId_Parent = _tmpItem_pr.MovementItemId
                                                                                                                   )
                                                                                     , inBranchId               := vbBranchId_To
                                                                                     , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                      )
                                                  ELSE
                                                  lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                     , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN _tmpItem_pr.UnitId_Item ELSE vbUnitId_To END
                                                                                     , inCarId                  := NULL
                                                                                     , inMemberId               := vbMemberId_To
                                                                                     , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                     , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                     , inGoodsKindId            := _tmpItem_pr.GoodsKindId
                                                                                     , inIsPartionCount         := _tmpItem_pr.isPartionCount
                                                                                     , inPartionGoodsId         := _tmpItem_pr.PartionGoodsId
                                                                                     , inAssetId                := _tmpItem_pr.AssetId
                                                                                     , inBranchId               := vbBranchId_To
                                                                                     , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                      )
                                                  END;

     -- 2.1. определяется ContainerId_count для Master(приход)-Остатки количественного учета батонов
     UPDATE _tmpItem_pr SET ContainerId_count = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                      , inParentId          := _tmpItem_pr.ContainerId_GoodsTo
                                                                      , inObjectId          := _tmpItem_pr.GoodsId
                                                                      , inJuridicalId_basis := NULL
                                                                      , inBusinessId        := NULL
                                                                      , inObjectCostDescId  := NULL
                                                                      , inObjectCostId      := NULL
                                                                       )
     WHERE _tmpItem_pr.OperCountCount <> 0;

--  RAISE EXCEPTION 'Ошибка.<%>   %', (select _tmpItem_pr.PartionGoodsId from _tmpItem_pr )
-- , (select _tmpItem_pr.ContainerId_GoodsTo from _tmpItem_pr )
-- ;


     -- самое интересное: заполняем таблицу - суммовые Child(расход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     IF inMovementId IN (2296516, 2296563) -- !!!захардкодил исправление ошибки - 31.07.2015!!!
     THEN
     INSERT INTO _tmpItemSummChild (MovementItemId_Parent, MovementItemId, ContainerId_GoodsFrom, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
        WITH tmpRemains AS (SELECT _tmpItemChild.ContainerId_GoodsFrom, Container.Id AS ContainerId, Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperSumm
                            FROM _tmpItemChild
                                 INNER JOIN Container ON Container.ParentId = _tmpItemChild.ContainerId_GoodsFrom
                                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = Container.Id
                                                                               AND MIContainer.OperDate >= '01.08.2015'
                            GROUP BY _tmpItemChild.ContainerId_GoodsFrom, Container.Id, Container.Amount
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                           )
        SELECT
              _tmpItemChild.MovementItemId_Parent
            , _tmpItemChild.MovementItemId
            , _tmpItemChild.ContainerId_GoodsFrom
            , Container.Id       AS ContainerId_From
            , Container.ObjectId AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , 1 * tmpRemains.OperSumm
        FROM _tmpItemChild
             INNER JOIN tmpRemains ON tmpRemains.ContainerId_GoodsFrom = _tmpItemChild.ContainerId_GoodsFrom
             INNER JOIN Container ON Container.Id = tmpRemains.ContainerId
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpRemains.ContainerId
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
       ;

     ELSEIF inMovementId IN (27533463) -- !!!захардкодил исправление ошибки - 01.06.2023!!! -- select * from Container where Container.ParentId =  808612
     THEN
         INSERT INTO _tmpItemSummChild (MovementItemId_Parent, MovementItemId, ContainerId_GoodsFrom, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
            SELECT
                  _tmpItemChild.MovementItemId_Parent
                , _tmpItemChild.MovementItemId
                , _tmpItemChild.ContainerId_GoodsFrom
                , Container.Id       AS ContainerId_From
                , Container.ObjectId AS AccountId_From
                , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
                , -1 * Container_err.Amount
            FROM _tmpItemChild
                 INNER JOIN Container ON Container.ParentId = _tmpItemChild.ContainerId_GoodsFrom
                                     AND Container.Amount   > 0
                                     AND Container.DescId   = zc_Container_Summ()
                 INNER JOIN Container AS Container_err
                                      ON Container_err.ParentId = _tmpItemChild.ContainerId_GoodsFrom
                                     AND Container_err.Amount   < 0
                                     AND Container_err.DescId   = zc_Container_Summ()
                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                               ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container.Id
                                              AND ContainerLinkObject_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
           ;

     ELSE

     INSERT INTO _tmpItemSummChild (MovementItemId_Parent, MovementItemId, ContainerId_GoodsFrom, ContainerId_From, AccountId_From, InfoMoneyId_Detail_From, OperSumm)
       --
       WITH -- где надо проверить с/с и потом найти альтернативную цену
            tmpHistoryCost_find_all AS (SELECT _tmpItem.ContainerId_GoodsFrom
                                             , _tmpItem.GoodsId
                                             , _tmpItem.GoodsKindId
                                             , Container_Summ.Id               AS ContainerId_Summ
                                             , Container_Summ.ObjectId         AS AccountId
                                             , COALESCE (HistoryCost.Price, 0) AS Price
                                        FROM _tmpItemChild AS _tmpItem
                                             INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                                                                   AND Container_Summ.DescId   = zc_Container_Summ()
                                             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                        WHERE vbIsPartionCell_from = TRUE
                                       )
                -- нашли с/с если нет для ContainerId_Goods
              , tmpHistoryCost_find AS (SELECT Container_Summ.ContainerId_GoodsFrom
                                             , Container_Summ.ContainerId_Summ
                                             , MAX (HistoryCost.Price) AS Price
                                        FROM -- нашли у каких ContainerId_GoodsFrom ВСЕ цены = 0
                                             (SELECT tmpHistoryCost_find_all.ContainerId_GoodsFrom FROM tmpHistoryCost_find_all
                                              GROUP BY tmpHistoryCost_find_all.ContainerId_GoodsFrom
                                              HAVING MAX (tmpHistoryCost_find_all.Price) = 0
                                             ) AS tmpHistoryCost_list
                                             -- для всех ContainerId_Summ надо найти альтернативную цену
                                             JOIN tmpHistoryCost_find_all AS Container_Summ ON Container_Summ.ContainerId_GoodsFrom = tmpHistoryCost_list.ContainerId_GoodsFrom

                                             -- св-ва ContainerId_Summ, где нет цены
                                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = Container_Summ.ContainerId_Summ
                                                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                             LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = Container_Summ.ContainerId_Summ
                                                                                                 AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                             LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = Container_Summ.ContainerId_Summ
                                                                                                AND CLO_JuridicalBasis.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                                               
                                             -- альтернатива
                                             JOIN Container AS Container_Count_new ON Container_Count_new.ObjectId = Container_Summ.GoodsId
                                                                                  AND Container_Count_new.DescId   = zc_Container_Count()
                                             JOIN Container AS Container_Summ_new ON Container_Summ_new.ParentId = Container_Count_new.Id
                                                                                 AND Container_Summ_new.ObjectId = Container_Summ.AccountId
                                                                                 AND Container_Summ_new.DescId   = zc_Container_Summ()
                                             INNER JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ_new.Id
                                                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                                                  -- !!! есть цена !!!
                                                                  AND HistoryCost.Price > 0
                                             -- св-ва
                                             INNER JOIN ContainerLinkObject AS CLO_Unit_new
                                                                            ON CLO_Unit_new.ContainerId = Container_Summ_new.Id
                                                                           AND CLO_Unit_new.DescId      = zc_ContainerLinkObject_Unit()
                                                                           AND CLO_Unit_new.ObjectId    = vbWhereObjectId_Analyzer_From

                                             INNER JOIN ContainerLinkObject AS CLO_InfoMoney_new ON CLO_InfoMoney_new.ContainerId = Container_Summ_new.Id
                                                                                                AND CLO_InfoMoney_new.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                                                                AND CLO_InfoMoney_new.ObjectId    = CLO_InfoMoney.ObjectId
                                             INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail_new ON CLO_InfoMoneyDetail_new.ContainerId = Container_Summ_new.Id
                                                                                                      AND CLO_InfoMoneyDetail_new.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      AND CLO_InfoMoneyDetail_new.ObjectId    = CLO_InfoMoneyDetail.ObjectId
                                             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind_new ON CLO_GoodsKind_new.ContainerId = Container_Summ_new.Id
                                                                                               AND CLO_GoodsKind_new.DescId      = zc_ContainerLinkObject_GoodsKind()
                                             INNER JOIN ContainerLinkObject AS CLO_JuridicalBasis_new ON CLO_JuridicalBasis_new.ContainerId = Container_Summ_new.Id
                                                                                                     AND CLO_JuridicalBasis_new.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                                                                                                     AND CLO_JuridicalBasis_new.ObjectId    = CLO_JuridicalBasis.ObjectId

                                        WHERE COALESCE (CLO_GoodsKind_new.ObjectId, 0) = COALESCE (Container_Summ.GoodsKindId, 0)
                                        GROUP BY Container_Summ.ContainerId_GoodsFrom
                                               , Container_Summ.ContainerId_Summ
                                  )
        -- Результат
        SELECT
              _tmpItemChild.MovementItemId_Parent
            , _tmpItemChild.MovementItemId
            , _tmpItemChild.ContainerId_GoodsFrom
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId_From
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
            , SUM (/*ABS*/ (CASE WHEN vbProcessId = zc_Enum_Process_Auto_Defroster() -- !!!для <Схема Дефростер> другая цена!!!
                                      THEN CAST (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price_external, 0) AS NUMERIC (16,4))
                                 ELSE CAST (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))
                                    + CASE WHEN _tmpItemChild.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                                THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                           ELSE 0
                                      END
                            END)) AS OperSumm
        FROM _tmpItemChild
             -- так находим для тары
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItemChild.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_From
                                                                                 AND lfContainerSumm_20901.BusinessId        = _tmpItemChild.BusinessId_From
                                                                                 AND _tmpItemChild.InfoMoneyDestinationId    = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
             -- так находим для остальных
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItemChild.ContainerId_GoodsFrom
                                                  AND Container_Summ.DescId   IN (zc_Container_Summ(), zc_Container_SummAsset())
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             /*INNER JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                            ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                           AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id) -- ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

             -- нашли с/с если нет для ContainerId_GoodsFrom
             LEFT JOIN tmpHistoryCost_find ON tmpHistoryCost_find.ContainerId_Summ = Container_Summ.Id
                                          AND HistoryCost.ContainerId IS NULL

        WHERE /*zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          -- AND inIsHistoryCost = TRUE -- OR (_tmpItemChild.OperCount * HistoryCost.Price) <> 0) -- !!!ОБЯЗАТЕЛЬНО!!! вставляем нули если это не последний раз (они нужны для расчета с/с)
          AND*/ (_tmpItemChild.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0)) <> 0 -- !!!НЕ!!! вставляем нули
          AND vbIsHistoryCost= TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
        GROUP BY
                 _tmpItemChild.MovementItemId_Parent
               , _tmpItemChild.MovementItemId
               , _tmpItemChild.ContainerId_GoodsFrom
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId
        ;
     END IF;

     -- !!!ПРОВЕРКА!!! - уникальность в Child(расход)-элементы документа
     IF EXISTS (SELECT _tmpItemSummChild.MovementItemId, _tmpItemSummChild.ContainerId_From FROM _tmpItemSummChild GROUP BY _tmpItemSummChild.MovementItemId, _tmpItemSummChild.ContainerId_From HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка в алгоритме.';
     END IF;


     -- группируем и получаем таблицу - суммовые Master(приход)-элементы документа, со всеми свойствами для формирования Аналитик в проводках
     IF inMovementId IN (2296516, 2296563) -- !!!захардкодил исправление ошибки - 01.08.2015!!!
     THEN
     INSERT INTO _tmpItemSumm_pr (MovementItemId, AccountGroupId_From, AccountDirectionId_From, AccountId_From, ContainerId_From, MIContainerId_To, ContainerId_To, AccountId_To, InfoMoneyDestinationId_asset, InfoMoneyId_asset, InfoMoneyId_Detail_To, OperSumm)
        SELECT _tmpItemSummChild.MovementItemId_Parent, ObjectLink_Account_AccountGroup.ChildObjectId, ObjectLink_Account_AccountDirection.ChildObjectId, _tmpItemSummChild.AccountId_From, _tmpItemSummChild.ContainerId_From
             , 0 AS MIContainerId_To
             , 0 AS ContainerId_To
             , 0 AS AccountId_To -- !!!почему было _tmpItemSummChild.AccountId_From!!!, теперь понятно почему
             , 0 AS InfoMoneyDestinationId_asset, 0 AS InfoMoneyId_asset
             , zc_Enum_InfoMoney_10203() AS InfoMoneyId_Detail_From
             , SUM (_tmpItemSummChild.OperSumm)
        FROM _tmpItemSummChild
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                  ON ObjectLink_Account_AccountGroup.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                  ON ObjectLink_Account_AccountDirection.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
        GROUP BY _tmpItemSummChild.MovementItemId_Parent
               , ObjectLink_Account_AccountGroup.ChildObjectId
               , ObjectLink_Account_AccountDirection.ChildObjectId
               , _tmpItemSummChild.AccountId_From
               , _tmpItemSummChild.ContainerId_From
                ;

     ELSEIF inMovementId IN (27533463) -- !!!захардкодил исправление ошибки - 01.06.2023!!! -- select * from Container where Container.ParentId =  808612
     THEN
         INSERT INTO _tmpItemSumm_pr (MovementItemId, AccountGroupId_From, AccountDirectionId_From, AccountId_From, ContainerId_From, MIContainerId_To, ContainerId_To, AccountId_To, InfoMoneyDestinationId_asset, InfoMoneyId_asset, InfoMoneyId_Detail_To, OperSumm)
            SELECT _tmpItemSummChild.MovementItemId_Parent
                 , ObjectLink_Account_AccountGroup.ChildObjectId     AS AccountGroupId_From
                 , ObjectLink_Account_AccountDirection.ChildObjectId AS AccountDirectionId_From
                 , _tmpItemSummChild.AccountId_From
                 , _tmpItemSummChild.ContainerId_From

                 , 0                      AS MIContainerId_To
                 , Container_err.Id       AS ContainerId_To
                 , Container_err.ObjectId AS AccountId_To -- !!!почему было _tmpItemSummChild.AccountId_From!!!, теперь понятно почему
                 , 0 AS InfoMoneyDestinationId_asset
                 , 0 AS InfoMoneyId_asset
                 , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
                 , _tmpItemSummChild.OperSumm
            FROM _tmpItemSummChild
                 INNER JOIN Container ON Container.Id = _tmpItemSummChild.ContainerId_From
                 INNER JOIN Container AS Container_err
                                      ON Container_err.ParentId = Container.ParentId
                                     AND Container_err.Amount   < 0
                                     AND Container_err.DescId   = zc_Container_Summ()

                 LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                      ON ObjectLink_Account_AccountGroup.ObjectId = _tmpItemSummChild.AccountId_From
                                     AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
                 LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                      ON ObjectLink_Account_AccountDirection.ObjectId = _tmpItemSummChild.AccountId_From
                                     AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()

                 LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                               ON ContainerLinkObject_InfoMoneyDetail.ContainerId = _tmpItemSummChild.ContainerId_From
                                              AND ContainerLinkObject_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                    ;

     ELSE
     INSERT INTO _tmpItemSumm_pr (MovementItemId, AccountGroupId_From, AccountDirectionId_From, AccountId_From, ContainerId_From, MIContainerId_To, ContainerId_To, AccountId_To, InfoMoneyDestinationId_asset, InfoMoneyId_asset, InfoMoneyId_Detail_To, OperSumm)
        SELECT _tmpItemSummChild.MovementItemId_Parent, ObjectLink_Account_AccountGroup.ChildObjectId, ObjectLink_Account_AccountDirection.ChildObjectId, _tmpItemSummChild.AccountId_From, _tmpItemSummChild.ContainerId_From
             , 0 AS MIContainerId_To
             , 0 AS ContainerId_To
             , CASE WHEN vbIsPeresort = TRUE THEN 0 ELSE 0 END AS AccountId_To -- !!!почему было _tmpItemSummChild.AccountId_From!!!, теперь понятно почему
               -- для Asset - не меняется
             , ObjectLink_InfoMoneyDestination.ChildObjectId AS InfoMoneyDestinationId_asset, ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId_asset
               --
             , _tmpItemSummChild.InfoMoneyId_Detail_From
             , SUM (_tmpItemSummChild.OperSumm)
        FROM _tmpItemSummChild
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                  ON ObjectLink_Account_AccountGroup.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
             LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                  ON ObjectLink_Account_AccountDirection.ObjectId = _tmpItemSummChild.AccountId_From
                                 AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()

             LEFT JOIN _tmpItemChild ON _tmpItemChild.MovementItemId        = _tmpItemSummChild.MovementItemId
                                    AND _tmpItemChild.ContainerId_GoodsFrom = _tmpItemSummChild.ContainerId_GoodsFrom
             -- для Asset - не меняется
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                           ON ContainerLinkObject_InfoMoney.ContainerId = _tmpItemSummChild.ContainerId_From
                                          AND ContainerLinkObject_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                          AND _tmpItemChild.ObjectDescId                = zc_Object_Asset()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                                  ON ObjectLink_InfoMoneyDestination.ObjectId = ContainerLinkObject_InfoMoney.ObjectId
                                 AND ObjectLink_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
        GROUP BY _tmpItemSummChild.MovementItemId_Parent
               , ObjectLink_Account_AccountGroup.ChildObjectId
               , ObjectLink_Account_AccountDirection.ChildObjectId
               , _tmpItemSummChild.AccountId_From
               , _tmpItemSummChild.ContainerId_From
               -- , CASE WHEN vbIsPeresort = TRUE THEN 0 ELSE 0 END -- !!!почему было _tmpItemSummChild.AccountId_From!!!, теперь понятно почему
               , ObjectLink_InfoMoneyDestination.ChildObjectId, ContainerLinkObject_InfoMoney.ObjectId
               , _tmpItemSummChild.InfoMoneyId_Detail_From;
     END IF;
/*
    RAISE EXCEPTION 'Ошибка.<%>  %  '
                                   , (select sum (_tmpItemSumm_pr.OperSumm) from _tmpItemSumm_pr where _tmpItemSumm_pr.MovementItemId = 289222842)
                                   , (select sum (_tmpItemSummChild.OperSumm) from _tmpItemSummChild where _tmpItemSummChild.MovementItemId_Parent = 289222842)
                                   ;
*/
     -- для теста - Master - Summ
     -- RETURN QUERY SELECT _tmpItemSumm_pr.AccountId_To, _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.MIContainerId_To, _tmpItemSumm_pr.InfoMoneyId_Detail_To, _tmpItemSumm_pr.OperSumm FROM _tmpItemSumm_pr;
     -- для теста - Child - Summ
     -- RETURN QUERY SELECT _tmpItemSummChild.MovementItemId_Parent, _tmpItemSummChild.MovementItemId, _tmpItemSummChild.ContainerId_From, _tmpItemSummChild.InfoMoneyId_Detail_From, _tmpItemSummChild.OperSumm FROM _tmpItemSummChild ;
     -- RETURN;


     -- формируются Проводки для количественного учета - Кому + определяется MIContainer.Id (количественный)
     UPDATE _tmpItem_pr SET MIContainerId_To =
             lpInsertUpdate_MovementItemContainer (ioId                      := 0
                                                 , inDescId                  := zc_MIContainer_Count()
                                                 , inMovementDescId          := vbMovementDescId
                                                 , inMovementId              := inMovementId
                                                 , inMovementItemId          := _tmpItem_pr.MovementItemId
                                                 , inParentId                := NULL
                                                 , inContainerId             := _tmpItem_pr.ContainerId_GoodsTo -- был опеределен выше
                                                 , inAccountId               := 0                               -- нет счета
                                                 , inAnalyzerId              := vbWhereObjectId_Analyzer_From   -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                 , inObjectId_Analyzer       := _tmpItem_pr.GoodsId             -- Товар
                                                 , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To     -- Подраделение или...
                                                 , inContainerId_Analyzer    := 0                               -- количественный Контейнер-Мастер (для прихода не надо)
                                                 , inObjectIntId_Analyzer    := _tmpItem_pr.GoodsKindId         -- вид товара
                                                 , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From   -- Подраделение "От кого"
                                                 , inContainerIntId_Analyzer := 0                               -- Контейнер "товар"
                                                 , inAmount                  := _tmpItem_pr.OperCount
                                                 , inOperDate                := vbOperDate
                                                 , inIsActive                := TRUE
                                                  )
        , MIContainerId_count = CASE WHEN _tmpItem_pr.OperCountCount = 0 THEN 0 ELSE
             lpInsertUpdate_MovementItemContainer (ioId                      := 0
                                                 , inDescId                  := zc_MIContainer_CountCount()
                                                 , inMovementDescId          := vbMovementDescId
                                                 , inMovementId              := inMovementId
                                                 , inMovementItemId          := _tmpItem_pr.MovementItemId
                                                 , inParentId                := NULL
                                                 , inContainerId             := _tmpItem_pr.ContainerId_count   -- был опеределен выше
                                                 , inAccountId               := 0                               -- нет счета
                                                 , inAnalyzerId              := vbWhereObjectId_Analyzer_From   -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                 , inObjectId_Analyzer       := _tmpItem_pr.GoodsId             -- Товар
                                                 , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To     -- Подраделение или...
                                                 , inContainerId_Analyzer    := 0                               -- количественный Контейнер-Мастер (для прихода не надо)
                                                 , inObjectIntId_Analyzer    := _tmpItem_pr.GoodsKindId         -- вид товара
                                                 , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From   -- Подраделение "От кого"
                                                 , inContainerIntId_Analyzer := 0                               -- Контейнер "товар"
                                                 , inAmount                  := _tmpItem_pr.OperCountCount
                                                 , inOperDate                := vbOperDate
                                                 , inIsActive                := TRUE
                                                  ) END;
     -- формируются Проводки для количественного учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       WITH tmpGoods_ReWork AS (SELECT ObjectLink.ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.ChildObjectId = zc_Enum_InfoMoney_30301() AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney())
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemChild.MovementItemId
            , _tmpItemChild.ContainerId_GoodsFrom
            , 0                                       AS AccountId              -- нет счета
            , CASE WHEN tmpGoods_ReWork.GoodsId > 0 THEN zc_Enum_AnalyzerId_ReWork() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- есть аналитика + для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItemChild.GoodsId                   AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem_pr.ContainerId_GoodsTo         AS ContainerId_Analyzer   -- количественный Контейнер-Мастер (т.е. из прихода)
            , _tmpItemChild.GoodsKindId               AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , _tmpItem_pr.MIContainerId_To            AS ParentId
            , -1 * _tmpItemChild.OperCount
            , vbOperDate
            , FALSE
       FROM _tmpItemChild
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemChild.MovementItemId_Parent
            LEFT JOIN tmpGoods_ReWork ON tmpGoods_ReWork.GoodsId = _tmpItem_pr.GoodsId

      UNION ALL
       SELECT 0, zc_MIContainer_CountCount() AS DescId, vbMovementDescId, inMovementId, _tmpItemChild.MovementItemId
            , _tmpItemChild.ContainerId_count
            , 0                                       AS AccountId              -- нет счета
            , CASE WHEN tmpGoods_ReWork.GoodsId > 0 THEN zc_Enum_AnalyzerId_ReWork() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- есть аналитика + для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItemChild.GoodsId                   AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem_pr.ContainerId_count           AS ContainerId_Analyzer   -- количественный Контейнер-Мастер (т.е. из прихода)
            , _tmpItemChild.GoodsKindId               AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , NULL                                    AS ParentId               -- !!!
            , -1 * _tmpItemChild.OperCountCount
            , vbOperDate
            , FALSE
       FROM _tmpItemChild
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemChild.MovementItemId_Parent
            LEFT JOIN tmpGoods_ReWork ON tmpGoods_ReWork.GoodsId = _tmpItem_pr.GoodsId
       WHERE _tmpItemChild.OperCountCount <> 0
      ;


     -- определяется Счет(справочника) для проводок по суммовому учету - Кому
     UPDATE _tmpItemSumm_pr SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM _tmpItem_pr
          JOIN (SELECT CASE WHEN _tmpItem_group.ObjectDescId = zc_Object_Asset()
                            -- !!!т.е. счет не меняется!!!
                            THEN  _tmpItem_group.AccountId_From
                            --
                            ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId_From -- zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                            , inAccountDirectionId     := CASE WHEN vbIsPeresort = TRUE OR vbIsBranch = TRUE
                                                                                                    THEN _tmpItem_group.AccountDirectionId_From
                                                                                               WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                                                                                                    THEN zc_Enum_AccountDirection_20900() -- 20900; "Оборотная тара"
                                                                                               WHEN vbMemberId_To <> 0
                                                                                                AND _tmpItem_group.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_20700() -- "Общефирменные"; 20700; "Товары"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_20900() -- "Общефирменные"; 20900; "Ирна"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_21000() -- "Общефирменные"; 21000; "Чапли"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_21100() -- "Общефирменные"; 21100; "Дворкин"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                                                             )
                                                                                                    THEN 0 -- !!!по идее для Сотрудника их здесь быть не может!!!
                                                                                               ELSE vbAccountDirectionId_To
                                                                                          END
                                                            , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                            , inInfoMoneyId            := NULL
                                                            , inUserId                 := inUserId
                                                             )
                       END AS AccountId
                     , _tmpItem_group.InfoMoneyDestinationId
                     , _tmpItem_group.AccountId_From
                FROM (SELECT DISTINCT
                             _tmpItem_pr.ObjectDescId
                           , _tmpItem_pr.InfoMoneyDestinationId
                           , CASE WHEN (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                  --WHEN _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                  --     THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  WHEN (vbAccountDirectionId_To = zc_Enum_AccountDirection_20800() AND _tmpItem_pr.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- Запасы + на упаковке AND Основное сырье + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  ELSE _tmpItem_pr.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                           , _tmpItemSumm_pr.AccountGroupId_From
                           , _tmpItemSumm_pr.AccountDirectionId_From
                           , _tmpItemSumm_pr.AccountId_From
                      FROM _tmpItem_pr
                           INNER JOIN _tmpItemSumm_pr ON _tmpItemSumm_pr.MovementItemId = _tmpItem_pr.MovementItemId
                      WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
                        -- AND vbIsPeresort = FALSE -- !!!если НЕ пересортица!!! -- !!!почему было _tmpItemSummChild.AccountId_From!!!, теперь понятно почему
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem_pr.InfoMoneyDestinationId
     WHERE _tmpItemSumm_pr.MovementItemId = _tmpItem_pr.MovementItemId
       AND _tmpItemSumm_pr.AccountId_From = _tmpItem_byAccount.AccountId_From;

     -- определяется ContainerId для проводок по суммовому учету - Кому  + формируется Аналитика <элемент с/с>
     UPDATE _tmpItemSumm_pr SET ContainerId_To = _tmpItem_group.ContainerId_To
     FROM (SELECT CASE WHEN _tmpItemSumm_group.ContainerId_To > 0
                            THEN _tmpItemSumm_group.ContainerId_To
                       WHEN _tmpItem_pr.ObjectDescId = zc_Object_Asset()
                       THEN lpInsertUpdate_ContainerSumm_Asset (inOperDate               := vbOperDate
                                                              , inUnitId                 := vbUnitId_To
                                                              , inCarId                  := NULL
                                                              , inMemberId               := vbMemberId_To
                                                              , inBranchId               := vbBranchId_To
                                                              , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                              , inBusinessId             := _tmpItem_pr.BusinessId_To
                                                              , inAccountId              := _tmpItemSumm_group.AccountId_To
                                                                -- для Asset - не меняется
                                                              , inInfoMoneyDestinationId := _tmpItemSumm_group.InfoMoneyDestinationId_asset
                                                                -- для Asset - не меняется
                                                              , inInfoMoneyId            := _tmpItemSumm_group.InfoMoneyId_asset
                                                                --
                                                              , inInfoMoneyId_Detail     := _tmpItemSumm_group.InfoMoneyId_Detail_To
                                                              , inContainerId_Goods      := _tmpItem_pr.ContainerId_GoodsTo
                                                              , inGoodsId                := _tmpItem_pr.GoodsId
                                                              , inGoodsKindId            := _tmpItem_pr.GoodsKindId
                                                              , inIsPartionSumm          := _tmpItem_pr.isPartionSumm
                                                              , inPartionGoodsId         := _tmpItem_pr.PartionGoodsId
                                                              , inAssetId                := (SELECT MAX (CLO_AssetTo.ObjectId)
                                                                                             FROM _tmpItemChild
                                                                                                  INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                                                                                                 ON CLO_AssetTo.ContainerId = _tmpItemChild.ContainerId_GoodsFrom
                                                                                                                                AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()
                                                                                             WHERE _tmpItemChild.MovementItemId_Parent = _tmpItem_pr.MovementItemId
                                                                                            )
                                                               )
                       ELSE lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                              , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN _tmpItem_pr.UnitId_Item ELSE vbUnitId_To END
                                                              , inCarId                  := NULL
                                                              , inMemberId               := vbMemberId_To
                                                              , inBranchId               := vbBranchId_To
                                                              , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                              , inBusinessId             := _tmpItem_pr.BusinessId_To
                                                              , inAccountId              := _tmpItemSumm_group.AccountId_To
                                                              , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                              , inInfoMoneyId            := _tmpItem_pr.InfoMoneyId
                                                              , inInfoMoneyId_Detail     := _tmpItemSumm_group.InfoMoneyId_Detail_To
                                                              , inContainerId_Goods      := _tmpItem_pr.ContainerId_GoodsTo
                                                              , inGoodsId                := _tmpItem_pr.GoodsId
                                                              , inGoodsKindId            := _tmpItem_pr.GoodsKindId
                                                              , inIsPartionSumm          := _tmpItem_pr.isPartionSumm
                                                              , inPartionGoodsId         := _tmpItem_pr.PartionGoodsId
                                                              , inAssetId                := _tmpItem_pr.AssetId
                                                               )
                  END AS ContainerId_To
                , _tmpItem_pr.MovementItemId
                , _tmpItemSumm_group.AccountId_To
                , _tmpItemSumm_group.InfoMoneyId_Detail_To
           FROM _tmpItem_pr
                JOIN (SELECT DISTINCT _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.AccountId_To, _tmpItemSumm_pr.InfoMoneyId_Detail_To
                                    , _tmpItemSumm_pr.InfoMoneyDestinationId_asset
                                    , _tmpItemSumm_pr.InfoMoneyId_asset
                                    , _tmpItemSumm_pr.ContainerId_To
                      FROM _tmpItemSumm_pr
                     ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_pr.MovementItemId
          ) AS _tmpItem_group
     WHERE _tmpItemSumm_pr.MovementItemId = _tmpItem_group.MovementItemId
       AND _tmpItemSumm_pr.AccountId_To = _tmpItem_group.AccountId_To
       AND _tmpItemSumm_pr.InfoMoneyId_Detail_To = _tmpItem_group.InfoMoneyId_Detail_To
      ;

     -- формируются Проводки для суммового учета - Кому + определяется MIContainer.Id (суммовой)
     UPDATE _tmpItemSumm_pr SET MIContainerId_To = _tmpItem_group.MIContainerId_To
     FROM (SELECT lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                      , inDescId         := zc_MIContainer_Summ()
                                                      , inMovementDescId := vbMovementDescId
                                                      , inMovementId     := inMovementId
                                                      , inMovementItemId := _tmpItem_pr.MovementItemId
                                                      , inParentId       := NULL
                                                      , inContainerId    := _tmpItemSumm_group.ContainerId_To
                                                      , inAccountId      := _tmpItemSumm_group.AccountId_To         -- счет есть всегда
                                                      , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                      , inObjectId_Analyzer       := _tmpItem_pr.GoodsId            -- Товар
                                                      , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- Подраделение или...
                                                      , inContainerId_Analyzer    := 0                              -- суммовой Контейнер-Мастер (для прихода не надо)
                                                      , inObjectIntId_Analyzer    := _tmpItem_pr.GoodsKindId        -- вид товара
                                                      , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- Подраделение "От кого"
                                                      , inContainerIntId_Analyzer := 0                              -- Контейнер "товар"
                                                      , inAmount         := _tmpItemSumm_group.OperSumm
                                                      , inOperDate       := vbOperDate
                                                      , inIsActive       := TRUE
                                                       ) AS MIContainerId_To
                , _tmpItem_pr.MovementItemId
                , _tmpItemSumm_group.ContainerId_To
           FROM _tmpItem_pr
                JOIN (SELECT _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.ContainerId_To, _tmpItemSumm_pr.AccountId_To, SUM (_tmpItemSumm_pr.OperSumm) AS OperSumm FROM _tmpItemSumm_pr GROUP BY _tmpItemSumm_pr.MovementItemId, _tmpItemSumm_pr.ContainerId_To, _tmpItemSumm_pr.AccountId_To
                     ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_pr.MovementItemId
          ) AS _tmpItem_group
     WHERE _tmpItemSumm_pr.MovementItemId = _tmpItem_group.MovementItemId
       AND _tmpItemSumm_pr.ContainerId_To = _tmpItem_group.ContainerId_To;

     -- формируются Проводки для суммового учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       WITH tmpGoods_ReWork AS (SELECT ObjectLink.ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.ChildObjectId = zc_Enum_InfoMoney_30301() AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney())
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemChild.MovementItemId
            , _tmpItemSummChild.ContainerId_From
            , _tmpItemSummChild.AccountId_From        AS AccountId              -- счет есть всегда
            , CASE WHEN tmpGoods_ReWork.GoodsId > 0 THEN zc_Enum_AnalyzerId_ReWork() ELSE vbWhereObjectId_Analyzer_To END AS AnalyzerId -- есть аналитика + для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItemChild.GoodsId                   AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm_pr.ContainerId_To          AS ContainerId_Analyzer   -- суммовой Контейнер-Мастер (т.е. из прихода)
            , _tmpItemChild.GoodsKindId               AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , _tmpItemSumm_pr.MIContainerId_To        AS ParentId
            , -1 * _tmpItemSummChild.OperSumm
            , vbOperDate
            , FALSE
       FROM _tmpItemChild
            JOIN _tmpItemSummChild ON _tmpItemSummChild.MovementItemId        = _tmpItemChild.MovementItemId
                                  -- для партий
                                  AND _tmpItemSummChild.ContainerId_GoodsFrom = _tmpItemChild.ContainerId_GoodsFrom
            JOIN _tmpItemSumm_pr ON _tmpItemSumm_pr.MovementItemId   = _tmpItemSummChild.MovementItemId_Parent
                                AND _tmpItemSumm_pr.ContainerId_From = _tmpItemSummChild.ContainerId_From

            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemSumm_pr.MovementItemId
            LEFT JOIN tmpGoods_ReWork ON tmpGoods_ReWork.GoodsId = _tmpItem_pr.GoodsId
      ;



     -- !!!Проводки для отчета больше не нужны!!!
     IF 1=0 THEN
     -- !!!не всегда Проводки для отчета!!!
     IF vbIsHistoryCost = TRUE THEN


     -- формируются Проводки для отчета (Аналитики: Товар расход и Товар приход)
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
                   , vbOperDate AS OperDate
              FROM (SELECT ABS (tmpCalc.OperSumm)       AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To   ELSE tmpCalc.ContainerId_From END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_From ELSE tmpCalc.ContainerId_To   END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To     ELSE tmpCalc.AccountId_From   END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_From   ELSE tmpCalc.AccountId_To     END AS PassiveAccountId
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm_pr.MovementItemId
                               , _tmpItemSummChild.ContainerId_From
                               , _tmpItemSummChild.AccountId_From
                               , _tmpItemSumm_pr.ContainerId_To
                               , _tmpItemSumm_pr.AccountId_To
                               , (_tmpItemSummChild.OperSumm) AS OperSumm
                          FROM _tmpItemSummChild
                               JOIN _tmpItemSumm_pr ON _tmpItemSumm_pr.MovementItemId = _tmpItemSummChild.MovementItemId_Parent
                                                   AND _tmpItemSumm_pr.ContainerId_From = _tmpItemSummChild.ContainerId_From
                               LEFT JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItemSummChild.MovementItemId_Parent
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     END IF; -- if vbIsHistoryCost = TRUE -- !!!не всегда Проводки для отчета!!!
     END IF; -- if 1=0 -- !!!Проводки для отчета больше не нужны!!!


     -- !!!5.0. формируются свойства в элементах документа - <Рецептуры>, если не ПФ-ГП и не пересортица!!!
     IF vbIsPeresort = FALSE
     THEN
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), tmp.MovementItemId, tmp.ReceiptId)
          FROM (SELECT _tmpItem_pr.MovementItemId
                     , CASE WHEN COALESCE (tmpReceipt.ReceiptId, 0) = 0 THEN MILO_Receipt.ObjectId ELSE tmpReceipt.ReceiptId END
                FROM _tmpItem_pr
                     LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                      ON MILO_Receipt.MovementItemId = _tmpItem_pr.MovementItemId
                                                     AND MILO_Receipt.DescId         = zc_MILinkObject_Receipt()
                     LEFT JOIN (SELECT COALESCE (ObjectLink_Receipt_Goods.ObjectId, 0) AS ReceiptId
                                     , tmpGoods.GoodsId
                                     , tmpGoods.GoodsKindId
                                FROM (SELECT _tmpItem_pr.GoodsId, _tmpItem_pr.GoodsKindId FROM _tmpItem_pr WHERE _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress() GROUP BY _tmpItem_pr.GoodsId, _tmpItem_pr.GoodsKindId) AS tmpGoods
                                     INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                           ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                          AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                     -- Главный
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                              ON ObjectBoolean_Main.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                             AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                             AND ObjectBoolean_Main.ValueData = TRUE
                                     LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                          ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                         AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpGoods.GoodsKindId
                               ) AS tmpReceipt ON tmpReceipt.GoodsId     = _tmpItem_pr.GoodsId
                                              AND tmpReceipt.GoodsKindId = _tmpItem_pr.GoodsKindId
                WHERE _tmpItem_pr.GoodsKindId <> zc_GoodsKind_WorkProgress()
                      -- Тушенка
                  AND _tmpItem_pr.InfoMoneyId <> zc_Enum_InfoMoney_30102()
               ) AS tmp;

     END IF; -- if vbIsPeresort = FALSE

     -- !!!5.0.2. формируются свойства "по рецептуре" в элементах документа, если ПФ-ГП и не пересортица!!!
     IF vbIsPeresort = FALSE AND 1=0
     THEN
          PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), tmp.MovementItemId, tmp.isWeightMain)
                , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_TaxExit(), tmp.MovementItemId, tmp.isTaxExit)
          FROM (SELECT MovementItem.Id                      AS MovementItemId
                     , COALESCE (tmpMI.isWeightMain, FALSE) AS isWeightMain
                     , COALESCE (tmpMI.isTaxExit, FALSE)    AS isTaxExit
                FROM _tmpItem_pr
                     INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId   = zc_MI_Child()
                                            AND MovementItem.ParentId = _tmpItem_pr.MovementItemId
                                            AND MovementItem.isErased  = FALSE
                     LEFT JOIN (SELECT _tmpItem_pr.MovementItemId                              AS MovementItemId
                                     , ObjectLink_ReceiptChild_Goods.ChildObjectId          AS GoodsId
                                     , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE) AS isWeightMain
                                     , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)    AS isTaxExit
                                FROM _tmpItem_pr
                                     INNER JOIN MovementItemLinkObject AS MILO_Receipt
                                                                       ON MILO_Receipt.MovementItemId = _tmpItem_pr.MovementItemId
                                                                      AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                                     INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                           ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                                          AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                     LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                          ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                         AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                             ON ObjectBoolean_WeightMain.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                            AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                             ON ObjectBoolean_TaxExit.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                            AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                                WHERE _tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress()
                               ) AS tmpMI ON tmpMI.MovementItemId = _tmpItem_pr.MovementItemId
                                         AND tmpMI.GoodsId = MovementItem.ObjectId
                WHERE _tmpItem_pr.GoodsKindId = zc_GoodsKind_WorkProgress()
               ) AS tmp;

     END IF; -- if vbIsPeresort = FALSE AND 1=0
     

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable (inUserId);
     -- 5.2. ФИНИШ - Обязательно сохраняем Проводки для Отчета
     PERFORM lpInsertUpdate_MIReport_byTable ();

     -- 5.3. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ProductionUnion()
                                , inUserId     := inUserId
                                 );


     -- !!!обязательно ПОСЛЕ проводок!!! - Пересчет только для IsPeresort - переходящий остаток
     IF vbIsPeresort = TRUE AND vbUnitId_From IN (8447, 8448, 8449) -- ЦЕХ ковбасних виробів + ЦЕХ деликатесов + Цех сирокопчених ковбас
        --AND 1=0
        AND inUserId = zc_Enum_Process_Auto_PrimeCost() :: Integer
     THEN
         PERFORM gpUpdate_MI_ProductionUnion_AmountNext_out (inMovementId:= tmp.MovementId, inSession:= inUserId :: TVarChar)
         FROM (SELECT DISTINCT MIContainer.MovementId
               FROM _tmpItemChild
                    INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                   ON CLO_PartionGoods.ContainerId = _tmpItemChild.ContainerId_GoodsFrom
                                                  AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                    INNER JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                             AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                    INNER JOIN MovementItemContainer AS MIContainer
                                                     ON MIContainer.ContainerId    = _tmpItemChild.ContainerId_GoodsFrom
                                                    AND MIContainer.DescId         = zc_MIContainer_Count()
                                                    AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                    AND MIContainer.IsActive       = TRUE
                                                    AND MIContainer.OperDate       = ObjectDate_Value.ValueData

                    INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = MIContainer.MovementId
                                                             AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                             AND MLO_From.ObjectId   = vbUnitId_From
                    INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = MIContainer.MovementId
                                                           AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                           AND MLO_To.ObjectId   = vbUnitId_From

                    -- без пересортицы
                    LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                              ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                             AND MovementBoolean_Peresort.DescId     = zc_MovementBoolean_Peresort()
                                             AND MovementBoolean_Peresort.ValueData  = TRUE

               -- !!!убрали Пересортицу!!!
               WHERE MovementBoolean_Peresort.MovementId IS NULL
              ) AS tmp;
     END IF;


IF inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer) AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>  %   %   %'
                                   , (select min (_tmpItem_pr.ContainerId_GoodsTo) from _tmpItem_pr)
                                   , (select min (_tmpItemSumm_pr.ContainerId_To) from _tmpItemSumm_pr)
                                   , (select min (_tmpItemChild.ContainerId_GoodsFrom) from _tmpItemChild)
                                   , (select min (_tmpItemSummChild.ContainerId_From) from _tmpItemSummChild )
                                    ;
end if;

IF inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer) AND EXISTS (select 1 from MovementItemContainer where ContainerId in (5811824, 5821341) AnD MovementId = inMovementId)
   AND 1=0
THEN
    RAISE EXCEPTION 'count <%>', (select Count(*) from MovementItemContainer where ContainerId in (5811824, 5821341) AnD MovementId = 27857061);
end if;

     -- кроме Админа
     IF inUserId <> zfCalc_UserAdmin() :: Integer
     THEN
         -- !!!Синхронно - пересчитали/провели Пересортица!!! - на основании "Производство" - !!!важно - здесь очищается ВСЕ, поэтому делаем ПОСЛЕ проводок!!!
         PERFORM lpComplete_Movement_ProductionUnion_Recalc (inMovementId := inMovementId
                                                           , inUnitId     := vbUnitId_From
                                                           , inUserId     := inUserId
                                                            );
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.15                                        * add lpComplete_Movement_ProductionUnion_Partion
 03.05.15                                        * set lp
 17.08.14                                        * add MovementDescId
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 05.08.14                                        * add UnitId_Item and ...
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 11.08.13                                        * add inIsHistoryCost
 10.08.13                                        * в проводках для количественного и суммового учета: Master - приход, Child - расход (т.е. точно так же как и для MovementItem)
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 24.07.13                                        * !ОБЯЗАТЕЛЬНО! вставляем нули
 21.07.13                                        * ! finich !
 20.07.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 143712, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_ProductionUnion (inMovementId:= 143712, inIsHistoryCost:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 143712, inSession:= '2')
-- select * from gpUpdate_Status_ProductionUnion(inMovementId := 25281711 , inStatusCode := 2 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
-- select gpComplete_All_Sybase (28138209, FALSE, '')
