DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn(
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
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit()   THEN Object_To.Id   ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Client() THEN Object_From.Id ELSE 0 END, 0) AS ClientId

                  -- !!!ВСЕГДА - zc_Enum_AccountDirection_20100!!! Дебиторы + Покупатели
                , zc_Enum_AccountDirection_20100() AS AccountDirectionId_From

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Магазины
                , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_To

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
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_ReturnIn()
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
                         , OperSumm_ToPay, OperSummPriceList, TotalChangePercent, TotalPay, TotalToPay
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        WITH -- Курс - из истории
             tmpCurrency AS (SELECT *
                             FROM lfSelect_Movement_CurrencyAll_byDate (inOperDate      := vbOperDate
                                                                      , inCurrencyFromId:= zc_Currency_Basis()
                                                                      , inCurrencyToId  := 0
                                                                       )
                            )
        -- результат
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- сформируем позже
             , 0 AS ContainerId_Goods         -- сформируем позже
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.PartionId_MI
             , tmp.GoodsSizeId
             , tmp.OperCount

               -- Цена - из партии
             , tmp.OperPrice
               -- Цена за количество - из партии
             , tmp.CountForPrice

               -- Сумма по Вх. в zc_Currency_Basis
             , CASE WHEN tmp.CurrencyId = zc_Currency_Basis()
                         THEN tmp.OperSumm_Currency
                    WHEN tmp.CurrencyId = tmpCurrency.CurrencyToId
                         THEN zfCalc_CurrencyFrom (tmp.OperSumm_Currency, tmpCurrency.Amount, tmpCurrency.ParValue)
                    WHEN tmp.CurrencyId = tmpCurrency.CurrencyFromId
                         THEN zfCalc_CurrencyTo (tmp.OperSumm_Currency, tmpCurrency.Amount, tmpCurrency.ParValue)
               END AS OperSumm
               -- Сумма по Вх. в ВАЛЮТЕ
             , tmp.OperSumm_Currency

               -- Сумма к Оплате ИТОГО
             , tmp.OperSummPriceList - tmp.TotalChangePercent AS OperSumm_ToPay

             , tmp.OperSummPriceList  -- Сумма по Прайсу
             , tmp.TotalChangePercent -- Итого сумма Скидки
             , tmp.TotalPay           -- Итого сумма оплаты
             , tmp.TotalToPay         -- Итого сумма К оплате

             , 0 AS AccountId          -- Счет(справочника), сформируем позже

               -- УП для Sale - для определения счета Запасы
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.PartionId           AS PartionId
                   , MILinkObject_PartionMI.ObjectId  AS PartionId_MI
                   , Object_PartionGoods.GoodsSizeId  AS GoodsSizeId
                   , MovementItem.Amount              AS OperCount
                   , Object_PartionGoods.OperPrice    AS OperPrice
                   , MIFloat_OperPriceList.ValueData  AS OperPriceList
                   , CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS CountForPrice
                   , Object_PartionGoods.CurrencyId   AS CurrencyId

                     -- Сумма по Вх. в Валюте - с округлением до 2-х знаков
                   , zfCalc_SummIn (MovementItem.Amount, Object_PartionGoods.OperPrice, Object_PartionGoods.CountForPrice) AS OperSumm_Currency

                     -- Сумма по Прайсу - с округлением до 2-х знаков
                   , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) AS OperSummPriceList
                     -- Итого сумма Скидки (в ГРН) - только для текущего документа - суммируется 1)по %скидки + 2)дополнительная
                   , COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)                          AS TotalChangePercent
                     -- Итого сумма оплаты (в ГРН) - в текущем документе по zc_MI_Child
                   , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)                                    AS TotalPay

                     -- !!!самое Важное - расчет К выплате!!!
                   , CASE -- если вернули ВСЕ кол-во
                          WHEN MovementItem.Amount = MI_Sale.Amount
                               THEN -- Вся сумма ОПЛАТЫ
                                    COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0)

                          -- если прошла ИТОГО оплата меньше чем "расчет"
                          WHEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                             < ROUND (
                               -- Сумма по Прайсу
                               (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
                               -- МИНУС TotalChangePercent - Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах
                             - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))
                              ) / MI_Sale.Amount * MovementItem.Amount, 2)
                               THEN -- Вся сумма ОПЛАТЫ
                                    COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0)

                          ELSE -- Сумма по Прайсу
                               ROUND (
                              (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
                               -- МИНУС TotalChangePercent - Итого сумма Скидки (в ГРН) - для ВСЕХ документов - суммируется 1)по %скидки + 2)дополнительная + 3)дополнительная в оплатах
                             - (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))
                              ) / MI_Sale.Amount * MovementItem.Amount, 2)
                     END AS TotalToPay

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

                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                               ON MIFloat_TotalChangePercent_curr.MovementItemId = MovementItem.Id
                                              AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent()
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

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!ВРЕМЕННО!!! Доходы + Товары + Одежда
                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId


              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_ReturnIn()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
             LEFT JOIN tmpCurrency ON tmpCurrency.CurrencyFromId = tmp.CurrencyId OR tmpCurrency.CurrencyToId = tmp.CurrencyId
            ;




     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnIn()
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
 14.05.17         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ReturnIn (inMovementId:= 1100, inUserId:= zfCalc_UserAdmin() :: Integer)
