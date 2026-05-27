-- Function: lpComplete_Movement_Sale (Integer, Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer               , -- Пользователь
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inIsRecalcPrice     Boolean  DEFAULT TRUE   -- Пересчет цен из Прайса или Акций при Проведении
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId_save Integer;

  DECLARE vbMovementId_Tax Integer;

  DECLARE vbMovementItemId_check Integer;

  DECLARE vbIsHistoryCost Boolean; -- нужны проводки с/с для этого пользователя

  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_PartnerFrom Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;

  DECLARE vbAccountId_GoodsTransit_01 Integer;
  DECLARE vbAccountId_GoodsTransit_02 Integer;
  DECLARE vbAccountId_GoodsTransit_51 Integer;
  DECLARE vbAccountId_GoodsTransit_52 Integer;
  DECLARE vbAccountId_GoodsTransit_53 Integer;

  DECLARE vbMovementDescId Integer;

  -- Корректировка суммы покупателя для выравнивания округлений
  DECLARE vbCorrSumm TFloat;
  --
  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_PriceListJur_byItem TFloat;
  DECLARE vbOperSumm_PriceListJur TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;
  DECLARE vbOperSumm_PartnerVirt_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_PartnerVirt_ChangePercent TFloat;
  DECLARE vbOperSumm_Currency_byItem TFloat;
  DECLARE vbOperSumm_Currency TFloat;

  DECLARE vbPriceWithVAT_PriceList Boolean;
  DECLARE vbVATPercent_PriceList TFloat;
  DECLARE vbPriceWithVAT_PriceListJur Boolean;
  DECLARE vbVATPercent_PriceListJur TFloat;
  DECLARE vbPriceListId_Jur Integer;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbIsChangePrice Boolean;
  DECLARE vbIsDiscountPrice Boolean;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbUnitId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbBranchId_From Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbIsPartionDate_Unit Boolean;

  DECLARE vbJuridicalId_From Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbPaidKindId_From Integer;
  DECLARE vbContractId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

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
  DECLARE vbBusinessId_To Integer;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
  DECLARE vbCurrencyPartnerValue TFloat;
  DECLARE vbParPartnerValue TFloat;

  DECLARE vbIsPartionDoc_Branch Boolean;
  DECLARE vbPartionMovementId Integer;
  DECLARE vbPaymentDate TDateTime;

  DECLARE vbIsPriceList_begin_recalc Boolean;

  DECLARE vbPriceListId_begin Integer;
  DECLARE vbOperDate_pl TDateTime;

  DECLARE vbMovementId_Order Integer;

  DECLARE vbIsRealEx Boolean;
  DECLARE vbMovementId_ReturnIn Integer;

  DECLARE vbIsNotRealGoods Boolean;


  DECLARE vbGoodsId Integer;
  DECLARE vbGoodsKindId Integer;
  DECLARE vbMeasureId Integer;
  DECLARE vbAmountPartner TFloat;
  DECLARE vbAmountOrder TFloat;
  DECLARE vbPersentReal TFloat;

  DECLARE vbIsPartionCell_from Boolean;

  DECLARE vbPersent_check TFloat;
BEGIN

     -- проверка отклонения по кол-ву
     vbUserId_save:= inUserId;
     inUserId:= ABS (inUserId);

     -- проверка отклонения по кол-ву
     vbPersent_check:= 19.99;


/*IF inUserId in (zfCalc_UserAdmin() :: Integer) -- , zc_Enum_Process_Auto_PrimeCost(), 9459)
 OR ('01.10.2017' <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
     AND
     '01.10.2017' <= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
    )
THEN
    PERFORM lpComplete_Movement_Sale_NEW (inMovementId, inUserId, FALSE);
    RETURN;
END IF;*/



     -- если Новая схема - StatusId_next
     IF zfCheck_User_StatusId_next (inUserId) = TRUE AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId_next = zc_Enum_Status_UnComplete())
     THEN
         -- 0.1. теперь он Не проведен
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Movement.Id = inMovementId;
         -- 0.2. Удаляем все проводки
         PERFORM lpDelete_MovementItemContainer (inMovementId);
         -- 0.3. Удаляем все проводки для отчета
         PERFORM lpDelete_MovementItemReport (inMovementId);
     END IF;


     -- расчет "кол-во склад"!!! - кроме Админа
     IF 1=1 -- inUserId = zfCalc_UserAdmin() :: Integer -- OR 1=1
     THEN
         -- !!!Синхронно - пересчитали/провели Пересортица!!! - на основании "Реализация" - !!!важно - здесь очищается _tmpMIContainer_insert, поэтому делаем ДО проводок!!!, но после заполнения _tmpItem
         PERFORM lpComplete_Movement_Sale_Recalc_pack (inMovementId := inMovementId
                                                     , inUserId     := inUserId
                                                      );
     END IF;



     -- !!!временно!!!
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);

     -- !!!обязательно!!! очистили таблицу - Promo-recalc
     DELETE FROM _tmpItem_Promo_recalc;
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm;
     -- !!!обязательно!!! очистили таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- проверка отклонения по кол-ву более чем на vbPersent_check % - Розподільчий комплекс
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From() AND MLO.ObjectId = zc_Unit_RK())
  --AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind() AND MLO.ObjectId = zc_Enum_PaidKind_FirstForm())
    AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.OperDate > '12.12.2022')
    -- Есть заявка
    AND EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order() AND MLM.MovementChildId > 0)
  --AND inUserId <> zfCalc_UserAdmin() :: Integer
  --AND inMovementId <> 24732446 --
    AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
    AND inUserId <> 8159525 -- Парфеєвець Н.В.
     THEN
         -- если есть хоть 1 товар у которого кол > на vbPersent_check% чем в заявка выдаем сообщение
         SELECT tmp.GoodsId
              , tmp.GoodsKindId
              , tmp.MeasureId
              , tmp.AmountPartner
              , tmp.AmountOrder
              , tmp.PersentReal
              , tmp.PersentReal
                INTO vbGoodsId, vbGoodsKindId, vbMeasureId, vbAmountPartner, vbAmountOrder, vbPersentReal
         FROM
           (WITH
            tmpMIOrder AS (SELECT MovementItem.ObjectId AS GoodsId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0)) AS Amount
                                , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0)) /100 * vbPersent_check AS Amount15
                           FROM MovementLinkMovement AS MovementLinkMovement_Order
                                INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Order.MovementChildId
                                                      AND MovementItem.DescId = zc_MI_Master()
                                                      AND MovementItem.isErased = FALSE
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                            ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                           WHERE MovementLinkMovement_Order.MovementId = inMovementId       --23791150 --
                             AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                             AND COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0) <> 0
                           GROUP BY MovementItem.ObjectId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                         )
          , tmpMISale AS (SELECT MovementItem.ObjectId AS GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MovementItem.Amount,0) AS Amount
                               , MIFloat_AmountPartner.ValueData               AS AmountPartner
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                           ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId = zc_MI_Master()
                            AND MovementItem.isErased = FALSE
                            -- !!! замовлення в яких більше 2,7 кілограма.
                            -- AND MIFloat_AmountPartner.ValueData > 2.7
                          )

              SELECT tmpMISale.GoodsId
                   , tmpMISale.GoodsKindId
                   , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
                   , COALESCE (tmpMISale.AmountPartner,0) AS AmountPartner
                   , COALESCE (tmpMIOrder.Amount,0)       AS AmountOrder
                   , CASE WHEN tmpMIOrder.Amount > 0
                          THEN CAST ((COALESCE (tmpMISale.AmountPartner,0) - COALESCE (tmpMIOrder.Amount,0)) * 100 / COALESCE (tmpMIOrder.Amount,0) AS NUMERIC (16,1))
                          ELSE 100
                     END AS PersentReal
              FROM tmpMISale
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId      = tmpMISale.GoodsId
                                       AND ObjectLink_Goods_Measure.DescId        = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN tmpMIOrder ON tmpMIOrder.GoodsId     = tmpMISale.GoodsId
                                       AND tmpMIOrder.GoodsKindId = tmpMISale.GoodsKindId
              WHERE ((COALESCE (tmpMISale.AmountPartner,0) - COALESCE (tmpMIOrder.Amount,0) > COALESCE (tmpMIOrder.Amount15, 0) AND COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) <> zc_Measure_Sh())
                  OR (COALESCE (tmpMISale.AmountPartner,0) - COALESCE (tmpMIOrder.Amount,0) > 0 AND ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh())
                    )
               -- !!! замовлення в яких більше 0.1 кілограма.
               AND (COALESCE (tmpMIOrder.Amount,0) = 0 OR tmpMIOrder.Amount >= 0.1)
               -- !!! замовлення в яких більше 2,7 кілограма.
               AND (COALESCE (tmpMIOrder.Amount,0) = 0 OR tmpMIOrder.Amount >= 2.7)
               --AND (COALESCE (tmpMIOrder.Amount,0) = 0 OR tmpMIOrder.Amount > 5)
               --AND inUserId <> 5
              LIMIT 1
             ) AS tmp;

         IF COALESCE (vbGoodsId,0) > 0
         THEN
             RAISE EXCEPTION 'Ошибка.В продаже % % % % % отклонение от заказа больше % %  %Количество = <%> %Заказ = <%> % факт % отклонения = <%>.'
                             , CHR (13)
                             , lfGet_Object_ValueData (vbGoodsId)
                             , CHR (13)
                             , lfGet_Object_ValueData_sh (vbGoodsKindId)
                             , CHR (13)
                             , zfConvert_FloatToString (CASE WHEN vbMeasureId = zc_Measure_Sh() THEN 0 ELSE vbPersent_check END)
                             , '%'
                             , CHR (13)
                             , zfConvert_FloatToString (vbAmountPartner)
                             , CHR (13)
                             , zfConvert_FloatToString (vbAmountOrder)
                             , CHR (13)
                             , '%'
                             , zfConvert_FloatToString (vbPersentReal);
         END IF;
     END IF;


     -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN /*IF inIsLastComplete = FALSE
             -- OR DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '3 DAY') <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
          -- !!! нужны еще для Запорожья, понятно что временно!!!
          -- !!! OR 301310 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          -- !!! нужны еще для Одесса, понятно что временно!!!
          -- !!! OR 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          THEN vbIsHistoryCost:= TRUE;
          ELSE vbIsHistoryCost:= FALSE;
          END IF;*/
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! для остальных тоже нужны проводки с/с!!!
         IF (0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- Кладовщик Днепр
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- Бухгалтер ДНЕПР
            )
            AND DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '3 DAY') <= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT
            CASE WHEN EXTRACT (MONTH FROM Movement.OperDate) < EXTRACT (MONTH FROM CURRENT_DATE)
                  AND EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '7 DAY')
                      THEN TRUE
                 ELSE vbIsHistoryCost
            END AS isHistoryCost -- !!!еще раз расчет!!!
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE)            AS isDiscountPrice_juridical

          , Movement.DescId                                                      AS MovementDescId
          , Movement.OperDate                                                    AS OperDate -- COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDate --
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
          , 0 AS MemberId_From -- COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From
          , COALESCE (CASE WHEN ObjectLink_Partner_Branch.ChildObjectId <> 0
                                THEN ObjectLink_Partner_Branch.ChildObjectId

                           WHEN Object_From.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitFrom_Branch.ChildObjectId

                           WHEN Object_From.DescId = zc_Object_Partner()
                                THEN ObjectLink_PartnerFrom_Branch.ChildObjectId

                           WHEN Object_From.DescId = zc_Object_Personal()
                                THEN ObjectLink_UnitPersonalFrom_Branch.ChildObjectId
                           ELSE 0
                      END, 0) AS BranchId_From
          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= '01.05.2015'
                      THEN COALESCE (ObjectBoolean_PartionDoc.ValueData, FALSE)
                 ELSE FALSE
            END AS isPartionDoc_Branch
          , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_From -- Аналитики счетов - направления !!!нужны только для подразделения!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_PartnerFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
          , COALESCE (MovementLinkObject_PaidKindFrom.ObjectId, 0) AS PaidKindId_From
          , COALESCE (MovementLinkObject_ContractFrom.ObjectId, 0) AS ContractId_From
            -- УП Статью назначения берем: ВСЕГДА по договору
          , COALESCE (ObjectLink_ContractFrom_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
            END AS isCorporate_To
          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                 ELSE 0
            END AS InfoMoneyId_CorporateTo
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To

          , CASE WHEN MovementBoolean_TotalSumm_GoodsReal.ValueData = TRUE
                      THEN FALSE
                 ELSE COALESCE (ObjectBoolean_isNotRealGoods.ValueData, FALSE)
            END AS isNotRealGoods

          , 0 AS MemberId_To -- COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN Object_To.Id WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To

            -- УП Статью назначения берем: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ChildObjectId WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_ContractFrom_JuridicalBasis.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalFrom_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_From
          , COALESCE (ObjectLink_PartnerTo_Business.ChildObjectId, 0) AS BusinessId_To

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
          , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (MovementFloat_ParPartnerValue.ValueData, 0)                             AS ParPartnerValue
            --
          , COALESCE (ObjectLink_Contract_PriceList.ChildObjectId, ObjectLink_Juridical_PriceList.ChildObjectId) AS PriceListId_Jur

            --
          , COALESCE (MovementLinkMovement_ReturnIn.MovementChildId,0)           AS MovementId_ReturnIn
          , COALESCE (ObjectBoolean_Contract_RealEx.ValueData, False) :: Boolean AS isRealEx

            -- Корректировка суммы покупателя для выравнивания округлений
          , COALESCE (MovementFloat_CorrSumm.ValueData, 0) AS CorrSumm

            INTO vbIsHistoryCost, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbIsDiscountPrice
               , vbMovementDescId, vbOperDate, vbOperDatePartner
               , vbUnitId_From, vbMemberId_From, vbBranchId_From, vbIsPartionDoc_Branch, vbAccountDirectionId_From, vbIsPartionDate_Unit
               , vbJuridicalId_From, vbPartnerId_From, vbPaidKindId_From, vbContractId_From, vbInfoMoneyId_From
               , vbJuridicalId_To, vbIsCorporate_To, vbInfoMoneyId_CorporateTo, vbPartnerId_To, vbIsNotRealGoods, vbMemberId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_From, vbBusinessId_From, vbBusinessId_To
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue
               , vbPriceListId_Jur
               , vbMovementId_ReturnIn, vbIsRealEx
               , vbCorrSumm

     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_TotalSumm_GoodsReal
                                    ON MovementBoolean_TotalSumm_GoodsReal.MovementId =  Movement.Id
                                   AND MovementBoolean_TotalSumm_GoodsReal.DescId = zc_MovementBoolean_TotalSumm_GoodsReal()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          -- Корректировка суммы
          LEFT JOIN MovementFloat AS MovementFloat_CorrSumm
                                  ON MovementFloat_CorrSumm.MovementId = Movement.Id
                                 AND MovementFloat_CorrSumm.DescId     = zc_MovementFloat_CorrSumm()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

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
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                  ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                  ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                               ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                               ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                  ON ObjectBoolean_PartionDoc.ObjectId = ObjectLink_UnitFrom_Branch.ChildObjectId
                                 AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc()
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

          LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Juridical
                               ON ObjectLink_PartnerFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PartnerFrom_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_From.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Branch
                               ON ObjectLink_PartnerFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PartnerFrom_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
                              AND Object_From.DescId = zc_Object_Partner()
                              AND 1 = 0 -- вроде это как наш филиал

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
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                  ON ObjectBoolean_isNotRealGoods.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isNotRealGoods.DescId   = zc_ObjectBoolean_Juridical_isNotRealGoods()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch
                               ON ObjectLink_Partner_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!не ошибка!!!
                              AND Object_To.DescId = zc_Object_Partner()
                              AND 1 = 0 -- вроде это как наш филиал
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                               ON ObjectLink_Partner_Unit.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Business
                               ON ObjectLink_PartnerTo_Business.ObjectId = ObjectLink_Partner_Unit.ChildObjectId
                              AND ObjectLink_PartnerTo_Business.DescId = zc_ObjectLink_Unit_Business()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindFrom
                                       ON MovementLinkObject_PaidKindFrom.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKindFrom.DescId = zc_MovementLinkObject_PaidKindFrom()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                       ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                      AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
          LEFT JOIN ObjectLink AS ObjectLink_ContractFrom_InfoMoney
                               ON ObjectLink_ContractFrom_InfoMoney.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                              AND ObjectLink_ContractFrom_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN ObjectLink AS ObjectLink_ContractFrom_JuridicalBasis
                               ON ObjectLink_ContractFrom_JuridicalBasis.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                              AND ObjectLink_ContractFrom_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                               ON ObjectLink_Contract_PriceList.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Contract_RealEx
                                  ON ObjectBoolean_Contract_RealEx.ObjectId = MovementLinkObject_Contract.ObjectId
                                 AND ObjectBoolean_Contract_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                               ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
          --док основание возврат
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ReturnIn
                                         ON MovementLinkMovement_ReturnIn.MovementId = Movement.Id
                                        AND MovementLinkMovement_ReturnIn.DescId     = zc_MovementLinkMovement_ReturnIn()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- Если учет по ячейкам - РАСХОД - Учет будет для От КОГО
     IF vbMovementDescId = zc_Movement_SaleAsset()
     THEN vbIsPartionCell_from:= FALSE;
     ELSE vbIsPartionCell_from:= lfGet_Object_Unit_isPartionCell (vbOperDate, vbUnitId_From)
                              OR (inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
                              AND vbUnitId_From = zc_Unit_RK()
                              AND vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                                 )
                              OR (vbOperDate >= lfGet_Object_Unit_PartionDate_isPartionCell()
                              AND vbUnitId_From = zc_Unit_RK()
                                 )
                                ;
     END IF;

     -- проверка
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> уже Проведен.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                        ;
     END IF;


     -- проверка
     IF vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND vbCurrencyDocumentId <> vbCurrencyPartnerId
     THEN
         RAISE EXCEPTION 'Ошибка.Неверное значение <Валюта (цена)> или <Валюта (покупатель)>';
     END IF;

     -- проверка
     IF COALESCE (vbJuridicalId_To, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbContractId AND OL.DescId = zc_ObjectLink_Contract_Juridical()), 0)
    AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
    AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.В документе выбран договор%для Юридического лица = <%>.%Необходимо выбрать договор%для Юридического лица = <%>.'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbContractId AND OL.DescId = zc_ObjectLink_Contract_Juridical()))
                       , CHR (13)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbJuridicalId_To)
                        ;
     END IF;

     -- проверка если договор RealEx = TRUE, тогда "На основании № (возврат)" должен быть заполнен
     IF COALESCE (vbIsRealEx,FALSE) = TRUE AND COALESCE (vbMovementId_ReturnIn,0) = 0 AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
     THEN
         RAISE EXCEPTION 'Ошибка.Не Заполнено значение На основании № (возврат).';
     END IF;


     -- !!!записали св-во
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, zfCalc_GoodsPropertyId (vbContractId, vbJuridicalId_To, vbPartnerId_To));


     -- Эти параметры прайс-листа нужны для ...
     SELECT lfGet.PriceWithVAT, lfGet.VATPercent INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfGet;
     -- Эти параметры СПЕЦ. прайс-листа нужны для ...
     SELECT lfGet.PriceWithVAT, lfGet.VATPercent INTO vbPriceWithVAT_PriceListJur, vbVATPercent_PriceListJur FROM lfGet_Object_PriceList (vbPriceListId_Jur) AS lfGet;

     -- !!! Коротких О.Л. - Касян С.А.
     vbIsPriceList_begin_recalc:= inUserId IN (/*zfCalc_UserMain(), */ 7015095 /*, 2030723, 5*/) AND vbOperDate >= '01.04.2021'
                            --AND EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
                                 ;

     -- !!!Пересчет  Товар (факт отгрузка)
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbJuridicalId_To AND OB.DescId = zc_ObjectBoolean_Juridical_isNotRealGoods() AND OB.ValueData = TRUE)
        AND '01.12.2022' <= vbOperDate
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
         FROM (SELECT MovementItem.Id AS MovementItemId
                      -- сохранили связь с <Товар ((факт отгрузка))>
                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsReal(), MovementItem.Id, ObjectLink_GoodsByGoodsKind_GoodsReal.ChildObjectId)
                      -- сохранили связь с <Виды товаров (факт отгрузка)>
                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindReal(), MovementItem.Id, ObjectLink_GoodsByGoodsKind_GoodsKindReal.ChildObjectId)
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                     ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                     ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                          ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = MILinkObject_GoodsKind.ObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsReal
                                         ON ObjectLink_GoodsByGoodsKind_GoodsReal.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind_GoodsReal.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsReal()
                    LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindReal
                                         ON ObjectLink_GoodsByGoodsKind_GoodsKindReal.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                        AND ObjectLink_GoodsByGoodsKind_GoodsKindReal.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId = zc_MI_Master()
                 AND (COALESCE (MILinkObject_GoodsReal.ObjectId, 0)     <> COALESCE (ObjectLink_GoodsByGoodsKind_GoodsReal.ChildObjectId, 0)
                   OR COALESCE (MILinkObject_GoodsKindReal.ObjectId, 0) <> COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindReal.ChildObjectId, 0)
                     )
              ) AS tmp;
     ELSE
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
         FROM (SELECT MovementItem.Id AS MovementItemId
                      -- сохранили связь с <Товар ((факт отгрузка))>
                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsReal(), MovementItem.Id, NULL)
                      -- сохранили связь с <Виды товаров (факт отгрузка)>
                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindReal(), MovementItem.Id, NULL)
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                     ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                     ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId = zc_MI_Master()
                 AND (MILinkObject_GoodsReal.ObjectId     > 0
                   OR MILinkObject_GoodsKindReal.ObjectId > 0
                     )
              ) AS tmp;

     END IF;


     -- если схема Павильоны
     IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId_To AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Partner_Unit())
        -- AND inUserId = 5
     THEN
         -- Пересчитали
         PERFORM lpUpdate_MovementItem_Sale_PriceIn (inMovementId:= inMovementId, inUserId:= inUserId);

     END IF;

     -- !!!нашли!!!
     vbMovementId_Order:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order());

     -- !!!Пересчет цен - если надо!!!!
     IF vbIsPriceList_begin_recalc = TRUE AND inIsRecalcPrice = TRUE
     THEN
         -- !!!нашли!!!
         SELECT tmp.PriceListId, tmp.OperDate
               INTO vbPriceListId_begin, vbOperDate_pl
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := vbContractId
                                                   , inPartnerId      := vbPartnerId_To
                                                   , inMovementDescId := zc_Movement_Sale()
                                                   , inOperDate_order := CASE WHEN vbMovementId_Order <> 0
                                                                                   THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Order)
                                                                              ELSE NULL
                                                                         END
                                                   , inOperDatePartner:= vbOperDatePartner -- т.к. есть факт. дата
                                                   , inDayPrior_PriceReturn:= 0
                                                   , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                   , inOperDatePartner_order:= NULL
                                                    ) AS tmp;


         -- Сохранили Прайс
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId_begin);

         -- текущие элементы
         INSERT INTO _tmpItem_Promo_recalc (MovementItemId, GoodsId, GoodsKindId, OperPrice, MovementId_promo, OperPrice_promo, CountForPrice_promo, isChangePercent_promo)
            SELECT MovementItem.Id                               AS MovementItemId
                 , MovementItem.ObjectId                         AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , COALESCE (MIFloat_Price.ValueData, 0)         AS OperPrice
                 , 0 AS MovementId_promo
                 , 0 AS OperPrice_promo
                 , 0 AS CountForPrice_promo
                 , TRUE AS isChangePercent_promo
            FROM MovementItem
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId         = zc_MIFloat_Price()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
           ;

         -- !!!нашли Акции!!!
         UPDATE _tmpItem_Promo_recalc SET MovementId_promo = lpGet.MovementId
                                        , OperPrice_promo = CASE WHEN /*lpGet.TaxPromo <> 0*/ 1=1 AND vbPriceWithVAT = TRUE THEN lpGet.PriceWithVAT_orig
                                                                 WHEN /*lpGet.TaxPromo <> 0*/ 1=1 THEN lpGet.PriceWithOutVAT_orig
                                                                 ELSE 0
                                                            END
                                        , CountForPrice_promo = lpGet.CountForPrice
                                        , isChangePercent_promo = lpGet.isChangePercent
         FROM _tmpItem_Promo_recalc AS _tmpItem_Promo_recalc_find
              JOIN lpGet_Movement_Promo_Data (inOperDate   := CASE WHEN vbMovementId_Order <> 0
                                                               AND TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
                                                                           FROM ObjectLink AS ObjectLink_Juridical
                                                                                INNER JOIN ObjectLink AS ObjectLink_Retail
                                                                                                      ON ObjectLink_Retail.ObjectId = ObjectLink_Juridical.ChildObjectId
                                                                                                     AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                INNER JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                                                                         ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Retail.ChildObjectId
                                                                                                        AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                                                                           WHERE ObjectLink_Juridical.ObjectId = vbPartnerId_To
                                                                             AND ObjectLink_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                          )
                                                                   THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Order)
                                                              ELSE (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                         END
                                       , inPartnerId  := vbPartnerId_To
                                       , inContractId := vbContractId
                                       , inUnitId     := vbUnitId_From
                                       , inGoodsId    := _tmpItem_Promo_recalc_find.GoodsId
                                       , inGoodsKindId:= _tmpItem_Promo_recalc_find.GoodsKindId
                                        ) AS lpGet
              ON lpGet.MovementId > 0
         WHERE _tmpItem_Promo_recalc.MovementItemId = _tmpItem_Promo_recalc_find.MovementItemId
        ;

IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>', (select _tmpItem_Promo_recalc.MovementId_promo from _tmpItem_Promo_recalc where _tmpItem_Promo_recalc.MovementItemId = 256809205 );
end if;


         -- Сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
         FROM (WITH tmpMI AS (SELECT _tmpItem_Promo_recalc.MovementItemId
                                   , _tmpItem_Promo_recalc.GoodsId
                                   , _tmpItem_Promo_recalc.GoodsKindId
                                   , _tmpItem_Promo_recalc.OperPrice   AS OperPrice_old
                                   , CASE WHEN _tmpItem_Promo_recalc.isChangePercent_promo = TRUE THEN COALESCE (MF_ChangePercent.ValueData, 0) ELSE 0 END AS ChangePercent
                                   , _tmpItem_Promo_recalc.MovementId_promo
                                   , _tmpItem_Promo_recalc.OperPrice_promo
                                   , _tmpItem_Promo_recalc.CountForPrice_promo
                              FROM _tmpItem_Promo_recalc
                                   LEFT JOIN MovementFloat AS MF_ChangePercent
                                                           ON MF_ChangePercent.MovementId = inMovementId
                                                          AND MF_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
                             )
                    , tmpPrice AS (SELECT tmpGoods.GoodsId
                                        , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                        , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS OperPrice
                                   FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                                         INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                               ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                              AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                         INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                               ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                              AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId_begin
                                                              AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                         LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                              ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                             AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                         INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                                 AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                                 AND vbOperDate_pl >= ObjectHistory_PriceListItem.StartDate AND vbOperDate_pl < ObjectHistory_PriceListItem.EndDate
                                         LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                      ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                     AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                   WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                                  )
                  , tmpAll AS (SELECT tmpMI.MovementItemId
                                    , tmpMI.MovementId_promo
                                    , CASE WHEN tmpMI.MovementId_promo > 0 THEN tmpMI.OperPrice_promo
                                           ELSE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0)
                                      END AS OperPrice
                                    , CASE WHEN tmpMI.MovementId_promo > 0 AND tmpMI.CountForPrice_promo > 0 THEN tmpMI.CountForPrice_promo
                                           ELSE 1
                                      END AS CountForPrice
                                    , tmpMI.ChangePercent
                                    , FALSE AS isDelete
                               FROM tmpMI
                                    LEFT JOIN tmpPrice AS tmpPrice_1 ON tmpPrice_1.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_1.GoodsKindId = tmpMI.GoodsKindId
                                    LEFT JOIN tmpPrice AS tmpPrice_2 ON tmpPrice_2.GoodsId     = tmpMI.GoodsId
                                                                    AND tmpPrice_2.GoodsKindId = 0
                               WHERE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0) > 0
                                 AND (tmpMI.OperPrice_old <> CASE WHEN tmpMI.MovementId_promo > 0 THEN tmpMI.OperPrice_promo
                                                                  ELSE COALESCE (tmpPrice_1.OperPrice, tmpPrice_2.OperPrice, 0)
                                                             END
                                   OR tmpMI.MovementId_promo > 0
                                     )
                              /*UNION ALL
                                SELECT tmpMI.MovementItemId
                                     , 0 AS MovementId_promo
                                     , 0 AS OperPrice
                                     , 1 AS CountForPrice
                                     , 0 AS ChangePercent
                                     , TRUE AS isDelete

                                FROM _tmpItem
                                     LEFT JOIN tmpMI ON tmpMI.MovementItemId = _tmpItem.MovementItemId
                                                    AND tmpMI.MovementId_promo > 0
                                WHERE tmpMI.MovementItemId IS NULL*/
                              )
               -- Сохранили Цены
               SELECT CASE WHEN tmpAll.isDelete = FALSE THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmpAll.MovementItemId, tmpAll.OperPrice) END
                      -- сохранили свойство <MovementId-Акция>
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), tmpAll.MovementItemId, COALESCE (tmpAll.MovementId_promo, 0))
                       -- сохранили свойство <(-)% Скидки (+)% Наценки>
                    , CASE WHEN tmpAll.isDelete = FALSE THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), tmpAll.MovementItemId, tmpAll.ChangePercent) END
                      -- сохранили свойство <Цена за количество>
                    , CASE WHEN tmpAll.isDelete = FALSE THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), tmpAll.MovementItemId, tmpAll.CountForPrice) END
                      --
                    , tmpAll.MovementItemId
               FROM tmpAll
              ) AS tmp;


         -- !!!временно!!!
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);

         -- Тест
         -- RAISE EXCEPTION 'Ошибка.<%  %>', lfGet_Object_ValueData_sh (vbPriceListId_begin), zfConvert_DateToString (vbOperDate_pl);

     END IF;


     -- определяется "Партионный учет долгов нал"
     IF vbIsPartionDoc_Branch = TRUE
     THEN
         IF 1 < (SELECT COUNT(*)
                 FROM (SELECT vbOperDatePartner AS OperDate) AS tmp
                      LEFT JOIN Object_ContractCondition_View
                             ON Object_ContractCondition_View.ContractId = vbContractId
                            AND Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                            AND Object_ContractCondition_View.Value <> 0
                            AND vbOperDatePartner BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                )
         THEN
             RAISE EXCEPTION 'Ошибка.Дублируется условие в договоре № <%>.', lfGet_Object_ValueData (vbContractId);
         END IF;
         -- определяется
         vbPaymentDate:= (SELECT tmp.OperDate + (tmp.OperDate - zfCalc_DetermentPaymentDate (COALESCE (Object_ContractCondition_View.ContractConditionKindId, 0), COALESCE (Value, 0) :: Integer, tmp.OperDate))
                          FROM (SELECT vbOperDatePartner AS OperDate) AS tmp
                               LEFT JOIN Object_ContractCondition_View
                                      ON Object_ContractCondition_View.ContractId = vbContractId
                                     AND Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                     AND Object_ContractCondition_View.Value <> 0
                                     AND vbOperDatePartner BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                         );
         -- проверка
         IF vbPaymentDate IS NULL OR vbPaymentDate < vbOperDatePartner
         THEN
             RAISE EXCEPTION 'Ошибка.В договоре не определены условия отсрочки.(%)', vbPaymentDate;
         END IF;

         -- определяется
         vbPartionMovementId:= lpInsertFind_Object_PartionMovement (inMovementId, vbPaymentDate);

     END IF;

     -- определяется Управленческие назначения, параметр нужен для для формирования Аналитик в проводках (для Покупателя)
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS View_InfoMoney;
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS View_InfoMoney;

     -- !!!Если нет филиала для "основной деятельности", тогда это "главный филиал"
     IF COALESCE (vbBranchId_From, 0) = 0
        /*vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                      , zc_Enum_InfoMoneyDestination_30200() -- Мясное сырье
                                       )
        AND vbBranchId_From = 0*/
     THEN
         vbBranchId_From:= zc_Branch_Basis();
     END IF;


     -- заполняем таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_Count, ContainerId_GoodsPartner, ContainerId_GoodsTransit_01, ContainerId_GoodsTransit_02, ContainerId_GoodsTransit_53, ObjectDescId, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate, ChangePercent, isChangePrice
                         , OperCount, OperCountCount, OperCount_ChangePercent, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_PriceListJur, OperSumm_PriceListJur
                         , tmpOperSumm_Partner, tmpOperSumm_Partner_original, tmpOperSumm_PartnerVirt, tmpOperSumm_Partner_Currency
                         , OperSumm_Partner, OperSumm_Partner_ChangePercent, OperSumm_PartnerVirt_ChangePercent, OperSumm_Currency, OperSumm_Partner_ChangePromo, OperSumm_80103
                         , ContainerId_ProfitLoss_10100, ContainerId_ProfitLoss_10200, ContainerId_ProfitLoss_10250, ContainerId_ProfitLoss_10300, ContainerId_ProfitLoss_80103
                         , ContainerId_Partner, ContainerId_Currency, AccountId_Partner, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_From
                         , isPartionCount, isPartionSumm, isTareReturning, isLossMaterials, isPromo
                         , PartionGoodsId
                         , PriceListPrice, PriceListJurPrice, Price, Price_Currency, Price_original, CountForPrice
                         , OperCount_start, OperCountCount_start, OperCount_ChangePercent_start, OperCount_Partner_start
                         )

    WITH tmpMI_all AS (SELECT (MovementItem.Id)                             AS MovementItemId
                            , COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId, 0)               AS GoodsId

                              -- !!!замена!!!
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- Тушенка
                                    AND COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) = zc_GoodsKind_Basis()
                                        THEN 0

                                   ELSE COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0)
                              END AS GoodsKindId

                            , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                            , COALESCE (MIFloat_PromoMovement.ValueData, 0) AS MovementId_promo

                            , (MovementItem.Amount)                                  AS OperCount
                            , COALESCE (MIFloat_Count.ValueData, 0)                  AS OperCountCount
                            , (COALESCE (MIFloat_AmountChangePercent.ValueData, 0))  AS OperCount_ChangePercent
                            , (COALESCE (MIFloat_AmountPartner.ValueData, 0))        AS OperCount_Partner

                            , COALESCE (MIFloat_Price.ValueData, 0)                  AS Price_original
                            , COALESCE (MIFloat_CountForPrice.ValueData, 0)          AS CountForPrice

                            , CASE WHEN vbMovementDescId = zc_Movement_SaleAsset() THEN MovementItem.ObjectId ELSE COALESCE (MILinkObject_Asset.ObjectId, 0) END AS AssetId
                            , COALESCE (MIString_PartionGoods.ValueData, '')         AS PartionGoods
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                            , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId_asset
                            , COALESCE (CLO_PartionGoods.ObjectId, 0)                AS PartionGoodsId_asset

                              -- Управленческие назначения
                            , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                              -- Статьи назначения
                            , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                             ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                                                            AND vbIsNotRealGoods                      = FALSE
                                                            AND vbOperDate                            >= '15.12.2022'
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                             ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
                                                            AND vbIsNotRealGoods                          = FALSE
                                                            AND vbOperDate                                >= '15.12.2022'

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                        ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                         ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Count.DescId         = zc_MIFloat_Count()

                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                        ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()

                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                       AND vbMovementDescId                   = zc_Movement_SaleAsset()
                            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                          ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId, 0)
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         AND vbMovementDescId        IN (zc_Movement_Sale(), zc_Movement_SaleAsset())
                      )
    -- !!!надо определить - есть ли скидка в цене!!!
  , tmpChangePrice AS (SELECT TRUE AS isChangePrice
                       FROM tmpMI_all
                       WHERE (vbIsDiscountPrice = TRUE                    -- у Юр лица есть галка
                           OR tmpMI_all.ChangePercent = 0                 -- в шапке есть скидка, но есть хоть один элемент со скидкой = 0%
                           OR vbPaidKindId = zc_Enum_PaidKind_FirstForm() -- это БН
                             )
                         AND (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0)
                       LIMIT 1
                      )
      , tmpPL_Basis AS (-- цены из прайса напрямую, для скорости
                       SELECT DISTINCT
                              tmpMI_all.GoodsId
                            , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                            , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                       FROM tmpMI_all
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_all.GoodsId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                            INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                     ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                    AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                      )
       , tmpPL_Jur AS (-- цены из прайса напрямую, для скорости
                       SELECT DISTINCT
                              tmpMI_all.GoodsId
                            , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                            , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                       FROM tmpMI_all
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_all.GoodsId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId_Jur
                                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                            INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                     ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                    AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                    AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                       WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                      )
, tmpContainer_asset AS (SELECT tmpMI.ContainerId_asset
                                -- тоже на всякий случай - Капитальные инвестиции + Производственное оборудование
                              , COALESCE (CLO_InfoMoney.ObjectId, zc_Enum_InfoMoney_70102()) AS InfoMoneyId
                              , ROW_NUMBER()     OVER (PARTITION BY tmpMI.ContainerId_asset ORDER BY CLO_InfoMoney.ObjectId ASC) AS Ord -- !!!на всякий случай!!!
                         FROM tmpMI_all AS tmpMI
                              LEFT JOIN Container ON Container.ParentId = tmpMI.ContainerId_asset
                                                 AND Container.DescId   = zc_Container_Summ()
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                         WHERE tmpMI.ContainerId_asset > 0
                        )

  -- сначала партии для итого расхода
