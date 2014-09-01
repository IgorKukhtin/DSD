-- Function: lpComplete_Movement_TransferDebt_all (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_TransferDebt_all (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TransferDebt_all(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;

  DECLARE vbMovementDescId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbFromId Integer;
  DECLARE vbToId Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbIsCorporate_To Boolean;
  DECLARE vbInfoMoneyId_Corporate_From Integer;
  DECLARE vbInfoMoneyId_Corporate_To Integer;
  DECLARE vbContractId_From Integer;
  DECLARE vbContractId_To Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;
  DECLARE vbPaidKindId_From Integer;
  DECLARE vbPaidKindId_To Integer;
  DECLARE vbJuridicalId_Basis_From Integer;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_From Integer;
  DECLARE vbBusinessId_To Integer;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и для формирования Аналитик в проводках
     SELECT Movement.DescId
          , Movement.OperDate
          , CASE WHEN Movement.DescId = zc_Movement_TransferDebtIn()
                      THEN MovementLinkObject_Partner.ObjectId
                 WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId
                      THEN MovementLinkObject_Partner.ObjectId
                 ELSE 0
            END AS PartnerId_From
          , CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut()
                      THEN MovementLinkObject_Partner.ObjectId
                 WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId
                      THEN MovementLinkObject_Partner.ObjectId
                 ELSE 0
            END AS PartnerId_To
          , COALESCE (MovementLinkObject_From.ObjectId, 0)                      AS FromId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)                        AS ToId
          , CASE WHEN View_Constant_isCorporate_From.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate_From.ValueData, FALSE)
            END AS isCorporate_From
          , CASE WHEN View_Constant_isCorporate_To.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate_To.ValueData, FALSE)
            END AS isCorporate_From
          , COALESCE (ObjectLink_Juridical_InfoMoney_From.ChildObjectId, 0)     AS InfoMoneyId_Corporate_From
          , COALESCE (ObjectLink_Juridical_InfoMoney_To.ChildObjectId, 0)       AS InfoMoneyId_Corporate_To
          , COALESCE (MovementLinkObject_Contract_From.ObjectId, 0)             AS ContractId_From
          , COALESCE (MovementLinkObject_Contract_To.ObjectId, 0)               AS ContractId_To
          , COALESCE (View_InfoMoney_From.InfoMoneyDestinationId, 0)            AS InfoMoneyDestinationId_From
          , COALESCE (ObjectLink_Contract_InfoMoney_From.ChildObjectId, 0)      AS InfoMoneyId_From
          , COALESCE (View_InfoMoney_To.InfoMoneyDestinationId, 0)              AS InfoMoneyDestinationId_To
          , COALESCE (ObjectLink_Contract_InfoMoney_To.ChildObjectId, 0)        AS InfoMoneyId_To
          , COALESCE (MovementLinkObject_PaidKind_From.ObjectId, 0)             AS PaidKindId_From
          , COALESCE (MovementLinkObject_PaidKind_To.ObjectId, 0)               AS PaidKindId_To
          , COALESCE (ObjectLink_Contract_JuridicalBasis_From.ChildObjectId, 0) AS JuridicalId_Basis_From
          , COALESCE (ObjectLink_Contract_JuridicalBasis_To.ChildObjectId, 0)   AS JuridicalId_Basis_To
          , 0 AS BusinessId_From
          , 0 AS BusinessId_To
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)             AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)                    AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
            INTO vbMovementDescId, vbOperDate
               , vbPartnerId_From, vbPartnerId_To, vbFromId, vbToId, vbIsCorporate_From, vbIsCorporate_To, vbInfoMoneyId_Corporate_From, vbInfoMoneyId_Corporate_To
               , vbContractId_From, vbContractId_To
               , vbInfoMoneyDestinationId_From, vbInfoMoneyId_From
               , vbInfoMoneyDestinationId_To, vbInfoMoneyId_To
               , vbPaidKindId_From, vbPaidKindId_To
               , vbJuridicalId_Basis_From, vbJuridicalId_Basis_To
               , vbBusinessId_From, vbBusinessId_To
               , vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
     FROM Movement

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = inMovementId
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = inMovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind_From
                                       ON MovementLinkObject_PaidKind_From.MovementId = inMovementId
                                      AND MovementLinkObject_PaidKind_From.DescId = zc_MovementLinkObject_PaidKindFrom()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_From
                                       ON MovementLinkObject_Contract_From.MovementId = inMovementId
                                      AND MovementLinkObject_Contract_From.DescId = zc_MovementLinkObject_ContractFrom()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis_From ON ObjectLink_Contract_JuridicalBasis_From.ObjectId = MovementLinkObject_Contract_From.ObjectId
                                                                         AND ObjectLink_Contract_JuridicalBasis_From.DescId = zc_ObjectLink_Contract_JuridicalBasis()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_From
                               ON ObjectLink_Contract_InfoMoney_From.ObjectId = MovementLinkObject_Contract_From.ObjectId
                              AND ObjectLink_Contract_InfoMoney_From.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_From ON View_InfoMoney_From.InfoMoneyId = ObjectLink_Contract_InfoMoney_From.ChildObjectId
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate_From
                                  ON ObjectBoolean_isCorporate_From.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_isCorporate_From.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney_From
                               ON ObjectLink_Juridical_InfoMoney_From.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Juridical_InfoMoney_From.DescId   = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View AS View_Constant_isCorporate_From ON View_Constant_isCorporate_From.InfoMoneyId = ObjectLink_Juridical_InfoMoney_From.ChildObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind_To
                                       ON MovementLinkObject_PaidKind_To.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind_To.DescId = zc_MovementLinkObject_PaidKindTo()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_To
                                       ON MovementLinkObject_Contract_To.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract_To.DescId = zc_MovementLinkObject_ContractTo()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis_To ON ObjectLink_Contract_JuridicalBasis_To.ObjectId = MovementLinkObject_Contract_To.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis_To.DescId = zc_ObjectLink_Contract_JuridicalBasis()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_To
                               ON ObjectLink_Contract_InfoMoney_To.ObjectId = MovementLinkObject_Contract_To.ObjectId
                              AND ObjectLink_Contract_InfoMoney_To.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_To ON View_InfoMoney_To.InfoMoneyId = ObjectLink_Contract_InfoMoney_To.ChildObjectId
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate_To
                                  ON ObjectBoolean_isCorporate_To.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_isCorporate_To.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney_To
                               ON ObjectLink_Juridical_InfoMoney_To.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Juridical_InfoMoney_To.DescId   = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View AS View_Constant_isCorporate_To ON View_Constant_isCorporate_To.InfoMoneyId = ObjectLink_Juridical_InfoMoney_To.ChildObjectId

          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- проверка
     IF vbFromId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <От кого (юридическое лицо)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbContractId_From = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор (от кого)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbInfoMoneyId_From = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (от кого)> не установлена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbPaidKindId_From = 0
     THEN
         IF vbMovementDescId = zc_Movement_TransferDebtOut()
         THEN RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты (от кого)>.Проведение невозможно.';
         ELSE RAISE EXCEPTION 'Ошибка.У <Договора (от кого)> не установлена <Форма оплаты>.Проведение невозможно.';
         END IF;
     END IF;
     -- проверка
     IF vbJuridicalId_Basis_From = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (от кого)> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;

     -- проверка
     IF vbToId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Кому (юридическое лицо)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbContractId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор (кому)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbInfoMoneyId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (кому)> не установлена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbPaidKindId_To = 0
     THEN
         IF vbMovementDescId = zc_Movement_TransferDebtOut()
         THEN RAISE EXCEPTION 'Ошибка.У <Договора (кому)> не установлена <Форма оплаты>.Проведение невозможно.';
         ELSE RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты (кому)>.Проведение невозможно.';
         END IF;
     END IF;
     -- проверка
     IF vbJuridicalId_Basis_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора (кому)> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , AccountId_From, AccountId_To, ContainerId_From, ContainerId_To
                         , ContainerId_Summ, GoodsId, GoodsKindId
                         , tmpOperSumm_Partner, OperSumm_Partner
                         , AccountId_Summ, InfoMoneyId_Summ)
        SELECT tmpMI.MovementItemId
             , 0 AS AccountId_From    -- сформируем позже
             , 0 AS AccountId_To      -- сформируем позже
             , 0 AS ContainerId_From  -- сформируем позже
             , 0 AS ContainerId_To    -- сформируем позже
             , 0 AS ContainerId_Summ  -- сформируем позже
             , tmpMI.GoodsId
             , tmpMI.GoodsKindId

              -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
            , tmpMI.tmpOperSumm_Partner AS tmpOperSumm_Partner
              -- конечная сумма по Контрагенту
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_Partner)
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner
              
            , zc_Enum_Account_110401()   AS AccountId_Summ      -- Счет(справочника), Транзит + виртуальный склад
            , tmpMI.InfoMoneyId          AS InfoMoneyId_Summ    -- Статьи назначения 

        FROM (SELECT tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   , tmpMI.GoodsKindId

                     -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                   , CASE WHEN tmpMI.CountForPrice <> 0
                               THEN CAST (tmpMI.OperCount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (tmpMI.OperCount * tmpMI.Price AS NUMERIC (16, 2))
                     END AS tmpOperSumm_Partner

                     -- Статьи назначения
                   , COALESCE (ObjectLink_Goods_InfoMoney.ObjectId, 0) AS InfoMoneyId
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
                AND Movement.DescId IN (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
              GROUP BY MovementItem.Id
                     , MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                      ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                     AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             ) AS tmpMI
        ;


     -- Расчет Итоговой суммы по Контрагенту
     SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            INTO vbOperSumm_Partner
     FROM (SELECT SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
           FROM _tmpItem
          ) AS tmp
     ;

     -- Расчет Итоговой суммы (по элементам)
     SELECT SUM (OperSumm_Partner) INTO vbOperSumm_Partner_byItem FROM _tmpItem;

     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Partner IN (SELECT MAX (OperSumm_Partner) FROM _tmpItem)
                                 );
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                  , inParentId          := NULL
                                                                  , inObjectId          := _tmpItem.AccountId_Summ
                                                                  , inJuridicalId_basis := tmp.JuridicalId_Basis
                                                                  , inBusinessId        := tmp.BusinessId
                                                                  , inObjectCostDescId  := NULL
                                                                  , inObjectCostId      := NULL
                                                                  , inDescId_1          := zc_ContainerLinkObject_Goods()
                                                                  , inObjectId_1        := _tmpItem.GoodsId
                                                                  , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                  , inObjectId_2        := _tmpItem.InfoMoneyId_Summ
                                                                  , inDescId_3          := CASE WHEN _tmpItem.InfoMoneyId_Summ = zc_Enum_InfoMoney_30101() THEN zc_ContainerLinkObject_GoodsKind() ELSE NULL END -- Готовая продукция
                                                                  , inObjectId_3        := CASE WHEN _tmpItem.InfoMoneyId_Summ = zc_Enum_InfoMoney_30101() THEN _tmpItem.GoodsKindId ELSE NULL END 
                                                                   )
     FROM (SELECT CASE WHEN vbMovementDescId = zc_Movement_TransferDebtOut() THEN vbJuridicalId_Basis_To ELSE vbJuridicalId_Basis_From END AS JuridicalId_Basis
                , CASE WHEN vbMovementDescId = zc_Movement_TransferDebtOut() THEN vbBusinessId_To ELSE vbBusinessId_From END AS BusinessId
          ) AS tmp;

     -- 1.2. формируются Проводки для суммового учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId, ContainerId_Summ, 0 AS ParentId, -1 * OperSumm_Partner, vbOperDate, FALSE
       FROM _tmpItem
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, MovementItemId, ContainerId_Summ, 0 AS ParentId, OperSumm_Partner, vbOperDate, TRUE
       FROM _tmpItem;


     -- 2.1.1. определяется Счет(справочника) для проводок по долг Контрагенту (От кого)
     UPDATE _tmpItem SET AccountId_From = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN _tmpItem_group.isCorporate = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                  END AS AccountId
           FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- Дебиторы
                             -- ELSE zc_Enum_AccountGroup_70000()  -- Кредиторы
                             ELSE zc_Enum_AccountGroup_30000() -- Дебиторы
                        END AS AccountGroupId
                      , CASE WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании
                             -- ELSE zc_Enum_AccountDirection_70100() -- поставщики
                             ELSE zc_Enum_AccountDirection_30100() -- покупатели
                        END AS AccountDirectionId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_Corporate_From
                                  THEN zc_Enum_Account_30201() -- Алан
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_Corporate_From
                                  THEN zc_Enum_Account_30202() -- Ирна
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_Corporate_From
                                  THEN zc_Enum_Account_30203() -- Чапли
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_Corporate_From
                                  THEN zc_Enum_Account_30204() -- Дворкин
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_Corporate_From
                                  THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                        END AS AccountId
                      , vbInfoMoneyDestinationId_From AS InfoMoneyDestinationId
                      , vbIsCorporate_From            AS isCorporate
                 FROM _tmpItem
                 GROUP BY AccountId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount;

     -- 2.1.2. определяется Счет(справочника) для проводок по долг Контрагенту (Кому)
     UPDATE _tmpItem SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN _tmpItem_group.isCorporate = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                  END AS AccountId
           FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- Дебиторы
                             -- ELSE zc_Enum_AccountGroup_70000()  -- Кредиторы
                             ELSE zc_Enum_AccountGroup_30000() -- Дебиторы
                        END AS AccountGroupId
                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании
                             -- ELSE zc_Enum_AccountDirection_70100() -- поставщики
                             ELSE zc_Enum_AccountDirection_30100() -- покупатели
                        END AS AccountDirectionId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_Corporate_To
                                  THEN zc_Enum_Account_30201() -- Алан
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_Corporate_To
                                  THEN zc_Enum_Account_30202() -- Ирна
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_Corporate_To
                                  THEN zc_Enum_Account_30203() -- Чапли
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_Corporate_To
                                  THEN zc_Enum_Account_30204() -- Дворкин
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_Corporate_To
                                  THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                        END AS AccountId
                      , vbInfoMoneyDestinationId_To AS InfoMoneyDestinationId
                      , vbIsCorporate_To            AS isCorporate
                 FROM _tmpItem
                 GROUP BY AccountId_To
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount;


     -- 2.2.1. определяется ContainerId для проводок по долг Контрагенту (От кого)
     UPDATE _tmpItem SET ContainerId_From = tmp.ContainerId
     FROM (SELECT CASE WHEN tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                        AND tmp.IsCorporate = FALSE
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := tmp.AccountId
                                                       , inJuridicalId_basis := tmp.JuridicalId_Basis
                                                       , inBusinessId        := tmp.BusinessId
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                       , inObjectId_1        := tmp.JuridicalId
                                                       , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                       , inObjectId_3        := tmp.ContractId
                                                       , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                       , inObjectId_2        := tmp.PaidKindId
                                                       , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_4        := tmp.InfoMoneyId
                                                       , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                       , inObjectId_5        := tmp.PartionMovementId
                                                       , inDescId_6          := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                       , inObjectId_6        := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmp.PartnerId ELSE NULL END
                                                        )
                                  -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                            ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := tmp.AccountId
                                                       , inJuridicalId_basis := tmp.JuridicalId_Basis
                                                       , inBusinessId        := tmp.BusinessId
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                       , inObjectId_1        := tmp.JuridicalId
                                                       , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                       , inObjectId_3        := tmp.ContractId
                                                       , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                       , inObjectId_2        := tmp.PaidKindId
                                                       , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_4        := tmp.InfoMoneyId
                                                       , inDescId_5          := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.IsCorporate = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                       , inObjectId_5        := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.IsCorporate = FALSE THEN tmp.PartnerId ELSE NULL END
                                                        )
                  END AS ContainerId
                , tmp.AccountId
           FROM (SELECT _tmpItem.AccountId_From  AS AccountId
                      , vbFromId                 AS JuridicalId
                      , vbPartnerId_From         AS PartnerId
                      , vbContractId_From        AS ContractId
                      , vbInfoMoneyId_From       AS InfoMoneyId
                      , vbPaidKindId_From        AS PaidKindId
                      , vbBusinessId_From        AS BusinessId
                      , vbJuridicalId_Basis_From AS JuridicalId_Basis
                      , 0                        AS PartionMovementId  -- !!!по этой аналитике учет пока не ведем!!!
                      , vbInfoMoneyDestinationId_From  AS InfoMoneyDestinationId
                      , vbIsCorporate_From             AS IsCorporate
                 FROM _tmpItem
                 GROUP BY _tmpItem.AccountId_From
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem.AccountId_From = tmp.AccountId;


     -- 2.2.2. определяется ContainerId для проводок по долг Контрагенту (Кому)
     UPDATE _tmpItem SET ContainerId_To = tmp.ContainerId
     FROM (SELECT CASE WHEN tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                        AND tmp.IsCorporate = FALSE
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := tmp.AccountId
                                                       , inJuridicalId_basis := tmp.JuridicalId_Basis
                                                       , inBusinessId        := tmp.BusinessId
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                       , inObjectId_1        := tmp.JuridicalId
                                                       , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                       , inObjectId_3        := tmp.ContractId
                                                       , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                       , inObjectId_2        := tmp.PaidKindId
                                                       , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_4        := tmp.InfoMoneyId
                                                       , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                       , inObjectId_5        := tmp.PartionMovementId
                                                       , inDescId_6          := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                       , inObjectId_6        := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmp.PartnerId ELSE NULL END
                                                        )
                                  -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                            ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := tmp.AccountId
                                                       , inJuridicalId_basis := tmp.JuridicalId_Basis
                                                       , inBusinessId        := tmp.BusinessId
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                       , inObjectId_1        := tmp.JuridicalId
                                                       , inDescId_3          := zc_ContainerLinkObject_Contract()
                                                       , inObjectId_3        := tmp.ContractId
                                                       , inDescId_2          := zc_ContainerLinkObject_PaidKind()
                                                       , inObjectId_2        := tmp.PaidKindId
                                                       , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_4        := tmp.InfoMoneyId
                                                       , inDescId_5          := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.IsCorporate = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                       , inObjectId_5        := CASE WHEN tmp.PaidKindId = zc_Enum_PaidKind_SecondForm() AND tmp.IsCorporate = FALSE THEN tmp.PartnerId ELSE NULL END
                                                        )
                  END AS ContainerId
                , tmp.AccountId
           FROM (SELECT _tmpItem.AccountId_To  AS AccountId
                      , vbToId                 AS JuridicalId
                      , vbPartnerId_To         AS PartnerId
                      , vbContractId_To        AS ContractId
                      , vbInfoMoneyId_To       AS InfoMoneyId
                      , vbPaidKindId_To        AS PaidKindId
                      , vbBusinessId_To        AS BusinessId
                      , vbJuridicalId_Basis_To AS JuridicalId_Basis
                      , 0                      AS PartionMovementId  -- !!!по этой аналитике учет пока не ведем!!!
                      , vbInfoMoneyDestinationId_To  AS InfoMoneyDestinationId
                      , vbIsCorporate_To             AS IsCorporate
                 FROM _tmpItem
                 GROUP BY _tmpItem.AccountId_To
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem.AccountId_To = tmp.AccountId;


     -- 2.3. формируются Проводки - долг Контрагенту
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       -- Контрагент - От кого
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId, _tmpItem.ContainerId_From, 0 AS ParentId, -1 * _tmpItem.OperSumm_Partner
            , vbOperDate
            , FALSE
       FROM _tmpItem
     UNION ALL
       -- Контрагент - Кому
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId, _tmpItem.ContainerId_To, 0 AS ParentId, _tmpItem.OperSumm_Partner
            , vbOperDate
            , TRUE
       FROM _tmpItem
      ;


     -- 4.1. формируются Проводки для отчета (Счета: Контрагент (От кого) <-> Транзит + виртуальный склад
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := tmpMIReport.MovementItemId
                                              , inActiveContainerId  := tmpMIReport.ActiveContainerId
                                              , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                              , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                              , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                    , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                    , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                    , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                             , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                             , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                             , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                              )
                                              , inAmount   := tmpMIReport.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT _tmpItem.MovementItemId
                , _tmpItem.OperSumm_Partner AS OperSumm
                , _tmpItem.ContainerId_Summ AS ActiveContainerId
                , _tmpItem.ContainerId_From AS PassiveContainerId
                , _tmpItem.AccountId_Summ   AS ActiveAccountId
                , _tmpItem.AccountId_From   AS PassiveAccountId
           FROM _tmpItem
          ) AS tmpMIReport;

     -- 4.2. формируются Проводки для отчета (Счета: Контрагент (Кому) <-> Транзит + виртуальный склад
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := tmpMIReport.MovementItemId
                                              , inActiveContainerId  := tmpMIReport.ActiveContainerId
                                              , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                              , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                              , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                    , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                    , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                    , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := tmpMIReport.ActiveContainerId
                                                                                                             , inPassiveContainerId := tmpMIReport.PassiveContainerId
                                                                                                             , inActiveAccountId    := tmpMIReport.ActiveAccountId
                                                                                                             , inPassiveAccountId   := tmpMIReport.PassiveAccountId
                                                                                                              )
                                              , inAmount   := tmpMIReport.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM (SELECT _tmpItem.MovementItemId
                , _tmpItem.OperSumm_Partner AS OperSumm
                , _tmpItem.ContainerId_To   AS ActiveContainerId
                , _tmpItem.ContainerId_Summ AS PassiveContainerId
                , _tmpItem.AccountId_To     AS ActiveAccountId
                , _tmpItem.AccountId_Summ   AS PassiveAccountId
           FROM _tmpItem
          ) AS tmpMIReport;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := inUserId
                                 );

     -- 5.3. ФИНИШ - перепроводим Налоговую
     IF EXISTS (SELECT MovementLinkMovement_Master.MovementId
                FROM MovementLinkMovement AS MovementLinkMovement_Master
                     INNER JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                                   AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
                     INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                                   ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id
                                                  AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                  AND MovementLinkObject_DocumentTaxKind_Master.ObjectId = zc_Enum_DocumentTaxKind_Tax()
                WHERE MovementLinkMovement_Master.MovementId = inMovementId
                  AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                  AND vbMovementDescId = zc_Movement_TransferDebtOut()
               )
     THEN PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := inMovementId
                                                       , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                       , inDocumentTaxKindId_inf := NULL
                                                       , inUserId                := inUserId
                                                        );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 16.05.14                                        * add ФИНИШ - перепроводим Налоговую
 11.05.14                                        * all
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        *
*/
/*
     -- таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , AccountId_From Integer, AccountId_To Integer, ContainerId_From Integer, ContainerId_To Integer
                               , ContainerId_Summ Integer, GoodsId Integer, GoodsKindId Integer
                               , tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , AccountId_Summ Integer, InfoMoneyId_Summ Integer) ON COMMIT DROP;
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 267275 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_TransferDebt_all (inMovementId:= 267275, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 267275 , inSession:= '2')
