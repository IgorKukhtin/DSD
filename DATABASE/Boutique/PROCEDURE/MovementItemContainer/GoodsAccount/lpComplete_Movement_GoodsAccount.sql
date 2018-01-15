DROP FUNCTION IF EXISTS lpComplete_Movement_GoodsAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_GoodsAccount(
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
  DECLARE vbJuridicalId_Basis       Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId              Integer; -- значение пока НЕ определяется
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
          , _tmp.AccountDirectionId_From
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId
               , vbClientId
               , vbAccountDirectionId_From
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit()   THEN Object_To.Id   ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Client() THEN Object_From.Id ELSE 0 END, 0) AS ClientId

                  -- !!!ВСЕГДА - zc_Enum_AccountDirection_20100!!! Дебиторы + Покупатели
                , zc_Enum_AccountDirection_20100() AS AccountDirectionId_From

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_GoodsAccount()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
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
                         , GoodsId, PartionId, PartionId_MI, GoodsSizeId
                         , OperCount, OperPrice, CountForPrice, OperSumm, OperSumm_Currency
                         , OperSumm_ToPay, OperSummPriceList, TotalChangePercent, TotalPay, TotalPay_curr
                         , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , SummDebt_sale, SummDebt_return
                          )
        -- результат
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- сформируем позже
             , 0 AS ContainerId_Goods         -- сформируем позже
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.PartionId_MI
             , tmp.GoodsSizeId

               -- !!!заменили!!!
             , tmp.Amount_begin AS OperCount

               -- Цена - из партии
             , tmp.OperPrice
               -- Цена за количество - из партии
             , tmp.CountForPrice

               -- Сумма по Вх. в zc_Currency_Basis
             , CASE WHEN tmp.CurrencyId = zc_Currency_Basis()
                         THEN zfCalc_SummIn (tmp.Amount_begin, tmp.OperPrice, tmp.CountForPrice)
                    ELSE -- !!!Надо не забыть и курс записать в ГРН!!!
                         zfCalc_CurrencyFrom (zfCalc_SummIn (tmp.Amount_begin, tmp.OperPrice, tmp.CountForPrice), tmp.CurrencyValue, tmp.ParValue)
               END AS OperSumm
               -- Сумма по Вх. в ВАЛЮТЕ
             , zfCalc_SummIn (tmp.Amount_begin, tmp.OperPrice, tmp.CountForPrice) AS OperSumm_Currency

               -- Сумма к Оплате ИТОГО
             , zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList)
             - (tmp.TotalChangePercent + tmp.TotalChangePercentPay + tmp.SummChangePercent_curr)
             - tmp.TotalReturn_calc
               AS OperSumm_ToPay

               -- Сумма по Прайсу - с округлением до 2-х знаков
             , zfCalc_SummPriceList (tmp.Amount_begin, tmp.OperPriceList) AS OperSummPriceList

               -- Итого сумма Скидки - 1) + 2) + 3) + 4)в текущем документе - 5)сколько Скидки - вернули
             , tmp.TotalChangePercent + tmp.TotalChangePercentPay + tmp.SummChangePercent_curr - tmp.SummChangePercent_return AS TotalChangePercent

             , tmp.TotalPay + tmp.TotalPayOth + tmp.TotalPay_curr - tmp.TotalPayReturn_calc AS TotalPay      -- Итого сумма оплаты - 1) + 2) + 3)в текущем документе - 4)сколько оплаты - вернули
             , tmp.TotalPay_curr                                                            AS TotalPay_curr -- Итого сумма оплаты - в текущем документе

               -- Сезонная скидка - Только для %
             , CASE WHEN tmp.DiscountSaleKindId = zc_Enum_DiscountSaleKind_Period() THEN tmp.SummChangePercent_pl ELSE 0 END AS Summ_10201
               -- Скидка outlet - Только для %
             , CASE WHEN tmp.DiscountSaleKindId = zc_Enum_DiscountSaleKind_Outlet() THEN tmp.SummChangePercent_pl ELSE 0 END AS Summ_10202
               -- Скидка клиента - Только для %
             , CASE WHEN tmp.DiscountSaleKindId = zc_Enum_DiscountSaleKind_Client() THEN tmp.SummChangePercent_pl ELSE 0 END AS Summ_10203
               -- Скидка дополнительная - считаем сколько от неё остаётся
             , tmp.TotalChangePercent + tmp.TotalChangePercentPay + tmp.SummChangePercent_curr - tmp.SummChangePercent_return - tmp.SummChangePercent_pl AS Summ_10204

             , 0 AS AccountId          -- Счет(справочника), сформируем позже

               -- УП для Sale - для определения счета Запасы
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

             , tmp.SummDebt_sale
             , tmp.SummDebt_return

        FROM (SELECT tmp.*
                     -- !!!самое Важное - определить Кол-во!!!
                   , CASE WHEN tmp.SummDebt_sale = 0
                               THEN -- то что в продаже
                                    tmp.Amount_Sale
                          WHEN tmp.SummDebt_return = 0
                               THEN -- продажа МИНУС возврат
                                    tmp.Amount_Sale - tmp.Amount_Return
                          ELSE 0
                     END AS Amount_begin

                     -- !!!самое Важное - определить для Amount_begin Скидка - Только для %!!!
                   , CASE WHEN tmp.SummDebt_sale = 0
                               THEN -- то что в продаже
                                    zfCalc_SummPriceList (tmp.Amount_Sale, tmp.OperPriceList) - zfCalc_SummChangePercent (tmp.Amount_Sale, tmp.OperPriceList, tmp.ChangePercent)
                          WHEN tmp.SummDebt_return = 0
                               THEN -- продажа МИНУС возврат
                                    zfCalc_SummPriceList (tmp.Amount_Sale - tmp.Amount_Return, tmp.OperPriceList) - zfCalc_SummChangePercent (tmp.Amount_Sale - tmp.Amount_Return, tmp.OperPriceList, tmp.ChangePercent)
                          ELSE 0
                     END AS SummChangePercent_pl

                     -- !!!самое Важное - определить Долг!!!
                   , CASE WHEN tmp.SummDebt_sale = 0
                               THEN -- то что в продаже
                                    tmp.SummDebt_sale
                          WHEN tmp.SummDebt_return = 0
                               THEN -- продажа МИНУС возврат
                                    tmp.SummDebt_return
                          ELSE tmp.SummDebt_return
                     END AS SummDebt

                     -- !!!сколько Скидки - вернули!!!
                   , CASE WHEN tmp.SummDebt_sale = 0
                               THEN -- НЕ учитываем её
                                    0
                          WHEN tmp.SummDebt_return = 0
                               THEN -- просто разница
                                    zfCalc_SummPriceList (tmp.Amount_Return, tmp.OperPriceList) - tmp.TotalReturn
                          ELSE 0
                     END AS SummChangePercent_return
                     -- !!!сколько оплаты - вернули!!!
                   , CASE WHEN tmp.SummDebt_sale = 0
                               THEN -- НЕ учитываем её
                                    0
                          WHEN tmp.SummDebt_return = 0
                               THEN -- учитываем её
                                    tmp.TotalPayReturn
                          ELSE 0
                     END AS TotalPayReturn_calc
                     -- !!!сколько суммы со скидкой - вернули!!!
                   , CASE WHEN tmp.SummDebt_sale = 0
                               THEN -- НЕ учитываем её
                                    0
                          WHEN tmp.SummDebt_return = 0
                               THEN -- учитываем её
                                    tmp.TotalReturn
                          ELSE 0
                     END AS TotalReturn_calc

              FROM
             (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.PartionId           AS PartionId
                   -- , Object_PartionMI.ObjectCode   AS MovementItemId_MI
                   , MILinkObject_PartionMI.ObjectId  AS PartionId_MI
                   , Object_PartionGoods.GoodsSizeId  AS GoodsSizeId
                   -- , MovementItem.Amount           AS OperCount
                   , Object_PartionGoods.OperPrice    AS OperPrice
                   , MIFloat_OperPriceList.ValueData  AS OperPriceList
                   , CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS CountForPrice
                   , Object_PartionGoods.CurrencyId   AS CurrencyId


                     -- !!!1.1. самое Важное - Сложный расчет ДОЛГА - БЕЗ ВОЗВРАТА!!!
                   , -- Сумма по Прайсу
                     zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)

                     -- МИНУС: Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах + 4)в текущем документе
                   - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0))

                     -- МИНУС: Итого сумма оплаты (в ГРН) - для ВСЕХ документов - суммируется 1) + 2) + 3)в текущем документе по zc_MI_Child
                   - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) + COALESCE (MIFloat_TotalPay_curr.ValueData, 0))

                     AS SummDebt_sale -- 1.1.


                     -- !!!1.2. самое Важное - Сложный расчет ДОЛГА - с учетом ВОЗВРАТА!!!
                   , -- Сумма по Прайсу
                     zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)

                     -- МИНУС: Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах + 4)в текущем документе
                   - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) + COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0))

                     -- МИНУС: Итого сумма оплаты (в ГРН) - для ВСЕХ документов - суммируется 1) + 2) + 3)в текущем документе по zc_MI_Child
                   - (COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) + COALESCE (MIFloat_TotalPay_curr.ValueData, 0))

                     -- МИНУС TotalReturn - Итого сумма возврата со скидкой - все док-ты
                   - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                     -- !!!ПЛЮС!!! TotalReturn - Итого возврат оплаты - все док-ты
                   + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                     AS SummDebt_return -- 1.2.


                     -- кол-во в самой продаже
                   , MI_Sale.Amount AS Amount_Sale
                     -- Скидка % - в самой продаже
                   , COALESCE (MIFloat_ChangePercent.ValueData, 0)          AS ChangePercent
                     -- Скидка в самой продаже - суммируется 1)по %скидки + 2)дополнительная
                   , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)     AS TotalChangePercent
                     -- Скидка в самой продаже - дополнительная из Расчеты покупателей
                   , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)  AS TotalChangePercentPay
                     -- сумма оплаты в самой продаже
                   , COALESCE (MIFloat_TotalPay.ValueData, 0)               AS TotalPay
                     -- сумма оплаты в самой продаже - из Расчеты покупателей
                   , COALESCE (MIFloat_TotalPayOth.ValueData, 0)            AS TotalPayOth

                     -- кол-во Итого возврат
                   , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   AS Amount_Return
                     -- Итого сумма возврата со скидкой - все док-ты
                   , COALESCE (MIFloat_TotalReturn.ValueData, 0)        AS TotalReturn
                     -- Итого сумма возврата ОПЛАТЫ - все док-ты
                   , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     AS TotalPayReturn

                     -- сумма Скидки - в текущем документе
                   , COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0) AS SummChangePercent_curr
                     -- Итого сумма оплаты (в ГРН) - в текущем документе по zc_MI_Child
                   , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)          AS TotalPay_curr


                   , MILinkObject_DiscountSaleKind.ObjectId AS DiscountSaleKindId

                     -- Управленческая группа
                   , View_InfoMoney.InfoMoneyGroupId
                     -- Управленческие назначения
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- Статьи назначения
                   , View_InfoMoney.InfoMoneyId

                   , MIFloat_CurrencyValue.ValueData  AS CurrencyValue
                   , MIFloat_ParValue.ValueData       AS ParValue

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE

                   LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                               ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                              AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                               ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                              AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                    ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                   LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId

                   LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode

                   LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                               ON MIFloat_OperPriceList.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                               ON MIFloat_TotalChangePercent.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                               ON MIFloat_TotalChangePercentPay.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                               ON MIFloat_TotalPay.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                               ON MIFloat_TotalPayOth.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                               ON MIFloat_SummChangePercent.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                   LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                               ON MIFloat_TotalCountReturn.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                               ON MIFloat_TotalReturn.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                               ON MIFloat_TotalPayReturn.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                               ON MIFloat_CurrencyValue.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = Object_PartionMI.ObjectCode
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                    ON MILinkObject_DiscountSaleKind.MovementItemId = Object_PartionMI.ObjectCode
                                                   AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!ВРЕМЕННО!!! Доходы + Товары + Одежда
                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_GoodsAccount()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
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
     -- проверка SummDebt_sale
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.SummDebt_sale < 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Сумма долга после оплаты = <%> <SummDebt_sale>.', (SELECT _tmpItem.SummDebt_sale FROM _tmpItem WHERE _tmpItem.SummDebt_sale < 0 ORDER BY _tmpItem.MovementItemId LIMIT 1);
     END IF;
     -- проверка SummDebt_return
     IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.SummDebt_return < 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Сумма долга после оплаты = <%> <SummDebt_return>.', (SELECT _tmpItem.SummDebt_return FROM _tmpItem WHERE _tmpItem.SummDebt_return < 0 ORDER BY _tmpItem.MovementItemId LIMIT 1);
     END IF;


     -- заполняем таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_SummClient (MovementItemId, ContainerId_Summ, ContainerId_Summ_20102, ContainerId_Goods, AccountId, AccountId_20102, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                    , GoodsId, PartionId, GoodsSizeId, PartionId_MI
                                    , OperCount, OperSumm, OperSumm_ToPay, TotalPay, TotalPay_curr
                                    , OperCount_sale, OperSumm_sale, OperSummPriceList_sale
                                    , Summ_10201, Summ_10202, Summ_10203, Summ_10204
                                    , ContainerId_ProfitLoss_10101, ContainerId_ProfitLoss_10201, ContainerId_ProfitLoss_10202, ContainerId_ProfitLoss_10203, ContainerId_ProfitLoss_10204, ContainerId_ProfitLoss_10301
                                     )

        WITH -- Нужен Кол-во Остаток (долг) - .т.к. проводки могли пройти в Других MovementId
             tmpContainer AS (SELECT _tmpItem.PartionId_MI, Container.ObjectId AS GoodsId, Container.Amount
                              FROM _tmpItem
                                   INNER JOIN Container ON Container.PartionId = _tmpItem.PartionId
                                                       AND Container.DescId    = zc_Container_Count()
                                   INNER JOIN ContainerLinkObject AS CLO_PartionMI
                                                                  ON CLO_PartionMI.ContainerId = Container.Id
                                                                 AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                                                                 AND CLO_PartionMI.ObjectId    = _tmpItem.PartionId_MI
                                   INNER JOIN ContainerLinkObject AS CLO_Client
                                                                  ON CLO_Client.ContainerId = Container.Id
                                                                 AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                                 AND CLO_Client.ObjectId    = vbClientId
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ObjectId    = vbUnitId
                             )
        -- Результат
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ, 0 AS ContainerId_Summ_20102, 0 AS ContainerId_Goods, 0 AS AccountId, 0 AS AccountId_20102
             , tmp.InfoMoneyGroupId, tmp.InfoMoneyDestinationId, tmp.InfoMoneyId
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId

               -- Партия элемента продажи/возврата
             , tmp.PartionId_MI

               -- все кол-во
             , tmp.OperCount

             , (tmp.OperSumm)          AS OperSumm       -- сумма по вх.
             , (tmp.OperSumm_ToPay)    AS OperSumm_ToPay -- сумма к оплате
             , (tmp.TotalPay)          AS TotalPay       -- сумма оплаты - 1) + 2) + 3)в текущем документе
             , (tmp.TotalPay_curr)     AS TotalPay_curr  -- сумма оплаты - в текущем документе

               -- расчет кол-во которое попадает в ПРОДАЖУ - ОПИУ
             , tmp.OperCount_sale

               -- расчет с/с которое попадает в ПРОДАЖУ
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.OperSumm
                    ELSE 0
               END AS OperSumm_sale

               -- расчет Суммы которая попадает в ПРОДАЖУ
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.OperSummPriceList
                    ELSE 0
               END AS OperSummPriceList_sale

               -- расчет сезонная скидка которая попадает в ПРОДАЖУ
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10201
                    ELSE 0
               END AS Summ_10201

               -- расчет скидка outlet которая попадает в ПРОДАЖУ
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10202
                    ELSE 0
               END AS Summ_10202

               -- расчет скидка клиента которая попадает в ПРОДАЖУ
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10203
                    ELSE 0
               END AS Summ_10203

               -- расчет Скидка дополнительная которая попадает в ПРОДАЖУ
             , CASE WHEN 1=1 -- tmp.OperSumm_ToPay = tmp.TotalPay AND tmp.OperCount_sale > 0
                         THEN tmp.Summ_10204
                    ELSE 0
               END AS Summ_10204

             , 0 AS ContainerId_ProfitLoss_10101, 0 AS ContainerId_ProfitLoss_10201, 0 AS ContainerId_ProfitLoss_10202, 0 AS ContainerId_ProfitLoss_10203, 0 AS ContainerId_ProfitLoss_10204, 0 AS ContainerId_ProfitLoss_10301

        FROM (SELECT _tmpItem.*
                     -- расчет кол-во которое попадает в ПРОДАЖУ - ОПИУ
                   , CASE WHEN 1=1
                               THEN _tmpItem.OperCount
                          WHEN _tmpItem.OperSumm_ToPay = _tmpItem.TotalPay AND _tmpItem.OperCount = tmpContainer.Amount
                               THEN _tmpItem.OperCount
                          WHEN _tmpItem.OperSumm_ToPay = _tmpItem.TotalPay AND tmpContainer.Amount > 0
                               THEN -1 * tmpContainer.Amount -- !!!будет ошибка
                          ELSE 0
                     END AS OperCount_sale
              FROM _tmpItem
                   LEFT JOIN tmpContainer ON tmpContainer.PartionId_MI = _tmpItem.PartionId_MI
                                         AND tmpContainer.GoodsId      = _tmpItem.GoodsId     -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
              -- WHERE _tmpItem.OperCount > 0
             ) AS tmp
        ;

     -- проверка что сумма оплаты ....
     -- IF EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204)
     -- THEN
     --     RAISE EXCEPTION 'Ошибка. проверка что сумма оплаты .....', (SELECT _tmpItem.TotalChangePercent FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --                                                              , (SELECT _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 FROM _tmpItem WHERE _tmpItem.TotalChangePercent <> _tmpItem.Summ_10201 + _tmpItem.Summ_10202 + _tmpItem.Summ_10203 + _tmpItem.Summ_10204 ORDER BY _tmpItem.MovementItemId LIMIT 1)
     --    ;
     -- END IF;

     -- проверка что количество - РАВНО Кол-во Остаток (долг)
     IF EXISTS (SELECT 1 FROM _tmpItem_SummClient WHERE _tmpItem_SummClient.OperCount_sale < 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Кол-во в партии продажи = <%> не равно Кол-во Остаток (долг) = <%>.'
                       , (SELECT _tmpItem_SummClient.OperCount           FROM _tmpItem_SummClient WHERE _tmpItem_SummClient.OperCount_sale < 0 ORDER BY _tmpItem_SummClient.MovementItemId LIMIT 1)
                       , (SELECT -1 * _tmpItem_SummClient.OperCount_sale FROM _tmpItem_SummClient WHERE _tmpItem_SummClient.OperCount_sale < 0 ORDER BY _tmpItem_SummClient.MovementItemId LIMIT 1)
        ;
     END IF;


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
                   , CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_Basis() THEN MovementItem.Amount ELSE ROUND (zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData), 2) END AS OperSumm
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
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Child()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.Amount     <> 0
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
                AND Movement.DescId   = zc_Movement_GoodsAccount()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
        ;

     -- проверка что сумма оплаты ....
     IF  COALESCE ((SELECT SUM (_tmpItem_SummClient.TotalPay_curr) FROM _tmpItem_SummClient), 0)
      <> COALESCE ((SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) FROM _tmpPay), 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Сумма оплаты Main <%> не равна Child <%>.', (SELECT SUM (_tmpItem_SummClient.TotalPay_curr) FROM _tmpItem_SummClient)
                                                                            , (SELECT SUM (_tmpPay.OperSumm - _tmpPay.OperSumm_from) FROM _tmpPay)
         ;
     END IF;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


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
                                                                                            )
     WHERE _tmpItem_SummClient.OperCount_sale > 0 -- !!!ЕСЛИ будет продажа!!!
    ;

     -- 3.2.1. определяется Счет(справочника) для проводок по Покупателю
     UPDATE _tmpItem_SummClient SET AccountId       = _tmpItem_byAccount.AccountId
                                  , AccountId_20102 = zc_Enum_Account_20102() -- Дебиторы + покупатели + Прибыль будущих периодов

     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Дебиторы
                                             , inAccountDirectionId     := vbAccountDirectionId_From
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
            , -1 * _tmpItem_SummClient.TotalPay_curr  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.TotalPay_curr <> 0
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
                  ) AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummClient ON _tmpItem_SummClient.MovementItemId = _tmpItem.MovementItemId
       WHERE _tmpItem_SummClient.OperCount_sale > 0
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
            , _tmpCalc.Amount                         AS Amount
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
             -- скидка дополнительная
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



     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_GoodsAccount()
                                , inUserId     := inUserId
                                 );

     -- 6.1. пересчитали "итоговые" суммы по элементам партии продажи - ОБЯЗАТЕЛЬНО после lpComplete
     PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

     -- 6.2. меняются ИТОГОВЫЕ суммы по покупателю
     PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 18.05.17         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_GoodsAccount (inMovementId:= 354046, inSession:= zfCalc_UserAdmin())