, tmpMI_summ  AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, SUM (tmpMI.OperCount) AS OperCount
                       , SUM (tmpMI.OperCount_ChangePercent) AS OperCount_ChangePercent
                       , SUM (tmpMI.OperCount_Partner)       AS OperCount_Partner
                       , tmpMI.InfoMoneyDestinationId, tmpMI.InfoMoneyId
                  FROM tmpMI_all AS tmpMI
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                       LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                       ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                  WHERE -- только не ОС
                        tmpMI.ContainerId_asset = 0
                    -- учет - по партиям
                    AND (View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                 , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                 , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                  )

                      -- учет - партии по датам + ячейки
                      OR (vbIsPartionCell_from = TRUE
                      AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                  , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                   )
                         ))

                  GROUP BY tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.InfoMoneyDestinationId, tmpMI.InfoMoneyId
                 )

         -- !!! - 01 - по партиям для Общефирменные
       , tmp_01 AS (-- 1. для zc_ContainerLinkObject_Unit
                  /*SELECT Container.Id                                          AS ContainerId
                         , tmpMI.GoodsId                                         AS GoodsId
                         , 0                                                     AS GoodsKindId
                         , Container.Amount                                      AS Amount
                         , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                         , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                         , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                    FROM tmpMI_summ AS tmpMI
                         INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                             AND Container.DescId   = zc_Container_Count()
                                             -- есть остаток
                                             AND Container.Amount   > 0
                                             --
                                             AND vbIsPartionCell_from = FALSE
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                       AND CLO_Unit.ObjectId    = vbUnitId_from -- (SELECT DISTINCT tmpMI.UnitId_From FROM tmpMI WHERE tmpMI.UnitId_From <> 0)
                                                       AND vbUnitId_from > 0
                         -- !!!
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                       ON CLO_PartionGoods.ContainerId = Container.Id
                                                      AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                 AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                         LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                                                AND Object_PartionGoods.ValueData <> '0'
                    -- учет - по партиям
                    WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                         , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                         , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                          )
                   UNION ALL*/
                    -- 2. для zc_ContainerLinkObject_Member
                    SELECT Container.Id                                          AS ContainerId
                         , tmpMI.GoodsId                                         AS GoodsId
                         , 0                                                     AS GoodsKindId
                         , Container.Amount                                      AS Amount
                         , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                         , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                         , COALESCE (Object_PartionGoods.ValueData, '')          AS PartionGoods
                    FROM tmpMI_summ AS tmpMI
                         INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                             AND Container.DescId   = zc_Container_Count()
                                             -- есть остаток
                                             AND Container.Amount   > 0
                                             --
                                             AND vbIsPartionCell_from = FALSE
                         INNER JOIN ContainerLinkObject AS CLO_Member
                                                        ON CLO_Member.ContainerId = Container.Id
                                                       AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                                                                                  -- !!!была ошибка в проводках!!!
                                                       AND CLO_Member.ObjectId    = vbMemberId_From
                                                       AND vbMemberId_From        > 0
                         -- !!!
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                       ON CLO_PartionGoods.ContainerId = Container.Id
                                                      AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                 AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                         LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                                                AND Object_PartionGoods.ValueData <> '0'
                    -- учет - по партиям
                    WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                         , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                         , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                          )
                     -- !!! временно, неправильно работает для РК!!!
                     -- AND vbIsPartionCell_from = FALSE
                    )

     -- Вернем остатки ПАРТИЙ, если их списали в следующем месяце
   , tmpContainer_rem_sale AS (SELECT Container.Id AS ContainerId
                                      -- добавятся расходы
                                    , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount_rem

                                    , COALESCE (CLO_PartionGoods.ObjectId, 0)               AS PartionGoodsId
                                    , CASE WHEN ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()
                                           -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                                           THEN zc_DateStart()
                                           ELSE COALESCE (ObjectDate_Value.ValueData, zc_DateStart())
                                      END AS PartionGoodsDate

                                    , tmpMI.GoodsId
                                    , tmpMI.GoodsKindId

                               FROM tmpMI_summ AS tmpMI
                                    INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                        AND Container.DescId   = zc_Container_Count()
                                                        -- !!!если их списали!!!
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
                                     -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                                     LEFT JOIN ObjectLink AS ObjectLink_PartionCell ON ObjectLink_PartionCell.ObjectId = CLO_PartionGoods.ObjectId
                                                                                   AND ObjectLink_PartionCell.DescId   = zc_ObjectLink_PartionGoods_PartionCell()

                                    INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = Container.Id
                                                                    -- !!!следующий месяц
                                                                    AND MIContainer.OperDate       >= DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                                                                    -- !!!все
                                                                  --AND MIContainer.MovementDescId = zc_Movement_Inventory()
                               -- учет - партии по датам
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
                                 --!!!не пустая партия!!!
                                 AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)

                               GROUP BY Container.Id, Container.Amount
                                      , COALESCE (CLO_PartionGoods.ObjectId, 0)
                                      , CASE WHEN ObjectLink_PartionCell.ChildObjectId = zc_PartionCell_RK()
                                             -- если zc_PartionCell_RK, списываем партию - ПЕРВОЙ
                                             THEN zc_DateStart()
                                             ELSE COALESCE (ObjectDate_Value.ValueData, zc_DateStart())
                                        END
                                      , tmpMI.GoodsId
                                      , tmpMI.GoodsKindId

                               --HAVING SUM (COALESCE (MIContainer.Amount, 0)) <> 0
                               -- !!!
                               HAVING Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) > 0
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
                                             -- есть остаток
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
                      --!!!не пустая партия!!!
                      AND COALESCE (CLO_PartionGoods.ObjectId, -1) NOT IN (80132, 0)

                   UNION ALL
                    -- Добавили ПАРТИИ, если их списали в следующем месяце
                    SELECT tmpContainer_rem_sale.ContainerId                     AS ContainerId
                         , tmpMI.GoodsId                                         AS GoodsId
                         , tmpMI.GoodsKindId                                     AS GoodsKindId
                         , tmpContainer_rem_sale.Amount_rem                      AS Amount
                         , tmpContainer_rem_sale.PartionGoodsId                  AS PartionGoodsId
                         , tmpContainer_rem_sale.PartionGoodsDate                AS PartionGoodsDate
                    FROM tmpMI_summ AS tmpMI
                         INNER JOIN tmpContainer_rem_sale ON tmpContainer_rem_sale.GoodsId     = tmpMI.GoodsId
                                                         AND tmpContainer_rem_sale.GoodsKindId = tmpMI.GoodsKindId
                   )

         -- !!! - 03 - учет для ГП - партии по датам
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
                                             -- НЕТ остатка
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
  , tmpContainer_list AS (-- по партиям для Общефирменные
                          SELECT tmp_01.ContainerId
                               , tmp_01.GoodsId
                               , tmp_01.GoodsKindId
                               , tmp_01.Amount
                               , tmp_01.PartionGoodsId
                               , tmp_01.PartionGoodsDate
                               , tmp_01.PartionGoods
                          FROM tmp_01

                         UNION ALL
                          -- учет для ГП - партии по датам + ячейки
                          SELECT tmp_02.ContainerId
                               , tmp_02.GoodsId
                               , tmp_02.GoodsKindId
                               , tmp_02.Amount
                               , tmp_02.PartionGoodsId
                               , tmp_02.PartionGoodsDate
                               , '' AS PartionGoods
                          FROM tmp_02

                         UNION ALL
                          -- учет для ГП - партии по датам + ячейки
                          SELECT tmp_03.ContainerId
                               , tmp_03.GoodsId
                               , tmp_03.GoodsKindId
                               , 0.01 AS Amount
                               , tmp_03.PartionGoodsId
                               , tmp_03.PartionGoodsDate
                               , '' AS PartionGoods
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
                            , Container.ContainerId
                              -- Кол-во
                            , tmpMI.OperCount  AS Amount
                              -- Остаток + без учета Инвентаризации для ГП
                            , Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) AS Amount_container
                              -- накопительно
                            , SUM (Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0))
                                                      OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                            ORDER BY CASE WHEN Container.PartionGoodsId > 0 THEN 0 ELSE 1 END
                                                                   , CASE WHEN Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END
                                                                   , CASE WHEN Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END
                                                                   , COALESCE (Container.PartionGoodsDate, zc_DateStart()) ASC
                                                                   , Container.ContainerId ASC
                                                           ) AS AmountSUM
                              -- !!!Надо отловить ПОСЛЕДНИЙ!!!
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId
                                                 ORDER BY CASE WHEN Container.PartionGoodsId > 0 THEN 0 ELSE 1 END DESC
                                                        , CASE WHEN Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) > 0 THEN 0 ELSE 1 END DESC
                                                        , CASE WHEN Container.Amount + COALESCE (tmpContainer_rem_RK.Amount_invent, 0) < 0 THEN 0 ELSE 1 END DESC
                                                        , COALESCE (Container.PartionGoodsDate, zc_DateStart()) DESC
                                                        , Container.ContainerId DESC
                                                ) AS Ord
                              -- партия
                            , Container.PartionGoodsId

                       FROM tmpMI_summ AS tmpMI
                            INNER JOIN tmpContainer_list AS Container
                                                         ON Container.GoodsId     = tmpMI.GoodsId
                                                        AND Container.GoodsKindId = tmpMI.GoodsKindId
                            LEFT JOIN tmpContainer_rem_RK ON tmpContainer_rem_RK.ContainerId = Container.ContainerId
                      )
      -- итого кол-во разбили по партиям
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
      -- получили накопительные суммы - Партии результат
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
      -- накопительные периоды - Партии результат
    , tmpContainer_group AS (SELECT tmpContainer.ContainerId
                                  , tmpContainer.GoodsId
                                  , tmpContainer.GoodsKindId
                                  , tmpContainer.PartionGoodsId
                                  , tmpContainer.Amount
                                  , tmpContainer.AmountSUM
                                  , tmpContainer.Ord
                                    -- с минимального
                                  , COALESCE (tmpContainer_old.AmountSUM, 0) AS Amount_min

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
                      FROM tmpMI_all AS tmpMI
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

                                 -- только если партию НЕ нашли
                                 /*LEFT JOIN tmpContainer_list ON tmpContainer_list.GoodsId      = tmpMI_summ.GoodsId
                                                            AND tmpContainer_list.PartionGoods = tmpMI_summ.PartionGoods
                                                            AND tmpContainer_list.Amount       > 0
                                                            -- партия установлена
                                                            AND tmpContainer_list.PartionGoods <> ''*/

                            WHERE tmpMI_summ.OperCount > 0
                              -- только если партию НЕ нашли
                              -- AND tmpContainer_list.ContainerId IS NULL
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


      -- партии прикрутили к MI для OperCount_ChangePercent + OperCount_Partner
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

                              -- № п/п - для корректировки разницы для OperCount_ChangePercent + OperCount_Partner
                            , ROW_NUMBER() OVER (PARTITION BY tmpMI_group.MovementItemId ORDER BY tmpMI_group.Amount DESC) AS Ord_amount

                      FROM tmpContainer_res_2 AS tmpMI_group
                           LEFT JOIN tmpMI_all AS tmpMI ON tmpMI.MovementItemId = tmpMI_group.MovementItemId
                     )

      -- итого надо скорректировать на погрешность для OperCount_ChangePercent + OperCount_Partner
    , tmpContainer_diff AS (SELECT tmpContainer.MovementItemId
                                 , tmpMI.OperCount_ChangePercent - SUM (tmpContainer.OperCount_ChangePercent) AS OperCount_ChangePercent
                                 , tmpMI.OperCount_Partner       - SUM (tmpContainer.OperCount_Partner)       AS OperCount_Partner
                          FROM tmpMI_all AS tmpMI
                               JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMI.MovementItemId
                          GROUP BY tmpContainer.MovementItemId, tmpMI.OperCount_ChangePercent, tmpMI.OperCount_Partner
                          HAVING SUM (tmpContainer.OperCount_ChangePercent) <> tmpMI.OperCount_ChangePercent
                              OR SUM (tmpContainer.OperCount_Partner)       <> tmpMI.OperCount_Partner
                         )
        -- Результат - суммы и скидка если надо
        SELECT
              _tmp.MovementItemId

              -- !!!или подбор партий!!!
            , _tmp.ContainerId_Goods AS ContainerId_Goods
            , 0 AS ContainerId_Count
            , 0 AS ContainerId_GoodsPartner

            , 0 AS ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
            , 0 AS ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
            , 0 AS ContainerId_GoodsTransit_53 -- Счет - кол-во Транзит

            , _tmp.ObjectDescId
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId

            , _tmp.PartionGoods
-- test
-- , (select  STRING_AGG (tmpContainer_partion.Amount :: TVarChar ';') from tmpContainer_partion where tmpContainer_partion.GoodsId = 2143 and tmpContainer_partion.GoodsKindId = 8344 ) AS PartionGoods

            , _tmp.PartionGoodsDate
            , _tmp.ChangePercent
            , _tmp.isChangePrice

              -- количество с остатка
            , _tmp.OperCount
            , _tmp.OperCountCount
              -- количество с учетом % скидки
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_ChangePercent
              END AS OperCount_ChangePercent
              -- количество у контрагента
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_Partner
              END AS OperCount_Partner

