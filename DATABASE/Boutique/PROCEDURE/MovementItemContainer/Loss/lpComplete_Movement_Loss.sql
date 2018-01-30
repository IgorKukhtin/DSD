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
     SELECT _tmp.MovementDescId, _tmp.OperDate, _tmp.UnitId_From
          , _tmp.AccountDirectionId_From
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
          ) AS _tmp;


     -- доопределили - Аналитику для проводок
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperSumm, OperSumm_Currency
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , ProfitLossId_30200, ContainerId_ProfitLoss_30200
                          )
        -- результат
        SELECT _tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- сформируем позже
             , 0 AS ContainerId_Goods         -- сформируем позже
             , _tmp.GoodsId
             , _tmp.PartionId
             , _tmp.GoodsSizeId
             , _tmp.OperCount

               -- сумма по с/с
             , _tmp.OperSumm
               -- сумма в Валюте по с/с
             , _tmp.OperSumm_Currency

             , 0 AS AccountId                 -- Счет(справочника), сформируем позже

               -- УП
             , _tmp.InfoMoneyGroupId
             , _tmp.InfoMoneyDestinationId
             , _tmp.InfoMoneyId

             , 0 AS ProfitLossId_30200
             , 0 AS ContainerId_ProfitLoss_30200

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , Object_PartionGoods.GoodsId      AS GoodsId
                   , MovementItem.PartionId           AS PartionId
                   , Object_PartionGoods.GoodsSizeId  AS GoodsSizeId
                   , MovementItem.Amount              AS OperCount

                     -- сумма по Контрагенту в Валюте Баланса - с округлением до 2-х знаков
                   , CAST (MovementItem.Amount
                         * CASE WHEN Object_PartionGoods.CurrencyId <> zc_Currency_Basis()
                                     -- так переводится в валюту zc_Currency_Basis - с округлением до 2-х знаков
                                     THEN CAST (COALESCE (MIFloat_OperPrice.ValueData, 0) * COALESCE (MIFloat_CurrencyValue.ValueData, 0) / CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS NUMERIC (16, 2))
                                ELSE COALESCE (MIFloat_OperPrice.ValueData, 0)
                           END
                         / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                     AS NUMERIC (16, 2)) AS OperSumm

                     -- сумма по Контрагенту в Валюте - с округлением до 2-х знаков
                   , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS NUMERIC (16, 2)) AS OperSumm_Currency

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

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Loss()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
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


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Loss()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 25.04.17         *
*/