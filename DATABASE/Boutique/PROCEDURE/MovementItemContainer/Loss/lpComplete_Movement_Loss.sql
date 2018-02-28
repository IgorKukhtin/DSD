DROP FUNCTION IF EXISTS lpComplete_Movement_Loss (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbUnitId_From              Integer;
  DECLARE vbAccountDirectionId_From  Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId               Integer; -- значение пока НЕ определяется

  DECLARE vbWhereObjectId_Analyzer_From Integer; -- Аналитика для проводок
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Параметры из документа
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.UnitId_From
          , tmp.AccountDirectionId_From
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId_From
               , vbAccountDirectionId_From
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Магазины
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Loss()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- доопределили - Аналитику для проводок
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperPrice, CountForPrice, OperSumm, OperSumm_Currency
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , ProfitLossId_30200, ContainerId_ProfitLoss_30200
                         , CurrencyValue, ParValue
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
             , tmp.GoodsSizeId
             , tmp.OperCount

               -- Цена - из партии
             , tmp.OperPrice
               -- Цена за количество - из партии
             , tmp.CountForPrice

               -- Сумма по Вх. в zc_Currency_Basis - с округлением до 2-х знаков
             , zfCalc_SummIn (tmp.OperCount, tmp.OperPrice_basis, tmp.CountForPrice) AS OperSumm
               -- Сумма по Вх. в ВАЛЮТЕ
             , tmp.OperSumm_Currency

               -- Счет(справочника), сформируем позже
             , 0 AS AccountId

               -- УП
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

             , 0 AS ProfitLossId_30200
             , 0 AS ContainerId_ProfitLoss_30200

               -- Курс - из истории
             , COALESCE (tmp.CurrencyValue, 0) AS CurrencyValue
               -- Номинал курса - из истории
             , COALESCE (tmp.ParValue, 0)      AS ParValue

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

                     -- сумма по Вх. в Валюте - с округлением до 2-х знаков
                   , zfCalc_SummIn (MovementItem.Amount, Object_PartionGoods.OperPrice, Object_PartionGoods.CountForPrice) AS OperSumm_Currency

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
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = Object_PartionGoods.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!ВРЕМЕННО!!! Доходы + Товары + Одежда

                   LEFT JOIN tmpCurrency ON (tmpCurrency.CurrencyFromId = Object_PartionGoods.CurrencyId OR tmpCurrency.CurrencyToId = Object_PartionGoods.CurrencyId)
                                        AND Object_PartionGoods.CurrencyId <> zc_Currency_Basis()

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Loss()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                 , inUnitId                 := vbUnitId_From
                                                                                 , inMemberId               := NULL
                                                                                 , inClientId               := NULL
                                                                                 , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                 , inGoodsId                := _tmpItem.GoodsId
                                                                                 , inPartionId              := _tmpItem.PartionId
                                                                                 , inPartionId_MI           := NULL
                                                                                 , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                 , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                  );

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
                                                                              , inUnitId                 := vbUnitId_From
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


     -- 2.3. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItem SET ContainerId_ProfitLoss_30200 = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                              , inParentId          := NULL
                                                                              , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                                                              , inPartionId         := NULL
                                                                              , inJuridicalId_basis := vbJuridicalId_Basis
                                                                              , inBusinessId        := vbBusinessId
                                                                              , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                              , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                                                              , inDescId_2          := zc_ContainerLinkObject_Unit()
                                                                              , inObjectId_2        := vbUnitId_From
                                                                               )
                       , ProfitLossId_30200 = _tmpItem_byProfitLoss.ProfitLossId
     FROM (SELECT lpInsertFind_Object_ProfitLoss (inProfitLossGroupId         := zc_Enum_ProfitLossGroup_30000()     -- Расходы по магазинам
                                                , inProfitLossDirectionId     := zc_Enum_ProfitLossDirection_30200() -- Списания
                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                                , inInfoMoneyId            := NULL
                                                , inUserId                 := inUserId
                                                 ) AS ProfitLossId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byProfitLoss
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byProfitLoss.InfoMoneyDestinationId;


     -- 3.1. формируются Проводки - остаток количество
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - РАСХОД
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_100301()                AS AccountId_Analyzer     -- Счет - Корреспондент - прибыль текущего периода
            , _tmpItem.ContainerId_ProfitLoss_30200   AS ContainerId_Analyzer   -- Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- Контейнер - "товар"
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , _tmpItem.ProfitLossId_30200             AS ObjectExtId_Analyzer   -- Аналитический справочник - статья ОПиУ
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem;


     -- 3.2. формируются Проводки - остаток сумма
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - РАСХОД
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_100301()                AS AccountId_Analyzer     -- Счет - Корреспондент - прибыль текущего периода
            , _tmpItem.ContainerId_ProfitLoss_30200   AS ContainerId_Analyzer   -- Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- Контейнер - "товар"
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , _tmpItem.ProfitLossId_30200             AS ObjectExtId_Analyzer   -- Аналитический справочник - статья ОПиУ
            , -1 * _tmpItem.OperSumm                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem;


     -- 4. формируются Проводки - Прибыль
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
            , _tmpItem.ContainerId_ProfitLoss_30200
            , 0                                       AS ParentId
            , zc_Enum_Account_100301()                AS AccountId              -- прибыль текущего периода
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId                      AS AccountId_Analyzer     -- Счет - корреспондент - "товар"
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , _tmpItem.ContainerId_Summ               AS ContainerIntId_Analyzer-- Контейнер "товар"
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , 0                                       AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение
            , 1 * _tmpItem.OperSumm                   AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem;


     -- 5.0.1. Пересохраним св-ва из партии: <Цена> + <Цена за количество> + Курс - из истории
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(),     _tmpItem.MovementItemId, _tmpItem.OperPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), _tmpItem.MovementItemId, _tmpItem.CountForPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), _tmpItem.MovementItemId, _tmpItem.CurrencyValue)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      _tmpItem.MovementItemId, _tmpItem.ParValue)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), _tmpItem.MovementItemId, tmpPrice.ValuePrice)
     FROM _tmpItem
          LEFT JOIN (SELECT _tmpItem.GoodsId
                          , ObjectHistoryFloat_Value.ValueData AS ValuePrice
                     FROM _tmpItem
                         INNER JOIN ObjectLink AS ObjectLink_Goods
                                               ON ObjectLink_Goods.ChildObjectId = _tmpItem.GoodsId
                                              AND ObjectLink_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                         INNER JOIN ObjectLink AS ObjectLink_PriceList
                                               ON ObjectLink_PriceList.ObjectId      = ObjectLink_Goods.ObjectId
                                              AND ObjectLink_PriceList.ChildObjectId = zc_PriceList_Basis()  -- !!!Базовый Прайс!!!
                                              AND ObjectLink_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
             
                         INNER JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_Goods.ObjectId
                                                 AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                 AND vbOperDate >= ObjectHistory_PriceListItem.StartDate AND vbOperDate < ObjectHistory_PriceListItem.EndDate
                         LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                      ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                     AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                    ) AS tmpPrice ON tmpPrice.GoodsId = _tmpItem.GoodsId
     ;
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
                                , inDescId     := zc_Movement_Loss()
                                , inUserId     := inUserId
                                 );

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 25.04.17         *
*/