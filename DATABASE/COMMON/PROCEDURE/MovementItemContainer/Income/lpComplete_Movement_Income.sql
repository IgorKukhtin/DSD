-- Function: lpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer               , -- Пользователь
    IN inIsLastComplete    Boolean  DEFAULT False  -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
)
RETURNS VOID
AS
$BODY$
  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_Packer Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;

  DECLARE vbMovementDescId Integer;

  DECLARE vbInvoiceSumm          TFloat;
  DECLARE vbInvoiceSumm_Currency TFloat;

  DECLARE vbOperSumm_Partner_byItem   TFloat;
  DECLARE vbOperSumm_Packer_byItem    TFloat;
  DECLARE vbOperSumm_PartnerTo_byItem TFloat;
  DECLARE vbOperSumm_Currency_byItem  TFloat;

  DECLARE vbOperSumm_Partner   TFloat;
  DECLARE vbOperSumm_Packer    TFloat;
  DECLARE vbOperSumm_PartnerTo TFloat;
  DECLARE vbOperSumm_Currency  TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;
  DECLARE vbJuridicalId_From Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbInfoMoneyId_CorporateFrom Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbCardFuelId_From Integer;
  DECLARE vbPriceListId_Fuel Integer;
  DECLARE vbTicketFuelId_From Integer;
  DECLARE vbUnitId_From Integer;
  DECLARE vbInfoMoneyGroupId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbIsCorporate_To Boolean;
  DECLARE vbInfoMoneyId_CorporateTo Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbFounderId_To Integer;
  DECLARE vbInfoMoneyGroupId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;
  DECLARE vbPaidKindId_To Integer;
  DECLARE vbContractId_To Integer;
  DECLARE vbChangePercent_To TFloat;
  DECLARE vbIsAccount_30000 Boolean;

  DECLARE vbUnitId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbMemberId_Driver Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbBranchId_Car Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbMemberId_Packer Integer;
  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;
  DECLARE vbBusinessId_Route Integer;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;

  DECLARE vbMovementId_Invoice Integer;

BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPartner;
     -- !!!обязательно!!! очистили таблицу - элементы по ПОКУПАТЕЛЮ, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPartner_To;
     -- !!!обязательно!!! очистили таблицу - элементы по Сотруднику (ЗП), со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPersonal;
     -- !!!обязательно!!! очистили таблицу - элементы по Сотруднику (заготовитель), со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPacker;
     -- !!!обязательно!!! очистили таблицу - элементы по Сотруднику (Водитель), со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummDriver;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     -- !!!обязательно!!! очистили таблицу - партии Спецодежда
     DELETE FROM _tmpItemPartion_20202;
     -- !!!обязательно!!! очистили таблицу - с/с перемещение ГСМ
     DELETE FROM _tmpItemSumm_Unit;


     -- параметр
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());


     -- сначала - замена
     PERFORM lpInsert_MovementItemProtocol (tmpMI.MovementItemId, inUserId, FALSE)
     FROM (WITH -- пересорт по подразделениям
                tmpUnitPeresort AS (SELECT Object_GoodsByGoodsKind.Id                 AS GoodsByGoodsKindId
                                         , ObjectLink_UnitPeresort_Unit.ChildObjectId AS UnitId
                                    FROM Object AS Object_UnitPeresort
                                         INNER JOIN ObjectLink AS ObjectLink_UnitPeresort_GoodsByGoodsKind
                                                               ON ObjectLink_UnitPeresort_GoodsByGoodsKind.ObjectId = Object_UnitPeresort.Id
                                                              AND ObjectLink_UnitPeresort_GoodsByGoodsKind.DescId   = zc_ObjectLink_UnitPeresort_GoodsByGoodsKind()

                                         INNER JOIN ObjectLink AS ObjectLink_UnitPeresort_Unit
                                                               ON ObjectLink_UnitPeresort_Unit.ObjectId      = Object_UnitPeresort.Id
                                                              AND ObjectLink_UnitPeresort_Unit.DescId        = zc_ObjectLink_UnitPeresort_Unit()
                                                              AND ObjectLink_UnitPeresort_Unit.ChildObjectId > 0

                                         INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id       = ObjectLink_UnitPeresort_GoodsByGoodsKind.ChildObjectId
                                                                                     AND Object_GoodsByGoodsKind.isErased = FALSE
                                    WHERE Object_UnitPeresort.DescId = zc_Object_UnitPeresort()
                                      AND Object_UnitPeresort.isErased = FALSE
                                   )
           --
           SELECT MovementItem.Id AS MovementItemId
                , lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, ObjectLink_GoodsByGoodsKind_GoodsIncome.ChildObjectId, MovementItem.MovementId, MovementItem.Amount, MovementItem.ParentId)
                , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), MovementItem.Id, ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ChildObjectId)

                , CASE WHEN MILO_GoodsReal.ObjectId     IS NULL THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsReal(), MovementItem.Id, MovementItem.ObjectId) END
                , CASE WHEN MILO_GoodsKindReal.ObjectId IS NULL THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindReal(), MovementItem.Id, MILO_GoodsKind.ObjectId) END

           FROM MovementItem
                -- INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = MovementItem.ObjectId

                INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                      ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                     AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                INNER JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND Object_GoodsByGoodsKind.isErased = FALSE
                LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object_GoodsByGoodsKind.Id
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()

                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                LEFT JOIN MovementItemLinkObject AS MILO_GoodsReal
                                                 ON MILO_GoodsReal.MovementItemId = MovementItem.Id
                                                AND MILO_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindReal
                                                 ON MILO_GoodsKindReal.MovementItemId = MovementItem.Id
                                                AND MILO_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()

                INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsIncome
                                      ON ObjectLink_GoodsByGoodsKind_GoodsIncome.ObjectId      = Object_GoodsByGoodsKind.Id
                                     AND ObjectLink_GoodsByGoodsKind_GoodsIncome.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsIncome()
                                     AND ObjectLink_GoodsByGoodsKind_GoodsIncome.ChildObjectId > 0
                LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindIncome
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ObjectId = Object_GoodsByGoodsKind.Id
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKindIncome.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome()


                -- пересорт по подразделениям
                LEFT JOIN (SELECT DISTINCT tmpUnitPeresort.GoodsByGoodsKindId FROM tmpUnitPeresort
                          ) AS tmpUnitPeresort
                            ON tmpUnitPeresort.GoodsByGoodsKindId = Object_GoodsByGoodsKind.Id
                LEFT JOIN tmpUnitPeresort AS tmpUnitPeresort_find
                                          ON tmpUnitPeresort_find.GoodsByGoodsKindId = Object_GoodsByGoodsKind.Id
                                         AND tmpUnitPeresort_find.UnitId             = vbUnitId

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.isErased   = FALSE
             AND MovementItem.DescId     = zc_MI_Master()
             AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (MILO_GoodsKind.ObjectId, 0)
             --
             AND (ObjectLink_GoodsByGoodsKind_GoodsIncome.ChildObjectId                   <> MovementItem.ObjectId
               OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ChildObjectId, 0) <> COALESCE (MILO_GoodsKind.ObjectId, 0)
                 )
             -- если пересорт по подразделениям
             AND (tmpUnitPeresort_find.GoodsByGoodsKindId > 0 OR tmpUnitPeresort.GoodsByGoodsKindId IS NULL)
          ) AS tmpMI
    ;


     -- формируются Партии для Сырья
     PERFORM lpInsertUpdate_MovementItemString (inDescId        := zc_MIString_PartionGoodsCalc()
                                              , inMovementItemId:= MovementItem.Id
                                              , inValueData     := zfCalc_PartionGoods (Object_Goods.ObjectCode, Object_Partner.ObjectCode, Movement.OperDate)
                                               )
     FROM MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_PartionCount
                                  ON ObjectBoolean_Goods_PartionCount.ObjectId = MovementItem.ObjectId
                                 AND ObjectBoolean_Goods_PartionCount.DescId   = zc_ObjectBoolean_Goods_PartionCount()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_PartionSumm
                                  ON ObjectBoolean_Goods_PartionSumm.ObjectId = MovementItem.ObjectId
                                 AND ObjectBoolean_Goods_PartionSumm.DescId   = zc_ObjectBoolean_Goods_PartionSumm()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND (View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
         OR (ObjectBoolean_Goods_PartionCount.ValueData = TRUE
             AND View_InfoMoney.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
            )
         OR (ObjectBoolean_Goods_PartionSumm.ValueData = TRUE
             AND View_InfoMoney.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье
            )
         OR (MovementItem.ObjectId IN (6612355 -- 94185 Эт Мясо курей в собственном соку 525г 320х71 Варто
                                      )
             AND inUserId = 5
            )
           )
     ;


     -- параметр
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     vbOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner());

     -- замена
     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MLO_Contract
                                                   ON MLO_Contract.MovementId = Movement.Id
                                                  AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                  AND MLO_Contract.ObjectId   = vbContractId
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                     INNER JOIN MovementItem AS MovementItem_curr
                                             ON MovementItem_curr.MovementId = inMovementId
                                            AND MovementItem_curr.DescId     = zc_MI_Master()
                                            AND MovementItem_curr.isErased   = FALSE
                                            AND MovementItem_curr.ObjectId   = MovementItem.ObjectId
                     LEFT JOIN MovementBoolean AS MB_ChangePriceUser
                                               ON MB_ChangePriceUser.MovementId = inMovementId
                                              AND MB_ChangePriceUser.DescId     = zc_MovementBoolean_ChangePriceUser()
                                              AND MB_ChangePriceUser.ValueData   = TRUE
                WHERE Movement.DescId    = zc_Movement_ContractGoods()
                  AND Movement.StatusId  = zc_Enum_Status_Complete()
                  AND Movement.OperDate  <= vbOperDatePartner
                  --
                  AND MB_ChangePriceUser.MovementId IS NULL
               )
     THEN
         -- сохранили свойство <Скидка в цене>
         PERFORM lpInsertUpdate_MovemenTFloat (zc_MovementFloat_ChangePrice()
                                             , inMovementId
                                             , COALESCE ((SELECT MIFloat.ValueData
                                                          FROM Movement
                                                               INNER JOIN MovementLinkObject AS MLO_Contract
                                                                                             ON MLO_Contract.MovementId = Movement.Id
                                                                                            AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                                            AND MLO_Contract.ObjectId   = vbContractId
                                                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                                                      AND MovementItem.isErased   = FALSE
                                                               LEFT JOIN MovementItemFloat AS MIFloat ON MIFloat.MovementItemId = MovementItem.Id
                                                                                          AND MIFloat.DescId         = zc_MIFloat_ChangePrice()
                                                               INNER JOIN MovementItem AS MovementItem_curr
                                                                                       ON MovementItem_curr.MovementId = inMovementId
                                                                                      AND MovementItem_curr.DescId     = zc_MI_Master()
                                                                                      AND MovementItem_curr.isErased   = FALSE
                                                                                      AND MovementItem_curr.ObjectId   = MovementItem.ObjectId
                                                          WHERE Movement.DescId    = zc_Movement_ContractGoods()
                                                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                                                            AND Movement.OperDate  <= vbOperDatePartner
                                                          ORDER BY Movement.OperDate DESC, COALESCE (MIFloat.ValueData, 0) DESC
                                                          LIMIT 1
                                                         ), 0)
                                              );

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     END IF;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и Сотруднику (заготовитель) и для формирования Аналитик в проводках
     SELECT _tmp.PriceWithVAT, _tmp.VATPercent, _tmp.DiscountPercent, _tmp.ExtraChargesPercent, _tmp.ChangePrice
          , _tmp.MovementDescId, _tmp.OperDate, _tmp.OperDatePartner, _tmp.JuridicalId_From, _tmp.isCorporate_From, _tmp.InfoMoneyId_CorporateFrom, _tmp.PartnerId_From, _tmp.MemberId_From, _tmp.CardFuelId_From, _tmp.TicketFuelId_From, _tmp.UnitId_From
          , _tmp.InfoMoneyId_From
          , _tmp.JuridicalId_To, _tmp.isCorporate_To, _tmp.InfoMoneyId_CorporateTo, _tmp.PartnerId_To, _tmp.MemberId_To, _tmp.FounderId_To, _tmp.InfoMoneyId_To, _tmp.PaidKindId_To, _tmp.ContractId_To, _tmp.ChangePercent_To, _tmp.isAccount_30000
          , _tmp.UnitId, _tmp.CarId, _tmp.MemberDriverId, _tmp.BranchId_To, _tmp.BranchId_Car, _tmp.AccountDirectionId_To, _tmp.isPartionDate_Unit
          , _tmp.MemberId_Packer, _tmp.PaidKindId, _tmp.ContractId, _tmp.JuridicalId_Basis_To, _tmp.BusinessId_To, _tmp.BusinessId_Route
          , _tmp.CurrencyDocumentId, _tmp.CurrencyPartnerId, _tmp.CurrencyValue, _tmp.ParValue
          , _tmp.InvoiceSumm, _tmp.InvoiceSumm_Currency
          , _tmp.MovementId_Invoice
            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePrice
               , vbMovementDescId, vbOperDate, vbOperDatePartner, vbJuridicalId_From, vbIsCorporate_From, vbInfoMoneyId_CorporateFrom, vbPartnerId_From, vbMemberId_From, vbCardFuelId_From, vbTicketFuelId_From, vbUnitId_From
               , vbInfoMoneyId_From
               , vbJuridicalId_To, vbIsCorporate_To, vbInfoMoneyId_CorporateTo, vbPartnerId_To, vbMemberId_To, vbFounderId_To, vbInfoMoneyId_To, vbPaidKindId_To, vbContractId_To, vbChangePercent_To, vbIsAccount_30000
               , vbUnitId, vbCarId, vbMemberId_Driver, vbBranchId_To, vbBranchId_Car, vbAccountDirectionId_To, vbIsPartionDate_Unit
               , vbMemberId_Packer, vbPaidKindId, vbContractId, vbJuridicalId_Basis_To, vbBusinessId_To, vbBusinessId_Route
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue
               , vbInvoiceSumm, vbInvoiceSumm_Currency
               , vbMovementId_Invoice


     FROM (WITH tmpMI_Invoice AS (SELECT MI_Invoice.MovementId AS MovementId
                                  FROM MovementItem
                                       INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                    ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementItemId()
                                                                   AND MIFloat_MovementId.ValueData      > 0
                                       INNER JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id       = MIFloat_MovementId.ValueData :: Integer
                                                                            AND MI_Invoice.isErased = FALSE
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_MASter()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.Amount     > 0
                                  ORDER BY MovementItem.Id DESC
                                  LIMIT 1
                                )
              , tmpMovement_Invoice AS
                               (SELECT tmpMI_Invoice.MovementId                     AS MovementId
                                     , MovementLinkObject_CurrencyDocument.ObjectId AS CurrencyId
                                     , MovementFloat_CurrencyValue.ValueData        AS CurrencyValue
                                     , MovementFloat_ParValue.ValueData             AS ParValue
                                       -- оплата б/н
                                     , CASE WHEN MovementLinkObject_CurrencyDocument.ObjectId = zc_Enum_Currency_Basis()
                                            THEN CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                                      THEN MovementFloat_TotalSumm.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                      ELSE COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                 END
                                            ELSE CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                                      THEN MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                      ELSE COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                 END
                                       END AS TotalSumm_f1
                                       -- оплата нал
                                     , CASE WHEN MovementLinkObject_CurrencyDocument.ObjectId = zc_Enum_Currency_Basis()
                                            THEN CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                                      THEN COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                      ELSE MovementFloat_TotalSumm.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                 END
                                            ELSE CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                                      THEN COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                      ELSE MovementFloat_TotalSummCurrency.ValueData - COALESCE (MovementFloat_TotalSummPayOth.ValueData,0)
                                                 END
                                       END AS TotalSumm_f2
                                FROM tmpMI_Invoice
                                     LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                             ON MovementFloat_CurrencyValue.MovementId = tmpMI_Invoice.MovementId
                                                            AND MovementFloat_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
                                     LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                             ON MovementFloat_ParValue.MovementId = tmpMI_Invoice.MovementId
                                                            AND MovementFloat_ParValue.DescId     = zc_MovementFloat_ParValue()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                                  ON MovementLinkObject_PaidKind.MovementId = tmpMI_Invoice.MovementId
                                                                 AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                                  ON MovementLinkObject_CurrencyDocument.MovementId = tmpMI_Invoice.MovementId
                                                                 AND MovementLinkObject_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                             ON MovementFloat_TotalSumm.MovementId = tmpMI_Invoice.MovementId
                                                            AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSummCurrency
                                                             ON MovementFloat_TotalSummCurrency.MovementId = tmpMI_Invoice.MovementId
                                                            AND MovementFloat_TotalSummCurrency.DescId     = zc_MovementFloat_AmountCurrency()
                                     LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayOth
                                                             ON MovementFloat_TotalSummPayOth.MovementId = tmpMI_Invoice.MovementId
                                                            AND MovementFloat_TotalSummPayOth.DescId     = zc_MovementFloat_TotalSummPayOth()
                               )
           SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
                , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
                , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
                , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
                , COALESCE (MovementFloat_ChangePrice.ValueData, 0) AS ChangePrice

                , Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                , COALESCE (COALESCE (ObjectLink_CardFuel_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId), 0) AS JuridicalId_From
                , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                            THEN TRUE
                       ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
                  END AS isCorporate_From
                , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                            THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                       ELSE 0
                  END AS InfoMoneyId_CorporateFrom

                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner()    THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member()     THEN Object_From.Id ELSE 0 END, 0) AS MemberId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_CardFuel()   THEN Object_From.Id ELSE 0 END, 0) AS CardFuelId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_TicketFuel() THEN Object_From.Id ELSE 0 END, 0) AS TicketFuelId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()       THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From

                  -- УП Статью назначения берем: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_From

                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_PartnerTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
                , CASE WHEN Constant_InfoMoney_isCorporateTo_View.InfoMoneyId IS NOT NULL
                            THEN TRUE
                       ELSE COALESCE (ObjectBoolean_isCorporateTo.ValueData, FALSE)
                  END AS isCorporate_To
                , CASE WHEN Constant_InfoMoney_isCorporateTo_View.InfoMoneyId IS NOT NULL
                            THEN ObjectLink_JuridicalTo_InfoMoney.ChildObjectId
                       ELSE 0
                  END AS InfoMoneyId_CorporateTo
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To
                , COALESCE (CASE WHEN Object_To.DescId IN (zc_Object_Member(), zc_Object_Founder()) THEN Object_To.Id ELSE 0 END, 0) AS MemberId_To
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Founder() THEN Object_To.Id ELSE 0 END, 0) AS FounderId_To


                  -- ПОКУПАТЕЛЮ УП Статью назначения берем: ВСЕГДА по договору
                , COALESCE (ObjectLink_ContractTo_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To
                , COALESCE (MovementLinkObject_PaidKindTo.ObjectId, 0)        AS PaidKindId_To
                , COALESCE (MovementLinkObject_ContractTo.ObjectId, 0)        AS ContractId_To
                , COALESCE (MovementFloat_ChangePercentPartner.ValueData, 0)  AS ChangePercent_To
                , CASE WHEN ObjectLink_PartnerFrom_Unit.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isAccount_30000

                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car() THEN Object_To.Id ELSE 0 END, 0) AS CarId
                , COALESCE (ObjectLink_PersonalDriver_Member.ChildObjectId, 0) AS MemberDriverId
                , COALESCE (ObjectLink_UnitTo_Branch.ChildObjectId, 0) AS BranchId_To
                , COALESCE (ObjectLink_UnitCar_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_Car
                  -- Аналитики счетов - направления
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Car()
                                      THEN zc_Enum_AccountDirection_20500() -- 20000; "Запасы"; 20500; "сотрудники (МО)"
                                 WHEN Object_To.DescId = zc_Object_Member()
                                   -- !!!т.е. если НЕ ГСМ!!!
                                   AND COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) <> zc_Enum_InfoMoney_20401()
                                      THEN zc_Enum_AccountDirection_20500() -- 20000; "Запасы"; 20500; "сотрудники (МО)"
                                 ELSE ObjectLink_UnitTo_AccountDirection.ChildObjectId
                            END, 0) AS AccountDirectionId_To
                , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE)  AS isPartionDate_Unit

                , COALESCE (ObjectLink_Personal_Member.ChildObjectId, MovementLinkObject_PersonalPacker.ObjectId, 0) AS MemberId_Packer
                , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
                , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_ContractTo_JuridicalBasis.ChildObjectId
                                 WHEN Object_To.DescId = zc_Object_Member()  THEN ObjectLink_Contract_JuridicalBasis.ChildObjectId
                                 ELSE ObjectLink_UnitTo_Juridical.ChildObjectId
                            END, 0) AS JuridicalId_Basis_To
                , COALESCE (ObjectLink_UnitTo_Business.ChildObjectId, 0)    AS BusinessId_To
                , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId_Route

                , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
                , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
                , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
                  -- !!!замена!!!
                , CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_ParValue.ValueData ELSE 1 END AS ParValue

                  -- !!!
               , CASE -- если док Приход БН
                      WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                           THEN CASE -- если в счете валюта + в доке Прихода валюта
                                     WHEN tmpMovement_Invoice.CurrencyId <> zc_Enum_Currency_Basis()
                                      AND COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis()
                                          -- переводим сумму счета по ф.2 из валюты - в ГРН !!!по курсу док.!!!
                                          THEN tmpMovement_Invoice.TotalSumm_f2 * MovementFloat_CurrencyValue.ValueData / CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_ParValue.ValueData ELSE 1 END
                                     -- если в счете валюта + в доке Прихода ГРН
                                     WHEN tmpMovement_Invoice.CurrencyId <> zc_Enum_Currency_Basis()
                                          -- переводим сумму счета по ф.2 из валюты - в ГРН
                                          THEN tmpMovement_Invoice.TotalSumm_f2 * tmpMovement_Invoice.CurrencyValue / CASE WHEN tmpMovement_Invoice.ParValue > 0 THEN tmpMovement_Invoice.ParValue ELSE 1 END
                                          -- иначе сумма счета по ф.2
                                     ELSE tmpMovement_Invoice.TotalSumm_f2
                                END
                      -- если док Приход НАЛ
                      WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                           THEN CASE -- если в счете валюта + в доке Прихода валюта
                                     WHEN tmpMovement_Invoice.CurrencyId <> zc_Enum_Currency_Basis()
                                      AND COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) <> zc_Enum_Currency_Basis()
                                          -- переводим сумму счета по ф.1 из валюты - в ГРН !!!по курсу док.!!!
                                          THEN tmpMovement_Invoice.TotalSumm_f1 * MovementFloat_CurrencyValue.ValueData / CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_ParValue.ValueData ELSE 1 END
                                     -- если в счете валюта + в доке Прихода ГРН
                                     WHEN tmpMovement_Invoice.CurrencyId = zc_Enum_Currency_Basis()
                                          -- переводим сумму счета по ф.1 из валюты - в ГРН
                                          THEN tmpMovement_Invoice.TotalSumm_f1 * tmpMovement_Invoice.CurrencyValue / CASE WHEN tmpMovement_Invoice.ParValue > 0 THEN tmpMovement_Invoice.ParValue ELSE 1 END
                                          -- иначе сумма счета по ф.1
                                     ELSE tmpMovement_Invoice.TotalSumm_f1
                                END
                 END AS InvoiceSumm

                 -- !!!
               , CASE WHEN COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) = zc_Enum_Currency_Basis()
                           -- если документ Приход в ГРН
                           THEN 0
                      -- если док Приход БН
                      WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                           THEN CASE WHEN tmpMovement_Invoice.CurrencyId = zc_Enum_Currency_Basis()
                                          -- переводим сумму счета по ф.2 из ГРН - в валюту
                                          THEN CASE WHEN MovementFloat_CurrencyValue.ValueData > 0 THEN tmpMovement_Invoice.TotalSumm_f2 / MovementFloat_CurrencyValue.ValueData * CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_ParValue.ValueData ELSE 1 END ELSE 0 END
                                          -- иначе сумма счета по ф.2
                                     ELSE tmpMovement_Invoice.TotalSumm_f2
                                END
                      -- если док Приход НАЛ
                      WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                           THEN CASE WHEN tmpMovement_Invoice.CurrencyId = zc_Enum_Currency_Basis()
                                          -- переводим сумму счета по ф.1 из ГРН - в валюту
                                          THEN CASE WHEN MovementFloat_CurrencyValue.ValueData > 0 THEN tmpMovement_Invoice.TotalSumm_f1 / MovementFloat_CurrencyValue.ValueData * CASE WHEN MovementFloat_ParValue.ValueData > 0 THEN MovementFloat_ParValue.ValueData ELSE 1 END ELSE 0 END
                                          -- иначе сумма счета по ф.1
                                     ELSE tmpMovement_Invoice.TotalSumm_f1
                                END
                 END AS InvoiceSumm_Currency

               , tmpMovement_Invoice.MovementId AS MovementId_Invoice

           FROM Movement
                LEFT JOIN tmpMovement_Invoice ON 1=1
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
                LEFT JOIN MovementFloat AS MovementFloat_ChangePercentPartner
                                        ON MovementFloat_ChangePercentPartner.MovementId = Movement.Id
                                       AND MovementFloat_ChangePercentPartner.DescId = zc_MovementFloat_ChangePercentPartner()
                LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                        ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                       AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                             ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
                LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                        ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                       AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                        ON MovementFloat_ParValue.MovementId = Movement.Id
                                       AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Unit
                                     ON ObjectLink_PartnerFrom_Unit.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_PartnerFrom_Unit.DescId = zc_ObjectLink_Partner_Unit()

                LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                     ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                        ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                     ON ObjectLink_Juridical_InfoMoney.ObjectId = COALESCE (ObjectLink_CardFuel_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ChildObjectId)
                                    AND ObjectLink_Juridical_InfoMoney.DescId   = zc_ObjectLink_Juridical_InfoMoney()
                LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId


                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Juridical
                                     ON ObjectLink_PartnerTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_PartnerTo_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporateTo
                                        ON ObjectBoolean_isCorporateTo.ObjectId = ObjectLink_PartnerTo_Juridical.ChildObjectId
                                       AND ObjectBoolean_isCorporateTo.DescId   = zc_ObjectBoolean_Juridical_isCorporate()
                LEFT JOIN ObjectLink AS ObjectLink_JuridicalTo_InfoMoney
                                     ON ObjectLink_JuridicalTo_InfoMoney.ObjectId = ObjectLink_PartnerTo_Juridical.ChildObjectId
                                    AND ObjectLink_JuridicalTo_InfoMoney.DescId   = zc_ObjectLink_Juridical_InfoMoney()
                LEFT JOIN Constant_InfoMoney_isCorporate_View AS Constant_InfoMoney_isCorporateTo_View ON Constant_InfoMoney_isCorporateTo_View.InfoMoneyId = ObjectLink_JuridicalTo_InfoMoney.ChildObjectId


                LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                     ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Branch
                                     ON ObjectLink_UnitCar_Branch.ObjectId = ObjectLink_CarTo_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Branch.DescId = zc_ObjectLink_Unit_Branch()

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                     ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                        ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                             ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                            AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                             ON MovementLinkObject_PersonalPacker.MovementId = Movement.Id
                                            AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = MovementLinkObject_PersonalPacker.ObjectId
                                    AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                     ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                    AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                     ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                    AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                             ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                             ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                            AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
                LEFT JOIN ObjectLink AS ObjectLink_ContractTo_InfoMoney
                                     ON ObjectLink_ContractTo_InfoMoney.ObjectId = MovementLinkObject_ContractTo.ObjectId
                                    AND ObjectLink_ContractTo_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_ContractTo_JuridicalBasis
                                     ON ObjectLink_ContractTo_JuridicalBasis.ObjectId = MovementLinkObject_ContractTo.ObjectId
                                    AND ObjectLink_ContractTo_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Unit
                                     ON ObjectLink_PartnerTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_PartnerTo_Unit.DescId = zc_ObjectLink_Partner_Unit()

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                                     ON ObjectLink_UnitTo_Juridical.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId)
                                    AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                                     ON ObjectLink_UnitTo_Business.ObjectId = COALESCE (ObjectLink_PartnerTo_Unit.ChildObjectId, COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, MovementLinkObject_To.ObjectId))
                                    AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                             ON MovementLinkObject_Route.MovementId = Movement.Id
                                            AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                     ON ObjectLink_Route_Unit.ObjectId = MovementLinkObject_Route.ObjectId
                                    AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                     ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                    AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()

                LEFT JOIN ObjectLink AS ObjectLink_PersonalDriver_Member
                                     ON ObjectLink_PersonalDriver_Member.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                    AND ObjectLink_PersonalDriver_Member.DescId = zc_ObjectLink_Personal_Member()

           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND vbUnitId_From = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен № договора <%>.', vbUnitId_From;
     END IF;

     -- проверка Сотрудник (если заправка <физ-лицо> и НЕ <Учредитель> и НЕ <ОС>)
     IF vbMemberId_To <> 0 AND vbFounderId_To = 0 AND vbMovementDescId <> zc_Movement_IncomeAsset()
     THEN
         -- проверка
         IF COALESCE ((SELECT View_Personal.PersonalId FROM Object_Personal_View AS View_Personal WHERE View_Personal.MemberId = vbMemberId_To AND View_Personal.isMain = TRUE AND View_Personal.isErased = FALSE LIMIT 1), 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для физ. лицо <%> не определен <Сотрудник>.', lfGet_Object_ValueData (vbMemberId_To);
         END IF;
     END IF;


     -- Пересчитали цену - для ГСМ
     IF vbCardFuelId_From <> 0
     THEN
         -- нашли Прайс
         vbPriceListId_Fuel:= COALESCE
                             ((-- 1. Поиск в Договоре
                               SELECT ObjectLink_Contract_PriceList.ChildObjectId
                               FROM ObjectLink AS ObjectLink_Contract_PriceList
                               WHERE ObjectLink_Contract_PriceList.ObjectId = vbContractId
                                 AND ObjectLink_Contract_PriceList.DescId   = zc_ObjectLink_Contract_PriceList()
                                 -- AND inUserId = 5
                              )
                            , (-- 1. Поиск у Юр Лица
                               SELECT CASE WHEN vbOperDatePartner >= ObjectDate_Juridical_StartPromo.ValueData THEN ObjectLink_Juridical_PriceList.ChildObjectId ELSE 0 END
                               FROM ObjectLink AS ObjectLink_CardFuel_Juridical
                                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                         ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_CardFuel_Juridical.ChildObjectId
                                                        AND ObjectLink_Juridical_PriceList.DescId   = zc_ObjectLink_Juridical_PriceList()
                                    LEFT JOIN ObjectDate AS ObjectDate_Juridical_StartPromo
                                                         ON ObjectDate_Juridical_StartPromo.ObjectId = ObjectLink_CardFuel_Juridical.ChildObjectId
                                                        AND ObjectDate_Juridical_StartPromo.DescId   = zc_ObjectDate_Juridical_StartPromo()
                               WHERE ObjectLink_CardFuel_Juridical.ObjectId = vbCardFuelId_From
                                 AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                 -- AND inUserId = 5
                              ));


         IF vbPriceListId_Fuel > 0
         THEN
             -- сохранили свойство <Цена>
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.MovementItemId, tmp.ValuePrice)
             FROM (WITH tmpMI AS (SELECT MovementItem.*
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                   , tmpPrice AS (SELECT tmpMI.Id AS MovementItemId
                                       , COALESCE (ObjectHistoryFloat_Value.ValueData, 0) AS ValuePrice
                                  FROM tmpMI
                                       INNER JOIN ObjectLink AS ObjectLink_Goods
                                                             ON ObjectLink_Goods.ChildObjectId = tmpMI.ObjectId
                                                            AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                       INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                             ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                            AND ObjectLink_PriceList.ChildObjectId = vbPriceListId_Fuel
                                                            AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                       INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                               AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                               AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                                    ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                   AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                 )
                   SELECT tmpMI.Id AS MovementItemId, COALESCE (tmpPrice.ValuePrice, 0) AS ValuePrice
                   FROM tmpMI
                        LEFT JOIN tmpPrice ON tmpPrice.MovementItemId = tmpMI.Id
                  ) AS tmp;

              -- пересчитали Итоговые суммы по накладной
              PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

              -- проверка - для Цены ГСМ из Прайса
              IF EXISTS (SELECT 1 FROM (WITH tmpMI AS (SELECT MovementItem.*
                                                       FROM MovementItem
                                                       WHERE MovementItem.MovementId = inMovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                                      )
                                        , tmpPrice AS (SELECT tmpMI.Id AS MovementItemId
                                                            , COALESCE (ObjectHistoryFloat_Value.ValueData, 0) AS ValuePrice
                                                       FROM tmpMI
                                                            INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                                 ON ObjectLink_Goods.ChildObjectId = tmpMI.ObjectId
                                                                                AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                                            INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                                  ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                                                 AND ObjectLink_PriceList.ChildObjectId = vbPriceListId_Fuel
                                                                                 AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                            INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                                     ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                                                    AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                                                    AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                                                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                                                         ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                                        AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                      )
                                        SELECT tmpMI.Id AS MovementItemId, COALESCE (tmpPrice.ValuePrice, 0) AS ValuePrice
                                        FROM tmpMI
                                             LEFT JOIN tmpPrice ON tmpPrice.MovementItemId = tmpMI.Id
                                        WHERE COALESCE (tmpPrice.ValuePrice, 0) = 0
                                       ) AS tmp
                        )
              THEN
                  RAISE EXCEPTION 'Ошибка.Для Топлива <%> НЕ установлена цена в прайсе <%>.'
                                , lfGet_Object_ValueData_sh ((SELECT tmp.ObjectId
                                                              FROM (WITH tmpMI AS (SELECT MovementItem.*
                                                                                   FROM MovementItem
                                                                                   WHERE MovementItem.MovementId = inMovementId
                                                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                                                     AND MovementItem.isErased   = FALSE
                                                                                  )
                                                                    , tmpPrice AS (SELECT tmpMI.Id AS MovementItemId
                                                                                        , COALESCE (ObjectHistoryFloat_Value.ValueData, 0) AS ValuePrice
                                                                                   FROM tmpMI
                                                                                        INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                                                             ON ObjectLink_Goods.ChildObjectId = tmpMI.ObjectId
                                                                                                            AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                                                                        INNER JOIN ObjectLink AS ObjectLink_PriceList
                                                                                                              ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                                                                                             AND ObjectLink_PriceList.ChildObjectId = vbPriceListId_Fuel
                                                                                                             AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                                                        INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                                                                 ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                                                                                AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                                                                                AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                                                                                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                                                                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                                                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                                                  )
                                                                    SELECT tmpMI.ObjectId, COALESCE (tmpPrice.ValuePrice, 0) AS ValuePrice
                                                                    FROM tmpMI
                                                                         LEFT JOIN tmpPrice ON tmpPrice.MovementItemId = tmpMI.Id
                                                                    WHERE COALESCE (tmpPrice.ValuePrice, 0) = 0
                                                                    LIMIT 1
                                                                   ) AS tmp
                                                            ))
                                , lfGet_Object_ValueData_sh (vbPriceListId_Fuel);
              END IF;

         END IF;

     END IF;


     -- определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках
     SELECT lfGet_InfoMoney.InfoMoneyGroupId, lfGet_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyGroupId_From, vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS lfGet_InfoMoney;
     -- ПОКУПАТЕЛЮ определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках
     SELECT lfGet_InfoMoney.InfoMoneyGroupId, lfGet_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyGroupId_To, vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS lfGet_InfoMoney;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods, ContainerId_CountSupplier, GoodsId, GoodsKindId, AssetId, UnitId_Asset, PartionGoods, PartionGoodsDate
                         , ContainerId_GoodsTicketFuel, GoodsId_TicketFuel
                         , ContainerId_Goods_Unit, GoodsId_Unit
                         , OperCount, OperCount_Partner, OperCount_Packer
                         , tmpOperSumm, OperSumm
                         , tmpOperSumm_Partner, OperSumm_Partner, tmpOperSumm_Partner_Currency, OperSumm_Partner_Currency, Price_Currency
                         , tmpOperSumm_Packer, OperSumm_Packer
                         , tmpOperSumm_PartnerTo, OperSumm_PartnerTo
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyGroupId_Detail, InfoMoneyDestinationId_Detail, InfoMoneyId_Detail
                         , BusinessId
                         , ContainerId_ProfitLoss
                         , isPartionCount, isPartionSumm, isTareReturning, isAsset
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Summ          -- сформируем позже
            , 0 AS ContainerId_Goods         -- сформируем позже
            , 0 AS ContainerId_CountSupplier -- сформируем позже
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , CASE WHEN _tmp.UnitId_Asset > 0 THEN _tmp.UnitId_Asset ELSE vbUnitId END AS UnitId_Asset
          --, vbUnitId AS UnitId_Asset
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate

            , 0 AS ContainerId_GoodsTicketFuel
            , _tmp.GoodsId_TicketFuel

            , 0 AS ContainerId_Goods_Unit
            , _tmp.GoodsId_Unit

              -- количество с остатка
            , _tmp.OperCount
              -- количество у контрагента
            , CASE WHEN _tmp.Price = 0
                    AND vbMemberId_From = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN _tmp.OperCount
                   WHEN vbUnitId_From > 0
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_Partner
              END AS OperCount_Partner
              -- количество у заготовителя
            , _tmp.OperCount_Packer

              -- промежуточная сумма !!!КОЛ-ВО СКЛАД!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_ChangePrice AS tmpOperSumm
              -- конечная сумма !!!КОЛ-ВО СКЛАД!!!
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_ChangePrice)
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_ChangePrice) AS NUMERIC (16, 2))
                           END
              END AS OperSumm


              -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner_ChangePrice AS tmpOperSumm_Partner
              -- конечная сумма по Контрагенту
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_Partner_ChangePrice)
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner

              -- промежуточная сумма в валюте по Контрагенту - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner_ChangePrice_Currency AS tmpOperSumm_Partner_Currency
              -- конечная сумма в валюте по Контрагенту
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_Partner_ChangePrice_Currency)
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner_Currency
              -- !!! ЦЕНА в валюте !!!
            , _tmp.Price_Currency

              -- промежуточная сумма по Сотруднику (заготовитель) - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Packer
              -- конечная сумма по Сотруднику (заготовитель)
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                ELSE (tmpOperSumm_Packer)
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                      THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Packer

              -- промежуточная сумма по ПОКУПАТЕЛЮ - с округлением до 2-х знаков
            , 0 AS tmpOperSumm_PartnerTo
              -- конечная сумма по ПОКУПАТЕЛЮ
            , 0 AS OperSumm_PartnerTo

            , 0 AS AccountId              -- Счет(справочника), сформируем позже

              -- УП для Income = УП у товаров, для остальных (это ОС) = УП долг Контрагента
            , CASE WHEN vbMovementDescId = zc_Movement_Income() THEN _tmp.InfoMoneyGroupId       ELSE vbInfoMoneyGroupId_From       END AS InfoMoneyGroupId
            , CASE WHEN vbMovementDescId = zc_Movement_Income() THEN _tmp.InfoMoneyDestinationId ELSE vbInfoMoneyDestinationId_From END AS InfoMoneyDestinationId
            , CASE WHEN vbMovementDescId = zc_Movement_Income() THEN _tmp.InfoMoneyId            ELSE vbInfoMoneyId_From            END AS InfoMoneyId

              -- Управленческая группа (детализация с/с), она же !!!соответствует!!! УП долг Контрагента
            , CASE WHEN vbInfoMoneyGroupId_From <> 0
                        THEN vbInfoMoneyGroupId_From -- УП ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                   ELSE _tmp.InfoMoneyGroupId -- УП берется по товару
              END AS InfoMoneyGroupId_Detail

              -- Управленческие назначения (детализация с/с), она же !!!соответствует!!! УП долг Контрагента
            , CASE WHEN vbInfoMoneyDestinationId_From <> 0
                        THEN vbInfoMoneyDestinationId_From -- УП ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                   ELSE _tmp.InfoMoneyDestinationId -- УП берется по товару
              END AS InfoMoneyDestinationId_Detail

              -- Статьи назначения (детализация с/с), она же !!!соответствует!!! УП долг Контрагента
            , CASE WHEN vbInfoMoneyId_From <> 0
                        THEN vbInfoMoneyId_From -- УП ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                   ELSE _tmp.InfoMoneyId -- Иначе УП берется по товару
              END AS InfoMoneyId_Detail

              -- значение Бизнес !!!выбирается!!! из 1)Автомобиля или 2)Товара или 3)Подраделения
            , CASE WHEN _tmp.BusinessId = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId END AS BusinessId

              -- для ОПиУ, сформируем позже
            , 0 AS ContainerId_ProfitLoss

            , _tmp.isPartionCount
            , _tmp.isPartionSumm
              -- Надо ли делать забалансовые проводки для Количественный учет - долги поставщику
            , CASE WHEN _tmp.Price = 0
                    AND vbMemberId_From = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN TRUE
                   ELSE FALSE
               END AS isTareReturning

            , _tmp.isAsset

            , 0 AS PartionGoodsId -- Партии товара, сформируем позже

        FROM (SELECT
                     tmp.MovementItemId
                     -- если Вид топлива, иначе - Товар
                   , tmp.GoodsId
                   , tmp.GoodsKindId
                   , tmp.AssetId
                   , tmp.UnitId_Asset
                   , tmp.PartionGoods
                   , tmp.PartionGoodsDate

                   , tmp.GoodsId_TicketFuel
                   , tmp.GoodsId_Unit

                   , tmp.OperCount
                   , tmp.OperCount_Partner
                   , tmp.OperCount_Packer
                   , tmp.Price
                   , tmp.Price_Currency

                     -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                   -- , COALESCE (CAST (tmp.OperCount_Partner *  tmp.Price                  / tmp.CountForPrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_Partner
                     -- промежуточная сумма в валюте по Контрагенту - с округлением до 2-х знаков
                   , COALESCE (CAST (tmp.OperCount_Partner * (tmp.Price_Currency - 0)    / tmp.CountForPrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_Partner_ChangePrice_Currency
                     -- промежуточная сумма по Контрагенту с учетом скидки в цене - с округлением до 2-х знаков
                   , COALESCE (CAST (tmp.OperCount_Partner * (tmp.Price - vbChangePrice) / tmp.CountForPrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_Partner_ChangePrice
                     -- промежуточная сумма !!!КОЛ-ВО СКЛАД!!! - с учетом скидки в цене - с округлением до 2-х знаков
                   , COALESCE (CAST (tmp.OperCount         * (tmp.Price - vbChangePrice) / tmp.CountForPrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_ChangePrice

                     -- промежуточная сумма по Сотруднику (заготовитель) - с округлением до 2-х знаков
                   , COALESCE (CAST (tmp.OperCount_Packer * tmp.Price / tmp.CountForPrice AS NUMERIC (16, 2)), 0) AS tmpOperSumm_Packer

                     -- Управленческая группа
                   , tmp.InfoMoneyGroupId
                     -- Управленческие назначения
                   , tmp.InfoMoneyDestinationId
                     -- Статьи назначения
                   , tmp.InfoMoneyId

                     -- Бизнес из Товара нужен только если не <Вид топлива>
                   , tmp.BusinessId

                   , tmp.isPartionCount
                   , tmp.isPartionSumm
                   , tmp.isAsset

              FROM
             (-- перевод цены в валюту zc_Enum_Currency_Basis
              SELECT
                     MovementItem.Id AS MovementItemId
                     -- если Вид топлива, иначе - Товар
                   , COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, MovementItem.ObjectId) AS GoodsId
                   , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) -- Ирна + Готовая продукция
                          WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                               THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                          ELSE 0
                     END AS GoodsKindId
                   , CASE WHEN MILinkObject_Asset.ObjectId > 0 THEN MILinkObject_Asset.ObjectId WHEN vbMovementDescId = zc_Movement_IncomeAsset() AND Object_Goods.DescId = zc_Object_Asset() THEN Object_Goods.Id ELSE 0 END AS AssetId
                   , COALESCE (MILinkObject_Unit.ObjectId, 0)  AS UnitId_Asset
                   , CASE WHEN COALESCE (MIString_PartionGoods.ValueData, '') <> '' THEN MIString_PartionGoods.ValueData
                          WHEN COALESCE (MIString_PartionGoodsCalc.ValueData, '') <> '' THEN MIString_PartionGoodsCalc.ValueData
                          ELSE ''
                     END AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                   , MovementItem.ObjectId AS GoodsId_TicketFuel
                   , MovementItem.ObjectId AS GoodsId_Unit

                   , MovementItem.Amount                           AS OperCount
                   , CASE WHEN Movement.DescId = zc_Movement_IncomeAsset() THEN MovementItem.Amount ELSE COALESCE (MIFloat_AmountPartner.ValueData, 0) END AS OperCount_Partner
                   , COALESCE (MIFloat_AmountPacker.ValueData, 0)  AS OperCount_Packer

                   , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                               -- так переводится в валюту zc_Enum_Currency_Basis
                               THEN CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN vbParValue = 0 THEN 1 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price

                   , CASE WHEN vbCurrencyDocumentId =  zc_Enum_Currency_Basis()
                           AND vbCurrencyPartnerId  <> zc_Enum_Currency_Basis()
                               -- так переводится в валюту vbCurrencyPartnerId
                               THEN CASE WHEN vbCurrencyValue = 0 OR vbParValue = 0 THEN 0 ELSE CAST (COALESCE (MIFloat_Price.ValueData, 0) / (vbCurrencyValue / vbParValue) AS NUMERIC (16, 2)) END
                          WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                           AND vbCurrencyPartnerId  <> zc_Enum_Currency_Basis()
                           AND vbCurrencyPartnerId  =  vbCurrencyDocumentId
                               -- так оставляется в валюте vbCurrencyDocumentId
                               THEN COALESCE (MIFloat_Price.ValueData, 0)

                          WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                           AND vbCurrencyPartnerId  =  zc_Enum_Currency_Basis()
                               -- так переводится в валюту zc_Enum_Currency_Basis - но это НЕ надо, т.к. ДОЛГ НЕ В ВАЛЮТЕ
                               THEN 0 -- CAST (COALESCE (MIFloat_Price.ValueData, 0) * CASE WHEN vbParValue = 0 THEN 1 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                          ELSE 0
                     END AS Price_Currency

                   , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                    -- Управленческая группа
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfGet_InfoMoney_Fuel.InfoMoneyGroupId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyGroupId, 0)
                    END AS InfoMoneyGroupId
                    -- Управленческие назначения
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfGet_InfoMoney_Fuel.InfoMoneyDestinationId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0)
                    END AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN COALESCE (lfGet_InfoMoney_Fuel.InfoMoneyId, 0)
                         ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                    END AS InfoMoneyId

                    -- Бизнес из Товара нужен только если не <Вид топлива>
                  , CASE WHEN COALESCE (ObjectLink_Goods_Fuel.ChildObjectId, 0) <> 0 THEN 0
                         ELSE COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0)
                    END AS BusinessId

                   , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
                   , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)  AS isPartionSumm
                   , COALESCE (ObjectBoolean_Asset.ValueData, FALSE)        AS isAsset

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                               ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                                ON MIString_PartionGoodsCalc.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Asset
                                           ON ObjectBoolean_Asset.ObjectId = MovementItem.ObjectId
                                          AND ObjectBoolean_Asset.DescId   = zc_ObjectBoolean_Goods_Asset()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                                        ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                       AND ObjectLink_Goods_Fuel.ChildObjectId <> 0 -- !!!обязательно, что б смело использовать COALESCE!!!
                                       AND vbCarId <> 0 -- !!!обязательно, т.к. в остальных случаях нужен товар!!!

                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                    AND ObjectLink_Goods_Fuel.ChildObjectId IS NULL
                   LEFT JOIN lfGet_Object_InfoMoney (zc_Enum_InfoMoney_20401()) AS lfGet_InfoMoney_Fuel ON ObjectLink_Goods_Fuel.ChildObjectId <> 0 -- ГСМ

              WHERE Movement.Id = inMovementId
                AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_IncomeAsset())
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
             ) AS _tmp
        ;

     -- проверка - MovementId_Invoice
     IF vbMovementDescId = zc_Movement_IncomeAsset() AND COALESCE (vbMovementId_Invoice, 0) = 0
     THEN
         IF NOT EXISTS (SELECT 1 FROM _tmpItem)
         THEN
             RAISE EXCEPTION 'Ошибка.В документе не заполнено кол-во.';
         ELSE
             IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperSumm_Partner <> 0)
             THEN
                 RAISE EXCEPTION 'Ошибка.Необходимо заполнить значение <№ док. Счет>.';
             END IF;
         END IF;
     END IF;


     -- !!!с/с тары будем списывать сразу в ОПиУ!!!
     UPDATE _tmpItem SET ContainerId_ProfitLoss = lpInsertFind_Container
                                                        (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := zc_Enum_Account_100301() -- прибыль текущего периода
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                       , inBusinessId        := vbBusinessId_To
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                       , inObjectId_1        := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := zc_Enum_ProfitLossGroup_20000()      -- Общепроизводственные расходы
                                                                                                              , inProfitLossDirectionId  := zc_Enum_ProfitLossDirection_20100()  -- Содержание производства
                                                                                                              , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                              , inInfoMoneyId            := NULL
                                                                                                              , inUserId                 := inUserId
                                                                                                               )
                                                       , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_2        := 0 -- zc_Branch_Basis(), может потом распределим в самом отчете
                                                        )
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
       AND _tmpItem.isTareReturning        = FALSE -- т.е. купили
    ;


     -- !!!формируются суммы ПОКУПАТЕЛЮ!!! - !!!КОЛ-ВО СКЛАД!!!
     UPDATE _tmpItem SET tmpOperSumm_PartnerTo = CAST ((1 + vbChangePercent_To / 100)
                                               * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                                                           -- если цены с НДС или %НДС=0
                                                           THEN tmpOperSumm -- (tmpOperSumm_Partner)
                                                      -- если цены без НДС
                                                      ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                                 END AS NUMERIC (16, 2))
                       , OperSumm_PartnerTo    = CAST ((1 + vbChangePercent_To / 100)
                                               * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                                                           -- если цены с НДС или %НДС=0
                                                           THEN tmpOperSumm -- (tmpOperSumm_Partner)
                                                      -- если цены без НДС
                                                      ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                                                 END AS NUMERIC (16, 2))
     WHERE vbPartnerId_To <> 0;

     -- проверка
     IF 1=0 AND COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE AND OperSumm_Partner <> 0)
                                       -- AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!! НАЛ !!!
                                           )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;

     -- проверка
     IF COALESCE (vbContractId_To, 0) = 0 AND vbPartnerId_To <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор (Покупателя)>.Проведение невозможно.';
     END IF;

     -- проверка - если есть Суммы < 0, то <Ошибка>
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE tmpOperSumm_Partner < 0 OR OperSumm_Partner < 0 OR OperSumm_PartnerTo < 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Есть элементы с отрицательной суммой.';
     END IF;
     -- проверка - если Товар не определен
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE COALESCE (GoodsId, 0) = 0)
     THEN
         IF vbMovementDescId = zc_Movement_IncomeAsset()
         THEN
             RAISE EXCEPTION 'Ошибка.Не определено значение <Название (ОС)>.';
         ELSE
             RAISE EXCEPTION 'Ошибка.Не определено значение <Товар>.';
         END IF;
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- Расчеты сумм
     SELECT -- Расчет Итоговой суммы по Контрагенту
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            -- Расчет Итоговой суммы в валюте по Контрагенту
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              ELSE tmpOperSumm_Partner_Currency
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
            END
            -- Расчет Итоговой суммы по Сотруднику (заготовитель) (точно так же как и для Контрагента)
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              ELSE tmpOperSumm_Packer
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * tmpOperSumm_Packer AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm_Packer AS NUMERIC (16, 2))
                         END
            END
            -- Расчет Итоговой суммы по ПОКУПАТЕЛЮ - !!!КОЛ-ВО СКЛАД!!!
          , CAST ((1 + vbChangePercent_To / 100)
          * CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0
                    THEN tmpOperSumm
                 -- если цены без НДС
                 ELSE CAST ( (1 + vbVATPercent / 100) * tmpOperSumm AS NUMERIC (16, 2))
            END AS NUMERIC (16, 2))

            INTO vbOperSumm_Partner, vbOperSumm_Currency, vbOperSumm_Packer, vbOperSumm_PartnerTo

     FROM (SELECT SUM (_tmpItem.tmpOperSumm_Partner)          AS tmpOperSumm_Partner
                , SUM (_tmpItem.tmpOperSumm_Partner_Currency) AS tmpOperSumm_Partner_Currency
                , SUM (_tmpItem.tmpOperSumm_Packer)           AS tmpOperSumm_Packer
                , SUM (_tmpItem.tmpOperSumm)                  AS tmpOperSumm
           FROM _tmpItem
          ) AS _tmpItem
     ;


     -- Расчет Итоговых сумм (по элементам)
     SELECT SUM (OperSumm_Partner), SUM (OperSumm_Partner_Currency), SUM (OperSumm_Packer), SUM (OperSumm_PartnerTo) INTO vbOperSumm_Partner_byItem, vbOperSumm_Currency_byItem, vbOperSumm_Packer_byItem, vbOperSumm_PartnerTo_byItem FROM _tmpItem;


     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId = (SELECT MovementItemId FROM _tmpItem ORDER BY OperSumm_Partner DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы в валюте по Контрагенту
     IF COALESCE (vbOperSumm_Currency, 0) <> COALESCE (vbOperSumm_Currency_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner_Currency = OperSumm_Partner_Currency - (vbOperSumm_Currency_byItem - vbOperSumm_Currency)
         WHERE MovementItemId = (SELECT MovementItemId FROM _tmpItem ORDER BY OperSumm_Partner_Currency DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы по Сотруднику (заготовитель)
     IF COALESCE (vbOperSumm_Packer, 0) <> COALESCE (vbOperSumm_Packer_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Packer = OperSumm_Packer - (vbOperSumm_Packer_byItem - vbOperSumm_Packer)
         WHERE MovementItemId = (SELECT MovementItemId FROM _tmpItem ORDER BY OperSumm_Packer DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы по ПОКУПАТЕЛЮ
     IF COALESCE (vbOperSumm_PartnerTo, 0) <> COALESCE (vbOperSumm_PartnerTo_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PartnerTo = OperSumm_PartnerTo - (vbOperSumm_PartnerTo_byItem - vbOperSumm_PartnerTo)
         WHERE MovementItemId = (SELECT MovementItemId FROM _tmpItem ORDER BY OperSumm_PartnerTo DESC LIMIT 1);
     END IF;


     -- №1 - формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbMovementDescId = zc_Movement_IncomeAsset()
                                                 OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                    THEN lpInsertFind_Object_PartionGoods (inMovementId    := inMovementId
                                                                                         , inGoodsId       := _tmpItem.GoodsId
                                                                                         , inUnitId        := _tmpItem.UnitId_Asset
                                                                                         , inStorageId     := NULL
                                                                                         , inInvNumber     := NULL
                                                                                          )
                                               WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                AND vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                               WHEN vbOperDate >= zc_DateStart_PartionGoods_20103()
                                                AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20103() -- Запчасти и Ремонты + Шины
                                                   THEN lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                   THEN lpInsertFind_Object_PartionGoods (inOperDate:= _tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                   THEN 0

                                               WHEN _tmpItem.isAsset = TRUE
                                                AND _tmpItem.PartionGoods <> ''
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= vbUnitId
                                                                                        , inGoodsId       := _tmpItem.GoodsId
                                                                                        , inStorageId     := NULL
                                                                                      --, inPartionModelId:= ???
                                                                                        , inInvNumber     := _tmpItem.PartionGoods
                                                                                      --, inPartNumber    := ???
                                                                                        , inOperDate      := vbOperDate
                                                                                        , inPrice         := CASE WHEN _tmpItem.OperCount_Partner > 0 THEN _tmpItem.OperSumm_Partner / _tmpItem.OperCount_Partner ELSE 0 END
                                                                                         )

                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                 -- OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
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
        OR _tmpItem.InfoMoneyId            = zc_Enum_InfoMoney_20103()            -- Запчасти и Ремонты + Шины
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
        -- OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
        OR vbMovementDescId = zc_Movement_IncomeAsset()
     ;


     -- №2 - формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = lpInsertFind_Object_PartionGoods (inValue:= _tmpItem.PartionGoods)
     WHERE _tmpItem.PartionGoodsId = 0
       AND _tmpItem.PartionGoods <> ''
       AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
     ;


     -- формируются для Партий Спецодежда
     INSERT INTO _tmpItemPartion_20202 (MovementItemId, PartionGoodsId, ContainerId_Goods, ContainerId_Summ, PartionGoods, OperCount, OperSumm)
        WITH tmpList AS (SELECT GENERATE_SERIES (1, 10000) AS Num)
        SELECT _tmpItem.MovementItemId
              , 0 AS PartionGoodsId
              , 0 AS ContainerId_Goods
              , 0 AS ContainerId_Summ
              , _tmpItem.PartionGoods || '-' || (COALESCE (MIFloat_PartionNumStart.ValueData, 0) :: Integer  + tmpList.Num - 1) :: TVarChar || '-' || zfConvert_DateToString (vbOperDate)
              , 1 AS OperCount
                -- разбили сумму по партиям
              , CASE WHEN _tmpItem.OperCount > 0 THEN _tmpItem.OperSumm / _tmpItem.OperCount ELSE 0 END AS OperSumm
        FROM _tmpItem
             LEFT JOIN tmpList ON tmpList.Num <= _tmpItem.OperCount
             LEFT JOIN MovementItemFloat AS MIFloat_PartionNumStart
                                         ON MIFloat_PartionNumStart.MovementItemId = _tmpItem.MovementItemId
                                        AND MIFloat_PartionNumStart.DescId = zc_MIFloat_PartionNumStart()
        WHERE _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202()
          AND (vbOperDate >= '01.02.2021' OR inUserId = 5)
          AND _tmpItem.PartionGoods <> ''
        ;

     -- корректируем "копейки"
     UPDATE _tmpItemPartion_20202 SET OperSumm = _tmpItemPartion_20202.OperSumm - (tmpSumm.OperSumm - _tmpItem.OperSumm)
     FROM -- нашли первый, который надо скорректировать, с максимальной суммой
          (SELECT _tmpItemPartion_20202.MovementItemId, _tmpItemPartion_20202.PartionGoodsId
                , ROW_NUMBER() OVER (PARTITION BY _tmpItemPartion_20202.MovementItemId ORDER BY _tmpItemPartion_20202.OperSumm DESC) AS Ord
           FROM _tmpItemPartion_20202
          ) AS tmpItemPartion_one
          -- итого сумма в партиях
          JOIN (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperSumm) AS OperSumm FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
               ) AS tmpSumm ON tmpSumm.MovementItemId = tmpItemPartion_one.MovementItemId
          -- текущие Элементы, если суммы не равны
          JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                       AND _tmpItem.OperSumm       <> tmpSumm.OperSumm

     WHERE _tmpItemPartion_20202.MovementItemId = tmpItemPartion_one.MovementItemId
       AND _tmpItemPartion_20202.PartionGoodsId = tmpItemPartion_one.PartionGoodsId
       AND tmpItemPartion_one.Ord = 1
      ;

     -- проверка - для кол-во
     IF EXISTS (SELECT 1
                FROM -- итого сумма в партиях
                     (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperCount) AS OperCount FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                     ) AS tmpSumm
                     -- текущие Элементы, если суммы не равны
                     JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                  AND _tmpItem.OperCount      <> tmpSumm.OperCount
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> распределенная сумма в партиях <%> не равна сумме в документе <%>.'
                       , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                          FROM -- итого сумма в партиях
                               (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperCount) AS OperCount FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                               ) AS tmpSumm
                               -- текущие Элементы, если суммы не равны
                               JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                            AND _tmpItem.OperCount      <> tmpSumm.OperCount
                          ORDER BY _tmpItem.MovementItemId
                          LIMIT 1
                         )
                       , (SELECT zfConvert_FloatToString (tmpSumm.OperSumm)
                          FROM -- итого сумма в партиях
                               (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperCount) AS OperCount FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                               ) AS tmpSumm
                               -- текущие Элементы, если суммы не равны
                               JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                            AND _tmpItem.OperCount      <> tmpSumm.OperCount
                          ORDER BY _tmpItem.MovementItemId
                          LIMIT 1
                         )
                       , (SELECT zfConvert_FloatToString (_tmpItem.OperSumm)
                          FROM -- итого сумма в партиях
                               (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperCount) AS OperCount FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                               ) AS tmpSumm
                               -- текущие Элементы, если суммы не равны
                               JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                            AND _tmpItem.OperCount      <> tmpSumm.OperCount
                          ORDER BY _tmpItem.MovementItemId
                          LIMIT 1
                         )
                        ;
     END IF;

     -- проверка - для суммы
     IF EXISTS (SELECT 1
                FROM -- итого сумма в партиях
                     (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperSumm) AS OperSumm FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                     ) AS tmpSumm
                     -- текущие Элементы, если суммы не равны
                     JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                  AND _tmpItem.OperSumm       <> tmpSumm.OperSumm
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> распределенная сумма в партиях <%> не равна сумме в документе <%>.'
                       , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                          FROM -- итого сумма в партиях
                               (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperSumm) AS OperSumm FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                               ) AS tmpSumm
                               -- текущие Элементы, если суммы не равны
                               JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                            AND _tmpItem.OperSumm       <> tmpSumm.OperSumm
                          ORDER BY _tmpItem.MovementItemId
                          LIMIT 1
                         )
                       , (SELECT zfConvert_FloatToString (tmpSumm.OperSumm)
                          FROM -- итого сумма в партиях
                               (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperSumm) AS OperSumm FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                               ) AS tmpSumm
                               -- текущие Элементы, если суммы не равны
                               JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                            AND _tmpItem.OperSumm       <> tmpSumm.OperSumm
                          ORDER BY _tmpItem.MovementItemId
                          LIMIT 1
                         )
                       , (SELECT zfConvert_FloatToString (_tmpItem.OperSumm)
                          FROM -- итого сумма в партиях
                               (SELECT _tmpItemPartion_20202.MovementItemId, SUM (_tmpItemPartion_20202.OperSumm) AS OperSumm FROM _tmpItemPartion_20202 GROUP BY _tmpItemPartion_20202.MovementItemId
                               ) AS tmpSumm
                               -- текущие Элементы, если суммы не равны
                               JOIN _tmpItem ON _tmpItem.MovementItemId =  tmpSumm.MovementItemId
                                            AND _tmpItem.OperSumm       <> tmpSumm.OperSumm
                          ORDER BY _tmpItem.MovementItemId
                          LIMIT 1
                         )
                        ;
     END IF;


     -- формируются для Партий Спецодежда
     UPDATE _tmpItemPartion_20202 SET PartionGoodsId = lpInsertFind_Object_PartionGoods (inValue       := PartionGoods
                                                                                       , inOperDate    := vbOperDate
                                                                                       , inInfoMoneyId := zc_Enum_InfoMoney_20202()
                                                                                        );


     -- заполняем таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках, здесь по !!!InfoMoneyId_Detail!!!
     -- !!!только если не талон + Не заправка со склада!!!
     INSERT INTO _tmpItem_SummPartner (MovementItemId, ContainerId, ContainerId_Currency, ContainerId_re, ContainerId_Currency_re, AccountId, ContainerId_Transit, AccountId_Transit, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, UnitId_Asset, GoodsId, GoodsKindId, OperSumm_Partner, OperSumm_Partner_Currency)
        SELECT _tmpSumm.MovementItemId
             , 0 AS ContainerId, 0 AS ContainerId_Currency, 0 AS ContainerId_re, 0 AS ContainerId_Currency_re
             , 0 AS AccountId, 0 AS ContainerId_Transit, 0 AS AccountId_Transit
             , _tmpSumm.InfoMoneyGroupId_Detail, _tmpSumm.InfoMoneyDestinationId_Detail, _tmpSumm.InfoMoneyId_Detail, _tmpSumm.BusinessId, _tmpSumm.UnitId_Asset
             , _tmpSumm.GoodsId
             , _tmpSumm.GoodsKindId
             , (_tmpSumm.OperSumm_Partner)          AS OperSumm_Partner
             , (_tmpSumm.OperSumm_Partner_Currency) AS OperSumm_Partner_Currency
        FROM (SELECT _tmpSumm_all.MovementItemId
                   , _tmpSumm_all.InfoMoneyGroupId_Detail
                   , _tmpSumm_all.InfoMoneyDestinationId_Detail
                   , _tmpSumm_all.InfoMoneyId_Detail
                   , _tmpSumm_all.BusinessId
                   , _tmpSumm_all.UnitId_Asset
                   , _tmpSumm_all.GoodsId
                   , _tmpSumm_all.GoodsKindId
                   , _tmpSumm_all.OperSumm_Partner
                   , _tmpSumm_all.OperSumm_Partner_Currency
              FROM (SELECT _tmpItem.MovementItemId, _tmpItem.InfoMoneyGroupId_Detail, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyDestinationId_Detail, _tmpItem.InfoMoneyId_Detail, _tmpItem.BusinessId, _tmpItem.UnitId_Asset, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                         , (_tmpItem.OperSumm_Partner)          AS OperSumm_Partner
                         , (_tmpItem.OperSumm_Partner_Currency) AS OperSumm_Partner_Currency
                    FROM _tmpItem
                    -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
                    -- WHERE _tmpItem.OperSumm_Partner <> 0 AND zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
                    WHERE vbTicketFuelId_From = 0
                      AND vbUnitId_From       = 0
                    -- GROUP BY _tmpItem.InfoMoneyGroupId_Detail, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyDestinationId_Detail, _tmpItem.InfoMoneyId_Detail, _tmpItem.BusinessId, _tmpItem.UnitId_Asset, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                   ) AS _tmpSumm_all
             ) AS _tmpSumm
        -- GROUP BY _tmpSumm.InfoMoneyGroupId_Detail, _tmpSumm.InfoMoneyDestinationId_Detail, _tmpSumm.InfoMoneyId_Detail, _tmpSumm.BusinessId, _tmpSumm.UnitId_Asset, _tmpSumm.GoodsId, _tmpSumm.GoodsKindId
        ;


     -- заполняем таблицу - элементы по ПОКУПАТЕЛЮ, со всеми свойствами для формирования Аналитик в проводках, здесь по !!!MovementItemId!!!
     INSERT INTO _tmpItem_SummPartner_To (MovementItemId, ContainerId_Goods, ContainerId, AccountId, ContainerId_ProfitLoss_70201, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, GoodsId, OperCount_PartnerFrom, OperCount, OperSumm_Partner, OperSumm_70201)
        SELECT _tmpSumm.MovementItemId
             , 0 AS ContainerId_Goods, 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_ProfitLoss_70201
             , vbInfoMoneyGroupId_To, vbInfoMoneyDestinationId_To, vbInfoMoneyId_To
             , _tmpSumm.BusinessId
             , _tmpSumm.GoodsId
             , (_tmpSumm.OperCount_PartnerFrom)                          AS OperCount_PartnerFrom
             , (_tmpSumm.OperCount)                                      AS OperCount
             , (_tmpSumm.OperSumm_PartnerTo)                             AS OperSumm_Partner
             , (_tmpSumm.OperSumm_PartnerTo - _tmpSumm.OperSumm_Partner) AS OperSumm_70201
        FROM (SELECT _tmpSumm_all.MovementItemId
                   , _tmpSumm_all.BusinessId
                   , _tmpSumm_all.GoodsId
                   , _tmpSumm_all.OperCount_PartnerFrom
                   , _tmpSumm_all.OperCount
                   , _tmpSumm_all.OperSumm_Partner
                   , _tmpSumm_all.OperSumm_PartnerTo
              FROM (SELECT _tmpItem.MovementItemId
                         , _tmpItem.BusinessId, _tmpItem.GoodsId
                         , (_tmpItem.OperCount_Partner)  AS OperCount_PartnerFrom
                         , (_tmpItem.OperCount)          AS OperCount
                         , (_tmpItem.OperSumm_Partner)   AS OperSumm_Partner
                         , (_tmpItem.OperSumm_PartnerTo) AS OperSumm_PartnerTo
                    FROM _tmpItem
                    WHERE vbPartnerId_To <> 0
                    -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
                    -- AND WHERE _tmpItem.OperSumm_PartnerTo <> 0 AND zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
                    -- GROUP BY _tmpItem.BusinessId, _tmpItem.GoodsId
                   ) AS _tmpSumm_all
             ) AS _tmpSumm
        -- GROUP BY _tmpSumm.BusinessId, _tmpSumm.GoodsId
       ;

