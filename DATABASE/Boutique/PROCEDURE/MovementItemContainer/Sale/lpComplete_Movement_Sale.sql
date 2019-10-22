-- Function: lpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId          Integer;
  DECLARE vbOperDate                TDateTime;
  DECLARE vbUnitId                  Integer;
  DECLARE vbClientId                Integer;
  DECLARE vbAccountDirectionId_From Integer;
  DECLARE vbAccountDirectionId_To   Integer;
  DECLARE vbJuridicalId_Basis       Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId              Integer; -- значение пока НЕ определяется
  DECLARE vbContainerId_err         Integer;
  DECLARE vbId_err                  Integer;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы оплаты, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpPay;
     -- !!!обязательно!!! очистили таблицу - элементы по покупателю, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummClient;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Параметры из документа
     SELECT _tmp.MovementDescId, _tmp.OperDate, _tmp.UnitId, _tmp.ClientId
          , _tmp.AccountDirectionId_From, _tmp.AccountDirectionId_To
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId
               , vbClientId
               , vbAccountDirectionId_From
               , vbAccountDirectionId_To
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN Object_From.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Client() THEN Object_To.Id   ELSE 0 END, 0) AS ClientId

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Магазины
                , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From

                  -- !!!ВСЕГДА - zc_Enum_AccountDirection_20100!!! Дебиторы + Покупатели
                , zc_Enum_AccountDirection_20100() AS AccountDirectionId_To

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Sale()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased()) -- Обязательно так, т.к. в gp могла измениться Дата
          ) AS _tmp;


     -- проверка - Установлено Подразделение
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Подразделение>.';
     END IF;
     -- проверка - Установлен Покупатель
     IF COALESCE (vbClientId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Покупатель>.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperPrice, CountForPrice, OperSumm, OperSumm_Currency
                         , OperSumm_ToPay, OperSummPriceList, TotalChangePercent, TotalPay
                         , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , CurrencyValue, ParValue
                         , isGoods_Debt
                          )
        WITH -- Курс - из истории
             tmpCurrency AS (SELECT *
                             FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate      := vbOperDate
                                                                      , inCurrencyFromId:= zc_Currency_Basis()
                                                                      , inCurrencyToId  := 0
                                                                       )
                            )
            -- для Sybase
          , tmpCheck AS (SELECT Object.ObjectCode AS PartionId_MI FROM Object WHERE Object.Id IN (SELECT -12345 AS PartionId_MI
                   UNION SELECT 764132 -- select ObP.*, MovementItem.* , Movement.* from MovementItem join Object as ObP on ObP.ObjectCode = MovementItem.Id and ObP.DescId = zc_Object_PartionMI() join Movement on Movement.Id = MovementId and Movement.DescId = zc_Movement_Sale() and Movement.Operdate = '14.05.2012' where PartionId = (SELECT MovementItemId FROM Object_PartionGoods join Object on Object.Id = GoodsId and Object.ObjectCode = 69023 join Object as o2 on o2.Id = GoodsSizeId and o2.ValueData = '40')
                   UNION SELECT 764131
                   UNION SELECT 764129
                   UNION SELECT 686338
                   UNION SELECT 685769
                   UNION SELECT 685753
                   UNION SELECT 685567
                   UNION SELECT 596053
                   UNION SELECT 764134
                   UNION SELECT 764133
                   UNION SELECT 764130
                   UNION SELECT 696356
                   UNION SELECT 685616
                   UNION SELECT 592549
                   UNION SELECT 592548
                   UNION SELECT 592547
                   UNION SELECT 696906
                   UNION SELECT 685767
                   UNION SELECT 685766
                   UNION SELECT 599412
                   UNION SELECT 592546
                   UNION SELECT 764136
                   UNION SELECT 764135
                   UNION SELECT 685590
                   UNION SELECT 595497
                   UNION SELECT 592069
                         -- FROM gpSelect_MovementItem_Sale_Sybase_Check()
                        ))
        -- результат
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- сформируем позже
             , 0 AS ContainerId_Goods         -- сформируем позже
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId
             , tmp.OperCount

               -- Цена - из партии
             , tmp.OperPrice
               -- Цена за количество - из партии
             , tmp.CountForPrice

               -- Сумма по Вх. в zc_Currency_Basis
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0 -- !!!это долги!!!

                    -- с округлением до 2-х знаков
                    ELSE zfCalc_SummIn (tmp.OperCount, tmp.OperPrice_basis, tmp.CountForPrice)

               END AS OperSumm

               -- Сумма по Вх. в ВАЛЮТЕ
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0  -- !!!это долги!!!
                    ELSE tmp.OperSumm_Currency
               END AS OperSumm_Currency

               -- Сумма к Оплате
             , tmp.OperSummPriceList - tmp.TotalChangePercent AS OperSumm_ToPay

               -- Сумма по Прайсу
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN tmp.OperSummPriceList - tmp.TotalChangePercent -- подставили - Сумма к Оплате !!!т.к. это долги!!!
                    ELSE tmp.OperSummPriceList
               END AS OperSummPriceList

               -- Итого сумма Скидки
             , CASE WHEN tmp.isGoods_Debt = TRUE
                         THEN 0 -- !!!это долги!!!
                    ELSE tmp.TotalChangePercent
               END AS TotalChangePercent

               -- Итого сумма оплаты
             , tmp.TotalPay

             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10201 END -- Сезонная скидка
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10202 END -- Скидка outlet
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10203 END -- Скидка клиента
             , CASE WHEN tmp.isGoods_Debt = TRUE THEN 0 ELSE tmp.Summ_10204 END -- Скидка дополнительная

             , 0 AS AccountId -- Счет(справочника), сформируем позже

               -- УП для Sale - для определения счета Запасы
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

               -- Курс - из истории
             , COALESCE (tmp.CurrencyValue, 0) AS CurrencyValue
               -- Номинал курса - из истории
             , COALESCE (tmp.ParValue, 0)      AS ParValue

             , tmp.isGoods_Debt

        FROM (SELECT MovementItem.Id                    AS MovementItemId
                   , Object_PartionGoods.GoodsId        AS GoodsId
                   , MovementItem.PartionId             AS PartionId
                   , Object_PartionGoods.GoodsSizeId    AS GoodsSizeId
                   , MovementItem.Amount                AS OperCount
                   , Object_PartionGoods.OperPrice      AS OperPrice
                   , CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS CountForPrice
                   , Object_PartionGoods.CurrencyId     AS CurrencyId

                     -- Курс - из истории
                   , CASE WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                               THEN tmpCurrency.Amount
                          WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                               -- Здесь Деление
                               THEN 1000 * 1 / tmpCurrency.Amount
                     END AS CurrencyValue
                     -- Номинал курса - из истории
                   , CASE WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                               THEN tmpCurrency.ParValue
                          WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                               -- т.к. было Деление
                               THEN 1000 * tmpCurrency.ParValue
                     END AS ParValue

                     -- Цена Вх. - именно её переводим в zc_Currency_Basis - с округлением до 2-х знаков
                   , zfCalc_PriceIn_Basis (Object_PartionGoods.CurrencyId, Object_PartionGoods.OperPrice
                                         , CASE WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                                                     THEN tmpCurrency.Amount
                                                WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                                                     -- Здесь Деление
                                                     THEN 1000 * 1 / tmpCurrency.Amount
                                           END
                                         , CASE WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyToId
                                                     THEN tmpCurrency.ParValue
                                                WHEN Object_PartionGoods.CurrencyId = tmpCurrency.CurrencyFromId AND tmpCurrency.Amount > 0
                                                     -- т.к. было Деление
                                                     THEN 1000 * tmpCurrency.ParValue
                                           END
                                          ) AS OperPrice_basis

                     -- Сумма по Вх. в Валюте - с округлением до 2-х знаков
                   , zfCalc_SummIn (MovementItem.Amount, Object_PartionGoods.OperPrice, Object_PartionGoods.CountForPrice) AS OperSumm_Currency

                     -- Сумма по Прайсу - с округлением до 0/2-х знаков
                   , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) AS OperSummPriceList
                     -- Итого сумма Скидки (в ГРН) - только для текущего документа - суммируется 1)по %скидки + 2)дополнительная
                   , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)                          AS TotalChangePercent
                     -- Итого сумма оплаты (в ГРН) - в текущем документе по zc_MI_Child
                   , COALESCE (MIFloat_TotalPay.ValueData, 0)                                    AS TotalPay

                     -- Сезонная скидка
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Period() THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData) ELSE 0 END AS Summ_10201
                     -- Скидка outlet
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Outlet() THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData) ELSE 0 END AS Summ_10202
                     -- Скидка клиента
                   , CASE WHEN MILinkObject_DiscountSaleKind.ObjectId = zc_Enum_DiscountSaleKind_Client() THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData) ELSE 0 END AS Summ_10203
                     -- Скидка дополнительная
                   , COALESCE (MIFloat_SummChangePercent.ValueData, 0) AS Summ_10204

                     -- Управленческая группа
                   , View_InfoMoney.InfoMoneyGroupId
                     -- Управленческие назначения
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- Статьи назначения
                   , View_InfoMoney.InfoMoneyId

                   , CASE WHEN Object_PartionGoods.GoodsId = zc_Enum_Goods_Debt() THEN TRUE
                          WHEN EXISTS (SELECT 1 FROM tmpCheck WHERE tmpCheck.PartionId_MI = MovementItem.Id) THEN TRUE
                               ELSE FALSE
                     END AS isGoods_Debt

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                               ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                              AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                               ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                               ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                              AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                               ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                    ON MILinkObject_DiscountSaleKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = Object_PartionGoods.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!ВРЕМЕННО!!! Доходы + Товары + Одежда

                   LEFT JOIN tmpCurrency ON (tmpCurrency.CurrencyFromId = Object_PartionGoods.CurrencyId OR tmpCurrency.CurrencyToId = Object_PartionGoods.CurrencyId)
                                        AND Object_PartionGoods.CurrencyId <> zc_Currency_Basis()

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- проверка что оплачено НЕ больше чем надо
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay)
     THEN
         RAISE EXCEPTION 'Ошибка. Сумма к оплате = <%> больше чем сумма оплаты = <%>.', (SELECT _tmpItem.OperSumm_ToPay FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1)
                                                                                      , (SELECT _tmpItem.TotalPay       FROM _tmpItem WHERE _tmpItem.TotalPay > _tmpItem.OperSumm_ToPay ORDER BY _tmpItem.MovementItemId LIMIT 1)
         ;
     END IF;
     -- проверка что скидка та что надо
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     THEN
         RAISE EXCEPTION 'Ошибка. Скида итого <%> не равна <%>.', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
                                                                , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
         ;
     END IF;


     -- заполняем таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_SummClient (MovementItemId, ContainerId_Summ, ContainerId_Summ_20102, ContainerId_Goods, AccountId, AccountId_20102, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                    , GoodsId, PartionId, GoodsSizeId, PartionId_MI
                                    , OperCount, OperSumm, OperSumm_ToPay, TotalPay
                                    , OperCount_sale, OperSumm_sale, OperSummPriceList_sale
                                    , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                                    , ContainerId_ProfitLoss_10101, ContainerId_ProfitLoss_10201, ContainerId_ProfitLoss_10202, ContainerId_ProfitLoss_10203, ContainerId_ProfitLoss_10204, ContainerId_ProfitLoss_10301
                                     )
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ, 0 AS ContainerId_Summ_20102, 0 AS ContainerId_Goods, 0 AS AccountId, 0 AS AccountId_20102
             , tmp.InfoMoneyGroupId, tmp.InfoMoneyDestinationId, tmp.InfoMoneyId
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId

               -- определяем Партию элемента продажи/возврата
             , lpInsertFind_Object_PartionMI (tmp.MovementItemId) AS PartionId_MI

               -- все кол-во
             , tmp.OperCount

             , (tmp.OperSumm)          AS OperSumm       -- сумма по вх.
             , (tmp.OperSumm_ToPay)    AS OperSumm_ToPay -- сумма к оплате
             , (tmp.TotalPay)          AS TotalPay       -- сумма оплаты

               -- расчет кол-во которое попадает в ПРОДАЖУ - ОПИУ
             , tmp.OperCount_sale

               -- расчет с/с которое попадает в ПРОДАЖУ - ОПИУ
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.OperSumm
                    ELSE -- иначе кол-во которое попадает в ПРОДАЖУ
                         tmp.OperCount_sale
                         -- Цена с/с в ГРН - округлили до 2-х знаков
                       * ROUND (tmp.OperSumm / tmp.OperCount * 100) / 100
               END AS OperSumm_sale

               -- расчет Суммы которая попадает в ПРОДАЖУ - ОПИУ
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.OperSummPriceList
                    ELSE -- иначе кол-во которое попадает в ПРОДАЖУ
                         tmp.OperCount_sale
                         -- Цена ПРАЙС в ГРН - округлили до 2-х знаков
                       * ROUND (tmp.OperSummPriceList / tmp.OperCount * 100) / 100
               END AS OperSummPriceList_sale

               -- расчет сезонная скидка которая попадает в ПРОДАЖУ
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10201
                    ELSE -- иначе кол-во которое попадает в ПРОДАЖУ
                         tmp.OperCount_sale
                         -- Цена "скидки" в ГРН - округлили до 2-х знаков
                       * ROUND (tmp.Summ_10201 / tmp.OperCount * 100) / 100
               END AS Summ_10201

               -- расчет скидка outlet которая попадает в ПРОДАЖУ
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10202
                    ELSE -- иначе кол-во которое попадает в ПРОДАЖУ
                         tmp.OperCount_sale
                         -- Цена "скидки" в ГРН - округлили до 2-х знаков
                       * ROUND (tmp.Summ_10202 / tmp.OperCount * 100) / 100
               END AS Summ_10202

               -- расчет скидка клиента которая попадает в ПРОДАЖУ
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10203
                    ELSE -- иначе кол-во которое попадает в ПРОДАЖУ
                         tmp.OperCount_sale
                         -- Цена "скидки" в ГРН - округлили до 2-х знаков
                       * ROUND (tmp.Summ_10203 / tmp.OperCount * 100) / 100
               END AS Summ_10203

               -- расчет Скидка дополнительная которая попадает в ПРОДАЖУ
             , CASE WHEN tmp.OperSumm_ToPay = tmp.TotalPay
                         THEN tmp.Summ_10204
                    ELSE -- иначе кол-во которое попадает в ПРОДАЖУ
                         tmp.OperCount_sale
                         -- Цена "скидки" в ГРН - округлили до 2-х знаков
                       * ROUND (tmp.Summ_10204 / tmp.OperCount * 100) / 100
               END AS Summ_10204

             , 0 AS ContainerId_ProfitLoss_10101, 0 AS ContainerId_ProfitLoss_10201, 0 AS ContainerId_ProfitLoss_10202, 0 AS ContainerId_ProfitLoss_10203, 0 AS ContainerId_ProfitLoss_10204, 0 AS ContainerId_ProfitLoss_10301

        FROM (SELECT _tmpItem.*
                     -- расчет кол-во которое попадает в ПРОДАЖУ - ОПИУ
                   , CASE WHEN _tmpItem.isGoods_Debt = TRUE
                               THEN 1 -- !!!виртуально что б сразу в прибыль!!!
                          WHEN _tmpItem.OperSumm_ToPay = _tmpItem.TotalPay
                               THEN _tmpItem.OperCount
                          ELSE -- иначе Только ДОЛГ
                               0
                     END AS OperCount_sale
              FROM _tmpItem
             ) AS tmp
        ;

     -- проверка что сумма оплаты ....
     -- IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     -- THEN
     --     RAISE EXCEPTION 'Ошибка. проверка что сумма оплаты .....', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --                                                              , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --     ;
     -- END IF;


     -- заполняем таблицу - элементы оплаты, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpPay (MovementItemId, ParentId, ObjectId, ObjectDescId, CurrencyId
                        , AccountId, ContainerId, ContainerId_Currency
                        , OperSumm, OperSumm_Currency
                        , ObjectId_from
                        , AccountId_from, ContainerId_from
                        , OperSumm_from
                         )
        SELECT tmp.MovementItemId
             , tmp.ParentId
             , tmp.ObjectId
             , tmp.ObjectDescId
             , tmp.CurrencyId
             , tmp.AccountId

               -- ContainerId
             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := tmp.AccountId
                                     , inPartionId         := NULL
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := vbBusinessId
                                     , inDescId_1          := CASE WHEN tmp.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() WHEN tmp.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() END
                                     , inObjectId_1        := tmp.ObjectId
                                     , inDescId_2          := zc_ContainerLinkObject_Currency()
                                     , inObjectId_2        := tmp.CurrencyId
                                      ) AS ContainerId

               -- ContainerId_Currency
             , CASE WHEN tmp.CurrencyId <> zc_Currency_Basis() THEN
               lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                     , inParentId          := NULL
                                     , inObjectId          := tmp.AccountId
                                     , inPartionId         := NULL
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := vbBusinessId
                                     , inDescId_1          := CASE WHEN tmp.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() WHEN tmp.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() END
                                     , inObjectId_1        := tmp.ObjectId
                                     , inDescId_2          := zc_ContainerLinkObject_Currency()
                                     , inObjectId_2        := tmp.CurrencyId
                                      )
               END AS ContainerId_Currency

             , tmp.OperSumm
             , tmp.OperSumm_Currency

             , tmp.ObjectId_from
             , tmp.AccountId_from
             , CASE WHEN tmp.OperSumm_from <> 0 THEN
               lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := tmp.AccountId_from
                                     , inPartionId         := NULL
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := vbBusinessId
                                     , inDescId_1          := zc_ContainerLinkObject_Cash()
                                     , inObjectId_1        := tmp.ObjectId_from
                                     , inDescId_2          := zc_ContainerLinkObject_Currency()
                                     , inObjectId_2        := tmp.CurrencyId_from
                                      )
                         ELSE 0
               END AS ContainerId_from
             , tmp.OperSumm_from

        FROM (SELECT MovementItem.Id       AS MovementItemId
                   , MovementItem.ParentId AS ParentId
                   , MovementItem.ObjectId AS ObjectId
                   , Object.DescId         AS ObjectDescId

                   , CASE -- Денежные средства + Касса магазинов + касса*****
                          WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() AND Object.DescId = zc_Object_Cash()
                              THEN zc_Enum_Account_30201()
                          -- Денежные средства + Касса магазинов + в валюте
                          WHEN Object.DescId = zc_Object_Cash()
                              THEN zc_Enum_Account_30202()
                          -- Денежные средства + расчетный счет + расчетный счет
                          WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() AND Object.DescId = zc_Object_BankAccount()
                              THEN zc_Enum_Account_30301()
                     END AS AccountId

                     -- если надо - переведем сумму в Валюте в ГРН
                   -- , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN MovementItem.Amount ELSE ROUND (zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData), 2) END AS OperSumm
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN MovementItem.Amount ELSE ROUND (zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData), 4) END AS OperSumm
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN 0 ELSE MovementItem.Amount END AS OperSumm_Currency
                   , MILinkObject_Currency.ObjectId AS CurrencyId

                     -- Валюта для обмен
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zc_Currency_Basis()   ELSE 0 END AS CurrencyId_from
                     -- Касса в грн для обмен
                   , CASE WHEN MovementItem.ParentId IS NULL THEN MILinkObject_Cash.ObjectId ELSE 0 END AS ObjectId_from
                     -- Счет в грн для обмен всегда - Денежные средства + Касса магазинов + касса*****
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zc_Enum_Account_30201()    ELSE 0 END AS AccountId_from
                     -- Расчетная сумма в грн для обмен
                   , CASE WHEN MovementItem.ParentId IS NULL THEN zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData) ELSE 0 END AS OperSumm_from
              FROM Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Child()
                                          AND MovementItem.isErased   = FALSE
                                          AND MovementItem.Amount     <> 0
                   INNER JOIN MovementItem AS MI_Master
                                           ON MI_Master.MovementId = Movement.Id
                                          AND MI_Master.DescId     = zc_MI_Master()
                                          AND MI_Master.Id         = MovementItem.ParentId
                                          AND MI_Master.isErased   = FALSE
                   LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Cash
                                                    ON MILinkObject_Cash.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Cash.DescId         = zc_MILinkObject_Cash()
                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
        ;

     -- проверка что сумма оплаты ....
     IF  COALESCE ((SELECT SUM (_tmpItem_SummClient.TotalPay) FROM _tmpItem_SummClient), 0)
      <> COALESCE ((SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) FROM _tmpPay), 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Сумма оплаты Main <%> не равна Child <%>.', (SELECT SUM (_tmpItem_SummClient.TotalPay) FROM _tmpItem_SummClient)
                                                                            , (SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) FROM _tmpPay)
         ;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inMemberId               := NULL
                                                                                , inClientId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inPartionId              := _tmpItem.PartionId
                                                                                , inPartionId_MI           := NULL
                                                                                , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 );



     -- проверка: ОСТАТОК должен быть
     IF inUserId <> zc_User_Sybase()
     -- AND inUserId <> 1017903 -- 
     THEN
         --
         vbContainerId_err:= (WITH tmpContainer AS (SELECT Container.Id, Container.Amount
                                                    FROM _tmpItem
                                                         INNER JOIN Container ON Container.Id = _tmpItem.ContainerId_Goods
                                                         LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                                       ON CLO_Client.ContainerId = Container.Id
                                                                                      AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                    WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
         
                                                   )
                              SELECT _tmpItem.ContainerId_Goods
                              FROM _tmpItem
                                   LEFT JOIN tmpContainer ON tmpContainer.Id = _tmpItem.ContainerId_Goods
                              WHERE _tmpItem.OperCount > COALESCE (tmpContainer.Amount, 0)
                              LIMIT 1
                             );
         --
         vbId_err:= (SELECT Container.PartionId FROM Container WHERE Container.Id = vbContainerId_err);

     END IF;
     -- проверка: ОСТАТОК должен быть
     IF vbId_err > 0 AND 1=1
     THEN
        RAISE EXCEPTION 'Ошибка.Для товара <% %> р.<%> Остаток = <%>. Кол-во = <%>'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbId_err))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbId_err))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbId_err))
                      , zfConvert_FloatToString (COALESCE ((SELECT Container.Amount FROM Container WHERE Container.Id = vbContainerId_err
                                                          /*FROM Container
                                                                 LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                                               ON CLO_Client.ContainerId = Container.Id
                                                                                              AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                            WHERE Container.PartionId     = vbId_err
                                                              AND Container.DescId        = zc_Container_Count()
                                                              AND Container.WhereObjectId = vbUnitId
                                                              AND Container.Amount        > 0
                                                              AND CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                                                          */
                                                           ), 0))
                      -- , zfConvert_FloatToString (COALESCE ((SELECT _tmpItem.OperCount FROM _tmpItem WHERE _tmpItem.ContainerId_Goods = vbId_err), 0))
                      , zfConvert_FloatToString (COALESCE ((SELECT _tmpItem.OperCount FROM _tmpItem WHERE _tmpItem.PartionId = vbId_err), 0))
                       ;
     END IF;

     -- 2.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
    ;

     -- 2.2. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                              , inUnitId                 := vbUnitId
                                                                              , inMemberId               := NULL
                                                                              , inClientId               := NULL
                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                              , inBusinessId             := vbBusinessId
                                                                              , inAccountId              := _tmpItem.AccountId
                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                              , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                              , inGoodsId                := _tmpItem.GoodsId
                                                                              , inPartionId              := _tmpItem.PartionId
                                                                              , inPartionId_MI           := NULL
                                                                              , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                               );

     -- 3.1. определяется ContainerId_Goods для количественного учета по Покупателю
     UPDATE _tmpItem_SummClient SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                           , inUnitId                 := vbUnitId
                                                                                           , inMemberId               := NULL
                                                                                           , inClientId               := vbClientId
                                                                                           , inInfoMoneyDestinationId := _tmpItem_SummClient.InfoMoneyDestinationId
                                                                                           , inGoodsId                := _tmpItem_SummClient.GoodsId
                                                                                           , inPartionId              := _tmpItem_SummClient.PartionId
                                                                                           , inPartionId_MI           := _tmpItem_SummClient.PartionId_MI
                                                                                           , inGoodsSizeId            := _tmpItem_SummClient.GoodsSizeId
                                                                                           , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                            );

     -- 3.2.1. определяется Счет(справочника) для проводок по Покупателю
     UPDATE _tmpItem_SummClient SET AccountId       = _tmpItem_byAccount.AccountId
                                  , AccountId_20102 = zc_Enum_Account_20102() -- Дебиторы + покупатели + Прибыль будущих периодов

     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Дебиторы
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_SummClient.InfoMoneyDestinationId FROM _tmpItem_SummClient) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem_SummClient.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.2.2. определяется ContainerId_Summ для проводок по Покупателю
     UPDATE _tmpItem_SummClient SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                         , inUnitId                 := vbUnitId
                                                                                         , inMemberId               := NULL
                                                                                         , inClientId               := vbClientId
                                                                                         , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                         , inBusinessId             := vbBusinessId
                                                                                         , inAccountId              := _tmpItem_SummClient.AccountId
                                                                                         , inInfoMoneyDestinationId := _tmpItem_SummClient.InfoMoneyDestinationId
                                                                                         , inInfoMoneyId            := _tmpItem_SummClient.InfoMoneyId
                                                                                         , inContainerId_Goods      := _tmpItem_SummClient.ContainerId_Goods
                                                                                         , inGoodsId                := _tmpItem_SummClient.GoodsId
                                                                                         , inPartionId              := _tmpItem_SummClient.PartionId
                                                                                         , inPartionId_MI           := _tmpItem_SummClient.PartionId_MI
                                                                                         , inGoodsSizeId            := _tmpItem_SummClient.GoodsSizeId
                                                                                          )
                            , ContainerId_Summ_20102 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                         , inUnitId                 := vbUnitId
                                                                                         , inMemberId               := NULL
                                                                                         , inClientId               := vbClientId
                                                                                         , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                         , inBusinessId             := vbBusinessId
                                                                                         , inAccountId              := _tmpItem_SummClient.AccountId_20102
                                                                                         , inInfoMoneyDestinationId := _tmpItem_SummClient.InfoMoneyDestinationId
                                                                                         , inInfoMoneyId            := _tmpItem_SummClient.InfoMoneyId
                                                                                         , inContainerId_Goods      := _tmpItem_SummClient.ContainerId_Goods
                                                                                         , inGoodsId                := _tmpItem_SummClient.GoodsId
                                                                                         , inPartionId              := _tmpItem_SummClient.PartionId
                                                                                         , inPartionId_MI           := _tmpItem_SummClient.PartionId_MI
                                                                                         , inGoodsSizeId            := _tmpItem_SummClient.GoodsSizeId
                                                                                          )
                             ;

     -- 3.3. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItem_SummClient SET ContainerId_ProfitLoss_10101 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10101
                                  , ContainerId_ProfitLoss_10201 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10201
                                  , ContainerId_ProfitLoss_10202 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10202
                                  , ContainerId_ProfitLoss_10203 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10203
                                  , ContainerId_ProfitLoss_10204 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10204
                                  , ContainerId_ProfitLoss_10301 = tmpItem_byProfitLoss.ContainerId_ProfitLoss_10301
     FROM (SELECT -- для Сумма по ценам продажи
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10101() -- Сумма по ценам продажи
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10101
                  -- для Себестоимость реализации
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10301() -- Себестоимость реализации
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10301
                  -- для Сезонная скидка
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10201() -- Сезонная скидка
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10201
                  -- для Скидка outlet
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10202() -- Скидка outlet
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10202

                  -- для Скидка клиента
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10203() -- Скидка клиента
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10203

                  -- для Скидка дополнительная
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := zc_Enum_ProfitLoss_10204() -- Скидка дополнительная
                                        , inDescId_2          := zc_ContainerLinkObject_Unit()
                                        , inObjectId_2        := vbUnitId
                                         ) AS ContainerId_ProfitLoss_10204

                , tmpItem_byDestination.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_SummClient.InfoMoneyDestinationId
                 FROM _tmpItem_SummClient
                 WHERE _tmpItem_SummClient.OperCount_sale > 0
                ) AS tmpItem_byDestination
          ) AS tmpItem_byProfitLoss
     WHERE _tmpItem_SummClient.InfoMoneyDestinationId = tmpItem_byProfitLoss.InfoMoneyDestinationId;


     -- 4.1. формируются Проводки - МИНУС остаток количество Магазин
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Покупатель !!!хотя их ДВА!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerId_Analyzer   -- Контейнер - Корреспондент - Покупатель в продаже/возврат !!!хотя их ТРИ!!!
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- Контейнер - "товар"
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Покупатель
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;

     -- 4.2. формируются Проводки - МИНУС остаток сумма c/c Магазин
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbUnitId                                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Покупатель !!!хотя их ДВА!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerId_Analyzer   -- Контейнер - Корреспондент - Покупатель в продаже/возврат !!!хотя их ТРИ!!!
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Контрагент
            , -1 * _tmpItem.OperSumm                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;


     -- 5.1. формируются Проводки - ПЛЮС остаток количество у Дебиторы покупатели
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет из суммового учета
            , zc_Enum_AnalyzerId_SaleCount_10100()    AS AnalyzerId             -- Кол-во, реализация  - Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId                      AS AccountId_Analyzer     -- Счет - корреспондент - остаток
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer   -- Контейнер - Корреспондент - остаток
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- Контейнер - "товар"
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , 1 * _tmpItem_SummClient.OperCount       AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;


     -- 5.2. формируются Проводки - ПЛЮС остаток сумма c/c + прибыль у Дебиторы покупатели
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - c/c
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , zc_Enum_AnalyzerId_SaleSumm_10300()     AS AnalyzerId             -- Сумма с/с, реализация   - Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId                      AS AccountId_Analyzer     -- Счет - корреспондент - остаток
            , _tmpItem.ContainerId_Summ               AS ContainerId_Analyzer   -- Контейнер - Корреспондент - остаток
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , 1 * _tmpItem_SummClient.OperSumm        AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      UNION ALL
       -- проводки - Прибыль будущих периодов - ДОБАВИМ в остаток
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , _tmpCalc.AnalyzerId                     AS AnalyzerId             -- Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId_20102        AS AccountId_Analyzer  -- Счет - корреспондент - Прибыль будущих периодов
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerId_Analyzer-- Контейнер - Корреспондент - Прибыль будущих периодов
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , 1 * _tmpCalc.Amount                     AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_SummClient
            LEFT JOIN (-- сезонная скидка
                       SELECT _tmpItem.MovementItemId
                            , -1* _tmpItem.Summ_10201             AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10201() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10201 <> 0
                      UNION ALL
                       -- скидка outlet
                       SELECT _tmpItem.MovementItemId
                            , -1 * _tmpItem.Summ_10202            AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10202() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10202 <> 0
                      UNION ALL
                       -- скидка клиента
                       SELECT _tmpItem.MovementItemId
                            , -1 * _tmpItem.Summ_10203            AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10203() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10203 <> 0
                      UNION ALL
                       -- скидка дополнительная
                       SELECT _tmpItem.MovementItemId
                            , -1 * _tmpItem.Summ_10204            AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10204() AS AnalyzerId
                       FROM _tmpItem
                       WHERE _tmpItem.Summ_10204 <> 0
                      UNION ALL
                       -- Сумма, реализация (по прайсу) - !!!ХОТЯ ЗДЕСЬ ПРИБЫЛЬ без скидки!!!
                       SELECT _tmpItem.MovementItemId
                            , _tmpItem.OperSummPriceList - _tmpItem.OperSumm AS Amount
                            , zc_Enum_AnalyzerId_SaleSumm_10100()            AS AnalyzerId
                       FROM _tmpItem
                      ) AS _tmpCalc ON _tmpCalc.MovementItemId = _tmpItem_SummClient.MovementItemId
      UNION ALL
       -- проводки - Прибыль будущих периодов - С МИНУСОМ
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ_20102
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId_20102     AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - остаток
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerId_Analyzer   -- Контейнер - Корреспондент - остаток
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerIntId_Analyzer -- Контейнер - тот же самый
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , -1 * (_tmpItem.OperSummPriceList - _tmpItem.OperSumm
                  - _tmpItem.Summ_10201 - _tmpItem.Summ_10202 - _tmpItem.Summ_10203 - _tmpItem.Summ_10204
                   )                                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem.isGoods_Debt = FALSE
      ;


     -- 5.3. формируются Проводки - МИНУС остаток количество у Дебиторы покупатели
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - кол-во
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет из суммового учета
            , zc_Enum_AnalyzerId_SaleCount_10100()    AS AnalyzerId             -- Кол-во, реализация - Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_100301()                         AS AccountId_Analyzer     -- Счет - Корреспондент - прибыль текущего периода
            , _tmpItem_SummClient.ContainerId_ProfitLoss_10101 AS ContainerId_Analyzer   -- Контейнер - Корреспондент - ОПиУ !!!хотя их МНОГО!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- Контейнер - "товар"
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , -1 * _tmpItem_SummClient.OperCount_sale AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.OperCount_sale > 0
         AND _tmpItem.isGoods_Debt              = FALSE
       ;


     -- 5.4. формируются Проводки - МИНУС остаток сумма у Дебиторы покупатели
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - Сумма оплаты
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , 0                                       AS AccountId_Analyzer     -- Счет - Корреспондент - КАССА
            , 0                                       AS ContainerId_Analyzer   -- Контейнер - Корреспондент - КАССА !!!хотя их МНОГО!!!
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , -1 * _tmpItem_SummClient.TotalPay       AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.TotalPay <> 0
      UNION ALL
       -- проводки - Прибыль будущих периодов - С ПЛЮСОМ
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpItem_SummClient.ContainerId_Summ_20102
            , 0                                       AS ParentId
            , _tmpItem_SummClient.AccountId_20102     AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_100301()                         AS AccountId_Analyzer     -- Счет - Корреспондент - прибыль текущего периода
            , _tmpItem_SummClient.ContainerId_ProfitLoss_10101 AS ContainerId_Analyzer   -- Контейнер - Корреспондент - ОПиУ !!!хотя их МНОГО!!!
            , _tmpItem_SummClient.ContainerId_Summ_20102 AS ContainerIntId_Analyzer -- Контейнер - тот же самый
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , 1 * (_tmpItem_SummClient.OperSummPriceList_sale - _tmpItem_SummClient.OperSumm_sale
                 - _tmpItem_SummClient.Summ_10201 - _tmpItem_SummClient.Summ_10202 - _tmpItem_SummClient.Summ_10203 - _tmpItem_SummClient.Summ_10204
                  )                                   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.OperCount_sale > 0
         AND _tmpItem.isGoods_Debt              = FALSE
      ;


     -- ОПИУ


     -- 1. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_SummClient.MovementItemId
            , _tmpCalc.ContainerId_ProfitLoss
            , 0                                       AS ParentId
            , zc_Enum_Account_100301()                AS AccountId              -- прибыль текущего периода
            , _tmpCalc.AnalyzerId                     AS AnalyzerId             -- Типы аналитик (проводки)
            , _tmpItem_SummClient.GoodsId             AS ObjectId_Analyzer      -- Товар
            , _tmpItem_SummClient.PartionId           AS PartionId              -- Партия
            , vbClientId                              AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummClient.AccountId           AS AccountId_Analyzer     -- Счет - корреспондент - Покупатель !!!хотя их ДВА!!!
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , _tmpItem_SummClient.ContainerId_Summ    AS ContainerIntId_Analyzer-- Контейнер "товар"
            , _tmpItem_SummClient.GoodsSizeId         AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId                                AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , 1 * _tmpCalc.Amount                     AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_SummClient
            INNER JOIN
            (-- Сумма, реализация (по прайсу)
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10101 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10100()              AS AnalyzerId
                  , -1 * _tmpItem_SummClient.OperSummPriceList_sale  AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale > 0
            UNION ALL
             -- сезонная скидка
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10201 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10201()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10201                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10201     <> 0

            UNION ALL
             -- скидка outlet
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10202 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10202()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10202                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10202     <> 0
            UNION ALL
             -- скидка клиента
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10203 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10203()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10203                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10203     <> 0
            UNION ALL
             -- скидка дополнительная
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10204 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10204()              AS AnalyzerId
                  , _tmpItem_SummClient.Summ_10204                   AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
               AND _tmpItem_SummClient.Summ_10204     <> 0
            UNION ALL
             -- Себестоимость реализации
             SELECT _tmpItem_SummClient.MovementItemId               AS MovementItemId
                  , _tmpItem_SummClient.ContainerId_ProfitLoss_10301 AS ContainerId_ProfitLoss
                  , zc_Enum_AnalyzerId_SaleSumm_10300()              AS AnalyzerId
                  , _tmpItem_SummClient.OperSumm_sale                AS Amount
             FROM _tmpItem_SummClient
             WHERE _tmpItem_SummClient.OperCount_sale <> 0
            ) AS _tmpCalc ON _tmpCalc.MovementItemId = _tmpItem_SummClient.MovementItemId
           ;


     -- 2. формируются Проводки - оплаты
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpPay.MovementItemId
            , _tmpPay.ContainerId
            , 0                                       AS ParentId
            , _tmpPay.AccountId                       AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpPay.CurrencyId                      AS ObjectId_Analyzer      -- Валюта
            , 0                                       AS PartionId              -- Партия
            , _tmpPay.ObjectId                        AS WhereObjectId_Analyzer -- Место учета
            , COALESCE (_tmpItem_SummClient.AccountId, _tmpPay.AccountId_from)          AS AccountId_Analyzer   -- Счет - корреспондент - Покупатель / или ОБМЕН
            , COALESCE (_tmpItem_SummClient.ContainerId_Summ, _tmpPay.ContainerId_from) AS ContainerId_Analyzer -- Контейнер - Корреспондент - Покупатель / или ОБМЕН
            , _tmpPay.ContainerId                     AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , vbUnitId                                AS ObjectIntId_Analyzer   -- Аналитический справочник - Подразделение
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Покупатель
            , 1 * _tmpPay.OperSumm                    AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpPay
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpPay.ParentId

      UNION ALL
       -- проводки - ОБМЕН
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpPay.MovementItemId
            , _tmpPay.ContainerId_from
            , 0                                       AS ParentId
            , _tmpPay.AccountId_from                  AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , zc_Currency_Basis()                     AS ObjectId_Analyzer      -- Валюта
            , 0                                       AS PartionId              -- Партия
            , _tmpPay.ObjectId_from                   AS WhereObjectId_Analyzer -- Место учета
            , _tmpPay.AccountId                       AS AccountId_Analyzer     -- Счет - корреспондент -  ОБМЕН
            , _tmpPay.ContainerId                     AS ContainerId_Analyzer   -- Контейнер - Корреспондент - ОБМЕН
            , _tmpPay.ContainerId_from                AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , vbUnitId                                AS ObjectIntId_Analyzer   -- Аналитический справочник - Подразделение
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Покупатель
            , -1 * _tmpPay.OperSumm_from              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpPay
       WHERE _tmpPay.OperSumm_from <> 0

      UNION ALL
       -- проводки - ЗАБАЛАСОВЫЙ Валютный Счет
       SELECT 0, zc_MIContainer_SummCurrency() AS DescId, vbMovementDescId, inMovementId
            , _tmpPay.MovementItemId
            , _tmpPay.ContainerId_Currency
            , 0                                       AS ParentId
            , _tmpPay.AccountId                       AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpPay.CurrencyId                      AS ObjectId_Analyzer      -- Валюта
            , 0                                       AS PartionId              -- Партия
            , _tmpPay.ObjectId                        AS WhereObjectId_Analyzer -- Место учета
            , COALESCE (_tmpItem_SummClient.AccountId, _tmpPay.AccountId_from)          AS AccountId_Analyzer   -- Счет - корреспондент - Покупатель / или ОБМЕН
            , COALESCE (_tmpItem_SummClient.ContainerId_Summ, _tmpPay.ContainerId_from) AS ContainerId_Analyzer -- Контейнер - Корреспондент - Покупатель / или ОБМЕН
            , _tmpPay.ContainerId                     AS ContainerIntId_Analyzer-- Контейнер - тот же самый
            , vbUnitId                                AS ObjectIntId_Analyzer   -- Аналитический справочник - Подразделение
            , vbClientId                              AS ObjectExtId_Analyzer   -- Аналитический справочник - Покупатель
            , 1 * _tmpPay.OperSumm_Currency           AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpPay
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpPay.ParentId
       WHERE _tmpPay.OperSumm_Currency <> 0
      ;



     -- 5.0.1. Пересохраним св-ва из партии: <Цена> + <Цена за количество> + Курс - из истории
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(),     _tmpItem.MovementItemId, _tmpItem.OperPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), _tmpItem.MovementItemId, _tmpItem.CountForPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), _tmpItem.MovementItemId, _tmpItem.CurrencyValue)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      _tmpItem.MovementItemId, _tmpItem.ParValue)
     FROM _tmpItem;
     -- 5.0.2. Пересохраним св-ва из партии: <Товар>
     UPDATE MovementItem SET ObjectId = _tmpItem.GoodsId
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId = MovementItem.Id
       AND _tmpItem.GoodsId        <> MovementItem.ObjectId
     ;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Sale()
                                , inUserId     := inUserId
                                 );

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- меняются ИТОГОВЫЕ суммы по покупателю - !!!ПОСЛЕ Итоговые суммы по накладной!!!
     PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 14.05.17         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale (inMovementId:= 1100, inUserId:= zfCalc_UserAdmin() :: Integer)