-- select * from Container where Id =  14821898
-- select * from MovementItemContainer where ContainerId =14821898 order by OperDate desc
-- MovementItemId = 353628530
-- Container = 2840782
-- , (select sum (tmpContainer_all.Amount) from tmpContainer_all where tmpContainer_all.GoodsId = 4597070   and tmpContainer_all.GoodsKindId = 8348 ) AS tmpOperSumm_PriceList
--, (select count(*) from tmpContainer_rem_sale where tmpContainer_rem_sale.ContainerId = 14821898) AS OperSumm_PriceList

              -- промежуточная (в ценах док-та) сумма прайс-листа по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_PriceList
              -- конечная сумма прайс-листа по Контрагенту !!! без скидки !!!
            , CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_PriceList
                   WHEN vbVATPercent_PriceList > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList AS NUMERIC (16, 2))
              END AS OperSumm_PriceList

              -- промежуточная (в ценах док-та) сумма СПЕЦ. прайс-листа по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_PriceListJur
              -- конечная сумма СПЕЦ. прайс-листа по Контрагенту !!! без скидки !!!
            , CASE WHEN vbPriceWithVAT_PriceListJur OR vbVATPercent_PriceListJur = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_PriceListJur
                   WHEN vbVATPercent_PriceListJur > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent_PriceListJur / 100) * _tmp.tmpOperSumm_PriceListJur AS NUMERIC (16, 2))
              END AS OperSumm_PriceListJur

              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner
              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!без скидки!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_Partner_original
              -- промежуточная (в ценах док-та) сумма для кол-во с уч. %ск.вес !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков
            , _tmp.tmpOperSumm_PartnerVirt
              -- промежуточная (в ценах док-та) сумма по Контрагенту !!!почти без скидки(т.е. учтена если надо)!!! - с округлением до 2-х знаков !!!в валюте!!!
            , _tmp.tmpOperSumm_Partner_Currency


              -- конечная сумма по Контрагенту !!!без скидки!!!
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE  OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда ничего не делаем
                      THEN _tmp.tmpOperSumm_Partner_original
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда получаем сумму с НДС
                      THEN CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
              END   -- так переводится в валюту zc_Enum_Currency_Basis
                  -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_Partner -- !!!результат!!!


              -- конечная сумма по Контрагенту
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END   -- так переводится в валюту zc_Enum_Currency_Basis
                  -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_Partner_ChangePercent  -- !!!результат!!!


              -- конечная сумма по Контрагенту - для кол-во с уч. %ск.вес
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_PartnerVirt
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_PartnerVirt) AS NUMERIC (16, 2))
                           END
              END   -- так переводится в валюту zc_Enum_Currency_Basis
                  -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
              AS NUMERIC (16, 2)) AS OperSumm_PartnerVirt_ChangePercent -- !!!результат!!!


              -- конечная сумма в валюте по Контрагенту
            , CAST
             (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner_Currency
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner_Currency) AS NUMERIC (16, 2))
                           END
              END   -- так переводится в валюту CurrencyPartnerId
                  * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
              AS NUMERIC (16, 2)) AS OperSumm_Currency -- !!!результат!!!

              -- сумма Скидка Акция
            , 0 AS OperSumm_Partner_ChangePromo
              -- сумма
            , 0 AS OperSumm_80103

              -- Счет - прибыль (ОПиУ - Сумма реализации)
            , 0 AS ContainerId_ProfitLoss_10100
              -- Счет - прибыль (ОПиУ - Разница с оптовыми ценами)
            , 0 AS ContainerId_ProfitLoss_10200
              -- Счет - прибыль (ОПиУ - Скидка Акция)
            , 0 AS ContainerId_ProfitLoss_10250
              -- Счет - прибыль (ОПиУ - Скидка дополнительная)
            , 0 AS ContainerId_ProfitLoss_10300
              -- Счет - прибыль (ОПиУ - Курсовая разница)
            , 0 AS ContainerId_ProfitLoss_80103

              -- Счет - долг Контрагента
            , 0 AS ContainerId_Partner
              -- Счет - долг Контрагента в валюте
            , 0 AS ContainerId_Currency
              -- Счет(справочника) Контрагента
            , 0 AS AccountId_Partner
              -- Управленческая группа
            , _tmp.InfoMoneyGroupId
              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

              -- значение Бизнес !!!выбирается!!!: 1) покупатель (для павильонов)  2) Товар 3) Подраделение/Сотрудник
            , CASE WHEN vbBusinessId_To <> 0 THEN vbBusinessId_To WHEN _tmp.BusinessId_From = 0 THEN vbBusinessId_From ELSE _tmp.BusinessId_From END AS BusinessId_From

            , _tmp.isPartionCount
            , _tmp.isPartionSumm

              -- Возвратная ли это тара (если да, себестоимость остается на остатке)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- Списание Прочее сырье ли это (если да, то в проводках будет zc_Enum_AnalyzerId_Loss...)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20600() -- 10200; "Прочее сырье"
                        THEN TRUE
                   ELSE FALSE
              END AS isLossMaterials
              -- Списание Прочее сырье ли это (если да, то в проводках будет zc_Enum_AnalyzerId_Loss...)
            , CASE WHEN _tmp.MovementId_promo > 0
                        THEN TRUE
                   ELSE FALSE
              END AS isPromo

              -- Партии товара, сформируем позже - !!!или подбор партий!!!
            , _tmp.PartionGoodsId_Item AS PartionGoodsId


            , _tmp.PriceListPrice
            , _tmp.PriceListJurPrice
            , _tmp.Price
            , _tmp.Price_Currency
            , _tmp.Price_original
            , _tmp.CountForPrice

            , _tmp.OperCount_start
            , _tmp.OperCountCount_start
            , _tmp.OperCount_ChangePercent_start
            , _tmp.OperCount_Partner_start

        FROM
             (-- расчет суммы по элементам + их округление до 2-х знаков (скидка если надо - будет расчитана выше)
              SELECT
                    tmpMI.MovementItemId
                  , Object_Goods.DescId AS ObjectDescId
                  , tmpMI.GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                              THEN tmpMI.GoodsKindId

                         WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_30102()) -- Тушенка
                          AND tmpMI.GoodsKindId <> zc_GoodsKind_Basis()
                              THEN tmpMI.GoodsKindId

                         WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                              THEN tmpMI.GoodsKindId
                         ELSE 0
                    END AS GoodsKindId
                  , tmpMI.AssetId
                  , tmpMI.PartionGoods
                  , tmpMI.PartionGoodsDate
                  , tmpMI.ChangePercent
                  , tmpMI.isChangePrice
                  , tmpMI.MovementId_promo

                  , COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS PriceListPrice
                  , COALESCE (tmpPL_Jur_kind.PriceListPrice, tmpPL_Jur.PriceListPrice, 0)     AS PriceListJurPrice
                  , tmpMI.Price
                  , tmpMI.Price_original
                  , tmpMI.Price_Currency
                  , tmpMI.CountForPrice
                    -- количество для склада
                  , tmpMI.OperCount
                  , tmpMI.OperCountCount
                    -- количество с учетом % скидки
                  , tmpMI.OperCount_ChangePercent
                    -- количество у контрагента
                  , tmpMI.OperCount_Partner

                    -- промежуточная сумма прайс-листа по Контрагенту - с округлением до 2-х знаков
                  , COALESCE (CAST (tmpMI.OperCount_Partner * COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList
                    -- промежуточная сумма СПЕЦ. прайс-листа по Контрагенту - с округлением до 2-х знаков
                  , COALESCE (CAST (tmpMI.OperCount_Partner * COALESCE (tmpPL_Jur_kind.PriceListPrice, tmpPL_Jur.PriceListPrice, 0)     AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceListJur

                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner
                    -- промежуточная сумма для кол-во с уч. %ск.вес - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_ChangePercent * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_ChangePercent * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_PartnerVirt

                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + учтена скидка в цене (!!!если надо!!!) !!!в валюте!!!
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_Currency AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_Currency
                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков + !!!НЕ!!! учтена скидка в цене
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_original AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_original

                    -- Управленческая группа
                  , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                    -- Управленческие назначения
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- Статьи назначения
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- Бизнес из Товара
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_From

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

                    -- !!!или подбор партий!!!
                  , tmpMI.ContainerId_Goods
                    -- !!!или подбор партий!!!
                  , tmpMI.PartionGoodsId_Item

                  , tmpMI.OperCount_start
                  , tmpMI.OperCountCount_start
                  , tmpMI.OperCount_ChangePercent_start
                  , tmpMI.OperCount_Partner_start

              FROM (-- перевод цены в валюту zc_Enum_Currency_Basis
                    SELECT tmpMI.MovementItemId
                         , tmpMI.ContainerId_asset
                         , tmpMI.GoodsId
                         , tmpMI.GoodsKindId
                         , tmpMI.AssetId
                         , tmpMI.PartionGoods
                         , tmpMI.PartionGoodsDate
                         , tmpMI.ChangePercent
                         , tmpMI.isChangePrice
                         , tmpMI.MovementId_promo

                         , tmpMI.OperCount
                         , tmpMI.OperCountCount
                         , tmpMI.OperCount_ChangePercent
                         , tmpMI.OperCount_Partner

                         , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                     -- так переводится в валюту zc_Enum_Currency_Basis
                                     THEN CAST (tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                ELSE tmpMI.Price
                           END AS Price
                         , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                     -- так переводится в валюту zc_Enum_Currency_Basis
                                     THEN CAST (tmpMI.Price_original * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                ELSE tmpMI.Price_original
                           END AS Price_original
                         , tmpMI.Price AS Price_Currency

                         , tmpMI.CountForPrice

                           -- !!!или подбор партий!!!
                         , tmpMI.ContainerId_Goods
                           -- !!!или подбор партий!!!
                         , tmpMI.PartionGoodsId_Item

                         , tmpMI.OperCount_start
                         , tmpMI.OperCountCount_start
                         , tmpMI.OperCount_ChangePercent_start
                         , tmpMI.OperCount_Partner_start

                    FROM (-- расчет цены с учетом скидки !!!"иногда"!!!
                          SELECT tmpMI_all.MovementItemId
                               , tmpMI_all.ContainerId_asset
                               , tmpMI_all.GoodsId
                               , tmpMI_all.GoodsKindId
                               , tmpMI_all.AssetId
                               , tmpMI_all.PartionGoods
                               , tmpMI_all.PartionGoodsDate
                               , tmpMI_all.ChangePercent
                               , COALESCE (tmpChangePrice.isChangePrice, FALSE) AS isChangePrice
                               , tmpMI_all.MovementId_promo

                               , tmpMI_all.OperCount               AS OperCount_start
                               , tmpMI_all.OperCountCount          AS OperCountCount_start
                               , tmpMI_all.OperCount_ChangePercent AS OperCount_ChangePercent_start
                               , tmpMI_all.OperCount_Partner       AS OperCount_Partner_start

                                 -- !!!или подбор партий!!!
                               , COALESCE (tmpContainer.Amount, tmpMI_all.OperCount)               AS OperCount
                               , CASE WHEN COALESCE (tmpContainer.Ord, 1) = 1 THEN tmpMI_all.OperCountCount ELSE 0 END AS OperCountCount
                               , COALESCE (tmpContainer.OperCount_ChangePercent, tmpMI_all.OperCount_ChangePercent) + COALESCE (tmpContainer_diff.OperCount_ChangePercent, 0) AS OperCount_ChangePercent
                               , COALESCE (tmpContainer.OperCount_Partner,       tmpMI_all.OperCount_Partner)       + COALESCE (tmpContainer_diff.OperCount_Partner,       0) AS OperCount_Partner

                               , CASE WHEN tmpChangePrice.isChangePrice = TRUE AND tmpMI_all.ChangePercent <> 0 -- !!!для НАЛ "иногда" не учитываем, для БН - всегда учитываем!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= tmpMI_all.ChangePercent
                                                                    , inPrice        := tmpMI_all.Price_original
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      ELSE tmpMI_all.Price_original
                                 END AS Price
                               , tmpMI_all.Price_original
                               , tmpMI_all.CountForPrice

                                 -- !!!или подбор партий - ContainerId_Goods !!!
                               , CASE WHEN vbMovementDescId = zc_Movement_SaleAsset() THEN tmpMI_all.ContainerId_asset    ELSE COALESCE (tmpContainer.ContainerId, 0)    END AS ContainerId_Goods
                                 -- !!!или подбор партий - PartionGoodsId_Item !!!
                               , CASE WHEN vbMovementDescId = zc_Movement_SaleAsset() THEN tmpMI_all.PartionGoodsId_asset ELSE COALESCE (tmpContainer.PartionGoodsId, 0) END AS PartionGoodsId_Item

                          FROM tmpMI_all
                               LEFT JOIN tmpChangePrice ON tmpChangePrice.isChangePrice = TRUE
                               LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMI_all.MovementItemId
                               LEFT JOIN tmpContainer_diff ON tmpContainer_diff.MovementItemId = tmpMI_all.MovementItemId
                                                          -- только одну позицию корректируем
                                                          AND tmpContainer.Ord_amount = 1

                         ) AS tmpMI
                   ) AS tmpMI

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = tmpMI.GoodsId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = tmpMI.GoodsId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

                   LEFT JOIN tmpContainer_asset ON tmpContainer_asset.ContainerId_asset = tmpMI.ContainerId_asset
                                               AND tmpContainer_asset.Ord               = 1

                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                   ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                       THEN -- !!!временно захардкодил!!! - Капитальные инвестиции + Производственное оборудование
                                                                                                            COALESCE (tmpContainer_asset.InfoMoneyId, zc_Enum_InfoMoney_70102())
                                                                                                  ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                             END
                   -- привязываем цены 2 раза по виду и без
                   LEFT JOIN tmpPL_Basis AS tmpPL_Basis_kind
                                         ON tmpPL_Basis_kind.GoodsId                   = tmpMI.GoodsId
                                        AND COALESCE (tmpPL_Basis_kind.GoodsKindId, 0) = COALESCE (tmpMI.GoodsKindId, 0)
                                        AND tmpPL_Basis_kind.PriceListPrice            <> 0
                   LEFT JOIN tmpPL_Basis ON tmpPL_Basis.GoodsId     = tmpMI.GoodsId
                                        AND tmpPL_Basis.GoodsKindId IS NULL

                   -- привязываем цены 2 раза по виду и без
                   LEFT JOIN tmpPL_Jur AS tmpPL_Jur_kind
                                       ON tmpPL_Jur_kind.GoodsId                  = tmpMI.GoodsId
                                      AND COALESCE (tmpPL_Jur_kind.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)
                                      AND tmpPL_Jur_kind.PriceListPrice           <> 0
                   LEFT JOIN tmpPL_Jur ON tmpPL_Jur.GoodsId     = tmpMI.GoodsId
                                      AND tmpPL_Jur.GoodsKindId IS NULL
             ) AS _tmp
            ;

     -- !!!надо определить - есть ли скидка в цене!!!
     vbIsChangePrice:= (SELECT _tmpItem.isChangePrice FROM _tmpItem LIMIT 1);

/*
 -- тест
  RAISE EXCEPTION 'Ошибка. <%>  <%>  <%>  <%>    <%>  <%>  '
, (select sum (_tmpItem.OperCount) from _tmpItem where _tmpItem.MovementItemId = 353628530  )
, (select _tmpItem.ContainerId_Goods from _tmpItem where _tmpItem.MovementItemId = 353628530 )
, (select _tmpItem.PartionGoods from _tmpItem where _tmpItem.MovementItemId = 353628530 )
, (select _tmpItem.PartionGoodsId_Item from _tmpItem where _tmpItem.MovementItemId = 353628530 )
, (select _tmpItem.tmpOperSumm_PriceList from _tmpItem where _tmpItem.MovementItemId = 353628530 )
, (select _tmpItem.OperSumm_PriceList from _tmpItem where _tmpItem.MovementItemId = 353628530 )
  ;
*/
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
                         -- GoodsKindId
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
                               , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                               , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                               , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start
                          FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                              , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                FROM _tmpItem
                                WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                         )
                                  -- только если был ?подбор?
                                  AND _tmpItem.OperCount_start <> 0
                               ) AS tmpItem_start
                          GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                         ) AS tmpItem_start
                         FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         , SUM (_tmpItem.OperCount)               AS OperCount
                                         , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                         , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                         , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                    FROM _tmpItem
                                    WHERE _tmpItem.ContainerId_Goods > 0
                                      -- только если был ?подбор?
                                      AND _tmpItem.OperCount <> 0
                                    GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                   ) AS tmpItem
                                     ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                    AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                    WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                       OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
                       OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                       OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                   )
        AND inUserId IN (5, zc_Enum_Process_Auto_PrimeCost() :: Integer)
        --AND inUserId <> 5
        --AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Подбор партий.% % № <%> от <%> %Товар = <%> %Вид = <%> %Кол-во = <%> %Кол-во по партиям = <%> %Кол.Пок = <%> %Кол.Пок по партиям = <%> %Id = <%>'
                       , CHR (13)
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR (13)
                         -- GoodsId
                       , (SELECT lfGet_Object_ValueData (tmpItem_start.GoodsId) || ' (' || tmpItem_start.GoodsId :: TVarChar || ') ' || ' (' || tmpItem_start.MovementItemId :: TVarChar || ')'
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start
                                     , MAX (tmpItem_start.MovementItemId)                AS MovementItemId

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                               , MAX (_tmpItem.MovementItemId)          AS MovementItemId
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- GoodsKindId
                       , (SELECT lfGet_Object_ValueData_sh (tmpItem_start.GoodsKindId) || ' (' || tmpItem_start.GoodsKindId :: TVarChar || ')'
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
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
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
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
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 2.1. OperCount_Partner_start
                       , (SELECT zfConvert_FloatToString (tmpItem_start.OperCount_Partner_start)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- 2.2. OperCount - calc
                       , (SELECT zfConvert_FloatToString (tmpItem.OperCount_Partner)
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                       , CHR (13)
                         -- MovementItemId
                       , (SELECT COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId) :: TVarChar || ' - ' || COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId) :: TVarChar
                          FROM (SELECT tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                                     , SUM (tmpItem_start.OperCount_start)               AS OperCount_start
                                     , SUM (tmpItem_start.OperCountCount_start)          AS OperCountCount_start
                                     , SUM (tmpItem_start.OperCount_ChangePercent_start) AS OperCount_ChangePercent_start
                                     , SUM (tmpItem_start.OperCount_Partner_start)       AS OperCount_Partner_start

                                FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                                    , _tmpItem.OperCount_start, _tmpItem.OperCountCount_start, _tmpItem.OperCount_ChangePercent_start, _tmpItem.OperCount_Partner_start
                                      FROM _tmpItem
                                      WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                              , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                               )
                                        -- только если был ?подбор?
                                        AND _tmpItem.OperCount_start <> 0
                                     ) AS tmpItem_start
                                GROUP BY tmpItem_start.GoodsId, tmpItem_start.GoodsKindId
                               ) AS tmpItem_start
                               FULL JOIN (SELECT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                               , SUM (_tmpItem.OperCount)               AS OperCount
                                               , SUM (_tmpItem.OperCountCount)          AS OperCountCount
                                               , SUM (_tmpItem.OperCount_ChangePercent) AS OperCount_ChangePercent
                                               , SUM (_tmpItem.OperCount_Partner)       AS OperCount_Partner
                                          FROM _tmpItem
                                          WHERE _tmpItem.ContainerId_Goods > 0
                                            -- только если был ?подбор?
                                            AND _tmpItem.OperCount <> 0
                                          GROUP BY _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                         ) AS tmpItem
                                           ON tmpItem.GoodsId     = tmpItem_start.GoodsId
                                          AND tmpItem.GoodsKindId = tmpItem_start.GoodsKindId
                          WHERE COALESCE (tmpItem_start.OperCount_start, 0)                <> COALESCE (tmpItem.OperCount, 0)
                             OR COALESCE (tmpItem_start.OperCountCount_start, 0)           <> COALESCE (tmpItem.OperCountCount, 0)
                             OR COALESCE (tmpItem_start.OperCount_ChangePercent_start, 0)  <> COALESCE (tmpItem.OperCount_ChangePercent, 0)
                             OR COALESCE (tmpItem_start.OperCount_Partner_start, 0)        <> COALESCE (tmpItem.OperCount_Partner, 0)
                          ORDER BY COALESCE (tmpItem_start.GoodsId, tmpItem.GoodsId)
                                 , COALESCE (tmpItem_start.GoodsKindId, tmpItem.GoodsKindId)
                          LIMIT 1
                         )
                        ;
     END IF;


     -- Проверка - RK + Склад Неликвид
     IF vbUnitId_From IN (zc_Unit_RK(), 9558031) AND COALESCE (vbMovementId_Order, 0) = 0
    AND vbMovementDescId <> zc_Movement_SaleAsset()
    AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
    AND inUserId <> 5
    AND vbUserId_save > 0
    AND EXISTS (SELECT 1
                FROM _tmpItem
                WHERE -- isTareReturning
                      _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                      -- Списание Прочее сырье ли это (если да, то в проводках будет zc_Enum_AnalyzerId_Loss...)
                  AND _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20600() -- 10200; "Прочее сырье"
                --
                --AND _tmpItem.tmpOperSumm_PriceList > 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка.%Нет прав формировать документ <Продажа покупателю>.%Не указано основание - <Заявка от покупателя>.', CHR (13), CHR (13);
     END IF;


     -- Проверка - для ОС
     IF vbMovementDescId = zc_Movement_SaleAsset()
        AND EXISTS (SELECT 1
                    FROM _tmpItem
                    WHERE COALESCE (_tmpItem.ContainerId_Goods, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId, 0) = 0
                   )
     THEN
          RAISE EXCEPTION 'Ошибка.Для ОС <%> должна быть указана партия.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.GoodsId
                                                      FROM _tmpItem
                                                      WHERE COALESCE (_tmpItem.ContainerId_Goods, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId, 0) = 0
                                                      LIMIT 1
                                                     ))
                                                     ;
     END IF;

     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE COALESCE (_tmpItem.GoodsId, 0) = 0)
     THEN
          RAISE EXCEPTION 'Ошибка.Не заполнен парамет <Товар>.';
     END IF;

     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE))
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;

     -- проверка - цена = 0
     vbMovementItemId_check:= (SELECT MIN (_tmpItem.MovementItemId)
                               FROM _tmpItem
                               WHERE _tmpItem.OperCount_Partner > 0
                               --AND _tmpItem.OperSumm_Partner  = 0
                                 AND _tmpItem.Price_original    = 0
                                 AND vbMovementDescId <> zc_Movement_SaleAsset()
                                 AND _tmpItem.InfoMoneyDestinationId NOT IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                           , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                           , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                           , zc_Enum_InfoMoneyDestination_30500() -- Прочие доходы
                                                                            ));
     --
     IF vbMovementItemId_check > 0 AND 1=1 -- AND inUserId = 5
        AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND vbIsCorporate_To = FALSE
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

     -- кроме Админа
     IF inUserId <> zfCalc_UserAdmin() :: Integer OR 1=0
     THEN
         -- !!!Синхронно - пересчитали/провели Пересортица!!! - на основании "Реализация" - !!!важно - здесь очищается _tmpMIContainer_insert, поэтому делаем ДО проводок!!!, но после заполнения _tmpItem
         PERFORM lpComplete_Movement_Sale_Recalc (inMovementId := inMovementId
                                                , inUnitId     := vbUnitId_From
                                                , inUserId     := inUserId
                                                 );
     END IF;


     -- !!!Пересчет цен - ТАРА!!!!
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE) -- Оборотная тара
     THEN
         -- Сохранили Цены
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTare(), tmp.MovementItemId, tmp.OperPrice)
         FROM (WITH tmpPrice AS (SELECT tmpGoods.GoodsId
                                      , COALESCE (ObjectLink_PriceListItem_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                      , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS OperPrice
                                 FROM (SELECT DISTINCT _tmpItem.GoodsId
                                       FROM _tmpItem
                                       WHERE _tmpItem.isTareReturning = TRUE
                                      ) AS tmpGoods
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                            ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                      INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                            ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                           AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                           AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                      LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                           ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                          AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                      INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                              AND vbOperDate >= ObjectHistory_PriceListItem.StartDate AND vbOperDate < ObjectHistory_PriceListItem.EndDate
                                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                   ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                  AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                 WHERE ObjectHistoryFloat_PriceListItem_Value.ValueData > 0
                                )
               SELECT _tmpItem.MovementItemId, tmpPrice.OperPrice
               FROM _tmpItem
                    INNER JOIN tmpPrice ON tmpPrice.GoodsId = _tmpItem.GoodsId
              ) AS tmp;
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
            END AS OperSumm_PriceList


            -- Расчет Итоговой суммы прайс-листа по Контрагенту
          , CASE WHEN vbPriceWithVAT_PriceListJur OR vbVATPercent_PriceListJur = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_PriceListJur
                 WHEN vbVATPercent_PriceListJur > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent_PriceListJur / 100) * _tmpItem.tmpOperSumm_PriceListJur AS NUMERIC (16, 2))
            END AS OperSumm_PriceListJur


            -- Расчет Итоговой суммы по Контрагенту !!!без скидки!!!
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда ничего не делаем
                    THEN _tmpItem.tmpOperSumm_Partner_original
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда получаем сумму с НДС
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
            END   -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)
           )
            -- Корректировка суммы покупателя
          + vbCorrSumm
            -- !!!результат!!!
            AS OperSumm_Partner


            -- Расчет Итоговой суммы по Контрагенту
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END   -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)
           )
           -- Корректировка суммы покупателя
         + vbCorrSumm
           -- !!!результат!!!
           AS OperSumm_Partner_ChangePercent


            -- Расчет Итоговой суммы по Контрагенту - для кол-во с уч. %ск.вес
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_PartnerVirt
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_PartnerVirt AS NUMERIC (16, 2))
                         END
            END   -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)
           )
            -- Корректировка суммы покупателя
          + vbCorrSumm
            -- !!!результат!!!
            AS OperSumm_PartnerVirt_ChangePercent


            -- Расчет Итоговой суммы в валюте по Контрагенту
          , CAST
           (CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner_Currency
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" для НАЛ - скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_Currency AS NUMERIC (16, 2))
                         END
            END   -- так переводится в валюту CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue /  vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)
           )
             -- !!!результат!!!
            AS OperSumm_Currency

            INTO vbOperSumm_PriceList, vbOperSumm_PriceListJur, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent, vbOperSumm_PartnerVirt_ChangePercent, vbOperSumm_Currency
     FROM
           -- получили 1 запись
          (SELECT SUM (CASE WHEN vbOperDatePartner < lfGet_Object_Unit_PartionDate_isPartionCell() THEN _tmpItem.tmpOperSumm_PriceList    ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListPrice    AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceList
                , SUM (CASE WHEN vbOperDatePartner < lfGet_Object_Unit_PartionDate_isPartionCell() THEN _tmpItem.tmpOperSumm_PriceListJur ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListJurPrice AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceListJur

                , SUM (CASE WHEN vbOperDatePartner < lfGet_Object_Unit_PartionDate_isPartionCell() THEN _tmpItem.tmpOperSumm_Partner -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner

                , SUM (CASE WHEN vbOperDatePartner < lfGet_Object_Unit_PartionDate_isPartionCell() THEN _tmpItem.tmpOperSumm_PartnerVirt -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_ChangePercent * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_ChangePercent * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_PartnerVirt

                , SUM (CASE WHEN vbOperDatePartner < lfGet_Object_Unit_PartionDate_isPartionCell() THEN _tmpItem.tmpOperSumm_Partner_original -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_original

                , SUM (CASE WHEN vbOperDatePartner < lfGet_Object_Unit_PartionDate_isPartionCell() THEN _tmpItem.tmpOperSumm_Partner_Currency -- так получаем по каждому товару отдельно (даже если он повторяется)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_Currency / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_Currency AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_Currency

           FROM (SELECT _tmpItem.PriceListPrice
                      , _tmpItem.PriceListJurPrice
                      , _tmpItem.Price
                      , _tmpItem.Price_original
                      , _tmpItem.Price_Currency
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.OperCount_ChangePercent)  AS OperCount_ChangePercent
                      , SUM (_tmpItem.OperCount_Partner)        AS OperCount_Partner
                      , SUM (_tmpItem.tmpOperSumm_PriceList)    AS tmpOperSumm_PriceList
                      , SUM (_tmpItem.tmpOperSumm_PriceListJur) AS tmpOperSumm_PriceListJur
                      , SUM (_tmpItem.tmpOperSumm_Partner)      AS tmpOperSumm_Partner
                      , SUM (_tmpItem.tmpOperSumm_PartnerVirt)  AS tmpOperSumm_PartnerVirt
                      , SUM (_tmpItem.tmpOperSumm_Partner_original) AS tmpOperSumm_Partner_original
                      , SUM (_tmpItem.tmpOperSumm_Partner_Currency) AS tmpOperSumm_Partner_Currency
                 FROM _tmpItem
                 GROUP BY _tmpItem.PriceListPrice
                        , _tmpItem.PriceListJurPrice
                        , _tmpItem.Price
                        , _tmpItem.Price_original
                        , _tmpItem.Price_Currency
                        , _tmpItem.CountForPrice
                        , _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                ) AS _tmpItem
          ) AS _tmpItem
    ;

     -- Захардкодили Суммы
     IF EXISTS (SELECT 1 FROM lpInsertUpdate_MovementFloat_TotalSumm_check_err() AS lp WHERE lp.MovementId = inMovementId)
     THEN
         SELECT lp.S2, lp.S2
               INTO vbOperSumm_Partner_ChangePercent, vbOperSumm_Partner
         FROM lpInsertUpdate_MovementFloat_TotalSumm_check_err() AS lp
         WHERE lp.MovementId = inMovementId;

     END IF;


     -- !!!меняется значение - переводится в валюту zc_Enum_Currency_Basis!!! - !!!нельзя что б переводился в строчной части!!!
     IF vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND vbParValue <> 0
     THEN
         vbOperSumm_Partner_ChangePercent:= CAST (vbOperSumm_Currency * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
         IF vbDiscountPercent = 0 AND vbExtraChargesPercent = 0
         THEN vbOperSumm_Partner:= vbOperSumm_Partner_ChangePercent;
         END IF;
     END IF;


     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_PriceListJur), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent), SUM (_tmpItem.OperSumm_PartnerVirt_ChangePercent), SUM (_tmpItem.OperSumm_Currency)
            INTO vbOperSumm_PriceList_byItem, vbOperSumm_PriceListJur_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem, vbOperSumm_PartnerVirt_ChangePercent_byItem, vbOperSumm_Currency_byItem
     FROM _tmpItem;

     -- если не равны ДВЕ Итоговые суммы прайс-листа по Контрагенту
     IF COALESCE (vbOperSumm_PriceList, 0) <> COALESCE (vbOperSumm_PriceList_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PriceList = _tmpItem.OperSumm_PriceList - (vbOperSumm_PriceList_byItem - vbOperSumm_PriceList)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceList DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceList DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы СПЕЦ. прайс-листа по Контрагенту
     IF COALESCE (vbOperSumm_PriceListJur, 0) <> COALESCE (vbOperSumm_PriceListJur_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PriceListJur = _tmpItem.OperSumm_PriceListJur - (vbOperSumm_PriceListJur_byItem - vbOperSumm_PriceListJur)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceListJur DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_PriceListJur DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы по Контрагенту !!!без скидки!!!
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner_ChangePercent, 0) <> COALESCE (vbOperSumm_Partner_ChangePercent_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner_ChangePercent = _tmpItem.OperSumm_Partner_ChangePercent - (vbOperSumm_Partner_ChangePercent_byItem - vbOperSumm_Partner_ChangePercent)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Partner_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы для кол-во с уч. %ск.вес
     IF COALESCE (vbOperSumm_PartnerVirt_ChangePercent, 0) <> COALESCE (vbOperSumm_PartnerVirt_ChangePercent_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_PartnerVirt_ChangePercent = _tmpItem.OperSumm_PartnerVirt_ChangePercent - (vbOperSumm_PartnerVirt_ChangePercent_byItem - vbOperSumm_PartnerVirt_ChangePercent)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_PartnerVirt_ChangePercent DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- если не равны ДВЕ Итоговые суммы в валюте по Контрагенту
     IF COALESCE (vbOperSumm_Currency, 0) <> COALESCE (vbOperSumm_Currency_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Currency = _tmpItem.OperSumm_Currency - (vbOperSumm_Currency_byItem - vbOperSumm_Currency)
         WHERE _tmpItem.MovementItemId    = (SELECT _tmpItem.MovementItemId    FROM _tmpItem ORDER BY _tmpItem.OperSumm_Currency DESC, _tmpItem.MovementItemId DESC LIMIT 1)
           AND _tmpItem.ContainerId_Goods = (SELECT _tmpItem.ContainerId_Goods FROM _tmpItem ORDER BY _tmpItem.OperSumm_Currency DESC, _tmpItem.MovementItemId DESC LIMIT 1);
     END IF;

     -- !!!правильный расчет суммы - Скидка Акция!!!
     UPDATE _tmpItem SET OperSumm_Partner_ChangePromo = CASE WHEN _tmpItem.isPromo = TRUE AND vbPriceListId_Jur <> 0
                                                                  THEN _tmpItem.OperSumm_PriceListJur - _tmpItem.OperSumm_Partner
                                                             WHEN _tmpItem.isPromo = TRUE
                                                                  THEN _tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner
                                                             ELSE 0
                                                        END;

     -- формируются Партии Спецодежда, ЕСЛИ указана + надо найти именно ее
     UPDATE _tmpItem SET PartionGoodsId = _tmpItem_find.PartionGoodsId
     FROM (WITH tmp_04 AS (SELECT _tmpItem.MovementItemId
                                , Container.Id                  AS ContainerId
                                , Container.Amount              AS Amount_container
                                , _tmpItem.GoodsId              AS GoodsId
                                , _tmpItem.GoodsKindId          AS GoodsKindId
                                , CLO_PartionGoods.ObjectId     AS PartionGoodsId
                           FROM _tmpItem
                                INNER JOIN Container ON Container.ObjectId = _tmpItem.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                    -- НЕТ ограничения
                                                    -- AND Container.Amount   > 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId    = vbUnitId_from
                                -- !!!
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = Container.Id
                                                             AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                INNER JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id        = CLO_PartionGoods.ObjectId
                                                                        --!!!Партия совпала!!!
                                                                        AND Object_PartionGoods.ValueData ILIKE _tmpItem.PartionGoods
                                -- без Товар в пути
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container.Id
                                                             AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()

                           WHERE _tmpItem.InfoMoneyId    = zc_Enum_InfoMoney_20202() -- Спецодежда
                             AND _tmpItem.PartionGoods   <> ''
                           --AND _tmpItem.PartionGoods   <> '0'
                             AND _tmpItem.PartionGoodsId = 0
                              -- без Товар в пути
                              AND CLO_Account.ObjectId IS NULL
                          )
          -- Остаток на дату
        , tmpContainer AS (SELECT tmp_04.ContainerId
                                , tmp_04.Amount_container - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_container
                           FROM (SELECT DISTINCT tmp_04.ContainerId, tmp_04.Amount_container FROM tmp_04
                                ) AS tmp_04
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = tmp_04.ContainerId
                                                               AND MIContainer.OperDate    >= vbOperDate
                           GROUP BY tmp_04.ContainerId
                                  , tmp_04.Amount_container
                          )
           -- Результат
           SELECT tmp_04.MovementItemId
                , tmp_04.ContainerId
                , tmp_04.GoodsId
                , tmp_04.GoodsKindId
                , tmp_04.PartionGoodsId
                  -- !!!Надо отловить ОДИН!!!
                , ROW_NUMBER() OVER (PARTITION BY tmp_04.MovementItemId
                                     ORDER BY tmpContainer.Amount_container DESC
                                    ) AS Ord
           FROM tmp_04
                INNER JOIN tmpContainer ON tmpContainer.ContainerId = tmp_04.ContainerId
                                       -- есть ограничение
                                       AND tmpContainer.Amount_container > 0
          ) AS _tmpItem_find
     WHERE _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202()
       AND _tmpItem.PartionGoods <> ''
     --AND _tmpItem.PartionGoods <> '0'
       AND _tmpItem.PartionGoodsId = 0
       AND _tmpItem.MovementItemId = _tmpItem_find.MovementItemId
       -- !!!Надо отловить ОДИН!!!
       AND _tmpItem_find.Ord = 1
      ;

     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbMovementDescId = zc_Movement_SaleAsset()
                                                    THEN _tmpItem.PartionGoodsId -- !!!Партию уже нашли!!!

                                               WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА

                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция

                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                    )
                                                 AND (_tmpItem.PartionGoodsId    > 0
                                                   OR _tmpItem.ContainerId_Goods > 0
                                                     )
                                                    THEN _tmpItem.PartionGoodsId

                                               -- Спецодежда
                                               WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20202() AND _tmpItem.PartionGoods <> '' AND _tmpItem.PartionGoods <> '0'
                                                    THEN lpInsertFind_Object_PartionGoods (inValue       := _tmpItem.PartionGoods
                                                                                         , inOperDate    := zc_DateStart()
                                                                                         , inInfoMoneyId := zc_Enum_InfoMoney_20202()
                                                                                          )

                                               WHEN _tmpItem.ObjectDescId     = zc_Object_Asset()
                                                 OR _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
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
                                                               LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                             ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                                          WHERE ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                            AND ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                                          ORDER BY CASE WHEN CLO_PartionGoods.ObjectId = ObjectLink_Goods.ObjectId AND CLO_Unit.ObjectId = vbUnitId_From AND Container.Amount > 0 THEN 1
                                                                        WHEN CLO_Unit.ObjectId = vbUnitId_From THEN 2
                                                                        ELSE 3
                                                                   END ASC
                                                                 , Container.Amount DESC
                                                          LIMIT 1
                                                         )
                                               WHEN vbAccountDirectionId_From = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                   THEN 0

                                               WHEN (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                              --  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                  OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                    )
                                              -- AND _tmpItem.UnitId_Item > 0
                                              -- AND 1=0
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                        , inGoodsId       := NULL -- _tmpItem.GoodsId
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

        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
        OR _tmpItem.ObjectDescId           = zc_Object_Asset()
     ;

 -- тест
 -- RAISE EXCEPTION 'Ошибка.<%>', (select _tmpItem .PartionGoodsId from _tmpItem where _tmpItem.MovementItemId = 287630184);
 -- тест
/*  RAISE EXCEPTION 'Ошибка. <%>  <%>  <%>  <%>  '
, (select sum (_tmpItem.OperCount) from _tmpItem where _tmpItem.MovementItemId = 330313041  )
, (select _tmpItem.ContainerId_Goods from _tmpItem where _tmpItem.MovementItemId = 330313041 )
, (select _tmpItem.PartionGoods from _tmpItem where _tmpItem.MovementItemId = 330313041 )
, (select _tmpItem.PartionGoodsId from _tmpItem where _tmpItem.MovementItemId = 330313041 )
  ;
*/
     -- формируются данные если продажа от Контрагента -> Контрагенту
     INSERT INTO _tmpItemPartnerFrom (MovementItemId, ContainerId_Partner, AccountId_Partner, ContainerId_ProfitLoss_10100, ContainerId_ProfitLoss_10400, OperSumm_Partner)
        SELECT MovementItemId
             , 0 AS ContainerId_Partner
             , 0 AS AccountId_Partner
             , 0 AS ContainerId_ProfitLoss_10100
             , 0 AS ContainerId_ProfitLoss_10400
             , OperSumm_PriceList AS OperSumm_Partner
        FROM _tmpItem
        WHERE vbPartnerId_From <> 0
    ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.0.1. определяется Счет(справочника) для проводок по долг Покупателя !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30100() -- покупатели
                                             , inInfoMoneyDestinationId := vbInfoMoneyDestinationId_From
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
           WHERE EXISTS (SELECT _tmpItemPartnerFrom.AccountId_Partner FROM _tmpItemPartnerFrom)
          ) AS _tmpItem_byAccount
     ;

     -- 3.0.2. определяется ContainerId для проводок по долг Покупателя !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM _tmpItem
          INNER JOIN (SELECT -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := (SELECT AccountId_Partner FROM _tmpItemPartnerFrom GROUP BY AccountId_Partner)
                                                   , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                   , inBusinessId        := tmp.BusinessId_From
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                   , inObjectId_1        := vbJuridicalId_From
                                                   , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                   , inObjectId_2        := vbContractId_From
                                                   , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_3        := vbInfoMoneyId_From
                                                   , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                   , inObjectId_4        := vbPaidKindId_From
                                                   , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_5        := vbPartionMovementId
                                                   , inDescId_6          := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                   , inObjectId_6        := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_From ELSE NULL END
                                                   , inDescId_7          := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                   , inObjectId_7        := CASE WHEN vbPaidKindId_From = zc_Enum_PaidKind_SecondForm() THEN vbBranchId_From ELSE NULL END
                                                   , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                   , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                    ) AS ContainerId
                           , tmp.BusinessId_From
            FROM (SELECT _tmpItem.BusinessId_From
                  FROM _tmpItem
                  WHERE EXISTS (SELECT _tmpItemPartnerFrom.AccountId_Partner FROM _tmpItemPartnerFrom)
                  GROUP BY _tmpItem.BusinessId_From
                 ) AS tmp
          ) AS _tmpItem_byInfoMoney ON _tmpItem_byInfoMoney.BusinessId_From = _tmpItem.BusinessId_From
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
     ;


     -- 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN vbIsCorporate_To = TRUE AND vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                            THEN _tmpItem_group.AccountId_Corporate
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- Физ.лица (подотчетные лица)

                             WHEN vbIsCorporate_To = TRUE
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                                 THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                             ELSE zc_Enum_AccountDirection_30200() -- наши компании
                                       END

                             WHEN vbInfoMoneyDestinationId_To IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                , zc_Enum_InfoMoneyDestination_20700()  -- Товары
                                                                , zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                , zc_Enum_InfoMoneyDestination_30100()  -- Продукция
                                                                , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                                 THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                            ELSE zc_Enum_AccountDirection_30100()      -- покупатели
                                       END

                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- Товары
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- Продукция
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                  THEN CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                                 THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                            ELSE zc_Enum_AccountDirection_30100()      -- покупатели
                                       END

                          -- ELSE zc_Enum_AccountDirection_30400() -- Прочие дебиторы
                             ELSE CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                                            THEN zc_Enum_AccountDirection_30150() -- покупатели ВЭД
                                       ELSE zc_Enum_AccountDirection_30100()      -- покупатели
                                  END
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_To = TRUE
                                  THEN vbInfoMoneyDestinationId_To -- zc_Enum_InfoMoneyDestination_30100() -- Продукция
                             WHEN vbInfoMoneyDestinationId_To <> 0
                                  THEN vbInfoMoneyDestinationId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.isTareReturning = TRUE -- !!!Возвратная тара!!!
                               OR _tmpItem.isLossMaterials = TRUE -- !!!Прочее сырье с ценой=0!!!
                                  THEN zc_Enum_InfoMoneyDestination_30100() -- Продукция
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
                             WHEN zc_Enum_InfoMoney_21152() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30206() -- Алан АЗИЯ
                             WHEN zc_Enum_InfoMoney_21155() = vbInfoMoneyId_CorporateTo
                                  THEN zc_Enum_Account_30207() -- Фирменная торговля

                        END AS AccountId_Corporate
                 FROM _tmpItem
                 WHERE _tmpItem.isTareReturning = FALSE -- !!!Возвратная тара не учавствует!!!
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот AccountId в проводках для отчета!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.isTareReturning, _tmpItem.isLossMaterials
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.2.1. определяется ContainerId для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM (SELECT CASE WHEN vbMemberId_To <> 0
                                 -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Физ.лица (подотчетные лица) 2)NULL 3)NULL 4)Статьи назначения
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := _tmpItem_group.AccountId_Partner
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                       , inBusinessId        := _tmpItem_group.BusinessId_From
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Member()
                                                       , inObjectId_1        := vbMemberId_To
                                                       , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_2        := _tmpItem_group.InfoMoneyId_calc
                                                       , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_3        := vbBranchId_From -- долг Подотчета всегда на филиале Склада
                                                       , inDescId_4          := zc_ContainerLinkObject_Car()
                                                       , inObjectId_4        := 0 -- для Физ.лица (подотчетные лица) !!!именно здесь последняя аналитика всегда значение = 0!!!
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
                                                  , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_2        := vbContractId
                                                  , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_4        := vbPaidKindId
                                                  , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                  , inObjectId_5        := vbPartionMovementId
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                                  , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbBranchId_From ELSE NULL END
                                                  , inDescId_8          := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                  , inObjectId_8        := CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN NULL ELSE vbCurrencyPartnerId END
                                                   )
                  END AS ContainerId
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_From
                      , CASE WHEN vbInfoMoneyId_To <> 0
                                  THEN vbInfoMoneyId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- Ирна
                                  THEN zc_Enum_InfoMoney_30101 () -- Готовая продукция
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 WHERE _tmpItem.isTareReturning = FALSE -- !!!Возвратная тара не учавствует!!!
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!нельзя ограничивать, т.к. этот ContainerId в проводках для отчета!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
     ;

     -- 3.3. !!!Очень важно - определили здесь vbContainerId_Analyzer для ВСЕХ!!!, если он не один - тогда ошибка
     vbContainerId_Analyzer:= (SELECT ContainerId_Partner FROM _tmpItem WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- определили
     vbContainerId_Analyzer_PartnerFrom:= (SELECT ContainerId_Partner FROM _tmpItemPartnerFrom WHERE ContainerId_Partner <> 0 GROUP BY ContainerId_Partner);
     -- определили
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From END;
     -- определили
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To END;

     -- определили
     vbAccountId_GoodsTransit_01:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110101() ELSE 0 END; -- Транзит + товар в пути
     IF vbOperDate < zc_DateStart_OperDatePartner()
     THEN vbAccountId_GoodsTransit_02:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110102() ELSE 0 END; -- Транзит + товар в пути
     ELSE vbAccountId_GoodsTransit_02:= vbAccountId_GoodsTransit_01;
     END IF;
     -- определили
     vbAccountId_GoodsTransit_51:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110151() ELSE 0 END; -- Транзит + товар в пути
     vbAccountId_GoodsTransit_52:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110152() ELSE 0 END; -- Транзит + товар в пути
     IF vbOperDate < zc_DateStart_OperDatePartner()
     THEN vbAccountId_GoodsTransit_53:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110153() ELSE 0 END; -- Транзит + товар в пути
     ELSE vbAccountId_GoodsTransit_53:= vbAccountId_GoodsTransit_01;
     END IF;


     -- 1.1.1. определяется ContainerId_GoodsPartner для !!!НЕ забалансовой!!! проводки по количественному учету - долги Покупателя или Физ.лица
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
                                                                          , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                          , inObjectId_2        := vbBranchId_From
                                                                          , inDescId_3          := zc_ContainerLinkObject_PaidKind()
                                                                          , inObjectId_3        := vbPaidKindId
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
       AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
    ;

     -- 1.1.2. формируются !!!НЕ забалансовые!!! Проводки для количественного учета - долги Покупателя или Физ.лица
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsPartner
            , 0                                       AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_TareReturning()      AS AnalyzerId               -- есть аналитика
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- Товар
            , CASE WHEN vbMemberId_To <> 0 THEN vbMemberId_To ELSE vbPartnerId_To END AS WhereObjectId_Analyzer -- Покупатель или Физ.лицо
            , 0                                       AS ContainerId_Analyzer     -- !!!нет!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!нет!!!
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- подразделение или...
            , ContainerId_GoodsPartner                AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0                                       AS ParentId
            , OperCount                               AS Amount
            , vbOperDatePartner                       AS OperDate                 -- т.е. по "Дате покупателя"
            , TRUE                                    AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
         AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
      ;


     -- 1.2.0. определяется ContainerId_Goods для количественного учета - !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner -- !!!по "Дате покупателя"!!!
                                                                                           , inUnitId                 := NULL -- !!!подразделения нет!!!
                                                                                           , inCarId                  := NULL
                                                                                           , inMemberId               := NULL
                                                                                           , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                           , inGoodsId                := _tmpItem.GoodsId
                                                                                           , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                           , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                           , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                           , inAssetId                := _tmpItem.AssetId
                                                                                           , inBranchId               := NULL
                                                                                           , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                            )
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
    ;

   -- 1.2.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN _tmpItem.ContainerId_Goods > 0 THEN _tmpItem.ContainerId_Goods
                                             ELSE
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
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
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From             -- эта аналитика нужна для филиала
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
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From             -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit_02 -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
                  -- Скидка в весе
                , ContainerId_GoodsTransit_53 = CASE WHEN vbAccountId_GoodsTransit_53 <> 0 AND _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                                     AND _tmpItem.OperCount <>_tmpItem.OperCount_ChangePercent
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate -- по "Дате склад"
                                                                                , inUnitId                 := vbUnitId_From
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_From
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := -- !!!криво найдем - временно!!!
                                                                                                              CASE WHEN _tmpItem.ObjectDescId = zc_Object_Asset()
                                                                                                                        THEN (SELECT CLO_AssetTo.ObjectId
                                                                                                                              FROM Container
                                                                                                                                   INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                                                                                                                  ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                                                                                                 AND CLO_PartionGoods.ObjectId    = _tmpItem.PartionGoodsId
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
                                                                                , inBranchId               := vbBranchId_From             -- эта аналитика нужна для филиала
                                                                                , inAccountId              := vbAccountId_GoodsTransit_53 -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                        ELSE 0 END
     WHERE vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
    ;

     -- 1.2.2. определяется ContainerId_Count для количественного учета
     UPDATE _tmpItem SET ContainerId_Count = lpInsertFind_Container (inContainerDescId   := zc_Container_CountCount()
                                                                   , inParentId          := _tmpItem.ContainerId_Goods
                                                                   , inObjectId          := _tmpItem.GoodsId
                                                                   , inJuridicalId_basis := NULL
                                                                   , inBusinessId        := NULL
                                                                   , inObjectCostDescId  := NULL
                                                                   , inObjectCostId      := NULL
                                                                    )
     WHERE _tmpItem.OperCountCount <> 0;

     -- 1.2.3. формируются Проводки для количественного учета (остаток)
        WITH tmpMIContainer AS
            (SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_Count
                  , 0                                          AS AccountId_GoodsTransit
                  , 0                                          AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                    -- Кол-во, списание при реализации/перемещении по цене
                  , zc_Enum_AnalyzerId_LossCount_20200()       AS AnalyzerId
                  , 0                                          AS ParentId
                  , -1 * OperCount                             AS Amount
                  , -1 * OperCountCount                        AS OperCountCount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             WHERE vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
               AND isLossMaterials = TRUE -- !!!если списание!!!

            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_Count
                  , vbAccountId_GoodsTransit_01                AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_01                AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                    --  Кол-во, реализация, у покупателя
                  , CASE WHEN isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE zc_Enum_AnalyzerId_SaleCount_10400() END AS AnalyzerId
                  , 0                                          AS ParentId
                  , -1 * OperCount_Partner                     AS Amount
                  , -1 * OperCountCount                        AS OperCountCount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             -- убрал т.к. хоть одна проводка должна быть (!!!для отчетов!!!)
             -- WHERE OperCount_Partner <> 0
             WHERE vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
               AND isLossMaterials = FALSE -- !!!если НЕ списание!!!

            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_Count
                  , vbAccountId_GoodsTransit_53                AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_53                AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                    --  Кол-во, реализация, Скидка за вес
                  , CASE WHEN isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE zc_Enum_AnalyzerId_SaleCount_10500() END AS AnalyzerId
                  , 0                                          AS ParentId
                  , -1 * (OperCount - OperCount_ChangePercent) AS Amount
                  , 0                                          AS OperCountCount
                  , FALSE                                      AS isActive
             FROM _tmpItem
             WHERE (OperCount - OperCount_ChangePercent) <> 0  -- !!!нулевые не нужны!!!
               AND isLossMaterials = FALSE -- !!!если НЕ списание!!!
               AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!

            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_Count
                  , vbAccountId_GoodsTransit_02                        AS AccountId_GoodsTransit
                  , ContainerId_GoodsTransit_02                        AS ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                     -- Кол-во, реализация, Разница в весе
                  , CASE WHEN isTareReturning = TRUE THEN zc_Enum_AnalyzerId_TareReturning() ELSE zc_Enum_AnalyzerId_SaleCount_40200() END AS AnalyzerId
                  , 0                                                  AS ParentId
                  , -1 * (OperCount_ChangePercent - OperCount_Partner) AS Amount
                  , 0                                                  AS OperCountCount
                  , FALSE                                              AS isActive
             FROM _tmpItem
             WHERE (OperCount_ChangePercent - OperCount_Partner) <> 0 -- !!!нулевые не нужны!!!
               AND isLossMaterials = FALSE -- !!!если НЕ списание!!!
               AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
            )
     -- проводки: AnalyzerId <> 0 всегда, ContainerId_Analyzer <> 0 тогда попадает в отчеты покупателя, иначе "виртуальная" (т.е. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка - zc_Container_Count
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Goods
            , 0                                       AS AccountId                -- нет счета
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND tmpMIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- если это транзит, тогда в реализацию за vbOperDate попадет 2 раза с + и -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , tmpMIContainer.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer

     UNION ALL
       -- это обычная проводка - zc_Container_CountCount
       SELECT 0, zc_MIContainer_CountCount() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Count
            , 0                                       AS AccountId                -- нет счета
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND tmpMIContainer.AnalyzerId <> zc_Enum_AnalyzerId_LossCount_20200() THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- если это транзит, тогда в реализацию за vbOperDate попадет 2 раза с + и -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , tmpMIContainer.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , tmpMIContainer.ParentId
            , tmpMIContainer.OperCountCount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
       WHERE tmpMIContainer.OperCountCount <> 0

     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_GoodsTransit
            , tmpMIContainer.AccountId_GoodsTransit   AS AccountId                -- есть счет (т.е. в отчетах определяется "транзит")
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже для "виртуальной")
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- т.е. в реализацию попадет "реальная" за vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- т.е. в реализацию попадет "реальная" за vbOperDatePartner + за vbOperDate попадет 2 раза с + и -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , tmpMIContainer.ContainerId_GoodsTransit AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT tmpMIContainer.isActive ELSE tmpMIContainer.isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN tmpMIContainer ON tmpMIContainer.AccountId_GoodsTransit <> 0
                                     AND tmpMIContainer.AnalyzerId             <> zc_Enum_AnalyzerId_LossCount_20200() -- !!!если НЕ списание!!!

     UNION ALL
       -- это обычная проводка - !!!если продажа от Контрагента -> Контрагенту!!!
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemPartnerFrom.MovementItemId
            , _tmpItemPartnerFrom.ContainerId_Goods
            , 0                                       AS AccountId                -- нет счета
            , zc_Enum_AnalyzerId_SaleCount_10400()    AS AnalyzerId               -- !!!аналитика есть всегда!!! Кол-во, реализация, у покупателя
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = TRUE THEN vbPartnerId_From ELSE vbPartnerId_To END AS WhereObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = TRUE THEN vbContainerId_Analyzer_PartnerFrom ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItemPartnerFrom.ContainerId_Goods   AS ContainerIntId_Analyzer  -- Контейнер "товар" - тот же самый
            , 0 AS ParentId
            , _tmpItem.OperCount_Partner * CASE WHEN tmpIsActive.isActive = TRUE THEN 1 ELSE -1 END AS Amount
            , vbOperDatePartner -- т.е. по "Дате покупателя"
            , tmpIsActive.isActive
       FROM (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmpIsActive
            INNER JOIN _tmpItem ON _tmpItem.OperCount_Partner <> 0  -- !!!нулевые не нужны!!!
            INNER JOIN _tmpItemPartnerFrom ON _tmpItemPartnerFrom.MovementItemId = _tmpItem.MovementItemId
      ;


     -- 1.2.3. дальше !!!Возвратная тара не учавствует!!!, поэтому удаляем
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;

     -- 1.2.4. дальше !!!Прочее сырье с ценой=0 не учавствует!!!, поэтому удаляем (потом это будет документ Списание))
     -- DELETE FROM _tmpItem WHERE _tmpItem.isLossMaterials = TRUE;



     IF vbIsHistoryCost         = TRUE -- !!! только для Админа нужны проводки с/с (сделано для ускорения проведения)!!!
        AND zc_isHistoryCost()  = TRUE -- !!!если нужны проводки!!!
     THEN
     -- 1.3.1.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_Goods, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_ProfitLoss_10400, ContainerId_ProfitLoss_20200, ContainerId, AccountId, ContainerId_Transit_01, ContainerId_Transit_02, ContainerId_Transit_51, ContainerId_Transit_52, ContainerId_Transit_53, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, isLossMaterials)
       --
       WITH -- где надо проверить с/с и потом найти альтернативную цену
            tmpHistoryCost_find_all AS (SELECT _tmpItem.ContainerId_Goods
                                             , _tmpItem.GoodsId
                                             , _tmpItem.GoodsKindId
                                             , Container_Summ.Id               AS ContainerId_Summ
                                             , Container_Summ.ObjectId         AS AccountId
                                             , COALESCE (HistoryCost.Price, 0) AS Price
                                        FROM _tmpItem
                                             INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                                                   AND Container_Summ.DescId   = zc_Container_Summ()
                                             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id
                                                                  AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                                                                THEN vbOperDatePartner
                                                                           ELSE vbOperDate
                                                                      END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                        WHERE vbIsPartionCell_from = TRUE
                                       )
                -- нашли с/с если нет для ContainerId_Goods
              , tmpHistoryCost_find AS (SELECT Container_Summ.ContainerId_Goods
                                             , Container_Summ.ContainerId_Summ
                                             , MAX (HistoryCost.Price) AS Price
                                        FROM -- нашли у каких ContainerId_Goods ВСЕ цены = 0
                                             (SELECT tmpHistoryCost_find_all.ContainerId_Goods FROM tmpHistoryCost_find_all
                                              GROUP BY tmpHistoryCost_find_all.ContainerId_Goods
                                              HAVING MAX (tmpHistoryCost_find_all.Price) = 0
                                             ) AS tmpHistoryCost_list
                                             -- для всех ContainerId_Summ надо найти альтернативную цену
                                             JOIN tmpHistoryCost_find_all AS Container_Summ ON Container_Summ.ContainerId_Goods = tmpHistoryCost_list.ContainerId_Goods

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
                                                                  AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                                                                THEN vbOperDatePartner
                                                                           ELSE vbOperDate
                                                                      END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
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
                                        GROUP BY Container_Summ.ContainerId_Goods
                                               , Container_Summ.ContainerId_Summ
                                  )
        -- Результат
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
            , 0 AS ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
            , 0 AS ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
            , 0 AS ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) AS AccountId

            , 0 AS ContainerId_Transit_01 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_02 -- Счет Транзит, определим позже +++
            , 0 AS ContainerId_Transit_51 -- Счет Транзит, определим позже
            , 0 AS ContainerId_Transit_52 -- Счет Транзит, определим позже
            , 0 AS ContainerId_Transit_53 -- Счет Транзит, определим позже +++

              -- с/с1 - для количества: расход с остатка
            , SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                        ELSE 0
                   END) AS OperSumm
              -- с/с2 - для количества: с учетом % скидки
            , SUM (CAST (_tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                        ELSE 0
                   END) AS OperSumm_ChangePercent
              -- с/с3 - для количества: контрагента
            , SUM (CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))
                 + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                             THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                        ELSE 0
                   END) AS OperSumm_Partner
            , _tmpItem.isLossMaterials
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
                                                  AND Container_Summ.DescId   = zc_Container_Summ()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                                THEN vbOperDatePartner
                                           --WHEN vbOperDatePartner < vbOperDate AND 1=0
                                           --     THEN vbOperDatePartner
                                           ELSE vbOperDate
                                      END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

             -- нашли с/с если нет для ContainerId_GoodsFrom
             LEFT JOIN tmpHistoryCost_find ON tmpHistoryCost_find.ContainerId_Summ = Container_Summ.Id
                                          AND HistoryCost.ContainerId IS NULL

        WHERE (_tmpItem.OperCount * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) <> 0                 -- !!!
             OR _tmpItem.OperCount_ChangePercent * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) <> 0  -- здесь нули !!!НЕ НУЖНЫ!!!
             OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, tmpHistoryCost_find.Price, 0) <> 0)       -- !!!
          AND vbPartnerId_From = 0 -- !!!если НЕ продажа от Контрагента -> Контрагенту!!!
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.ContainerId_Goods
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId
               , _tmpItem.isLossMaterials
                ;

        -- для филиалов вытянуть с/с РК
        IF COALESCE (vbBranchId_From, 0) NOT IN (0, zc_Branch_Basis())
           AND EXISTS (SELECT 1 FROM _tmpItem LEFT JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId WHERE _tmpItemSumm.MovementItemId IS NULL)
        THEN
            -- добавили новые ContainerId
            INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_Goods, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10500, ContainerId_ProfitLoss_10400, ContainerId_ProfitLoss_20200, ContainerId, AccountId, ContainerId_Transit_01, ContainerId_Transit_02, ContainerId_Transit_51, ContainerId_Transit_52, ContainerId_Transit_53, OperSumm, OperSumm_ChangePercent, OperSumm_Partner, isLossMaterials)
               SELECT
                     _tmpItem.MovementItemId
                   , _tmpItem.ContainerId_Goods
                   , 0 AS ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
                   , 0 AS ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
                   , 0 AS ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
                   , 0 AS ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
                     -- нашли только один
                   , COALESCE (MAX (COALESCE (Container.Id, 0)), 0) AS ContainerId
                   , 0 AS AccountId

                   , 0 AS ContainerId_Transit_01 -- Счет Транзит, определим позже +++
                   , 0 AS ContainerId_Transit_02 -- Счет Транзит, определим позже +++
                   , 0 AS ContainerId_Transit_51 -- Счет Транзит, определим позже
                   , 0 AS ContainerId_Transit_52 -- Счет Транзит, определим позже
                   , 0 AS ContainerId_Transit_53 -- Счет Транзит, определим позже +++

                     -- с/с1 - для количества: расход с остатка
                   , 0 AS OperSumm
                     -- с/с2 - для количества: с учетом % скидки
                   , 0 AS OperSumm_ChangePercent
                     -- с/с3 - для количества: контрагента
                   , 0 AS OperSumm_Partner
                   , _tmpItem.isLossMaterials
               FROM _tmpItem
                    LEFT JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
                    -- найдем любой ОДИН
                    LEFT JOIN Container ON Container.ParentId = _tmpItem.ContainerId_Goods
                                       AND Container.DescId   = zc_Container_Summ()
                    -- эту статью нельзя
                    INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                   ON CLO_InfoMoney.ContainerId = Container.Id
                                                  AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                  AND CLO_InfoMoney.ObjectId    <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                    -- эту статью нельзя
                    INNER JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                   ON CLO_InfoMoneyDetail.ContainerId = Container.Id
                                                  AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                                  AND CLO_InfoMoneyDetail.ObjectId    <> zc_Enum_InfoMoney_80401() -- прибыль текущего периода
                    -- эти счета нельзя
                    LEFT JOIN ObjectLink AS ObjectLink_AccountGroup ON ObjectLink_AccountGroup.ObjectId      = Container.ObjectId
                                                                   AND ObjectLink_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                                   -- Прибыль будущих периодов + Транзит
                                                                   AND ObjectLink_AccountGroup.ChildObjectId IN (zc_Enum_AccountGroup_60000()
                                                                                                               , zc_Enum_AccountGroup_110000()
                                                                                                                )

               WHERE _tmpItem.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
                 -- если не был найден стандартный
                 AND _tmpItemSumm.MovementItemId IS NULL
                 -- находим по другим счетам
                 AND ObjectLink_AccountGroup.ObjectId IS NULL
                 -- !!!временно, пока только с поиском, потом прикрутим Insert!!!
                 AND Container.Id > 0
               GROUP BY _tmpItem.MovementItemId
                      , _tmpItem.ContainerId_Goods
                      , _tmpItem.isLossMaterials
              ;


            -- если все еще не нашли - ОШИБКА
            IF EXISTS (SELECT 1 FROM _tmpItemSumm WHERE _tmpItemSumm.ContainerId = 0)
               AND 1=0
            THEN
                RAISE EXCEPTION 'Ошибка.Не нашли ячейку (ContainerId) для сохранения с/с.%Товар = <%>.%Вид = <%>.%Документ № <%> от <%>.'
                               , CHR (13)
                               , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId FROM _tmpItemSumm LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId WHERE _tmpItemSumm.ContainerId = 0 ORDER BY _tmpItemSumm.MovementItemId ASC LIMIT 1))
                               , CHR (13)
                               , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsKindId FROM _tmpItemSumm LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId WHERE _tmpItemSumm.ContainerId = 0 ORDER BY _tmpItemSumm.MovementItemId ASC LIMIT 1))
                               , CHR (13)
                               , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                               , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                                ;
            END IF;

            -- с/с РК
            UPDATE _tmpItemSumm SET -- с/с1 - для количества: расход с остатка
                                    OperSumm               = CAST (tmpList.OperCount               * tmpList.Price AS NUMERIC (16,4))
                                    -- с/с2 - для количества: с учетом % скидки
                                  , OperSumm_ChangePercent = CAST (tmpList.OperCount_ChangePercent * tmpList.Price AS NUMERIC (16,4))
                                    -- с/с3 - для количества: контрагента
                                  , OperSumm_Partner       = CAST (tmpList.OperCount_Partner       * tmpList.Price AS NUMERIC (16,4))

            FROM (WITH tmpList AS (SELECT DISTINCT _tmpItem.GoodsId, _tmpItem.GoodsKindId
                                   FROM _tmpItem
                                        JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
                                                         AND _tmpItemSumm.ContainerId_Goods = _tmpItem.ContainerId_Goods
                                                         -- !!!только для НОВЫХ!!!
                                                         AND _tmpItemSumm.AccountId      = 0
                                  )
                , tmpPrice_all AS (SELECT tmpList.GoodsId
                                        , tmpList.GoodsKindId
                                          -- для каждой партии отдельно
                                        , COALESCE (CLO_PartionGoods.ObjectId, 0)   AS PartionGoodsId
                                          --
                                        , SUM (COALESCE (HistoryCost.Price, 0))     AS Price
                                        , SUM (COALESCE (HistoryCost_old.Price, 0)) AS Price_old
                                   FROM tmpList
                                        INNER JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ObjectId = tmpList.GoodsId
                                                                                   AND CLO_Goods.DescId   = zc_ContainerLinkObject_Goods()
                                        INNER JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = CLO_Goods.ContainerId
                                                                                       AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                                                                       AND CLO_GoodsKind.ObjectId    = tmpList.GoodsKindId
                                        LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = CLO_Goods.ContainerId
                                                                                         AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                        INNER JOIN Container ON Container.Id      = CLO_Goods.ContainerId
                                                            AND Container.DescId = zc_Container_Summ()
                                        INNER JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = CLO_Goods.ContainerId
                                                                                  AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                                  -- !!!Только Розподільчий комплекс!!!
                                                                                  AND CLO_Unit.ObjectId    = zc_Unit_RK()

                                        LEFT JOIN ObjectLink AS ObjectLink_AccountGroup ON ObjectLink_AccountGroup.ObjectId      = Container.ObjectId
                                                                                       AND ObjectLink_AccountGroup.DescId        = zc_ObjectLink_Account_AccountGroup()
                                                                                       -- Прибыль будущих периодов + Транзит
                                                                                       AND ObjectLink_AccountGroup.ChildObjectId IN (zc_Enum_AccountGroup_60000()
                                                                                                                                   , zc_Enum_AccountGroup_110000()
                                                                                                                                    )
                                       LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container.Id
                                                            AND CASE WHEN DATE_TRUNC ('MONTH', vbOperDatePartner) < DATE_TRUNC ('MONTH', vbOperDate)
                                                                          THEN vbOperDatePartner
                                                                     --WHEN vbOperDatePartner < vbOperDate AND 1=0
                                                                     --     THEN vbOperDatePartner
                                                                     ELSE vbOperDate
                                                                END BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
                                       LEFT JOIN HistoryCost AS HistoryCost_old
                                                             ON HistoryCost_old.ContainerId = Container.Id
                                                            AND (DATE_TRUNC ('MONTH', CASE WHEN vbOperDatePartner < vbOperDate AND 1=0
                                                                                                THEN vbOperDatePartner
                                                                                           ELSE vbOperDate
                                                                                      END) - INTERVAL '1 MONTH')
                                                                BETWEEN HistoryCost_old.StartDate AND HistoryCost_old.EndDate
                                   -- находим по другим счетам
                                   WHERE ObjectLink_AccountGroup.ObjectId IS NULL
                                   GROUP BY tmpList.GoodsId
                                          , tmpList.GoodsKindId
                                          , COALESCE (CLO_PartionGoods.ObjectId, 0)
                                  )
                 , tmpPrice AS (SELECT tmpPrice_all.GoodsId
                                     , tmpPrice_all.GoodsKindId
                                     , tmpPrice_all.PartionGoodsId
                                     , tmpPrice_all.Price
                                     , tmpPrice_all.Price_old
                                       -- № п/п
                                     , ROW_NUMBER() OVER (PARTITION BY tmpPrice_all.GoodsId, tmpPrice_all.GoodsKindId ORDER BY tmpPrice_all.Price     DESC) AS Ord
                                     , ROW_NUMBER() OVER (PARTITION BY tmpPrice_all.GoodsId, tmpPrice_all.GoodsKindId ORDER BY tmpPrice_all.Price_old DESC) AS Ord_old
                                FROM tmpPrice_all
                               )
                  --
                  SELECT _tmpItem.MovementItemId
                       , _tmpItem.ContainerId_Goods
                       , CASE WHEN tmpPrice.Price > 0 THEN tmpPrice.Price WHEN tmpPrice_old.Price_old > 0 THEN tmpPrice_old.Price_old ELSE 0 END AS Price
                       , _tmpItem.OperCount
                       , _tmpItem.OperCount_ChangePercent
                       , _tmpItem.OperCount_Partner

                  FROM _tmpItem
                       LEFT JOIN tmpPrice ON tmpPrice.GoodsId     = _tmpItem.GoodsId
                                         AND tmpPrice.GoodsKindId = _tmpItem.GoodsKindId
                                         AND tmpPrice.Ord         = 1
                       LEFT JOIN tmpPrice AS tmpPrice_old
                                          ON tmpPrice_old.GoodsId     = _tmpItem.GoodsId
                                         AND tmpPrice_old.GoodsKindId = _tmpItem.GoodsKindId
                                         AND tmpPrice_old.Ord_old     = 1
                  WHERE tmpPrice.GoodsId > 0 OR tmpPrice_old.GoodsId > 0
                 ) AS tmpList

            -- !!!только для НОВЫХ!!!
            WHERE _tmpItemSumm.AccountId         = 0
              AND _tmpItemSumm.MovementItemId    = tmpList.MovementItemId
              AND _tmpItemSumm.ContainerId_Goods = tmpList.ContainerId_Goods
           ;


            -- нашли AccountId
            UPDATE _tmpItemSumm SET AccountId = Container.ObjectId
            FROM Container
            WHERE Container.Id = _tmpItemSumm.ContainerId
              AND _tmpItemSumm.AccountId = 0
           ;


        END IF; -- для филиалов вытянуть с/с РК

     END IF; -- if vbIsHistoryCost = TRUE AND zc_isHistoryCost() = TRUE


