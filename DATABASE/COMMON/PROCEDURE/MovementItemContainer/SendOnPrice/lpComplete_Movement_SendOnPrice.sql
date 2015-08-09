-- Function: lpComplete_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS lpComplete_Movement_SendOnPrice (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
 RETURNS VOID
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя

  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer_From Integer;
  DECLARE vbWhereObjectId_Analyzer_To Integer;
  DECLARE vbAccountId_GoodsTransit Integer;

  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;

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

  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_UnitTo Boolean;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;
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
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- Бухгалтер ДНЕПР
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
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- Аналитики счетов - направления !!!обрабатываются только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE) AS isPartionDate_UnitFrom

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS MemberId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ChildObjectId WHEN Object_To.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BranchId_To
          , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_To  -- Аналитики счетов - направления !!!обрабатываются только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate_To.ValueData, FALSE) AS isPartionDate_UnitTo

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Member() THEN zc_Juridical_Basis() ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BusinessId_From
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Member() THEN zc_Juridical_Basis() ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Member() THEN 0 ELSE 0 END, 0) AS BusinessId_To

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbMovementDescId, vbOperDate, vbOperDatePartner, vbUnitId_From, vbMemberId_From, vbBranchId_From, vbAccountDirectionId_From, vbIsPartionDate_UnitFrom
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbAccountDirectionId_To, vbIsPartionDate_UnitTo
               , vbJuridicalId_Basis_From, vbBusinessId_From
               , vbJuridicalId_Basis_To, vbBusinessId_To
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
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                               ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                               ON ObjectLink_UnitTo_Business.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_To.DescId = zc_Object_Unit()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_SendOnPrice()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     
     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, isLossMaterials
                         , MIContainerId_To, ContainerId_GoodsFrom, ContainerId_GoodsTo, ContainerId_GoodsTransit, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCount_ChangePercent, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_Partner, OperSumm_Partner, OperSumm_Partner_ChangePercent
                         , InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From, BusinessId_To
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId_From, PartionGoodsId_To)
        SELECT
              _tmp.MovementItemId
            , CASE WHEN _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20600()   -- 20600; "Прочие материалы"
                     -- OR _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200()   -- 10200; "Прочее сырье"
                        THEN TRUE
                   ELSE FALSE
              END AS isLossMaterials
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_GoodsFrom
            , 0 AS ContainerId_GoodsTo
            , 0 AS ContainerId_GoodsTransit -- Счет - кол-во Транзит
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

            , _tmp.OperCount
            , _tmp.OperCount_ChangePercent
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

              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId END AS BusinessId_From
              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId END AS BusinessId_To

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 

              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId_From
            , 0 AS PartionGoodsId_To

        FROM 
             (SELECT
                    MovementItem.Id AS MovementItemId

                  , MovementItem.ObjectId AS GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция
                  , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                  , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate
 
                  , COALESCE (MIFloat_Price.ValueData, 0) AS Price
                    -- количество с остатка
                  , MovementItem.Amount AS OperCount
                    -- количество с учетом % скидки
                  , COALESCE (MIFloat_AmountChangePercent.ValueData, 0) AS OperCount_ChangePercent
                    -- количество у контрагента
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS OperCount_Partner

                    -- промежуточная сумма прайс-листа по Контрагенту - с округлением до 2-х знаков
                  , COALESCE (CAST (MIFloat_AmountPartner.ValueData * lfObjectHistory_PriceListItem.ValuePrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                  , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                 ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                    END AS tmpOperSumm_Partner

                    -- Управленческие назначения
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

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

                   LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate) -- по "Дате склад"
                          AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_SendOnPrice()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     SELECT -- Расчет Итоговой суммы прайс-листа по Контрагенту
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_PriceList
                 WHEN vbVATPercent_PriceList > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList AS NUMERIC (16, 2))
            END
            -- Расчет Итоговой суммы по Контрагенту !!! без скидки !!!
         ,  CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_Partner
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
            END
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
            END
            INTO vbOperSumm_PriceList, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent
     FROM (SELECT SUM (_tmpItem.tmpOperSumm_PriceList) AS tmpOperSumm_PriceList
                , SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
           FROM _tmpItem
          ) AS _tmpItem
     ;

     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent) INTO vbOperSumm_PriceList_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem FROM _tmpItem;

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
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner_ChangePercent IN (SELECT MAX (_tmpItem.OperSumm_Partner_ChangePercent) FROM _tmpItem)
                                          );
     END IF;


     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId_From = CASE WHEN vbOperDate >= zc_DateStart_PartionGoods()
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
                                                     AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN vbIsPartionDate_UnitTo = TRUE
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
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
     ;


     -- определили
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From END;
     vbWhereObjectId_Analyzer_To:= CASE WHEN vbUnitId_To <> 0 THEN vbUnitId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;
     -- определили
     vbAccountId_GoodsTransit:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110101() ELSE 0 END; -- Транзит + товар в пути


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. определяется для количественного учета
     UPDATE _tmpItem SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
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
                       , ContainerId_GoodsTo   = CASE WHEN _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                                           THEN
                                                 lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner -- по "Дате покупателя"
                                                                                    , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN 0 ELSE vbUnitId_To END
                                                                                    , inCarId                  := NULL
                                                                                    , inMemberId               := vbMemberId_To
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId_To
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                    , inBranchId               := vbBranchId_To
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     )
                                                      ELSE 0 -- !!!если списание!!!
                                                 END
                , ContainerId_GoodsTransit = CASE WHEN vbAccountId_GoodsTransit <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
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
                                                                                , inBranchId               := vbBranchId_From          -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END;
     -- 1.1.2. формируются Проводки для количественного учета - Кому + определяется MIContainer.Id (количественный)
     UPDATE _tmpItem SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId             := 0
                                                                                , inDescId         := zc_MIContainer_Count()
                                                                                , inMovementDescId := vbMovementDescId
                                                                                , inMovementId     := inMovementId
                                                                                , inMovementItemId := _tmpItem.MovementItemId
                                                                                , inParentId       := NULL
                                                                                , inContainerId    := _tmpItem.ContainerId_GoodsTo            -- был опеределен выше
                                                                                , inAccountId               := 0                              -- нет счета
                                                                                , inAnalyzerId              := vbWhereObjectId_Analyzer_From  -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                                                , inObjectId_Analyzer       := _tmpItem.GoodsId               -- Товар
                                                                                , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To    -- Подраделение или...
                                                                                , inContainerId_Analyzer    := _tmpItem.ContainerId_GoodsFrom -- количественный Контейнер-Корреспондент (т.е. из расхода)
                                                                                , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId           -- вид товара
                                                                                , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From  -- Подраделение "От кого"
                                                                                , inAmount         := CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                                THEN _tmpItem.OperCount -- !!!количество ушло!!!
                                                                                                           ELSE _tmpItem.OperCount_Partner -- !!!количество пришло!!!
                                                                                                      END
                                                                                , inOperDate       := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                , inIsActive       := TRUE
                                                                                 )
     WHERE _tmpItem.isLossMaterials = FALSE; -- !!!если НЕ списание!!!

     -- 1.1.3. формируются Проводки для количественного учета - От кого, здесь -- !!!количество ушло!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_GoodsFrom          AS ContainerId
            , 0                                       AS AccountId              -- нет счета
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem.ContainerId_GoodsTo            AS ContainerId_Analyzer   -- количественный Контейнер-Корреспондент (т.е. из прихода)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , MIContainerId_To                        AS ParentId
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate               -- по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItem
       -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
       -- WHERE OperCount <> 0
       WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsTransit
            , vbAccountId_GoodsTransit                AS AccountId              -- есть счет (т.е. в отчетах определяется "транзит")
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE _tmpItem.ContainerId_GoodsTo END AS ContainerId_Analyzer -- т.е. в перемещение попадет "реальная" за vbOperDatePartner
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , NULL                                    AS ParentId               -- !!!т.е. не будут привязаны к "приходу"!!!
            , _tmpItem.OperCount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit <> 0
                               AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!

      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_GoodsFrom       AS ContainerId
            , 0                                    AS AccountId              -- нет счета
            , zc_Enum_AnalyzerId_LossCount_20200() AS AnalyzerId             -- Кол-во, списание при реализации/перемещении по цене
            , _tmpItem.GoodsId                     AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From        AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                    AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                 AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To          AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , MIContainerId_To                     AS ParentId
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
      INSERT INTO _tmpItemSumm (MovementItemId, isLossMaterials, isRestoreAccount_60000, MIContainerId_To, ContainerId_Transit, ContainerId_To, AccountId_To, ContainerId_ProfitLoss_20200, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_60000, AccountId_60000, ContainerId_From, AccountId_From, InfoMoneyId_From, InfoMoneyId_Detail_From, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, OperSumm_Account_60000)
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.isLossMaterials
            , CASE WHEN ContainerLinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_80401()       -- прибыль текущего периода
                     OR ContainerLinkObject_InfoMoneyDetail.ObjectId = zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                        THEN TRUE
                   ELSE FALSE
              END AS isRestoreAccount_60000
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_Transit -- Счет Транзит, определим позже
            , 0 AS ContainerId_To
            , 0 AS AccountId_To
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
                        THEN SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                                + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                            THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                       ELSE 0
                                  END)
                   ELSE SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) -- ABS
                           + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) >= -1 * HistoryCost.Summ_diff
                                       THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                  ELSE 0
                             END)

              END AS OperSumm
              -- с/с2 - для количества с учетом % скидки
            , SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                         AND ContainerLinkObject_InfoMoneyDetail.ObjectId <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                             THEN CAST (_tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) -- ABS
                        ELSE 0
                   END) AS OperSumm_ChangePercent
              -- с/с3 - для количества контрагента
            , SUM (CASE WHEN ContainerLinkObject_InfoMoney.ObjectId       <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                         AND ContainerLinkObject_InfoMoneyDetail.ObjectId <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                             THEN CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) -- ABS
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
                             THEN (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))
                        ELSE 0
                   END
                 ) AS OperSumm_Account_60000*/
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
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND (ContainerLinkObject_InfoMoneyDetail.ObjectId = 0 OR zc_isHistoryCost_byInfoMoneyDetail()= TRUE)
          --!!!AND (inIsLastComplete = FALSE OR (_tmpItem.OperCount * HistoryCost.Price) <> 0) -- !!!ОБЯЗАТЕЛЬНО!!! вставляем нули если это не последний раз (они нужны для расчета с/с)
           AND _tmpItem.OperCount * HistoryCost.Price <> 0
          -- AND ((ContainerLinkObject_InfoMoney.ObjectId <> zc_Enum_InfoMoney_80401()        -- + для этой
          --   AND ContainerLinkObject_InfoMoneyDetail.ObjectId <> zc_Enum_InfoMoney_80401()) -- + УП = прибыль текущего периода
          --   OR (_tmpItem.OperCount * HistoryCost.Price) <> 0                               -- + вставлять нули !!!НЕ надо!!!
          --     )
          AND vbIsHistoryCost= TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.isLossMaterials
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , ContainerLinkObject_InfoMoney.ObjectId
               , ContainerLinkObject_InfoMoneyDetail.ObjectId;

     -- 1.2.2. определяется ContainerId - Транзит, !!!обязательно перед 1.2.3.!!!
     UPDATE _tmpItemSumm SET ContainerId_Transit = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                     , inUnitId                 := CLO_Unit.ObjectId
                                                                                     , inCarId                  := CLO_Car.ObjectId
                                                                                     , inMemberId               := CLO_Member.ObjectId
                                                                                     , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                     , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                     , inBusinessId             := CLO_Business.ObjectId
                                                                                     , inAccountId              := vbAccountId_GoodsTransit -- !!!для счета Транзит!!!
                                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                     , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                     , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                     , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit -- Счет - кол-во Транзит
                                                                                     , inGoodsId                := CLO_Goods.ObjectId
                                                                                     , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                     , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                     , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                     , inAssetId                := CLO_Asset.ObjectId
                                                                                      )
     FROM _tmpItem
          INNER JOIN _tmpItemSumm AS _tmpItemSumm_find ON _tmpItemSumm_find.MovementItemId = _tmpItem.MovementItemId
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
     WHERE _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
       AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
       AND vbAccountId_GoodsTransit <> 0
    ;

     -- 1.2.3. самое интересное-2: заполняем таблицу - суммовые элементы документа, для счета "Прибыль будущих периодов"
     INSERT INTO _tmpItemSumm (MovementItemId, isLossMaterials, isRestoreAccount_60000, MIContainerId_To, ContainerId_Transit, ContainerId_To, AccountId_To, ContainerId_ProfitLoss_20200, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_60000, AccountId_60000, ContainerId_From, AccountId_From, InfoMoneyId_From, InfoMoneyId_Detail_From, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, OperSumm_Account_60000)
        SELECT
              _tmpItem.MovementItemId
            , FALSE AS isLossMaterials
            , FALSE AS isRestoreAccount_60000
            , 0 AS MIContainerId_To
            , 0 AS ContainerId_Transit -- Счет Транзит, не будет использоваться
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
            , _tmpItem.OperSumm_Partner_ChangePercent - COALESCE (_tmpItemSumm_group.OperSumm_Partner, 0) AS OperSumm_Account_60000
        FROM _tmpItem
             LEFT JOIN (SELECT _tmpItemSumm.MovementItemId, SUM (_tmpItemSumm.OperSumm_Partner) AS OperSumm_Partner
                        FROM _tmpItemSumm
                        GROUP BY _tmpItemSumm.MovementItemId
                       ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem.MovementItemId
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
          AND (vbBranchId_From = 0                  -- + только если
            OR vbBranchId_From = zc_Branch_Basis()) -- + со склада на филиал
       ;

     -- 1.2.4. !!!Проверка - в этом случае корреспонденция между с/с и Прибыль будущих периодов должна быть одинаковой
     IF EXISTS (SELECT MovementItemId FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE GROUP BY MovementItemId HAVING SUM (OperSumm) <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Проверка 1.2.3. <%>', (SELECT MAX (ContainerId_From) FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE AND MovementItemId IN (SELECT MovementItemId FROM _tmpItemSumm WHERE isRestoreAccount_60000 = TRUE GROUP BY MovementItemId HAVING SUM (OperSumm) <> 0));
     END IF;


     -- 1.3.1. определяется Счет для проводок по суммовому учету - Кому
     UPDATE _tmpItemSumm SET AccountId_To = _tmpItem_byAccount.AccountId_To
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                  , inAccountDirectionId     := vbAccountDirectionId_To
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := inUserId
                                                   ) AS AccountId_To
                     , _tmpItem_group.InfoMoneyDestinationId
                FROM (SELECT _tmpItem.InfoMoneyDestinationId
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
                        AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                      GROUP BY _tmpItem.InfoMoneyDestinationId
                             , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                    ELSE _tmpItem.InfoMoneyDestinationId
                               END
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 1.3.2. определяется ContainerId для проводок по суммовому учету - Кому  + формируется Аналитика <элемент с/с>
     UPDATE _tmpItemSumm SET ContainerId_To = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDatePartner -- по "Дате покупателя"
                                                                                , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN 0 ELSE vbUnitId_To END
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inBranchId               := vbBranchId_To
                                                                                , inJuridicalId_basis      := vbJuridicalId_Basis_To
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
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.isLossMaterials = FALSE -- !!!так отбрасывается то что попадает в списание!!!
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 1.3.3. формируются Проводки для суммового учета - Кому + определяется MIContainer.Id
     UPDATE _tmpItemSumm SET MIContainerId_To = lpInsertUpdate_MovementItemContainer (ioId:= 0
                                                                                    , inDescId         := zc_MIContainer_Summ()
                                                                                    , inMovementDescId := vbMovementDescId
                                                                                    , inMovementId     := inMovementId
                                                                                    , inMovementItemId := _tmpItem.MovementItemId
                                                                                    , inParentId       := NULL
                                                                                    , inContainerId    := _tmpItemSumm.ContainerId_To
                                                                                    , inAccountId               := _tmpItemSumm.AccountId_To     -- счет есть всегда
                                                                                    , inAnalyzerId              := vbWhereObjectId_Analyzer_From -- нет аналитики, но для ускорения отчетов будет Подраделение "От кого" или...
                                                                                    , inObjectId_Analyzer       := _tmpItem.GoodsId              -- Товар
                                                                                    , inWhereObjectId_Analyzer  := vbWhereObjectId_Analyzer_To   -- Подраделение или...
                                                                                    , inContainerId_Analyzer    := _tmpItemSumm.ContainerId_From -- суммовой Контейнер-Корреспондент (т.е. из расхода)
                                                                                    , inObjectIntId_Analyzer    := _tmpItem.GoodsKindId          -- вид товара
                                                                                    , inObjectExtId_Analyzer    := vbWhereObjectId_Analyzer_From -- Подраделение "От кого"
                                                                                    , inAmount         := _tmpItemSumm.OperSumm_Partner + _tmpItemSumm.OperSumm_Account_60000
                                                                                    , inOperDate       := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                    , inIsActive       := TRUE
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.isLossMaterials = FALSE -- !!!так отбрасывается то что попадает в списание!!!
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;


     -- 1.4. формируются Проводки для суммового учета - От кого
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
           , _tmpItemSumm.ContainerId_From            AS ContainerId
            , _tmpItemSumm.AccountId_From             AS AccountId              -- счет есть всегда
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm.ContainerId_To             AS ContainerId_Analyzer   -- суммовой Контейнер-Мастер (т.е. из прихода)
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
           , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так =0
           , -1 * _tmpItemSumm.OperSumm
           , vbOperDate -- по "Дате склад"
           , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItemSumm.ContainerId_From <> 0 -- !!без "самое интересное-2"!!
         AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!

      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
           , _tmpItemSumm.ContainerId_From            AS ContainerId
            , _tmpItemSumm.AccountId_From             AS AccountId              -- счет есть всегда
            , zc_Enum_AnalyzerId_LossSumm_20200()     AS AnalyzerId             -- Сумма с/с, списание при реализации/перемещении по цене
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
           , CASE WHEN _tmpItemSumm.isLossMaterials = TRUE OR _tmpItemSumm.isRestoreAccount_60000 = TRUE THEN 0 ELSE _tmpItemSumm.MIContainerId_To END AS ParentId -- хотя он здесь и так =0
           , -1 * _tmpItemSumm.OperSumm
           , vbOperDate  -- по "Дате склад"
           , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItemSumm.ContainerId_From <> 0 -- !!без "самое интересное-2"!!
         AND _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId_Transit        AS ContainerId
            , vbAccountId_GoodsTransit                AS AccountId              -- есть счет (т.е. в отчетах определяется "транзит")
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- нет аналитики, но для ускорения отчетов будет Подраделение "Кому" или... (даже для "виртуальной")
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Подраделение или...
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE _tmpItemSumm.ContainerId_To END AS ContainerId_Analyzer -- т.е. в перемещение попадет "реальная" за vbOperDatePartner
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , NULL                                    AS ParentId               -- !!!т.е. не будут привязаны к "приходу"!!!
            , _tmpItemSumm.OperSumm * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit <> 0
                               AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            INNER JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                                   AND _tmpItemSumm.ContainerId_Transit > 0 -- !!!т.е. без "самое интересное-2"!!
      ;



     -- 2.1.1. создаем контейнеры Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
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
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  zc_Enum_ProfitLossGroup_20000()     AS ProfitLossGroupId     -- Общепроизводственные расходы
                       , zc_Enum_ProfitLossDirection_20200() AS ProfitLossDirectionId -- Содержание складов
                       , _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                 FROM _tmpItem
                 WHERE _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 2.1.2. создаем контейнеры для Проводки - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
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
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                 FROM _tmpItem
                 WHERE _tmpItem.isLossMaterials = FALSE
                   AND _tmpItem.OperCount_ChangePercent <> _tmpItem.OperCount_Partner
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;

     -- 2.1.3. создаем контейнеры для Проводки - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
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
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                       , _tmpItem.BusinessId_From
                 FROM _tmpItem
                 WHERE _tmpItem.isLossMaterials = FALSE
                   AND _tmpItem.OperCount <> _tmpItem.OperCount_ChangePercent
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.isRestoreAccount_60000 = FALSE;


     -- 2.2. формируются Проводки - Прибыль (Себестоимость)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
           , _tmpItem_group.ContainerId_ProfitLoss
           , zc_Enum_Account_100301 ()                AS AccountId              -- прибыль текущего периода
            , vbWhereObjectId_Analyzer_To             AS AnalyzerId             -- !!!нет!!!, но для ускорения отчетов будет Подраделение "Кому" или...
           , _tmpItem_group.GoodsId                   AS ObjectId_Analyzer      -- Товар
           , vbWhereObjectId_Analyzer_From            AS WhereObjectId_Analyzer -- Подраделение или...
           , 0                                        AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_To             AS ObjectExtId_Analyzer   -- Подраделение "Кому"
           , 0                                        AS ParentId
           , _tmpItem_group.OperSumm
           , vbOperDate
           , FALSE
       FROM  -- Проводки по списанию
            (SELECT _tmpItemSumm.ContainerId_ProfitLoss_20200 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.MovementItemId
                  , _tmpItem.GoodsId                 AS GoodsId
                  , _tmpItem.GoodsKindId             AS GoodsKindId
                  , 0                                AS AnalyzerId -- !!!нет!!!
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItemSumm.ContainerId_ProfitLoss_20200 <> 0 -- !!!если списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_20200
                    , _tmpItemSumm.MovementItemId
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            UNION ALL
             -- Проводки по разнице в весе : с/с2 - с/с3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.MovementItemId
                  , _tmpItem.GoodsId                 AS GoodsId
                  , _tmpItem.GoodsKindId             AS GoodsKindId
                  , 0                                AS AnalyzerId -- !!!нет!!!
                  , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItemSumm.ContainerId_ProfitLoss_40208 <> 0
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208
                    , _tmpItemSumm.MovementItemId
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            UNION ALL
             -- Проводки по скидкам в весе : с/с1 - с/с2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                    , _tmpItemSumm.MovementItemId
                  , _tmpItem.GoodsId                 AS GoodsId
                  , _tmpItem.GoodsKindId             AS GoodsKindId
                  , 0                                AS AnalyzerId -- !!!нет!!!
                    , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItemSumm.ContainerId_ProfitLoss_10500 <> 0
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10500
                    , _tmpItemSumm.MovementItemId
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       ;


     -- 3.1. определяется Счет для проводок по "Прибыль будущих периодов"
     UPDATE _tmpItemSumm SET AccountId_60000 = _tmpItem_byAccount.AccountId
     FROM _tmpItem
          JOIN (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000() -- Прибыль будущих периодов -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_60000()
                                                  , inAccountDirectionId     := CASE WHEN vbMemberId_To <> 0
                                                                                          THEN zc_Enum_AccountDirection_60100() -- "Прибыль будущих периодов"; 60100; "сотрудники (экспедиторы)"
                                                                                     ELSE zc_Enum_AccountDirection_60200() -- "Прибыль будущих периодов"; 60200; "на филиалах"
                                                                                END
                                                  , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                  , inInfoMoneyId            := NULL
                                                  , inUserId                 := inUserId
                                                   ) AS AccountId
                     , _tmpItem_group.InfoMoneyDestinationId
                FROM (SELECT _tmpItem.InfoMoneyDestinationId
                           , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                    OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                    OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                  WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                       THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                  ELSE _tmpItem.InfoMoneyDestinationId
                             END AS InfoMoneyDestinationId_calc
                      FROM _tmpItem
                      WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                      GROUP BY _tmpItem.InfoMoneyDestinationId
                             , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                      OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                      OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                         THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                    ELSE _tmpItem.InfoMoneyDestinationId
                               END
                     ) AS _tmpItem_group
               ) AS _tmpItem_byAccount ON _tmpItem_byAccount.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId 
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       AND _tmpItemSumm.OperSumm_Account_60000 <> 0;


     -- 3.2. определяется ContainerId для проводок по "Прибыль будущих периодов"
     UPDATE _tmpItemSumm SET ContainerId_60000 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                   , inUnitId                 := CASE WHEN vbMemberId_To <> 0 THEN 0 ELSE vbUnitId_To END
                                                                                   , inCarId                  := NULL
                                                                                   , inMemberId               := vbMemberId_To
                                                                                   , inBranchId               := vbBranchId_To
                                                                                   , inJuridicalId_basis      := vbJuridicalId_Basis_To
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
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
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
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , _tmpItemSumm_group.GoodsKindId          AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer_From           AS ObjectExtId_Analyzer   -- Подраделение "Кому"
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm_group.OperSumm
            , vbOperDatePartner                       AS OperDate -- !!!по "Дате покупателя"!!!
            , CASE WHEN vbBranchId_From = 0 OR vbBranchId_From = zc_Branch_Basis() THEN TRUE ELSE FALSE END AS isActive
       FROM (SELECT _tmpItemSumm.ContainerId_60000 AS ContainerId, _tmpItemSumm.AccountId_60000 AS AccountId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, (_tmpItemSumm.OperSumm_Account_60000) AS OperSumm
                  , _tmpItemSumm.MovementItemId
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             WHERE _tmpItemSumm.OperSumm_Account_60000 <> 0
            ) AS _tmpItemSumm_group
     ;


     -- !!!не всегда Проводки для отчета!!!
     IF vbIsHistoryCost = TRUE
     THEN

     -- 5.1. формируются Проводки для отчета (Счета: Товар(с/с, от кого) <-> ОПиУ(Общепроизводственные расходы + Содержание складов Прочие материалы))
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
                                                      --, inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                      --, inContainerId_1      := tmpMIReport.ContainerId_Kind
                                                      --, inAccountId_1        := tmpMIReport.AccountId_Kind
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , vbOperDate AS OperDate -- по "Дате склад"
              FROM (SELECT ABS (tmpCalc.OperSumm) AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_ProfitLoss ELSE tmpCalc.ContainerId_From       END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_From       ELSE tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_ProfitLoss   ELSE tmpCalc.AccountId_From         END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_From         ELSE tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To         ELSE tmpCalc.ContainerId_To         END AS ContainerId_Kind
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To           ELSE tmpCalc.AccountId_To           END AS AccountId_Kind
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm.MovementItemId
                               , _tmpItemSumm.ContainerId_From
                               , _tmpItemSumm.AccountId_From
                               , _tmpItemSumm.ContainerId_To
                               , _tmpItemSumm.AccountId_To
                               , _tmpItemSumm.ContainerId_ProfitLoss_20200 AS ContainerId_ProfitLoss
                               , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                               , (_tmpItemSumm.OperSumm) AS OperSumm
                          FROM _tmpItemSumm
                          WHERE _tmpItemSumm.isLossMaterials = TRUE -- !!!если списание!!!
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     -- 5.2.1. формируются Проводки для отчета (Счета: Товар(с/с, от кого) <-> ОПиУ(разница в весе))
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
                                                      , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                      , inContainerId_1      := tmpMIReport.ContainerId_Kind
                                                      , inAccountId_1        := tmpMIReport.AccountId_Kind
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , vbOperDate AS OperDate -- по "Дате склад"
              FROM (SELECT ABS (tmpCalc.OperSumm) AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_ProfitLoss ELSE tmpCalc.ContainerId_From       END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_From       ELSE tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_ProfitLoss   ELSE tmpCalc.AccountId_From         END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_From         ELSE tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To         ELSE tmpCalc.ContainerId_To         END AS ContainerId_Kind
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To           ELSE tmpCalc.AccountId_To           END AS AccountId_Kind
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm.MovementItemId
                               , _tmpItemSumm.ContainerId_From
                               , _tmpItemSumm.AccountId_From
                               , _tmpItemSumm.ContainerId_To
                               , _tmpItemSumm.AccountId_To
                               , _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                               , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                               , (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!если>0, значит товар-кредит, т.е. у покупателя меньше чем отгрузка!!!
                          FROM _tmpItemSumm
                          WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                            AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     -- 5.2.2. формируются Проводки для отчета (Счета: Товар(с/с, от кого) <-> ОПиУ(скидка в весе))
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
                                                      , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                      , inContainerId_1      := tmpMIReport.ContainerId_Kind
                                                      , inAccountId_1        := tmpMIReport.AccountId_Kind
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , vbOperDate AS OperDate -- по "Дате склад"
              FROM (SELECT ABS (tmpCalc.OperSumm) AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_ProfitLoss ELSE tmpCalc.ContainerId_From       END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_From       ELSE tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_ProfitLoss   ELSE tmpCalc.AccountId_From         END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_From         ELSE tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To         ELSE tmpCalc.ContainerId_To         END AS ContainerId_Kind
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To           ELSE tmpCalc.AccountId_To           END AS AccountId_Kind
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm.MovementItemId
                               , _tmpItemSumm.ContainerId_From
                               , _tmpItemSumm.AccountId_From
                               , _tmpItemSumm.ContainerId_To
                               , _tmpItemSumm.AccountId_To
                               , _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                               , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                               , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm -- !!!по идее >0, значит товар-кредит!!!
                          FROM _tmpItemSumm
                          WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                            AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     -- 5.3. формируются Проводки для отчета (Счета: Товар(с/с, от кого) <-> Товар(с/с, кому))
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
                                                      --, inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                      --, inContainerId_1      := tmpMIReport.ContainerId_Kind
                                                      --, inAccountId_1        := tmpMIReport.AccountId_Kind
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , tmpMIReport.OperDate AS OperDate
              FROM (SELECT ABS (tmpCalc.OperSumm) AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To   ELSE tmpCalc.ContainerId_From END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_From ELSE tmpCalc.ContainerId_To   END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To     ELSE tmpCalc.AccountId_From   END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_From   ELSE tmpCalc.AccountId_To     END AS PassiveAccountId
                         -- , tmpCalc.ContainerId_60000 AS ContainerId_Kind
                         -- , tmpCalc.AccountId_60000 AS AccountId_Kind
                         , tmpCalc.MovementItemId
                         , tmpCalc.OperDate
                    FROM (SELECT tmpCalc.MovementItemId
                               , tmpOperDate.OperDate
                               , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN tmpCalc.ContainerId_From ELSE tmpCalc.ContainerId_Transit END AS ContainerId_From
                               , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN tmpCalc.AccountId_From   ELSE tmpCalc.AccountId_Transit   END AS AccountId_From
                               , CASE WHEN tmpOperDate.OperDate = vbOperDate AND tmpCalc.ContainerId_Transit <> 0 THEN tmpCalc.ContainerId_Transit ELSE tmpCalc.ContainerId_To END AS ContainerId_To
                               , CASE WHEN tmpOperDate.OperDate = vbOperDate AND tmpCalc.ContainerId_Transit <> 0 THEN tmpCalc.AccountId_Transit   ELSE tmpCalc.AccountId_To   END AS AccountId_To
                               , tmpCalc.OperSumm
                          FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                               ) AS tmpOperDate
                               INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                                , _tmpItemSumm.ContainerId_From
                                                , _tmpItemSumm.AccountId_From
                                                , _tmpItemSumm.ContainerId_To
                                                , _tmpItemSumm.AccountId_To
                                                , _tmpItemSumm.ContainerId_60000
                                                , _tmpItemSumm.AccountId_60000
                                                , _tmpItemSumm.AccountId_60000
                                                , _tmpItemSumm.ContainerId_Transit AS ContainerId_Transit
                                                , vbAccountId_GoodsTransit         AS AccountId_Transit
                                                , (_tmpItemSumm.OperSumm_Partner)  AS OperSumm -- !!!по идее >0, значит товар-кредит!!!
                                           FROM _tmpItemSumm
                                           WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                             AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
                                          ) AS tmpCalc ON tmpCalc.OperSumm <> 0
                         ) AS tmpCalc
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;


     -- 5.4. формируются Проводки для отчета (Счета: Прибыль будущих периодов <-> Товар(с/с, кому))
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
                                                      --, inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                      --, inContainerId_1      := tmpMIReport.ContainerId_Kind
                                                      --, inAccountId_1        := tmpMIReport.AccountId_Kind
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , vbOperDatePartner    AS OperDate -- !!!по "Дате покупателя"!!!
              FROM (SELECT ABS (tmpCalc.OperSumm) AS OperSumm
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_To    ELSE tmpCalc.ContainerId_60000 END AS ActiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.ContainerId_60000 ELSE tmpCalc.ContainerId_To    END AS PassiveContainerId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_To      ELSE tmpCalc.AccountId_60000   END AS ActiveAccountId
                         , CASE WHEN tmpCalc.OperSumm > 0 THEN tmpCalc.AccountId_60000   ELSE tmpCalc.AccountId_To      END AS PassiveAccountId
                         , tmpCalc.ContainerId_From AS ContainerId_Kind
                         , tmpCalc.AccountId_From   AS AccountId_Kind
                         , tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm.MovementItemId
                               , _tmpItemSumm.ContainerId_From
                               , _tmpItemSumm.AccountId_From
                               , _tmpItemSumm.ContainerId_To
                               , _tmpItemSumm.AccountId_To
                               , _tmpItemSumm.ContainerId_60000
                               , _tmpItemSumm.AccountId_60000
                               , (_tmpItemSumm.OperSumm_Account_60000) AS OperSumm -- !!!по идее >0, значит товар-кредит!!!
                          FROM _tmpItemSumm
                          WHERE _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                            AND _tmpItemSumm.isRestoreAccount_60000 = FALSE
                         ) AS tmpCalc
                    WHERE tmpCalc.OperSumm <> 0
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     -- 5.5. формируются Проводки для отчета (Счета: Прибыль будущих периодов <-> Прибыль будущих периодов)
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
                                                      --, inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                      --, inContainerId_1      := tmpMIReport.ContainerId_Kind
                                                      --, inAccountId_1        := tmpMIReport.AccountId_Kind
                                                       ) AS ChildReportContainerId
                   , tmpMIReport.OperSumm AS Amount
                   , vbOperDate           AS OperDate -- т.е. по "Дате склад"
              FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                         , MAX (CASE WHEN _tmpCalc.OperSumm > 0 THEN 0                          ELSE _tmpCalc.ContainerId_From END) AS ActiveContainerId
                         , MAX (CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_From  ELSE 0                         END) AS PassiveContainerId
                         , MAX (CASE WHEN _tmpCalc.OperSumm > 0 THEN 0                          ELSE _tmpCalc.AccountId_From   END) AS ActiveAccountId
                         , MAX (CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_From    ELSE 0                         END) AS PassiveAccountId
                         , _tmpCalc.MovementItemId
                    FROM (SELECT _tmpItemSumm.MovementItemId
                               , _tmpItemSumm.ContainerId_From
                               , _tmpItemSumm.AccountId_From
                               , (_tmpItemSumm.OperSumm) AS OperSumm
                          FROM _tmpItemSumm
                          WHERE _tmpItemSumm.isRestoreAccount_60000 = TRUE
                         ) AS _tmpCalc
                    WHERE _tmpCalc.OperSumm <> 0
                    GROUP BY ABS (_tmpCalc.OperSumm)
                           , _tmpCalc.MovementItemId
                   ) AS tmpMIReport
             ) AS tmpMIReport
       ;

     END IF; -- if vbIsHistoryCost = TRUE -- !!!не всегда Проводки для отчета!!!

     -- !!!6.0. формируется свойство <Спец. алгоритм для расчета с/с (да/нет)>!!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_HistoryCost(), inMovementId, CASE WHEN vbBranchId_From = 0 OR vbBranchId_From = zc_Branch_Basis() THEN TRUE ELSE FALSE END);


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
-- SELECT * FROM lpComplete_Movement_SendOnPrice (inMovementId:= 3313, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3313, inSession:= '2')
