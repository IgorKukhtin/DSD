-- Function: gpComplete_Movement_Inventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_Inventory  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer Integer;

  DECLARE vbIsGoodsGroup Boolean;
  DECLARE vbIsLastOnMonth Boolean;

  DECLARE vbStatusId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbUnitId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbMemberId Integer;
  DECLARE vbBranchId Integer;
  DECLARE vbAccountDirectionId Integer;
  DECLARE vbIsPartionDate_Unit Boolean;
  DECLARE vbIsPartionGoodsKind_Unit Boolean;
  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId Integer;
  DECLARE vbUnitId_Car Integer;

  DECLARE vbPriceListId Integer;

  DECLARE vbProfitLossGroupId Integer;
  DECLARE vbProfitLossDirectionId Integer;

  DECLARE vbGoodsGroupId    Integer;
  DECLARE vbIsGoodsGroupIn  Boolean;
  DECLARE vbIsGoodsGroupExc Boolean;
  DECLARE vbIsList          Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= lpGetUserBySession (inSession)  :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Inventory());
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Inventory_CreateTemp();


     -- !!!ВРЕМЕННО, исправляется ошибка!!!!
     UPDATE MovementItem SET isErased = TRUE
     WHERE MovementItem.isErased = FALSE
       AND MovementItem.Amount = 0
       AND MovementItem.MovementId = inMovementId;


     -- Эти параметры нужны для расчета остатка
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Car() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS CarId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS MemberId
          , COALESCE (ObjectLink_ObjectFrom_Branch.ChildObjectId, 0) AS BranchId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                           WHEN Object_From.DescId = zc_Object_Car()
                                THEN zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                           WHEN Object_From.DescId = zc_Object_Member()
                                THEN zc_Enum_AccountDirection_20500() -- "Запасы"; 20500; "сотрудники (МО)"
                      END, 0) AS AccountDirectionId -- !!!не окончательное значение, т.к. еще может зависить от InfoMoneyDestinationId (Товара)!!!
          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)      AS isPartionDate_Unit
          , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE)  AS isPartionGoodsKind_Unit

          , COALESCE (ObjectLink_ObjectFrom_Juridical.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_Basis
          , COALESCE (ObjectLink_ObjectFrom_Business.ChildObjectId, 0)      AS BusinessId

          , COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, 0)             AS UnitId_Car

          , CASE WHEN COALESCE (ObjectLink_ObjectFrom_Branch.ChildObjectId, zc_Branch_Basis()) NOT IN (zc_Branch_Basis(), 8109544) -- Ирна
                  AND Object_From.DescId = zc_Object_Unit()
                      THEN COALESCE (MovementLinkObject_PriceList.ObjectId, zc_PriceList_Basis())
                 ELSE 0
            END AS PriceListId

          , MovementLinkObject_GoodsGroup.ObjectId                               AS GoodsGroupId
          , COALESCE (MovementBoolean_GoodsGroupIn.ValueData,  FALSE) :: Boolean AS isGoodsGroupIn
          , COALESCE (MovementBoolean_GoodsGroupExc.ValueData, FALSE) :: Boolean AS isGoodsGroupExc
          , COALESCE (MovementBoolean_List.ValueData,          FALSE) :: Boolean AS isList

            INTO vbMovementDescId, vbStatusId, vbOperDate
               , vbUnitId, vbCarId, vbMemberId, vbBranchId, vbAccountDirectionId, vbIsPartionDate_Unit, vbIsPartionGoodsKind_Unit, vbJuridicalId_Basis, vbBusinessId
               , vbUnitId_Car
               , vbPriceListId
               , vbGoodsGroupId, vbIsGoodsGroupIn, vbIsGoodsGroupExc, vbIsList
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()

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

          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupIn
                                    ON MovementBoolean_GoodsGroupIn.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupIn.DescId = zc_MovementBoolean_GoodsGroupIn()
          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupExc
                                    ON MovementBoolean_GoodsGroupExc.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupExc.DescId = zc_MovementBoolean_GoodsGroupExc()
          LEFT JOIN MovementBoolean AS MovementBoolean_List
                                    ON MovementBoolean_List.MovementId = Movement.Id
                                   AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

          LEFT JOIN ObjectLink AS ObjectLink_CarFrom_Unit
                               ON ObjectLink_CarFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_CarFrom_Unit.DescId = zc_ObjectLink_Car_Unit()
                              AND Object_From.DescId = zc_Object_Car()

          LEFT JOIN ObjectLink AS ObjectLink_ObjectFrom_Branch
                               ON ObjectLink_ObjectFrom_Branch.ObjectId = COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_ObjectFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN ObjectLink AS ObjectLink_ObjectFrom_Juridical
                               ON ObjectLink_ObjectFrom_Juridical.ObjectId = COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_ObjectFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_ObjectFrom_Business
                               ON ObjectLink_ObjectFrom_Business.ObjectId = COALESCE (ObjectLink_CarFrom_Unit.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_ObjectFrom_Business.DescId = zc_ObjectLink_Unit_Business()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsGroup
                                       ON MovementLinkObject_GoodsGroup.MovementId = Movement.Id
                                      AND MovementLinkObject_GoodsGroup.DescId = zc_MovementLinkObject_GoodsGroup()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Inventory()
       AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- !!!Если документ проведен - выход!!!
     IF vbStatusId = zc_Enum_Status_Complete() THEN RETURN; END IF;
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- проверка
     IF COALESCE (vbUnitId, 0) = 0 AND COALESCE (vbCarId, 0) = 0 AND COALESCE (vbMemberId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <От Кого>.';
     END IF;


     -- !!!Если это последняя инвент в текущем месяце, тогда "зависшие" коп. надо списать!!!
     vbIsLastOnMonth:= (vbOperDate + INTERVAL '1 DAY' = DATE_TRUNC ('MONTH', vbOperDate + INTERVAL '1 DAY'))
                    OR vbPriceListId = 0
                      ;

     /*vbIsLastOnMonth:= NOT EXISTS (SELECT 1
                                   FROM Movement
                                        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                     AND MovementLinkObject_From.ObjectId = vbUnitId
                                   WHERE Movement.OperDate > vbOperDate
                                     AND (EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM vbOperDate)
                                       -- OR Movement.Id IN (11270863 , 11250369)
                                         )
                                     AND Movement.DescId = zc_Movement_Inventory()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                  );*/


     IF inMovementId IN (11270863 , 11250369, 11648660)
        -- OR 1=1
     THEN
         vbIsLastOnMonth:= FALSE;
         -- RAISE EXCEPTION '<%>', ;
     END IF;


     -- !!!Ограничения по товарам!!!
     IF vbIsList = TRUE
     THEN
         vbIsGoodsGroup:= TRUE;
         --
         INSERT INTO _tmpGoods_Complete_Inventory (GoodsId)
            SELECT DISTINCT MovementItem.ObjectId AS GoodsId FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
           ;
     -- !!!Ограничения по товарам!!!
     ELSEIF vbGoodsGroupId > 0 AND vbIsGoodsGroupExc = TRUE
     THEN
         vbIsGoodsGroup:= TRUE;
         --
         INSERT INTO _tmpGoods_Complete_Inventory (GoodsId)
            WITH tmpGoods AS (SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (vbGoodsGroupId) AS lfSelect)
            SELECT Object.Id AS GoodsId FROM Object LEFT JOIN tmpGoods ON tmpGoods.GoodsId = Object.Id WHERE Object.DescId = zc_Object_Goods() AND tmpGoods.GoodsId IS NULL
           ;
     -- !!!Ограничения по товарам!!!
     ELSEIF vbGoodsGroupId > 0 AND vbIsGoodsGroupIn = TRUE
     THEN
         vbIsGoodsGroup:= TRUE;
         --
         INSERT INTO _tmpGoods_Complete_Inventory (GoodsId)
            SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (vbGoodsGroupId) AS lfSelect
           ;
     ELSEIF EXISTS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup WHERE UnitId = vbUnitId) -- ЦЕХ колбаса+дел-сы
       AND 1 <> EXTRACT (DAY FROM (vbOperDate :: Date + 1))
     THEN
         vbIsGoodsGroup:= TRUE;
         --
         INSERT INTO _tmpGoods_Complete_Inventory (GoodsId)
            SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1945)    AS lfSelect -- СО-ОБЩАЯ
           UNION
            SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1942)    AS lfSelect -- СО-ЭМУЛЬСИИ
           UNION
            SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (5064881) AS lfSelect -- СО-ПОСОЛ
           UNION
            SELECT lfSelect.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (1938)    AS lfSelect -- С-ПЕРЕРАБОТКА
            WHERE vbUnitId <> 8447 -- ЦЕХ колбасный
           ;

     ELSE
         vbIsGoodsGroup:= FALSE;
     END IF;


     -- Определяются параметры для проводок по прибыли
     IF EXISTS (SELECT 1
                FROM (SELECT (lfGet_Object_Unit_byProfitLossDirection (tmpUnit.UnitId)).ProfitLossGroupId AS ProfitLossGroupId
                      FROM (SELECT vbUnitId AS UnitId WHERE vbUnitId <> 0 UNION ALL SELECT vbUnitId_Car AS UnitId WHERE vbUnitId_Car <> 0 -- UNION ALL SELECT vbUnitId_Personal AS UnitId WHERE vbUnitId_Personal <> 0
                           ) AS tmpUnit
                     ) AS tmp
                WHERE tmp.ProfitLossGroupId = zc_Enum_ProfitLossGroup_40000()) -- 40000; "Расходы на сбыт"
     THEN
         -- такие для Автомобиля/Подразделения (по филиалу)
         vbProfitLossGroupId     := zc_Enum_ProfitLossGroup_40000();     -- Расходы на сбыт
         vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_40400(); -- Прочие потери (Списание+инвентаризация)

     ELSEIF vbMemberId > 0
     THEN
         -- такие для Физ Лицо
         WITH tmpMember AS (SELECT lfSelect.UnitId
                            FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                            WHERE lfSelect.Ord = 1
                              AND lfSelect.MemberId = vbMemberId
                           )
         SELECT lfSelect.ProfitLossGroupId
              , lfSelect.ProfitLossDirectionId
                INTO vbProfitLossGroupId, vbProfitLossDirectionId
         FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect
         WHERE lfSelect.UnitId = (SELECT tmpMember.UnitId FROM tmpMember);


     ELSE
         -- такие для Автомобиля/Сотрудника/Подразделения (не филиал)
         vbProfitLossGroupId := zc_Enum_ProfitLossGroup_20000(); -- Общепроизводственные расходы
         IF vbMemberId = 0
         THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- Прочие потери (Списание+инвентаризация)
         ELSE
         --
         IF vbOperDate < '01.07.2015' -- !!!временно для последнего раза!!!
            OR inMovementId = 2184096 -- Кротон хранение - 31.07.2015
         THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- Прочие потери (Списание+инвентаризация)
         --
         IF vbOperDate <= '01.06.2014' -- !!!временно для первого раза!!!
         THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- Прочие потери (Списание+инвентаризация)
         ELSE IF vbOperDate <= '01.04.2015' -- !!!временно для первого раза!!!
              THEN vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20100(); -- Содержание производства
              ELSE vbProfitLossDirectionId := zc_Enum_ProfitLossDirection_20500(); -- Прочие потери (Списание+инвентаризация)
         END IF;
         END IF;
         END IF;
         END IF;
     END IF;


     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCountCount, OperSumm
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , UnitId_Item, StorageId_Item, UnitId_Partion, Price_Partion
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId

                            , COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, MovementItem.ObjectId, 0) AS GoodsId
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                    AND vbIsPartionGoodsKind_Unit = TRUE
                                    AND _tmpList_Goods_1942.GoodsId IS NULL
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

                                   ELSE 0
                              END AS GoodsKindId

                            , CASE WHEN _tmpList_Goods_1942.GoodsId IS NULL
                                        THEN COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis())
                                   ELSE 0
                              END AS GoodsKindId_complete

                            , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                            , COALESCE (MILinkObject_Unit.ObjectId, 0) AS UnitId_Item
                            , COALESCE (MILinkObject_Storage.ObjectId, 0) AS StorageId_Item
                            , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
                            , COALESCE (MILinkObject_PartionGoods.ObjectId, 0) AS PartionGoodsId

                            , COALESCE (MIFloat_ContainerId.ValueData, 0) AS ContainerId

                            , MovementItem.Amount                   AS OperCount
                            , COALESCE (MIFloat_Count.ValueData, 0) AS OperCountCount

                            , CASE WHEN vbOperDate = '30.06.2015' AND MovementItem.Amount <> 0 THEN CAST (COALESCE (MIFloat_Summ.ValueData, 0) / MovementItem.Amount AS NUMERIC (16, 4)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END AS Price_Partion
                            , COALESCE (MIFloat_Summ.ValueData, 0) AS OperSumm

                              -- Управленческие назначения
                           , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                                  ELSE COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0)
                             END AS InfoMoneyDestinationId
                              -- Статьи назначения
                           , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyId, 0)
                                  ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                             END AS InfoMoneyId

                             -- Бизнес из Товара нужен только если не <Вид топлива>
                           , CASE WHEN Object.DescId = zc_Object_Fuel() THEN 0
                                  ELSE COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0)
                             END AS BusinessId

                           , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                           , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

                       FROM Movement
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                            LEFT JOIN _tmpGoods_Complete_Inventory ON _tmpGoods_Complete_Inventory.GoodsId = MovementItem.ObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                                 ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                                AND vbCarId <> 0
                            LEFT JOIN Object ON Object.Id = COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, MovementItem.ObjectId)

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                                 ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                             AND Object.DescId              <> zc_Object_Fuel()
                            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Fuel ON View_InfoMoney_Fuel.InfoMoneyId = zc_Enum_InfoMoney_20401()
                                                                                  AND Object.DescId                   = zc_Object_Fuel()

                            LEFT JOIN _tmpList_Goods_1942 ON _tmpList_Goods_1942.GoodsId = MovementItem.ObjectId

                            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Count.DescId         = zc_MIFloat_Count()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
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
                                                            AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                                        , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                                        , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                                         )
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                        AND View_InfoMoney.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                                        , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                                        , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                                         )
                            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                      AND (View_InfoMoney.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                                       , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                                       , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                                       )
                                                    -- OR COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                                                           )

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                                    ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                                   AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                                    ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                                   AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                       WHERE Movement.Id = inMovementId
                         AND Movement.DescId = zc_Movement_Inventory()
                         AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                         AND (_tmpGoods_Complete_Inventory.GoodsId > 0 OR vbIsGoodsGroup = FALSE)
                      )
           , tmpContainer_all AS (SELECT tmpMI.MovementItemId
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.MovementItemId ORDER BY Container.Amount DESC) AS Ord -- !!!Надо отловить ПОСЛЕДНИЙ!!!
                                         -- !!!пустая партия!!!
                                       , CASE WHEN CLO_PartionGoods.ObjectId = 0 THEN -1 ELSE CLO_PartionGoods.ObjectId END AS PartionGoodsId
                                  FROM tmpMI
                                       INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                           AND Container.DescId   = zc_Container_Count()
                                                           AND Container.Amount   > 0
                                       LEFT JOIN ContainerLinkObject AS CLO_Member
                                                                     ON CLO_Member.ContainerId = Container.Id
                                                                    AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                       LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                     ON CLO_Unit.ContainerId = Container.Id
                                                                    AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                       INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                      ON CLO_PartionGoods.ContainerId = Container.Id
                                                                     AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                                     -- AND CLO_PartionGoods.ObjectId    = 0
                                  WHERE tmpMI.PartionGoodsDate = zc_DateEnd()
                                    AND tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                       , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                       , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                        )
                                    AND tmpMI.PartionGoodsId = 0
                                    AND ((CLO_Unit.ObjectId   = vbUnitId   AND vbUnitId    > 0)
                                      OR (CLO_Member.ObjectId = vbMemberId AND vbMemberId  > 0)
                                        )
                                 )
        SELECT (_tmp.MovementItemId) AS MovementItemId

             , (_tmp.ContainerId) AS ContainerId_Goods -- !!!
             , _tmp.GoodsId
             , _tmp.GoodsKindId
             , CASE WHEN _tmp.GoodsKindId <> zc_GoodsKind_WorkProgress() THEN NULL ELSE _tmp.GoodsKindId_complete END AS GoodsKindId_complete
             , _tmp.AssetId
             , _tmp.PartionGoods
             , _tmp.PartionGoodsDate

             , (_tmp.OperCount)
             , (_tmp.OperCountCount)
             , (_tmp.OperSumm)

               -- Управленческие назначения
             , _tmp.InfoMoneyDestinationId
               -- Статьи назначения
             , _tmp.InfoMoneyId

               -- значение Бизнес !!!выбирается!!! из 1)Автомобиля или 2)Товара или 3)Сотрудника/Подраделения
             , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId ELSE _tmp.BusinessId END AS BusinessId

             , _tmp.UnitId_Item
             , _tmp.StorageId_Item
               -- !!!временно для первого раза!!!
             , CASE WHEN vbMemberId <> 0 THEN vbMemberId ELSE 0 END AS UnitId_Partion
             , (_tmp.Price_Partion)

             , _tmp.isPartionCount
             , _tmp.isPartionSumm
               -- Партии товара, сформируем позже, ИЛИ !!!ЕСТЬ остаток с пустой партией!!!
             , COALESCE (tmpContainer_all.PartionGoodsId, _tmp.PartionGoodsId) AS PartionGoodsId
        FROM tmpMI AS _tmp
             LEFT JOIN tmpContainer_all ON tmpContainer_all.MovementItemId = _tmp.MovementItemId
                                       AND tmpContainer_all.Ord            = 1 -- на всякий случай - № п/п
              ;


     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = CASE --
                                               WHEN _tmpItem.PartionGoodsId = -1
                                                   THEN 0
                                               WHEN _tmpItem.PartionGoodsId > 0
                                                   THEN _tmpItem.PartionGoodsId

                                               WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               -- Упаковка Мяса (тоже ПФ-ГП)
                                               WHEN vbIsPartionDate_Unit      = TRUE
                                                AND vbIsPartionGoodsKind_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- Основное сырье + Мясное сырье
                                                AND NOT EXISTS (SELECT 1 FROM _tmpList_Goods_1942 WHERE _tmpList_Goods_1942.GoodsId = _tmpItem.GoodsId)
                                                    THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate
                                                                                         , inGoodsKindId_complete := CASE WHEN _tmpItem.GoodsKindId_complete = zc_GoodsKind_Basis() THEN  0 ELSE _tmpItem.GoodsKindId_complete END
                                                                                          )
                                               -- Производство ПФ-ГП
                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                      , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                      , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                    THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate
                                                                                         , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                          )
                                               WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Общефирменные + Ирна
                                                                                      , zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                      , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                    THEN 0

                                               WHEN --(_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                    --AND vbUnitId > 0) OR
                                                    _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Partion ELSE NULL END
                                                                                        , inGoodsId       := CASE WHEN vbMemberId <> 0 THEN _tmpItem.GoodsId ELSE NULL END
                                                                                        , inStorageId     := CASE WHEN vbMemberId <> 0 THEN _tmpItem.StorageId_Item ELSE NULL END
                                                                                        , inInvNumber     := CASE WHEN vbMemberId <> 0 THEN _tmpItem.PartionGoods ELSE NULL END
                                                                                        , inOperDate      := CASE WHEN vbMemberId <> 0 THEN CASE WHEN _tmpItem.PartionGoodsDate IN (zc_DateStart(), zc_DateEnd()) THEN vbOperDate ELSE COALESCE (_tmpItem.PartionGoodsDate, vbOperDate) END ELSE NULL END
                                                                                        , inPrice         := CASE WHEN vbMemberId <> 0 THEN _tmpItem.Price_Partion ELSE NULL END
                                                                                         )
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE /*_tmpItem.ContainerId_Goods = 0 -- !!!
    AND*/ (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
      --OR (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
      --   AND vbUnitId > 0)
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
          )
     ;

     -- еще раз, т.к. в прерыдущем когда-то выкинули zc_Enum_InfoMoneyDestination_20100, теперь криво для vbMemberId
     UPDATE _tmpItem SET PartionGoodsId = 0
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
       AND vbMemberId > 0
       AND _tmpItem.PartionGoodsId = -1;

     -- определили
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbMemberId <> 0 THEN vbMemberId WHEN vbCarId <> 0 THEN vbCarId END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/*
     UPDATE _tmpItem SET ContainerId_Goods = 0
     FROM Container
          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                        ON ContainerLinkObject_GoodsKind.ContainerId = Container.Id
                                       AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_PartionGoods
                                        ON ContainerLinkObject_PartionGoods.ContainerId = Container.Id
                                       AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_AssetTo
                                        ON ContainerLinkObject_AssetTo.ContainerId = Container.Id
                                       AND ContainerLinkObject_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
          LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                        ON ContainerLinkObject_Unit.ContainerId = Container.Id
                                       AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
     WHERE Container.Id = _tmpItem.ContainerId_Goods
       AND (Container.ObjectId <> _tmpItem.GoodsId
         OR COALESCE (ContainerLinkObject_GoodsKind.ObjectId, 0)    <> _tmpItem.GoodsKindId
         OR COALESCE (ContainerLinkObject_PartionGoods.ObjectId, 0) <> _tmpItem.PartionGoodsId
         OR COALESCE (ContainerLinkObject_AssetTo.ObjectId, 0)      <> _tmpItem.AssetId
         OR COALESCE (ContainerLinkObject_Unit.ObjectId, 0)         <> CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
           );
*/
     --
     UPDATE _tmpItem SET ContainerId_Goods = 0 WHERE OperCount <> 0;

     -- определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := CASE WHEN vbOperDate = '31.10.2015' THEN '01.11.2015' WHEN vbOperDate = '31.12.2015' THEN '01.01.2016' ELSE vbOperDate END -- !!!только для филиалов 1 раз!!!
                                                                                , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
     WHERE _tmpItem.ContainerId_Goods = 0;
     -- определяется ContainerId_count для количественного учета батонов
     UPDATE _tmpItem SET ContainerId_count = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                   , inParentId          := _tmpItem.ContainerId_Goods
                                                                   , inObjectId          := _tmpItem.GoodsId
                                                                   , inJuridicalId_basis := NULL
                                                                   , inBusinessId        := NULL
                                                                   , inObjectCostDescId  := NULL
                                                                   , inObjectCostId      := NULL
                                                                    )
     WHERE _tmpItem.OperCountCount <> 0;

     -- заполняем таблицу - количественный расчетный остаток на конец vbOperDate, и пробуем найти MovementItemId (что бы расчетный остаток связать с фактическим), т.к. один и тот же товар может быть введен несколько раз то привязываемся к MAX (_tmpItem.MovementItemId)
     INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, ContainerId_count, GoodsId, InfoMoneyGroupId, InfoMoneyDestinationId, OperCount, OperCountCount, OperCount_find, OperCountCount_find)
        WITH tmpContainerList AS (SELECT Container.*
                                  FROM (SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId = vbUnitId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit() AND vbUnitId <> 0
                                       UNION
                                        SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId = vbMemberId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Member() AND vbMemberId <> 0
                                       UNION
                                        SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId = vbCarId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Car() AND vbCarId <> 0
                                       ) AS tmpContainerLinkObject_From
                                       -- !!!обязательно JOIN, что б "учавствовали" только товарные операции!!!
                                       JOIN Container ON Container.Id = tmpContainerLinkObject_From.ContainerId
                                                     AND Container.DescId = zc_Container_Count()
                                       LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                     ON CLO_Account.ContainerId = Container.Id
                                                                    AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                       /*LEFT JOIN ContainerLinkObject AS CLO_AssetTo
                                                                     ON CLO_AssetTo.ContainerId = Container.Id
                                                                    AND CLO_AssetTo.DescId      = zc_ContainerLinkObject_AssetTo()*/
                                       LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                     ON CLO_PartionGoods.ContainerId = Container.Id
                                                                    AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                       LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId

                                       LEFT JOIN _tmpGoods_Complete_Inventory ON _tmpGoods_Complete_Inventory.GoodsId = Container.ObjectId

                                  WHERE CLO_Account.ContainerId IS NULL                  -- !!!т.е. без счета Транзит!!!
                                    AND COALESCE (Object_PartionGoods.ObjectCode, 0) = 0 -- !!!т.е. без ОС!!!
                                    AND (_tmpGoods_Complete_Inventory.GoodsId > 0 OR vbIsGoodsGroup = FALSE)
                                 )
     , tmpContainerList_count AS (SELECT Container.*
                                  FROM tmpContainerList
                                       JOIN Container ON Container.ParentId = tmpContainerList.Id
                                                     AND Container.DescId   = zc_Container_CountCount()
                                 )
         , tmpContainer_count AS (SELECT tmpContainerList.ParentId AS ContainerId_Goods
                                       , tmpContainerList.Id       AS ContainerId_count
                                       , tmpContainerList.ObjectId AS GoodsId
                                       , tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperCount
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN (vbOperDate + INTERVAL '1 DAY') AND (DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                                        THEN ABS (MIContainer.Amount)
                                                   ELSE 0
                                              END) AS OperCount_find -- здесь только движение до конца месяца
                                  FROM tmpContainerList_count AS tmpContainerList
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = tmpContainerList.Id
                                                                      AND MIContainer.OperDate > vbOperDate
                                  GROUP BY tmpContainerList.ParentId
                                         , tmpContainerList.Id
                                         , tmpContainerList.ObjectId
                                         , tmpContainerList.Amount
                                  HAVING tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate BETWEEN (vbOperDate + INTERVAL '1 DAY') AND (DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                                        THEN ABS (MIContainer.Amount)
                                                   ELSE 0
                                              END) <> 0
                                 )
           -- список, т.к. нужны батоны
       --, tmpList_count AS (SELECT DISTINCT tmpContainer_count.ContainerId_Goods FROM tmpContainer_count)
                 -- Остаток, кол-во
               , tmpContainer AS (SELECT tmpContainerList.Id       AS ContainerId_Goods
                                       , tmpContainerList.ObjectId AS GoodsId
                                       , tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperCount
                                       , SUM (CASE WHEN MIContainer.OperDate BETWEEN (vbOperDate + INTERVAL '1 DAY') AND (DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                                        THEN ABS (MIContainer.Amount)
                                                   ELSE 0
                                              END) AS OperCount_find -- здесь только движение до конца месяца
                                  FROM tmpContainerList
                                     --LEFT JOIN tmpList_count ON tmpList_count.ContainerId_Goods = tmpContainerList.Id
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = tmpContainerList.Id
                                                                      AND MIContainer.OperDate > vbOperDate
                                  GROUP BY tmpContainerList.Id
                                         , tmpContainerList.ObjectId
                                         , tmpContainerList.Amount
                                  HAVING tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                      OR SUM (CASE WHEN MIContainer.OperDate BETWEEN (vbOperDate + INTERVAL '1 DAY') AND (DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                                        THEN ABS (MIContainer.Amount)
                                                   ELSE 0
                                              END) <> 0
                                    --OR SUM (CASE WHEN tmpList_count.ContainerId_Goods > 0 THEN 1 ELSE 0 END) <> 0
                                 )
        -- Результат
        SELECT COALESCE (tmpMI_find.MovementItemId, 0)            AS MovementItemId
             , tmpContainer.ContainerId_Goods                     AS ContainerId_Goods
             , COALESCE (tmpContainer_count.ContainerId_count, 0) AS ContainerId_count
             , tmpContainer.GoodsId                               AS GoodsId
             , COALESCE (ObjectLink_InfoMoneyGroup.ChildObjectId, 0)
             , COALESCE (ObjectLink_InfoMoneyDestination.ChildObjectId, 0)

             , tmpContainer.OperCount                             AS OperCount
             , COALESCE (tmpContainer_count.OperCount, 0)         AS OperCountCount
             , tmpContainer.OperCount_find                        AS OperCount_find
             , COALESCE (tmpContainer_count.OperCount_find, 0)    AS OperCountCount_find
        FROM tmpContainer
             LEFT JOIN (SELECT tmpContainer_count.ContainerId_Goods, tmpContainer_count.GoodsId, MIN (tmpContainer_count.ContainerId_count) AS ContainerId_count, SUM (tmpContainer_count.OperCount) AS OperCount, SUM (tmpContainer_count.OperCount_find) AS OperCount_find FROM tmpContainer_count GROUP BY tmpContainer_count.ContainerId_Goods, tmpContainer_count.GoodsId
                       ) AS tmpContainer_count ON tmpContainer_count.ContainerId_Goods = tmpContainer.ContainerId_Goods
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.ContainerId_Goods FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods
                       ) AS tmpMI_find ON tmpMI_find.ContainerId_Goods = tmpContainer.ContainerId_Goods
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = tmpContainer.GoodsId AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyGroup ON ObjectLink_InfoMoneyGroup.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId AND ObjectLink_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination ON ObjectLink_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()

       UNION ALL
        SELECT COALESCE (tmpMI_find.MovementItemId, 0)            AS MovementItemId
             , tmpContainer_count.ContainerId_Goods               AS ContainerId_Goods
             , COALESCE (tmpContainer_count.ContainerId_count, 0) AS ContainerId_count
             , tmpContainer_count.GoodsId                         AS GoodsId
             , COALESCE (ObjectLink_InfoMoneyGroup.ChildObjectId, 0)
             , COALESCE (ObjectLink_InfoMoneyDestination.ChildObjectId, 0)

             , 0                                                  AS OperCount
             , COALESCE (tmpContainer_count.OperCount, 0)         AS OperCountCount
             , 0                                             AS OperCount_find
             , COALESCE (tmpContainer_count.OperCount_find, 0)    AS OperCountCount_find
        FROM (SELECT tmpContainer_count.ContainerId_Goods, tmpContainer_count.GoodsId, MIN (tmpContainer_count.ContainerId_count) AS ContainerId_count, SUM (tmpContainer_count.OperCount) AS OperCount, SUM (tmpContainer_count.OperCount_find) AS OperCount_find FROM tmpContainer_count GROUP BY tmpContainer_count.ContainerId_Goods, tmpContainer_count.GoodsId
             ) AS tmpContainer_count
             LEFT JOIN tmpContainer ON tmpContainer.ContainerId_Goods = tmpContainer_count.ContainerId_Goods
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.ContainerId_Goods FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods
                       ) AS tmpMI_find ON tmpMI_find.ContainerId_Goods = tmpContainer_count.ContainerId_Goods
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = tmpContainer_count.GoodsId AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyGroup ON ObjectLink_InfoMoneyGroup.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId AND ObjectLink_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination ON ObjectLink_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
        WHERE tmpContainer.ContainerId_Goods IS NULL
     ;


     -- заполняем таблицу - суммовой расчетный остаток на конец vbOperDate (ContainerId_Goods - значит в разрезе товарных остатков)
     INSERT INTO _tmpRemainsSumm (ContainerId_Goods, ContainerId, AccountId, GoodsId, InfoMoneyGroupId, InfoMoneyDestinationId, OperSumm, InfoMoneyId, InfoMoneyId_Detail)
        WITH tmpAccount AS (SELECT View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId NOT IN (zc_Enum_AccountGroup_10000(), zc_Enum_AccountGroup_110000()) -- !!!т.е. без счета Необоротные активы + Транзит!!!
                           )
           , tmpContainerList AS (SELECT Container.*
                                  FROM (SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId = vbUnitId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit() AND vbUnitId <> 0
                                       UNION
                                        SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId = vbMemberId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Member() AND vbMemberId <> 0
                                       UNION
                                        SELECT ContainerLinkObject.ContainerId FROM ContainerLinkObject WHERE ContainerLinkObject.ObjectId = vbCarId AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Car() AND vbCarId <> 0
                                       ) AS tmpContainerLinkObject_From
                                       -- !!!обязательно JOIN and ParentId, что б "учавствовали" только товарные операции!!!
                                       JOIN Container ON Container.Id = tmpContainerLinkObject_From.ContainerId
                                                     AND Container.DescId = zc_Container_Summ()
                                                     AND Container.ParentId IS NOT NULL
                                       JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                                       INNER JOIN ContainerLinkObject AS CLO_Goods
                                                                      ON CLO_Goods.ContainerId = Container.Id
                                                                     AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                       LEFT JOIN _tmpGoods_Complete_Inventory ON _tmpGoods_Complete_Inventory.GoodsId = CLO_Goods.ObjectId
                                  WHERE (_tmpGoods_Complete_Inventory.GoodsId > 0 OR vbIsGoodsGroup = FALSE)
                                 )
               , tmpContainer AS (SELECT tmpContainerList.Id        AS ContainerId
                                       , tmpContainerList.ObjectId  AS AccountId
                                       , tmpContainerList.ParentId  AS ContainerId_Goods
                                       , tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS OperSumm
                                       -- , tmpContainerList.InfoMoneyId
                                       -- , tmpContainerList.InfoMoneyId_Detail
                                  FROM tmpContainerList
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = tmpContainerList.Id
                                                                      AND MIContainer.OperDate > vbOperDate
                                  GROUP BY tmpContainerList.Id
                                         , tmpContainerList.ObjectId
                                         , tmpContainerList.ParentId
                                         , tmpContainerList.Amount
                                         -- , tmpContainerList.InfoMoneyId
                                         -- , tmpContainerList.InfoMoneyId_Detail
                                  HAVING (tmpContainerList.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                                 )
        SELECT tmpContainer.ContainerId_Goods
             , tmpContainer.ContainerId
             , tmpContainer.AccountId
             , Container_Count.ObjectId
             , COALESCE (ObjectLink_InfoMoneyGroup.ChildObjectId, 0)
             , COALESCE (ObjectLink_InfoMoneyDestination.ChildObjectId, 0)
             , tmpContainer.OperSumm
             , COALESCE (ContainerLinkObject_InfoMoney.ObjectId, 0)       AS InfoMoneyId
             , COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) AS InfoMoneyId_Detail
        FROM tmpContainer
             LEFT JOIN Container AS Container_Count ON Container_Count.Id = tmpContainer.ContainerId_Goods
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney ON ObjectLink_Goods_InfoMoney.ObjectId = Container_Count.ObjectId AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyGroup ON ObjectLink_InfoMoneyGroup.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId AND ObjectLink_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
             LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination ON ObjectLink_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                           ON ContainerLinkObject_InfoMoney.ContainerId = tmpContainer.ContainerId
                                          AND ContainerLinkObject_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
             LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                           ON ContainerLinkObject_InfoMoneyDetail.ContainerId = tmpContainer.ContainerId
                                          AND ContainerLinkObject_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
       ;

     -- добавляем из суммовой расчетный остаток в количественный расчетный остаток те товары которых нет, и пробуем найти MovementItemId (что бы расчетный остаток связать с фактическим)
     INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, ContainerId_count, GoodsId, InfoMoneyGroupId, InfoMoneyDestinationId, OperCount, OperCountCount, OperCount_find, OperCountCount_find)
        SELECT COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId
             , _tmpRemainsSumm.ContainerId_Goods
             , 0 AS ContainerId_count
             , _tmpRemainsSumm.GoodsId
             , _tmpRemainsSumm.InfoMoneyGroupId
             , _tmpRemainsSumm.InfoMoneyDestinationId
             , 0 AS OperCount
             , 0 AS OperCountCount
             , 0 AS OperCount_find
             , 0 AS OperCountCount_find
        FROM _tmpRemainsSumm
             LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
             LEFT JOIN (SELECT MAX (_tmpItem.MovementItemId) AS MovementItemId, _tmpItem.ContainerId_Goods FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods
                       ) AS tmpMI_find ON tmpMI_find.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
        WHERE _tmpRemainsCount.ContainerId_Goods IS NULL
        GROUP BY tmpMI_find.MovementItemId
               , _tmpRemainsSumm.ContainerId_Goods
               , _tmpRemainsSumm.GoodsId
               , _tmpRemainsSumm.InfoMoneyGroupId
               , _tmpRemainsSumm.InfoMoneyDestinationId
                ;

     -- Проверка
     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Admin  =  <%> <%> ', vbIsGoodsGroup
                        , (select _tmpRemainsCount.OperCount from _tmpRemainsCount  where _tmpRemainsCount.GoodsId = 2318)
                         ;
     END IF;


     -- формируем новые элементы документа (MovementItem) для тех товаров, по которым есть расчетный остаток но они не введены в документ (ContainerId_Goods=0, значит по переучету остаток = 0 и они не вводились)
     UPDATE _tmpRemainsCount SET MovementItemId = lpInsertUpdate_MovementItem (ioId         := 0
                                                                             , inDescId     := zc_MI_Master()
                                                                             , inObjectId   := _tmpRemainsCount.GoodsId
                                                                             , inMovementId := inMovementId
                                                                             , inAmount     := 0
                                                                             , inParentId   := NULL
                                                                              )
     WHERE _tmpRemainsCount.MovementItemId = 0;

     -- !!!Проверка!!!
     IF vbUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND EXISTS (SELECT tmp.ContainerId
                    FROM (SELECT MovementItemFloat.ValueData AS ContainerId
                          FROM MovementItem
                               INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                           AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                                           AND MovementItemFloat.ValueData <> 0
                          WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.isErased = FALSE
                          GROUP BY MovementItemFloat.ValueData
                          HAVING COUNT (*) > 1
                         ) AS tmp
                         JOIN
                         (SELECT DISTINCT MovementItemFloat.ValueData AS ContainerId
                          FROM MovementItem
                               INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                           AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                                           AND MovementItemFloat.ValueData <> 0
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.isErased = FALSE
                            AND MovementItem.Amount = 0
                         ) AS tmp_find on  tmp_find.ContainerId = tmp.ContainerId
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Дублирование элементов.Обратитесь к разработчику.<%>', (SELECT tmp.ContainerId :: Integer
                                                                                         FROM (SELECT MovementItemFloat.ValueData AS ContainerId
                                                                                               FROM MovementItem
                                                                                                    INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                                                                                AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                                                                                                                AND MovementItemFloat.ValueData <> 0
                                                                                               WHERE MovementItem.MovementId = inMovementId
                                                                                                 AND MovementItem.isErased = FALSE
                                                                                               GROUP BY MovementItemFloat.ValueData
                                                                                               HAVING COUNT (*) > 1
                                                                                              ) AS tmp
                                                                                             JOIN
                                                                                             (SELECT DISTINCT MovementItemFloat.ValueData AS ContainerId
                                                                                              FROM MovementItem
                                                                                                   INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                                                                                               AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                                                                                                               AND MovementItemFloat.ValueData <> 0
                                                                                              WHERE MovementItem.MovementId = inMovementId
                                                                                                AND MovementItem.isErased = FALSE
                                                                                                AND MovementItem.Amount = 0
                                                                                             ) AS tmp_find on  tmp_find.ContainerId = tmp.ContainerId
                                                                                         LIMIT 1
                                                                                        );
     END IF;

     -- добавляем в список для проводок те товары, которые только что были добавлены в строчную часть (MovementItem), причем !!!без!!! аналитик для суммовых проводок (т.к. они не нужны)
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_count, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCountCount, OperSumm
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , UnitId_Item, StorageId_Item, UnitId_Partion, Price_Partion
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT _tmpRemainsCount.MovementItemId
             , _tmpRemainsCount.ContainerId_Goods
             , _tmpRemainsCount.ContainerId_count
             , _tmpRemainsCount.GoodsId
             , ContainerLinkObject_GoodsKind.ObjectId AS GoodsKindId
             , 0 AS GoodsKindId_complete
             , ContainerLinkObject_AssetTo.ObjectId AS AssetId
             , '' AS PartionGoods
             , zc_DateEnd() AS PartionGoodsDate
             , 0 AS OperCount
             , 0 AS OperCountCount
             , 0 AS OperSumm
               -- Управленческие назначения
             , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                    ELSE COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0)
               END AS InfoMoneyDestinationId
               -- Статьи назначения
             , CASE WHEN Object.DescId = zc_Object_Fuel() THEN COALESCE (View_InfoMoney_Fuel.InfoMoneyId, 0)
                    ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
               END AS InfoMoneyId
             , 0 AS BusinessId
             , 0 AS UnitId_Item, 0 AS StorageId_Item, 0 AS UnitId_Partion, 0 AS Price_Partion
             , FALSE AS isPartionCount -- эти параметры здесь уже не важны, т.к. уже есть ContainerId_Goods
             , FALSE AS isPartionSumm  -- эти параметры здесь уже не важны, т.к. уже есть ContainerId_Goods
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

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                  ON ObjectLink_Goods_Fuel.ObjectId = _tmpRemainsCount.GoodsId
                                 AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                 AND vbCarId <> 0
             LEFT JOIN Object ON Object.Id = COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, _tmpRemainsCount.GoodsId)

             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_Fuel ON View_InfoMoney_Fuel.InfoMoneyId = zc_Enum_InfoMoney_20401()
                                                                   AND Object.DescId = zc_Object_Fuel()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = _tmpRemainsCount.GoodsId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                 AND Object.DescId <> zc_Object_Fuel()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

        WHERE _tmpItem.ContainerId_Goods IS NULL;

     -- Проверка
     IF 1 = 1 AND EXISTS (SELECT 1 FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1)
        AND (vbPriceListId > 0 -- OR vbUnitId IN (8458 -- Склад База ГП
                               --               , 8459 -- Склад Реализации
                               --                )
            )
     THEN
          RAISE EXCEPTION 'Ошибка.Остаток для партии товара <%> <%> <%> <%> не уникален.<%>', lfGet_Object_ValueData ((SELECT GoodsId FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , lfGet_Object_ValueData ((SELECT GoodsKindId FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , lfGet_Object_ValueData ((SELECT GoodsKindId_complete FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , lfGet_Object_ValueData ((SELECT PartionGoodsId FROM _tmpItem WHERE ContainerId_Goods = (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1) LIMIT 1))
                                                                                           , (SELECT ContainerId_Goods FROM _tmpItem GROUP BY ContainerId_Goods HAVING COUNT(*) > 1 ORDER BY 1 LIMIT 1)
                                                                                            ;
     END IF;

     -- формируются Проводки для количественного учета !!!только!!! если есть разница по остатку
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , _tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)
            , vbOperDate
            , TRUE
       FROM _tmpItem
            LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.MovementItemId = _tmpItem.MovementItemId
       WHERE (_tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)) <> 0

      UNION ALL
       SELECT 0, zc_MIContainer_CountCount() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_count
            , 0                                       AS AccountId              -- нет счета
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , _tmpItem.OperCountCount - COALESCE (_tmpRemainsCount.OperCountCount, 0)
            , vbOperDate
            , TRUE
       FROM _tmpItem
            LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.MovementItemId = _tmpItem.MovementItemId
       WHERE (_tmpItem.OperCountCount - COALESCE (_tmpRemainsCount.OperCountCount, 0)) <> 0;


-- if vbUserId = 5 -- OR inUserId = 5 OR inMovementId = 691308
-- then
--    RAISE EXCEPTION 'Ошибка.<%>'
--     , (select _tmpRemainsCount.OperCountCount from _tmpRemainsCount where _tmpRemainsCount.ContainerId_count = 3050116)
--    ;
     -- INSERT INTO _tmpRemainsCount (MovementItemId, ContainerId_Goods, ContainerId_count, GoodsId, InfoMoneyGroupId, InfoMoneyDestinationId, OperCount, OperCountCount, OperCount_find, OperCountCount_find)
-- end if;

     -- 3. Start
      -- таблица -  Цены из прайса
      CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
         INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
             SELECT lfSelect.GoodsId     AS GoodsId
                  , lfSelect.GoodsKindId AS GoodsKindId
                  , lfSelect.ValuePrice  AS ValuePrice
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate + INTERVAL '1 DAY') AS lfSelect;

     -- 3.1. заполняем таблицу - суммовые элементы документа, !!!без!!! свойств для формирования Аналитик в проводках (если ContainerId=0 тогда возьмем их из _tmpItem)
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss, ContainerId, AccountId, OperSumm)
        WITH tmp_all AS
       (SELECT _tmp.MovementItemId
             , _tmp.ContainerId
             , _tmp.AccountId
             , SUM (_tmp.OperSumm) AS OperSumm
        FROM  -- 1.0. для филиала
             (SELECT _tmpItem.MovementItemId
                   , COALESCE (Container_Summ.Id, 0)       AS ContainerId
                   , COALESCE (Container_Summ.ObjectId, 0) AS AccountId
                   , CAST ((_tmpItem.OperCount - COALESCE (_tmpRemainsCount.OperCount, 0)) * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) AS OperSumm
              FROM _tmpItem
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpItem.ContainerId_Goods
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                   INNER JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                         AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
              WHERE vbPriceListId   <> 0 -- !!!
                AND vbIsLastOnMonth = FALSE
             UNION ALL
              -- 1.1. это введенные остатки - их добавим
              SELECT _tmpItem.MovementItemId
                   , CASE WHEN vbPriceListId <> 0 AND View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                           AND COALESCE (ContainerLinkObject_InfoMoney.ObjectId, 0)       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           AND COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                               THEN 0 -- !!!всегда выравниваем филиал на один InfoMoneyId_Detail = _tmpItem.InfoMoneyId!!!
                          ELSE COALESCE (Container_Summ.Id, 0)
                     END AS ContainerId
                   , CASE WHEN vbPriceListId <> 0 AND View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                           AND COALESCE (ContainerLinkObject_InfoMoney.ObjectId, 0)       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           AND COALESCE (ContainerLinkObject_InfoMoneyDetail.ObjectId, 0) <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                               THEN 0 -- !!!всегда выравниваем филиал на один InfoMoneyId_Detail = _tmpItem.InfoMoneyId!!!
                          ELSE COALESCE (Container_Summ.ObjectId, 0)
                     END AS AccountId

                   , CASE WHEN -- !!!только в 1-ый раз выставили остатки по этим филиалам - по прайсу!!!
                               (vbOperDate IN ('31.10.2015') AND vbUnitId IN (8413   -- Склад ГП ф.Кривой Рог
                                                                            , 8417   -- Склад ГП ф.Николаев (Херсон)
                                                                            , 8425   -- Склад ГП ф.Харьков
                                                                            , 8415   -- Склад ГП ф.Черкассы (Кировоград)
                                                                             )
                               )
                            OR (vbOperDate IN ('31.12.2015') AND vbUnitId IN (8411)  -- Склад ГП ф.Киев
                               )
                               THEN CAST (_tmpItem.OperCount * COALESCE (lfSelect_PriceListItem.ValuePrice, 0) * 1.2 AS NUMERIC (16,4)) -- это введенные остатки по прайсу !!!плюс НДС!!!

                          WHEN vbOperDate IN ('30.06.2015') AND vbPriceListId = 0
                               THEN _tmpItem.OperSumm -- !!!в первый раз, преход с Integer!!!
                          WHEN inMovementId = 2184096 -- Кротон хранение - 31.07.2015
                               THEN _tmpItem.OperSumm -- !!!тоже в первый раз, преход с Integer!!!

                          -- WHEN vbPriceListId <> 0 AND View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                          --      THEN 0 -- !!!этот счет по филиалам всегда выравниваем в 0!!!

                          -- сумма остатка - по цене с/с
                          ELSE CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                          -- сумма остатка - сумма с/с на дату
                          -- ELSE COALESCE (_tmpRemainsSumm.OperSumm, 0)

                     END AS OperSumm

              FROM _tmpItem
                   LEFT JOIN tmpPriceList AS lfSelect_PriceListItem ON lfSelect_PriceListItem.GoodsId = _tmpItem.GoodsId
                                                                   AND vbOperDate IN ('31.10.2015', '31.12.2015') -- в 1-ый раз для филиалов
                                                                   AND vbPriceListId <> 0
                                                                   AND lfSelect_PriceListItem.GoodsKindId IS NULL -- тогда еще не было учета по видам товара

                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND (vbOperDate >= '01.07.2015' OR vbPriceListId <> 0)
                                                        AND inMovementId <> 2184096 -- Кротон хранение - 31.07.2015
                                                        AND (vbUnitId NOT IN (8413   -- Склад ГП ф.Кривой Рог
                                                                            , 8417   -- Склад ГП ф.Николаев (Херсон)
                                                                            , 8425   -- Склад ГП ф.Харьков
                                                                            , 8415   -- Склад ГП ф.Черкассы (Кировоград)
                                                                             )
                                                          OR vbOperDate <> '31.10.2015'
                                                            )
                                                        AND (vbUnitId NOT IN (8411)  -- Склад ГП ф.Киев
                                                          OR vbOperDate <> '31.12.2015'
                                                            )
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                    LEFT JOIN _tmpRemainsSumm ON _tmpRemainsSumm.ContainerId = Container_Summ.Id

                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                 ON ContainerLinkObject_InfoMoney.ContainerId = Container_Summ.Id
                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                AND vbPriceListId > 0
                   LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                                 ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                                AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                                                AND vbPriceListId > 0
              WHERE (vbPriceListId   = 0 -- !!!
                  OR vbIsLastOnMonth = TRUE)

             /*UNION ALL
              -- 1.1. это введенные остатки
              SELECT _tmpItem.MovementItemId
                     -- !!!всегда выравниваем филиал на один InfoMoneyId_Detail = _tmpItem.InfoMoneyId!!!
                   , 0 AS ContainerId
                   , 0 AS AccountId

                   , -- сумма остатка - по цене с/с
                     CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     -- сумма остатка - сумма с/с на дату
                    -1 * COALESCE (_tmpRemainsSumm.OperSumm, 0)
                     AS OperSumm

              FROM _tmpItem
                   LEFT JOIN _tmpRemainsSumm ON _tmpRemainsSumm.ContainerId_Goods = _tmpItem.ContainerId_Goods
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = _tmpRemainsSumm.ContainerId
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = _tmpRemainsSumm.AccountId

              WHERE vbPriceListId > 0
                AND (_tmpRemainsSumm.InfoMoneyId        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                  OR _tmpRemainsSumm.InfoMoneyId_Detail = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                    )
                AND View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                */
             UNION ALL
              -- 1.2.1. это расчетные остатки (их надо вычесть) - !!!для "наши"!!!
              SELECT _tmpRemainsCount.MovementItemId
                   , COALESCE (Container_Summ.Id, 0) AS ContainerId
                   , COALESCE (Container_Summ.ObjectId, 0) AS AccountId
                   , CASE WHEN vbPriceListId = 0 OR View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                           OR _tmpRemainsSumm.InfoMoneyId        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           OR _tmpRemainsSumm.InfoMoneyId_Detail = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                               -- сумма остатка - по цене с/с
                               THEN -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
--                               THEN -1 * COALESCE (_tmpRemainsSumm.OperSumm, 0)
                          ELSE -- сумма остатка - сумма с/с на дату
                               -1 * COALESCE (_tmpRemainsSumm.OperSumm, 0)
--                               -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     END AS OperSumm

              FROM _tmpRemainsCount
                   INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpRemainsCount.ContainerId_Goods
                                                         AND Container_Summ.DescId   = zc_Container_Summ()
                   LEFT JOIN _tmpRemainsSumm ON _tmpRemainsSumm.ContainerId = Container_Summ.Id
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE vbPriceListId = 0
                 AND inMovementId <> 2184096 -- Кротон хранение - 31.07.2015
                 AND (_tmpRemainsCount.ContainerId_Goods IN (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem WHERE _tmpItem.OperCount <> 0)
                   OR _tmpRemainsCount.OperCount_find <> 0
                   OR vbIsLastOnMonth = FALSE
                     )

             UNION ALL
              -- 1.2.2. это расчетные остатки (их надо вычесть) -- !!!для "наши если кол=0 в "последний" день" + "филиалы" за дату перехода!!!!
               SELECT _tmpRemainsCount.MovementItemId
                   , _tmpRemainsSumm.ContainerId
                   , _tmpRemainsSumm.AccountId
                   , -1 * _tmpRemainsSumm.OperSumm AS OperSumm
              FROM _tmpRemainsSumm
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
                   LEFT JOIN (SELECT _tmpItem.ContainerId_Goods, SUM (_tmpItem.OperCount) AS OperCount FROM _tmpItem GROUP BY _tmpItem.ContainerId_Goods
                             ) AS _tmpItem ON _tmpItem.ContainerId_Goods = _tmpRemainsCount.ContainerId_Goods

              WHERE vbIsLastOnMonth = TRUE
                AND COALESCE (_tmpItem.OperCount, 0) = 0 AND COALESCE (_tmpRemainsCount.OperCount_find, 0) = 0
                AND (_tmpRemainsSumm.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000(), zc_Enum_InfoMoneyGroup_30000()) -- Основное сырье + Доходы
                  OR _tmpRemainsSumm.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20600(), zc_Enum_InfoMoneyDestination_20700(), zc_Enum_InfoMoneyDestination_20800(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_21300()) -- Прочие материалы + Товары + Ирна + Чапли + Дворкин + Незавершенное производство
                  OR _tmpRemainsSumm.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300(), zc_Enum_InfoMoneyDestination_20400(), zc_Enum_InfoMoneyDestination_20500()) -- ...........
                    )
                AND (vbPriceListId   = 0 -- !!!
                  OR vbIsLastOnMonth = TRUE)

             UNION ALL
              -- это расчетные остатки (их надо вычесть) - !!!для "филиалы"!!!!
              SELECT _tmpRemainsCount.MovementItemId
                   , COALESCE (Container_Summ.Id, 0) AS ContainerId
                   , COALESCE (Container_Summ.ObjectId, 0) AS AccountId
                     -- сумма остатка - по цене с/с
                   -- , CASE WHEN View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                   --             THEN -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                   --        ELSE -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                   --   END AS OperSumm


                   , CASE WHEN vbPriceListId = 0 OR View_Account.AccountDirectionId = zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                           OR _tmpRemainsSumm.InfoMoneyId        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           OR _tmpRemainsSumm.InfoMoneyId_Detail = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                               -- сумма остатка - по цене с/с
--                               THEN -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                               THEN -1 * COALESCE (_tmpRemainsSumm.OperSumm, 0)

                          ELSE -- сумма остатка - сумма с/с на дату
                               -1 * COALESCE (_tmpRemainsSumm.OperSumm, 0)
--                               -1 * CAST (_tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     END AS OperSumm

              FROM _tmpRemainsCount
                   INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpRemainsCount.ContainerId_Goods
                                                         AND Container_Summ.DescId = zc_Container_Summ()
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN _tmpRemainsSumm ON _tmpRemainsSumm.ContainerId = Container_Summ.Id
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId

              WHERE (_tmpRemainsCount.ContainerId_Goods IN (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem WHERE _tmpItem.OperCount <> 0)
                     OR vbIsLastOnMonth = FALSE
                     OR _tmpRemainsCount.OperCount_find <> 0
                    )
                AND vbPriceListId   > 0    -- !!!
                AND vbIsLastOnMonth = TRUE -- !!!

               /*AND (vbUnitId IN (301309 -- Склад ГП ф.Запорожье
                               , 309599 -- Склад возвратов ф.Запорожье

                               , 346093 -- Склад ГП ф.Одесса
                               , 346094 -- Склад возвратов ф.Одесса
                                )
                 OR (vbUnitId IN (8413   -- Склад ГП ф.Кривой Рог
                                , 428366 -- Склад возвратов ф.Кривой Рог

                                , 8417   -- Склад ГП ф.Николаев (Херсон)
                                , 428364 -- Склад возвратов ф.Николаев (Херсон)

                                , 8425   -- Склад ГП ф.Харьков
                                , 409007 -- Склад возвратов ф.Харьков

                                , 8415   -- Склад ГП ф.Черкассы (Кировоград)
                                , 428363 -- Склад возвратов ф.Черкассы (Кировоград)
                                 )
                     AND vbOperDate > '31.10.2015'
                    )
                 OR (vbUnitId IN (8411   -- Склад ГП ф.Киев
                                , 428365 -- Склад возвратов ф.Киев
                                 )
                     AND vbOperDate > '31.12.2015'
                    )
                 OR (vbBranchId NOT IN (zc_Branch_Basis(), 0, 8109544) -- Ирна
                     AND vbOperDate > '31.12.2017'
                    )
                   )*/
             ) AS _tmp
        WHERE  zc_isHistoryCost() = TRUE
        GROUP BY _tmp.MovementItemId
               , _tmp.ContainerId
               , _tmp.AccountId
       )
        SELECT tmp_all.MovementItemId
             , 0 AS ContainerId_ProfitLoss
             , tmp_all.ContainerId
             , tmp_all.AccountId
             , tmp_all.OperSumm - COALESCE (HistoryCost.Summ_diff, 0) AS OperSumm -- !!!если есть "погрешность" при округлении, добавили сумму!!!
        FROM tmp_all
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId         = tmp_all.ContainerId
                                  AND HistoryCost.MovementItemId_diff = tmp_all.MovementItemId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
       ;

/*/
if vbUserId = 5
then
    RAISE EXCEPTION '<%> %  %  %', vbIsLastOnMonth
 , (select sum (_tmpItemSumm.OperSumm) from _tmpItemSumm  JOIN _tmpItem ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId and _tmpItem.GoodsId =  2066 )
 , (select _tmpRemainsCount.OperCount_find from _tmpRemainsCount where _tmpRemainsCount.GoodsId =  2066 )
 , (select _tmpItem.OperCount from _tmpItem where _tmpItem.GoodsId =  2066 )
-- , (select _tmpItemSumm.OperSumm from _tmpItemSumm where _tmpItemSumm.ContainerId = 2261046)
-- , (select _tmpRemainsSumm.InfoMoneyId_Detail from _tmpRemainsSumm where _tmpRemainsSumm.ContainerId = 695905)
-- , zc_Enum_InfoMoney_80401() -- (select _tmpItemSumm.OperSumm from _tmpItemSumm where _tmpItemSumm.ContainerId = 0 and _tmpItemSumm.MovementItemId = 121243281)
;
end if;
*/

     -- 3.2. определяется Счет для проводок по суммовому учету
     UPDATE _tmpItemSumm SET AccountId = _tmpItem_byAccount.AccountId
     FROM _tmpItem
          JOIN (SELECT CASE WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- Производственное оборудование
                                                THEN zc_Enum_Account_10201() -- Производственные ОС + Основные средства*****
                                           ELSE zc_Enum_Account_10101() -- Административные ОС + Основные средства*****
                                      END
                            ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                            , inAccountDirectionId     := CASE WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                    THEN zc_Enum_AccountDirection_20900() -- Оборотная тара
                                                                                               WHEN vbMemberId <> 0
                                                                                                AND tmpItem_group.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_20700() -- "Общефирменные"; 20700; "Товары"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_20900() -- "Общефирменные"; 20900; "Ирна"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_21000() -- "Общефирменные"; 21000; "Чапли"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_21100() -- "Общефирменные"; 21100; "Дворкин"
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                                            , zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                                                                             )
                                                                                                    THEN 0 -- !!!всё в сотрудники (МО), а здесь ошибка!!! zc_Enum_AccountDirection_20600() -- "Запасы"; 20600; "сотрудники (экспедиторы)"
                                                                                               ELSE vbAccountDirectionId
                                                                                          END
                                                            , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                            , inInfoMoneyId            := NULL
                                                            , inUserId                 := vbUserId
                                                             )
                       END AS AccountId
                     , tmpItem_group.InfoMoneyDestinationId
                     , tmpItem_group.InfoMoneyId
                FROM (SELECT _tmpItem.InfoMoneyDestinationId
                           , _tmpItem.InfoMoneyId
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство

                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция

                                  WHEN vbAccountDirectionId = zc_Enum_AccountDirection_20300() -- Запасы + на хранении
                                   AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- Общефирменные + услуги полученные
                                       THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье

                                  -- временно
                                  WHEN (vbAccountDirectionId = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- Запасы + на на упаковке AND Основное сырье + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье

                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                           JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItemSumm.OperSumm <> 0
                                            AND _tmpItemSumm.ContainerId = 0
                      GROUP BY _tmpItem.InfoMoneyDestinationId
                             , _tmpItem.InfoMoneyId
                             , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                      OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                      OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                      OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство

                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция

                                    WHEN vbAccountDirectionId = zc_Enum_AccountDirection_20300() -- Запасы + на хранении
                                     AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- Общефирменные + услуги полученные
                                         THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье

                                    -- временно
                                    WHEN (vbAccountDirectionId = zc_Enum_AccountDirection_20800() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()) -- Запасы + на на упаковке AND Основное сырье + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье

                                    ELSE _tmpItem.InfoMoneyDestinationId
                               END
                     ) AS tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyId = _tmpItem.InfoMoneyId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.OperSumm <> 0
       AND _tmpItemSumm.ContainerId = 0;

     -- 3.3. создаем контейнеры для суммового учета + Аналитика <элемент с/с>, причем !!!только!!! когда ContainerId=0 и !!!есть!!! разница по остатку
     UPDATE _tmpItemSumm SET ContainerId = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := CASE WHEN vbOperDate = '31.10.2015' THEN '01.11.2015' WHEN vbOperDate = '31.12.2015' THEN '01.01.2016' ELSE vbOperDate END -- !!!только для филиалов 1 раз!!!
                                                                             , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                             , inCarId                  := vbCarId
                                                                             , inMemberId               := vbMemberId
                                                                             , inBranchId               := vbBranchId
                                                                             , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                             , inBusinessId             := _tmpItem.BusinessId
                                                                             , inAccountId              := _tmpItemSumm.AccountId
                                                                             , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                             , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                             , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId
                                                                             , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                             , inGoodsId                := _tmpItem.GoodsId
                                                                             , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                             , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                             , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                             , inAssetId                := _tmpItem.AssetId
                                                                              )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.OperSumm <> 0
       AND _tmpItemSumm.ContainerId = 0;


     -- 3.4. формируются Проводки для суммового учета !!!только!!! если есть разница по остатку
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId
            , _tmpItemSumm.AccountId                  AS AccountId              -- счет есть всегда
            , 0                                       AS AnalyzerId             -- нет аналитики
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , _tmpItemSumm.OperSumm
            , vbOperDate
            , TRUE
       FROM _tmpItemSumm
            JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
       WHERE _tmpItemSumm.OperSumm <> 0;


     -- 3.5. создаем контейнеры для Проводки - Прибыль !!!только!!! если есть разница по остатку
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss = _tmpItem_byContainer.ContainerId_ProfitLoss
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := _tmpItem_byProfitLoss.JuridicalId_basis
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.ContainerId
           FROM (SELECT CASE WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                              AND vbOperDate < '01.06.2014' -- !!!временно для первого раза!!!
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- Производственное оборудование
                                                     -- !!!временно для первого раза!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- Амортизация + Производственные ОС + Основные средства*****
                                                -- !!!временно для первого раза!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- Амортизация + Административные ОС + Основные средства*****
                                      END
                             WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                              AND vbOperDate < '01.04.2015' -- !!!временно для второго раза!!!
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- Производственное оборудование
                                                     -- !!!временно для первого раза!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- Амортизация + Производственные ОС + Основные средства*****
                                                -- !!!временно для первого раза!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- Амортизация + Административные ОС + Основные средства*****
                                      END
                             WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                              AND vbOperDate < '01.07.2015' -- !!!временно для последнего раза!!!
                                 THEN CASE WHEN tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- Производственное оборудование
                                                     -- !!!временно для первого раза!!!
                                                THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- Амортизация + Производственные ОС + Основные средства*****
                                                -- !!!временно для первого раза!!!
                                           ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- Амортизация + Административные ОС + Основные средства*****
                                      END

                             WHEN tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- услуги полученные
                              AND vbOperDate < '01.08.2015' -- !!!временно для последнего раза!!!
                                 THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20502) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + Прочее сырье


                             WHEN(tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                 )
                              AND vbOperDate < '01.06.2014' -- !!!временно для первого раза!!!
                                       -- !!!временно для первого раза!!!
                                  -- THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20509) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + ГСМ
                                       -- !!!временно для второго раза!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20508) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + Прочие ТМЦ

                             WHEN(tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                               OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                 )
                              AND vbOperDate < '01.07.2015' -- !!!временно для последнего раза!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20508) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + Прочие ТМЦ


                             WHEN tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                              AND vbOperDate < '01.06.2014' -- !!!временно для первого раза!!!
                                       -- !!!временно для первого раза!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20504) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + Продукция

                             WHEN vbAccountDirectionId = zc_Enum_AccountDirection_20300() -- Запасы + на хранении
                              AND vbOperDate < '01.06.2014' -- !!!временно для первого раза!!!
                                       -- !!!временно для первого раза!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20502) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + Прочее сырье

                             WHEN tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                              AND vbOperDate >= '01.06.2014' -- !!!временно!!!
                                       -- !!!временно!!!
                                  THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 20504) -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация) + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := CASE WHEN vbUnitId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode IN (32031 -- Склад Возвратов
                                                                                                                                                                                            , 32032 -- Склад Брак
                                                                                                                                                                                            , 32033 -- Склад УТИЛЬ
                                                                                                                                                                                            , 22122 -- Склад возвратов ф.Запорожье
                                                                                                                                                                                            , 8461  -- Склад возвратов ф.Одесса
                                                                                                                                                                                             )
                                                                                                                    )
                                                                                                        AND vbOperDate >= '01.06.2014' -- !!!временно кроме первого раза!!!
                                                                                                        AND tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                        THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLossGroup() AND ObjectCode = 10000) -- Результат основной деятельности
                                                                                                   ELSE vbProfitLossGroupId
                                                                                              END
                                                                , inProfitLossDirectionId  := CASE WHEN vbUnitId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND ObjectCode IN (32031 -- Склад Возвратов
                                                                                                                                                                                            , 32032 -- Склад Брак
                                                                                                                                                                                            , 32033 -- Склад УТИЛЬ
                                                                                                                                                                                            , 22122 -- Склад возвратов ф.Запорожье
                                                                                                                                                                                            , 8461  -- Склад возвратов ф.Одесса
                                                                                                                                                                                             )
                                                                                                                    )
                                                                                                        AND vbOperDate >= '01.06.2014' -- !!!временно кроме первого раза!!!
                                                                                                        AND tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                        THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLossDirection() AND ObjectCode = 10900) -- Результат основной деятельности + Утилизация возвратов

                                                                                                   WHEN (tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                                      OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                                      OR tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                                        )
                                                                                                        AND vbOperDate < '01.04.2015' -- !!!временно для НЕ первого раза!!!
                                                                                                        AND vbProfitLossDirectionId = zc_Enum_ProfitLossDirection_20500() -- Прочие потери (Списание+инвентаризация)
                                                                                                        THEN zc_Enum_ProfitLossDirection_20100() -- Содержание производства

                                                                                                   ELSE vbProfitLossDirectionId
                                                                                              END
                                                                , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId
                      , tmpItem_group.ContainerId
                      , tmpItem_group.InfoMoneyDestinationId
                      , ContainerLinkObject_JuridicalBasis.ObjectId AS JuridicalId_basis
                      , ContainerLinkObject_Business.ObjectId AS BusinessId
                 FROM (SELECT _tmpItemSumm.ContainerId
                            , View_InfoMoney.InfoMoneyDestinationId
                            , View_InfoMoney.InfoMoneyId
                            , CASE WHEN (ContainerLinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                     OR (ContainerLinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                     OR (ContainerLinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                     OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                     OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                     OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                        THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                        THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                   ELSE View_InfoMoney.InfoMoneyDestinationId
                              END AS InfoMoneyDestinationId_calc
                       FROM _tmpItemSumm
                            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_GoodsKind
                                                          ON ContainerLinkObject_GoodsKind.ContainerId = _tmpItemSumm.ContainerId
                                                         AND ContainerLinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                          ON ContainerLinkObject_InfoMoney.ContainerId = _tmpItemSumm.ContainerId
                                                         AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ContainerLinkObject_InfoMoney.ObjectId
                       WHERE _tmpItemSumm.OperSumm <> 0
                      ) AS tmpItem_group
                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                                    ON ContainerLinkObject_JuridicalBasis.ContainerId = tmpItem_group.ContainerId
                                                     AND ContainerLinkObject_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                      LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                                    ON ContainerLinkObject_Business.ContainerId = tmpItem_group.ContainerId
                                                   AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byContainer
     WHERE _tmpItemSumm.ContainerId = _tmpItem_byContainer.ContainerId;

     -- 3.6. формируются Проводки - Прибыль !!!только!!! если есть разница по остатку
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpItem_group.MovementItemId
            , tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- прибыль текущего периода
            , 0                                       AS AnalyzerId             -- !!!нет!!!
            , tmpItem_group.GoodsId                   AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , tmpItem_group.GoodsKindId               AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , -1 * tmpItem_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_ProfitLoss
                  , _tmpItem.GoodsId
                  , _tmpItem.GoodsKindId
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItemSumm.OperSumm <> 0
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS tmpItem_group
       ;
     -- 3. Finish


     -- 4. Start Переоценка
     IF (
        (vbOperDate >= '01.06.2014' AND vbPriceListId <> 0
        AND vbUnitId IN (301309 -- Склад ГП ф.Запорожье
                       , 309599 -- Склад возвратов ф.Запорожье
                       , 346093 -- Склад ГП ф.Одесса
                       , 346094 -- Склад возвратов ф.Одесса
                        )
        )
     OR (vbOperDate > '31.10.2015' AND vbPriceListId <> 0
        AND vbUnitId IN (8413   -- Склад ГП ф.Кривой Рог
                       , 428366 -- Склад возвратов ф.Кривой Рог

                       , 8417   -- Склад ГП ф.Николаев (Херсон)
                       , 428364 -- Склад возвратов ф.Николаев (Херсон)

                       , 8425   -- Склад ГП ф.Харьков
                       , 409007 -- Склад возвратов ф.Харьков

                       , 8415   -- Склад ГП ф.Черкассы (Кировоград)
                       , 428363 -- Склад возвратов ф.Черкассы (Кировоград)
                        )
        )
     OR (vbOperDate > '31.12.2015' AND vbPriceListId <> 0
        AND vbUnitId IN (8411   -- Склад ГП ф.Киев
                       , 428365 -- Склад возвратов ф.Киев
                        )
        )
     OR (vbBranchId NOT IN (zc_Branch_Basis(), 0, 8109544) -- Ирна
         AND vbOperDate > '31.12.2017'
        )
        )
        AND inMovementId NOT IN (18389580)
     THEN

     -- 4.1. заполняем таблицу - суммовые элементы документа, для переоценки
     INSERT INTO _tmpItemSummRePrice (MovementItemId, ContainerId_Active, AccountId_Active, ContainerId_Passive, AccountId_Passive, OperSumm)
        SELECT _tmp.MovementItemId
             , 0 AS ContainerId_Active
             , 0 AS AccountId_Active
             , 0 AS ContainerId_Passive
             , 0 AS AccountId_Passive
             , SUM (_tmp.OperSumm) AS OperSumm
        FROM  -- это введенные остатки по ценам с/с (их надо вычесть)
/*             (SELECT _tmpItem.MovementItemId
                     -- остатки по сумме должны быть загружены один раз, а потом расчитываться из HistoryCost
                   , -1 * _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS OperSumm
              FROM _tmpItem
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND vbOperDate >= '01.06.2014'
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
*/
             (SELECT _tmpItem.MovementItemId
                   -- , CASE WHEN vbOperDate <= '01.06.2014' THEN _tmpItem.OperSumm ELSE _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) END AS OperSumm
                   , -1 * CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                     AS OperSumm
              FROM _tmpItem
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpItem.ContainerId_Goods
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND (vbOperDate >= '01.07.2015' OR vbPriceListId <> 0)
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
             /*UNION ALL
              -- это расчетные остатки (их надо вычесть) - !!!для филиала!!!
              SELECT _tmpRemainsCount.MovementItemId
                   , -1 * CAST (-1 * _tmpRemainsCount.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) AS OperSumm
              FROM _tmpRemainsCount
                   LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpRemainsCount.ContainerId_Goods
                                                        AND Container_Summ.DescId = zc_Container_Summ()
                                                        AND vbOperDate >= '01.06.2014'
                   LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                        AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = Container_Summ.ObjectId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
             UNION ALL
              -- это расчетные остатки (их надо вычесть) -- !!!для "наших" подр!!!!
               SELECT _tmpRemainsCount.MovementItemId
                   , -1 * _tmpRemainsSumm.OperSumm AS OperSumm
              FROM _tmpRemainsSumm
                   LEFT JOIN _tmpRemainsCount ON _tmpRemainsCount.ContainerId_Goods = _tmpRemainsSumm.ContainerId_Goods
                   LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = _tmpRemainsSumm.AccountId
              WHERE View_Account.AccountDirectionId <> zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах*/
            UNION ALL
              -- это введенные остатки по прайсу !!!плюс НДС!!!
              SELECT _tmpItem.MovementItemId
                   , CAST (_tmpItem.OperCount * COALESCE (lfSelect_PriceListItem_kind.ValuePrice, lfSelect_PriceListItem.ValuePrice, 0) * 1.2 AS NUMERIC (16,4)) AS OperSumm
              FROM _tmpItem
                   -- привязываем цены 2 раза по виду и без
                   LEFT JOIN tmpPriceList AS lfSelect_PriceListItem_kind
                                          ON lfSelect_PriceListItem_kind.GoodsId                   = _tmpItem.GoodsId
                                         AND COALESCE (lfSelect_PriceListItem_kind.GoodsKindId, 0) = COALESCE (_tmpItem.GoodsKindId, 0)
                   LEFT JOIN tmpPriceList AS lfSelect_PriceListItem
                                          ON lfSelect_PriceListItem.GoodsId     = _tmpItem.GoodsId
                                         AND lfSelect_PriceListItem.GoodsKindId IS NULL
              WHERE _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
             ) AS _tmp
        GROUP BY _tmp.MovementItemId;


     DELETE FROM _tmpItemSummRePrice WHERE MovementItemId IN (SELECT MovementItemId FROM _tmpItem WHERE InfoMoneyId = 0);

     -- 4.2. определяется Счет для проводок по суммовому учету
     UPDATE _tmpItemSummRePrice	 SET AccountId_Active = _tmpItem_byAccount.AccountId_Active, AccountId_Passive = _tmpItem_byAccount.AccountId_Passive
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                                  , inAccountDirectionId     := vbAccountDirectionId
                                                  , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := vbUserId
                                                   ) AS AccountId_Active
                     , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов
                                                  , inAccountDirectionId     := zc_Enum_AccountDirection_60200() -- Прибыль будущих периодов + на филиалах
                                                  , inInfoMoneyDestinationId := tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := vbUserId
                                                   ) AS AccountId_Passive
                     , tmpItem_group.InfoMoneyId
                FROM (SELECT _tmpItem.InfoMoneyDestinationId
                           , _tmpItem.InfoMoneyId
                           , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                           JOIN _tmpItemSummRePrice ON _tmpItemSummRePrice.MovementItemId = _tmpItem.MovementItemId
                                                   AND _tmpItemSummRePrice.OperSumm <> 0
                      GROUP BY _tmpItem.InfoMoneyDestinationId
                             , _tmpItem.InfoMoneyId
                     ) AS tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyId = _tmpItem.InfoMoneyId
     WHERE _tmpItemSummRePrice.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSummRePrice.OperSumm <> 0
    ;

     -- 4.3. создаем контейнеры для суммового учета + Аналитика <элемент с/с>, причем !!!только!!! когда ContainerId=0 и !!!есть!!! разница по остатку
     UPDATE _tmpItemSummRePrice SET ContainerId_Active =
                                           lpInsertUpdate_ContainerSumm_Goods (inOperDate               := CASE WHEN vbOperDate = '31.10.2015' THEN '01.11.2015' WHEN vbOperDate = '31.12.2015' THEN '01.01.2016' ELSE vbOperDate END -- !!!только для филиалов 1 раз!!!
                                                                             , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                             , inCarId                  := vbCarId
                                                                             , inMemberId               := vbMemberId
                                                                             , inBranchId               := vbBranchId
                                                                             , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                             , inBusinessId             := _tmpItem.BusinessId
                                                                             , inAccountId              := _tmpItemSummRePrice.AccountId_Active
                                                                             , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                             , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                             , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401()
                                                                             , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                             , inGoodsId                := _tmpItem.GoodsId
                                                                             , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                             , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                             , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                             , inAssetId                := _tmpItem.AssetId
                                                                              )
                                  , ContainerId_Passive =
                                           lpInsertUpdate_ContainerSumm_Goods (inOperDate               := CASE WHEN vbOperDate = '31.10.2015' THEN '01.11.2015' WHEN vbOperDate = '31.12.2015' THEN '01.01.2016' ELSE vbOperDate END -- !!!только для филиалов 1 раз!!!
                                                                             , inUnitId                 := CASE WHEN vbMemberId <> 0 THEN _tmpItem.UnitId_Item ELSE vbUnitId END
                                                                             , inCarId                  := vbCarId
                                                                             , inMemberId               := vbMemberId
                                                                             , inBranchId               := vbBranchId
                                                                             , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                             , inBusinessId             := _tmpItem.BusinessId
                                                                             , inAccountId              := _tmpItemSummRePrice.AccountId_Passive
                                                                             , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                             , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                             , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401()
                                                                             , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                             , inGoodsId                := _tmpItem.GoodsId
                                                                             , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                             , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                             , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                             , inAssetId                := _tmpItem.AssetId
                                                                              )
     FROM _tmpItem
     WHERE _tmpItemSummRePrice.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSummRePrice.OperSumm <> 0
    ;


     -- 4.4. формируются Проводки для суммового учета !!!только!!! если есть разница
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSummRePrice.MovementItemId
            , CASE WHEN tmp.myNumber = 1 THEN _tmpItemSummRePrice.ContainerId_Active ELSE _tmpItemSummRePrice.ContainerId_Passive END AS ContainerId
            , CASE WHEN tmp.myNumber = 1 THEN _tmpItemSummRePrice.AccountId_Active   ELSE _tmpItemSummRePrice.AccountId_Passive   END AS AccountId    -- счет есть всегда
            , zc_Enum_AccountGroup_60000()            AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , CASE WHEN tmp.myNumber = 1 THEN _tmpItemSummRePrice.OperSumm ELSE -1 * _tmpItemSummRePrice.OperSumm END AS OperSumm
            , vbOperDate
            , CASE WHEN (tmp.myNumber = 1 AND _tmpItemSummRePrice.OperSumm > 0) OR (tmp.myNumber = 2 AND _tmpItemSummRePrice.OperSumm < 0) THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT 1 AS myNumber UNION ALL SELECT 2 AS myNumber) AS tmp
            INNER JOIN _tmpItemSummRePrice ON _tmpItemSummRePrice.OperSumm <> 0
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSummRePrice.MovementItemId
    ;

     -- 4.5. формируются Проводки для отчета (Аналитики: счет Запасы и счет Прибыль будущих периодов)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpItemSummRePrice.OperSumm) AS OperSumm
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.ContainerId_Active  WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.ContainerId_Passive END AS ActiveContainerId
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.ContainerId_Passive WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.ContainerId_Active  END AS PassiveContainerId
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.AccountId_Active    WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.AccountId_Passive   END AS ActiveAccountId
                , CASE WHEN _tmpItemSummRePrice.OperSumm > 0 THEN _tmpItemSummRePrice.AccountId_Passive   WHEN _tmpItemSummRePrice.OperSumm < 0 THEN _tmpItemSummRePrice.AccountId_Active    END AS PassiveAccountId
                , _tmpItemSummRePrice.MovementItemId
           FROM _tmpItemSummRePrice
           WHERE _tmpItemSummRePrice.OperSumm <> 0
           ) AS _tmpItem_byProfitLoss
    ;

     END IF; -- заполняем таблицу - суммовые элементы документа, для переоценки

     -- 4. Finish - Переоценка


     -- формируются Проводки для отчета (Аналитики: Товар и ОПиУ)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpItemSumm.OperSumm) AS OperSumm
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN _tmpItemSumm.ContainerId            WHEN _tmpItemSumm.OperSumm < 0 THEN _tmpItemSumm.ContainerId_ProfitLoss END AS ActiveContainerId
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN _tmpItemSumm.ContainerId_ProfitLoss WHEN _tmpItemSumm.OperSumm < 0 THEN _tmpItemSumm.ContainerId            END AS PassiveContainerId
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN _tmpItemSumm.AccountId              WHEN _tmpItemSumm.OperSumm < 0 THEN zc_Enum_Account_100301 ()           END AS ActiveAccountId  -- 100301; "прибыль текущего периода"
                , CASE WHEN _tmpItemSumm.OperSumm > 0 THEN zc_Enum_Account_100301 ()           WHEN _tmpItemSumm.OperSumm < 0 THEN _tmpItemSumm.AccountId              END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpItemSumm.MovementItemId
           FROM _tmpItemSumm
           WHERE _tmpItemSumm.OperSumm <> 0
           ) AS _tmpItem_byProfitLoss;



     -- !!!формируется свойство <ContainerId>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), _tmpItem.MovementItemId, _tmpItem.ContainerId_Goods)
     FROM _tmpItem;

     -- !!!формируется свойство <Price>!!!
     IF vbPriceListId <> 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), _tmpItem.MovementItemId, COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0))
         FROM _tmpItem
                   -- привязываем цены 2 раза по виду и без
              LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                     ON tmpPriceList_kind.GoodsId                   = _tmpItem.GoodsId
                                    AND COALESCE (tmpPriceList_kind.GoodsKindId, 0) = COALESCE (_tmpItem.GoodsKindId, 0)
              LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId     = _tmpItem.GoodsId
                                    AND tmpPriceList.GoodsKindId IS NULL
         ;
     END IF;

     -- !!!формируется свойство <Цена>!!!
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), _tmpItem.PartionGoodsId, Price_Partion)
     FROM _tmpItem
     WHERE _tmpItem.PartionGoodsId > 0
        AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                              , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                              , zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                               );



     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := vbUserId
                                 );
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.12.19         *
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 13.10.13                                        * add vbCarId
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 16.09.13                                        * add zc_Enum_InfoMoneyDestination_20500
 14.09.13                                        * add zc_ObjectLink_Goods_Business
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 01.09.13                                        * change isActive
 26.08.13                                        * add zc_InfoMoneyDestination_WorkProgress
 23.08.13                                        *
