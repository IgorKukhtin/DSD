-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
 RETURNS VOID
--  RETURNS TABLE (OperSumm_Partner_byItem TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent_byItem TFloat, OperSumm_Partner_ChangePercent TFloat, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat, ExtraChargesPercent TFloat, UnitId_From Integer, PersonalId_From Integer, BranchId_From Integer, AccountDirectionId_From Integer, isPartionDate Boolean, JuridicalId_To Integer, IsCorporate Boolean, PersonalId_To Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, InfoMoneyDestinationId_Contract Integer, InfoMoneyId_Contract Integer, PaidKindId Integer, ContractId Integer, JuridicalId_basis Integer)
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, OperCount TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat, AccountId_Partner Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;

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
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbIsCorporate_To Boolean;
  DECLARE vbInfoMoneyId_CorporateTo Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbBusinessId_From Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());

     -- Эти параметры нужны для 
     SELECT lfObject_PriceList.PriceWithVAT, lfObject_PriceList.VATPercent
       INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList
     FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfObject_PriceList;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDate -- Movement.OperDate
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Branch.ChildObjectId ELSE 0 END, 0) AS BranchId_From
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- Аналитики счетов - направления !!!нужны только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
          , CASE WHEN ObjectLink_Juridical_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20801() -- Алан
                                                                     , zc_Enum_InfoMoney_20901() -- Ирна
                                                                     , zc_Enum_InfoMoney_21001() -- Чапли
                                                                     , zc_Enum_InfoMoney_21101() -- Дворкин
                                                                     , zc_Enum_InfoMoney_21151() -- ЕКСПЕРТ-АГРОТРЕЙД
                                                                      )
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
            END AS isCorporate_To
          , CASE WHEN ObjectLink_Juridical_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20801() -- Алан
                                                                     , zc_Enum_InfoMoney_20901() -- Ирна
                                                                     , zc_Enum_InfoMoney_21001() -- Чапли
                                                                     , zc_Enum_InfoMoney_21101() -- Дворкин
                                                                     , zc_Enum_InfoMoney_21151() -- ЕКСПЕРТ-АГРОТРЕЙД
                                                                      )
                      THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                 ELSE 0
            END AS InfoMoneyId_CorporateTo
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN Object_To.Id WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To

            -- УП Статью назначения берем: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_From

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbOperDate, vbOperDatePartner
               , vbUnitId_From, vbMemberId_From, vbBranchId_From, vbAccountDirectionId_From, vbIsPartionDate_Unit
               , vbJuridicalId_To, vbIsCorporate_To, vbInfoMoneyId_CorporateTo, vbPartnerId_To , vbMemberId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
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
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                  ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
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

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Member
                               ON ObjectLink_PersonalTo_Member.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PersonalTo_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_Sale()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках (для Покупателя)
     SELECT lfObject_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS lfObject_InfoMoney;

     -- !!!Если нет филиала для "основной деятельности", тогда это "главный филиал"
     IF vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                      , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                       )
        AND vbBranchId_From = 0
     THEN
         vbBranchId_From:= zc_Branch_Basis();
     END IF;


     -- таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     CREATE TEMP TABLE _tmp___ (Id Integer) ON COMMIT DROP;
     -- таблица - Аналитики остатка
     CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- таблица - Аналитики <элемент с/с>
     CREATE TEMP TABLE _tmpObjectCost (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- таблица - Аналитики <Проводки для отчета>
     CREATE TEMP TABLE _tmpChildReportContainer (AccountKindId Integer, ContainerId Integer, AccountId Integer) ON COMMIT DROP;
     -- таблица - 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_ProfitLoss_10400 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                               , ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10200 Integer, ContainerId_ProfitLoss_10300 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isLossMaterials Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_GoodsPartner, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate
                         , OperCount, OperCount_ChangePercent, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_Partner, OperSumm_Partner, OperSumm_Partner_ChangePercent
                         , ContainerId_ProfitLoss_10100, ContainerId_ProfitLoss_10200, ContainerId_ProfitLoss_10300
                         , ContainerId_Partner, AccountId_Partner, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From
                         , isPartionCount, isPartionSumm, isTareReturning, isLossMaterials
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_GoodsPartner
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

              -- Счет - прибыль (ОПиУ - Сумма реализации)
            , 0 AS ContainerId_ProfitLoss_10100
              -- Счет - прибыль (ОПиУ - Скидка по акциям)
            , 0 AS ContainerId_ProfitLoss_10200
              -- Счет - прибыль (ОПиУ - Скидка дополнительная)
            , 0 AS ContainerId_ProfitLoss_10300

              -- Счет - долг Контрагента
            , 0 AS ContainerId_Partner
              -- Счет(справочника) Контрагента
            , 0 AS AccountId_Partner 
              -- Счет - долг Транзит
            , 0 AS ContainerId_Transit
              -- Счет(справочника) Транзит
            , 0 AS AccountId_Transit
              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

              -- значение Бизнес !!!выбирается!!! из Товара или Подраделения/Сотрудника
            , CASE WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 

              -- Возвратная ли это тара (если да, себестоимость остается на остатке)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- Списание Прочее сырье ли это (если да, ничего не делаем для проводок по суммам, потом это будет документ Списание)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20600() -- 10200; "Прочее сырье"
                        THEN TRUE
                   ELSE FALSE
              END AS isLossMaterials

              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId

        FROM 
             (SELECT
                    MovementItem.Id AS MovementItemId

                  , MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
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
                  , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

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
                   LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                   LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate)
                          AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Sale()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp;


     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE)
                                         -- OR !!! НАЛ !!!
                                           )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- Расчеты сумм
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
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- "Запасы"; 20200; "на складах"
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)
                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "Доходы"; 30100; "Продукция"
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- "Основное сырье"; 10100; "Мясное сырье"
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- "Доходы"; 30100; "Продукция"
     ;


     -- для теста - Заголовок
     -- RETURN QUERY SELECT CAST (vbOperSumm_Partner_byItem AS TFloat) AS OperSumm_Partner_byItem, CAST (vbOperSumm_Partner AS TFloat) AS OperSumm_Partner, CAST (vbOperSumm_Partner_ChangePercent_byItem AS TFloat) AS OperSumm_Partner_ChangePercent_byItem, CAST (vbOperSumm_Partner_ChangePercent AS TFloat) AS OperSumm_Partner_ChangePercent, CAST (vbPriceWithVAT AS Boolean) AS PriceWithVAT, CAST (vbVATPercent AS TFloat) AS VATPercent, CAST (vbDiscountPercent AS TFloat) AS DiscountPercent, CAST (vbExtraChargesPercent AS TFloat) AS ExtraChargesPercent, CAST (vbUnitId_From AS Integer) AS UnitId_From, CAST (vbMemberId_From AS Integer) AS PersonalId_From, CAST (vbBranchId_From AS Integer) AS BranchId_From, CAST (vbAccountDirectionId_From AS Integer) AS AccountDirectionId_From, CAST (vbIsPartionDate_Unit AS Boolean) AS isPartionDate, CAST (vbJuridicalId_To AS Integer) AS JuridicalId_To, CAST (vbIsCorporate_To AS Boolean) AS IsCorporate_To, CAST (vbMemberId_To AS Integer) AS PersonalId_To, CAST (vbInfoMoneyDestinationId_isCorporate AS Integer) AS InfoMoneyDestinationId_isCorporate, CAST (vbInfoMoneyId_isCorporate AS Integer) AS InfoMoneyId_isCorporate, CAST (vbInfoMoneyDestinationId_Contract AS Integer) AS InfoMoneyDestinationId_Contract, CAST (vbInfoMoneyId_Contract AS Integer) AS InfoMoneyId_Contract, CAST (vbPaidKindId AS Integer) AS PaidKindId, CAST (vbContractId AS Integer) AS ContractId, CAST (vbJuridicalId_Basis_From AS Integer) AS JuridicalId_Basis_From;
     -- для теста
     -- RETURN QUERY SELECT _tmpItem.MovementItemId, inMovementId, vbOperDate, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.PartionGoodsDate, _tmpItem.OperCount, _tmpItem.tmpOperSumm_PriceList, _tmpItem.OperSumm_PriceList, _tmpItem.tmpOperSumm_Partner, _tmpItem.OperSumm_Partner, _tmpItem.OperSumm_Partner_ChangePercent, _tmpItem.AccountId_Partner, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId_From, _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.PartionGoodsId FROM _tmpItem;
     -- return;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1.1. определяется ContainerId_GoodsPartner для проводки по количественному учету - долги Покупателя или Физ.лица
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)Товар 1)Покупатель
                                                    -- 0)Товар 1)Физ.лицо
                                                    lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                                          , inParentId          := NULL
                                                                          , inObjectId          := _tmpItem.GoodsId
                                                                          , inJuridicalId_basis := NULL
                                                                          , inBusinessId        := NULL
                                                                          , inObjectCostDescId  := NULL
                                                                          , inObjectCostId      := NULL
                                                                          , inDescId_1          := CASE WHEN vbMemberId_To <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Partner() END
                                                                          , inObjectId_1        := CASE WHEN vbMemberId_To <> 0 THEN vbMemberId_To ELSE vbPartnerId_To END
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0;

     -- 1.1.2. формируются Проводки для количественного учета - долги Покупателя или Физ.лица
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, inMovementId, MovementItemId, ContainerId_GoodsPartner, 0 AS ParentId, OperCount, vbOperDate, TRUE
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0;


     -- 1.2.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                 );
     -- 1.2.2. формируются Проводки для количественного учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, inMovementId, MovementItemId, ContainerId_Goods, 0 AS ParentId, -1 * OperCount, vbOperDate, FALSE
       FROM _tmpItem;
       -- WHERE OperCount <> 0;


     -- 1.2.3. дальше !!!Возвратная тара не учавствует!!!, поэтому удаляем
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;

     -- 1.2.4. дальше !!!Прочее сырье с ценой=0 не учавствует!!!, поэтому удаляем (потом это будет документ Списание))
     DELETE FROM _tmpItem WHERE _tmpItem.isLossMaterials = TRUE;


     -- 1.3.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_ProfitLoss_10400, ContainerId, AccountId, OperSumm, OperSumm_ChangePercent, OperSumm_Partner)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
            , 0 AS ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
            , 0 AS ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId
              -- с/с1 - для количества: расход с остатка
            , SUM (ABS (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0))) AS OperSumm
              -- с/с2 - для количества: с учетом % скидки
            , SUM (ABS (_tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0))) AS OperSumm_ChangePercent
              -- с/с3 - для количества: контрагента
            , SUM (ABS (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0))) AS OperSumm_Partner
        FROM _tmpItem
             -- так находим для тары
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_From
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_From -- !!!пока не понятно с проводками по Бизнесу!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                                                                                 AND _tmpItem.isTareReturning                = FALSE
             -- так находим для остальных
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()
             LEFT JOIN HistoryCost ON HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                -- !!!
            OR _tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, 0) <> 0  -- здесь нули !!!НЕ НУЖНЫ!!! 
            OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0)       -- !!!
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId;

     -- 1.3.2. формируются Проводки для суммового учета : с/с1
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId, 0 AS ParentId, -1 * _tmpItemSumm.OperSumm, vbOperDate, FALSE
       FROM _tmpItemSumm
       WHERE _tmpItemSumm.OperSumm <> 0;


     -- 2.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
                           , ContainerId_ProfitLoss_10500 = _tmpItem_byDestination.ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
                           , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
     FROM _tmpItem
          JOIN
          (SELECT -- для учета разница в весе : с/с2 - с/с3
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_CountChange
                                         ) AS ContainerId_ProfitLoss_40208
                  -- для учета скидки в весе : с/с1 - с/с2
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                         ) AS ContainerId_ProfitLoss_10500
                  -- для учета себестоимости реализации : с/с3
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                         ) AS ContainerId_ProfitLoss_10400
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT -- определяем ProfitLossId - для учета разница в весе : с/с2 - с/с3
                        CASE WHEN vbIsCorporate_To = TRUE
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_40208() -- Содержание филиалов 40208; "Разница в весе"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                  THEN zc_Enum_ProfitLoss_40208() -- Содержание филиалов 40208; "Разница в весе"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId_CountChange

                        -- определяем ProfitLossId - для учета скидки в весе : с/с1 - с/с2
                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10502() -- Скидка за вес 10502; "Ирна"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                  THEN zc_Enum_ProfitLoss_10501() -- Скидка за вес 10501; "Продукция"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                        -- определяем ProfitLossId - для учета себестоимости реализации : с/с3
                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10402() -- Себестоимость реализации 10402; "Ирна"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                  THEN zc_Enum_ProfitLoss_10401() -- Себестоимость реализации 10401; "Продукция"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- 70000; "Дополнительная прибыль"
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                   WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- 70000; "Дополнительная прибыль"
                              END AS ProfitLossGroupId

                            , CASE WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- 70300; "Реализация нашим компаниям"
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossDirection_10400() -- 10400; "Себестоимость реализации"
                                   WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossDirection_10400() -- 10400; "Себестоимость реализации"
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- 70300; "сотрудники (недостачи, порча)"
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- 70200; "Прочее"
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE _tmpItem.InfoMoneyDestinationId END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_From
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                              , _tmpItem.ProfitLossId
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. формируются Проводки - Прибыль (Себестоимость)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- Проводки по разнице в весе : с/с2 - с/с3
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      UNION ALL
       -- Проводки по скидкам в весе : с/с1 - с/с2
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm
             FROM _tmpItemSumm
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10500
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      UNION ALL
       -- Проводки по себестоимости реализации : с/с3
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , SUM (_tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;


     -- 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (недостачи, порча)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
                       , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- Транзит
     FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := vbUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                  THEN zc_Enum_AccountDirection_30600() -- сотрудники (недостачи, порча)  -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30600())
                             WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())
                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- Товары       -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- Ирна         -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- Продукция    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                  THEN zc_Enum_AccountDirection_30100() -- покупатели -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30100())
                            ELSE zc_Enum_AccountDirection_30400() -- Прочие дебиторы select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30400())
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN vbInfoMoneyDestinationId_To -- zc_Enum_InfoMoneyDestination_30100() -- Продукция
                             WHEN vbInfoMoneyDestinationId_To <> 0
                                  THEN vbInfoMoneyDestinationId_To -- -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             ELSE _tmpItem.InfoMoneyDestinationId -- иначе берем по товару
                        END AS InfoMoneyDestinationId_calc

                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30201() -- Алан
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30202() -- Ирна
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30203() -- Чапли
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30204() -- Дворкин
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                        END AS AccountId
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот AccountId в проводках для отчета!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.2. определяется ContainerId для проводок по долг Покупателя или Физ.лица (недостачи, порча)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
                       , ContainerId_Transit = _tmpItem_byInfoMoney.ContainerId_Transit
     FROM (SELECT CASE WHEN vbMemberId_To <> 0
                         OR vbIsCorporate_To = TRUE
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудники(подотчетные лица) 2)NULL 3)NULL 4)Статьи назначения
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := _tmpItem_group.AccountId_Partner
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                       , inBusinessId        := _tmpItem_group.BusinessId_From
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := CASE WHEN vbMemberId_To <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Juridical() END
                                                       , inObjectId_1        := CASE WHEN vbMemberId_To <> 0 THEN vbMemberId_To ELSE vbJuridicalId_To END
                                                       , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_2        := _tmpItem_group.InfoMoneyId_calc
                                                       , inDescId_3          := CASE WHEN vbMemberId_To <> 0 THEN NULL ELSE zc_ContainerLinkObject_Contract() END
                                                       , inObjectId_3        := vbContractId
                                                       , inDescId_4          := CASE WHEN vbMemberId_To <> 0 THEN NULL ELSE zc_ContainerLinkObject_PaidKind() END
                                                       , inObjectId_4        := vbPaidKindId
                                                        )

                            -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Partner
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_group.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_To
                                                  , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_2        := vbPaidKindId
                                                  , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_3        := vbContractId
                                                  , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_4        := _tmpItem_group.InfoMoneyId_calc
                                                   )
                  END AS ContainerId
                , CASE WHEN _tmpItem_group.AccountId_Transit = 0
                            THEN 0
                            -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Transit
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_group.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_To
                                                  , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_2        := vbPaidKindId
                                                  , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_3        := vbContractId
                                                  , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_4        := _tmpItem_group.InfoMoneyId_calc
                                                   )
                  END AS ContainerId_Transit
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.AccountId_Transit
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_From
                      , CASE WHEN vbInfoMoneyId_To <> 0
                                  THEN vbInfoMoneyId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- -- 20901; "Ирна"
                                  THEN zc_Enum_InfoMoney_30101 () -- 30101; "Готовая продукция"
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот ContainerId в проводках для отчета!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.AccountId_Transit
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
     ;

     -- 3.3. формируются Проводки - долг Покупателя или Физ.лица (недостачи, порча)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_Partner, 0 AS ParentId, _tmpItem_group.OperSumm
            , CASE WHEN _tmpItem_group.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , TRUE
       FROM (SELECT _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Transit, SUM (_tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm FROM _tmpItem GROUP BY _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Transit
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_Transit, 0 AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END * _tmpItem_group.OperSumm
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN (SELECT _tmpItem.ContainerId_Transit, SUM (_tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm FROM _tmpItem WHERE _tmpItem.AccountId_Transit <> 0 GROUP BY _tmpItem.ContainerId_Transit
                 ) AS _tmpItem_group ON _tmpItem_group.OperSumm <> 0
     ;


     -- 4.1.1. создаем контейнеры для Проводки - Прибыль (Сумма реализации и Скидка по акциям и Скидка дополнительная)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100
                       , ContainerId_ProfitLoss_10200 = _tmpItem_byDestination.ContainerId_ProfitLoss_10200
                       , ContainerId_ProfitLoss_10300 = _tmpItem_byDestination.ContainerId_ProfitLoss_10300
     FROM (SELECT -- для Сумма реализации
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                         ) AS ContainerId_ProfitLoss_10100
                  -- для Скидка по акциям
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                         ) AS ContainerId_ProfitLoss_10200
                  -- для Скидка дополнительная
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                         ) AS ContainerId_ProfitLoss_10300
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT -- определяем ProfitLossId - для Сумма реализации
                        CASE WHEN vbIsCorporate_To = TRUE
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10102() -- Сумма реализации 10102; "Ирна"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                  THEN zc_Enum_ProfitLoss_10101() -- Сумма реализации 10101; "Продукция"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId_PriceList
                        -- определяем ProfitLossId - для Скидка по акциям
                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10202() -- Скидка по акциям 10202; "Ирна"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                  THEN zc_Enum_ProfitLoss_10201() -- Скидка по акциям 10201; "Продукция"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId_Partner
                        -- определяем ProfitLossId - для Скидка дополнительная
                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN _tmpItem_group.ProfitLossId
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10302() -- Скидка дополнительная 10302; "Ирна"
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                  THEN zc_Enum_ProfitLoss_10301() -- Скидка дополнительная 10301; "Продукция"
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := vbUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT -- здесь !!!тоже!!! что и для с/с (но из с/с нельзя брать т.к. может быть что с/с=0)
                              CASE WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- 70000; "Дополнительная прибыль"
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                   WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- 70000; "Дополнительная прибыль"
                              END AS ProfitLossGroupId

                              -- здесь !!!другое!!! (в THEN) чем для с/с
                            , CASE WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- 70300; "Реализация нашим компаниям"
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossDirection_10100() -- 10100; "Сумма реализации"
                                   WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossDirection_10100() -- 10100; "Сумма реализации"
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- 70300; "сотрудники (недостачи, порча)"
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- 70200; "Прочее"
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE _tmpItem.InfoMoneyDestinationId END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId
                             FROM _tmpItem
                             WHERE _tmpItem.OperSumm_PriceList <> 0 OR _tmpItem.OperSumm_Partner <> 0 OR _tmpItem.OperSumm_Partner_ChangePercent <> 0
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_From
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                              , _tmpItem.ProfitLossId
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId;

     -- 4.1.2. формируются Проводки - Прибыль (Сумма реализации и Скидка по акциям и Скидка дополнительная)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- Сумма реализации
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItem.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                  , -1 * SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10100
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      UNION ALL
       -- Скидка по акциям
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItem.ContainerId_ProfitLoss_10200 AS ContainerId_ProfitLoss
                  , 1 * SUM (_tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10200
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      UNION ALL
       -- Скидка дополнительная
       SELECT 0, zc_MIContainer_Summ() AS DescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss, 0 AS ParentId, _tmpItem_group.OperSumm, vbOperDate, FALSE
       FROM (SELECT _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                  , 1 * SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10300
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;

     -- 5.1.1. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ(разнице в весе))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                      , (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!если>0, значит товар-кредит, т.е. у покупателя меньше со склада!!!
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;
     -- 5.1.2. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ(скидка в весе))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                      , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm -- !!!по идее >0, значит товар-кредит!!!
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;
     -- 5.1.3. формируются Проводки для отчета (Счета: Товар(с/с) <-> ОПиУ(себестоимость реализации))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
           FROM (SELECT _tmpItemSumm.MovementItemId
                      , _tmpItemSumm.ContainerId
                      , _tmpItemSumm.AccountId
                      , _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                      , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                      , (_tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!по идее >0, значит товар-кредит!!!
                 FROM _tmpItemSumm
                ) AS _tmpCalc
           WHERE _tmpCalc.OperSumm <> 0
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.1. формируются Проводки для отчета (Счета: Юр.лицо(Сумма по прайсу) <-> ОПиУ(сумма реализации)) Аналитики: !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods)
                                                                                                             , inAccountId_1        := COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) -- 100301; "прибыль текущего периода"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.AccountId_Transit ELSE _tmpCalc_all.AccountId END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId_ProfitLoss ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId_ProfitLoss ELSE _tmpCalc_all.AccountId_Transit END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_Transit
                            , _tmpItem.AccountId_Transit
                            , _tmpItem.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                            , -1 * _tmpItem.OperSumm_PriceList AS OperSumm -- !!!минус, значит долг-дебет!!!
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                      LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                         OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                          AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 WHERE _tmpCalc_all.OperSumm <> 0
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN (SELECT _tmpItemSumm.MovementItemId
                          , _tmp_byContainer.ContainerId
                          , MAX (_tmpItemSumm.AccountId) AS AccountId
                     FROM _tmpItemSumm
                          JOIN (SELECT _tmpItemSumm.MovementItemId, MAX  (_tmpItemSumm.ContainerId) AS ContainerId FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                               ) AS _tmp_byContainer ON _tmp_byContainer.MovementItemId = _tmpItemSumm.MovementItemId
                     GROUP BY _tmpItemSumm.MovementItemId
                            , _tmp_byContainer.ContainerId
                    ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.2. формируются Проводки для отчета (Счета: Юр.лицо(Сумма по прайсу "минус" Сумма контрагенту) <-> ОПиУ(Скидка по акциям)) Аналитики: !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods)
                                                                                                             , inAccountId_1        := COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) -- 100301; "прибыль текущего периода"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.AccountId_Transit ELSE _tmpCalc_all.AccountId END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId_ProfitLoss ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId_ProfitLoss ELSE _tmpCalc_all.AccountId_Transit END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_Transit
                            , _tmpItem.AccountId_Transit
                            , _tmpItem.ContainerId_ProfitLoss_10200 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                            , 1 * (_tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner) AS OperSumm -- !!!не минус, значит долг-кредит, т.е. уменьшаем его на скидку!!!
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                      LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                         OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                          AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 WHERE _tmpCalc_all.OperSumm <> 0
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN (SELECT _tmpItemSumm.MovementItemId
                          , _tmp_byContainer.ContainerId
                          , MAX (_tmpItemSumm.AccountId) AS AccountId
                     FROM _tmpItemSumm
                          JOIN (SELECT _tmpItemSumm.MovementItemId, MAX  (_tmpItemSumm.ContainerId) AS ContainerId FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                               ) AS _tmp_byContainer ON _tmp_byContainer.MovementItemId = _tmpItemSumm.MovementItemId
                     GROUP BY _tmpItemSumm.MovementItemId
                            , _tmp_byContainer.ContainerId
                    ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.3. формируются Проводки для отчета (Счета: Юр.лицо(Сумма контрагента "минус" конечная сумма по Контрагенту) <-> ОПиУ(скидка дополнительная)) Аналитики: !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
     PERFORM lpInsertUpdate_MovementItemReport (inMovementId         := inMovementId
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods)
                                                                                                             , inAccountId_1        := COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) -- 100301; "прибыль текущего периода"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND _tmpCalc_all.AccountId_Transit <> 0 THEN _tmpCalc_all.AccountId_Transit ELSE _tmpCalc_all.AccountId END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId_ProfitLoss ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId_ProfitLoss ELSE _tmpCalc_all.AccountId_Transit END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_Transit
                            , _tmpItem.AccountId_Transit
                            , _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                            , 1 * (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm -- !!!не минус, значит долг-кредит, т.е. уменьшаем его на скидку!!!
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                      LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                                                                                                                         OR  (tmpOperDate.OperDate = vbOperDatePartner
                                                                                                                          AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 WHERE _tmpCalc_all.OperSumm <> 0
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN (SELECT _tmpItemSumm.MovementItemId
                          , _tmp_byContainer.ContainerId
                          , MAX (_tmpItemSumm.AccountId) AS AccountId
                     FROM _tmpItemSumm
                          JOIN (SELECT _tmpItemSumm.MovementItemId, MAX  (_tmpItemSumm.ContainerId) AS ContainerId FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                               ) AS _tmp_byContainer ON _tmp_byContainer.MovementItemId = _tmpItemSumm.MovementItemId
                     GROUP BY _tmpItemSumm.MovementItemId
                            , _tmp_byContainer.ContainerId
                    ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;


     -- !!!6.0. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_From)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;


     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 6.2. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Sale() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.04.14                                        * add zc_Enum_InfoMoney_20801, ...
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 30.01.14                                        * add !!!Возвратная тара не учавствует!!!, поэтому удаляем
 12.01.14                                        * lpInsertUpdate_MovementItemLinkObject
 21.12.13                                        * Personal -> Member
 03.11.13                                        * rename zc_Enum_ProfitLoss_40209 -> zc_Enum_ProfitLoss_40208
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 03.10.13                                        * add inCarId := NULL
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods
 15.09.13                                        * add zc_Enum_Account_20901
 14.09.13                                        * add vbBusinessId_From
 09.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Sale (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
