-- Function: lpComplete_Movement_ChangePercent (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangePercent (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbOperSumm_Partner          TFloat;
  DECLARE vbOperSumm_Partner_byItem   TFloat;

  DECLARE vbMovementDescId            Integer;
  DECLARE vbOperDate                  TDateTime;
  DECLARE vbPartnerId_to              Integer;
  DECLARE vbFromId                    Integer;
  DECLARE vbToId                      Integer;
  DECLARE vbIsCorporate_To            Boolean;
  DECLARE vbInfoMoneyId_Corporate_To  Integer;
  DECLARE vbContractId_To             Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To            Integer;
  DECLARE vbPaidKindId_To             Integer;
  DECLARE vbJuridicalId_Basis_To      Integer;

  DECLARE vbPriceWithVAT              Boolean;
  DECLARE vbVATPercent                TFloat;
  DECLARE vbDiscountPercent           TFloat;

  DECLARE vbBranchId_Juridical Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- для долга !!!определяется Филиал по Пользователю!!!, иначе всегда на Главном филиале
     vbBranchId_Juridical:= zc_Branch_Basis();


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и для формирования Аналитик в проводках
     SELECT Movement.DescId
          , Movement.OperDate
          , MovementLinkObject_Partner.ObjectId            AS PartnerId_To
          , COALESCE (MovementLinkObject_From.ObjectId, 0) AS FromId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)   AS ToId
          , CASE WHEN View_Constant_isCorporate_To.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate_To.ValueData, FALSE)
            END AS isCorporate_From
          , COALESCE (ObjectLink_Juridical_InfoMoney_To.ChildObjectId, 0)       AS InfoMoneyId_Corporate_To
          , COALESCE (MovementLinkObject_Contract_To.ObjectId, 0)               AS ContractId_To
          , COALESCE (View_InfoMoney_To.InfoMoneyDestinationId, 0)              AS InfoMoneyDestinationId_To
          , COALESCE (ObjectLink_Contract_InfoMoney_To.ChildObjectId, 0)        AS InfoMoneyId_To
          , COALESCE (MovementLinkObject_PaidKind_To.ObjectId, 0)               AS PaidKindId_To
          , COALESCE (ObjectLink_Contract_JuridicalBasis_To.ChildObjectId, 0)   AS JuridicalId_Basis_To
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)             AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)                    AS VATPercent
          , MovementFloat_ChangePercent.ValueData                               AS DiscountPercent
            INTO vbMovementDescId, vbOperDate
               , vbPartnerId_To, vbFromId, vbToId, vbIsCorporate_To, vbInfoMoneyId_Corporate_To
               , vbContractId_To
               , vbInfoMoneyDestinationId_To, vbInfoMoneyId_To
               , vbPaidKindId_To
               , vbJuridicalId_Basis_To
               , vbPriceWithVAT, vbVATPercent, vbDiscountPercent
     FROM Movement

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = inMovementId
                                      AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = inMovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind_To
                                       ON MovementLinkObject_PaidKind_To.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind_To.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_To
                                       ON MovementLinkObject_Contract_To.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract_To.DescId     = zc_MovementLinkObject_Contract()
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
       AND Movement.DescId IN (zc_Movement_ChangePercent())
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
      ;


     -- проверка
     IF vbFromId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <От кого (юридическое лицо)>.Проведение невозможно.';
     END IF;

     -- проверка
     IF vbToId = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Кому (юридическое лицо)>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbContractId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbInfoMoneyId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлена <УП статья назначения>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbPaidKindId_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты>.Проведение невозможно.';
     END IF;
     -- проверка
     IF vbJuridicalId_Basis_To = 0
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено <Главное юридическое лицо>.Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_ProfitLoss_10300, AccountId_To, ContainerId_To
                         , GoodsId, GoodsKindId
                         , OperCount, Price_original, OperSumm_Partner_noDiscount, OperSumm_Partner_Discount, OperSumm_Partner
                         , BusinessId, BranchId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )

        WITH tmpMI_child AS (SELECT MI_Child.ParentId     AS ParentId
                                  , MI_Child.ObjectId     AS GoodsId
                                  , SUM (MI_Child.Amount) AS Amount
                                  , MAX (MI_Child.Id)     AS MovementItemId
                             FROM MovementItem AS MI_Child
                             WHERE MI_Child.MovementId = inMovementId
                               AND MI_Child.DescId     = zc_MI_Child()
                               AND MI_Child.isErased   = FALSE
                             GROUP BY MI_Child.ParentId
                                    , MI_Child.ObjectId
                            )
        SELECT tmpMI.MovementItemId
             , 0 AS ContainerId_ProfitLoss_10300    -- сформируем позже
             , 0 AS AccountId_To                    -- сформируем позже
             , 0 AS ContainerId_To                  -- сформируем позже
             , tmpMI.GoodsId
             , tmpMI.GoodsKindId
             , tmpMI.OperCount
             , tmpMI.Price_original

              -- сумма БЕЗ СКИДКИ и БЕЗ НДС - с округлением до 2-х знаков
            , tmpMI.OperSumm_Partner_noDiscount
            
              -- сумма СКИДКИ для суммы БЕЗ НДС - с округлением до 2-х знаков
            , tmpMI.OperSumm_percent AS OperSumm_Partner_Discount

              -- конечная сумма СКИДКИ c НДС
            , tmpMI.OperSumm_percent + CAST (vbVATPercent / 100 * tmpMI.OperSumm_percent AS NUMERIC (16, 2)) AS OperSumm_Partner
              
              -- Бизнес из Товара
            , tmpMI.BusinessId
              -- 
            , tmpMI.BranchId

              -- Статьи назначения
            , tmpMI.InfoMoneyGroupId
            , tmpMI.InfoMoneyDestinationId
            , tmpMI.InfoMoneyId

        FROM (SELECT tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   , tmpMI.GoodsKindId
                   , tmpMI.OperCount
                   , tmpMI.Price_original
                     -- цена БЕЗ СКИДКИ и БЕЗ НДС - с округлением до 2-х знаков
                   , tmpMI.OperPrice
                     -- цена СКИДКИ и БЕЗ НДС - с округлением до 2-х знаков
                   , CAST (tmpMI.OperPrice * vbDiscountPercent / 100 AS NUMERIC (16, 2)) AS OperPrice_percent

                     -- сумма БЕЗ СКИДКИ и БЕЗ НДС - с округлением до 2-х знаков
                   , CAST (tmpMI.OperCount * tmpMI.OperPrice AS NUMERIC (16, 2)) AS OperSumm_Partner_noDiscount

                     -- сумма со СКИДКОЙ БЕЗ НДС - с округлением до 2-х знаков
                   , CAST (tmpMI.OperCount * (tmpMI.OperPrice - CAST (tmpMI.OperPrice * vbDiscountPercent / 100 AS NUMERIC (16, 2))) AS NUMERIC (16, 2)) AS OperSumm_Partner_Discount

                     -- сумма СКИДКИ БЕЗ НДС - с округлением до 2-х знаков
                   , CAST (tmpMI.OperCount * CAST (tmpMI.OperPrice * vbDiscountPercent / 100 AS NUMERIC (16, 2)) AS NUMERIC (16, 2)) AS OperSumm_percent

                    -- Бизнес из Товара
                   , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 8370) AS BusinessId -- АЛАН
                     --
                   , tmpMI.BranchId
                     -- Статьи назначения
                   , View_InfoMoney_From.InfoMoneyGroupId
                   , View_InfoMoney_From.InfoMoneyDestinationId
                   , View_InfoMoney_From.InfoMoneyId

              FROM (SELECT MovementItem.Id                                        AS MovementItemId
                         , COALESCE (MI_Child.GoodsId, MovementItem.ObjectId)     AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind_child.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                         
                         , COALESCE (ObjectLink_UnitFrom_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId
      
                         , MovementItem.Amount                                    AS OperCount
                         , COALESCE (MIFloat_Price.ValueData, 0)                  AS Price_original
                         , COALESCE (MIFloat_CountForPrice.ValueData, 0)          AS CountForPrice

                           -- цена БЕЗ СКИДКИ и БЕЗ НДС - с округлением до 2-х знаков
                         , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent > 0
                                   -- если цены с НДС, тогда находим БЕЗ НДС
                                   THEN CAST (-- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                                              CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                                         THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                              END AS NUMERIC (16, 2))
                                            / (1 + vbVATPercent/100)
                                              AS NUMERIC (16, 2))
             
                                ELSE -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                                     CASE WHEN MIFloat_CountForPrice.ValueData <> 0
                                               THEN COALESCE (MIFloat_Price.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                               ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                     END
             
                           END AS OperPrice
      
                    FROM Movement
                         JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                         LEFT JOIN tmpMI_child AS MI_Child ON MI_Child.ParentId   = MovementItem.Id
      
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_child
                                                          ON MILinkObject_GoodsKind_child.MovementItemId = MI_Child.MovementItemId
                                                         AND MILinkObject_GoodsKind_child.DescId         = zc_MILinkObject_GoodsKind()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit_child
                                                          ON MILinkObject_Unit_child.MovementItemId = MI_Child.MovementItemId
                                                         AND MILinkObject_Unit_child.DescId         = zc_MILinkObject_Unit()
                         LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                              ON ObjectLink_UnitFrom_Branch.ObjectId = MILinkObject_Unit_child.ObjectId
                                             AND ObjectLink_UnitFrom_Branch.DescId   = zc_ObjectLink_Unit_Branch()
      
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                     ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                    WHERE Movement.Id = inMovementId
                      AND Movement.DescId IN (zc_Movement_ChangePercent())
                      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                   ) AS tmpMI
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_From ON View_InfoMoney_From.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_Business.DescId   = zc_ObjectLink_Goods_Business()
             ) AS tmpMI
        ;

     -- сохранили связь
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), _tmpItem.MovementItemId, _tmpItem.BranchId)
     FROM _tmpItem
    ;
     

     -- Расчет Итоговой суммы по Контрагенту
     vbOperSumm_Partner:= (SELECT CAST ((1 + vbVATPercent / 100) * tmpOperSumm_Partner AS NUMERIC (16, 2))
                            FROM (SELECT SUM (_tmpItem.OperSumm_Partner_Discount) AS tmpOperSumm_Partner
                                  FROM _tmpItem
                                 ) AS tmp
                           );
     -- Расчет Итоговой суммы (по элементам)
     vbOperSumm_Partner_byItem:= (SELECT SUM (OperSumm_Partner) FROM _tmpItem);


     -- если не равны ДВЕ Итоговые суммы по Контрагенту
   /*IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT _tmpItem.MovementItemId FROM _tmpItem ORDER BY OperSumm_Partner DESC LIMIT 1);

     END IF;*/


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1.1. создаем контейнеры для Проводки - Прибыль (Скидка дополнительная)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10300 = _tmpItem_byDestination.ContainerId_ProfitLoss_10300
     FROM (SELECT -- для Скидка дополнительная
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := _tmpItem_byProfitLoss.BranchId
                                         ) AS ContainerId_ProfitLoss_10300
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId

           FROM (SELECT -- определяем ProfitLossId - для Скидка дополнительная
                        CASE WHEN  -- 10000; "Результат основной деятельности"
                                  _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000()
                                   -- Ирна
                              AND _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                  -- Скидка дополнительная 10302; "Ирна"
                                  THEN zc_Enum_ProfitLoss_10302()
    
                             WHEN  -- 10000; "Результат основной деятельности"
                                  _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000()
                                  -- Скидка дополнительная 10301; "Продукция"
                                  THEN zc_Enum_ProfitLoss_10301()

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId
                      , _tmpItem_group.BranchId

                 FROM (SELECT DISTINCT
                              -- 10000; "Результат основной деятельности"
                              zc_Enum_ProfitLossGroup_10000()     AS ProfitLossGroupId
                              -- 10300; "Скидка дополнительная"
                            , zc_Enum_ProfitLossDirection_10300() AS ProfitLossDirectionId 
                              --
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId
                            , _tmpItem.BranchId

                       FROM (SELECT DISTINCT
                                    _tmpItem.InfoMoneyDestinationId
                                  , _tmpItem.BusinessId
                                  , _tmpItem.BranchId
                             FROM _tmpItem
                             -- !!!нельзя ограничивать, т.к. проводки для отчета будем делать всегда!!!
                             -- WHERE _tmpItem.OperSumm_Partner <> 0
                            ) AS _tmpItem

                      ) AS _tmpItem_group

                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination

     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId             = _tmpItem_byDestination.BusinessId
      ;


     -- 1.2. формируются Проводки - Прибыль (Скидка дополнительная)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- Сумма возвратов
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- прибыль текущего периода
            , 0                                       AS AnalyzerId               -- zc_Enum_AnalyzerId_SaleSumm_10300() AS AnalyzerId -- !!!Сумма, реализация, Скидка дополнительная!!!
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer
            , 0                                       AS WhereObjectId_Analyzer   -- в этом док-те это св-во неизвестно
            , 0                                       AS ContainerId_Analyzer     -- в ОПиУ не нужен
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- вид товара
            , vbToId                                  AS ObjectExtId_Analyzer     -- покупатель
            , _tmpItem_group.ContainerId_To           AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItem.MovementItemId               AS MovementItemId
                  , _tmpItem.ContainerId_ProfitLoss_10300 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_To               AS ContainerId_To
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , (_tmpItem.OperSumm_Partner)           AS OperSumm
             FROM _tmpItem
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0
      ;


     -- 3.1. определяется Счет(справочника) для проводок по долг Покупателя или Физ.лица (недостачи, порча)
     UPDATE _tmpItem SET AccountId_To = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- Дебиторы
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT
                        -- покупатели
                        zc_Enum_AccountDirection_30100() AS AccountDirectionId
                      , vbInfoMoneyDestinationId_To      AS InfoMoneyDestinationId
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!нельзя ограничивать, т.к. этот AccountId в проводках для отчета!!!
                ) AS _tmpItem_group

          ) AS _tmpItem_byAccount
      ;

     -- 3.2. определяется ContainerId для проводок по долг Покупателя или Физ.лица (недостачи, порча)
     UPDATE _tmpItem SET ContainerId_To = tmp.ContainerId
     FROM (SELECT -- 0.1.Счет 0.2.Главное Юр лицо 0.3.Бизнес 1.Юридические лица 2.Виды форм оплаты 3.Договора 4.Статьи назначения 5.Партии накладной
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId
                                        , inJuridicalId_basis := tmp.JuridicalId_Basis
                                        , inBusinessId        := NULL
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
                                         ) AS ContainerId
           FROM (SELECT DISTINCT
                        _tmpItem.AccountId_To         AS AccountId
                      , vbToId                        AS JuridicalId
                      , vbContractId_To               AS ContractId
                      , vbInfoMoneyId_To              AS InfoMoneyId
                      , vbPaidKindId_To               AS PaidKindId
                      , vbJuridicalId_Basis_To        AS JuridicalId_Basis
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner <> 0 !!!нельзя ограничивать, т.к. этот ContainerId в проводках для отчета!!!
                ) AS tmp

          ) AS tmp;

     -- 3.3. формируются Проводки - долг Покупателя или Физ.лица (недостачи, порча) + !!!не добавлен MovementItemId!!! + !!!добавлен GoodsId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       -- это обычная проводка
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_To
            , _tmpItem.AccountId_To        AS AccountId
            , zc_Enum_AnalyzerId_SaleSumm_10300()     AS AnalyzerId               -- !!!Сумма, реализация, Скидка дополнительная!!!
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , 0                                       AS WhereObjectId_Analyzer
            , _tmpItem.ContainerId_To                 AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- вид товара
            , vbToId                                  AS ObjectExtId_Analyzer     -- покупатель
            , _tmpItem.ContainerId_ProfitLoss_10300   AS ContainerIntId_Analyzer  -- Контейнер "товар"
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperSumm_Partner
            , vbOperDate AS OperDate
            , FALSE
       FROM _tmpItem
       -- !!!нельзя ограничивать, т.к. на этих проводках строятся отчеты!!!
       -- WHERE _tmpItem_group.OperSumm <> 0 -- !!!ограничение - пустые проводки не формируются!!!
     ;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ChangePercent()
                                , inUserId     := inUserId
                                 );

 

/*RAISE EXCEPTION 'Ошибка.<%>  %   %   %'
 , (select sum (OperSumm_Partner_noDiscount) from _tmpItem)
 , (select sum (OperSumm_Partner_Discount) from _tmpItem)
 , (select sum (OperSumm_Partner) from _tmpItem)
 , vbOperSumm_Partner
  ;*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 267275 , inSession:= '2')
-- SELECT * FROM gpUpdate_Status_ChangePercent (inMovementId:= 24743082, ioStatusCode:= 2, inSession := zfCalc_UserAdmin() );