*/
/*
UPDATE MovementItem SET isErased = TRUE
from Movement
WHERE Movement.Id = MovementId
  AND Movement.OperDate BETWEEN '01.12.2015' AND '31.12.2015'
  AND Movement.DescId = zc_Movement_Inventory()
  AND Movement.StatusId = zc_Enum_Status_Complete()
  AND isErased = FALSE
  AND MovementItem.Amount = 0
  AND Movement.Id = 1902144
*/
/*
with tmp1 as (select MovementItemId, sum(amount) as amount from MovementItemContainer where MovementId = 11295799 and DescId = 2 and AccountId <> zc_Enum_Account_100301 () group by MovementItemId)
, tmp2 as (select MovementItemId, sum(amount) as amount from tmpMIContainer_test where MovementId = 11295799 and DescId = 2 and AccountId <> zc_Enum_Account_100301 ()  group by MovementItemId)
, res as (select coalesce (tmp1.MovementItemId, tmp2.MovementItemId) as MovementItemId, coalesce (tmp1.amount, 0) as t1 , coalesce (tmp2.amount, 0) as t2 --, *
         from tmp1 full join tmp2 on tmp1.MovementItemId = tmp2.MovementItemId
         where coalesce (tmp1.amount, 0) <>  coalesce (tmp2.amount, 0))

select * from res
left join MovementItem on MovementItem .Id = MovementItemId
left join Object as Object1 on Object1.Id = MovementItem.ObjectId
LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
left join Object as Object2 on Object2.Id = MILinkObject_GoodsKind.ObjectId

 where Object1.ObjectCode = 198
-- where res.MovementItemId = 123394051
order by abs (t1 - t2) desc
--  select sum (t1), sum (t2) from res

update Container set Amount = AmountCalc
from
  (select Container.Id, Container.Amount , coalesce (sum (coalesce (MovementItemContainer.Amount, 0)), 0) as AmountCalc
   from Container
        left join  MovementItemContainer on MovementItemContainer.ContainerId = Container.Id
   group by Container.Id, Container.Amount
   having Container.Amount <> coalesce (sum (coalesce (MovementItemContainer.Amount, 0)), 0)
  ) as tmp
where Container.Id = tmp.Id
*/
-- тест
-- SELECT * FROM gpReComplete_Movement_Inventory (inMovementId:= 10774526, inSession:= '5')
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 29207, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 1902144, inIsLastComplete:= FALSE, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 29207, inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_Inventory (inMovementId:= 14590084, inSession:= '5')

/*
select *
from
(select x1 .containerId , x2 .containerId
, coalesce (amount1, 0) as amount1, coalesce (amount2, 0) as amount2
from (select containerId, sum (Amount) as amount1 from _MIContainer_20_03_2020_test group by containerId) as x1
full join (select containerId, sum (Amount) as amount2  from MovementItemContainer
where MovementId = 15999936
-- and DescId <> zc_MIContainer_CountCount()
group by containerId) as x2
on x1 .containerId = x2 .containerId
) as x11
where amount1 <> amount2
*/