/*
IF inUserId = 5
THEN
    RAISE EXCEPTION '<%>  %', (select _tmpItem_SummPartner_To.OperCount_PartnerFrom from _tmpItem_SummPartner_To)
    , (select _tmpItem_SummPartner_To.OperCount from _tmpItem_SummPartner_To);
    -- 'Повторите действие через 3 мин.'
END IF;
*/
     -- !!!обязательно до ... _tmpItem_SummPersonal и после ...!!! - формируются <норма авто> - если есть лимит в ГРН (это ПРИОРИТЕТНЫЙ вариант)
     -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountFuel(), inMovementId, CASE WHEN tmp.Price <> 0 THEN MovementFloat_Limit.ValueData / tmp.Price ELSE 0 END)
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitDistance(), inMovementId, CASE WHEN tmp.Price <> 0 AND MovementFloat_AmountFuel.ValueData <> 0
                                                                                                     THEN (100 * MovementFloat_Limit.ValueData / tmp.Price) / MovementFloat_AmountFuel.ValueData
                                                                                                ELSE 0
                                                                                           END
                                                                                         )
           -- , lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountFuel(), inMovementId, CASE WHEN tmp.Price <> 0 THEN 100 * (MovementFloat_Limit.ValueData / tmp.Price) / MovementFloat_Distance.ValueData ELSE 0 END)
     FROM MovementFloat AS MovementFloat_Limit
          INNER JOIN MovementFloat AS MovementFloat_Distance
                                   ON MovementFloat_Distance.MovementId =  inMovementId
                                  AND MovementFloat_Distance.DescId = zc_MovementFloat_Distance()
                                  AND MovementFloat_Distance.ValueData <> 0
          LEFT JOIN MovementFloat AS MovementFloat_AmountFuel
                                  ON MovementFloat_AmountFuel.MovementId =  inMovementId
                                 AND MovementFloat_AmountFuel.DescId = zc_MovementFloat_AmountFuel()
          LEFT JOIN (SELECT SUM (_tmpItem.OperSumm_Partner) / SUM (_tmpItem.OperCount_Partner) AS Price
                          , SUM (_tmpItem.OperCount_Partner) AS OperCount_Partner
                     FROM _tmpItem
                     WHERE _tmpItem.OperCount_Partner <> 0
                    ) AS tmp ON tmp.Price <> 0
     WHERE MovementFloat_Limit.MovementId = inMovementId
       AND MovementFloat_Limit.DescId = zc_MovementFloat_Limit()
       AND inMovementId in (3166576, 3158828)
       AND MovementFloat_Limit.ValueData <> 0;

     -- заполняем таблицу - элементы по Сотруднику (ЗП) + затраты "Заправка" + "Учредитель" + "Перевыставление", со всеми свойствами для формирования Аналитик в проводках, здесь по !!!MovementItemId!!!
     INSERT INTO _tmpItem_SummPersonal (MovementItemId, ContainerId_Goods, ContainerId, AccountId, InfoMoneyDestinationId, InfoMoneyId, PersonalId, BranchId, UnitId, PositionId, ServiceDateId, PersonalServiceListId, GoodsId, OperCount, OperSumm_Partner
                                      , OperSumm_20401, OperSumm_21425
                                      , InfoMoneyDestinationId_20401, InfoMoneyId_20401, InfoMoneyDestinationId_21425, InfoMoneyId_21425
                                      , BusinessId_ProfitLoss, BranchId_ProfitLoss, UnitId_ProfitLoss, ProfitLossGroupId, ProfitLossDirectionId
                                      , ContainerId_ProfitLoss_20401, ContainerId_ProfitLoss_21425
                                      , ContainerId_External, AccountId_External
                                      , FounderId, ContractId, JuridicalId
                                       )
        -- "виртуальная запись" для SummReparation, есди вдруг в _tmpItem пусто
        WITH tmpItem_child AS (SELECT MovementItem.Id AS MovementItemId
                               FROM MovementItem
                                    LEFT JOIN _tmpItem ON 1=1
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Child()
                                 AND MovementItem.isErased   = FALSE
                                 -- в _tmpItem пусто
                                 AND _tmpItem.MovementItemId IS NULL
                                 --
                                 AND vbMemberId_To <> 0 AND vbMovementDescId = zc_Movement_Income()
                                 -- !!!т.е. Эта схема ТОЛЬКО для ГСМ!!!
                                 AND vbInfoMoneyId_From = zc_Enum_InfoMoney_20401()
                               LIMIT 1
                              )
        -- Результат
        SELECT _tmpItem.MovementItemId
             , 0 AS ContainerId_Goods, 0 AS ContainerId, 0 AS AccountId
             , tmpPersonal.InfoMoneyDestinationId
             , tmpPersonal.InfoMoneyId
             , tmpPersonal.PersonalId
             , tmpPersonal.BranchId
             , tmpPersonal.UnitId
             , tmpPersonal.PositionId
             , tmpPersonal.ServiceDateId
             , tmpPersonal.PersonalServiceListId
             , _tmpItem.GoodsId
             , _tmpItem.OperCount

               -- Сумма ЗП - баланс
             , _tmpItem.OperSumm_Partner - tmpFuel.SummReparation
             - CASE WHEN tmpFuel.OperSumm_20401 <> 0
                         THEN tmpFuel.OperSumm_20401
                    ELSE 0
               END AS OperSumm_Partner

               -- Сумма ГСМ - затраты
             , CASE WHEN tmpFuel.OperSumm_20401 <> 0
                         THEN tmpFuel.OperSumm_20401
                    ELSE 0
               END AS OperSumm_20401

               -- Сумма амортизация - затраты
             , tmpFuel.SummReparation AS OperSumm_21425

             , lfGet_20401.InfoMoneyDestinationId AS InfoMoneyDestinationId_20401 -- 20401 Общефирменные + ГСМ
             , lfGet_20401.InfoMoneyId            AS InfoMoneyId_20401            -- 20401 Общефирменные + ГСМ + ГСМ
             , lfGet_21425.InfoMoneyDestinationId AS InfoMoneyDestinationId_21425 -- 20401 Общефирменные + услуги полученные
             , lfGet_21425.InfoMoneyId            AS InfoMoneyId_21425            -- 20401 Общефирменные + услуги полученные + амортизация транспорт торговых

             , COALESCE (ObjectLink_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss -- для учредителя будет пусто
             , tmpPersonal.BranchId                            AS BranchId_ProfitLoss   -- для учредителя будет пусто
             , tmpPersonal.UnitId                              AS UnitId_ProfitLoss     -- для учредителя будет пусто
             , CASE WHEN vbFounderId_To <> 0 THEN zc_Enum_ProfitLossGroup_30000()    ELSE COALESCE (lfSelect.ProfitLossGroupId, 0)     END AS ProfitLossGroupId
             , CASE WHEN vbFounderId_To <> 0 THEN zc_Enum_ProfitLossDirection_30100()ELSE COALESCE (lfSelect.ProfitLossDirectionId, 0) END AS ProfitLossDirectionId

             , 0 AS ContainerId_ProfitLoss_20401
             , 0 AS ContainerId_ProfitLoss_21425
             , 0 AS ContainerId_External

             , CASE WHEN vbFounderId_To <> 0
                         THEN zc_Enum_Account_100401() -- Расчеты с участниками
                    ELSE CASE (SELECT ObjectLink.ChildObjectId AS InfoMoneyId
                               FROM ObjectLink
                               WHERE ObjectLink.ObjectId = ObjectLink_Juridical.ChildObjectId
                                 AND ObjectLink.DescId = zc_ObjectLink_Juridical_InfoMoney()
                              )
                              WHEN zc_Enum_InfoMoney_20801()
                                   THEN zc_Enum_Account_30201() -- Алан
                              WHEN zc_Enum_InfoMoney_20901()
                                   THEN zc_Enum_Account_30202() -- Ирна
                              WHEN zc_Enum_InfoMoney_21001()
                                   THEN zc_Enum_Account_30203() -- Чапли
                              WHEN zc_Enum_InfoMoney_21101()
                                   THEN zc_Enum_Account_30204() -- Дворкин
                              WHEN zc_Enum_InfoMoney_21151()
                                   THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                              ELSE 0
                         END
               END AS AccountId_External

             , vbFounderId_To                                   AS FounderId
             , COALESCE (ObjectLink_Contract.ChildObjectId, 0)  AS ContractId
             , COALESCE (ObjectLink_Juridical.ChildObjectId, 0) AS JuridicalId

        FROM (-- обычный _tmpItem
              SELECT _tmpItem.MovementItemId
                   , _tmpItem.GoodsId
                   , _tmpItem.OperCount
                   , _tmpItem.OperSumm_Partner
                   , FALSE AS isReparation
              FROM _tmpItem
             UNION ALL
              -- "виртуальная запись" для SummReparation, есди вдруг в _tmpItem пусто
              SELECT tmpItem_child.MovementItemId  AS MovementItemId
                   , vbMemberId_To                 AS GoodsId
                   , 0                             AS OperCount
                   , 0                             AS OperSumm_Partner
                   , TRUE AS isReparation
              FROM tmpItem_child
             ) AS _tmpItem
             LEFT JOIN (SELECT CASE WHEN _tmpItem.OperCount <> tmp.FuelRealCalc AND tmp.FuelRealCalc <> 0
                                         THEN CAST (tmp.FuelRealCalc * _tmpItem.OperSumm_Partner / _tmpItem.OperCount AS NUMERIC (16, 2))
                                    WHEN tmp.FuelRealCalc <> 0
                                         THEN _tmpItem.OperSumm_Partner
                                    ELSE 0
                               END
                             + CASE WHEN tmp.SummLimit < _tmpItem.OperSumm_Partner - CASE WHEN _tmpItem.OperCount <> tmp.FuelRealCalc AND tmp.FuelRealCalc <> 0
                                                                                               THEN CAST (tmp.FuelRealCalc * _tmpItem.OperSumm_Partner / _tmpItem.OperCount AS NUMERIC (16, 2))
                                                                                          WHEN tmp.FuelRealCalc <> 0
                                                                                               THEN _tmpItem.OperSumm_Partner
                                                                                          ELSE 0
                                                                                     END
                                         THEN tmp.SummLimit
                                    WHEN tmp.FuelRealCalc = 0
                                         THEN _tmpItem.OperSumm_Partner
                                    ELSE 0
                               END AS OperSumm_20401
                               -- *Сумма грн (амортизация) = есть лим. км. = 0 ТОГДА = пробег ф.км. * цена аморт. ИНАЧЕ = МИН (пробег ф.км. ИЛИ лимит км.)  * цена аморт.
                             , CAST (tmp.SummReparation AS NUMERIC (16, 2)) AS SummReparation
                        FROM gpGet_Movement_IncomeFuel (inMovementId := inMovementId
                                                      , inOperDate   := NULL
                                                      , inSession    := lfGet_User_Session (inUserId)
                                                       ) AS tmp
                             LEFT JOIN _tmpItem ON 1 = 1
                       ) AS tmpFuel ON 1 = 1

             LEFT JOIN (SELECT View_InfoMoney.InfoMoneyDestinationId
                             , View_InfoMoney.InfoMoneyId
                             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId
                             , View_Personal.UnitId
                             , View_Personal.PersonalId
                             , View_Personal.PositionId
                             , lpInsertFind_Object_ServiceDate (inOperDate:= vbOperDate) AS ServiceDateId
                             , ObjectLink_Personal_PersonalServiceList.ChildObjectId     AS PersonalServiceListId
                        FROM Object_Personal_View AS View_Personal
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                  ON ObjectLink_Unit_Branch.ObjectId = View_Personal.UnitId
                                                 AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101() -- Заработная плата
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = View_Personal.PersonalId
                                                 AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                        WHERE View_Personal.MemberId = vbMemberId_To
                          AND View_Personal.isErased = FALSE
                          AND vbFounderId_To         = 0
                          AND View_Personal.isMain   = TRUE
                        LIMIT 1
                       ) AS tmpPersonal ON 1 = 1
             LEFT JOIN ObjectLink AS ObjectLink_Contract
                                  ON ObjectLink_Contract.ObjectId = tmpPersonal.UnitId
                                 AND ObjectLink_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                  ON ObjectLink_Juridical.ObjectId = ObjectLink_Contract.ChildObjectId
                                 AND ObjectLink_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Business
                                  ON ObjectLink_Business.ObjectId = tmpPersonal.UnitId
                                 AND ObjectLink_Business.DescId   = zc_ObjectLink_Unit_Business()

             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect ON lfSelect.UnitId = tmpPersonal.UnitId

             LEFT JOIN lfGet_Object_InfoMoney (zc_Enum_InfoMoney_20401()) AS lfGet_20401 ON 1 = 1 -- 20401 Общефирменные + ГСМ + ГСМ
             LEFT JOIN lfGet_Object_InfoMoney (zc_Enum_InfoMoney_21425()) AS lfGet_21425 ON 1 = 1 -- 20401 Общефирменные + услуги полученные + амортизация транспорт торговых

        WHERE vbMemberId_To <> 0 AND vbMovementDescId = zc_Movement_Income()
          -- !!!т.е. Эта схема ТОЛЬКО для ГСМ!!!
          AND vbInfoMoneyId_From = zc_Enum_InfoMoney_20401()
          -- если нет SummReparation, "виртуальная запись" НЕ нужна
          AND (_tmpItem.isReparation = FALSE OR tmpFuel.SummReparation > 0)
          AND vbUnitId_From = 0
        -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
        -- AND _tmpItem.OperSumm_Partner <> 0
       ;

     -- проверка
     IF COALESCE (vbMemberId_Packer, 0) = 0 AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.OperSumm_Packer <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не выбран Заготовитель для начисления по нему суммы <%>', zfConvert_FloatToString ((SELECT SUM (_tmpItem.OperSumm_Packer) FROM _tmpItem WHERE _tmpItem.OperSumm_Packer <> 0));
     END IF;

     -- заполняем таблицу - элементы по Сотруднику (заготовитель), со всеми свойствами для формирования Аналитик в проводках, здесь по !!!InfoMoneyId!!!
     INSERT INTO _tmpItem_SummPacker (ContainerId, AccountId, InfoMoneyDestinationId, InfoMoneyId, BusinessId, OperSumm_Packer)
        SELECT 0 AS ContainerId, 0 AS AccountId
             , _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId
             , SUM (_tmpItem.OperSumm_Packer) AS OperSumm_Packer
        FROM _tmpItem
        -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
        -- WHERE _tmpItem.OperSumm_Packer <> 0 AND zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
        WHERE vbMemberId_Packer <> 0
        GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.BusinessId;

     -- заполняем таблицу - элементы по Сотруднику (Водитель), со всеми свойствами для формирования Аналитик в проводках, здесь по !!!InfoMoneyId!!!
     -- !!!по таблице элементы по контрагенту!!! и !!!только если zc_Enum_PaidKind_SecondForm!!! и !!!только если Автомобиль!!! и !!!не Карта и не талон!!!
     INSERT INTO _tmpItem_SummDriver (ContainerId, AccountId, ContainerId_Transit, AccountId_Transit, InfoMoneyDestinationId, InfoMoneyId, BusinessId, OperSumm_Driver)
        SELECT 0 AS ContainerId, 0 AS AccountId, 0 AS ContainerId_Transit, 0 AS AccountId_Transit
             , _tmpItem_SummPartner.InfoMoneyDestinationId, _tmpItem_SummPartner.InfoMoneyId
               -- !!!для Сотрудник (Водитель) подставляем другой Бизнес!!!
             , vbBusinessId_Route
             , SUM (_tmpItem_SummPartner.OperSumm_Partner)
        FROM _tmpItem_SummPartner
        WHERE vbPaidKindId        = zc_Enum_PaidKind_SecondForm()
          AND vbCardFuelId_From   = 0
          AND vbTicketFuelId_From = 0
          AND vbUnitId_From       = 0
          AND vbCarId             <> 0
        GROUP BY _tmpItem_SummPartner.InfoMoneyDestinationId, _tmpItem_SummPartner.InfoMoneyId;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 2.0.1.1. определяется Счет(справочника) для проводок по долг Поставщику или Физ.лицу (подотчетные лица)
     UPDATE _tmpItem_SummPartner SET AccountId         = _tmpItem_byAccount.AccountId
                                   , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- Транзит
     FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                            THEN _tmpItem_group.AccountId
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                  END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountGroup_30000() -- Дебиторы  -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())

                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())

                             WHEN vbIsAccount_30000 = TRUE
                                  THEN zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())

                             ELSE zc_Enum_AccountGroup_70000()  -- Кредиторы select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                        END AS AccountGroupId
                      , CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)  -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500())

                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- наши компании -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30200())

                             WHEN _tmpItem_SummPartner.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                  THEN zc_Enum_AccountDirection_70800() -- Кредиторы + Производственные ОС !!!захардкодил-все сюда, надо будет сделать с подразделением или...!!!

                             WHEN vbIsAccount_30000 = TRUE
                                  THEN zc_Enum_AccountDirection_30100() -- Дебиторы + покупатели

                             ELSE zc_Enum_AccountDirection_70100() -- поставщики select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70100())
                        END AS AccountDirectionId
                      , _tmpItem_SummPartner.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30201() -- Алан
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30202() -- Ирна
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30203() -- Чапли
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30204() -- Дворкин
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                        END AS AccountId
                 FROM _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.InfoMoneyGroupId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 2.0.1.2. определяется ContainerId для проводок по долг Поставщику или Физ.лицу (подотчетные лица)
     UPDATE _tmpItem_SummPartner SET ContainerId          = tmp.ContainerId
                                   , ContainerId_re       = tmp.ContainerId_re
                                   , ContainerId_Transit  = tmp.ContainerId_Transit
                                   , ContainerId_Currency = CASE WHEN vbMemberId_From <> 0 OR vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                                                                      THEN 0
                                                                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                                      ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                                                                                 , inParentId          := tmp.ContainerId
                                                                                                 , inObjectId          := tmp.AccountId
                                                                                                 , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                 , inBusinessId        := tmp.BusinessId
                                                                                                 , inObjectCostDescId  := NULL
                                                                                                 , inObjectCostId      := NULL
                                                                                                 , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                 , inObjectId_1        := vbJuridicalId_From
                                                                                                 , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                 , inObjectId_2        := vbContractId
                                                                                                 , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                 , inObjectId_3        := tmp.InfoMoneyId
                                                                                                 , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                 , inObjectId_4        := vbPaidKindId
                                                                                                 , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                 , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                 , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                 , inObjectId_6        := CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                 , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                 , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                 , inDescId_8          := zc_ContainerLinkObject_Currency()
                                                                                                 , inObjectId_8        := vbCurrencyPartnerId
                                                                                                  )
                                                            END
                                , ContainerId_Currency_re = CASE WHEN vbMemberId_From <> 0 OR vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                                                                    OR (COALESCE (vbInvoiceSumm, 0) = 0 AND COALESCE (vbInvoiceSumm_Currency, 0) = 0)
                                                                      THEN 0
                                                                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                                      ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                                                                                 , inParentId          := tmp.ContainerId
                                                                                                 , inObjectId          := tmp.AccountId
                                                                                                 , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                 , inBusinessId        := tmp.BusinessId
                                                                                                 , inObjectCostDescId  := NULL
                                                                                                 , inObjectCostId      := NULL
                                                                                                 , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                 , inObjectId_1        := vbJuridicalId_From
                                                                                                 , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                 , inObjectId_2        := vbContractId
                                                                                                 , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                 , inObjectId_3        := tmp.InfoMoneyId
                                                                                                 , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                 , inObjectId_4        := -- !!!замена!!!
                                                                                                                          CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN zc_Enum_PaidKind_SecondForm() ELSE zc_Enum_PaidKind_FirstForm() END
                                                                                                 , inDescId_5          := -- !!!замена!!!
                                                                                                                          zc_ContainerLinkObject_PartionMovement()
                                                                                                 , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                 , inDescId_6          := -- !!!замена!!!
                                                                                                                          CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                 , inObjectId_6        := -- !!!замена!!!
                                                                                                                          CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                 , inDescId_7          := -- !!!замена!!!
                                                                                                                          CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                 , inObjectId_7        := -- !!!замена!!!
                                                                                                                          CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                 , inDescId_8          := zc_ContainerLinkObject_Currency()
                                                                                                 , inObjectId_8        := vbCurrencyPartnerId
                                                                                                  )
                                                            END
     FROM (SELECT tmp.AccountId, tmp.AccountId_Transit, tmp.BusinessId, tmp.InfoMoneyId
                                                               , CASE WHEN vbMemberId_From <> 0
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудники(подотчетные лица) 2)NULL 3)NULL 4)Статьи назначения 5)Автомобиль
                                                                           THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                                                      , inObjectId_1        := vbMemberId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_2        := tmp.InfoMoneyId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                                                      , inObjectId_3        := zc_Branch_Basis() -- долг Подотчета всегда на Главном филиале
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                                                      , inObjectId_4        := 0 -- для Физ.лица (подотчетные лица) !!!именно здесь последняя аналитика всегда значение = 0!!!
                                                                                                       )
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                                           ELSE CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                                                                THEN
                                                                                lpInsertFind_Container (inContainerDescId   := zc_Container_SummAsset()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика НЕ всегда на Главном филиале
                                                                                                      , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                                                      , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                                                                       )
                                                                                ELSE
                                                                                lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                      , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                                                      , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                                                                       )
                                                                                END
                                                                 END AS ContainerId
                                                               , CASE WHEN vbMemberId_From = 0 AND (vbInvoiceSumm <> 0 OR vbInvoiceSumm_Currency <> 0)
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                                           THEN CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                                                                THEN
                                                                                lpInsertFind_Container (inContainerDescId   := zc_Container_SummAsset()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN zc_Enum_PaidKind_SecondForm() ELSE zc_Enum_PaidKind_FirstForm() END
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                      , inDescId_6          := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := -- !!!замена!!!
                                                                                                                               CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                      , inDescId_7          := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                      , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                                                      , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                                                                       )
                                                                                ELSE
                                                                                lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN zc_Enum_PaidKind_SecondForm() ELSE zc_Enum_PaidKind_FirstForm() END
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                      , inDescId_6          := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := -- !!!замена!!!
                                                                                                                               CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                      , inDescId_7          := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := -- !!!замена!!!
                                                                                                                               CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                      , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                                                      , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                                                                       )
                                                                                END
                                                                           ELSE 0
                                                                 END AS ContainerId_re
                                                               , CASE WHEN tmp.AccountId_Transit = 0 OR vbMemberId_From <> 0
                                                                           THEN 0
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                                           ELSE CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                                                                THEN
                                                                                lpInsertFind_Container (inContainerDescId   := zc_Container_SummAsset()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId_Transit
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                      , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                                                      , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                                                       )
                                                                                ELSE
                                                                                lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                                                      , inParentId          := NULL
                                                                                                      , inObjectId          := tmp.AccountId_Transit
                                                                                                      , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                                                      , inBusinessId        := tmp.BusinessId
                                                                                                      , inObjectCostDescId  := NULL
                                                                                                      , inObjectCostId      := NULL
                                                                                                      , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                                                      , inObjectId_1        := vbJuridicalId_From
                                                                                                      , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                                                      , inObjectId_2        := vbContractId
                                                                                                      , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_3        := tmp.InfoMoneyId
                                                                                                      , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                                                      , inObjectId_4        := vbPaidKindId
                                                                                                      , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                                                      , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                                                      , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                                                      , inObjectId_6        := CASE WHEN vbInfoMoneyDestinationId_From = zc_Enum_InfoMoneyDestination_20400() /*ГСМ*/ THEN 0 ELSE CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END END
                                                                                                      , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                                                      , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN CASE WHEN vbBranchId_To > 0 THEN vbBranchId_To ELSE zc_Branch_Basis() END ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                                                      , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                                                      , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                                                       )
                                                                                END
                                                                 END AS ContainerId_Transit
           FROM (SELECT _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.AccountId_Transit, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.AccountId_Transit, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.AccountId         = tmp.AccountId
       AND _tmpItem_SummPartner.AccountId_Transit = tmp.AccountId_Transit
       AND _tmpItem_SummPartner.BusinessId        = tmp.BusinessId
       AND _tmpItem_SummPartner.InfoMoneyId       = tmp.InfoMoneyId
    ;


     -- 2.0.2.1. определяется ContainerId_Goods для "виртуальных" проводок количественного учета по ПОКУПАТЕЛЮ
     UPDATE _tmpItem_SummPartner_To SET ContainerId_Goods = tmp.ContainerId
     FROM                            (SELECT _tmpItem.GoodsId
                                           , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                             THEN
                                                  lpInsertUpdate_ContainerCount_Asset (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                     , inUnitId                 := vbPartnerId_To
                                                                                     , inCarId                  := NULL
                                                                                     , inMemberId               := NULL
                                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                     , inGoodsId                := _tmpItem.GoodsId
                                                                                     , inGoodsKindId            := NULL
                                                                                     , inIsPartionCount         := FALSE
                                                                                     , inPartionGoodsId         := NULL
                                                                                     , inAssetId                := NULL
                                                                                     , inBranchId               := NULL                     -- эта аналитика нужна для филиала
                                                                                     , inAccountId              := zc_Enum_Account_110401() -- эта аналитика нужна для "товар в пути / виртуальный склад"
                                                                                      )
                                             ELSE lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                     , inUnitId                 := vbPartnerId_To
                                                                                     , inCarId                  := NULL
                                                                                     , inMemberId               := NULL
                                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                     , inInfoMoneyId            := NULL
                                                                                     , inGoodsId                := _tmpItem.GoodsId
                                                                                     , inGoodsKindId            := NULL
                                                                                     , inIsPartionCount         := FALSE
                                                                                     , inPartionGoodsId         := NULL
                                                                                     , inAssetId                := NULL
                                                                                     , inBranchId               := NULL                     -- эта аналитика нужна для филиала
                                                                                     , inAccountId              := zc_Enum_Account_110401() -- эта аналитика нужна для "товар в пути / виртуальный склад"
                                                                                      )
                                             END AS ContainerId
           FROM (SELECT _tmpItem_SummPartner.GoodsId, _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.GoodsId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem
          ) AS tmp
     WHERE _tmpItem_SummPartner_To.GoodsId = tmp.GoodsId
    ;


     -- 2.0.2.2. определяется Счет(справочника) для проводок по долг ПОКУПАТЕЛЮ
     UPDATE _tmpItem_SummPartner_To SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                            THEN zc_Enum_Account_30201() -- Алан
                       WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                            THEN zc_Enum_Account_30202() -- Ирна
                       WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                            THEN zc_Enum_Account_30203() -- Чапли
                       WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                            THEN zc_Enum_Account_30204() -- Дворкин
                       WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                            THEN zc_Enum_Account_30205() -- ЕКСПЕРТ-АГРОТРЕЙД
                       WHEN vbIsCorporate_To = TRUE
                            THEN 0 -- будет ошибка
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                      END AS AccountId

                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT zc_Enum_AccountGroup_30000()      AS AccountGroupId     -- Дебиторы
                      , zc_Enum_AccountDirection_30100()  AS AccountDirectionId -- Дебиторы + покупатели
                      , _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.InfoMoneyGroupId, _tmpItem_SummPartner.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner_To.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.0.2.3. определяется ContainerId для проводок по долг ПОКУПАТЕЛЮ
     UPDATE _tmpItem_SummPartner_To SET ContainerId = tmp.ContainerId
     FROM              (SELECT tmp.AccountId, tmp.BusinessId, tmp.InfoMoneyId
                             , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                         THEN lpInsertFind_Container (inContainerDescId   := zc_Container_SummAsset()
                                                                    , inParentId          := NULL
                                                                    , inObjectId          := tmp.AccountId
                                                                    , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                    , inBusinessId        := tmp.BusinessId
                                                                    , inObjectCostDescId  := NULL
                                                                    , inObjectCostId      := NULL
                                                                    , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                    , inObjectId_1        := vbJuridicalId_To
                                                                    , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                    , inObjectId_2        := vbContractId_To
                                                                    , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                    , inObjectId_3        := tmp.InfoMoneyId
                                                                    , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                    , inObjectId_4        := vbPaidKindId_To
                                                                    , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                    , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                    , inDescId_6          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                    , inObjectId_6        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                                                    , inDescId_7          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                    , inObjectId_7        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_Branch_Basis() ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                    , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                    , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                     )
                                         ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                    , inParentId          := NULL
                                                                    , inObjectId          := tmp.AccountId
                                                                    , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                    , inBusinessId        := tmp.BusinessId
                                                                    , inObjectCostDescId  := NULL
                                                                    , inObjectCostId      := NULL
                                                                    , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                    , inObjectId_1        := vbJuridicalId_To
                                                                    , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                    , inObjectId_2        := vbContractId_To
                                                                    , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                    , inObjectId_3        := tmp.InfoMoneyId
                                                                    , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                    , inObjectId_4        := vbPaidKindId_To
                                                                    , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                    , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                    , inDescId_6          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                    , inObjectId_6        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                                                    , inDescId_7          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                    , inObjectId_7        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_Branch_Basis() ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                    , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                                    , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                                     )
                               END AS ContainerId

           FROM (SELECT _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
                 GROUP BY _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.BusinessId, _tmpItem_SummPartner.InfoMoneyId
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner_To.AccountId         = tmp.AccountId
       AND _tmpItem_SummPartner_To.BusinessId        = tmp.BusinessId
       AND _tmpItem_SummPartner_To.InfoMoneyId       = tmp.InfoMoneyId
    ;

     -- 2.0.2.4. определяется ContainerId для Проводки - Прибыль ПОКУПАТЕЛЮ
     UPDATE _tmpItem_SummPartner_To SET ContainerId_ProfitLoss_70201 = _tmpItem_byDestination.ContainerId_ProfitLoss_70201 -- Счет - прибыль (ОПиУ - Дополнительная прибыль + Прочее + Товары)
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := CASE WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                                                           THEN NULL -- Алан
                                                                      WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                                                           THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                                                      WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                                                           THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                                                      WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                                                           THEN zc_Enum_ProfitLoss_70103() -- Дворкин
                                                                      WHEN vbIsCorporate_To = TRUE AND zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                                                           THEN zc_Enum_ProfitLoss_70104() -- ЕКСПЕРТ-АГРОТРЕЙД
                                                                      WHEN vbIsCorporate_To = TRUE
                                                                           THEN 0 -- будет ошибка
                                                                      ELSE zc_Enum_ProfitLoss_70201() -- Дополнительная прибыль + Прочее + Товары
                                                                 END
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := 0
                                         ) AS ContainerId_ProfitLoss_70201
                , _tmpItem_byProfitLoss.BusinessId
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
           FROM (SELECT  _tmpItem_SummPartner_To.InfoMoneyDestinationId
                       , _tmpItem_SummPartner_To.BusinessId
                 FROM _tmpItem_SummPartner_To
                 GROUP BY _tmpItem_SummPartner_To.InfoMoneyDestinationId
                        , _tmpItem_SummPartner_To.BusinessId
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem_SummPartner_To.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem_SummPartner_To.BusinessId = _tmpItem_byDestination.BusinessId
    ;


     -- 2.0.3.1. определяется ContainerId_Goods для "виртуальных" проводок количественного учета по Сотруднику (ЗП) или "Учредитель"
     UPDATE _tmpItem_SummPersonal SET ContainerId_Goods = tmp.ContainerId
     FROM                            (SELECT _tmpItem.GoodsId
                                           , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                             THEN
                                                  lpInsertUpdate_ContainerCount_Asset (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                     , inUnitId                 := _tmpItem.byObjectId
                                                                                     , inCarId                  := NULL
                                                                                     , inMemberId               := NULL
                                                                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_20400() -- ГСМ
                                                                                     , inGoodsId                := _tmpItem.GoodsId
                                                                                     , inGoodsKindId            := NULL
                                                                                     , inIsPartionCount         := FALSE
                                                                                     , inPartionGoodsId         := NULL
                                                                                     , inAssetId                := NULL
                                                                                     , inBranchId               := NULL                     -- эта аналитика нужна для филиала
                                                                                     , inAccountId              := zc_Enum_Account_110401() -- эта аналитика нужна для "товар в пути / виртуальный склад"
                                                                                      )
                                             ELSE
                                                  lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                     , inUnitId                 := _tmpItem.byObjectId
                                                                                     , inCarId                  := NULL
                                                                                     , inMemberId               := NULL
                                                                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_20400() -- ГСМ
                                                                                     , inInfoMoneyId            := NULL
                                                                                     , inGoodsId                := _tmpItem.GoodsId
                                                                                     , inGoodsKindId            := NULL
                                                                                     , inIsPartionCount         := FALSE
                                                                                     , inPartionGoodsId         := NULL
                                                                                     , inAssetId                := NULL
                                                                                     , inBranchId               := NULL                     -- эта аналитика нужна для филиала
                                                                                     , inAccountId              := zc_Enum_Account_110401() -- эта аналитика нужна для "товар в пути / виртуальный склад"
                                                                                      )
                                             END AS ContainerId
           FROM (SELECT DISTINCT _tmpItem_SummPersonal.GoodsId, CASE WHEN _tmpItem_SummPersonal.FounderId <> 0 THEN _tmpItem_SummPersonal.FounderId ELSE _tmpItem_SummPersonal.PersonalId END AS byObjectId
                 FROM _tmpItem_SummPersonal
                ) AS _tmpItem
          ) AS tmp
     WHERE _tmpItem_SummPersonal.GoodsId = tmp.GoodsId
    ;

     -- 2.0.3.2. определяется Счет(справочника) для проводок по долг Сотрудника (ЗП)
     UPDATE _tmpItem_SummPersonal SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT zc_Enum_AccountGroup_70000()         AS AccountGroupId         -- Кредиторы
                      , zc_Enum_AccountDirection_70500()     AS AccountDirectionId     -- Кредиторы + Сотрудники
                      , _tmpItem_SummPersonal.InfoMoneyDestinationId
                 FROM _tmpItem_SummPersonal
                 WHERE _tmpItem_SummPersonal.OperSumm_Partner <> 0 -- !!!можно ограничивать!!!
                   AND _tmpItem_SummPersonal.FounderId  = 0        -- !!!т.е. не "Учредитель"!!!
                   AND _tmpItem_SummPersonal.ContractId = 0        -- !!!т.е. не "Перевыставление"!!!
                 GROUP BY _tmpItem_SummPersonal.InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPersonal.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 2.0.3.3. определяется ContainerId для проводок по долг Сотруднику (ЗП)
     UPDATE _tmpItem_SummPersonal SET ContainerId = tmp.ContainerId
     FROM              (SELECT _tmpItem.InfoMoneyId
                                                    , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                            , inBusinessId        := NULL
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Personal()
                                                                            , inObjectId_1        := _tmpItem.PersonalId
                                                                            , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_2        := _tmpItem.InfoMoneyId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                            , inObjectId_3        := _tmpItem.BranchId
                                                                            , inDescId_4          := zc_ContainerLinkObject_Unit()
                                                                            , inObjectId_4        := _tmpItem.UnitId
                                                                            , inDescId_5          := zc_ContainerLinkObject_Position()
                                                                            , inObjectId_5        := _tmpItem.PositionId
                                                                            , inDescId_6          := zc_ContainerLinkObject_ServiceDate()
                                                                            , inObjectId_6        := _tmpItem.ServiceDateId
                                                                            , inDescId_7          := zc_ContainerLinkObject_PersonalServiceList()
                                                                            , inObjectId_7        := _tmpItem.PersonalServiceListId
                                                                             ) AS ContainerId

           FROM (SELECT _tmpItem_SummPersonal.AccountId, _tmpItem_SummPersonal.InfoMoneyId, _tmpItem_SummPersonal.PersonalId, _tmpItem_SummPersonal.BranchId, _tmpItem_SummPersonal.UnitId, _tmpItem_SummPersonal.PositionId, _tmpItem_SummPersonal.ServiceDateId, _tmpItem_SummPersonal.PersonalServiceListId
                 FROM _tmpItem_SummPersonal
                 WHERE _tmpItem_SummPersonal.OperSumm_Partner <> 0 -- !!!можно ограничивать!!!
                   AND _tmpItem_SummPersonal.FounderId  = 0        -- !!!т.е. не "Учредитель"!!!
                   AND _tmpItem_SummPersonal.ContractId = 0        -- !!!т.е. не "Перевыставление"!!!
                 GROUP BY _tmpItem_SummPersonal.AccountId, _tmpItem_SummPersonal.InfoMoneyId, _tmpItem_SummPersonal.PersonalId, _tmpItem_SummPersonal.BranchId, _tmpItem_SummPersonal.UnitId, _tmpItem_SummPersonal.PositionId, _tmpItem_SummPersonal.ServiceDateId, _tmpItem_SummPersonal.PersonalServiceListId
                ) AS _tmpItem
          ) AS tmp
     WHERE _tmpItem_SummPersonal.InfoMoneyId = tmp.InfoMoneyId
    ;

     -- 2.0.3.4. определяется ContainerId_ProfitLoss_20401 + ContainerId_ProfitLoss_21425 для проводок по затратам "Заправка"
     UPDATE _tmpItem_SummPersonal SET ContainerId_ProfitLoss_20401 = _tmpItem_byContainer.ContainerId_ProfitLoss_20401
                                    , ContainerId_ProfitLoss_21425 = _tmpItem_byContainer.ContainerId_ProfitLoss_21425
     FROM (SELECT CASE WHEN _tmpItem_byProfitLoss.ProfitLossId_20401 <> 0
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := zc_Enum_Account_100301() -- прибыль текущего периода
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                       , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_ProfitLoss
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                       , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_20401
                                                       , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_2        := _tmpItem_byProfitLoss.BranchId_ProfitLoss
                                                        )
                       ELSE 0
                  END AS ContainerId_ProfitLoss_20401

                , CASE WHEN _tmpItem_byProfitLoss.ProfitLossId_21425 <> 0
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := zc_Enum_Account_100301() -- прибыль текущего периода
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                       , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_ProfitLoss
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                       , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_21425
                                                       , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_2        := _tmpItem_byProfitLoss.BranchId_ProfitLoss
                                                        )
                       ELSE 0
                  END AS ContainerId_ProfitLoss_21425

                , _tmpItem_byProfitLoss.MovementItemId

           FROM (SELECT -- УП = Общефирменные + ГСМ + ГСМ
                        CASE WHEN _tmpItem.OperSumm_20401 <> 0
                                  THEN lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := ProfitLossGroupId
                                                                     , inProfitLossDirectionId  := ProfitLossDirectionId
                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId_20401
                                                                     , inInfoMoneyId            := NULL
                                                                     , inUserId                 := inUserId
                                                                      )
                             ELSE 0
                        END AS ProfitLossId_20401
                        -- УП = Общефирменные + услуги полученные + амортизация транспорт торговых
                      , CASE WHEN _tmpItem.OperSumm_21425 <> 0
                                  THEN lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := ProfitLossGroupId
                                                                     , inProfitLossDirectionId  := ProfitLossDirectionId
                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId_21425
                                                                     , inInfoMoneyId            := NULL
                                                                     , inUserId                 := inUserId
                                                                      )
                             ELSE 0
                        END AS ProfitLossId_21425

                      , _tmpItem.MovementItemId
                      , _tmpItem.BusinessId_ProfitLoss
                      , _tmpItem.BranchId_ProfitLoss

                 FROM (SELECT  _tmpItem_SummPersonal.MovementItemId
                             , _tmpItem_SummPersonal.InfoMoneyDestinationId_20401
                             , _tmpItem_SummPersonal.InfoMoneyDestinationId_21425
                             , _tmpItem_SummPersonal.BusinessId_ProfitLoss
                             , _tmpItem_SummPersonal.BranchId_ProfitLoss
                             , _tmpItem_SummPersonal.ProfitLossGroupId
                             , _tmpItem_SummPersonal.ProfitLossDirectionId
                             , _tmpItem_SummPersonal.OperSumm_20401
                             , _tmpItem_SummPersonal.OperSumm_21425
                       FROM _tmpItem_SummPersonal
                      ) AS _tmpItem
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byContainer
     WHERE _tmpItem_SummPersonal.MovementItemId = _tmpItem_byContainer.MovementItemId;


     -- 2.0.3.5. определяется ContainerId_External для проводок по "Учредитель" или "Перевыставление"
     UPDATE _tmpItem_SummPersonal SET ContainerId_External = _tmpItem_byContainer.ContainerId_External
           FROM (SELECT CASE -- "Учредитель"
                             WHEN _tmpItem.FounderId <> 0
                                  THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                             , inParentId          := NULL
                                                             , inObjectId          := _tmpItem.AccountId_External
                                                             , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                             , inBusinessId        := NULL                     -- !!!непонятно, поэтому и нет!!!
                                                             , inObjectCostDescId  := NULL
                                                             , inObjectCostId      := NULL
                                                             , inDescId_1          := zc_ContainerLinkObject_Founder()
                                                             , inObjectId_1        := _tmpItem.FounderId
                                                              )
                             -- "Перевыставление"
                             WHEN _tmpItem.ContractId <> 0
                                  THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId_External
                                                                            , inJuridicalId_basis := vbJuridicalId_Basis_To -- ???может корректнее из договора???
                                                                            , inBusinessId        := NULL                   -- !!!непонятно, поэтому и нет!!!
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := _tmpItem.JuridicalId
                                                                            , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_2        := _tmpItem.ContractId
                                                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_3        := ObjectLink_Contract_InfoMoney.ChildObjectId
                                                                            , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_4        := ObjectLink_Contract_PaidKind.ChildObjectId
                                                                            , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                            , inObjectId_5        := NULL
                                                                             )
                             ELSE 0
                        END AS ContainerId_External

                      , _tmpItem.MovementItemId

                 FROM (SELECT  _tmpItem_SummPersonal.MovementItemId
                             , _tmpItem_SummPersonal.OperSumm_Partner
                             , _tmpItem_SummPersonal.AccountId_External
                             , _tmpItem_SummPersonal.FounderId
                             , _tmpItem_SummPersonal.ContractId
                             , _tmpItem_SummPersonal.JuridicalId
                       FROM _tmpItem_SummPersonal
                       WHERE _tmpItem_SummPersonal.OperSumm_Partner <> 0                                    -- !!!можно ограничивать!!!
                        AND (_tmpItem_SummPersonal.FounderId <> 0 OR _tmpItem_SummPersonal.ContractId <> 0) -- !!!т.е. "Учредитель" OR "Перевыставление" !!!
                      ) AS _tmpItem
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney ON ObjectLink_Contract_InfoMoney.ObjectId = _tmpItem.ContractId
                                                                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = _tmpItem.ContractId
                                                                          AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                ) AS _tmpItem_byContainer
     WHERE _tmpItem_SummPersonal.MovementItemId = _tmpItem_byContainer.MovementItemId;


     -- 3.0.1. определяется Счет(справочника) для проводок по доплата Физ.лицу (заготовитель)
     UPDATE _tmpItem_SummPacker SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT InfoMoneyDestinationId FROM _tmpItem_SummPacker GROUP BY InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPacker.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.0.2. определяется ContainerId для проводок по доплата Физ.лицу (заготовитель)
     UPDATE _tmpItem_SummPacker SET ContainerId =
                                                  -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1) Физ.лицо (заготовитель) 3)Статьи назначения
                                                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                        , inParentId          := NULL
                                                                        , inObjectId          := _tmpItem_SummPacker.AccountId
                                                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                        , inBusinessId        := _tmpItem_SummPacker.BusinessId
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                        , inObjectId_1        := vbMemberId_Packer
                                                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                        , inObjectId_2        := _tmpItem_SummPacker.InfoMoneyId
                                                                        , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                        , inObjectId_3        := zc_Branch_Basis() -- долг Подотчета всегда на Главном филиале
                                                                        , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_4        := 0 -- для Физ.лица (заготовитель) !!!именно здесь последняя аналитика всегда значение = 0!!!
                                                                        );

     -- Проверка
     IF 1 < (SELECT COUNT(*) FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId FROM _tmpItem_SummPartner) AS tmp)
     THEN
         RAISE EXCEPTION 'Ошибка в определении Аналитики для vbContainerId_Analyzer <%> <%>'
                        , (SELECT MIN (tmp.ContainerId) FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId FROM _tmpItem_SummPartner) AS tmp)
                        , (SELECT MAX (tmp.ContainerId) FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId FROM _tmpItem_SummPartner) AS tmp)
         ;
     END IF;
     -- 3.0.3. !!!Очень важно - определили здесь vbContainerId_Analyzer для ВСЕХ!!!, если он не один - тогда ошибка
     vbContainerId_Analyzer:= (SELECT DISTINCT _tmpItem_SummPartner.ContainerId FROM _tmpItem_SummPartner);
     -- определили
     vbContainerId_Analyzer_Packer:= (SELECT ContainerId FROM _tmpItem_SummPacker GROUP BY ContainerId);
     -- определили
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbCarId <> 0 THEN vbCarId WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;
     -- определили
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From WHEN vbCardFuelId_From <> 0 THEN vbCardFuelId_From WHEN vbTicketFuelId_From <> 0 THEN vbTicketFuelId_From WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;


     -- 3.0.4. !!!Ход конем - удалили, если ПОКУПАТЕЛЮ или заправка ТОЛЬКО ГСМ Сотрудника или заправка Учредитель - ТОЛЬКО для прихода!!!
     DELETE FROM _tmpItem WHERE (vbPartnerId_To <> 0 OR (vbMemberId_To <> 0 AND vbInfoMoneyId_From = zc_Enum_InfoMoney_20401())) AND vbMovementDescId = zc_Movement_Income();


     -- 1.1.1. определяется ContainerId_CountSupplier для !!!забалансовой!!! проводки по количественному учету - долги Поставщику
     UPDATE _tmpItem SET ContainerId_CountSupplier = -- 0)Товар 1)Поставщик
                                                     lpInsertFind_Container (inContainerDescId   := zc_Container_CountSupplier()
                                                                           , inParentId          := NULL
                                                                           , inObjectId          := _tmpItem.GoodsId
                                                                           , inJuridicalId_basis := NULL
                                                                           , inBusinessId        := NULL
                                                                           , inObjectCostDescId  := NULL
                                                                           , inObjectCostId      := NULL
                                                                           , inDescId_1          := zc_ContainerLinkObject_Partner()
                                                                           , inObjectId_1        := vbPartnerId_From
                                                                           , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                           , inObjectId_2        := zc_Branch_Basis() -- долг Поставщика всегда на Главном филиале
                                                                           , inDescId_3          := zc_ContainerLinkObject_PaidKind()
                                                                           , inObjectId_3        := vbPaidKindId
                                                                            )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0;

     -- 1.1.2. формируются !!!забалансовые!!! Проводки для количественного учета - долги поставщику
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_CountSupplier() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_CountSupplier
            , 0                                       AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_TareReturning()      AS AnalyzerId               -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbPartnerId_From                        AS WhereObjectId_Analyzer   -- Поставщик
            , 0                                       AS ContainerId_Analyzer     -- !!!нет!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- подразделение или...
            , ContainerId_CountSupplier               AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , -1 * OperCount                          AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0;


     -- 1.2.1.1. определяется ContainerId_Goods для проводок по количественному учету - если НЕ спецодежда
     UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                             THEN
                                             lpInsertUpdate_ContainerCount_Asset (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                             ELSE
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                             END
                        , ContainerId_Goods_Unit = CASE WHEN vbUnitId_from > 0 THEN
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_from
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inGoodsId                := _tmpItem.GoodsId_Unit
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := FALSE
                                                                                , inPartionGoodsId         := NULL
                                                                                , inAssetId                := NULL
                                                                                , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                                  ELSE 0
                                             END
     WHERE vbPartnerId_To = 0
       -- если НЕ спецодежда
       AND _tmpItem.MovementItemId NOT IN (SELECT _tmpItemPartion_20202.MovementItemId FROM _tmpItemPartion_20202)
     ;

     -- 1.2.1.2. определяется ContainerId_Goods для проводок по количественному учету - если спецодежда
     UPDATE _tmpItemPartion_20202 SET ContainerId_Goods =
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItemPartion_20202.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
     FROM _tmpItem
     WHERE vbPartnerId_To = 0
       -- если спецодежда
       AND _tmpItemPartion_20202.MovementItemId = _tmpItem.MovementItemId
     ;

     -- 1.2.1.3. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItemSumm_Unit (MovementItemId, ContainerId_From, AccountId_From, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , Container_Summ.Id AS ContainerId_From
            , Container_Summ.ObjectId AS AccountId_From
            , CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4)) AS OperSumm
        FROM _tmpItem
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods_Unit
                                             AND Container_Summ.DescId = zc_Container_Summ()
             JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoneyDetail
                                      ON ContainerLinkObject_InfoMoneyDetail.ContainerId = Container_Summ.Id
                                     AND ContainerLinkObject_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE (_tmpItem.OperCount * HistoryCost.Price) <> 0 -- !!!НЕ!!! вставляем нули
          AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
       ;

     -- 1.2.2. формируются Проводки для количественного учета
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- остаток с плюсом
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_CountAsset()
                        ELSE zc_MIContainer_Count()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , COALESCE (_tmpItemPartion_20202.ContainerId_Goods, _tmpItem.ContainerId_Goods) AS ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , CASE WHEN _tmpItem.isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE 0 END AS AnalyzerId             -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , COALESCE (tmpItemSumm_Unit.ContainerId_From, vbContainerId_Analyzer) AS ContainerId_Analyzer   -- Контейнер - по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Поставщик или...
            , COALESCE (_tmpItemPartion_20202.ContainerId_Goods, _tmpItem.ContainerId_Goods) AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , COALESCE (_tmpItemPartion_20202.OperCount, _tmpItem.OperCount_Partner) AS Amount
            , vbOperDate                              AS OperDate               -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItemPartion_20202 ON _tmpItemPartion_20202.MovementItemId = _tmpItem.MovementItemId
            LEFT JOIN (SELECT _tmpItemSumm_Unit.MovementItemId, _tmpItemSumm_Unit.ContainerId_From, _tmpItemSumm_Unit.AccountId_From
                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY _tmpItemSumm_Unit.MovementItemId ORDER BY _tmpItemSumm_Unit.ContainerId_From DESC) AS Ord
                       FROM _tmpItemSumm_Unit
                      ) AS tmpItemSumm_Unit ON tmpItemSumm_Unit.MovementItemId = _tmpItem.MovementItemId
                                           AND tmpItemSumm_Unit.Ord            = 1
       -- WHERE OperCount <> 0

      UNION ALL
       -- остаток с минусом
       SELECT 0
            , zc_MIContainer_Count() AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods_Unit         AS ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , CASE WHEN _tmpItem.isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE 0 END AS AnalyzerId             -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbObjectExtId_Analyzer                  AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem.ContainerId_Goods              AS ContainerId_Analyzer   -- Контейнер - НЕ по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer   -- Поставщик или...
            , _tmpItem.ContainerId_Goods_Unit         AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperCount_Partner         AS Amount
            , vbOperDate                              AS OperDate               -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_Goods_Unit > 0

      UNION ALL
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_CountAsset()
                        ELSE zc_MIContainer_Count()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , ContainerId_Goods
            , 0                                       AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId               -- есть аналитика, Разница в весе, хотя реально эта разница не попадает в статью затрат 40200...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer  -- Подраделение или...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , _tmpItem.OperCount - _tmpItem.OperCount_Partner AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.OperCount <> _tmpItem.OperCount_Partner

      UNION ALL
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_CountAsset()
                        ELSE zc_MIContainer_Count()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_Income_Packer()      AS AnalyzerId               -- есть аналитика, по заготовителю
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , vbContainerId_Analyzer_Packer           AS ContainerId_Analyzer     -- Контейнер - по долгам заготовителю
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbMemberId_Packer                       AS ObjectExtId_Analyzer     -- заготовитель
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , _tmpItem.OperCount_Packer               AS Amount
            , vbOperDate                              AS OperDate               -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.OperCount_Packer <> 0;


     -- 1.2.3. определяется ContainerId_GoodsTicketFuel для проводок по количественному учету - Расход талонов
     UPDATE _tmpItem SET ContainerId_GoodsTicketFuel = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := NULL
                                                                                          , inCarId                  := NULL
                                                                                          , inMemberId               := vbMemberId_Driver
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                          , inGoodsId                := _tmpItem.GoodsId_TicketFuel
                                                                                          , inGoodsKindId            := NULL
                                                                                          , inIsPartionCount         := NULL
                                                                                          , inPartionGoodsId         := NULL
                                                                                          , inAssetId                := NULL
                                                                                          , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                          , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                           )
     WHERE vbTicketFuelId_From <> 0;

     -- 1.2.4. формируются Проводки для количественного учета - Расход талонов
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsTicketFuel
            , 0                                       AS AccountId                -- нет счета
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem.GoodsId_TicketFuel             AS ObjectId_Analyzer        -- Товар
            , vbMemberId_Driver                       AS WhereObjectId_Analyzer   -- vbMemberId_Driver
            , 0                                       AS ContainerId_Analyzer     -- !!!нет!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , 0                                       AS ObjectExtId_Analyzer     -- !!!нет!!!
            , ContainerId_GoodsTicketFuel             AS ContainerIntId_Analyzer  -- Контейнер - тот же самый
            , 0                                       AS ParentId
            , -1 * OperCount                          AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE OperCount <> 0
         AND vbTicketFuelId_From <> 0;


     -- 1.3.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := CASE WHEN _tmpItem_group.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                                                     THEN zc_Enum_AccountGroup_10000() -- Необоротные активы
                                                                                ELSE zc_Enum_AccountGroup_20000() -- Запасы
                                                                           END
                                             , inAccountDirectionId     := CASE WHEN _tmpItem_group.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
                                                                                     THEN (SELECT lfGet.AccountDirectionId FROM lfGet_Object_Unit_byAccountDirection_Asset (_tmpItem_group.UnitId_Asset) AS lfGet)

                                                                                WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                     THEN zc_Enum_AccountDirection_20900() -- Оборотная тара

                                                                                ELSE vbAccountDirectionId_To
                                                                           END
                                             , inInfoMoneyDestinationId := CASE WHEN -- Запасы + на производстве
                                                                                     vbAccountDirectionId_To                    = zc_Enum_AccountDirection_20400()
                                                                                     -- Доходы + Продукция
                                                                                 AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_30100()
                                                                                     THEN -- !!!замена - Незавершенное производство!!!
                                                                                          zc_Enum_InfoMoneyDestination_21300()
                                                                                ELSE _tmpItem_group.InfoMoneyDestinationId_calc
                                                                           END
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyId
                , _tmpItem_group.UnitId_Asset
           FROM (SELECT DISTINCT
                        _tmpItem.UnitId_Asset
                      , _tmpItem.InfoMoneyGroupId
                      , _tmpItem.InfoMoneyDestinationId
                      , _tmpItem.InfoMoneyId
                      , CASE /*WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                               OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                  THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                             */
                             WHEN (vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- !!!временно!!! Запасы + на складах
                                OR vbAccountDirectionId_To = zc_Enum_AccountDirection_20300() -- Запасы + на хранении
                                  )
                              AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- Общефирменные + услуги полученные
                                  THEN zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье

                             ELSE _tmpItem.InfoMoneyDestinationId
                        END AS InfoMoneyDestinationId_calc
                 FROM _tmpItem
                 WHERE _tmpItem.ContainerId_ProfitLoss = 0 -- !!!если НЕ ОПиУ!!!
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyId  = _tmpItem_byAccount.InfoMoneyId
       AND _tmpItem.UnitId_Asset = _tmpItem_byAccount.UnitId_Asset
    ;

     -- 1.3.2.1. определяется ContainerId_Summ для проводок по суммовому учету + формируется Аналитика <элемент с/с> - если НЕ спецодежда
     UPDATE _tmpItem SET ContainerId_Summ =  CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                                             THEN
                                                  lpInsertUpdate_ContainerSumm_Asset (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId
                                                                                    , inCarId                  := vbCarId
                                                                                    , inMemberId               := vbMemberId_To
                                                                                    , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                    , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                    , inBusinessId             := _tmpItem.BusinessId
                                                                                    , inAccountId              := _tmpItem.AccountId
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                    , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId_Detail
                                                                                    , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                     )
                                             ELSE
                                                  lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId
                                                                                    , inCarId                  := vbCarId
                                                                                    , inMemberId               := vbMemberId_To
                                                                                    , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                    , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                    , inBusinessId             := _tmpItem.BusinessId
                                                                                    , inAccountId              := _tmpItem.AccountId
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                    , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId_Detail
                                                                                    , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                    , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                     )
                                             END
     WHERE _tmpItem.ContainerId_ProfitLoss = 0 -- !!!если НЕ ОПиУ!!!
       -- если НЕ спецодежда
       AND _tmpItem.MovementItemId NOT IN (SELECT _tmpItemPartion_20202.MovementItemId FROM _tmpItemPartion_20202)
    ;

     -- 1.3.2.2. определяется ContainerId_Summ для проводок по суммовому учету + формируется Аналитика <элемент с/с> - если спецодежда
     UPDATE _tmpItemPartion_20202 SET ContainerId_Summ =
                                                  lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId
                                                                                    , inCarId                  := vbCarId
                                                                                    , inMemberId               := vbMemberId_To
                                                                                    , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                    , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                    , inBusinessId             := _tmpItem.BusinessId
                                                                                    , inAccountId              := _tmpItem.AccountId
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                    , inInfoMoneyId_Detail     := _tmpItem.InfoMoneyId_Detail
                                                                                    , inContainerId_Goods      := _tmpItemPartion_20202.ContainerId_Goods
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                    , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                    , inPartionGoodsId         := _tmpItemPartion_20202.PartionGoodsId
                                                                                    , inAssetId                := _tmpItem.AssetId
                                                                                     )
     FROM _tmpItem
     WHERE _tmpItem.ContainerId_ProfitLoss = 0 -- !!!если НЕ ОПиУ!!!
       -- если спецодежда
       AND _tmpItemPartion_20202.MovementItemId = _tmpItem.MovementItemId
    ;

     -- 1.3.3. формируются Проводки для суммового учета : (c/c остаток) + !!!есть MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- c/c остаток с плюсом
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , COALESCE (_tmpItemPartion_20202.ContainerId_Summ, _tmpItem.ContainerId_Summ) AS ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , COALESCE (tmpItemSumm_Unit.ContainerId_From, vbContainerId_Analyzer) AS ContainerId_Analyzer -- Контейнер - по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , COALESCE (_tmpItemPartion_20202.ContainerId_Goods, _tmpItem.ContainerId_Goods) AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , COALESCE (tmpItemSumm_Unit.OperSumm, CASE WHEN _tmpItem.OperCount <> _tmpItem.OperCount_Partner AND _tmpItem.OperCount_Partner <> 0 THEN CAST (_tmpItem.OperCount * _tmpItem.OperSumm_Partner / _tmpItem.OperCount_Partner AS NUMERIC (16, 4)) ELSE COALESCE (_tmpItemPartion_20202.OperSumm, _tmpItem.OperSumm_Partner) END) AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItemPartion_20202 ON _tmpItemPartion_20202.MovementItemId = _tmpItem.MovementItemId
            LEFT JOIN (SELECT _tmpItemSumm_Unit.MovementItemId, MAX (_tmpItemSumm_Unit.ContainerId_From) AS ContainerId_From, MAX (_tmpItemSumm_Unit.AccountId_From) AS AccountId_From
                            , SUM (_tmpItemSumm_Unit.OperSumm) AS OperSumm
                       FROM _tmpItemSumm_Unit
                       GROUP BY _tmpItemSumm_Unit.MovementItemId
                      ) AS tmpItemSumm_Unit ON tmpItemSumm_Unit.MovementItemId = _tmpItem.MovementItemId

       WHERE _tmpItem.ContainerId_ProfitLoss = 0 -- !!!если НЕ ОПиУ!!!
         AND (_tmpItem.OperSumm_Partner <> 0
           OR tmpItemSumm_Unit.OperSumm <> 0
             )

      UNION ALL
       -- c/c остаток для vbUnitId_From с минусом
       SELECT 0
            , zc_MIContainer_Summ() AS DescId
            , vbMovementDescId, inMovementId, _tmpItemSumm_Unit.MovementItemId
            , _tmpItemSumm_Unit.ContainerId_From      AS ContainerId_Summ
            , _tmpItemSumm_Unit.AccountId_From        AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbObjectExtId_Analyzer                  AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer     -- Контейнер - НЕ по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem.ContainerId_Goods_Unit         AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm_Unit.OperSumm         AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItemSumm_Unit
            LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm_Unit.MovementItemId
       WHERE _tmpItemSumm_Unit.OperSumm <> 0

      UNION ALL
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, MovementItemId
            , _tmpItem.ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId                -- счет есть всегда
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId               -- есть аналитика, Разница в весе, хотя реально эта разница не попадает в статью затрат 40200...
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , CASE WHEN _tmpItem.OperCount <> _tmpItem.OperCount_Partner AND _tmpItem.OperCount_Partner <> 0 THEN _tmpItem.OperSumm_Partner - CAST (_tmpItem.OperCount * _tmpItem.OperSumm_Partner / _tmpItem.OperCount_Partner AS NUMERIC (16, 4)) ELSE 0 END AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_ProfitLoss = 0 -- !!!если НЕ ОПиУ!!!
         AND _tmpItem.OperSumm_Partner <> 0
         AND _tmpItem.OperCount <> _tmpItem.OperCount_Partner
      UNION ALL
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ
            , _tmpItem.AccountId                      AS AccountId                -- счет есть всегда
            , zc_Enum_AnalyzerId_Income_Packer()      AS AnalyzerId               -- есть аналитика, по заготовителю
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , vbContainerId_Analyzer_Packer           AS ContainerId_Analyzer     -- Контейнер - по долгам заготовителю
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbMemberId_Packer                       AS ObjectExtId_Analyzer     -- заготовитель
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem.OperSumm_Packer                AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_ProfitLoss = 0 -- !!!если НЕ ОПиУ!!!
         AND _tmpItem.OperSumm_Packer <> 0;


     -- 1.3.4. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                   AS AccountId                -- прибыль текущего периода
            , 0                                          AS AnalyzerId               -- в ОПиУ как правило не нужена аналитика, т.к. ...
            , _tmpItem.GoodsId                           AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                   AS WhereObjectId_Analyzer   -- Подраделение или...
            , vbContainerId_Analyzer                     AS ContainerId_Analyzer     -- в ОПиУ не нужен, НО здесь Контейнер - по долгам поставщика
            , vbUnitId                                   AS ObjectIntId_Analyzer     -- Подраделение (ОПиУ)
            , 0                                          AS ObjectExtId_Analyzer     -- Филиал (ОПиУ), а могло быть zc_Branch_Basis()
            , _tmpItem.ContainerId_Goods                 AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                          AS ParentId
            , 1 * (_tmpItem.OperSumm_Partner + _tmpItem.OperSumm_Packer)
            , vbOperDate                                 AS OperDate
            , FALSE                                      AS isActive                 -- !!!ОПиУ всегда по Кредиту!!!
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_ProfitLoss <> 0 -- !!!если ОПиУ!!!
      ;