-- RAISE EXCEPTION 'Нет Прав - 1 ';

     -- 1.3.1.2. определяется ContainerId - Транзит
     UPDATE _tmpItemSumm SET -- у покупателя
                             ContainerId_Transit_01 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := _tmpItemSumm_find.UnitId
                                                                                        , inCarId                  := _tmpItemSumm_find.CarId
                                                                                        , inMemberId               := _tmpItemSumm_find.MemberId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := _tmpItemSumm_find.JuridicalBasisId
                                                                                        , inBusinessId             := _tmpItemSumm_find.BusinessId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_01 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItemSumm_find.InfoMoneyId
                                                                                        , inInfoMoneyId_Detail     := _tmpItemSumm_find.InfoMoneyId_Detail
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := _tmpItemSumm_find.GoodsId
                                                                                        , inGoodsKindId            := _tmpItemSumm_find.GoodsKindId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := _tmpItemSumm_find.PartionGoodsId
                                                                                        , inAssetId                := _tmpItemSumm_find.AssetId
                                                                                         )
                             -- Разница в весе
                           , ContainerId_Transit_02 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_02 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := _tmpItemSumm_find.UnitId
                                                                                        , inCarId                  := _tmpItemSumm_find.CarId
                                                                                        , inMemberId               := _tmpItemSumm_find.MemberId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := _tmpItemSumm_find.JuridicalBasisId
                                                                                        , inBusinessId             := _tmpItemSumm_find.BusinessId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_02 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItemSumm_find.InfoMoneyId
                                                                                        , inInfoMoneyId_Detail     := _tmpItemSumm_find.InfoMoneyId_Detail
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := _tmpItemSumm_find.GoodsId
                                                                                        , inGoodsKindId            := _tmpItemSumm_find.GoodsKindId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := _tmpItemSumm_find.PartionGoodsId
                                                                                        , inAssetId                := _tmpItemSumm_find.AssetId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- у покупателя
                           , ContainerId_Transit_51 = CASE WHEN 1=1 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := _tmpItemSumm_find.UnitId
                                                                                        , inCarId                  := _tmpItemSumm_find.CarId
                                                                                        , inMemberId               := _tmpItemSumm_find.MemberId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := _tmpItemSumm_find.JuridicalBasisId
                                                                                        , inBusinessId             := _tmpItemSumm_find.BusinessId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_51 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItemSumm_find.InfoMoneyId
                                                                                        , inInfoMoneyId_Detail     := _tmpItemSumm_find.InfoMoneyId_Detail
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_01 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := _tmpItemSumm_find.GoodsId
                                                                                        , inGoodsKindId            := _tmpItemSumm_find.GoodsKindId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := _tmpItemSumm_find.PartionGoodsId
                                                                                        , inAssetId                := _tmpItemSumm_find.AssetId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- Разница в весе
                           , ContainerId_Transit_52 = CASE WHEN 1=1 AND _tmpItem.ContainerId_GoodsTransit_02 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := _tmpItemSumm_find.UnitId
                                                                                        , inCarId                  := _tmpItemSumm_find.CarId
                                                                                        , inMemberId               := _tmpItemSumm_find.MemberId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := _tmpItemSumm_find.JuridicalBasisId
                                                                                        , inBusinessId             := _tmpItemSumm_find.BusinessId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_52 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItemSumm_find.InfoMoneyId
                                                                                        , inInfoMoneyId_Detail     := _tmpItemSumm_find.InfoMoneyId_Detail
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_02 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := _tmpItemSumm_find.GoodsId
                                                                                        , inGoodsKindId            := _tmpItemSumm_find.GoodsKindId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := _tmpItemSumm_find.PartionGoodsId
                                                                                        , inAssetId                := _tmpItemSumm_find.AssetId
                                                                                         )
                                                      ELSE 0
                                                      END
                             -- Скидка в весе
                           , ContainerId_Transit_53 = CASE WHEN _tmpItem.ContainerId_GoodsTransit_53 <> 0 THEN
                                                      lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := _tmpItemSumm_find.UnitId
                                                                                        , inCarId                  := _tmpItemSumm_find.CarId
                                                                                        , inMemberId               := _tmpItemSumm_find.MemberId
                                                                                        , inBranchId               := vbBranchId_From -- эта аналитика нужна для филиала
                                                                                        , inJuridicalId_basis      := _tmpItemSumm_find.JuridicalBasisId
                                                                                        , inBusinessId             := _tmpItemSumm_find.BusinessId
                                                                                        , inAccountId              := vbAccountId_GoodsTransit_53 -- !!!для счета Транзит!!!
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItemSumm_find.InfoMoneyId
                                                                                        , inInfoMoneyId_Detail     := _tmpItemSumm_find.InfoMoneyId_Detail
                                                                                        , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit_53 -- Счет - кол-во Транзит
                                                                                        , inGoodsId                := _tmpItemSumm_find.GoodsId
                                                                                        , inGoodsKindId            := _tmpItemSumm_find.GoodsKindId
                                                                                        , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                        , inPartionGoodsId         := _tmpItemSumm_find.PartionGoodsId
                                                                                        , inAssetId                := _tmpItemSumm_find.AssetId
                                                                                         )
                                                      ELSE 0
                                                      END
     FROM (WITH tmpCLO AS (SELECT * FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId IN (SELECT DISTINCT _tmpItemSumm.ContainerId FROM _tmpItemSumm))
           SELECT _tmpItemSumm_find.MovementItemId
                , _tmpItemSumm_find.ContainerId
                , _tmpItemSumm_find.ContainerId_Goods
                , CLO_JuridicalBasis.ObjectId  AS JuridicalBasisId
                , CLO_Business.ObjectId        AS BusinessId
                , CLO_InfoMoney.ObjectId       AS InfoMoneyId
                , CLO_InfoMoneyDetail.ObjectId AS InfoMoneyId_Detail
                , CLO_Goods.ObjectId           AS GoodsId
                , CLO_GoodsKind.ObjectId       AS GoodsKindId
                , CLO_PartionGoods.ObjectId    AS PartionGoodsId
                , CLO_Asset.ObjectId           AS AssetId
                , CLO_Unit.ObjectId            AS UnitId
                , CLO_Car.ObjectId             AS CarId
                , CLO_Member.ObjectId          AS MemberId
           FROM (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId, _tmpItemSumm.ContainerId_Goods FROM _tmpItemSumm) AS _tmpItemSumm_find
                LEFT JOIN tmpCLO AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = _tmpItemSumm_find.ContainerId
                                                                   AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                LEFT JOIN tmpCLO AS CLO_Business ON CLO_Business.ContainerId = _tmpItemSumm_find.ContainerId
                                                             AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
                LEFT JOIN tmpCLO AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = _tmpItemSumm_find.ContainerId
                                                              AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                LEFT JOIN tmpCLO AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpItemSumm_find.ContainerId
                                                                    AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
                LEFT JOIN tmpCLO AS CLO_Goods ON CLO_Goods.ContainerId = _tmpItemSumm_find.ContainerId
                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                LEFT JOIN tmpCLO AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpItemSumm_find.ContainerId
                                                              AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                LEFT JOIN tmpCLO AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpItemSumm_find.ContainerId
                                                                 AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                LEFT JOIN tmpCLO AS CLO_Asset ON CLO_Asset.ContainerId = _tmpItemSumm_find.ContainerId
                                                          AND CLO_Asset.DescId = zc_ContainerLinkObject_AssetTo()
                LEFT JOIN tmpCLO AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItemSumm_find.ContainerId
                                                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                LEFT JOIN tmpCLO AS CLO_Car ON CLO_Car.ContainerId = _tmpItemSumm_find.ContainerId
                                                        AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
                LEFT JOIN tmpCLO AS CLO_Member ON CLO_Member.ContainerId = _tmpItemSumm_find.ContainerId
                                                           AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
          ) AS _tmpItemSumm_find
          INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm_find.MovementItemId
                             AND _tmpItem.ContainerId_Goods = _tmpItemSumm_find.ContainerId_Goods
                             AND _tmpItem.isLossMaterials   = FALSE -- !!!если НЕ списание!!!
     WHERE _tmpItemSumm.MovementItemId    = _tmpItemSumm_find.MovementItemId
       AND _tmpItemSumm.ContainerId       = _tmpItemSumm_find.ContainerId
       AND _tmpItemSumm.ContainerId_Goods = _tmpItemSumm_find.ContainerId_Goods
       AND vbAccountId_GoodsTransit_01    <> 0
    ;


     -- 1.3.2. формируются Проводки для суммового учета (c/c остаток) + !!!есть MovementItemId!!!
        WITH tmpAccount_60000 AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_60000()) -- Прибыль будущих периодов
           , tmpMIContainer AS
            (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    -- Сумма с/с, списание при реализации/перемещении по цене
                  , zc_Enum_AnalyzerId_LossSumm_20200() AS AnalyzerId
                  , 0                                   AS ParentId
                  , -1 * _tmpItemSumm.OperSumm          AS Amount
                  , FALSE                               AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm        <> 0   -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = TRUE -- !!!если списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    -- Сумма с/с, реализация, у покупателя
                  , zc_Enum_AnalyzerId_SaleSumm_10400() AS AnalyzerId
                  , 0                                   AS ParentId
                  , -1 * _tmpItemSumm.OperSumm_Partner  AS Amount
                  , FALSE                               AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm_Partner <> 0    -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials  = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    --  Сумма с/с, реализация, Скидка за вес
                  , zc_Enum_AnalyzerId_SaleSumm_10500()                                AS AnalyzerId
                  , 0                                                                  AS ParentId
                  , -1 * (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS Amount
                  , FALSE                                                              AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) <> 0    -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials                                  = FALSE -- !!!если НЕ списание!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_Goods
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit_01
                  , _tmpItemSumm.ContainerId_Transit_02
                  , _tmpItemSumm.ContainerId_Transit_51
                  , _tmpItemSumm.ContainerId_Transit_52
                  , _tmpItemSumm.ContainerId_Transit_53
                    -- Сумма с/с, реализация, Разница в весе
                  , zc_Enum_AnalyzerId_SaleSumm_40200()                                        AS AnalyzerId
                  , 0                                                                          AS ParentId
                  , -1 * (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS Amount
                  , FALSE                                                                      AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) <> 0  -- !!!нулевые не нужны!!!
               AND _tmpItemSumm.isLossMaterials = FALSE -- !!!если НЕ списание!!!
            )
     -- проводки: AnalyzerId <> 0 всегда, ContainerId_Analyzer <> 0 тогда попадает в отчеты покупателя, иначе "виртуальная" (т.е. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId
            , tmpMIContainer.AccountId                AS AccountId                -- счет есть всегда
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже если через транзит, она нужна для склада)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem.isLossMaterials = FALSE THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- если это транзит, тогда в реализацию за vbOperDate не попадет
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- если это транзит, тогда в реализацию за vbOperDate попадет 2 раза с + и -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- т.е. по "Дате склад"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = tmpMIContainer.MovementItemId
                               AND _tmpItem.ContainerId_Goods = tmpMIContainer.ContainerId_Goods
     UNION ALL
       -- это две проводки для счета Транзит
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId

            , CASE WHEN tmpAccount_60000.AccountId > 0
                        THEN tmpMIContainer.ContainerId_Transit_51

                   -- Разница в весе
                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200()
                        THEN tmpMIContainer.ContainerId_Transit_02
                   -- Скидка за вес
                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500()
                        THEN tmpMIContainer.ContainerId_Transit_53

                   ELSE tmpMIContainer.ContainerId_Transit_01

              END AS ContainerId

            , CASE WHEN tmpAccount_60000.AccountId > 0 AND tmpOperDate.OperDate = vbOperDate
                        THEN zc_Enum_AnalyzerId_SummIn_110101()
                   WHEN tmpAccount_60000.AccountId > 0 AND tmpOperDate.OperDate = vbOperDatePartner
                        THEN zc_Enum_AnalyzerId_SummOut_110101()

                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_40200() -- Разница в весе
                        THEN vbAccountId_GoodsTransit_02
                   WHEN tmpMIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10500() -- Скидка за вес
                        THEN vbAccountId_GoodsTransit_53

                   ELSE vbAccountId_GoodsTransit_01 -- такой же как у проводки кол-ва

              END AS AccountId                                                    -- есть счет (т.е. в отчетах определяется "транзит")

            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!аналитика есть всегда!!! (даже для "виртуальной")
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- т.е. в реализацию попадет "реальная" за vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- т.е. в реализацию попадет "реальная" за vbOperDatePartner + за vbOperDate попадет 2 раза с + и -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem.ContainerId_GoodsTransit_01    AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "виртуальная" с обратным знаком
            , tmpOperDate.OperDate -- !!!две проводки за разные даты!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT isActive ELSE isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit_01 <> 0
                               AND _tmpItem.isLossMaterials    = FALSE -- !!!если НЕ списание!!!
            INNER JOIN tmpMIContainer ON tmpMIContainer.MovementItemId    = _tmpItem.MovementItemId
                                     AND tmpMIContainer.ContainerId_Goods = _tmpItem.ContainerId_Goods
            LEFT JOIN tmpAccount_60000 ON tmpAccount_60000.AccountId = tmpMIContainer.AccountId
      ;


     -- 2.0. создаем контейнеры для Проводки - Прибыль !!!если продажа от Контрагента -> Контрагенту!!!
     UPDATE _tmpItemPartnerFrom SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100 -- Счет - прибыль (ОПиУ - Сумма реализации)
                                  , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - Себестоимости реализации)
     FROM _tmpItem
          JOIN
          (SELECT -- для Сумма реализации
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10100
                  -- для учета себестоимости реализации
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10400
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
           FROM (SELECT -- определяем ProfitLossId_PriceList - для учета суммы реализации
                        CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10102() -- Сумма реализации + Ирна
                             ELSE zc_Enum_ProfitLoss_10101() -- Сумма реализации + Продукция
                        END AS ProfitLossId_PriceList

                        -- определяем ProfitLossId_Partner - для учета себестоимости реализации
                      , CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10402() -- Себестоимость реализации + Ирна
                             ELSE zc_Enum_ProfitLoss_10401() -- Себестоимость реализации + Продукция
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                             FROM _tmpItemPartnerFrom
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_From
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_From = _tmpItem.BusinessId_From
     WHERE _tmpItemPartnerFrom.MovementItemId = _tmpItem.MovementItemId;


     -- 2.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- Счет - прибыль (ОПиУ - разница в весе : с/с2 - с/с3)
                           , ContainerId_ProfitLoss_10500 = _tmpItem_byDestination.ContainerId_ProfitLoss_10500 -- Счет - прибыль (ОПиУ - скидки в весе : с/с1 - с/с2)
                           , ContainerId_ProfitLoss_10400 = _tmpItem_byDestination.ContainerId_ProfitLoss_10400 -- Счет - прибыль (ОПиУ - себестоимости реализации : с/с3)
                           , ContainerId_ProfitLoss_20200 = _tmpItem_byDestination.ContainerId_ProfitLoss_20200 -- Счет - прибыль (ОПиУ - Общепроизводственные расходы + Содержание складов)
     FROM _tmpItem
          JOIN
          (SELECT -- для учета разница в весе : с/с2 - с/с3
                  CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!если списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_CountChange
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_40208
                  -- для учета скидки в весе : с/с1 - с/с2
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!если списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_10500
                  -- для учета себестоимости реализации : с/с3
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = TRUE -- !!!если списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_10400
                  -- для учета себестоимости списания
                , CASE WHEN _tmpItem_byProfitLoss.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                            THEN 0
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                  , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                  , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Loss
                                                  , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                  , inObjectId_2        := vbBranchId_From
                                                   )
                  END AS ContainerId_ProfitLoss_20200
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
                , _tmpItem_byProfitLoss.isLossMaterials
           FROM (SELECT -- определяем ProfitLossId_CountChange - для учета разница в весе : с/с2 - с/с3
                        CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!если списание!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_40208() -- Содержание филиалов + Разница в весе
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_40208() -- Содержание филиалов + Разница в весе

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_CountChange

                        -- определяем ProfitLossId_ChangePercent - для учета скидки в весе : с/с1 - с/с2
                      , CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!если списание!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10502() -- Скидка за вес + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10501() -- Скидка за вес + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                        -- определяем ProfitLossId_Partner - для учета себестоимости реализации : с/с3
                      , CASE WHEN _tmpItem_group.isLossMaterials = TRUE -- !!!если списание!!!
                                  THEN 0

                             WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10402() -- Себестоимость реализации + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10401() -- Себестоимость реализации + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                        -- определяем ProfitLossId_Loss - для учета себестоимости списания
                      , CASE WHEN _tmpItem_group.isLossMaterials = FALSE -- !!!если НЕ списание!!!
                                  THEN 0
                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Loss

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                      , _tmpItem_group.isLossMaterials
                 FROM (SELECT CASE WHEN _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                                    AND vbBranchId_From IN (zc_Branch_Basis(), 0)
                                        THEN zc_Enum_ProfitLossGroup_20000() -- Общепроизводственные расходы

                                   WHEN _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                                    AND vbBranchId_From NOT IN (zc_Branch_Basis(), 0)
                                        THEN zc_Enum_ProfitLossGroup_40000() -- Расходы на сбыт

                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                              END AS ProfitLossGroupId

                            , CASE WHEN _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                                    AND vbBranchId_From IN (zc_Branch_Basis(), 0)
                                        THEN zc_Enum_ProfitLossDirection_20200() -- Общепроизводственные расходы + Содержание складов

                                   WHEN _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
                                    AND vbBranchId_From NOT IN (zc_Branch_Basis(), 0)
                                        THEN zc_Enum_ProfitLossDirection_40200() -- Содержание филиалов

                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossDirection_10400() -- Результат основной деятельности + Себестоимость реализации
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- Дополнительная прибыль + Реализация нашим компаниям
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossDirection_10400() -- Результат основной деятельности + Себестоимость реализации
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!ошибка!!! Дополнительная прибыль + Физ.лица (возмещение ущерба)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId_Corporate
                            , _tmpItem.isLossMaterials
                       FROM (SELECT  DISTINCT
                                     _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , _tmpItem.isLossMaterials
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                          --WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                          --     THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70103() -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70104() -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                               AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                              , _tmpItem.ProfitLossId_Corporate
                              , _tmpItem.isLossMaterials
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_From        = _tmpItem.BusinessId_From
                                     AND _tmpItem_byDestination.isLossMaterials        = _tmpItem.isLossMaterials
     WHERE _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_Goods = _tmpItem.ContainerId_Goods
     ;

     -- 2.2. формируются Проводки - Прибыль (Себестоимость) + !!!нет MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId                -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 AND _tmpItem_group.isLossMaterials = FALSE THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "Дате покупателя"
            , FALSE                                   AS isActive
       FROM (-- Проводки по разнице в весе : с/с2 - с/с3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_40200()       AS AnalyzerId -- Сумма с/с, реализация, Разница в весе
                  , SUM (_tmpItemSumm.OperSumm_ChangePercent - _tmpItemSumm.OperSumm_Partner) AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            UNION ALL
             -- Проводки по скидкам в весе : с/с1 - с/с2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10500 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10500()       AS AnalyzerId -- Сумма с/с, реализация, Скидка за вес
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_ChangePercent) AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10500, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            UNION ALL
             -- Проводки по себестоимости реализации : с/с3
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  Сумма с/с, реализация, у покупателя
                  , SUM (_tmpItemSumm.OperSumm_Partner)       AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials

            UNION ALL
             -- Проводки по списанию
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_20200 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_LossSumm_20200()       AS AnalyzerId --  Сумма с/с, списание при реализации/перемещении по цене
                  , SUM (_tmpItemSumm.OperSumm)               AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             WHERE _tmpItem.isLossMaterials = TRUE -- !!!если списание!!!
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_20200, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials

            -- !!!если продажа от Контрагента -> Контрагенту!!!
            UNION ALL
             -- Проводки по себестоимости реализации : От Кого
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  Сумма с/с, реализация, у покупателя
                  , -1 * SUM (_tmpItemSumm.OperSumm_Partner)  AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemPartnerFrom AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            UNION ALL
             -- Проводки по себестоимости реализации : Кому
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10400 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10400()       AS AnalyzerId --  Сумма с/с, реализация, у покупателя
                  , 1 * SUM (_tmpItemSumm.OperSumm_Partner)   AS OperSumm
                  , _tmpItem.isLossMaterials                  AS isLossMaterials
             FROM _tmpItemPartnerFrom AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10400, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.isLossMaterials
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!нулевые не нужны!!!
       ;


     -- 3.2.2. определяется ContainerId_Currency для проводок по долг Покупателя или Физ.лица (подотчетные лица)
     UPDATE _tmpItem SET ContainerId_Currency = _tmpItem_byInfoMoney.ContainerId_Currency
     FROM (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                        , inParentId          := _tmpItem_group.ContainerId_Partner
                                        , inObjectId          := _tmpItem_group.AccountId_Partner
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_group.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                        , inObjectId_1        := vbJuridicalId_To
                                        , inDescId_2          := zc_ContainerLinkObject_Contract()
                                        , inObjectId_2        := vbContractId
                                        , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                        , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                        , inObjectId_4        := vbPaidKindId
                                        , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                        , inObjectId_5        := vbPartionMovementId
                                        , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                        , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbPartnerId_To ELSE NULL END
                                        , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                        , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_To = FALSE THEN vbBranchId_From ELSE NULL END
                                        , inDescId_8          := zc_ContainerLinkObject_Currency()
                                        , inObjectId_8        := vbCurrencyPartnerId
                                         ) AS ContainerId_Currency
                , _tmpItem_group.InfoMoneyId
           FROM (SELECT _tmpItem.ContainerId_Partner
                      , _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_From
                      , CASE WHEN vbInfoMoneyId_To <> 0
                                  THEN vbInfoMoneyId_To -- УП: ВСЕГДА по договору -- а раньше было: в первую очередь - по договору, во вторую - по юрлицу !!!(если наши компании)!!!, иначе будем определять для каждого товара
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- Ирна
                                  THEN zc_Enum_InfoMoney_30101 () -- Готовая продукция
                             ELSE _tmpItem.InfoMoneyId -- иначе берем по товару
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 WHERE vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                   AND vbMemberId_To = 0
                 -- + для НАШИХ
                 --AND vbIsCorporate_To = FALSE
                 GROUP BY _tmpItem.ContainerId_Partner
                        , _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_From
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId;

     -- 3.3. формируются Проводки - долг Покупателя или Физ.лица (подотчетные лица) + !!!добавлен MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_Partner
            , CASE WHEN tmpTransit.AccountId > 0 THEN tmpTransit.AccountId ELSE _tmpItem_group.AccountId_Partner END AS AccountId -- счет есть всегда, !!но это иногда zc_Enum_AnalyzerId_Summ...!!
            , _tmpItem_group.AnalyzerId          AS AnalyzerId             -- аналитика
            , _tmpItem_group.GoodsId             AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer           AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItem_group.ContainerId_Partner AS ContainerId_Analyzer   -- тот же самый
            , _tmpItem_group.GoodsKindId         AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer             AS ObjectExtId_Analyzer   -- покупатель / физ.лицо
            , _tmpItem_group.ContainerId_Goods   AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                  AS ParentId
            , _tmpItem_group.OperSumm * CASE WHEN tmpTransit.AccountId = zc_Enum_AnalyzerId_SummOut_110101() THEN -1 ELSE 1 END AS Amount
            , tmpTransit.OperDate                AS OperDate               -- т.е. по "определенной" Дате
            , tmpTransit.isActive                AS isActive               -- TRUE будет всегда, остальные зависят от даты
       FROM (-- Сумма реализации
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10100() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
             -- HAVING SUM (_tmpItem.OperSumm_PriceList) <> 0

           UNION ALL
             -- Разница с оптовыми ценами
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10200() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner + _tmpItem.OperSumm_Partner_ChangePromo - _tmpItem.OperSumm_PriceList) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner + _tmpItem.OperSumm_Partner_ChangePromo - _tmpItem.OperSumm_PriceList) <> 0 -- !!!можно ограничить!!!

           UNION ALL
             -- Скидка Акция
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10250() AS AnalyzerId
                  , SUM (-1 * _tmpItem.OperSumm_Partner_ChangePromo) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePromo) <> 0 -- !!!можно ограничить!!!

           UNION ALL
             -- Скидка дополнительная
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_SaleSumm_10300() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItem
             WHERE _tmpItem.isLossMaterials = FALSE -- !!!если НЕ списание!!!
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId --, _tmpItem.isLossMaterials
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) <> 0 -- !!!можно ограничить!!!

           -- !!!если продажа от Контрагента -> Контрагенту!!!
           UNION ALL
             SELECT _tmpItemPartnerFrom.MovementItemId, _tmpItemPartnerFrom.ContainerId_Partner, _tmpItemPartnerFrom.AccountId_Partner, _tmpItemPartnerFrom.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, zc_Enum_AnalyzerId_SaleSumm_10100() AS AnalyzerId
                  , -1 * SUM (_tmpItemPartnerFrom.OperSumm_Partner) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItemPartnerFrom
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
             GROUP BY _tmpItemPartnerFrom.MovementItemId, _tmpItemPartnerFrom.ContainerId_Partner, _tmpItemPartnerFrom.AccountId_Partner, _tmpItemPartnerFrom.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
             -- HAVING SUM (_tmpItemPartnerFrom.OperSumm_Partner) <> 0

            ) AS _tmpItem_group
            LEFT JOIN (SELECT -1                                  AS AccountId, TRUE  AS isActive, CASE WHEN vbAccountId_GoodsTransit_01 <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, TRUE  AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, FALSE AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit_01 <> 0
                      ) AS tmpTransit ON tmpTransit.AccountId <> 0
     UNION ALL
       -- это !!!одна!!! проводка для "забалансового" Валютного счета
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId
            , _tmpItem_group.ContainerId_Currency
            , _tmpItem_group.AccountId_Partner    AS AccountId
            , 0                                   AS AnalyzerId
            , 0                                   AS ObjectId_Analyzer
            , 0                                   AS WhereObjectId_Analyzer
            , _tmpItem_group.ContainerId_Currency AS ContainerId_Analyzer
            , 0                                   AS ObjectIntId_Analyzer     -- !!!нет!!!
            , 0                                   AS ObjectExtId_Analyzer     -- !!!нет!!!
            , 0                                   AS ContainerIntId_Analyzer  -- !!!нет!!!
            , 0 AS ParentId
            , _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "определенной" Дате
            , TRUE AS isActive
       FROM (SELECT _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner, SUM (_tmpItem.OperSumm_Currency) AS OperSumm FROM _tmpItem WHERE _tmpItem.ContainerId_Currency <> 0 GROUP BY _tmpItem.ContainerId_Currency, _tmpItem.AccountId_Partner
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
     ;


     -- 4.1.1. создаем контейнеры для Проводки - Прибыль (Сумма реализации и Скидка по акциям и Скидка дополнительная и Курсовая разница)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10100 = _tmpItem_byDestination.ContainerId_ProfitLoss_10100
                       , ContainerId_ProfitLoss_10200 = _tmpItem_byDestination.ContainerId_ProfitLoss_10200
                       , ContainerId_ProfitLoss_10250 = _tmpItem_byDestination.ContainerId_ProfitLoss_10250
                       , ContainerId_ProfitLoss_10300 = _tmpItem_byDestination.ContainerId_ProfitLoss_10300
                       , ContainerId_ProfitLoss_80103 = _tmpItem_byDestination.ContainerId_ProfitLoss_80103
     FROM (SELECT -- для Сумма реализации
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10100
                  -- для Разница с оптовыми ценами
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10200
                  -- для Скидка Акция
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Promo
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10250
                  -- для Скидка дополнительная
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inJuridicalId_basis := vbJuridicalId_Basis_From
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_ChangePercent
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_From
                                         ) AS ContainerId_ProfitLoss_10300
                  -- для Курсовая разница
                , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_From
                                                       , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_From
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                       , inObjectId_1        := zc_Enum_ProfitLoss_75103() -- zc_Enum_ProfitLoss_80103() -- Курсовая разница
                                                       , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_2        := vbBranchId_From
                                                        )
                       ELSE 0
                  END AS ContainerId_ProfitLoss_80103
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_From
           FROM (SELECT -- определяем ProfitLossId_PriceList - для Сумма реализации
                        CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10102() -- Сумма реализации + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10101() -- Сумма реализации + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_PriceList

                        -- определяем ProfitLossId_Partner - для Разница с оптовыми ценами
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10202() -- Разница с оптовыми ценами + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10201() -- Разница с оптовыми ценами + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                        -- определяем ProfitLossId_Promo - для Скидка Акция
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                  THEN zc_Enum_ProfitLoss_10252() -- Скидка Акция + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10251() -- Скидка Акция + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Promo


                        -- определяем ProfitLossId_ChangePercent - для Скидка дополнительная
                      , CASE WHEN vbIsCorporate_To = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- Ирна      -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  THEN zc_Enum_ProfitLoss_10302() -- Скидка дополнительная + Ирна
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() --Результат основной деятельности
                                  THEN zc_Enum_ProfitLoss_10301() -- Скидка дополнительная + Продукция

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_ChangePercent

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_From
                 FROM (SELECT -- здесь !!!тоже!!! что и для с/с (но из с/с нельзя брать т.к. может быть что с/с=0)
                              CASE WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossGroup_10000() -- Результат основной деятельности
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- Дополнительная прибыль
                              END AS ProfitLossGroupId

                              -- здесь !!!другое!!! (в THEN) чем для с/с
                            , CASE WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- Ирна
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- Продукция
                                        THEN zc_Enum_ProfitLossDirection_10100() -- Результат основной деятельности + Сумма реализации
                                   WHEN vbIsCorporate_To = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70100() -- Дополнительная прибыль + Реализация нашим компаниям
                                   WHEN vbMemberId_To = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- Мясное сырье
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- Мясное сырье
                                        THEN zc_Enum_ProfitLossDirection_10100() -- Результат основной деятельности + Сумма реализации
                                   WHEN vbMemberId_To <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!ошибка!!! Дополнительная прибыль + Физ.лица (возмещение ущерба)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- Дополнительная прибыль + Прочее
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_From
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  DISTINCT
                                     _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_From
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                            OR (vbAccountDirectionId_From = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                                          --WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                          --     THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateTo
                                               THEN NULL -- Алан
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70101() -- Ирна
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70102() -- Чапли
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70103() -- Дворкин
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateTo
                                               THEN zc_Enum_ProfitLoss_70104() -- ЕКСПЕРТ-АГРОТРЕЙД
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItem
                             -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
                             -- WHERE _tmpItem.OperSumm_PriceList <> 0 OR _tmpItem.OperSumm_Partner <> 0 OR _tmpItem.OperSumm_Partner_ChangePercent <> 0
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_From
                              , _tmpItem.ProfitLossId_Corporate
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId_From = _tmpItem_byDestination.BusinessId_From;

     -- 4.1.2. формируются Проводки - Прибыль (Сумма реализации и Скидка по акциям и Скидка дополнительная) + !!!нет MovementItemId!!! + !!!добавлен GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- прибыль текущего периода
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- аналитика, но значение = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- покупатель / физ.лицо
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm                 AS Amount
            , CASE WHEN vbAccountId_GoodsTransit_01 <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- т.е. по "определенной" Дате
            , FALSE                                   AS isActive
       FROM  -- Сумма реализации
            (SELECT _tmpItem.ContainerId_ProfitLoss_10100  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10100()    AS AnalyzerId -- Сумма, реализация, у покупателя
                  , -1 * SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10100, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- Разница с оптовыми ценами
             SELECT _tmpItem.ContainerId_ProfitLoss_10200  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10200()   AS AnalyzerId --  Сумма, реализация, Разница с оптовыми ценами
                  , 1 * SUM (_tmpItem.OperSumm_PriceList - _tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePromo) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10200, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId

            UNION ALL
             -- Скидка Акция
             SELECT _tmpItem.ContainerId_ProfitLoss_10250  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10250()   AS AnalyzerId --  Сумма, реализация, Скидка Акция
                  , 1 * SUM (_tmpItem.OperSumm_Partner_ChangePromo) AS OperSumm
             FROM _tmpItem
             WHERE OperSumm_Partner_ChangePromo <> 0
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10250, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId

            UNION ALL
             -- Скидка дополнительная
             SELECT _tmpItem.ContainerId_ProfitLoss_10300  AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods             AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10300()   AS AnalyzerId -- Сумма, реализация, Скидка дополнительная
                  , 1 * SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_Partner_ChangePercent) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10300, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            -- !!!если продажа от Контрагента -> Контрагенту!!!
            UNION ALL
             -- Сумма реализации От Кого
             SELECT _tmpItemPartnerFrom.ContainerId_ProfitLoss_10100 AS ContainerId_ProfitLoss
                  , _tmpItemPartnerFrom.ContainerId_Goods  AS ContainerId_Goods
                  , _tmpItem.GoodsId                       AS GoodsId
                  , _tmpItem.GoodsKindId                   AS GoodsKindId
                  , 0                                      AS AnalyzerId -- zc_Enum_AnalyzerId_SaleSumm_10100()   AS AnalyzerId -- Сумма, реализация, у покупателя
                  , 1 * SUM (_tmpItemPartnerFrom.OperSumm_Partner) AS OperSumm
             FROM _tmpItemPartnerFrom
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerFrom.MovementItemId
             GROUP BY _tmpItemPartnerFrom.ContainerId_ProfitLoss_10100, _tmpItemPartnerFrom.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
      ;


     /*-- убрал, т.к. св-во пишется теперь в ОПиУ
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     DELETE FROM MovementLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementId = inMovementId;*/
     -- !!!6.0.1. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), _tmpItem.MovementItemId, vbBranchId_From)
     FROM (SELECT DISTINCT _tmpItem.MovementItemId FROM _tmpItem) AS _tmpItem;
     -- !!!6.0.2. формируются свойство связь с <филиал> в документе из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, vbBranchId_From);
     -- !!!6.0.3. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Business(), _tmpItem.MovementItemId, _tmpItem.BusinessId_From)
     FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.BusinessId_From FROM _tmpItem) AS _tmpItem;
     -- !!!6.0.4. формируется свойство <zc_MIFloat_Summ - Сумма> + <zc_MIFloat_SummFrom - Сумма (ушло)> + <zc_MIFloat_SummPriceList - Сумма по прайсу>!!!
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


     --
     IF EXISTS (SELECT 1 FROM _tmpMIContainer_insert WHERE _tmpMIContainer_insert.ContainerId = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> необходимо ввести цену.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.GoodsId FROM _tmpMIContainer_insert JOIN _tmpItem ON _tmpItem.ContainerId_Goods = _tmpMIContainer_insert.ContainerIntId_Analyzer WHERE _tmpMIContainer_insert.ContainerId = 0 LIMIT 1))
                         ;
     END IF;

     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();


     -- 6.2.1. Дата оплаты по накладной (только если парт.учет долгов)
     IF vbPartionMovementId > 0 OR EXISTS (SELECT MovementId FROM MovementDate WHERE MovementId = inMovementId AND DescId = zc_MovementDate_Payment())
     THEN
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), inMovementId, vbPaymentDate);
     END IF;

     -- 6.2.2. в MovementLinkMovement если найдена акция и она 1
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), inMovementId, CASE WHEN tmp.MovementId_min = tmp.MovementId_max THEN tmp.MovementId_min ELSE NULL END :: Integer)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), inMovementId, CASE WHEN tmp.MovementId_min > 0 AND tmp.MovementId_max > 0 THEN TRUE ELSE FALSE END)
     FROM (SELECT 1 AS x) AS x1
           LEFT JOIN
          (SELECT MIN (MIFloat_PromoMovement.ValueData) AS MovementId_min,  MAX (MIFloat_PromoMovement.ValueData) AS MovementId_max
           FROM (SELECT DISTINCT _tmpItem.MovementItemId FROM _tmpItem) AS _tmpItem
                INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                             ON MIFloat_PromoMovement.MovementItemId = _tmpItem.MovementItemId
                                            AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()
                                            AND MIFloat_PromoMovement.ValueData      <> 0
          ) AS tmp ON 1 = 1;


     -- 6.2.3. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := CASE WHEN vbUserId_save < 0 THEN vbUserId_save ELSE inUserId END
                                 );

     -- 6.3. ФИНИШ - перепроводим Налоговую
     IF inUserId <> zc_Enum_Process_Auto_PrimeCost()
        --AND inMovementId <> 33900715
        AND inUserId <> 343013  -- Нагорная Я.Г.

        -- AND inUserId <> 6604558 -- Голота К.О.
        -- AND inUserId <> 9459   -- Малахова Т.Н.
        -- AND inUserId <> zfCalc_UserMain()
        -- AND inUserId <> 5
        AND vbPaidKindId = zc_Enum_PaidKind_FirstForm()
        AND vbCurrencyDocumentId = zc_Enum_Currency_Basis()
        AND vbCurrencyPartnerId = zc_Enum_Currency_Basis()
        AND vbMovementDescId = zc_Movement_Sale()
        AND EXISTS (SELECT MovementLinkMovement_Master.MovementId
                    FROM MovementLinkMovement AS MovementLinkMovement_Master
                         INNER JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                                       AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                                       ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id
                                                      AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                      AND MovementLinkObject_DocumentTaxKind_Master.ObjectId = zc_Enum_DocumentTaxKind_Tax()
                    WHERE MovementLinkMovement_Master.MovementId = inMovementId
                      AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                   )
     THEN
          -- Админу только отладка
          if inUserId <> zfCalc_UserAdmin() :: Integer AND 1=1 -- AND inMovementId <> 34203255
          then
          --
          PERFORM lpInsertUpdate_Movement_Tax_From_Kind (inMovementId            := inMovementId
                                                       , inDocumentTaxKindId     := zc_Enum_DocumentTaxKind_Tax()
                                                       , inDocumentTaxKindId_inf := NULL
                                                       , inStartDateTax          := NULL
                                                       , inUserId                := inUserId
                                                        );
        --   ELSE RAISE EXCEPTION 'Админу только отладка';
           end if;
     END IF;

     -- 6.4. ФИНИШ - в Налоговой устанавливается признак "Проверен"
     vbMovementId_Tax:= (SELECT MovementLinkMovement_Master.MovementChildId
                         FROM MovementLinkMovement AS MovementLinkMovement_Master
                              INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                                            ON MovementLinkObject_DocumentTaxKind_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                           AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                           AND MovementLinkObject_DocumentTaxKind_Master.ObjectId = zc_Enum_DocumentTaxKind_Tax()
                         WHERE MovementLinkMovement_Master.MovementId = inMovementId
                           AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                        );
     IF vbMovementId_Tax <> 0
     THEN -- сохранили свойство <Проверен>
          PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbMovementId_Tax, (SELECT ValueData FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Checked()));
     END IF;


     if inUserId = 5 AND 1=0 then RAISE EXCEPTION 'Нет Прав и нет Проверки - что б ничего не делать'; end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.12.19         * add GoodsKindId в прайс
 16.01.15                                        * add !!!убрал, переводится в строчной части!!!
 18.12.14                                        * all
 19.10.14                                        * add inIsLastComplete = FALSE, тогда перепроводим Налоговую
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_To
 05.09.14                                        * add zc_ContainerLinkObject_Branch to Физ.лица (подотчетные лица)
 02.09.14                                        * add vbIsHistoryCost
 23.08.14                                        * add vbPartnerId_To
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 12.08.14                                        * add !!!Виртуальные контейнеры!!!
 22.07.14                                        * add ...Price
 25.05.14                                        * add lpComplete_Movement
 22.05.14                                        * modify lfSelect_ObjectHistory_PriceListItem ... inOperDate:= vbOperDatePartner
 16.05.14                                        * add ФИНИШ - перепроводим Налоговую
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        * rem zc_Enum_AccountDirection_30400
 30.04.14                                        * set lp
 26.04.14                                        * !!!RESTORE!!!
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 14.02.14                                        *
*/

