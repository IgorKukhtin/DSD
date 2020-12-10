-- Function: lpComplete_Movement_Send (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbUnitId_From              Integer;
  DECLARE vbUnitId_To                Integer;
  DECLARE vbAccountDirectionId_From  Integer;
  DECLARE vbAccountDirectionId_To    Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId               Integer; -- значение пока НЕ определяется

  DECLARE vbWhereObjectId_Analyzer_From Integer; -- Аналитика для проводок
  DECLARE vbWhereObjectId_Analyzer_To   Integer; -- Аналитика для проводок

BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Параметры из документа
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.UnitId_From, tmp.UnitId_To
          , tmp.AccountDirectionId_From, tmp.AccountDirectionId_To
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId_From
               , vbUnitId_To
               , vbAccountDirectionId_From
               , vbAccountDirectionId_To
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit() THEN Object_To.Id   ELSE 0 END, 0) AS UnitId_To

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Магазины
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From
                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Магазины
                , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100())   AS AccountDirectionId_To

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- проверка - Подразделение
     IF COALESCE (vbUnitId_From, 0) = COALESCE (vbUnitId_To, 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Значение <Подразделение (От кого)> должно отличаться от <Подразделение (Кому)>.';
     END IF;

     -- доопределили - Аналитику для проводок
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;
     vbWhereObjectId_Analyzer_To  := CASE WHEN vbUnitId_To   <> 0 THEN vbUnitId_To   END;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_SummFrom, ContainerId_GoodsFrom
                         , ContainerId_SummTo, ContainerId_GoodsTo
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperPrice, CountForPrice, OperSumm, OperSumm_Currency
                         , AccountId_From, AccountId_To, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
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
             , 0 AS ContainerId_SummFrom          -- сформируем позже
             , 0 AS ContainerId_GoodsFrom         -- сформируем позже
             , 0 AS ContainerId_SummTo            -- сформируем позже
             , 0 AS ContainerId_GoodsTo           -- сформируем позже
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

             , 0 AS AccountId_From                 -- Счет(справочника), сформируем позже
             , 0 AS AccountId_To                   -- Счет(справочника), сформируем позже

               -- УП
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

               -- Курс - из истории
             , COALESCE (tmp.CurrencyValue, 0) AS CurrencyValue
               -- Номинал курса - из истории
             , COALESCE (tmp.ParValue, 0)      AS ParValue

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , Object_PartionGoods.GoodsId      AS GoodsId
                   , MovementItem.PartionId           AS PartionId
                   , Object_PartionGoods.GoodsSizeId  AS GoodsSizeId
                   , MovementItem.Amount              AS OperCount
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

                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = Object_PartionGoods.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!ВРЕМЕННО!!! Доходы + Товары + Одежда

                   LEFT JOIN tmpCurrency ON (tmpCurrency.CurrencyFromId = Object_PartionGoods.CurrencyId OR tmpCurrency.CurrencyToId = Object_PartionGoods.CurrencyId)
                                        AND Object_PartionGoods.CurrencyId <> zc_Currency_Basis()

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Send()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId_From
                                                                                    , inMemberId               := NULL
                                                                                    , inClientId               := NULL
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inPartionId              := _tmpItem.PartionId
                                                                                    , inPartionId_MI           := NULL
                                                                                    , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                    , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                     )
                       , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId_To
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
     UPDATE _tmpItem SET AccountId_From = _tmpItem_byAccount.AccountId_From
                       , AccountId_To   = _tmpItem_byAccount.AccountId_To
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_From
                , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_To
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
    ;

     -- 2.2. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpItem SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                  , inUnitId                 := vbUnitId_From
                                                                                  , inMemberId               := NULL
                                                                                  , inClientId               := NULL
                                                                                  , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                  , inBusinessId             := vbBusinessId
                                                                                  , inAccountId              := _tmpItem.AccountId_From
                                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                  , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                  , inContainerId_Goods      := _tmpItem.ContainerId_GoodsFrom
                                                                                  , inGoodsId                := _tmpItem.GoodsId
                                                                                  , inPartionId              := _tmpItem.PartionId
                                                                                  , inPartionId_MI           := NULL
                                                                                  , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                   )
                       , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                  , inUnitId                 := vbUnitId_To
                                                                                  , inMemberId               := NULL
                                                                                  , inClientId               := NULL
                                                                                  , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                  , inBusinessId             := vbBusinessId
                                                                                  , inAccountId              := _tmpItem.AccountId_To
                                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                  , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                  , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTo
                                                                                  , inGoodsId                := _tmpItem.GoodsId
                                                                                  , inPartionId              := _tmpItem.PartionId
                                                                                  , inPartionId_MI           := NULL
                                                                                  , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                   );

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
            , _tmpItem.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpItem.AccountId_From                 AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId_To                   AS AccountId_Analyzer     -- Счет - корреспондент - по ПРИХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem.ContainerId_SummTo             AS ContainerIntId_Analyzer-- Контейнер - Корреспондент - по ПРИХОДУ
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
      UNION ALL
       -- проводки - ПРИХОД
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpItem.AccountId_To                   AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId_From                 AS AccountId_Analyzer     -- Счет - корреспондент - по РАСХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem.ContainerId_SummFrom           AS ContainerIntId_Analyzer-- Контейнер - Корреспондент - по РАСХОДУ
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого
            , 1 * _tmpItem.OperCount                  AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
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
            , _tmpItem.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpItem.AccountId_From                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId_To                   AS AccountId_Analyzer     -- Счет - корреспондент - по ПРИХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem.ContainerId_SummTo             AS ContainerIntId_Analyzer-- Контейнер - Корреспондент - по ПРИХОДУ
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому
            , -1 * _tmpItem.OperSumm                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpItem.AccountId_To                   AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem.AccountId_From                 AS AccountId_Analyzer     -- Счет - корреспондент - по РАСХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem.ContainerId_SummFrom           AS ContainerIntId_Analyzer-- Контейнер - Корреспондент - по РАСХОДУ
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого
            , 1 * _tmpItem.OperSumm                   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem;


     -- 5.0.1. Пересохраним св-ва из партии: <Цена> + <Цена за количество> + Курс - из истории
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(),     _tmpItem.MovementItemId, _tmpItem.OperPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), _tmpItem.MovementItemId, _tmpItem.CountForPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), _tmpItem.MovementItemId, _tmpItem.CurrencyValue)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      _tmpItem.MovementItemId, _tmpItem.ParValue)
         --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), _tmpItem.MovementItemId, tmpPrice.ValuePrice)
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
                                , inDescId     := zc_Movement_Send()
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
 28.06.17                                        *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 39, inSession:= zfCalc_UserAdmin())
