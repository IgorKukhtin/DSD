-- Function: lpComplete_Movement_SendOnPrice_NEW()

DROP FUNCTION IF EXISTS lpComplete_Movement_SendOnPrice_NEW (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendOnPrice_NEW(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbMovementItemId_check Integer;

  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя

  DECLARE vbIsBranch_to Boolean; -- ПРИХОД На ФИЛИАЛ ИЛИ ВОЗВРАТ С ФИЛИАЛА

  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer_From Integer;
  -- DECLARE vbWhereObjectId_Analyzer_To Integer;

  DECLARE vbAccountId_GoodsTransit_01 Integer;
  DECLARE vbAccountId_GoodsTransit_02 Integer;
  DECLARE vbAccountId_GoodsTransit_51 Integer;
  DECLARE vbAccountId_GoodsTransit_52 Integer;
  DECLARE vbAccountId_GoodsTransit_53 Integer;

  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;
  DECLARE vbOperSumm_PartnerVirt_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_PartnerVirt_ChangePercent TFloat;

  DECLARE vbPriceWithVAT_PriceList Boolean;
  DECLARE vbVATPercent_PriceList TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbBranchId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_UnitFrom Boolean;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;

  DECLARE vbBranchId_To Integer;
  DECLARE vbUnitdId_To_find Integer;

  DECLARE vbIsPartionCell_from Boolean;
/*
  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_UnitTo Boolean;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;
*/
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm;
     -- !!!обязательно!!! очистили таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN
          vbIsHistoryCost:= TRUE;
          -- vbIsHistoryCost:= FALSE;
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- Бухгалтер ДНЕПР
           -- OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (540952)) -- Кладовщик Киев
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- Эти параметры нужны для
     SELECT lfObject_PriceList.PriceWithVAT, lfObject_PriceList.VATPercent
            INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList
     FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfObject_PriceList;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END

          , Movement.DescId, Movement.OperDate
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS MemberId_From

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId WHEN Object_From.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BranchId_From
          , COALESCE (ObjectLink_UnitTo_Branch.ChildObjectId, 0) AS BranchId_To

          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- Аналитики счетов - направления !!!обрабатываются только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE) AS isPartionDate_UnitFrom

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Member() THEN zc_Juridical_Basis() ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BusinessId_From

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbMovementDescId, vbOperDate, vbOperDatePartner, vbUnitId_From, vbMemberId_From, vbBranchId_From, vbBranchId_To, vbAccountDirectionId_From, vbIsPartionDate_UnitFrom
               , vbJuridicalId_Basis_From, vbBusinessId_From
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

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
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                               ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Business
                               ON ObjectLink_UnitFrom_Business.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_From.DescId = zc_Object_Unit()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                               ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_SendOnPrice()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- Если учет по ячейкам - РАСХОД - Учет будет для От КОГО
     vbIsPartionCell_from:= lfGet_Object_Unit_isPartionCell (vbOperDate, vbUnitId_From)
                         OR (inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
                         AND vbUnitId_From = zc_Unit_RK()
                         AND vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                            )
                         OR (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                         AND vbUnitId_From = zc_Unit_RK()
                            )
                           ;


     -- !!!обязательно!!! Определили - ПРИХОД На ФИЛИАЛ ИЛИ ВОЗВРАТ С ФИЛИАЛА
     vbIsBranch_to:= CASE WHEN vbBranchId_From = 0                 -- + только если
                            OR vbBranchId_From = zc_Branch_Basis() -- + со склада на филиал
                          THEN TRUE
                          ELSE FALSE
                     END;

     -- !!!обязательно - если в строчной части 1 значение, тогда ТОЛЬКО его!!!
     vbUnitdId_To_find:=(SELECT CASE WHEN tmp.Id_min = tmp.Id_max THEN tmp.Id_max ELSE 0 END
                         FROM (SELECT MIN (CASE WHEN MILinkObject_Unit.ObjectId > 0 THEN MILinkObject_Unit.ObjectId ELSE 0 END) AS Id_min
                                    , MAX (CASE WHEN MILinkObject_Unit.ObjectId > 0 THEN MILinkObject_Unit.ObjectId ELSE 0 END) AS Id_max
                               FROM Movement
                                    JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                                    JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                               AND MILinkObject_Unit.ObjectId       <> vbUnitId_From
                                                               AND MILinkObject_Unit.ObjectId       <> 0
                               WHERE Movement.Id = inMovementId
                              ) AS tmp
                        );


     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, isLossMaterials
                         , MIContainerId_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, ContainerId_GoodsTransit_01, ContainerId_GoodsTransit_02, ContainerId_GoodsTransit_53, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCount_ChangePercent, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_Partner, OperSumm_Partner, OperSumm_Partner_ChangePercent, tmpOperSumm_PartnerVirt, OperSumm_PartnerVirt_ChangePercent
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From, BusinessId_To
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId_From, PartionGoodsId_To
                         , UnitId_To, MemberId_To, BranchId_To, AccountDirectionId_To, IsPartionDate_UnitTo, JuridicalId_Basis_To
                         , WhereObjectId_Analyzer_To, isTo_10900
                         , OperCount_start, OperCount_ChangePercent_start, OperCount_Partner_start
                         , tmpOperSumm_PriceList_start, tmpOperSumm_Partner_start, tmpOperSumm_PartnerVirt_start
                          )

        WITH
        tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice  AS ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate) AS lfSelect  -- по "Дате склад"
                         )
    -- расчет суммы по элементам + их округление до 2-х знаков (скидка - будет расчитана потом)
  , tmpMI AS (SELECT
                    MovementItem.Id AS MovementItemId

                  , MovementItem.ObjectId AS GoodsId
                    -- !!!замена!!!
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())  -- Ирна + Готовая продукция + Мясное сырье
                              THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                              ELSE 0
                    END AS GoodsKindId

                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                  , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 0 END AS CountForPrice
                  , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                  , COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0) AS PriceListPrice

                    -- количество с остатка
                  , MovementItem.Amount AS OperCount
                    -- количество с учетом % скидки
                  , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS OperCount_ChangePercent
                    -- количество у контрагента
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS OperCount_Partner

                    -- ***tmpOperSumm_PriceList_start - промежуточная сумма прайс-листа по Контрагенту - с округлением до 2-х знаков
                  , COALESCE (CAST (MIFloat_AmountPartner.ValueData * COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0) AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList_start

                    -- ***tmpOperSumm_Partner_start - промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                  , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                 ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                    END AS tmpOperSumm_Partner_start

                    -- ***tmpOperSumm_PartnerVirt_start - промежуточная сумма для кол-во с уч. %ск.вес - с округлением до 2-х знаков
                  , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountChangePercent.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                 ELSE COALESCE (CAST (MIFloat_AmountChangePercent.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                    END AS tmpOperSumm_PartnerVirt_start

                    -- Управленческие назначения
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find)) ELSE 0 END, 0) AS UnitId_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find)) ELSE 0 END, 0) AS MemberId_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId WHEN Object_To.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BranchId_To
                  , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_To  -- Аналитики счетов - направления !!!обрабатываются только для подразделения!!!
                  , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE) AS isPartionDate_UnitTo

                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Member() THEN zc_Juridical_Basis() ELSE 0 END, 0) AS JuridicalId_Basis_To
                  , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BusinessId_To
                  , CASE WHEN ObjectLink_UnitTo_HistoryCost.ChildObjectId = Object_To.Id AND COALESCE (ObjectLink_UnitTo_Branch.ChildObjectId, 0) IN (0, zc_Branch_Basis()) THEN TRUE ELSE FALSE END AS isTo_10900

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                   AND MILinkObject_Unit.ObjectId       <> vbUnitId_From
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                               ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

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

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                   --LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate) -- по "Дате склад"
                   --       AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId

                   -- привязываем цены 2 раза по виду и без
                   LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                          ON tmpPriceList_kind.GoodsId                   = MovementItem.ObjectId
                                         AND COALESCE (tmpPriceList_kind.GoodsKindId, 0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                   LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId     = MovementItem.ObjectId
                                         AND tmpPriceList.GoodsKindId IS NULL

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND vbUnitdId_To_find = 0
                   LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find))

                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_HistoryCost
                                        ON ObjectLink_UnitTo_HistoryCost.ObjectId = Object_To.Id
                                       AND ObjectLink_UnitTo_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()

                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                        ON ObjectLink_UnitTo_Branch.ObjectId = COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find))
                                       AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                        ON ObjectLink_UnitTo_AccountDirection.ObjectId = COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find))
                                       AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_To
                                           ON ObjectBoolean_PartionDate_To.ObjectId = COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find))
                                          AND ObjectBoolean_PartionDate_To.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                          AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                                        ON ObjectLink_UnitTo_Juridical.ObjectId = COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find))
                                       AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                       AND Object_To.DescId = zc_Object_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                                        ON ObjectLink_UnitTo_Business.ObjectId = COALESCE (MILinkObject_Unit.ObjectId, COALESCE (MovementLinkObject_To.ObjectId, vbUnitdId_To_find))
                                       AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()
                                       AND Object_To.DescId = zc_Object_Unit()

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_SendOnPrice()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             )

     -- остаток с учетом движения - потом понадобится
     --, tmpContainer_rem AS (...

  -- сначала партии для итого расхода
, tmpMI_summ  AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, SUM (tmpMI.OperCount) AS OperCount
                       , SUM (tmpMI.OperCount_ChangePercent) AS OperCount_ChangePercent
                       , SUM (tmpMI.OperCount_Partner)       AS OperCount_Partner
                       , tmpMI.InfoMoneyDestinationId, tmpMI.InfoMoneyId
                  FROM tmpMI
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                       LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                       ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                  -- учет - партии по датам + ячейки
                  WHERE vbIsPartionCell_from = TRUE
                    AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                 )
                  GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId
                         , tmpMI.InfoMoneyDestinationId, tmpMI.InfoMoneyId
                 )

         -- !!! - 02 - учет для ГП - партии по датам + ячейки
       , tmp_02 AS (SELECT Container.Id                                          AS ContainerId
                         , tmpMI.GoodsId                                         AS GoodsId
                         , tmpMI.GoodsKindId                                     AS GoodsKindId
                         , Container.Amount                                      AS Amount
                         , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                         , CASE WHEN ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()
                                -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                                THEN zc_DateStart()
                                ELSE COALESCE (ObjectDate_Value.ValueData, zc_DateStart())
                           END AS PartionGoodsDate
                    FROM tmpMI_summ AS tmpMI
                         INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                             AND Container.DescId   = zc_Container_Count()
                                             AND Container.Amount   > 0
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                       AND CLO_Unit.ObjectId    = vbUnitId_From
                         -- !!!
                         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                       ON CLO_GoodsKind.ContainerId = Container.Id
                                                      AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                         -- !!!
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                       ON CLO_PartionGoods.ContainerId = Container.Id
                                                      AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                 AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                         -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                         LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId = CLO_PartionGoods.ObjectId
                                                                       AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()

                    -- учет - партии по датам + ячейки
                    WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                         , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                          )
                      AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                      --!!!
                      AND vbIsPartionCell_from = TRUE
                      --!!! не должны попадать партии из следующего периода
                      AND (ObjectDate_Value.ValueData < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                        OR CLO_PartionGoods.ContainerId IS NULL
                          )
                      --!!!не пустая пратия!!!
                      AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)
                   )                      

         -- !!! - 03 - учет для ГП - партии по датам + ячейки
       , tmp_03 AS (SELECT Container.Id                                          AS ContainerId
                         , tmpMI.GoodsId                                         AS GoodsId
                         , tmpMI.GoodsKindId                                     AS GoodsKindId
                         , Container.Amount                                      AS Amount
                         , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                         , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                           -- !!!Надо отловить ОДИН!!!
                         , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY Container.Id) AS Ord
                    FROM tmpMI_summ AS tmpMI
                         -- !!!
                         LEFT JOIN tmp_02 ON tmp_02.GoodsId     = tmpMI.GoodsId
                                         AND tmp_02.GoodsKindId = tmpMI.GoodsKindId

                         INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                             AND Container.DescId   = zc_Container_Count()
                                             AND Container.Amount   <= 0
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                       AND CLO_Unit.ObjectId    = vbUnitId_From
                         -- !!!
                         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                       ON CLO_GoodsKind.ContainerId = Container.Id
                                                      AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                         -- !!!
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                       ON CLO_PartionGoods.ContainerId = Container.Id
                                                      AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                 AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                         -- если zc_PartionCell_RK, НЕ списываем партию здесь вообще
                         LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId      = CLO_PartionGoods.ObjectId
                                                                       AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                                       AND ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()

                    -- учет - партии по датам + ячейки
                    WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                         , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                          )
                      AND COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI.GoodsKindId
                      --!!!
                      AND vbIsPartionCell_from = TRUE
                      --!!!
                      AND tmp_02.GoodsId IS NULL
                      --!!! не должны попадать партии из следующего периода
                      AND (ObjectDate_Value.ValueData < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                        OR CLO_PartionGoods.ContainerId IS NULL
                          )
                      --!!!не пустая партия!!!
                      AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)
                      -- НЕ списываем ЭТУ партию - здесь вообще
                      AND ObjectLink_PartionCell.ObjectId IS NULL
                   )                      
  , tmpContainer_list AS (-- учет для ГП - партии по датам + ячейки
                          SELECT tmp_02.ContainerId
                               , tmp_02.GoodsId
                               , tmp_02.GoodsKindId
                               , tmp_02.Amount
                               , tmp_02.PartionGoodsId
                               , tmp_02.PartionGoodsDate
                          FROM tmp_02

                         UNION ALL
                          -- учет для ГП - партии по датам + ячейки
                          SELECT tmp_03.ContainerId
                               , tmp_03.GoodsId
                               , tmp_03.GoodsKindId
                               , 0.01 AS Amount
                               , tmp_03.PartionGoodsId
                               , tmp_03.PartionGoodsDate
                          FROM tmp_03
                          -- только одна партия с остатком <=0
                          WHERE tmp_03.Ord = 1
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
                            , Container.ContainerId  AS ContainerId
                              -- Кол-во
                            , tmpMI.OperCount  AS Amount
                              -- Остаток + без учета Инвентаризации для ГП
                            , Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) AS Amount_container
                              -- накопительно
                            , SUM (Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0))
                                                     OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                           ORDER BY CASE WHEN Container.Amount > 0 THEN 0 ELSE 1 END
                                                                  , CASE WHEN Container.Amount < 0 THEN 0 ELSE 1 END
                                                                  , COALESCE (Container.PartionGoodsDate, zc_DateStart())
                                                                  , Container.ContainerId
                                                          ) AS AmountSUM
                              -- !!!Надо отловить ПОСЛЕДНИЙ!!!
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                 ORDER BY CASE WHEN Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END
                                                        , CASE WHEN Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END
                                                        , COALESCE (Container.PartionGoodsDate, zc_DateStart()) DESC
                                                        , Container.ContainerId DESC
                                                ) AS Ord
                              -- партия
                            , Container.PartionGoodsId

                       FROM tmpMI_summ AS tmpMI
                            INNER JOIN tmpContainer_list AS Container ON Container.GoodsId = tmpMI.GoodsId
                                                        AND Container.GoodsKindId          = tmpMI.GoodsKindId
                            LEFT JOIN tmpContainer_rem_RK ON tmpContainer_rem_RK.ContainerId = Container.ContainerId
                      )

    , tmpContainer_partion AS (SELECT DD.ContainerId
                                    , DD.GoodsId
                                    , DD.GoodsKindId
                                    , DD.PartionGoodsId
                                    , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1 --!!!- изменилась сортировка НАОБОРОТ!!!
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
     -- получили № п/п, чтоб сформировать накопительные периоды
   , tmpMI_NUMBER AS (SELECT tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.OperCount
                             -- сортировка по MovementItemId
                           , SUM (tmpMI.OperCount) OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.MovementItemId ASC) AS AmountSUM
                             -- последний MovementItemId будет с № п/п = 1
                           , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.MovementItemId DESC) AS Ord
                      FROM tmpMI
                     )
      -- накопительные периоды - MI
    , tmpMI_group AS (SELECT tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.OperCount
                           , tmpMI.AmountSUM
                           , tmpMI.Ord
                            -- с минимального
                           , COALESCE (tmpMI_old.AmountSUM, 0) AS Amount_min
                      FROM tmpMI_NUMBER AS tmpMI
                           LEFT JOIN tmpMI_NUMBER AS tmpMI_old
                                                  ON tmpMI_old.GoodsId     = tmpMI.GoodsId
                                                 AND tmpMI_old.GoodsKindId = tmpMI.GoodsKindId
                                                 AND tmpMI_old.Ord         = tmpMI.Ord + 1
                     )

      -- партии прикрутили к MI
    , tmpContainer_res_1 AS (SELECT tmpMI_group.MovementItemId
                                  , tmpMI_group.GoodsId
                                  , tmpMI_group.GoodsKindId

                                    -- подставили из MI - ERROR
                                --, tmpMI_group.OperCount AS Amount

                                    -- подставили из Container
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
                              -- расчет Кол-во с учетом скидки
                            , CASE WHEN tmpMI.OperCount_ChangePercent = 0
                                        THEN 0
                                   WHEN tmpMI_group.Amount = tmpMI.OperCount
                                        THEN tmpMI.OperCount_ChangePercent

                                   WHEN FLOOR (tmpMI_group.Amount * 1000) = CEIL (tmpMI_group.Amount * 1000)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_ChangePercent AS NUMERIC(16, 3))
                                   WHEN FLOOR (tmpMI_group.Amount * 100) = CEIL (tmpMI_group.Amount * 100)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_ChangePercent AS NUMERIC(16, 2))
                                   WHEN FLOOR (tmpMI_group.Amount * 10) = CEIL (tmpMI_group.Amount * 10)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_ChangePercent AS NUMERIC(16, 1))
                                   WHEN FLOOR (tmpMI_group.Amount * 1) = CEIL (tmpMI_group.Amount * 1)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_ChangePercent AS NUMERIC(16, 0))

                                   ELSE CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_ChangePercent AS NUMERIC(16, 4))
                              END AS OperCount_ChangePercent

                              -- расчет Кол-во у контрагента
                            , CASE WHEN tmpMI.OperCount_Partner = 0
                                        THEN 0
                                   WHEN tmpMI_group.Amount = tmpMI.OperCount
                                        THEN tmpMI.OperCount_Partner

                                   WHEN FLOOR (tmpMI_group.Amount * 1000) = CEIL (tmpMI_group.Amount * 1000)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_Partner AS NUMERIC(16, 3))
                                   WHEN FLOOR (tmpMI_group.Amount * 100) = CEIL (tmpMI_group.Amount * 100)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_Partner AS NUMERIC(16, 2))
                                   WHEN FLOOR (tmpMI_group.Amount * 10) = CEIL (tmpMI_group.Amount * 10)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_Partner AS NUMERIC(16, 1))
                                   WHEN FLOOR (tmpMI_group.Amount * 1) = CEIL (tmpMI_group.Amount * 1)
                                        THEN CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_Partner AS NUMERIC(16, 0))

                                   ELSE CAST (tmpMI_group.Amount * tmpMI.OperCount / tmpMI.OperCount_Partner AS NUMERIC(16, 4))
                              END AS OperCount_Partner
                              --
                            , tmpMI_group.ContainerId
                            , tmpMI_group.PartionGoodsId

                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI_group.MovementItemId ORDER BY tmpMI_group.ContainerId DESC) AS Ord

                              -- № п/п - для корректировки разницы
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI_group.MovementItemId ORDER BY tmpMI_group.Amount DESC) AS Ord_amount

                      FROM tmpContainer_res_2 AS tmpMI_group
                           LEFT JOIN tmpMI ON tmpMI.MovementItemId = tmpMI_group.MovementItemId
                     )

      -- итого надо скорректировать на погрешность
    , tmpContainer_diff AS (SELECT tmpContainer.MovementItemId
                                 , tmpMI.OperCount_ChangePercent - SUM (tmpContainer.OperCount_ChangePercent) AS OperCount_ChangePercent
                                 , tmpMI.OperCount_Partner       - SUM (tmpContainer.OperCount_Partner)       AS OperCount_Partner
                          FROM tmpMI
                               JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMI.MovementItemId
                          GROUP BY tmpContainer.MovementItemId, tmpMI.OperCount_ChangePercent, tmpMI.OperCount_Partner
                          HAVING SUM (tmpContainer.OperCount_ChangePercent) <> tmpMI.OperCount_ChangePercent
                              OR SUM (tmpContainer.OperCount_Partner)       <> tmpMI.OperCount_Partner
                         )

        -- Результат - суммы и скидка
        SELECT
              _tmp.MovementItemId
            , CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20600()   -- 20600; "Прочие материалы"
                     -- OR _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()   -- 10200; "Прочее сырье"
                        THEN TRUE
                   ELSE FALSE
              END AS isLossMaterials
            , 0 AS MIContainerId_To

              -- !!!или подбор партий - ContainerId_Goods !!!
            , _tmp.ContainerId_GoodsFrom
              --
            , 0 AS ContainerId_GoodsTo

            , 0 AS ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
            , 0 AS ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
            , 0 AS ContainerId_GoodsTransit_53 -- Счет - кол-во Транзит
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

              -- количество с остатка - !!!или подбор партий!!!
            , _tmp.OperCount

              -- количество с учетом % скидки
            , _tmp.OperCount_ChangePercent

              -- количество у контрагента
            , _tmp.OperCount_Partner

              -- промежуточная сумма прайс-листа по Контрагенту !!! без скидки !!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_PriceList
              -- конечная сумма прайс-листа по Контрагенту !!! без скидки !!!
            , CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_PriceList
                   WHEN vbVATPercent_PriceList > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList AS NUMERIC (16, 2))
              END AS OperSumm_PriceList

              -- промежуточная сумма по Контрагенту !!! без скидки !!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner
              -- конечная сумма по Контрагенту !!! без скидки !!!
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_Partner
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
              END AS OperSumm_Partner
              -- конечная сумма по Контрагенту
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner_ChangePercent

              -- промежуточная сумма для кол-во с уч. %ск.вес !!! без скидки !!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_PartnerVirt
              -- конечная сумма для кол-во с уч. %ск.вес
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_PartnerVirt
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_PartnerVirt) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_PartnerVirt_ChangePercent

              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , _tmp.BusinessId_From
              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , _tmp.BusinessId_To

            , _tmp.isPartionCount
            , _tmp.isPartionSumm

              -- !!!или подбор партий - PartionGoodsId !!!
            , _tmp.PartionGoodsId_From

              -- Партии товара, сформируем позже
            , _tmp.PartionGoodsId_To

            , _tmp.UnitId_To
            , _tmp.MemberId_To
            , _tmp.BranchId_To
            , _tmp.AccountDirectionId_To  -- Аналитики счетов - направления !!!обрабатываются только для подразделения!!!
            , _tmp.isPartionDate_UnitTo

            , _tmp.JuridicalId_Basis_To
            , _tmp.WhereObjectId_Analyzer_To
            , _tmp.isTo_10900

            , _tmp.OperCount_start
            , _tmp.OperCount_ChangePercent_start
            , _tmp.OperCount_Partner_start

            , _tmp.tmpOperSumm_PriceList_start, _tmp.tmpOperSumm_Partner_start, _tmp.tmpOperSumm_PartnerVirt_start

        FROM (SELECT _tmp.MovementItemId

                     -- !!!или подбор партий - ContainerId_Goods !!!
                   , COALESCE (tmpContainer.ContainerId, 0) AS ContainerId_GoodsFrom
                     --
                   , _tmp.GoodsId
                   , _tmp.GoodsKindId
                   , _tmp.AssetId
                   , _tmp.PartionGoods
                   , _tmp.PartionGoodsDate
       
                     -- количество с остатка - !!!или подбор партий!!!
                   , COALESCE (tmpContainer.Amount, _tmp.OperCount) AS OperCount

                     -- количество с учетом % скидки
                   , CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               THEN COALESCE (tmpContainer.Amount, _tmp.OperCount)
                          ELSE COALESCE (tmpContainer.OperCount_ChangePercent, _tmp.OperCount_ChangePercent) + COALESCE (tmpContainer_diff.OperCount_ChangePercent, 0)
                     END AS OperCount_ChangePercent
       
                     -- количество у контрагента
                   , CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               THEN COALESCE (tmpContainer.Amount, _tmp.OperCount)
                               -- THEN COALESCE (tmpContainer.OperCount_Partner, _tmp.OperCount_Partner) + COALESCE (tmpContainer_diff.OperCount_Partner, 0)
                          ELSE COALESCE (tmpContainer.OperCount_Partner, _tmp.OperCount_Partner) + COALESCE (tmpContainer_diff.OperCount_Partner, 0)
                     END AS OperCount_Partner
       

                     -- 1.1.***tmpOperSumm_PriceList - промежуточная сумма прайс-листа по Контрагенту !!! без скидки !!! - с округлением до 2-х знаков
                   , CAST (CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     THEN COALESCE (tmpContainer.Amount, _tmp.OperCount)
                                     -- THEN COALESCE (tmpContainer.OperCount_Partner, _tmp.OperCount_Partner) + COALESCE (tmpContainer_diff.OperCount_Partner, 0)
                                ELSE COALESCE (tmpContainer.OperCount_Partner, _tmp.OperCount_Partner) + COALESCE (tmpContainer_diff.OperCount_Partner, 0)
                           END
                         * _tmp.PriceListPrice
                           AS NUMERIC (16, 2)) AS tmpOperSumm_PriceList

                     -- 1.2.***tmpOperSumm_Partner - промежуточная сумма по Контрагенту !!! без скидки !!! - с округлением до 2-х знаков
                   , CAST (CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     THEN COALESCE (tmpContainer.Amount, _tmp.OperCount)
                                     -- THEN COALESCE (tmpContainer.OperCount_Partner, _tmp.OperCount_Partner) + COALESCE (tmpContainer_diff.OperCount_Partner, 0)
                                ELSE COALESCE (tmpContainer.OperCount_Partner, _tmp.OperCount_Partner) + COALESCE (tmpContainer_diff.OperCount_Partner, 0)
                           END
                         * _tmp.Price / _tmp.CountForPrice
                           AS NUMERIC (16, 2)) AS tmpOperSumm_Partner

                     -- 1.3.***tmpOperSumm_PartnerVirt - промежуточная сумма для кол-во с уч. %ск.вес !!! без скидки !!! - с округлением до 2-х знаков
                   , CAST (CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     THEN COALESCE (tmpContainer.Amount, _tmp.OperCount)
                                ELSE COALESCE (tmpContainer.OperCount_ChangePercent, _tmp.OperCount_ChangePercent) + COALESCE (tmpContainer_diff.OperCount_ChangePercent, 0)
                           END
                         * _tmp.Price / _tmp.CountForPrice
                           AS NUMERIC (16, 2)) AS tmpOperSumm_PartnerVirt


                     -- Управленческие назначения
                   , _tmp.InfoMoneyDestinationId
                     -- Статьи назначения
                   , _tmp.InfoMoneyId
       
                     -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
                   , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId END AS BusinessId_From
                     -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
                   , CASE WHEN _tmp.BusinessId = 0 THEN _tmp.BusinessId_To ELSE _tmp.BusinessId END AS BusinessId_To
       
                   , _tmp.isPartionCount
                   , _tmp.isPartionSumm
       
                     -- !!!или подбор партий - PartionGoodsId !!!
                   , COALESCE (tmpContainer.PartionGoodsId, 0) AS PartionGoodsId_From
                     -- Партии товара, сформируем позже
                   , 0 AS PartionGoodsId_To
       
                   , _tmp.UnitId_To
                   , _tmp.MemberId_To
                   , _tmp.BranchId_To
                   , _tmp.AccountDirectionId_To  -- Аналитики счетов - направления !!!обрабатываются только для подразделения!!!
                   , _tmp.isPartionDate_UnitTo
       
                   , _tmp.JuridicalId_Basis_To
                   , CASE WHEN _tmp.UnitId_To <> 0 THEN _tmp.UnitId_To WHEN _tmp.MemberId_To <> 0 THEN _tmp.MemberId_To END AS WhereObjectId_Analyzer_To
                   , _tmp.isTo_10900
       
                   , _tmp.OperCount               AS OperCount_start
       
                   , CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               THEN _tmp.OperCount
                          ELSE _tmp.OperCount_ChangePercent
                     END AS OperCount_ChangePercent_start
       
                   , CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                               THEN _tmp.OperCount
                          ELSE _tmp.OperCount_Partner
                     END AS OperCount_Partner_start

                   , _tmp.tmpOperSumm_PriceList_start, _tmp.tmpOperSumm_Partner_start, _tmp.tmpOperSumm_PartnerVirt_start

              FROM tmpMI AS _tmp
                   LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = _tmp.MovementItemId
                   LEFT JOIN tmpContainer_diff ON tmpContainer_diff.MovementItemId = _tmp.MovementItemId
                                              -- только одну позицию корректируем
                                              AND tmpContainer.Ord_amount = 1
             ) AS _tmp
            ;


     -- Проверка - 1 - Подбор партий
     IF vbIsPartionCell_from = TRUE
        AND EXISTS (SELECT 1
                    FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                          FROM _tmpItem
                          WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                  , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                   )
                         ) AS tmpItem
                    GROUP BY tmpItem.GoodsId, tmpItem.GoodsKindId
                    HAVING COUNT(*) > 1
                   )
        AND inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Дублируется товар+вид для подбор партий.%Товар = <%> %Вид = <%> % % № <%> от <%>'
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData (tmpItem.GoodsId)
                          FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                FROM _tmpItem
                                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                         )
                               ) AS tmpItem
                          GROUP BY tmpItem.GoodsId, tmpItem.GoodsKindId
                          HAVING COUNT(*) > 1
                          ORDER BY tmpItem.GoodsId, tmpItem.GoodsKindId
                          LIMIT 1
                         )
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData_sh (tmpItem.GoodsKindId)
                          FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                FROM _tmpItem
                                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                         )
                               ) AS tmpItem
                          GROUP BY tmpItem.GoodsId, tmpItem.GoodsKindId
                          HAVING COUNT(*) > 1
                          ORDER BY tmpItem.GoodsId, tmpItem.GoodsKindId
                          LIMIT 1
                         )
                       , CHR (13)
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- Проверка - 2 - Подбор партий
     IF vbIsPartionCell_from = TRUE
        AND EXISTS (SELECT 1
                    FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                               , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                               , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start
                          FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                FROM _tmpItem
                                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                         )
                                 AND _tmpItem.OperCount <> 0
                               ) AS tmpItem_start
                          GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                         ) AS tmpItem_start
                         FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         , SUM (_tmpItem.OperCount)               AS OperCount
                                         , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                         , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                    FROM _tmpItem
                                    WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                    GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                   ) AS tmpItem
                                     ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                    AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                    WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                       OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                       OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                   )
        AND inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
        --AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Подбор партий.% % № <%> от <%> %Товар = <%> %Вид = <%> %1.1.Кол-во = <%> %1.2.Кол-во по партиям = <%> %2.1.Кол-во со ск. = <%> %2.2.Кол-во со ск. по партиям = <%> %3.1.Кол-во пок. = <%> %3.2.Кол-во пок. по партиям = <%>  %Id = <%>'
                       , CHR (13)
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData (tmpItem_start.GoodsId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- GoodsKindId
                       , (SELECT lfGet_Object_ValueData_sh (tmpItem_start.GoodsKindId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )

                       , CHR (13)
                         -- 1.1. OperCount_start
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount_start)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 1.2. OperCount - calc
                       , (SELECT zfConvert_FloatToString (tmpItem.OperCount)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )

                       , CHR (13)
                         -- 2.1. OperCount_ChangePercent_start
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount_ChangePercent_start)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 2.2. OperCount_ChangePercent - calc
                       , (SELECT zfConvert_FloatToString (tmpItem.OperCount_ChangePercent)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )

                       , CHR (13)
                         -- 3.1. OperCount_Partner_start
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount_Partner_start)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 3.2. OperCount_Partner - calc
                       , (SELECT zfConvert_FloatToString (tmpItem.OperCount_Partner)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )

                       , CHR (13)
                         -- MovementItemId
                       , (SELECT COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                       AND _tmpItem.OperCount <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_GoodsFrom > 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                        ;
     END IF;


     -- !!!проверка!!!
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperCount <> _tmpItem.OperCount_ChangePercent AND vbIsBranch_to = FALSE)
     THEN
         RAISE EXCEPTION 'Ошибка. В приходе с филиала нельзя вводить Скидку в весе для товара <%>', (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId) FROM _tmpItem WHERE _tmpItem.OperCount <>_tmpItem.OperCount_ChangePercent AND vbIsBranch_to = FALSE LIMIT 1);
     END IF;


     -- проверка - цена = 0
     vbMovementItemId_check:= (SELECT MIN (_tmpItem.MovementItemId)
                               FROM _tmpItem
                               WHERE _tmpItem.OperCount_Partner > 0
                                 AND _tmpItem.OperSumm_Partner  = 0
                                 AND _tmpItem.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                           , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                           , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                           , zc_Enum_InfoMoneyDestination_30500() -- Прочие доходы
                                                                            ));
     --
     IF vbMovementItemId_check > 0 AND 1=1 -- AND inUserId = 5
        AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
     THEN
         RAISE EXCEPTION 'Ошибка.%В документе № <%> от <%> цена = 0%<%> <%>.%Проведение невозможно.'
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString (vbOperDate)
                       , CHR (13)
                       , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)        FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId_check)
                       , (SELECT lfGet_Object_ValueData_sh (_tmpItem.GoodsKindId) FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId_check)
                       , CHR (13)
                        ;
     END IF;


     IF inUserId <> zfCalc_UserAdmin() :: Integer OR 1=1 THEN
     -- IF inUserId <> zc_Enum_Process_Auto_PrimeCost() :: Integer THEN
       -- !!!Синхронно - пересчитали/провели Пересортица!!! - на основании "Реализация" - !!!важно - здесь очищается _tmpMIContainer_insert, поэтому делаем ДО проводок!!!, но после заполнения _tmpItem
       PERFORM lpComplete_Movement_Sale_Recalc (inMovementId := inMovementId
                                              , inUnitId     := vbUnitId_From
                                              , inUserId     := inUserId);
     END IF;


     -- Расчеты сумм
     SELECT -- Расчет Итоговой суммы прайс-листа по Контрагенту
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_PriceList
                 WHEN vbVATPercent_PriceList > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList AS NUMERIC (16, 2))
            END AS OperSumm_PriceList


            -- Расчет Итоговой суммы по Контрагенту !!! без скидки !!!
         ,  CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_Partner
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
            END AS OperSumm_Partner


            -- Расчет Итоговой суммы по Контрагенту
         ,  CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Partner_ChangePercent

            -- Расчет Итоговой суммы по Контрагенту - для кол-во с уч. %ск.вес
         ,  CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_PartnerVirt
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                         END
            END AS OperSumm_PartnerVirt_ChangePercent

            INTO vbOperSumm_PriceList, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent, vbOperSumm_PartnerVirt_ChangePercent

     FROM (SELECT SUM (_tmpItem.tmpOperSumm_PriceList)   AS tmpOperSumm_PriceList
                , SUM (_tmpItem.tmpOperSumm_Partner)     AS tmpOperSumm_Partner
                , SUM (_tmpItem.tmpOperSumm_PartnerVirt) AS tmpOperSumm_PartnerVirt
           FROM _tmpItem
          ) AS _tmpItem
     ;

     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent), SUM (_tmpItem.OperSumm_PartnerVirt_ChangePercent) INTO vbOperSumm_PriceList_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem, vbOperSumm_PartnerVirt_ChangePercent_byItem FROM _tmpItem;

     -- если не равны ДВЕ Итоговые суммы прайс-листа по Контрагенту
     IF COALESCE (vbOperSumm_PriceList, 0) <> COALESCE (vbOperSumm_PriceList_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PriceList = _tmpItem.OperSumm_PriceList - (vbOperSumm_PriceList_byItem - vbOperSumm_PriceList)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_PriceList IN (SELECT MAX (_tmpItem.OperSumm_PriceList) FROM _tmpItem)
                                          );
     END IF;


     -- если не равны ДВЕ Итоговые суммы по Контрагенту !!! без скидки !!!
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner IN (SELECT MAX (_tmpItem.OperSumm_Partner) FROM _tmpItem)
                                          );
     END IF;

     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner_ChangePercent, 0) <> COALESCE (vbOperSumm_Partner_ChangePercent_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner_ChangePercent = _tmpItem.OperSumm_Partner_ChangePercent - (vbOperSumm_Partner_ChangePercent_byItem - vbOperSumm_Partner_ChangePercent)
         WHERE _tmpItem.MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem WHERE _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC LIMIT 1);

         --
         IF COALESCE (vbOperSumm_Partner_ChangePercent, 0) <> COALESCE ((SELECT SUM (_tmpItem.OperSumm_Partner_ChangePercent) FROM _tmpItem), 0)
         THEN
             --
             -- RAISE EXCEPTION 'Копейки в vbOperSumm_Partner_ChangePercent (%)'
             --  , (SELECT _tmpItem.MovementItemId FROM _tmpItem WHERE _tmpItem.OperCount <> _tmpItem.OperCount_Partner ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC LIMIT 1);

             -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
             UPDATE _tmpItem SET OperSumm_Partner_ChangePercent = _tmpItem.OperSumm_Partner_ChangePercent - (vbOperSumm_Partner_ChangePercent_byItem - vbOperSumm_Partner_ChangePercent)
             WHERE _tmpItem.MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC LIMIT 1);

         END IF;

     END IF;

     -- если не равны ДВЕ Итоговые суммы для кол-во с уч. %ск.вес
     IF COALESCE (vbOperSumm_PartnerVirt_ChangePercent, 0) <> COALESCE (vbOperSumm_PartnerVirt_ChangePercent_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PartnerVirt_ChangePercent = _tmpItem.OperSumm_PartnerVirt_ChangePercent - (vbOperSumm_PartnerVirt_ChangePercent_byItem - vbOperSumm_PartnerVirt_ChangePercent)
         WHERE _tmpItem.MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem WHERE _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC LIMIT 1);

         --
         IF COALESCE (vbOperSumm_PartnerVirt_ChangePercent, 0) <> COALESCE ((SELECT SUM (_tmpItem.OperSumm_PartnerVirt_ChangePercent) FROM _tmpItem), 0)
         THEN
             --
             -- RAISE EXCEPTION 'Копейки в vbOperSumm_PartnerVirt_ChangePercent (%)'
             --  , (SELECT _tmpItem.MovementItemId FROM _tmpItem WHERE _tmpItem.OperCount <> _tmpItem.OperCount_Partner ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC LIMIT 1);

             -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
             UPDATE _tmpItem SET OperSumm_PartnerVirt_ChangePercent = _tmpItem.OperSumm_PartnerVirt_ChangePercent - (vbOperSumm_PartnerVirt_ChangePercent_byItem - vbOperSumm_PartnerVirt_ChangePercent)
             WHERE _tmpItem.MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC LIMIT 1);

         END IF;

     END IF;

