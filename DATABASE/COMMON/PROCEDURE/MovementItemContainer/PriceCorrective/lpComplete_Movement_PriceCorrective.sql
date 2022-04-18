-- Function: lpComplete_Movement_PriceCorrective (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PriceCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PriceCorrective(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
 RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbJuridicalId_From Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbInfoMoneyId_CorporateFrom Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbBranchId_To Integer;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_To Integer;

BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm;
     -- !!!обязательно!!! очистили таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

          , Movement.DescId   AS MovementDescId
          , Movement.OperDate AS OperDate
          , Movement.OperDate AS OperDatePartner

          , MovementLinkObject_From.ObjectId AS JuridicalId_From

          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
            END AS IsCorporate_From

          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                 ELSE 0
            END AS InfoMoneyId_CorporateFrom

          , COALESCE (MovementLinkObject_Partner.ObjectId, 0) AS PartnerId_From
          , 0 AS MemberId_From

            -- УП Статью назначения берем: ВСЕГДА по договору
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

            -- Главное юр. лицо берем: "Кому"
          , COALESCE (MovementLinkObject_To.ObjectId, 0)  AS JuridicalId_Basis_To

            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbMovementDescId, vbOperDate, vbOperDatePartner
               , vbJuridicalId_From, vbIsCorporate_From, vbInfoMoneyId_CorporateFrom, vbPartnerId_From , vbMemberId_From, vbInfoMoneyId_From
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_To
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                   ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                 ON MovementFloat_ChangePercent.MovementId = Movement.Id
                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
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
       AND Movement.DescId = zc_Movement_PriceCorrective()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     

     -- определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках (для Покупателя)
     SELECT lfObject_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS lfObject_InfoMoney;

     -- !!!Если нет филиала для "основной деятельности", тогда это "главный филиал"
     IF vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                        , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                         )
        AND COALESCE (vbBranchId_To, 0) = 0
     THEN
         vbBranchId_To:= COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Branch())
                                 , zc_Branch_Basis());
     ELSE
         vbBranchId_To:= COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Branch())
                                 , 0);
     END IF;



     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, GoodsId, GoodsKindId
                         , OperCount, tmpOperSumm_Partner, OperSumm_Partner
                         , ContainerId_ProfitLoss_10300
                         , ContainerId_Partner, AccountId_Partner
                         , BusinessId_To
                         , AccountId_Summ, InfoMoneyDestinationId_Summ, InfoMoneyId_Summ)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Summ  -- сформируем позже
            , _tmp.GoodsId
            , _tmp.GoodsKindId

            , _tmp.OperCount

              -- промежуточная сумма по Контрагенту !!! без скидки !!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner
              -- конечная сумма по Контрагенту
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner

              -- Счет - прибыль (ОПиУ - Скидка дополнительная)
            , 0 AS ContainerId_ProfitLoss_10300

              -- Счет - долг Контрагента
            , 0 AS ContainerId_Partner
              -- Счет(справочника) Контрагента
            , 0 AS AccountId_Partner 

              -- Бизнес: ВСЕГДА по товару
            , _tmp.BusinessId_To

            , _tmp.AccountId_Summ
            , _tmp.InfoMoneyDestinationId_Summ
            , _tmp.InfoMoneyId_Summ

        FROM 
             (SELECT
                    tmpMI.MovementItemId

                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId

                  , tmpMI.Price
                    -- количество для склада
                  , tmpMI.OperCount

                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_To
                    -- Счет(справочника), Транзит + виртуальный склад
                  , zc_Enum_Account_110401() AS AccountId_Summ
                    -- Управленческие назначения
                  , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId_Summ
                    -- Статьи назначения
                  , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId_Summ

              FROM
             (SELECT (MovementItem.Id) AS MovementItemId
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                   , SUM (MovementItem.Amount) AS OperCount
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_PriceCorrective()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
              GROUP BY MovementItem.Id
                     , MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
             ) AS _tmp;


     -- проверка
     IF COALESCE (vbContractId, 0) = 0 -- OR !!! НАЛ !!!
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- Расчеты сумм
     SELECT -- Расчет Итоговой суммы по Контрагенту
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            INTO vbOperSumm_Partner
     FROM (SELECT SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
           FROM _tmpItem
          ) AS _tmpItem
     ;

     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_Partner) INTO vbOperSumm_Partner_byItem FROM _tmpItem;

     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner IN (SELECT MAX (_tmpItem.OperSumm_Partner) FROM _tmpItem)
                                          );
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



     -- 1.1. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                  , inParentId          := NULL
                                                                  , inObjectId          := _tmpItem.AccountId_Summ
                                                                  , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                  , inBusinessId        := _tmpItem.BusinessId_To
                                                                  , inObjectCostDescId  := NULL
                                                                  , inObjectCostId      := NULL
                                                                  , inDescId_1          := zc_ContainerLinkObject_Goods()
                                                                  , inObjectId_1        := _tmpItem.GoodsId
                                                                  , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                  , inObjectId_2        := _tmpItem.InfoMoneyId_Summ
                                                                  , inDescId_3          := CASE WHEN _tmpItem.InfoMoneyId_Summ = zc_Enum_InfoMoney_30101() THEN zc_ContainerLinkObject_GoodsKind() ELSE NULL END -- Готовая продукция
                                                                  , inObjectId_3        := CASE WHEN _tmpItem.InfoMoneyId_Summ = zc_Enum_InfoMoney_30101() THEN _tmpItem.GoodsKindId ELSE NULL END 
                                                                   )
     ;

     -- 1.2. формируются Проводки для суммового учета + !!!есть MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_Summ
            , _tmpItem.AccountId_Summ                 AS AccountId
            , 0                                       AS AnalyzerId               -- не нужен
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , 0                                       AS WhereObjectId_Analyzer   -- в этом док-те это св-во неизвестно
            , 0                                       AS ContainerId_Analyzer     -- "наверно" не нужен
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbPartnerId_From                        AS ObjectExtId_Analyzer     -- покупатель
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , -1 * OperSumm_Partner
            , vbOperDate
            , FALSE
       FROM _tmpItem
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_Summ
            , _tmpItem.AccountId_Summ                 AS AccountId
            , 0                                       AS AnalyzerId             -- не нужен
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , 0                                       AS WhereObjectId_Analyzer -- в этом док-те это св-во неизвестно
            , 0                                       AS ContainerId_Analyzer   -- "наверно" не нужен
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbPartnerId_From                        AS ObjectExtId_Analyzer     -- покупатель
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , OperSumm_Partner
            , vbOperDate
            , TRUE
       FROM _tmpItem;


     -- 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (недостачи, порча)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())
                             ELSE zc_Enum_AccountDirection_30100() -- покупатели -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30100())
                        END AS AccountDirectionId
                      , vbInfoMoneyDestinationId_From AS InfoMoneyDestinationId
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!нельзя ограничивать, т.к. этот AccountId в проводках для отчета!!!
                 GROUP BY _tmpItem.AccountId_Partner
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      ;


     -- 3.2. определяется ContainerId для проводок по долг Покупателя или Физ.лица (недостачи, порча)
     UPDATE _tmpItem SET ContainerId_Partner = tmp.ContainerId
     FROM (SELECT                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                 lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := tmp.AccountId
                                                       , inJuridicalId_basis := tmp.JuridicalId_Basis
                                                       , inBusinessId        := tmp.BusinessId
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                       , inObjectId_1        := tmp.JuridicalId
                                                       , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                       , inObjectId_2        := tmp.ContractId
                                                       , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_3        := tmp.InfoMoneyId
                                                       , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                       , inObjectId_4        := tmp.PaidKindId
                                                       , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                       , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                       , inDescId_6          := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.PartnerId > 0 THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                       , inObjectId_6        := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.PartnerId > 0 THEN tmp.PartnerId                    ELSE NULL END
                                                       , inDescId_7          := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.PartnerId > 0 THEN zc_ContainerLinkObject_Branch()  ELSE NULL END
                                                       , inObjectId_7        := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.PartnerId > 0 THEN vbBranchId_To                    ELSE NULL END
                                                       , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                       , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                        ) AS ContainerId
                , tmp.BusinessId
           FROM (SELECT _tmpItem.AccountId_Partner    AS AccountId
                      , vbJuridicalId_From            AS JuridicalId
                      , vbPartnerId_From              AS PartnerId
                      , vbContractId                  AS ContractId
                      , vbInfoMoneyId_From            AS InfoMoneyId
                      , vbPaidKindId                  AS PaidKindId
                      , _tmpItem.BusinessId_To        AS BusinessId
                      , vbJuridicalId_Basis_To        AS JuridicalId_Basis
                      , 0                             AS PartionMovementId  -- !!!по этой аналитике учет пока не ведем!!!
                      , vbInfoMoneyDestinationId_From AS InfoMoneyDestinationId
                      , vbIsCorporate_From            AS IsCorporate
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!нельзя ограничивать, т.к. этот ContainerId в проводках для отчета!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.BusinessId_To
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem.BusinessId_To = tmp.BusinessId
     ;

     -- 3.3. формируются Проводки - долг Покупателя или Физ.лица (недостачи, порча) + !!!не добавлен MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_Partner
            , _tmpItem_group.AccountId_Partner        AS AccountId
            , zc_Enum_AnalyzerId_SaleSumm_10300()     AS AnalyzerId              -- !!!Сумма, реализация, Скидка дополнительная!!!
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer
            , 0                                       AS WhereObjectId_Analyzer
            , _tmpItem_group.ContainerId_Partner      AS ContainerId_Analyzer
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbPartnerId_From                        AS ObjectExtId_Analyzer     -- покупатель
            , _tmpItem_group.ContainerId_Summ         AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , -1 * _tmpItem_group.OperSumm
            , vbOperDate AS OperDate
            , FALSE
       FROM (SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Summ, _tmpItem.GoodsId, _tmpItem.GoodsKindId, SUM (_tmpItem.OperSumm_Partner) AS OperSumm FROM _tmpItem GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Summ, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
       -- WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
     ;


     -- 4.1.1. создаем контейнеры для Проводки - Прибыль (Скидка дополнительная)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10300 = _tmpItem_byDestination.ContainerId_ProfitLoss_10300
     FROM (SELECT -- для Скидка дополнительная
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10300
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- определяем ProfitLossId - для Скидка дополнительная
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                              AND _tmpItem_group.ProfitLossId > 0
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
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- 70000; "Дополнительная прибыль"
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossGroup_10000() -- 10000; "Результат основной деятельности"
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- 70000; "Дополнительная прибыль"
                              END AS ProfitLossGroupId

                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                        THEN zc_Enum_ProfitLossDirection_10300() -- 10300; "Скидка дополнительная"
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- 70300; "Реализация нашим компаниям"
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()
                                        THEN zc_Enum_ProfitLossDirection_10300() -- 10100; "Скидка дополнительная"
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- 70300; "сотрудники (недостачи, порча)"
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- 70200; "Прочее"
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId_Summ AS InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN _tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_InfoMoneyDestination_WorkProgress() ELSE _tmpItem.InfoMoneyDestinationId_Summ END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId
                             FROM _tmpItem
                             -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
                             -- WHERE _tmpItem.OperSumm_Partner <> 0
                             GROUP BY _tmpItem.InfoMoneyDestinationId_Summ
                                    , _tmpItem.BusinessId_To
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_To
                              , _tmpItem.ProfitLossId
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId_Summ = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId_To = _tmpItem_byDestination.BusinessId_To;

     -- 4.1.2. формируются Проводки - Прибыль (Скидка дополнительная) + !!!нет MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- Сумма возвратов
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- прибыль текущего периода
            , 0                                       AS AnalyzerId               -- zc_Enum_AnalyzerId_SaleSumm_10300() AS AnalyzerId -- !!!Сумма, реализация, Скидка дополнительная!!!
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer
            , 0                                       AS WhereObjectId_Analyzer   -- в этом док-те это св-во неизвестно
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbPartnerId_From                        AS ObjectExtId_Analyzer     -- покупатель
            , _tmpItem_group.ContainerId_Summ         AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Summ             AS ContainerId_Summ
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , SUM (_tmpItem.OperSumm_Partner)       AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10300, _tmpItem.ContainerId_Summ, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
       ;


     -- 5.2.1. формируются Проводки для отчета (Счета: Юр.лицо <-> ОПиУ(Скидка дополнительная)) !!!Товар здесь ЛЮБОЙ из с/с, а если его нет тогда количественный и еще inAccountId_1 НЕ ПРАВИЛЬНЫЙ!!! 
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
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem_byProfitLoss.ContainerId_Summ
                                                                                                             , inAccountId_1        := _tmpItem_byProfitLoss.AccountId_Summ
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "прибыль текущего периода"
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
                , _tmpCalc.ContainerId_Summ
                , _tmpCalc.AccountId_Summ
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , vbOperDate AS OperDate
                      , _tmpCalc_all.ContainerId AS ContainerId
                      , _tmpCalc_all.AccountId AS AccountId
                      , _tmpCalc_all.ContainerId_ProfitLoss AS ContainerId_ProfitLoss
                      , _tmpCalc_all.AccountId_ProfitLoss AS AccountId_ProfitLoss
                      , _tmpCalc_all.ContainerId_Summ
                      , _tmpCalc_all.AccountId_Summ
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 () AS AccountId_ProfitLoss   -- 100301; "прибыль текущего периода"
                            , _tmpItem.ContainerId_Summ
                            , _tmpItem.AccountId_Summ
                            , _tmpItem.OperSumm_Partner AS OperSumm -- !!!плюс, значит "убыток"!!!
                                                                    -- п.с. убыток: Active=ContainerId_ProfitLoss а доход: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                      ) AS _tmpCalc_all
                 -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
                 -- WHERE _tmpCalc_all.OperSumm <> 0
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
     ;


     -- убрал, т.к. св-во пишется теперь в ОПиУ
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     -- !!!6.0. формируются свойства в элементах документа из данных для проводок!!!
     /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_To)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;*/

     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 6.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PriceCorrective()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.08.14                                        * add MovementDescId
 05.06.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_PriceCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