/*
select Movement.*
--     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id, MovementFloat_ChangePercent.ValueData)
     FROM Movement
         inner JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                 AND MovementFloat_ChangePercent.ValueData <> 0
          inner JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Master()

          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                     AND MIFloat_PromoMovement.DescId = zc_MIFloat_ChangePercent()

where Movement.DescId = zc_Movement_Sale()
  and Movement.OperDate >= '01.01.2016'
and coalesce (MIFloat_PromoMovement.ValueData, 0) <> MovementFloat_ChangePercent.ValueData

-- check - zc_MIFloat_Summ - zc_MIFloat_SummFrom
select *
from MovementItem
left join MovementItemFloat  AS M1 on M1.MovementItemId = MovementItem.Id and M1.DescId = zc_MIFloat_Summ()
left join MovementItemFloat  AS M2 on M2.MovementItemId = MovementItem.Id and M2.DescId = zc_MIFloat_SummFrom()
where MovementItem.MovementId = 4321872
   and MovementItem.DescId = 1
   and MovementItem.isErased = false
and coalesce (M1.ValueData, 0) <> coalesce (M2.ValueData, 0)

*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_Sale (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')


/*
--23791150

WITH
tmpMIOrder AS (SELECT MovementItem.ObjectId AS GoodsId
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                    , (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0) ) AS Amount
                    , (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData,0)) /100 * 15 AS Amount15
               FROM MovementLinkMovement AS MovementLinkMovement_Order
                    INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Order.MovementChildId
                                          AND MovementItem.DescId = zc_MI_Master()
                                          AND MovementItem.isErased = FALSE
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

               WHERE MovementLinkMovement_Order.MovementId = 23791150 --inMovementId
                 AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
              --MovementLinkMovement_Order.MovementChildId
             )
, tmpMISale AS (
SELECT MovementItem.ObjectId AS GoodsId
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                    , COALESCE (MovementItem.Amount,0) AS Amount
 , MIFloat_AmountPartner.ValueData               AS AmountPartner
 , MIFloat_AmountPartner.ValueData*(1 + 15/100)  AS AmountPartner_15

FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                             ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

WHERE MovementItem.MovementId = 23791150 --inMovementId
                                          AND MovementItem.DescId = zc_MI_Master()
                                          AND MovementItem.isErased = FALSE
)

SELECT *
, COALESCE (tmpMISale.AmountPartner,0) - COALESCE (tmpMIOrder.Amount,0)
, CAST ((COALESCE (tmpMISale.AmountPartner,0) - COALESCE (tmpMIOrder.Amount,0)) * 100 / COALESCE (tmpMIOrder.Amount,0) AS NUMERIC (16,1)) AS PersentReal
FROM tmpMISale
    LEFT JOIN tmpMIOrder ON tmpMIOrder.GoodsId = tmpMISale.GoodsId
                        AND  tmpMIOrder.GoodsKindId = tmpMISale.GoodsKindId

WHERE COALESCE (tmpMISale.AmountPartner,0) - COALESCE (tmpMIOrder.Amount,0) < tmpMIOrder.Amount15
--LIMIT 1
*/

-- Фора ТОВ - update ObjectBoolean set ValueData = TRUE where ObjectId = 15616  AND DescId   = zc_ObjectBoolean_Juridical_isNotRealGoods()
-- select gpComplete_All_Sybase (31737245  ,  false    , '')
-- select gpComplete_All_Sybase (34029436 ,  false    , '')
