DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId          Integer;
  DECLARE vbStatusId                Integer;
  DECLARE vbOperDate                TDateTime;
  DECLARE vbClientId                Integer;
  DECLARE vbClientId_VAT            Integer;
  DECLARE vbUnitId                  Integer;
  DECLARE vbPaidKindId              Integer;
  DECLARE vbInfoMoneyId_Client      Integer;
  DECLARE vbInfoMoneyId_Client_VAT  Integer;
  DECLARE vbJuridicalId_Basis       Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId              Integer; -- значение пока НЕ определяется
  DECLARE vbMovementId_order        Integer; -- 
  
  DECLARE vbPriceWithVAT            Boolean;
  DECLARE vbVATPercent              TFloat;
  DECLARE vbSummMVAT_calc           TFloat;

  DECLARE vbTotalSumm_transport     TFloat;  -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
  DECLARE vbTotalSumm_10101         TFloat;  -- Сумма по ценам продажи
  DECLARE vbTotalSumm_10201         TFloat;  -- Скидка клиента
  DECLARE vbTotalSumm_10202         TFloat;  -- Скидка дополнительная
  DECLARE vbTotalSumm_10704         TFloat;  -- услуги предоставленные - Транспорт
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummClient;
     -- !!!обязательно!!! очистили таблицу - элементы документа
     DELETE FROM _tmpItem_Master_mi;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_Master;
 

     -- 1.0. Параметр из документа
     vbClientId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());

     -- Пересохранили VATPercent
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0))
     FROM ObjectLink AS OL_Client_TaxKind
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = OL_Client_TaxKind.ChildObjectId 
                               AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
     WHERE OL_Client_TaxKind.ObjectId = vbClientId
       AND OL_Client_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()
    ;


     -- 1.1. Параметры из документа
     SELECT tmp.MovementDescId, tmp.StatusId, tmp.OperDate, tmp.MovementId_order, tmp.ClientId, tmp.ClientId_VAT
          , tmp.UnitId, tmp.PaidKindId
          , tmp.InfoMoneyId_Client, tmp.InfoMoneyId_Client_VAT
          , tmp.PriceWithVAT, tmp.VATPercent
          , tmp.TotalSumm_transport
          , tmp.TotalSumm_10101
          , tmp.TotalSumm_10201
          , tmp.TotalSumm_10202
          , tmp.TotalSumm_10704

            INTO vbMovementDescId, vbStatusId
               , vbOperDate
               , vbMovementId_order
               , vbClientId, vbClientId_VAT
               , vbUnitId
               , vbPaidKindId
               , vbInfoMoneyId_Client, vbInfoMoneyId_Client_VAT
               , vbPriceWithVAT, vbVATPercent
                 -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
               , vbTotalSumm_transport
                 -- Сумма по ценам продажи
               , vbTotalSumm_10101
                 -- Скидка клиента
               , vbTotalSumm_10201
                 -- Скидка дополнительная
               , vbTotalSumm_10202
                 -- услуги предоставленные - Транспорт
               , vbTotalSumm_10704

     FROM (WITH tmpSelect_Product AS (SELECT gpSelect.MovementId_OrderClient
                                             -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
                                           , gpSelect.Basis_summ_orig
                                             -- Cумма откорректированной скидки, без НДС (доп.скидка)
                                           , gpSelect.SummTax
                                             -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
                                           , gpSelect.Basis_summ_transport
                                             -- load Сумма транспорт с сайта
                                           , gpSelect.TransportSumm_load

                                             -- ИТОГО Сумма Скидка № 1 (Basis) - без НДС
                                           , gpSelect.SummDiscount1
                                             -- ИТОГО Сумма Скидка № 1 (options) - без НДС
                                           , gpSelect.SummDiscount1_opt

                                      FROM gpSelect_Object_Product ((SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId), FALSE, FALSE, '') AS gpSelect
                                     )
           SELECT Movement.DescId AS MovementDescId
                , Movement.StatusId
                , Movement.OperDate
                  -- Заказ Клиента
                , Movement.ParentId AS MovementId_order

                  -- Client
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Client() THEN Object_To.Id   ELSE 0 END, 0) AS ClientId
                  -- Client Official Tax - кому выставляем долг за НДС
                , zc_Partner_VAT() AS ClientId_VAT
                  --
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId

                , COALESCE (MovementLinkObject_PaidKind.ObjectId, zc_Enum_PaidKind_FirstForm()) AS PaidKindId

                  -- УП-статья - Продажа лодки
                , COALESCE (ObjectLink_Client_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_30101()) AS InfoMoneyId_Client
                  -- УП-статья - Client Official Tax
                , zc_Enum_InfoMoney_50501() AS InfoMoneyId_Client_VAT -- Расчеты Налоги + НДС

                , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
                , COALESCE (MovementFloat_VATPercent.ValueData, 0)         AS VATPercent

                 -- ИТОГО с учетом всех скидок и Транспорта, Сумма продажи без НДС
                , tmpSelect_Product.Basis_summ_transport AS TotalSumm_transport

                  -- Сумма по ценам продажи
                , tmpSelect_Product.Basis_summ_orig AS TotalSumm_10101

                  -- Скидка клиента
                , tmpSelect_Product.SummDiscount1 + tmpSelect_Product.SummDiscount1_opt AS TotalSumm_10201

                  -- Скидка дополнительная
                , (tmpSelect_Product.Basis_summ_orig - (-- здесь скидка 1 + 2 + доп.скидка + Транспорт
                                                        tmpSelect_Product.Basis_summ_transport
                                                       --  минус Транспорт
                                                      - tmpSelect_Product.TransportSumm_load
                                                       )
                                                       --  Добавили скидку 1
                                                     - (tmpSelect_Product.SummDiscount1 + tmpSelect_Product.SummDiscount1_opt)
                  ) AS TotalSumm_10202

                 -- услуги предоставленные - Транспорт
               , tmpSelect_Product.TransportSumm_load AS TotalSumm_10704

           FROM Movement
                LEFT JOIN tmpSelect_Product ON tmpSelect_Product.MovementId_OrderClient > 0

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                        ON MovementFloat_VATPercent.MovementId = Movement.Id
                                       AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()

                LEFT JOIN ObjectLink AS ObjectLink_Client_InfoMoney
                                     ON ObjectLink_Client_InfoMoney.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_Client_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()

                -- св-во из Заказ Клиента
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.ParentId
                                            AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                -- св-во из Заказ Клиента
                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                          ON MovementBoolean_PriceWithVAT.MovementId = Movement.ParentId
                                         AND MovementBoolean_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Sale()
           --AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- проверка
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;


     -- 1.2. заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_Master_mi (MovementItemId
                                   , GoodsId
                                   , Amount, OperSumm, OperSumm_VAT
                                   , OperSumm_10101, OperSumm_10201, OperSumm_10202, OperSumm_10704
                                   , PartNumber
                                   , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                    )
        -- результат21:20 17.08.2023
        SELECT tmp.MovementItemId

             , tmp.GoodsId
             , tmp.Amount

               -- конечная сумма без НДС, с учетом ВСЕХ скидок + транспорт
             , tmp.OperSumm
               -- Сумма НДС - потом это все расчитаем
             , 0 AS OperSumm_VAT

               -- Сумма по ценам продажи - потом это все расчитаем
             , 0 AS OperSumm_10101
               -- Скидка клиента - потом это все расчитаем
             , 0 AS OperSumm_10201
              -- Скидка дополнительная - потом это все расчитаем
             , 0 AS OperSumm_10202
              -- Транспорт - потом это все расчитаем
             , 0 AS OperSumm_10704
             
             , tmp.PartNumber

               -- УП для Goods
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                    AS MovementItemId
                   , MovementItem.ObjectId              AS GoodsId
                   , MovementItem.Amount                AS Amount

                     -- Сумма продажи без НДС, с учетом ВСЕХ скидок + транспорт
                   , MovementItem.Amount * CASE WHEN vbPriceWithVAT = TRUE THEN zfCalc_Summ_NoVAT (MIFloat_OperPrice.ValueData, vbVATPercent) ELSE COALESCE (MIFloat_OperPrice.ValueData, 0) END AS OperSumm

                   , MIString_PartNumber.ValueData AS PartNumber

                     -- Управленческая группа
                   , View_InfoMoney.InfoMoneyGroupId
                     -- Управленческие назначения
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- Статьи назначения
                   , View_InfoMoney.InfoMoneyId

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE

                   LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                               ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()

                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!ВРЕМЕННО!!! Доходы + Продажа лодки
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_30101())

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;

     -- 1.3. заполняем таблицу - элементы Master документа
     INSERT INTO _tmpItem_Master (MovementItemId
                                , GoodsId, PartionId
                                , ContainerId_Summ, ContainerId_Goods
                                , AccountId
                                , ProfitLossId_10101, ProfitLossId_10201, ProfitLossId_10202, ProfitLossId_10301, ProfitLossId_10704
                                , ContainerId_10101, ContainerId_10201, ContainerId_10202, ContainerId_10301, ContainerId_10704
                                , Amount, OperSumm_10301
                                , MovementId_order
                                 )
        SELECT _tmpItem_Master_mi.MovementItemId
             , _tmpItem_Master_mi.GoodsId
             , Container.PartionId
             , Container_Summ.Id         AS ContainerId_Summ
             , Container.Id              AS ContainerId_Goods
             , Container_Summ.ObjectId   AS AccountId
               -- ОПиУ - надо будет потом использовать lpInsertFind_Object_ProfitLoss
             , zc_Enum_ProfitLoss_10101() AS ProfitLossId_10101, zc_Enum_ProfitLoss_10201() AS ProfitLossId_10201, zc_Enum_ProfitLoss_10202() AS ProfitLossId_10202, zc_Enum_ProfitLoss_10301() AS ProfitLossId_10301, zc_Enum_ProfitLoss_10704() AS ProfitLossId_10704
               -- сформируем позже
             , 0 AS ContainerId_10101, 0 AS ContainerId_10201, 0 AS ContainerId_10202, 0 AS ContainerId_10301, 0 AS ContainerId_10704
               -- кол-во
             , _tmpItem_Master_mi.Amount AS Amount
               -- Себестоимость реализации
             , Container_Summ.Amount     AS OperSumm_10301
               -- партия заказа
             , vbMovementId_order        AS MovementId_order

        FROM _tmpItem_Master_mi
             JOIN Container ON Container.ObjectId      = _tmpItem_Master_mi.GoodsId
                           AND Container.DescId        = zc_Container_Count()
                           AND Container.WhereObjectId = vbUnitId
             JOIN ContainerLinkObject AS CLO_PartionMovement
                                      ON CLO_PartionMovement.ContainerId = Container.Id
                                     AND CLO_PartionMovement.DescId      = zc_ContainerLinkObject_PartionMovement()
             JOIN Object AS Object_PartionMovement ON Object_PartionMovement.Id = CLO_PartionMovement.ObjectId
                                                  -- партия по этому заказу
                                                  AND Object_PartionMovement.ObjectCode = vbMovementId_order
             LEFT JOIN Container AS Container_Summ
                                 ON Container_Summ.ParentId = Container.Id
                                AND Container_Summ.DescId   = zc_Container_Summ()
                               ;

     -- 2.1.1. Сумма без НДС, с учетом скидки ...
     vbSummMVAT_calc:= (SELECT SUM (_tmpItem_Master_mi.OperSumm) FROM _tmpItem_Master_mi);
     -- 2.1.2. распределяем Сумма НДС .....
     UPDATE _tmpItem_Master_mi SET OperSumm_VAT = CASE WHEN vbSummMVAT_calc > 0
                                                       THEN zfCalc_SummVATDiscountTax (vbTotalSumm_transport, 0, vbVATPercent) * _tmpItem_Master_mi.OperSumm / vbSummMVAT_calc
                                                       ELSE 0
                                                  END;
     -- 2.1.3. корректируем на "погрешность округления"
     UPDATE _tmpItem_Master_mi SET OperSumm_VAT = _tmpItem_Master_mi.OperSumm_VAT                                        -- корректируем эту сумму на...
                                                - (SELECT SUM (_tmpItem_Master_mi.OperSumm_VAT) FROM _tmpItem_Master_mi) -- итоговая новая сумма
                                                + zfCalc_SummVATDiscountTax (vbTotalSumm_transport, 0, vbVATPercent)     -- а должна быть такая сумма
     WHERE _tmpItem_Master_mi.MovementItemId = (SELECT _tmpItem_Master_mi.MovementItemId FROM _tmpItem_Master_mi ORDER BY _tmpItem_Master_mi.OperSumm DESC LIMIT 1);

     -- 2.2.1. распределяем ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
     UPDATE _tmpItem_Master_mi SET OperSumm = CASE WHEN vbSummMVAT_calc > 0
                                         THEN vbTotalSumm_transport * _tmpItem_Master_mi.OperSumm / vbSummMVAT_calc
                                         ELSE 0
                                    END;
                                        
     -- 2.2.2. корректируем на "погрешность округления"
     UPDATE _tmpItem_Master_mi SET OperSumm = _tmpItem_Master_mi.OperSumm                                        -- корректируем эту сумму на...
                                            - (SELECT SUM (_tmpItem_Master_mi.OperSumm) FROM _tmpItem_Master_mi) -- итоговая новая сумма
                                            + vbTotalSumm_transport                                              -- а должна быть такая сумма
     WHERE _tmpItem_Master_mi.MovementItemId = (SELECT _tmpItem_Master_mi.MovementItemId FROM _tmpItem_Master_mi ORDER BY _tmpItem_Master_mi.OperSumm DESC LIMIT 1);

     -- 2.2.1. распределяем Сумма по ценам продажи - 10101
     UPDATE _tmpItem_Master_mi SET OperSumm_10101 = CASE WHEN vbSummMVAT_calc > 0
                                         THEN vbTotalSumm_10101 * _tmpItem_Master_mi.OperSumm / vbSummMVAT_calc
                                         ELSE 0
                                    END;
     -- 2.3.2. корректируем на "погрешность округления"
     UPDATE _tmpItem_Master_mi SET OperSumm_10101 = _tmpItem_Master_mi.OperSumm_10101                                  -- корректируем эту сумму на...
                                            - (SELECT SUM (_tmpItem_Master_mi.OperSumm_10101) FROM _tmpItem_Master_mi) -- итоговая новая сумма
                                            + vbTotalSumm_10101                                                        -- а должна быть такая сумма
     WHERE _tmpItem_Master_mi.MovementItemId = (SELECT _tmpItem_Master_mi.MovementItemId FROM _tmpItem_Master_mi ORDER BY _tmpItem_Master_mi.OperSumm DESC LIMIT 1);

     -- 2.4.1. распределяем Скидка клиента - 10201
     UPDATE _tmpItem_Master_mi SET OperSumm_10201 = CASE WHEN vbSummMVAT_calc > 0
                                         THEN vbTotalSumm_10201 * _tmpItem_Master_mi.OperSumm / vbSummMVAT_calc
                                         ELSE 0
                                    END;
     -- 2.4.2. корректируем на "погрешность округления"
     UPDATE _tmpItem_Master_mi SET OperSumm_10201 = _tmpItem_Master_mi.OperSumm_10201                                  -- корректируем эту сумму на...
                                            - (SELECT SUM (_tmpItem_Master_mi.OperSumm_10201) FROM _tmpItem_Master_mi) -- итоговая новая сумма
                                            + vbTotalSumm_10201                                                        -- а должна быть такая сумма
     WHERE _tmpItem_Master_mi.MovementItemId = (SELECT _tmpItem_Master_mi.MovementItemId FROM _tmpItem_Master_mi ORDER BY _tmpItem_Master_mi.OperSumm DESC LIMIT 1);

     -- 2.5.1. распределяем Скидка дополнительная - 10202
     UPDATE _tmpItem_Master_mi SET OperSumm_10202 = CASE WHEN vbSummMVAT_calc > 0
                                         THEN vbTotalSumm_10202 * _tmpItem_Master_mi.OperSumm / vbSummMVAT_calc
                                         ELSE 0
                                    END;
     -- 2.5.2. корректируем на "погрешность округления"
     UPDATE _tmpItem_Master_mi SET OperSumm_10202 = _tmpItem_Master_mi.OperSumm_10202                                  -- корректируем эту сумму на...
                                            - (SELECT SUM (_tmpItem_Master_mi.OperSumm_10202) FROM _tmpItem_Master_mi) -- итоговая новая сумма
                                            + vbTotalSumm_10202                                                        -- а должна быть такая сумма
     WHERE _tmpItem_Master_mi.MovementItemId = (SELECT _tmpItem_Master_mi.MovementItemId FROM _tmpItem_Master_mi ORDER BY _tmpItem_Master_mi.OperSumm DESC LIMIT 1);

     -- 2.6.1. распределяем услуги предоставленные - Транспорт - 10704
     UPDATE _tmpItem_Master_mi SET OperSumm_10704 = CASE WHEN vbSummMVAT_calc > 0
                                         THEN vbTotalSumm_10704 * _tmpItem_Master_mi.OperSumm / vbSummMVAT_calc
                                         ELSE 0
                                    END;
     -- 2.6.2. корректируем на "погрешность округления"
     UPDATE _tmpItem_Master_mi SET OperSumm_10704 = _tmpItem_Master_mi.OperSumm_10704                                  -- корректируем эту сумму на...
                                            - (SELECT SUM (_tmpItem_Master_mi.OperSumm_10704) FROM _tmpItem_Master_mi) -- итоговая новая сумма
                                            + vbTotalSumm_10704                                                        -- а должна быть такая сумма
     WHERE _tmpItem_Master_mi.MovementItemId = (SELECT _tmpItem_Master_mi.MovementItemId FROM _tmpItem_Master_mi ORDER BY _tmpItem_Master_mi.OperSumm DESC LIMIT 1);



     -- 3.1. заполняем таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_SummClient (MovementItemId, ContainerId, AccountId, ContainerId_VAT, AccountId_VAT, GoodsId, PartionId, OperSumm, OperSumm_VAT)
        SELECT tmpItem.MovementItemId
             , 0 AS ContainerId, 0 AS AccountId
             , 0 AS ContainerId_VAT, 0 AS AccountId_VAT
             , tmpItem.GoodsId
             , _tmpItem_Master.PartionId
               -- Поставщику - Сумма с НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка + Транспорт
             , (tmpItem.OperSumm + tmpItem.OperSumm_VAT) AS OperSumm
               -- в налоговую - Сумма НДС
             , tmpItem.OperSumm_VAT AS OperSumm_VAT
        FROM _tmpItem_Master_mi AS tmpItem
             LEFT JOIN _tmpItem_Master ON _tmpItem_Master.MovementItemId = tmpItem.MovementItemId
       ;

     -- 3.2. определяется Счет(справочника) для проводок по долг Клиенту + НДС
     UPDATE _tmpItem_SummClient SET AccountId     = _tmpItem_byAccount.AccountId
                                  , AccountId_VAT = _tmpItem_byAccount.AccountId_VAT
     FROM
          (SELECT -- Клиент
                  lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                  -- НДС
                , CASE WHEN _tmpItem_group.OperSumm_VAT <> 0 THEN
                  lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId_VAT
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId_VAT
                                             , inInfoMoneyDestinationId := View_InfoMoney_VAT.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              )
                  END AS AccountId_VAT

           FROM (SELECT zc_Enum_AccountGroup_20000()      AS AccountGroupId     -- Дебиторы
                      , zc_Enum_AccountDirection_20100()  AS AccountDirectionId -- покупатели
                      , vbInfoMoneyId_Client             AS InfoMoneyId
                        --
                      , zc_Enum_AccountGroup_80000()      AS AccountGroupId_VAT     -- Расчеты Налоги
                      , zc_Enum_AccountDirection_80500()  AS AccountDirectionId_VAT -- НДС
                      , vbInfoMoneyId_Client_VAT          AS InfoMoneyId_VAT

                      , SUM (_tmpItem_SummClient.OperSumm_VAT) AS OperSumm_VAT
                 FROM _tmpItem_SummClient
                ) AS _tmpItem_group
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney     ON View_InfoMoney.InfoMoneyId     = _tmpItem_group.InfoMoneyId
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_VAT ON View_InfoMoney_VAT.InfoMoneyId = _tmpItem_group.InfoMoneyId_VAT
        ) AS _tmpItem_byAccount
      WHERE 1=1;


     -- 3.3. определяется ContainerId для проводок по долг Клиенту
     UPDATE _tmpItem_SummClient SET ContainerId          = tmp.ContainerId
                                  , ContainerId_VAT      = tmp.ContainerId_VAT
     FROM (SELECT tmp.AccountId
                  -- Клиент
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId
                                        , inPartionId         := NULL
                                        , inIsReserve         := FALSE
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Client()
                                        , inObjectId_1        := vbClientId
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := vbInfoMoneyId_Client
                                         ) AS ContainerId
                  -- НДС
                , CASE WHEN tmp.AccountId_VAT > 0 THEN
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId_VAT
                                        , inPartionId         := NULL
                                        , inIsReserve         := FALSE
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner() -- !!!не ошибка, долги НДС у zc_Object_Partner!!!
                                        , inObjectId_1        := vbClientId_VAT
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := vbInfoMoneyId_Client_VAT
                                         )
                  ELSE 0
                  END AS ContainerId_VAT
           FROM (SELECT DISTINCT
                        _tmpItem_SummClient.AccountId
                      , _tmpItem_SummClient.AccountId_VAT
                 FROM _tmpItem_SummClient
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummClient.AccountId = tmp.AccountId
    ;

     -- 4. определяется ContainerId для ОПиУ
     UPDATE _tmpItem_Master SET ContainerId_10101 = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                                          , inParentId          := NULL                     -- Главный Container
                                                                          , inObjectId          := zc_Enum_Account_90301()  -- Объект всегда Счет для Суммовой учет
                                                                          , inPartionId         := NULL
                                                                          , inIsReserve         := FALSE
                                                                          , inJuridicalId_basis := vbJuridicalId_Basis      -- Главное юридическое лицо
                                                                          , inBusinessId        := vbBusinessId             -- Бизнесы
                                                                          , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                                          , inObjectId_1        := _tmpItem_Master.ProfitLossId_10101
                                                                           )
                              , ContainerId_10201 = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                                          , inParentId          := NULL                     -- Главный Container
                                                                          , inObjectId          := zc_Enum_Account_90301()  -- Объект всегда Счет для Суммовой учет
                                                                          , inPartionId         := NULL
                                                                          , inIsReserve         := FALSE
                                                                          , inJuridicalId_basis := vbJuridicalId_Basis      -- Главное юридическое лицо
                                                                          , inBusinessId        := vbBusinessId             -- Бизнесы
                                                                          , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                                          , inObjectId_1        := _tmpItem_Master.ProfitLossId_10201
                                                                           )
                              , ContainerId_10202 = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                                          , inParentId          := NULL                     -- Главный Container
                                                                          , inObjectId          := zc_Enum_Account_90301()  -- Объект всегда Счет для Суммовой учет
                                                                          , inPartionId         := NULL
                                                                          , inIsReserve         := FALSE
                                                                          , inJuridicalId_basis := vbJuridicalId_Basis      -- Главное юридическое лицо
                                                                          , inBusinessId        := vbBusinessId             -- Бизнесы
                                                                          , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                                          , inObjectId_1        := _tmpItem_Master.ProfitLossId_10202
                                                                           )
                              , ContainerId_10301 = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                                          , inParentId          := NULL                     -- Главный Container
                                                                          , inObjectId          := zc_Enum_Account_90301()  -- Объект всегда Счет для Суммовой учет
                                                                          , inPartionId         := NULL
                                                                          , inIsReserve         := FALSE
                                                                          , inJuridicalId_basis := vbJuridicalId_Basis      -- Главное юридическое лицо
                                                                          , inBusinessId        := vbBusinessId             -- Бизнесы
                                                                          , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                                          , inObjectId_1        := _tmpItem_Master.ProfitLossId_10301
                                                                           )
                              , ContainerId_10704 = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                                          , inParentId          := NULL                     -- Главный Container
                                                                          , inObjectId          := zc_Enum_Account_90301()  -- Объект всегда Счет для Суммовой учет
                                                                          , inPartionId         := NULL
                                                                          , inIsReserve         := FALSE
                                                                          , inJuridicalId_basis := vbJuridicalId_Basis      -- Главное юридическое лицо
                                                                          , inBusinessId        := vbBusinessId             -- Бизнесы
                                                                          , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                                          , inObjectId_1        := _tmpItem_Master.ProfitLossId_10704
                                                                           )
     FROM _tmpItem_Master_mi
     WHERE _tmpItem_Master.MovementItemId = _tmpItem_Master_mi.MovementItemId
    ;


     -- 5.1. формируются Проводки - остаток количество
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - РАСХОД кол-во
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Master.MovementItemId
            , _tmpItem_Master.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_Master.AccountId               AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Клиент
            , _tmpItem_Master.ContainerId_10301       AS ContainerId_Analyzer   -- Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10301      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , -1 * _tmpItem_Master.Amount             AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
      ;

     -- 5.2. формируются Проводки - остаток с/с сумма
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - РАСХОД с/с
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Master.MovementItemId
            , _tmpItem_Master.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_Master.AccountId               AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ОПиУ
            , _tmpItem_Master.ContainerId_10301       AS ContainerId_Analyzer   -- Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10301      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , -1 * _tmpItem_Master.OperSumm_10301     AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId

      UNION ALL
       -- проводки - с/с в ОПиУ
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Master.MovementItemId
            , _tmpItem_Master.ContainerId_10301
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_Master.AccountId               AS AccountId_Analyzer     -- Счет - корреспондент - Товар
            , _tmpItem_Master.ContainerId_Summ        AS ContainerId_Analyzer   -- Контейнер корреспондент - Товар
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10301      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            ,  1 * _tmpItem_Master.OperSumm_10301     AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- Всегда для ОПиУ
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
           ;


     -- 5.2. формируются Проводки - сумма по Клиенту
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- 1.1. проводки Долг - Сумма по ценам продажи
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Клиент
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ОПиУ
            , _tmpItem_Master.ContainerId_10101       AS ContainerId_Analyzer   -- Контейнер корреспондент - ОПиУ
            , 0                                       AS ContainerExtId_Analyzer-- ???Контейнер - Корреспондент - Товар???
            , _tmpItem_Master.ProfitLossId_10101      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Место учета
            , 1 * _tmpItem_Master_mi.OperSumm_10101   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId

      UNION ALL
       -- 1.2. проводки в ОПиУ - Сумма по ценам продажи
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_Master.ContainerId_10101
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Клиент
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10101      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , -1 * _tmpItem_Master_mi.OperSumm_10101  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- Всегда для ОПиУ
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId


      UNION ALL
       -- 2.1. проводки Долг - Скидка клиента
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Клиент
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ОПиУ
            , _tmpItem_Master.ContainerId_10201       AS ContainerId_Analyzer   -- Контейнер корреспондент - ОПиУ
            , 0                                       AS ContainerExtId_Analyzer-- ???Контейнер - Корреспондент - Товар???
            , _tmpItem_Master.ProfitLossId_10201      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Место учета
            , -1 * _tmpItem_Master_mi.OperSumm_10201  AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId

      UNION ALL
       -- 2.2. проводки в ОПиУ - Скидка клиента
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_Master.ContainerId_10201
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Клиент
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10201      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , 1 * _tmpItem_Master_mi.OperSumm_10201   AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- Всегда для ОПиУ
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId

      UNION ALL
       -- 3.1. проводки Долг - Скидка дополнительная
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Клиент
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ОПиУ
            , _tmpItem_Master.ContainerId_10202       AS ContainerId_Analyzer   -- Контейнер корреспондент - ОПиУ
            , 0                                       AS ContainerExtId_Analyzer-- ???Контейнер - Корреспондент - Товар???
            , _tmpItem_Master.ProfitLossId_10202      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Место учета
            , -1 * _tmpItem_Master_mi.OperSumm_10202  AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId

      UNION ALL
       -- 3.2. проводки в ОПиУ - Скидка дополнительная
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_Master.ContainerId_10202
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Клиент
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10202      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , 1 * _tmpItem_Master_mi.OperSumm_10202  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- Всегда для ОПиУ
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId


      UNION ALL
       -- 4.1. проводки Долг - Транспорт
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Клиент
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ОПиУ
            , _tmpItem_Master.ContainerId_10704       AS ContainerId_Analyzer   -- Контейнер корреспондент - ОПиУ
            , 0                                       AS ContainerExtId_Analyzer-- ???Контейнер - Корреспондент - Товар???
            , _tmpItem_Master.ProfitLossId_10704      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Место учета
            , 1 * _tmpItem_Master_mi.OperSumm_10704   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId

      UNION ALL
       -- 4.2. проводки в ОПиУ - Транспорт
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_Master.ContainerId_10704
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Клиент
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , _tmpItem_Master.ProfitLossId_10704      AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , -1 * _tmpItem_Master_mi.OperSumm_10704  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- Всегда для ОПиУ
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
            JOIN _tmpItem_Master_mi  ON _tmpItem_Master_mi.MovementItemId  = _tmpItem_Master.MovementItemId


      UNION ALL
       -- 5.1. проводки Долг - НДС
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Клиент
            , _tmpItem_SummClient.AccountId_VAT       AS AccountId_Analyzer     -- Счет - корреспондент - ОПиУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId_VAT     AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId_VAT                          AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , 1 * _tmpItem_SummClient.OperSumm_VAT    AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
       WHERE _tmpItem_SummClient.OperSumm_VAT <> 0

      UNION ALL
       -- 5.2. проводки Долг - НДС
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_VAT
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId_VAT       AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Master.GoodsId                 AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Master.PartionId               AS PartionId              -- Партия
            , vbClientId_VAT                          AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Клиент
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер корреспондент - ОПиУ
            , _tmpItem_SummClient.ContainerId         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - Клиент
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник - статья ОПиУ или ...
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Корреспондент - Клиент
            , -1 * _tmpItem_SummClient.OperSumm_VAT   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive               -- 
       FROM _tmpItem_Master
            JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem_Master.MovementItemId
       WHERE _tmpItem_SummClient.OperSumm_VAT <> 0
      ;


     /*RAISE EXCEPTION 'Ошибка.%OperSumm_VAT = <%>  %OperSumm = <%>  %OperSumm_10101 = <%>  %OperSumm_10201 = <%>  %OperSumm_10202 = <%>  %OperSumm_10704 = <%>  %OperSumm_10301 = <%>  %vbTotalSumm_transport = <%>  %vbMovementId_order = <%>'
                   , CHR (13), (select sum(OperSumm_VAT) from _tmpItem_Master_mi)
                   , CHR (13), (select sum(OperSumm) from _tmpItem_Master_mi)
                   , CHR (13), (select sum(OperSumm_10101) from _tmpItem_Master_mi)
                   , CHR (13), (select sum(OperSumm_10201) from _tmpItem_Master_mi)
                   , CHR (13), (select sum(OperSumm_10202) from _tmpItem_Master_mi)
                   , CHR (13), (select sum(OperSumm_10704) from _tmpItem_Master_mi)
                   , CHR (13), (select sum(OperSumm_10301) from _tmpItem_Master)
                   , CHR (13), vbTotalSumm_transport
                   , CHR (13), vbMovementId_order
                    ;*/


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Sale()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.21         *
*/

-- тест
-- select * from gpComplete_Movement_Sale(inMovementId := 815 ,  inSession := '5');