--  RAISE EXCEPTION 'Ошибка.<%>  <%>', (select _tmpItem .PartionGoodsId_From from _tmpItem where _tmpItem.MovementItemId = 287997157)
-- , (select _tmpItem .ContainerId_GoodsFrom from _tmpItem where _tmpItem.MovementItemId = 287997157)
-- ;

     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE WHEN (_tmpItem.PartionGoodsId_From   > 0
                                                      AND _tmpItem.ContainerId_GoodsFrom > 0
                                                         )
                                                        THEN _tmpItem.PartionGoodsId_From

                                                    WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN vbIsPartionDate_UnitFrom = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (PartionGoodsDate)
                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                        THEN NULL
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
                         , PartionGoodsId_To = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND _tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN _tmpItem.IsPartionDate_UnitTo = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)

                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                        THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                             , inGoodsId       := NULL
                                                                                             , inStorageId     := NULL
                                                                                             , inInvNumber     := NULL
                                                                                             , inOperDate      := NULL
                                                                                             , inPrice         := NULL
                                                                                              )
                                                    ELSE lpInsertFind_Object_PartionGoods ('')
                                               END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
      --OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Ирна
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
     ;


     -- определили
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From END;
     -- vbWhereObjectId_Analyzer_To:= CASE WHEN vbUnitId_To <> 0 THEN vbUnitId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;

     -- определили
     vbAccountId_GoodsTransit_01:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND (SELECT MemberId_To FROM _tmpItem WHERE MemberId_To <> 0 LIMIT 1) IS NULL
                                             THEN CASE WHEN vbIsBranch_to = TRUE
                                                            THEN zc_Enum_Account_110121() -- Транзит + товар в пути + расход на филиал
                                                       ELSE zc_Enum_Account_110131() -- Транзит + товар в пути + возврат с филиала
                                                  END
                                        ELSE 0
                                   END;
     IF vbOperDate < zc_DateStart_OperDatePartner()
     THEN vbAccountId_GoodsTransit_02:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND (SELECT MemberId_To FROM _tmpItem WHERE MemberId_To <> 0 LIMIT 1) IS NULL
                                                  THEN CASE WHEN vbIsBranch_to = TRUE
                                                                 THEN zc_Enum_Account_110122() -- Транзит + товар в пути + Разница в весе
                                                            ELSE zc_Enum_Account_110132() -- Транзит + товар в пути + Разница в весе
                                                       END
                                             ELSE 0
                                        END;
     ELSE vbAccountId_GoodsTransit_02:= vbAccountId_GoodsTransit_01;
     END IF;

     -- определили
     vbAccountId_GoodsTransit_51:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND (SELECT MemberId_To FROM _tmpItem WHERE MemberId_To <> 0 LIMIT 1) IS NULL
                                             THEN CASE WHEN vbIsBranch_to = TRUE
                                                            THEN zc_Enum_Account_110171() -- Транзит + прибыль в пути + расход на филиал
                                                       ELSE zc_Enum_Account_110181() -- Транзит + прибыль в пути + возврат с филиала
                                                  END
                                        ELSE 0
                                   END;
     vbAccountId_GoodsTransit_52:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND (SELECT MemberId_To FROM _tmpItem WHERE MemberId_To <> 0 LIMIT 1) IS NULL
                                             THEN CASE WHEN vbIsBranch_to = TRUE
                                                            THEN zc_Enum_Account_110172() -- Транзит + прибыль в пути + расход на филиал Разница в весе
                                                       ELSE zc_Enum_Account_110182() -- Транзит + прибыль в пути + возврат с филиала Разница в весе
                                                  END
                                        ELSE 0
                                   END;
     IF vbOperDate < zc_DateStart_OperDatePartner()
     THEN vbAccountId_GoodsTransit_53:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND (SELECT MemberId_To FROM _tmpItem WHERE MemberId_To <> 0 LIMIT 1) IS NULL
                                                  THEN CASE WHEN vbIsBranch_to = TRUE
                                                                 THEN zc_Enum_Account_110173() -- Транзит + прибыль в пути + расход на филиал Скидка в весе
                                                       END
                                             ELSE 0
                                        END;
     ELSE vbAccountId_GoodsTransit_53:= vbAccountId_GoodsTransit_01;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. определяется для количественного учета
     UPDATE _tmpItem SET ContainerId_GoodsFrom = CASE WHEN _tmpItem.ContainerId_GoodsFrom > 0 THEN _tmpItem.ContainerId_GoodsFrom
                                            ELSE lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                    , inUnitId                 := CASE WHEN vbMemberId_From <> 0 THEN 0 ELSE vbUnitId_From END
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := vbMemberId_From
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                    , inBranchId               := vbBranchId_From
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     )
                                            END
                       , ContainerId_GoodsTo   = CASE WHEN _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                                           THEN
                                                 lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner -- по "Дате покупателя"
                                                                                    , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 ELSE _tmpItem.UnitId_To END
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
                                                                                     )
                                                      ELSE 0 -- !!!если списание или ОПиУ!!!
                                                 END
               -- у покупателя
             , ContainerId_GoodsTransit_01 = CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_From           -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit_01 -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
               -- Разница в весе
             , ContainerId_GoodsTransit_02 = CASE WHEN vbAccountId_GoodsTransit_02 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                                   AND _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_From             -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit_02 -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
               -- Скидка в весе
             , ContainerId_GoodsTransit_53 = CASE WHEN vbAccountId_GoodsTransit_53 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                                   AND _tmpItem.OperCount <>_tmpItem.OperCount_ChangePercent
                                                   AND vbIsBranch_to = TRUE
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_From
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_From             -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit_53 -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
              ;
     -- 1.1.2. формируются Проводки для количественного учета - Кому + определяется MIContainer.Id (количественный)
     UPDATE _tmpItem SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                                                , inDescId         := zc_MIContainer_Count()
                                                                                , inMovementDescId := vbMovementDescId
                                                                                , inMovementId     := inMovementId
                                                                                , inMovementItemId := _tmpItem.MovementItemId
                                                                                , inParentId       := NULL
                                                                                , inContainerId    := _tmpItem.ContainerId_GoodsTo               -- был опеределен выше
                                                                                , inAccountId               := 0                                 -- нет счета
                                                                                , inAnalyzerId              := zc_Enum_AnalyzerId_SendCount_in() -- есть аналитика
                                                                                , inObjectId_Analyzer       := _tmpItem.GoodsId                  -- Товар
                                                                                , inWhereObjectId_Analyzer  := _tmpItem.WhereObjectId_Analyzer_To -- Подраделение или...
                                                                                , inContainerId_Analyzer    := _tmpItem.ContainerId_GoodsFrom    -- количественный Контейнер-Корреспондент (т.е. из расхода)
                                                                                , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId              -- вид товара
                                                                                , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From     -- Подраделение "От кого"
                                                                                , inContainerIntId_Analyzer := 0                                 -- Контейнер "товар"
                                                                                , inAmount         := CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                                THEN _tmpItem.OperCount -- !!!количество ушло!!!
                                                                                                           ELSE _tmpItem.OperCount_Partner -- !!!количество пришло!!!
                                                                                                      END
                                                                                , inOperDate       := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                , inIsActive       := TRUE
                                                                                 )
     WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
    ;

     -- 1.1.3. формируются Проводки для количественного учета - От кого, здесь -- !!!количество ушло!!!
        WITH tmpMIContainer AS
            (SELECT MovementItemId
                  , ContainerId_GoodsFrom
                  , ContainerId_GoodsTo
                  , vbAccountId_GoodsTransit_01             AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_01             AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , zc_Enum_AnalyzerId_SendCount_in()       AS AnalyzerId --  Кол-во, перемещение по цене, перемещение, пришло
                  , WhereObjectId_Analyzer_To               AS ObjectExtId_Analyzer
                  , MIContainerId_To                        AS ParentId
                  , OperCount_Partner                       AS OperCount
                  , FALSE                                   AS isActive
             FROM _tmpItem
             -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
             -- WHERE OperCount_Partner <> 0
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_GoodsFrom
                  , ContainerId_GoodsTo
                  , vbAccountId_GoodsTransit_53             AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_53             AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , zc_Enum_AnalyzerId_SendCount_10500()    AS AnalyzerId --  Кол-во, перемещение по цене, перемещение, Скидка за вес
                  , WhereObjectId_Analyzer_To               AS ObjectExtId_Analyzer
                  , MIContainerId_To                        AS ParentId
                  , OperCount - OperCount_ChangePercent     AS OperCount
                  , FALSE                                   AS isActive
             FROM _tmpItem
             WHERE (OperCount - OperCount_ChangePercent) <> 0  -- !!!нулевые не нужны!!!
               AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_GoodsFrom
                  , ContainerId_GoodsTo
                  , vbAccountId_GoodsTransit_02             AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_02             AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , zc_Enum_AnalyzerId_SendCount_40200()    AS AnalyzerId -- Кол-во, перемещение по цене, перемещение, Разница в весе
                  , WhereObjectId_Analyzer_To               AS ObjectExtId_Analyzer
                  , MIContainerId_To                        AS ParentId
                  , OperCount_calc                          AS OperCount
                  , FALSE                                   AS isActive
             FROM (-- так "хитро" собирается "сумма" И если если строить отчет по ContainerId_Analyzer, тогда будет ОШИБКА, т.е. надо будет делать еще "хитрее"
                   SELECT MovementItemId
                        , ContainerId_GoodsFrom
                        , ContainerId_GoodsTo
                        , ContainerId_GoodsTransit_02
                        , GoodsId
                        , GoodsKindId
                        , WhereObjectId_Analyzer_To
                        , MIContainerId_To
                        , SUM (_tmpItem.OperCount_ChangePercent - _tmpItem.OperCount_Partner) OVER (PARTITION BY ContainerId_GoodsFrom)     AS OperCount_calc
                        , ROW_NUMBER() OVER (PARTITION BY ContainerId_GoodsFrom ORDER BY _tmpItem.OperCount DESC, _tmpItem.MovementItemId) AS Ord
                   FROM _tmpItem
                   WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                     AND _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner
                  ) AS tmp
             WHERE OperCount_calc <> 0  -- !!!нулевые не нужны!!!
               AND Ord = 1              -- !!!т.е. "желательно" с кол-вом "ушло"!!!
            )
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_GoodsFrom          AS ContainerId
            , 0                                       AS AccountId              -- нет счета
            , _tmpItem.AnalyzerId                     AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem.ContainerId_GoodsTo            AS ContainerId_Analyzer   -- количественный Контейнер-Корреспондент (т.е. из прихода)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.ObjectExtId_Analyzer           AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , _tmpItem.ParentId                       AS ParentId
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate               -- по "Дате склад"
            , FALSE                                   AS isActive
       FROM tmpMIContainer AS _tmpItem
       -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
       -- WHERE OperCount <> 0

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsTransit
            , _tmpItem.AccountId_GoodsTransit         AS AccountId              -- есть счет (т.е. в отчетах определяется "транзит")
            , _tmpItem.AnalyzerId                     AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE _tmpItem.ContainerId_GoodsTo END AS ContainerId_Analyzer -- т.е. в перемещение попадет "реальная" за vbOperDatePartner
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.ObjectExtId_Analyzer           AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , NULL                                    AS ParentId               -- !!!т.е. не будут привязаны к "приходу"!!!
            , _tmpItem.OperCount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN tmpMIContainer AS _tmpItem ON _tmpItem.AccountId_GoodsTransit <> 0

      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_GoodsFrom       AS ContainerId
            , 0                                    AS AccountId              -- нет счета
            , zc_Enum_AnalyzerId_LossCount_20200() AS AnalyzerId             -- Кол-во, списание при реализации/перемещении по цене
            , _tmpItem.GoodsId                     AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From        AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                    AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                 AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.WhereObjectId_Analyzer_To   AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , MIContainerId_To                     AS ParentId               -- хотя его быть не должно
            , -1 * _tmpItem.OperCount              AS Amount
            , vbOperDate                           AS OperDate               -- по "Дате склад"
            , FALSE                                AS isActive
       FROM _tmpItem
       -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
       -- WHERE OperCount <> 0
       WHERE isLossMaterials = TRUE -- !!!если списание!!!
      ;

     -- 1.1.4. дальше !!!Возвратная тара не учавствует!!!, поэтому удаляем
     DELETE FROM _tmpItem WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500(); -- 20500; "Оборотная тара";


     -- 1.2.1. самое интересное-1: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItemSumm (MovementItemId, isLossMaterials, isRestoreAccount_60000, isAccount_60000, MIContainerId_To, ContainerId_GoodsFrom, ContainerId_Transit_01, ContainerId_Transit_02, ContainerId_Transit_51, ContainerId_Transit_52, ContainerId_Transit_53, ContainerId_To, AccountId_To, ContainerId_ProfitLoss_10900, ContainerId_ProfitLoss_20200, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_60000, AccountId_60000, ContainerId_From, AccountId_From, InfoMoneyId_From, InfoMoneyId_Detail_From, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, OperSumm_Account_60000, OperSummVirt_Account_60000)
       --
       WITH -- где надо проверить с/с и потом найти альтернативную цену
            tmpHistoryCost_find_all AS (SELECT _tmpItem.ContainerId_GoodsFrom
                                             , _tmpItem.GoodsId
                                             , _tmpItem.GoodsKindId
                                             , Container_Summ.Id               AS ContainerId_Summ
                                             , Container_Summ.ObjectId         AS AccountId
                                             , COALESCE (HistoryCost.Price, 0) AS Price
                                        FROM _tmpItem
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
                                                                           AND CLO_Unit_new.ObjectId    = vbUnitId_From

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
              _tmpItem.MovementItemId
            , _tmpItem.isLossMaterials
            , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId       = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                     OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                        THEN TRUE
                   ELSE FALSE
              END AS isRestoreAccount_60000
            , FALSE AS isAccount_60000 -- НЕТ самое интересное-2
            , 0 AS MIContainerId_To
            , _tmpItem.ContainerId_GoodsFrom
            , 0 AS ContainerId_Transit_01 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_02 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_51 -- Счет Транзит, определим позже
            , 0 AS ContainerId_Transit_52 -- Счет Транзит, определим позже
            , 0 AS ContainerId_Transit_53 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , 0 AS ContainerId_ProfitLoss_10900 -- Счет - прибыль (ОПиУ - Утилизация возвратов)
            , 0 AS ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
            , 0 AS ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
            , 0 AS ContainerId_60000
            , 0 AS AccountId_60000
            , COALESCE (Container_Summ.Id, 0) AS ContainerId_From
            , COALESCE (Container_Summ.ObjectId, 0) AS AccountId_From
            , ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId_From
            , ContainerLinkObject_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail_From
              -- с/с1 - для количества расхода с остатка (+ RestoreAccount_60000)
            , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId       = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                     OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                        THEN SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))
                                + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                            THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                       ELSE COALESCE (HistoryCost.Summ_diff, 0) -- !!!временно не смотрим на знак!!!
                                  END)
                   ELSE SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4)) -- ABS
                           + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4)) >= -1 * HistoryCost.Summ_diff
                                       THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                  ELSE COALESCE (HistoryCost.Summ_diff, 0) -- !!!временно не смотрим на знак!!!
                             END)

              END AS OperSumm
              -- с/с2 - для количества с учетом % скидки
            , SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                         AND ContainerLinkObject_InfoMoneyDetail.ObjectId <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                             THEN CAST (_tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4)) -- ABS
                                + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                            THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                       ELSE COALESCE (HistoryCost.Summ_diff, 0) -- !!!временно не смотрим на знак!!!
                                  END
                        ELSE 0
                   END) AS OperSumm_ChangePercent
              -- с/с3 - для количества контрагента
            , SUM (CASE WHEN 1=1/*ContainerLinkObject_InfoMoney.ObjectId       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                         AND ContainerLinkObject_InfoMoneyDetail.ObjectId <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                         */    THEN CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4)) -- ABS
                                + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                            THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                       ELSE COALESCE (HistoryCost.Summ_diff, 0) -- !!!временно не смотрим на знак!!!
                                  END
                        ELSE 0
                   END) AS OperSumm_Partner
              --
            , 0 AS OperSumm_Account_60000 /*SUM (CASE WHEN vbBranchId_From = 0
                          OR vbBranchId_From = zc_Branch_Basis()
                             THEN 0 -- -1
                        ELSE 0 -- -1
                   END
                 * CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401()
                          OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401()
                             THEN (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0))
                        ELSE 0
                   END
                 ) AS OperSumm_Account_60000*/
            , 0 AS OperSummVirt_Account_60000
        FROM _tmpItem
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_GoodsFrom
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                      ON ContainerLinkObject_InfoMoney.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
             -- нашли с/с если нет для ContainerId_GoodsFrom
             LEFT JOIN tmpHistoryCost_find ON tmpHistoryCost_find.ContainerId_Summ = Container_Summ.Id
                                          AND HistoryCost.ContainerId IS NULL

        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          --!!!AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0)) <> 0) -- !!!ОБЯЗАТЕЛЬНО!!! вставляем нули если это не последний раз (они нужны для расчета с/с)
           AND (_tmpItem.OperCount         * HistoryCost.Price <> 0
             OR _tmpItem.OperCount_Partner * HistoryCost.Price <> 0
               )
          -- AND ((ContainerLinkObject_InfoMoney.ObjectId <> zc_Enum_InfoMoney_80401()        -- + для этой
          --   AND ContainerLinkObject_InfoMoneyDetail.ObjectId <> zc_Enum_InfoMoney_80401()) -- + УП = прибыль текущего периода
          --   OR (_tmpItem.OperCount * HistoryCost.Price) <> 0                               -- + вставлять нули !!!НЕ надо!!!
          --     )
          AND vbIsHistoryCost= TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.isLossMaterials
               , _tmpItem.ContainerId_GoodsFrom
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoney.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId;

     -- 1.2.2. определяется ContainerId - Транзит, !!!обязательно перед 1.2.3.!!!
     UPDATE _tmpItemSumm SET -- у покупателя
                             ContainerId_Transit_01 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_01 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                             -- Разница в весе
                           , ContainerId_Transit_02 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_02 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_02 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- у покупателя
                           , ContainerId_Transit_51 = CASE WHEN isRestoreAccount_60000 = TRUE THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_51 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- Разница в весе
                           , ContainerId_Transit_52 = CASE WHEN isRestoreAccount_60000 = TRUE AND _tmpItem.ContainerId_GoodsTransit_02 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_52 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- Скидка в весе
                           , ContainerId_Transit_53 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_53 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := CLO_Unit.ObjectId
                                                                                        , inCarId                  := CLO_Car.ObjectId
                                                                                        , inMemberId               := CLO_Member.ObjectId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                        , inBusinessId             := CLO_Business.ObjectId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_53 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                        , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_53 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := CLO_Goods.ObjectId
                                                                                        , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                        , inAssetId                := CLO_Asset.ObjectId
                                                                                         )
                                                      ELSE 0
                                                      END
     FROM (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_GoodsFrom, _tmpItemSumm.ContainerId_From FROM _tmpItemSumm) AS _tmpItemSumm_find
          INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm_find.MovementItemId
                             AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm_find.ContainerId_GoodsFrom
                             AND _tmpItem.isLossMaterials       = FALSE -- !!!если НЕ списание!!!
          LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                             AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
          LEFT JOIN ContainerLinkObject AS CLO_Business ON CLO_Business.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                       AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
          LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
          LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
          LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                    AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset ON CLO_Asset.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                    AND CLO_Asset.DescId = zc_ContainerLinkObject_AssetTo()
          LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                  AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = _tmpItemSumm_find.ContainerId_From
                                                     AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
     WHERE _tmpItemSumm.MovementItemId        = _tmpItemSumm_find.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItemSumm_find.ContainerId_GoodsFrom
       AND _tmpItemSumm.ContainerId_From      = _tmpItemSumm_find.ContainerId_From
       AND vbAccountId_GoodsTransit_01 <> 0
    ;