/*
RAISE EXCEPTION '<%>   %'
,(SELECT DISTINCT _tmpItem_SummPartner.ContainerId_Currency
             FROM _tmpItem_SummPartner
             WHERE vbInvoiceSumm_Currency <> 0
            )
,(SELECT DISTINCT _tmpItem_SummPartner.ContainerId_Currency_re
             FROM _tmpItem_SummPartner
             WHERE vbInvoiceSumm_Currency <> 0
            )
;*/
     -- 2.0.3. формируются Проводки - долг Поставщику или Физ.лицу (подотчетные лица) + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- это обычная проводка
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem_SummPartner.ContainerId        AS ContainerId_Analyzer     -- тот же самый
            , _tmpItem_SummPartner.GoodsKindId        AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , -1 * _tmpItem_SummPartner.OperSumm_Partner
            , CASE WHEN _tmpItem_SummPartner.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_SummPartner
            LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_SummPartner.MovementItemId
       -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
       -- WHERE _tmpItem_SummPartner.OperSumm_Partner <> 0

     UNION ALL
       -- это взаимозачет - 1.1.
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                       AS ObjectId_Analyzer        -- Товар
            , 0                                       AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem_SummPartner.ContainerId        AS ContainerId_Analyzer     -- тот же самый
            , 0                                       AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_SummPartner.ContainerId_re     AS ContainerIntId_Analyzer  -- Контейнер "re"
            , 0                                       AS ParentId
            , 1 * vbInvoiceSumm                       AS Amount
            , vbOperDatePartner                       AS OperDate
            , FALSE                                   AS isActive
       FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.ContainerId_re
             FROM _tmpItem_SummPartner
             WHERE vbInvoiceSumm <> 0
            ) AS _tmpItem_SummPartner
     UNION ALL
       -- это взаимозачет - 1.2.
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummPartner.ContainerId_re
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                       AS ObjectId_Analyzer        -- Товар
            , 0                                       AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem_SummPartner.ContainerId_re     AS ContainerId_Analyzer     -- тот же самый
            , 0                                       AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_SummPartner.ContainerId        AS ContainerIntId_Analyzer  -- Контейнер "re"
            , 0                                       AS ParentId
            , -1 * vbInvoiceSumm                      AS Amount
            , vbOperDatePartner                       AS OperDate
            , FALSE                                   AS isActive
       FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.ContainerId_re
             FROM _tmpItem_SummPartner
             WHERE vbInvoiceSumm <> 0
            ) AS _tmpItem_SummPartner
     UNION ALL
       -- это !!!одна!!! проводка для "забалансового" Валютного счета
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpGroup.ContainerId_Currency
            , _tmpGroup.AccountId                      AS AccountId                -- счет есть всегда
            , 0                                        AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                        AS ObjectId_Analyzer        -- Товар
            , 0                                        AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpGroup.ContainerId_Currency           AS ContainerId_Analyzer     -- тот же самый
            , 0                                        AS ObjectIntId_Analyzer     -- вид товара
            , 0                                        AS ObjectExtId_Analyzer     -- Поставщик или...
            , 0                                        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                        AS ParentId
            , -1 * _tmpGroup.OperSumm_Partner_Currency
            , CASE WHEN _tmpGroup.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItem_SummPartner.ContainerId_Currency, _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.AccountId_Transit, SUM (_tmpItem_SummPartner.OperSumm_Partner_Currency) AS OperSumm_Partner_Currency FROM _tmpItem_SummPartner WHERE _tmpItem_SummPartner.ContainerId_Currency <> 0 GROUP BY _tmpItem_SummPartner.ContainerId_Currency, _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.AccountId_Transit
            ) AS _tmpGroup
     UNION ALL
       -- это взаимозачет - 2.1. !!!одна!!! проводка для "забалансового" Валютного счета
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpGroup.ContainerId_Currency
            , _tmpGroup.AccountId                      AS AccountId                -- счет есть всегда
            , 0                                        AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                        AS ObjectId_Analyzer        -- Товар
            , 0                                        AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpGroup.ContainerId_Currency           AS ContainerId_Analyzer     -- тот же самый
            , 0                                        AS ObjectIntId_Analyzer     -- вид товара
            , 0                                        AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpGroup.ContainerId_Currency_re        AS ContainerIntId_Analyzer  -- Контейнер "re"
            , 0                                        AS ParentId
            , 1 * vbInvoiceSumm_Currency               AS Amount
            , vbOperDatePartner                        AS OperDate
            , FALSE                                    AS isActive
       FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId_Currency, _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.ContainerId_Currency_re
             FROM _tmpItem_SummPartner
             WHERE vbInvoiceSumm_Currency <> 0
            ) AS _tmpGroup
     UNION ALL
       -- это взаимозачет - 2.2. !!!одна!!! проводка для "забалансового" Валютного счета
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpGroup.ContainerId_Currency_re
            , _tmpGroup.AccountId                      AS AccountId                -- счет есть всегда
            , 0                                        AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                        AS ObjectId_Analyzer        -- Товар
            , 0                                        AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpGroup.ContainerId_Currency_re        AS ContainerId_Analyzer     -- тот же самый
            , 0                                        AS ObjectIntId_Analyzer     -- вид товара
            , 0                                        AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpGroup.ContainerId_Currency           AS ContainerIntId_Analyzer  -- Контейнер "re"
            , 0                                        AS ParentId
            , -1 * vbInvoiceSumm_Currency              AS Amount
            , vbOperDatePartner                        AS OperDate
            , FALSE                                    AS isActive
       FROM (SELECT DISTINCT _tmpItem_SummPartner.ContainerId_Currency, _tmpItem_SummPartner.AccountId, _tmpItem_SummPartner.ContainerId_Currency_re
             FROM _tmpItem_SummPartner
             WHERE vbInvoiceSumm_Currency <> 0
            ) AS _tmpGroup

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId_Transit
            , _tmpItem_SummPartner.AccountId_Transit  AS AccountId                -- есть счет (т.е. в отчетах определяется "транзит")
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpItem_SummPartner.ContainerId_Transit ELSE _tmpItem_SummPartner.ContainerId_Transit END AS ContainerId_Analyzer -- тот же самый, т.е. в приход попадет "виртуальная" за vbOperDate + "реальная" за vbOperDatePartner
            , _tmpItem_SummPartner.GoodsKindId        AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END * _tmpItem_SummPartner.OperSumm_Partner
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN FALSE ELSE TRUE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN _tmpItem_SummPartner ON  _tmpItem_SummPartner.OperSumm_Partner <> 0
                                      AND _tmpItem_SummPartner.AccountId_Transit <> 0
            LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_SummPartner.MovementItemId
      ;

     -- 2.1.2. формируются "виртуальные" Проводки - для количественного учета по ПОКУПАТЕЛЮ + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner_To.MovementItemId
            , _tmpItem_SummPartner_To.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId              -- есть счет Транзит + виртуальный склад + виртуальный склад (т.е. в отчетах определяется "виртуальная")
            , 0                                       AS AnalyzerId             -- нет аналитики, т.е. признака "виртуальная" пока не надо
            , _tmpItem_SummPartner_To.GoodsId         AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Покупатель
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- Контейнер - по долгам поставщика
            , 0                                       AS ObjectIntId_Analyzer   -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Поставщик или...
            , _tmpItem_SummPartner_To.ContainerId_Goods AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_SummPartner_To.OperCount_PartnerFrom * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- с противоположными знаками
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive -- т.к. с противоположными знаками
       FROM _tmpItem_SummPartner_To
            LEFT JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner_To.MovementItemId
            , _tmpItem_SummPartner_To.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId              -- есть счет Транзит + виртуальный склад + виртуальный склад (т.е. в отчетах определяется "виртуальная")
            , zc_Enum_AnalyzerId_Count_40200()        AS AnalyzerId             -- есть аналитика, Разница в весе, хотя реально эта разница не попадает в статью затрат 40200...
            , _tmpItem_SummPartner_To.GoodsId         AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Покупатель
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- Контейнер - по долгам поставщика
            , 0                                       AS ObjectIntId_Analyzer   -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Поставщик или...
            , _tmpItem_SummPartner_To.ContainerId_Goods  AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , (_tmpItem_SummPartner_To.OperCount - _tmpItem_SummPartner_To.OperCount_PartnerFrom) * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- с противоположными знаками
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive -- т.к. с противоположными знаками
       FROM _tmpItem_SummPartner_To
            LEFT JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
       WHERE _tmpItem_SummPartner_To.OperCount <> _tmpItem_SummPartner_To.OperCount_PartnerFrom
      ;


     -- 2.1.3. формируются Проводки - долг ПОКУПАТЕЛЮ + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- это обычная проводка (на сумму поставщика)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Покупатель
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_SummPartner.ContainerId_Goods  AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , 1 * (_tmpItem_SummPartner.OperSumm_Partner - _tmpItem_SummPartner.OperSumm_70201)
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
       -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
       -- WHERE _tmpItem_SummPartner.OperSumm_Partner <> 0
      UNION ALL
       -- это обычная проводка (на сумму прибыли)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPartner.MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- счет есть всегда
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId               -- есть аналитика, т.е. то что относится к ОПиУ
            , _tmpItem_SummPartner.GoodsId            AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Покупатель
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_SummPartner.ContainerId_Goods  AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , 1 * _tmpItem_SummPartner.OperSumm_70201
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummPartner_To AS _tmpItem_SummPartner
       WHERE _tmpItem_SummPartner.OperSumm_70201 <> 0
      ;

     -- 2.1.4. формируются Проводки - Прибыль ПОКУПАТЕЛЮ + !!!нет MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0
            , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND vbMovementDescId = zc_Movement_IncomeAsset()
                        THEN zc_MIContainer_SummAsset()
                        ELSE zc_MIContainer_Summ()
              END AS DescId
            , vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId               -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM (SELECT _tmpItem_SummPartner_To.ContainerId_ProfitLoss_70201 AS ContainerId_ProfitLoss
                  , _tmpItem_SummPartner_To.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem_SummPartner_To.GoodsId                      AS GoodsId
                  , 0                                                    AS AnalyzerId -- нет аналитики
                  , -1 * SUM (_tmpItem_SummPartner_To.OperSumm_70201)    AS OperSumm
             FROM _tmpItem_SummPartner_To
             GROUP BY _tmpItem_SummPartner_To.ContainerId_ProfitLoss_70201, _tmpItem_SummPartner_To.ContainerId_Goods, _tmpItem_SummPartner_To.GoodsId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      ;


     -- 2.2.1. формируются "виртуальные" Проводки - для количественного учета по Сотруднику (ЗП) или "Учредитель" + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_Goods
            , zc_Enum_Account_110401()                AS AccountId               -- есть счет Транзит + виртуальный склад + виртуальный склад (т.е. в отчетах определяется "виртуальная")
            , 0                                       AS AnalyzerId              -- нет аналитики, т.е. признака "виртуальная" пока не надо
            , _tmpItem_SummPersonal.GoodsId           AS ObjectId_Analyzer       -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer  -- Физ.лицо (ЗП) или "Учредитель"
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer    -- Контейнер - по долгам поставщика
            , 0                                       AS ObjectIntId_Analyzer    -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer    -- Поставщик или...
            , _tmpItem_SummPersonal.ContainerId_Goods AS ContainerIntId_Analyzer -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_SummPersonal.OperCount * CASE WHEN tmp.isActive = TRUE THEN 1 ELSE -1 END AS Amount -- с противоположными знаками
            , vbOperDate                              AS OperDate
            , tmp.isActive                            AS isActive -- т.к. с противоположными знаками
       FROM _tmpItem_SummPersonal
            LEFT JOIN (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmp ON 1 = 1
      ;

     -- 2.2.2. формируются Проводки - долг Сотруднику (ЗП) + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId
            , _tmpItem_SummPersonal.AccountId         AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление ...
            , _tmpItem_SummPersonal.GoodsId           AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Физ.лицо (ЗП)
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , _tmpItem_SummPersonal.UnitId            AS ObjectIntId_Analyzer     -- !!!добавил Подразделение (ЗП)!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_SummPersonal.ContainerId_Goods AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , 1 * (_tmpItem_SummPersonal.OperSumm_Partner)
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummPersonal
       -- !!!надо ограничивать!!!
       WHERE _tmpItem_SummPersonal.OperSumm_Partner <> 0
         AND _tmpItem_SummPersonal.ContainerId_External = 0 -- !!!т.е. сотрудник!!!
      ;

     -- 2.2.3. формируются Проводки - долг "Учредитель" или "Перевыставление" + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_External
            , _tmpItem_SummPersonal.AccountId_External AS AccountId                -- счет есть всегда
            , 0                                        AS AnalyzerId               -- нет аналитики, т.е. деление ...
            , _tmpItem_SummPersonal.GoodsId            AS ObjectId_Analyzer        -- Товар
            , CASE WHEN _tmpItem_SummPersonal.FounderId <> 0 THEN _tmpItem_SummPersonal.FounderId ELSE _tmpItem_SummPersonal.JuridicalId END AS WhereObjectId_Analyzer   -- "Учредитель" или "Перевыставление"
            , vbContainerId_Analyzer                   AS ContainerId_Analyzer     -- Контейнер - по долгам поставщика
            , 0                                        AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                   AS ObjectExtId_Analyzer     -- Поставщик или...
            , _tmpItem_SummPersonal.ContainerId_Goods  AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                        AS ParentId
            , 1 * (_tmpItem_SummPersonal.OperSumm_Partner)
            , vbOperDate                               AS OperDate
            , TRUE                                     AS isActive
       FROM _tmpItem_SummPersonal
       -- !!!надо ограничивать!!!
       WHERE _tmpItem_SummPersonal.OperSumm_Partner <> 0
         AND _tmpItem_SummPersonal.ContainerId_External <> 0 -- !!!т.е. "Учредитель" или "Перевыставление"!!!
      ;
     -- 2.2.4. формируются Проводки - Прибыль - затраты "Заправка"
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- Заправка - ГСМ
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_ProfitLoss_20401
            , zc_Enum_Account_100301()                   AS AccountId                -- прибыль текущего периода
            , 0                                          AS AnalyzerId               -- в ОПиУ как правило не нужена аналитика, т.к. ...
            , _tmpItem_SummPersonal.GoodsId              AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                   AS WhereObjectId_Analyzer   -- Физ.лицо (ЗП) или "Учредитель"
            , vbContainerId_Analyzer                     AS ContainerId_Analyzer     -- в ОПиУ не нужен, НО здесь Контейнер - по долгам поставщика
            , _tmpItem_SummPersonal.UnitId_ProfitLoss    AS ObjectIntId_Analyzer     -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , _tmpItem_SummPersonal.BranchId_ProfitLoss  AS ObjectExtId_Analyzer     -- Филиал (ОПиУ), а могло быть BranchId_Route
            , _tmpItem_SummPersonal.ContainerId_Goods    AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                          AS ParentId
            , 1 * (_tmpItem_SummPersonal.OperSumm_20401)
            , vbOperDate                                 AS OperDate
            , FALSE                                      AS isActive                 -- !!!ОПиУ всегда по Кредиту!!!
       FROM _tmpItem_SummPersonal
       -- !!!можно ограничивать!!!
       WHERE _tmpItem_SummPersonal.OperSumm_20401 <> 0
      UNION ALL
       -- Общефирменные + услуги полученные + амортизация транспорт торговых
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_ProfitLoss_21425
            , zc_Enum_Account_100301()                   AS AccountId                -- прибыль текущего периода
            , 0                                          AS AnalyzerId               -- в ОПиУ как правило не нужена аналитика, т.к. ...
            , _tmpItem_SummPersonal.InfoMoneyId_21425    AS ObjectId_Analyzer        -- УП-статья
            , vbWhereObjectId_Analyzer                   AS WhereObjectId_Analyzer   -- Физ.лицо (ЗП)
            , vbContainerId_Analyzer                     AS ContainerId_Analyzer     -- в ОПиУ не нужен, НО здесь Контейнер - по долгам поставщика
            , _tmpItem_SummPersonal.UnitId_ProfitLoss    AS ObjectIntId_Analyzer     -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , _tmpItem_SummPersonal.BranchId_ProfitLoss  AS ObjectExtId_Analyzer     -- Филиал (ОПиУ), а могло быть BranchId_Route
            , _tmpItem_SummPersonal.ContainerId_Goods    AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                          AS ParentId
            , 1 * (_tmpItem_SummPersonal.OperSumm_21425)
            , vbOperDate                                 AS OperDate
            , FALSE                                      AS isActive                 -- !!!ОПиУ всегда по Кредиту!!!
       FROM _tmpItem_SummPersonal
       -- !!!можно ограничивать!!!
       WHERE _tmpItem_SummPersonal.OperSumm_21425 <> 0
      ;


     -- 3.3. формируются Проводки - доплата Физ.лицу(заготовитель)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , ContainerId
            , _tmpItem_SummPacker.AccountId           AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                       AS ObjectId_Analyzer        -- нет Товара
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , ContainerId                             AS ContainerId_Analyzer     -- тот же самый
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbMemberId_Packer                       AS ObjectExtId_Analyzer     -- заготовитель
            , 0                                       AS ContainerIntId_Analyzer  -- !!!нет!!!
            , 0                                       AS ParentId
            , -1 * OperSumm_Packer                    AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItem_SummPacker
       WHERE OperSumm_Packer <> 0;


     -- 4.1. определяется Счет(справочника) для проводок по расчетам с поставщиком - Физ.лицом (Водитель)
     UPDATE _tmpItem_SummDriver SET AccountId = _tmpItem_byAccount.AccountId
                                  , AccountId_Transit = CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 THEN zc_Enum_Account_110101() ELSE 0 END -- Транзит
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000())
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица) -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500())
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT InfoMoneyDestinationId FROM _tmpItem_SummDriver GROUP BY InfoMoneyDestinationId
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummDriver.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 4.2. определяется ContainerId для проводок по расчетам с поставщиком - Физ.лицо(Водитель)
     UPDATE _tmpItem_SummDriver SET ContainerId =
                                                  -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1) Физ.лицо(Водитель) 3)Статьи назначения
                                                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                        , inParentId          := NULL
                                                                        , inObjectId          := _tmpItem_SummDriver.AccountId
                                                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                        , inBusinessId        := _tmpItem_SummDriver.BusinessId
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                        , inObjectId_1        := vbMemberId_Driver
                                                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                        , inObjectId_2        := _tmpItem_SummDriver.InfoMoneyId
                                                                        , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                        , inObjectId_3        := vbBranchId_Car -- долг Подотчета на филиале Автомобиля or zc_Branch_Basis
                                                                        , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_4        := vbCarId
                                                                         )
                                  ,ContainerId_Transit = CASE WHEN _tmpItem_SummDriver.AccountId_Transit = 0 THEN 0
                                                              ELSE
                                                  -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1) Физ.лицо (Водитель) 3)Статьи назначения
                                                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                        , inParentId          := NULL
                                                                        , inObjectId          := _tmpItem_SummDriver.AccountId_Transit
                                                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                                        , inBusinessId        := _tmpItem_SummDriver.BusinessId
                                                                        , inObjectCostDescId  := NULL
                                                                        , inObjectCostId      := NULL
                                                                        , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                        , inObjectId_1        := vbMemberId_Driver
                                                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                        , inObjectId_2        := _tmpItem_SummDriver.InfoMoneyId
                                                                        , inDescId_3          := zc_ContainerLinkObject_Car()
                                                                        , inObjectId_3        := vbCarId
                                                                         )
                                                         END;

     -- 4.3. формируются Проводки - расчеты с поставщиком Физ.лицо(Водитель)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- это списание с водителя
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , ContainerId
            , _tmpItem_SummDriver.AccountId           AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                       AS ObjectId_Analyzer        -- нет Товара
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , ContainerId                             AS ContainerId_Analyzer     -- тот же самый - Водитель
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик
            , 0                                       AS ContainerIntId_Analyzer  -- !!!нет!!!
            , 0                                       AS ParentId
            , -1 * OperSumm_Driver                    AS Amount
            , vbOperDate                              AS OperDate                 -- т.е. по "Дате склад"
            , FALSE                                   AS isActive
       FROM _tmpItem_SummDriver
       WHERE OperSumm_Driver <> 0
     UNION ALL
       -- это расчеты с поставщиком за счет водителя
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummPartner.ContainerId
            , _tmpItem_SummPartner.AccountId          AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                       AS ObjectId_Analyzer        -- нет Товара
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem_SummDriver.ContainerId         AS ContainerId_Analyzer     -- !!!Водитель!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик
            , 0                                       AS ContainerIntId_Analyzer  -- !!!нет!!!
            , 0                                       AS ParentId
            , 1 * _tmpItem_SummDriver.OperSumm_Driver AS Amount
            , CASE WHEN _tmpItem_SummDriver.AccountId_Transit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummDriver
            INNER JOIN (SELECT _tmpItem_SummPartner.InfoMoneyId, _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId FROM _tmpItem_SummPartner GROUP BY _tmpItem_SummPartner.InfoMoneyId, _tmpItem_SummPartner.ContainerId, _tmpItem_SummPartner.AccountId
                       ) AS _tmpItem_SummPartner ON _tmpItem_SummPartner.InfoMoneyId = _tmpItem_SummDriver.InfoMoneyId
       WHERE _tmpItem_SummDriver.OperSumm_Driver <> 0
     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_SummDriver.ContainerId_Transit
            , _tmpItem_SummDriver.AccountId           AS AccountId                -- счет есть всегда
            , 0                                       AS AnalyzerId               -- нет аналитики, т.е. деление Поставщик, Заготовитель, Покупатель, Талоны пока не надо
            , 0                                       AS ObjectId_Analyzer        -- нет Товара
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , _tmpItem_SummDriver.ContainerId         AS ContainerId_Analyzer     -- !!!Водитель!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- Поставщик
            , 0                                       AS ContainerIntId_Analyzer  -- !!!нет!!!
            , 0                                       AS ParentId
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 1 ELSE -1 END * _tmpItem_SummDriver.OperSumm_Driver
            , tmpOperDate.OperDate
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN TRUE ELSE FALSE END AS IsActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            JOIN _tmpItem_SummDriver ON  _tmpItem_SummDriver.OperSumm_Driver <> 0
                                     AND _tmpItem_SummDriver.AccountId_Transit <> 0
      ;

     -- !!!Проводки для отчета больше не нужны!!!
     IF 1=0
     THEN
         RAISE EXCEPTION '!!!Проводки для отчета больше не нужны!!! - <08.11.2016>';
     END IF;


      IF   NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.DescId = zc_Movement_IncomeCost() AND Movement.StatusId = zc_Enum_Status_Complete())
      AND EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_TotalSummSpending() AND MF.ValueData <> 0)
     THEN
         -- обнулили <Итого сумма затрат по документу (с учетом НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSpending(), inMovementId, 0);
     END IF;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId -- zc_Movement_Income()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.10.14                                        * add InfoMoneyGroupId and InfoMoneyGroupId_Detail and UnitId_Asset
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_From
 05.09.14                                        * add zc_ContainerLinkObject_Branch to Физ.лица (подотчетные лица)
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 01.08.14                                        * zc_Enum_AccountDirection... Сотрудник (заготовитель) -> сотрудники (подотчетные лица)
 29.07.14                                        * change zc_GoodsKind_WorkProgress
 26.07.14                                        * add МНМА
 25.05.14                                        * add lpComplete_Movement
 11.05.14                                        * set zc_ContainerLinkObject_PaidKind is last
 11.05.14                                        * add Object_InfoMoney_View
 10.05.14                                        * add lpInsert_MovementProtocol
 08.04.14                                        * add Constant_InfoMoney_isCorporate_View
 04.04.14                                        * add zc_Enum_InfoMoney_21151
 21.12.13                                        * Personal -> Member
 01.11.13                                        * add vbOperDatePartner
 30.10.13                                        * add
 20.10.13                                        * add vbCardFuelId_From and vbTicketFuelId_From
 20.10.13                                        * add vbChangePrice
 06.10.13                                        * add StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
 06.10.13                                        * add inUserId
 03.10.13                                        * add vbBusinessId_Route
 02.10.13                                        * add zc_ObjectLink_Goods_Fuel
 30.09.13                                        * add vbCarId and vbMemberId_Driver
 17.09.13                                        * add lpInsertUpdate_ContainerCount_Goods and lpInsertUpdate_ContainerSumm_Goods
 15.09.13                                        * all
 14.09.13                                        * add vbBusinessId_To + isTareReturning
 02.09.13                                        * add lpInsertUpdate_MovementItemContainer_byTable
 29.08.13                                        * add lpInsertUpdate_MovementItemReport
 09.08.13                                        * add zc_isHistoryCost and zc_isHistoryCost_byInfoMoneyDetail
 07.08.13                                        * add inParentId and inIsActive
 05.08.13                                        * no InfoMoneyId_isCorporate
 20.07.13                                        * add MovementItemId
 20.07.13                                        * all Партии товара, ЕСЛИ надо ...
 19.07.13                                        * all
 12.07.13                                        * add PartionGoods
 11.07.13                                        * add ObjectCost
 04.07.13                                        * ! finich !
 02.07.13                                        *
*/

-- тест
/*
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM lpComplete_Movement_Income (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer, inIsLastComplete:= FALSE)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1100 , inSession:= zfCalc_UserAdmin())
*/