/*
  RAISE EXCEPTION 'Ошибка.<%>  <%> <%>'
-- , (select min (_tmpItemSumm.ContainerId_From) from _tmpItemSumm  where _tmpItemSumm.ContainerId_Transit_02 = 0 and _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner)
-- , (select min (_tmpItemSumm.ContainerId_From) from _tmpItemSumm  where _tmpItemSumm.ContainerId_Transit_02 <> 0 and _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner)
-- <5405331>  <140873

, (
 select count(*) 
-- select min (_tmpItemSumm.ContainerId_From)
from _tmpItemSumm 
       -- join (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_From FROM _tmpItemSumm
       --      ) as _tmpItemSumm_find on _tmpItemSumm_find.MovementItemId = _tmpItemSumm .MovementItemId
       join _tmpItem on _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId and _tmpItem.GoodsId = 2795
where _tmpItemSumm.ContainerId_Transit_02 = 0 and _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner
  --and _tmpItemSumm.ContainerId_From = 5405332
       AND _tmpItemSumm.MovementItemId   = _tmpItemSumm_find.MovementItemId
       AND _tmpItemSumm.ContainerId_From = _tmpItemSumm_find.ContainerId_From
       AND vbAccountId_GoodsTransit_01 <> 0
)
, (
  select count(*)
-- select min (_tmpItemSumm.ContainerId_From)
   from _tmpItemSumm
        join _tmpItem on _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId and _tmpItem.GoodsId = 2795
   where _tmpItemSumm.ContainerId_Transit_02 <> 0 and _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner
     -- and _tmpItemSumm.ContainerId_From = 5405331
)
     

, (
 select min (_tmpItem.GoodsId)
-- select count(*)
   from _tmpItemSumm join _tmpItem on _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId -- and _tmpItem.GoodsId = 7493  + 2795
  where _tmpItemSumm.ContainerId_Transit_02 = 0
    and _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner
)

-- , 5336373 (select min (_tmpItemSumm.ContainerId_From) from _tmpItemSumm  where _tmpItemSumm.ContainerId_Transit_02 = 0 and _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner)
;
*/


     -- 1.2.3. самое интересное-2: заполняем таблицу - суммовые элементы документа, для счета "Прибыль будущих периодов"
     INSERT INTO _tmpItemSumm (MovementItemId, isLossMaterials, isRestoreAccount_60000, isAccount_60000, MIContainerId_To, ContainerId_GoodsFrom, ContainerId_Transit_01, ContainerId_Transit_02, ContainerId_Transit_51, ContainerId_Transit_52, ContainerId_Transit_53, ContainerId_To, AccountId_To, ContainerId_ProfitLoss_20200, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_60000, AccountId_60000, ContainerId_From, AccountId_From, InfoMoneyId_From, InfoMoneyId_Detail_From, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, OperSumm_Account_60000, OperSummVirt_Account_60000)
        SELECT
              _tmpItem.MovementItemId
            , FALSE AS isLossMaterials
            , FALSE AS isRestoreAccount_60000
            , TRUE  AS isAccount_60000 -- ЕСТЬ самое интересное-2
            , 0 AS MIContainerId_To
            , _tmpItem.ContainerId_GoodsFrom
            , 0 AS ContainerId_Transit_01 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_02 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_51 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_52 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_53 -- Счет Транзит, определим позже
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
            , 0 AS ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов Прочие материалы)
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
            , 0 AS ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
            , 0 AS ContainerId_60000
            , 0 AS AccountId_60000
            , 0 AS ContainerId_From
            , 0 AS AccountId_From
            , CASE WHEN zc_isHistoryCost_byInfoMoneyDetail()= TRUE THEN _tmpItem.InfoMoneyId ELSE zc_Enum_InfoMoney_80401() END AS InfoMoneyId_From -- прибыль текущего периода
            , CASE WHEN zc_isHistoryCost_byInfoMoneyDetail()= TRUE THEN zc_Enum_InfoMoney_80401() ELSE 0 END AS InfoMoneyId_Detail_From             -- прибыль текущего периода
              -- с/с1 - для количества расхода с остатка
            , 0 AS OperSumm
              -- с/с2 - для количества с учетом % скидки
            , 0 AS OperSumm_ChangePercent
              -- с/с3 - для количества контрагента
            , 0 AS OperSumm_Partner
              --
            , _tmpItem.OperSumm_Partner_ChangePercent     - COALESCE (_tmpItemSumm_group.OperSumm_Partner, 0) AS OperSumm_Account_60000
            , _tmpItem.OperSumm_PartnerVirt_ChangePercent - _tmpItem.OperSumm_Partner_ChangePercent - COALESCE (_tmpItemSumm_group.OperSumm_ChangePercent, 0) AS OperSummVirt_Account_60000
        FROM _tmpItem
             LEFT JOIN (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_GoodsFrom
                             , SUM (_tmpItemSumm.OperSumm_Partner) AS OperSumm_Partner
                             , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm_ChangePercent
                        FROM _tmpItemSumm
                        GROUP BY _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_GoodsFrom
                       ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId        = _tmpItem.MovementItemId
                                              AND _tmpItemSumm_group.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
          AND ((vbBranchId_From = 0                  -- + только если
             OR vbBranchId_From = zc_Branch_Basis()) -- + со склада на филиал

            OR (vbBranchId_From > 0 AND vbBranchId_To > 0 AND vbBranchId_From <> zc_Branch_Basis() AND vbBranchId_To <> zc_Branch_Basis())
              )
          AND vbIsHistoryCost= TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
          -- AND vbOperDate < zc_DateStart_OperDatePartner()
       ;
/*

     IF inMovementId = 14030304
     THEN
         RAISE EXCEPTION 'Ошибка. <%> <%>  <%> <%>', (SELECT OperSumm FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND ContainerId_From = 724550)
                                                         , (SELECT OperSumm FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND ContainerId_From = 724558)
                                                         , (SELECT OperSumm FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND ContainerId_From = 2532332)
                                                         , (SELECT OperSumm FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND ContainerId_From = 2532333)
                                                         ;
     END IF;*/


     -- 1.2.4. !!!Проверка - в этом случае корреспонденция между с/с и Прибыль будущих периодов должна быть одинаковой
     IF EXISTS (SELECT MovementItemId FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE GROUP BY MovementItemId HAVING SUM (OperSumm) <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Проверка 1.2.3. <%> <%>', (SELECT MAX (ContainerId_From) FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND MovementItemId IN (SELECT MovementItemId FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE GROUP BY MovementItemId HAVING SUM (OperSumm) <> 0))
                                                         , (SELECT SUM (OperSumm) FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND ContainerId_From IN (SELECT MAX (ContainerId_From) FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND MovementItemId IN (SELECT MovementItemId FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE GROUP BY MovementItemId HAVING SUM (OperSumm) <> 0)));
     END IF;


     -- 1.2.1. создаем контейнеры Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_20200 = _tmpItem_byDestination.ContainerId_ProfitLoss
     FROM _tmpItem
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        -- , inObjectId_1        := zc_Enum_ProfitLoss_20204() -- Общепроизводственные расходы + Содержание складов Прочие материалы
                                        , inObjectId_1        := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_byProfitLoss.ProfitLossGroupId
                                                                                               , inProfitLossDirectionId  := _tmpItem_byProfitLoss.ProfitLossDirectionId
                                                                                               , inInfoMoneyDestinationId := _tmpItem_byProfitLoss.InfoMoneyDestinationId
                                                                                               , inInfoMoneyId            := NULL
                                                                                               , inUserId                 := inUserId
                                                                                                )
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := _tmpItem_byProfitLoss.BranchId_To
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BranchId_To
           FROM (SELECT  DISTINCT
                         CASE WHEN COALESCE (_tmpItem.BranchId_To, 0) IN (zc_Branch_Basis(), 0)
                              THEN zc_Enum_ProfitLossGroup_20000()     -- Общепроизводственные расходы
                              ELSE zc_Enum_ProfitLossGroup_40000()     -- Расходы на сбыт
                         END AS ProfitLossGroupId

                       , CASE WHEN COALESCE (_tmpItem.BranchId_To, 0) IN (zc_Branch_Basis(), 0)
                              THEN zc_Enum_ProfitLossDirection_20200() -- Содержание складов
                              ELSE zc_Enum_ProfitLossDirection_40200() -- Содержание филиалов
                         END AS ProfitLossDirectionId

                       , _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                       , _tmpItem.BranchId_To
                 FROM _tmpItem
                 WHERE _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BranchId_To            = _tmpItem.BranchId_To
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 1.2.2. создаем контейнеры для Проводки - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss
     FROM _tmpItem
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_40208() -- Содержание филиалов 40208; "Разница в весе"
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := _tmpItem_byProfitLoss.BranchId_To
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BranchId_To
           FROM (SELECT  DISTINCT
                         _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                       , _tmpItem.BranchId_To
                 FROM _tmpItem
                 WHERE _tmpItem.isLossMaterials = FALSE
                   AND _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BranchId_To            = _tmpItem.BranchId_To
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 1.2.3. создаем контейнеры для Проводки - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_10500 = _tmpItem_byDestination.ContainerId_ProfitLoss
     FROM _tmpItem
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := CASE WHEN _tmpItem_byProfitLoss.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()  -- Ирна -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          THEN zc_Enum_ProfitLoss_10502() -- Скидка за вес 10502; "Ирна"
                                                                     ELSE zc_Enum_ProfitLoss_10501()      -- Скидка за вес 10501; "Продукция"
                                                                END
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := _tmpItem_byProfitLoss.BranchId_To
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BranchId_To
           FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                       , _tmpItem.BranchId_To
                 FROM _tmpItem
                 WHERE _tmpItem.isLossMaterials = FALSE
                   AND _tmpItem.OperCount <> _tmpItem.OperCount_ChangePercent
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BranchId_To            = _tmpItem.BranchId_To
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 1.2.4. !!!создаем контейнер для Проводки - Прибыль - Утилизация возвратов!!!
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_10900 = _tmpItem_byDestination.ContainerId_ProfitLoss -- Счет - прибыль (ОПиУ - Утилизация возвратов)
     FROM _tmpItem
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := _tmpItem_byProfitLoss.JuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From -- !!!но филиал будет отправителя!!!
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.JuridicalId_Basis_To
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT DISTINCT
                        _tmpItem.JuridicalId_Basis_To
                      , _tmpItem.BusinessId_To
                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10902() -- Утилизация возвратов + Ирна
                             ELSE zc_Enum_ProfitLoss_10901() -- Утилизация возвратов + Продукция
                        END AS ProfitLossId
                 FROM _tmpItem
                 WHERE _tmpItem.isTo_10900 = TRUE
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.JuridicalId_Basis_To   = _tmpItem.JuridicalId_Basis_To
                                     AND _tmpItem_byDestination.BusinessId_To          = _tmpItem.BusinessId_To
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       -- AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
      ;


     -- 1.3.1. определяется Счет для проводок по суммовому учету - Кому
     UPDATE _tmpItemSumm SET AccountId_To = _tmpItem_byAccount.AccountId_To
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                  , inAccountDirectionId     := _tmpItem_group.AccountDirectionId_To
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := inUserId
                                                   ) AS AccountId_To
                     , _tmpItem_group.ContainerId_GoodsTo
                FROM (SELECT DISTINCT
                             _tmpItem.AccountDirectionId_To
                           , _tmpItem.ContainerId_GoodsTo
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE zc_isHistoryCost()       = TRUE -- !!!если нужны проводки!!!
                        AND _tmpItem.isTo_10900      = FALSE -- !!!если НЕ ОПиУ!!!
                        AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.ContainerId_GoodsTo = _tmpItem.ContainerId_GoodsTo
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 1.3.2. определяется ContainerId для проводок по суммовому учету - Кому  + формируется Аналитика <элемент с/с>
     UPDATE _tmpItemSumm SET ContainerId_To = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDatePartner -- по "Дате покупателя"
                                                                                , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 ELSE _tmpItem.UnitId_To END
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := _tmpItem.MemberId_To
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := _tmpItemSumm.AccountId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItemSumm.InfoMoneyId_From
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTo
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
                     -- у покупателя
                   , ContainerId_Transit_01 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_01 > 0 AND (_tmpItemSumm.OperSumm_Account_60000 <> 0 OR _tmpItemSumm.OperSummVirt_Account_60000 <> 0) THEN
                                              lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := _tmpItem.UnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := NULL
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := vbAccountId_GoodsTransit_01 -- !!!для счета Транзит!!!
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItemSumm.InfoMoneyId_From
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
                                              ELSE _tmpItemSumm.ContainerId_Transit_01 END

                     -- Разница в весе
                   , ContainerId_Transit_02 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_02 > 0 AND (_tmpItemSumm.OperSumm_Account_60000 <> 0 OR _tmpItemSumm.OperSummVirt_Account_60000 <> 0) THEN
                                              lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := _tmpItem.UnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := NULL
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := vbAccountId_GoodsTransit_02 -- !!!для счета Транзит!!!
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItemSumm.InfoMoneyId_From
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
                                              ELSE _tmpItemSumm.ContainerId_Transit_02 END

                     -- у покупателя - Прибыль в пути
                   , ContainerId_Transit_51 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_01 > 0 AND (_tmpItemSumm.OperSumm_Account_60000 <> 0 OR _tmpItemSumm.OperSummVirt_Account_60000 <> 0) THEN
                                              lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := _tmpItem.UnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := NULL
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := vbAccountId_GoodsTransit_51
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItemSumm.InfoMoneyId_From
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
                                              ELSE _tmpItemSumm.ContainerId_Transit_51 END

                     -- Разница в весе - Прибыль в пути
                   , ContainerId_Transit_52 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_02 > 0 AND (_tmpItemSumm.OperSumm_Account_60000 <> 0 OR _tmpItemSumm.OperSummVirt_Account_60000 <> 0) THEN
                                              lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := _tmpItem.UnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := NULL
                                                                                , inBranchId               := _tmpItem.BranchId_To
                                                                                , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                , inBusinessId             := _tmpItem.BusinessId_To
                                                                                , inAccountId              := vbAccountId_GoodsTransit_52
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItemSumm.InfoMoneyId_From
                                                                                , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 )
                                              ELSE _tmpItemSumm.ContainerId_Transit_52 END
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.isLossMaterials        = FALSE -- !!!так отбрасывается то что попадает в списание!!!
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
       AND _tmpItem.isTo_10900                 = FALSE -- !!!если НЕ ОПиУ!!!
      ;

     -- 1.3.3. формируются Проводки для суммового учета - Кому + определяется MIContainer.Id
     UPDATE _tmpItemSumm SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                                                    , inDescId         := zc_MIContainer_Summ()
                                                                                    , inMovementDescId := vbMovementDescId
                                                                                    , inMovementId     := inMovementId
                                                                                    , inMovementItemId := _tmpItem.MovementItemId
                                                                                    , inParentId       := NULL
                                                                                    , inContainerId    := _tmpItemSumm.ContainerId_To
                                                                                    , inAccountId               := _tmpItemSumm.AccountId_To        -- счет есть всегда
                                                                                    , inAnalyzerId              := zc_Enum_AnalyzerId_SendSumm_in() -- есть аналитика
                                                                                    , inObjectId_Analyzer       := _tmpItem.GoodsId                 -- Товар
                                                                                    , inWhereObjectId_Analyzer  := _tmpItem.WhereObjectId_Analyzer_To -- Подраделение или...
                                                                                    , inContainerId_Analyzer    := _tmpItemSumm.ContainerId_From    -- суммовой Контейнер-Корреспондент (т.е. из расхода)
                                                                                    , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId             -- вид товара
                                                                                    , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From    -- Подраделение "От кого"
                                                                                    , inContainerIntId_Analyzer := 0                                -- Контейнер "товар"
                                                                                    , inAmount         := _tmpItemSumm.OperSumm_Partner + _tmpItemSumm.OperSumm_Account_60000
                                                                                    , inOperDate       := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                    , inIsActive       := TRUE
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.isLossMaterials        = FALSE -- !!!так отбрасывается то что попадает в списание!!!
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
       AND _tmpItem.isTo_10900                 = FALSE -- !!!если НЕ ОПиУ!!!
      ;


     -- 1.4. формируются Проводки для суммового учета - От кого (c/c остаток) + !!!есть MovementItemId!!!
        WITH tmpAccount_60000 AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- Прибыль будущих периодов
           , tmpMIContainer AS
            (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_GoodsFrom
                  , _tmpItemSumm.isAccount_60000
                  , _tmpItemSumm.AccountId_From
                  , _tmpItemSumm.ContainerId_From
                  , _tmpItemSumm.ContainerId_To
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                  , _tmpItemSumm.ContainerId_ProfitLoss_10900
                  , _tmpItemSumm.ContainerId_ProfitLoss_20200
                  , _tmpItemSumm.ContainerId_ProfitLoss_40208
                  , _tmpItemSumm.ContainerId_ProfitLoss_10500
                  , CASE WHEN tmpAccount_60000.AccountId > 0
                          AND (_tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401()  -- прибыль текущего периода
                            OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401()) -- прибыль текущего периода
                          -- AND _tmpItem.OperCount_Partner <> 0 !!!временно!!!
                              THEN zc_Enum_AnalyzerId_SummIn_80401() -- Сумма, не совсем забалансовый счет, расход приб. буд. периодов

                         WHEN (_tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                            OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401()) -- прибыль текущего периода
                          -- AND _tmpItem.OperCount_Partner <> 0 !!!временно!!!
                              THEN zc_Enum_AnalyzerId_SummOut_80401() -- Сумма, не совсем забалансовый счет, приход приб. буд. периодов

                         /*WHEN (_tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                            OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401()) -- прибыль текущего периода
                          AND _tmpItem.OperCount_Partner = 0
                              THEN 0 -- !!!может быть временно, т.е. эту сумму надо будет делить на потери!!!*/

                         ELSE zc_Enum_AnalyzerId_SendSumm_in() -- Сумма с/с, перемещение по цене, перемещение, пришло

                    END AS AnalyzerId
                  , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так =0
                  , CASE WHEN _tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                              THEN _tmpItemSumm.OperSumm_Partner -- _tmpItemSumm.OperSumm
                         ELSE _tmpItemSumm.OperSumm_Partner
                    END AS OperSumm
                  , FALSE                                   AS isActive
             FROM _tmpItemSumm
                  LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = _tmpItemSumm.AccountId_From
                  LEFT JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                    AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE CASE WHEN _tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                          OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                             THEN _tmpItemSumm.OperSumm_Partner -- _tmpItemSumm.OperSumm
                        ELSE _tmpItemSumm.OperSumm_Partner
                   END <> 0 -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!

            -- тоже самое, но криво с МИНУСОМ
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_GoodsFrom
                  , _tmpItemSumm.isAccount_60000
                  , _tmpItemSumm.AccountId_From
                  , _tmpItemSumm.ContainerId_From
                  , _tmpItemSumm.ContainerId_To
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , -1 * _tmpItemSumm.ContainerId_Transit_52 AS ContainerId_Transit_52 -- вот он МИНУС
                  , _tmpItemSumm.ContainerId_Transit_53
                  , _tmpItemSumm.ContainerId_ProfitLoss_10900
                  , _tmpItemSumm.ContainerId_ProfitLoss_20200
                  , _tmpItemSumm.ContainerId_ProfitLoss_40208
                  , _tmpItemSumm.ContainerId_ProfitLoss_10500

                  , CASE WHEN tmpAccount_60000.AccountId > 0
                          AND (_tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401()  -- прибыль текущего периода
                            OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401()) -- прибыль текущего периода
                              THEN zc_Enum_AnalyzerId_SummIn_80401() -- Сумма, не совсем забалансовый счет, расход приб. буд. периодов

                         WHEN (_tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                            OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401()) -- прибыль текущего периода
                              THEN zc_Enum_AnalyzerId_SummOut_80401() -- Сумма, не совсем забалансовый счет, приход приб. буд. периодов


                         ELSE zc_Enum_AnalyzerId_SendSumm_in() -- Сумма с/с, перемещение по цене, перемещение, пришло

                    END AS AnalyzerId
                  , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так =0
                  , CASE WHEN _tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                           OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                              THEN _tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner
                         ELSE 0
                    END AS OperSumm
                  , FALSE                                   AS isActive
             FROM _tmpItemSumm
                  LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = _tmpItemSumm.AccountId_From
                  LEFT JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                    AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE (_tmpItemSumm.InfoMoneyId_From        = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                 OR _tmpItemSumm.InfoMoneyId_Detail_From = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                   )
               AND (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) <> 0
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!

            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_GoodsFrom
                  , _tmpItemSumm.isAccount_60000
                  , _tmpItemSumm.AccountId_From
                  , _tmpItemSumm.ContainerId_From
                  , _tmpItemSumm.ContainerId_To
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                  , _tmpItemSumm.ContainerId_ProfitLoss_10900
                  , _tmpItemSumm.ContainerId_ProfitLoss_20200
                  , _tmpItemSumm.ContainerId_ProfitLoss_40208
                  , _tmpItemSumm.ContainerId_ProfitLoss_10500

                  , zc_Enum_AnalyzerId_SendSumm_10500()     AS AnalyzerId --  Сумма с/с, перемещение по цене, перемещение, Скидка за вес
                  , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так =0
                  , _tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent AS OperSumm
                  , FALSE                                   AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) <> 0 -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.InfoMoneyId_From        <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
               AND _tmpItemSumm.InfoMoneyId_Detail_From <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_GoodsFrom
                  , _tmpItemSumm.isAccount_60000
                  , _tmpItemSumm.AccountId_From
                  , _tmpItemSumm.ContainerId_From
                  , _tmpItemSumm.ContainerId_To
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                  , _tmpItemSumm.ContainerId_ProfitLoss_10900
                  , _tmpItemSumm.ContainerId_ProfitLoss_20200
                  , _tmpItemSumm.ContainerId_ProfitLoss_40208
                  , _tmpItemSumm.ContainerId_ProfitLoss_10500
                  , zc_Enum_AnalyzerId_SendSumm_40200()    AS AnalyzerId -- Сумма с/с, перемещение по цене, перемещение, Разница в весе
                  , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так =0
                  , OperSumm_calc                          AS OperSumm
                  , FALSE                                  AS isActive
             FROM (SELECT _tmpItemSumm.*
                        , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) OVER (PARTITION BY _tmpItemSumm.ContainerId_From)            AS OperSumm_calc
                        , ROW_NUMBER() OVER (PARTITION BY _tmpItemSumm.ContainerId_From ORDER BY ABS (_tmpItemSumm.OperSumm) DESC, _tmpItemSumm.MovementItemId)  AS Ord
                   FROM _tmpItemSumm
                   WHERE _tmpItemSumm.InfoMoneyId_From        <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                     AND _tmpItemSumm.InfoMoneyId_Detail_From <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                     AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                     AND _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner -- так "хитро"
                  ) AS _tmpItemSumm
             WHERE OperSumm_calc <> 0 -- !!!нулевые не нужны!!!
               AND Ord = 1            -- !!!т.е. "желательно" с кол-вом "ушло"!!!
            )
     -- Результат
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive
                                        )
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_From           AS ContainerId
            , _tmpItemSumm.AccountId_From             AS AccountId              -- счет есть всегда
            , _tmpItemSumm.AnalyzerId                 AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , CASE WHEN _tmpItemSumm.ContainerId_ProfitLoss_10900 <> 0 THEN _tmpItemSumm.ContainerId_ProfitLoss_10900 ELSE _tmpItemSumm.ContainerId_To END AS ContainerId_Analyzer -- суммовой Контейнер-Мастер (т.е. из прихода)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.WhereObjectId_Analyzer_To      AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , _tmpItemSumm.ParentId
            , -1 * _tmpItemSumm.OperSumm
            , vbOperDate                              AS OperDate               -- по "Дате склад"
            , FALSE
       FROM _tmpItem
            JOIN tmpMIContainer AS _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                                               AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       WHERE _tmpItemSumm.isAccount_60000 = FALSE -- !!без "самое интересное-2"!!
         AND _tmpItem.isLossMaterials     = FALSE -- !!!если НЕ списание!!!

      UNION ALL
       -- это списание
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItemSumm.ContainerId_From           AS ContainerId
            , _tmpItemSumm.AccountId_From             AS AccountId              -- счет есть всегда
            , zc_Enum_AnalyzerId_LossSumm_20200()     AS AnalyzerId             -- Сумма с/с, списание при реализации/перемещении по цене
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.WhereObjectId_Analyzer_To      AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так = 0
            , -1 * _tmpItemSumm.OperSumm
            , vbOperDate                              AS OperDate               -- по "Дате склад"
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       WHERE  _tmpItemSumm.isAccount_60000 = FALSE -- !!без "самое интересное-2"!!
         AND _tmpItem.isLossMaterials      = TRUE  -- !!!если списание!!!

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId

            , CASE -- Прибыль в пути + Прибыль будущих периодов ИЛИ Разница в весе + криво с Минусом
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401() AND tmpOperDate.OperDate = vbOperDate
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN _tmpItemSumm.ContainerId_Transit_02 ELSE _tmpItemSumm.ContainerId_Transit_01 END
                   -- Прибыль в пути + Прибыль будущих периодов ИЛИ Разница в весе + криво с Минусом
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401() AND tmpOperDate.OperDate = vbOperDatePartner
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN _tmpItemSumm.ContainerId_Transit_02 ELSE _tmpItemSumm.ContainerId_Transit_01 END

                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummIn_80401() AND tmpOperDate.OperDate = vbOperDate
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN -1 * _tmpItemSumm.ContainerId_Transit_52 ELSE _tmpItemSumm.ContainerId_Transit_51 END
                   -- Прибыль в пути + Прибыль будущих периодов ИЛИ Разница в весе + криво с Минусом
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummIn_80401() AND tmpOperDate.OperDate = vbOperDatePartner
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN -1 * _tmpItemSumm.ContainerId_Transit_52 ELSE _tmpItemSumm.ContainerId_Transit_51 END


                   -- Разница в весе
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_40200()
                        THEN _tmpItemSumm.ContainerId_Transit_02
                   -- Скидка за вес
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500()
                        THEN _tmpItemSumm.ContainerId_Transit_53

                   ELSE _tmpItemSumm.ContainerId_Transit_01

              END AS ContainerId

            , CASE -- WHEN 1=0 AND tmpAccount_60000.AccountId > 0 AND tmpOperDate.OperDate = vbOperDate
                   --      THEN zc_Enum_AnalyzerId_SummOut_80401()
                   -- WHEN 1=0 AND tmpAccount_60000.AccountId > 0 AND tmpOperDate.OperDate = vbOperDatePartner
                   --      THEN zc_Enum_AnalyzerId_SummIn_80401()

                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401() AND tmpOperDate.OperDate = vbOperDate
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN vbAccountId_GoodsTransit_02 ELSE vbAccountId_GoodsTransit_01 END
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401() AND tmpOperDate.OperDate = vbOperDatePartner
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN vbAccountId_GoodsTransit_02 ELSE vbAccountId_GoodsTransit_01 END

                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummIn_80401() AND tmpOperDate.OperDate = vbOperDate
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN vbAccountId_GoodsTransit_52 ELSE vbAccountId_GoodsTransit_51 END
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummIn_80401() AND tmpOperDate.OperDate = vbOperDatePartner
                        THEN CASE WHEN _tmpItemSumm.ContainerId_Transit_52 < 0 THEN vbAccountId_GoodsTransit_52 ELSE vbAccountId_GoodsTransit_51 END

                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_40200() -- Разница в весе
                        THEN vbAccountId_GoodsTransit_02
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500() -- Скидка за вес
                        THEN vbAccountId_GoodsTransit_53

                   ELSE vbAccountId_GoodsTransit_01                             -- такой же как у проводки кол-ва

              END AS AccountId                                                  -- есть счет (т.е. в отчетах определяется "транзит")
            , CASE WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummIn_80401()  THEN zc_Enum_AnalyzerId_SummIn_110101()
                   WHEN _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401() THEN zc_Enum_AnalyzerId_SummOut_110101()
                   ELSE _tmpItemSumm.AnalyzerId
              END AS AnalyzerId                                                 -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0
                   ELSE CASE WHEN _tmpItemSumm.ContainerId_ProfitLoss_40208 <> 0 AND _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_40200()
                                  THEN _tmpItemSumm.ContainerId_ProfitLoss_40208 -- Разница в весе
                             WHEN _tmpItemSumm.ContainerId_ProfitLoss_10500 <> 0 AND _tmpItemSumm.AnalyzerId = zc_Enum_AnalyzerId_SendSumm_10500()
                                  THEN _tmpItemSumm.ContainerId_ProfitLoss_10500 -- Скидка за вес
                             WHEN _tmpItemSumm.ContainerId_ProfitLoss_10900 <> 0
                                  THEN _tmpItemSumm.ContainerId_ProfitLoss_10900 -- Утилизация возвратов
                             WHEN _tmpItemSumm.ContainerId_ProfitLoss_20200 <> 0
                                  THEN _tmpItemSumm.ContainerId_ProfitLoss_20200 -- Содержание складов
                             ELSE _tmpItemSumm.ContainerId_To
                        END
              END                                     AS ContainerId_Analyzer   -- т.е. в перемещение попадет "реальная" за vbOperDatePartner
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.WhereObjectId_Analyzer_To      AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , NULL                                    AS ParentId               -- !!!т.е. не будут привязаны к "приходу"!!!
            , _tmpItemSumm.OperSumm * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate                    AS OperDate               -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit_01 <> 0
                               AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            INNER JOIN tmpMIContainer AS _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                                                     AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
                                                     AND _tmpItemSumm.isAccount_60000       = FALSE -- !!без "самое интересное-2"!!
            LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = _tmpItemSumm.AccountId_From

     UNION ALL
       -- это 2 или 6 проводки для расчета суммы по ценам (!!!нужна при расчете суммы "ушло"!!!)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId

            , CASE WHEN _tmpItemSumm.ContainerId_ProfitLoss_10900 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_10900

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_51
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_01

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_51
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_01

                   ELSE _tmpItemSumm.ContainerId_To -- !!!не ошибка, т.к. это виртуальная проводка, а ContainerId_From иногда = 0!!!
              END AS ContainerId

            , CASE WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_51 -- !!!Транзит + прибыль в пути!!!
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_01

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_51
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_01 -- !!!Транзит + прибыль в пути!!!

                   WHEN tmpTransit.AccountId = 0
                        THEN vbAccountId_GoodsTransit_01
                   ELSE tmpTransit.AccountId
              END AS AccountId   -- есть счет

            , tmpTransit.AnalyzerId                   AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение !!!не ошибка, т.к. надо при расчете суммы "ушло"!!!
            -- пока не нужен
            , 0                                       AS ContainerId_Analyzer
            /*, CASE WHEN _tmpItemSumm.ContainerId_ProfitLoss_10900 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_10900
                   WHEN _tmpItemSumm.ContainerId_ProfitLoss_20200 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_20200
                   WHEN _tmpItemSumm.ContainerId_ProfitLoss_40208 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_40208
                   WHEN _tmpItemSumm.ContainerId_ProfitLoss_10500 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_10500
                   ELSE _tmpItemSumm.ContainerId_To
              END                                     AS ContainerId_Analyzer*/   -- т.е. в перемещение попадет "реальная" за vbOperDatePartner

            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.WhereObjectId_Analyzer_To      AS ObjectExtId_Analyzer   -- Подраделение "Кому" !!!не ошибка, т.к. надо при расчете суммы "ушло"!!!
            , NULL                                    AS ParentId               -- !!!т.е. не будут привязаны к "приходу"!!!
            , _tmpItemSumm.OperSumm_Account_60000 * CASE WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401()
                                                              THEN -1
                                                         WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpTransit.OperDate = vbOperDate
                                                              THEN -1
                                                         WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpTransit.OperDate = vbOperDatePartner
                                                              THEN -1
                                                         ELSE 1
                                                     END AS Amount -- "виртуальная" с обратным знаком
            , tmpTransit.OperDate                     AS OperDate               -- т.е. по "определенной" Дате
            , tmpTransit.isActive                     AS isActive               -- зависят от даты
       FROM _tmpItemSumm
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                               AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom

            LEFT JOIN (SELECT zc_Enum_AnalyzerId_SummIn_80401()   AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_80401()  AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AnalyzerId, 0 AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AnalyzerId, 0 AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
                      ) AS tmpTransit ON tmpTransit.AnalyzerId <> 0
       WHERE _tmpItemSumm.OperSumm_Account_60000 <> 0 -- !!!нулевые не нужны!!!

     UNION ALL
       -- это 4 проводки для расчета ПРИБЫЛЬ - Разница в весе (!!!нужна при расчете суммы "ушло"!!!)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId

            , CASE WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_52
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_02

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_52
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN _tmpItemSumm.ContainerId_Transit_02

              END AS ContainerId

            , CASE WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_52 -- !!!Транзит + прибыль в пути!!!
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_02

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_52 -- !!!Транзит + прибыль в пути!!!
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND inUserId = 5 and 1=1
                        THEN vbAccountId_GoodsTransit_02

              END AS AccountId   -- есть счет

            -- , tmpTransit.AnalyzerId                AS AnalyzerId             -- есть аналитика
            , 0                                       AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение !!!не ошибка, т.к. надо при расчете суммы "ушло"!!!
            -- пока не нужен
            , 0                                       AS ContainerId_Analyzer
            /*, CASE WHEN _tmpItemSumm.ContainerId_ProfitLoss_10900 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_10900
                   WHEN _tmpItemSumm.ContainerId_ProfitLoss_20200 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_20200
                   WHEN _tmpItemSumm.ContainerId_ProfitLoss_40208 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_40208
                   WHEN _tmpItemSumm.ContainerId_ProfitLoss_10500 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_10500
                   ELSE _tmpItemSumm.ContainerId_To
              END                                     AS ContainerId_Analyzer*/ -- т.е. в перемещение попадет "реальная" за vbOperDatePartner
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem.WhereObjectId_Analyzer_To      AS ObjectExtId_Analyzer   -- Подраделение "Кому" !!!не ошибка, т.к. надо при расчете суммы "ушло"!!!
            , NULL                                    AS ParentId               -- !!!т.е. не будут привязаны к "приходу"!!!
            , _tmpItemSumm.OperSummVirt_Account_60000 * CASE WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_80401()
                                                              THEN -1
                                                         WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()  AND tmpTransit.OperDate = vbOperDate
                                                              THEN -1
                                                         WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101() AND tmpTransit.OperDate = vbOperDatePartner
                                                              THEN -1
                                                         ELSE 1
                                                     END AS Amount -- "виртуальная" с обратным знаком
            , tmpTransit.OperDate                     AS OperDate               -- т.е. по "определенной" Дате
            , tmpTransit.isActive                     AS isActive               -- зависят от даты
       FROM _tmpItemSumm
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                               AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom

            LEFT JOIN (SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AnalyzerId, 0 AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AnalyzerId, 0 AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
                      ) AS tmpTransit ON tmpTransit.AnalyzerId <> 0
       WHERE _tmpItemSumm.OperSummVirt_Account_60000 <> 0 -- !!!нулевые не нужны!!!
      ;
/*
    RAISE EXCEPTION '<%>', (select
-- _tmpItemSumm.OperSumm_Account_60000
-- _tmpItemSumm.OperSummVirt_Account_60000
--  lfGet_Object_ValueData (_tmpItem.GoodsId) -- 6779
-- _tmpItem.OperSumm_PartnerVirt_ChangePercent --35819.9700
-- _tmpItem.OperSumm_Partner_ChangePercent
-- _tmpItem.OperCount_ChangePercent
-- _tmpItem.OperCount_Partner
       FROM _tmpItemSumm
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                              -- and _tmpItem.ContainerId_GoodsTransit_02 = 0
       WHERE _tmpItemSumm.OperSummVirt_Account_60000 <> 0
         and _tmpItemSumm.ContainerId_Transit_01 = 0
      -- and _tmpItemSumm.ContainerId_Transit_51 = 0
       limit 1);*/


/*
IF inUserId = 5
THEN
    RAISE EXCEPTION '<%>  <%>'
    , (select count (*) from  _tmpMIContainer_insert where coalesce (_tmpMIContainer_insert.ContainerId, 0) = 0
      )
    , (select min (coalesce (CASE WHEN _tmpItemSumm.ContainerId_ProfitLoss_10900 <> 0
                        THEN _tmpItemSumm.ContainerId_ProfitLoss_10900

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND 1=0
                        THEN _tmpItemSumm.ContainerId_Transit_01
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDate AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND 1=0
                        THEN _tmpItemSumm.ContainerId_Transit_51

                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummIn_110101()   AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND 1=0
                        THEN _tmpItemSumm.ContainerId_Transit_51
                   WHEN tmpTransit.AnalyzerId = zc_Enum_AnalyzerId_SummOut_110101()  AND tmpTransit.OperDate = vbOperDatePartner AND vbOperDate >= '01.09.2017' AND vbOperDatePartner >= '01.09.2017' AND 1=0
                        THEN _tmpItemSumm.ContainerId_Transit_01

                   ELSE _tmpItemSumm.ContainerId_To
              END, 0 ))
    from _tmpItemSumm
            LEFT JOIN (SELECT zc_Enum_AnalyzerId_SummIn_80401()   AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_80401()  AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AnalyzerId, 0 AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AnalyzerId, 0 AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AnalyzerId, 0 AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
                      ) AS tmpTransit ON tmpTransit.AnalyzerId <> 0
       WHERE _tmpItemSumm.OperSumm_Account_60000 <> 0 -- !!!нулевые не нужны!!!
       -- WHERE _tmpItemSumm.ContainerId_Transit_01 <> 0
    );
    -- 'Повторите действие через 3 мин.'
END IF;
*/

     -- 2.2.1. формируются Проводки - Прибыль (Себестоимость)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- прибыль текущего периода
            , _tmpItem_group.WhereObjectId_Analyzer_To AS AnalyzerId            -- !!!нет!!!, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer   -- вид товара
            , _tmpItem_group.WhereObjectId_Analyzer_To AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem_group.isLossMaterials = FALSE THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
            , FALSE
       FROM  -- Проводки по списанию
            (SELECT _tmpItemSumm.ContainerId_ProfitLoss_20200 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.MovementItemId
                  , _tmpItem.WhereObjectId_Analyzer_To
                  , _tmpItem.GoodsId                 AS GoodsId
                  , _tmpItem.GoodsKindId             AS GoodsKindId
                  , 0                                AS AnalyzerId -- !!!нет!!!
                  , SUM (_tmpItemSumm.OperSumm)      AS OperSumm
                  , TRUE                             AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE _tmpItemSumm.ContainerId_ProfitLoss_20200 <> 0 -- !!!если списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_20200
                    , _tmpItemSumm.MovementItemId
                    , _tmpItem.WhereObjectId_Analyzer_To
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            UNION ALL
             -- Проводки по разнице в весе : с/с2 - с/с3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.MovementItemId
                  , _tmpItem.WhereObjectId_Analyzer_To
                  , _tmpItem.GoodsId                 AS GoodsId
                  , _tmpItem.GoodsKindId             AS GoodsKindId
                  , 0                                AS AnalyzerId -- !!!нет!!!
                  , SUM (_tmpItemSumm.OperSumm_calc) AS OperSumm
                  , FALSE                            AS isLossMaterials
             FROM (SELECT _tmpItemSumm.*
                        , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) OVER (PARTITION BY _tmpItemSumm.ContainerId_From)             AS OperSumm_calc
                        , ROW_NUMBER() OVER (PARTITION BY _tmpItemSumm.ContainerId_From ORDER BY ABS (_tmpItemSumm.OperSumm) DESC, _tmpItemSumm.MovementItemId)  AS Ord
                   FROM _tmpItemSumm
                   WHERE _tmpItemSumm.ContainerId_ProfitLoss_40208 <> 0
                     AND _tmpItemSumm.OperSumm_ChangePercent <> _tmpItemSumm.OperSumm_Partner -- так "хитро"
                  ) AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE OperSumm_calc <> 0 -- !!!нулевые не нужны!!!
               AND Ord = 1            -- !!!т.е. "желательно" с кол-вом "ушло"!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208
                    , _tmpItemSumm.MovementItemId
                    , _tmpItem.WhereObjectId_Analyzer_To
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            UNION ALL
             -- Проводки по скидкам в весе : с/с1 - с/с2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.MovementItemId
                  , _tmpItem.WhereObjectId_Analyzer_To
                  , _tmpItem.GoodsId                 AS GoodsId
                  , _tmpItem.GoodsKindId             AS GoodsKindId
                  , 0                                AS AnalyzerId -- !!!нет!!!
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm
                  , FALSE                            AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE _tmpItemSumm.ContainerId_ProfitLoss_10500 <> 0
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10500
                    , _tmpItemSumm.MovementItemId
                    , _tmpItem.WhereObjectId_Analyzer_To
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       ;

     -- 2.2.2. формируются Проводки - Прибыль (Себестоимость - Утилизация возвратов)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId_ProfitLoss_10900
            , zc_Enum_Account_100301 ()               AS AccountId              -- прибыль текущего периода
            , zc_Enum_AnalyzerId_SendSumm_in()        AS AnalyzerId             -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.WhereObjectId_Analyzer_To      AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm.ContainerId_From           AS ContainerId_Analyzer   -- в ОПиУ не нужен, но проводку делаем похожей на "приход"
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_From           AS ObjectExtId_Analyzer   -- Подраделение "От кого"
            , 0                                       AS ParentId
            , _tmpItemSumm.OperSumm_Partner + _tmpItemSumm.OperSumm_Account_60000
            , vbOperDatePartner -- !!!по "Дате покупателя"!!!
            , FALSE
       FROM _tmpItem
            INNER JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
                                   AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       WHERE _tmpItem.isTo_10900 = TRUE -- !!!если ОПиУ!!!
      ;


     -- 3.1. определяется Счет для проводок по "Прибыль будущих периодов"
     UPDATE _tmpItemSumm SET AccountId_60000 = _tmpItem_byAccount.AccountId
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_60000()
                                                  , inAccountDirectionId     := CASE WHEN _tmpItem_group.MemberId_To <> 0
                                                                                          THEN zc_Enum_AccountDirection_60100() -- "Прибыль будущих периодов"; 60100; "сотрудники (экспедиторы)"
                                                                                     ELSE zc_Enum_AccountDirection_60200() -- "Прибыль будущих периодов"; 60200; "на филиалах"
                                                                                END
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := inUserId
                                                   ) AS AccountId
                     , _tmpItem_group.ContainerId_GoodsTo
                     , _tmpItem_group.ContainerId_GoodsFrom
                FROM (SELECT DISTINCT
                             _tmpItem.ContainerId_GoodsTo
                           , _tmpItem.ContainerId_GoodsFrom
                           , _tmpItem.MemberId_To
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (_tmpItem.AccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.ContainerId_GoodsTo = _tmpItem.ContainerId_GoodsTo
     WHERE _tmpItemSumm.MovementItemId        = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.OperSumm_Account_60000 <> 0
      ;


     -- 3.2. определяется ContainerId для проводок по "Прибыль будущих периодов"
     UPDATE _tmpItemSumm SET ContainerId_60000 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                   , inUnitId                 := CASE WHEN _tmpItem.MemberId_To <> 0 THEN 0 ELSE _tmpItem.UnitId_To END
                                                                                   , inCarId                  := NULL
                                                                                   , inMemberId               := _tmpItem.MemberId_To
                                                                                   , inBranchId               := _tmpItem.BranchId_To
                                                                                   , inJuridicalId_basis      := _tmpItem.JuridicalId_Basis_To
                                                                                   , inBusinessId             := _tmpItem.BusinessId_To
                                                                                   , inAccountId              := _tmpItemSumm.AccountId_60000
                                                                                   , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                   , inInfoMoneyId            := _tmpItemSumm.InfoMoneyId_From
                                                                                   , inInfoMoneyId_Detail     := _tmpItemSumm.InfoMoneyId_Detail_From
                                                                                   , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTo
                                                                                   , inGoodsId                := _tmpItem.GoodsId
                                                                                   , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                   , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                   , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                   , inAssetId                := _tmpItem.AssetId
                                                                                    )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId         = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_GoodsFrom  = _tmpItem.ContainerId_GoodsFrom
       AND _tmpItemSumm.OperSumm_Account_60000 <> 0
    ;

     -- 3.3. формируются Проводки - "Прибыль будущих периодов"
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId
            , _tmpItemSumm_group.AccountId            AS AccountId              -- счет есть всегда
            , vbWhereObjectId_Analyzer_From           AS AnalyzerId             -- !!!нет аналитики!!!, но для ускорения отчетов будет Подраделение "От кого" или...
            , _tmpItemSumm_group.GoodsId              AS ObjectId_Analyzer      -- Товар
            , _tmpItemSumm_group.WhereObjectId_Analyzer_To AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItemSumm_group.GoodsKindId          AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_From           AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm_group.OperSumm
            , vbOperDatePartner                       AS OperDate -- !!!по "Дате покупателя"!!!
            , CASE WHEN vbBranchId_From = 0 OR vbBranchId_From = zc_Branch_Basis() THEN TRUE ELSE FALSE END AS isActive
       FROM (SELECT _tmpItemSumm.ContainerId_60000 AS ContainerId, _tmpItemSumm.AccountId_60000 AS AccountId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.WhereObjectId_Analyzer_To, (_tmpItemSumm.OperSumm_Account_60000) AS OperSumm
                  , _tmpItemSumm.MovementItemId
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId        = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_GoodsFrom = _tmpItemSumm.ContainerId_GoodsFrom
             WHERE _tmpItemSumm.OperSumm_Account_60000 <> 0
            ) AS _tmpItemSumm_group
     ;


     -- !!!6.0.1. формируется свойство <Спец. алгоритм для расчета с/с (да/нет)>!!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_HistoryCost()
                                           , inMovementId
                                           , CASE WHEN (vbBranchId_From = 0 OR vbBranchId_From = zc_Branch_Basis())
                                                    OR (vbBranchId_From > 0 AND vbBranchId_To > 0 AND vbBranchId_From <> zc_Branch_Basis() AND vbBranchId_To <> zc_Branch_Basis())
                                                       THEN TRUE
                                                  ELSE FALSE
                                             END
                                            );

     -- !!!6.0.2. формируется свойство <zc_MIFloat_Summ - Сумма> + <zc_MIFloat_SummFrom - Сумма (ушло)> + <zc_MIFloat_SummPriceList - Сумма по прайсу>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(),          _tmpItem.MovementItemId, _tmpItem.OperSumm_Partner_ChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFrom(),      _tmpItem.MovementItemId, _tmpItem.OperSumm_PartnerVirt_ChangePercent)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPriceList(), _tmpItem.MovementItemId, _tmpItem.OperSumm_PriceList)
     FROM (SELECT _tmpItem.MovementItemId
            , SUM (_tmpItem.OperSumm_Partner_ChangePercent)     AS OperSumm_Partner_ChangePercent
            , SUM (_tmpItem.OperSumm_PartnerVirt_ChangePercent) AS OperSumm_PartnerVirt_ChangePercent
            , SUM (_tmpItem.OperSumm_PriceList)                 AS OperSumm_PriceList
           FROM _tmpItem
           GROUP BY _tmpItem.MovementItemId
          ) AS _tmpItem;


--  RAISE EXCEPTION 'Ошибка.<%>  <%> ', (select count(*) from _tmpItemSumm ), (select count(*) from _tmpMIContainer_insert);


     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();
     -- 6.2. ФИНИШ - Обязательно сохраняем Проводки для Отчета
     PERFORM lpInsertUpdate_MIReport_byTable ();

     -- 6.3. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SendOnPrice()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.19         * tmpPriceList
 23.10.14                                        * set lp
 17.08.14                                        * add MovementDescId
 13.08.14                                        * add lpInsertUpdate_MIReport_byTable
 12.08.14                                        * add inBranchId :=
 08.08.14                                        * add lpInsertFind_Object_PartionGoods
 25.05.14                                        * add lpComplete_Movement
 21.12.13                                        * Personal -> Member
 03.11.13                                        * rename zc_Enum_ProfitLoss_40209 -> zc_Enum_ProfitLoss_40208
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods
 15.09.13                                        * add zc_Enum_Account_20901
 14.09.13                                        * add vbBusinessId_From
 09.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 3313, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_SendOnPrice_NEW (inMovementId:= 3313, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3313, inSession:= '2')
-- select gpComplete_All_Sybase(    28044380 ,  false    , '')
