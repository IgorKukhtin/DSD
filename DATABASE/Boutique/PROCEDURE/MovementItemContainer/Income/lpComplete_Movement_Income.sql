-- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId         Integer;
  DECLARE vbOperDate               TDateTime;
  DECLARE vbPartnerId              Integer;
  DECLARE vbUnitId                 Integer;
  DECLARE vbAccountDirectionId_To  Integer;
  DECLARE vbJuridicalId_Basis      Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId             Integer; -- значение пока НЕ определяется

  DECLARE vbCurrencyDocumentId     Integer;
  DECLARE vbCurrencyValue          TFloat;
  DECLARE vbParValue               TFloat;

  DECLARE vbWhereObjectId_Analyzer Integer; -- Аналитика для проводок

BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPartner;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;


     -- Параметры из документа
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.PartnerId, tmp.UnitId
          , tmp.CurrencyDocumentId, tmp.CurrencyValue, tmp.ParValue
          , tmp.AccountDirectionId_To
            INTO vbMovementDescId
               , vbOperDate
               , vbPartnerId
               , vbUnitId
               , vbCurrencyDocumentId
               , vbCurrencyValue
               , vbParValue
               , vbAccountDirectionId_To
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit()    THEN Object_To.Id   ELSE 0 END, 0) AS UnitId

                , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Currency_Basis()) AS CurrencyDocumentId
                , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                          AS CurrencyValue
                , COALESCE (MovementFloat_ParValue.ValueData, 0)                               AS ParValue

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Магазины
                , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_To

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                        ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                       AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                        ON MovementFloat_ParValue.MovementId = Movement.Id
                                       AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Income()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- доопределили - Аналитику для проводок
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId END;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperSumm, OperSumm_Currency
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- результат
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- сформируем позже
             , 0 AS ContainerId_Goods         -- сформируем позже
             , tmp.GoodsId
             , tmp.PartionId
             , tmp.GoodsSizeId
             , tmp.OperCount

               -- Сумма по Вх. в zc_Currency_Basis - с округлением до 2-х знаков
             , zfCalc_SummIn (tmp.OperCount, tmp.OperPrice_basis, tmp.CountForPrice) AS OperSumm
               -- Сумма по Вх. в ВАЛЮТЕ
             , tmp.OperSumm_Currency

             , 0 AS AccountId                 -- Счет(справочника), сформируем позже

               -- УП для Income = УП долг Контрагента
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                    AS MovementItemId
                   , Object_PartionGoods.GoodsId        AS GoodsId
                   , MovementItem.Id                    AS PartionId -- !!!здесь можно было б и MovementItem.PartionId!!!
                   , Object_PartionGoods.GoodsSizeId    AS GoodsSizeId
                   , MovementItem.Amount                AS OperCount
                   , Object_PartionGoods.OperPrice      AS OperPrice
                   , CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS CountForPrice
                   , Object_PartionGoods.CurrencyId     AS CurrencyId

                     -- Цена Вх. - именно её переводим в zc_Currency_Basis - с округлением до 2-х знаков
                   , zfCalc_PriceIn_Basis (Object_PartionGoods.CurrencyId, Object_PartionGoods.OperPrice
                                         , CASE WHEN Object_PartionGoods.CurrencyId = Object_PartionGoods.CurrencyId
                                                     THEN vbCurrencyValue
                                                WHEN 1=0 -- Object_PartionGoods.CurrencyId <> Object_PartionGoods.CurrencyId AND vbCurrencyValue > 0
                                                     -- Здесь Деление
                                                     THEN 1000 * 1 / vbCurrencyValue
                                           END
                                         , CASE WHEN Object_PartionGoods.CurrencyId = Object_PartionGoods.CurrencyId
                                                     THEN vbParValue
                                                WHEN 1=0 -- Object_PartionGoods.CurrencyId <> Object_PartionGoods.CurrencyId AND vbCurrencyValue > 0
                                                     -- т.к. было Деление
                                                     THEN 1000 * vbParValue
                                           END
                                          ) AS OperPrice_basis

                     -- Сумма по Вх. в Валюте - с округлением до 2-х знаков
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

                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.Id
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = Object_PartionGoods.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!ВРЕМЕННО!!! Доходы + Товары + Одежда

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Income()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- заполняем таблицу - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_SummPartner (MovementItemId, ContainerId, ContainerId_Currency, AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, GoodsId, PartionId, OperSumm, OperSumm_Currency)
        SELECT _tmpItem.MovementItemId
             , 0 AS ContainerId, 0 AS ContainerId_Currency, 0 AS AccountId
             , _tmpItem.InfoMoneyGroupId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId
             , _tmpItem.GoodsId
             , _tmpItem.PartionId
             , (_tmpItem.OperSumm)          AS OperSumm
             , (_tmpItem.OperSumm_Currency) AS OperSumm_Currency
        FROM _tmpItem
        ;


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

     -- 2.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId_To
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


     -- 3.1. определяется Счет(справочника) для проводок по долг Поставщику
     UPDATE _tmpItem_SummPartner SET AccountId  = _tmpItem_byAccount.AccountId
     FROM
          (SELECT lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT
                        zc_Enum_AccountGroup_60000()      AS AccountGroupId     -- Кредиторы
                      , zc_Enum_AccountDirection_60100()  AS AccountDirectionId -- поставщики
                      , _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.2.1. определяется ContainerId для проводок по долг Поставщику
     UPDATE _tmpItem_SummPartner SET ContainerId          = tmp.ContainerId
     FROM (SELECT tmp.InfoMoneyId
                  -- в Валюте Баланса
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner()
                                        , inObjectId_1        := vbPartnerId
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := tmp.InfoMoneyId
                                         ) AS ContainerId
           FROM (SELECT DISTINCT
                        _tmpItem_SummPartner.AccountId
                      , _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.InfoMoneyId = tmp.InfoMoneyId
    ;
     -- 3.2.2. определяется ContainerId для проводок по долг Поставщику
     UPDATE _tmpItem_SummPartner SET ContainerId_Currency = tmp.ContainerId_Currency
     FROM (SELECT tmp.InfoMoneyId
                  -- в Валюте Документа - если НАДО
                , lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                        , inParentId          := tmp.ContainerId
                                        , inObjectId          := tmp.AccountId
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner()
                                        , inObjectId_1        := vbPartnerId
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := tmp.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Currency()
                                        , inObjectId_3        := vbCurrencyDocumentId
                                         ) AS ContainerId_Currency
           FROM (SELECT DISTINCT
                        _tmpItem_SummPartner.ContainerId
                      , _tmpItem_SummPartner.AccountId
                      , _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner
                 WHERE vbCurrencyDocumentId <> zc_Currency_Basis()
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.InfoMoneyId = tmp.InfoMoneyId
    ;




     -- 4.1. формируются Проводки - остаток количество
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
            , _tmpItem.AccountId                      AS AccountId              -- НЕТ счета из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , _tmpItem.PartionId                      AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummPartner.AccountId          AS AccountId_Analyzer     -- Счет - корреспондент - по долгам поставщика
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_SummPartner.ContainerId        AS ContainerIntId_Analyzer-- Контейнер - Корреспондент - по долгам поставщика
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbPartnerId                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Контрагент
            , _tmpItem.OperCount                      AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.MovementItemId = _tmpItem.MovementItemId;


     -- 4.2. формируются Проводки - остаток сумма
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
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_SummPartner.AccountId          AS AccountId_Analyzer     -- Счет - корреспондент - по долгам поставщика
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_SummPartner.ContainerId        AS ContainerIntId_Analyzer-- Контейнер - Корреспондент - по долгам поставщика
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbPartnerId                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Контрагент
            , _tmpItem.OperSumm                       AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.MovementItemId = _tmpItem.MovementItemId;


     -- 4.3. формируются Проводки - долг Поставщику
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- это 2 проводки
       SELECT 0, _tmpItem_group.DescId, vbMovementDescId, inMovementId
            , 0                               AS MovementItemId
            , _tmpItem_group.ContainerId      AS ContainerId
            , 0                               AS ParentId
            , _tmpItem_group.AccountId        AS AccountId               -- Счет
            , 0                               AS AnalyzerId              -- Типы аналитик (проводки)
            , vbPartnerId                     AS ObjectId_Analyzer       -- Поставщик
            , 0                               AS PartionId               -- Партия
            , 0                               AS WhereObjectId_Analyzer  -- Место учета
            , 0                               AS AccountId_Analyzer      -- Счет - корреспондент
            , 0                               AS ContainerId_Analyzer    -- Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , 0                               AS ContainerIntId_Analyzer -- Контейнер - Корреспондент
            , 0                               AS ObjectIntId_Analyzer    -- Аналитический справочник
            , 0                               AS ObjectExtId_Analyzer    -- Аналитический справочник
            , -1 * _tmpItem_group.OperSumm    AS Amount
            , vbOperDate                      AS OperDate
            , FALSE                           AS isActive

       FROM (-- !!!одна!!! проводка в валюте Баланса
             SELECT zc_MIContainer_Summ() AS DescId, tmp.ContainerId, tmp.AccountId, SUM (tmp.OperSumm) AS OperSumm FROM _tmpItem_SummPartner AS tmp GROUP BY tmp.ContainerId, tmp.AccountId
            UNION ALL
             -- !!!одна!!! проводка для "забалансового" Валютного счета - если НАДО
             SELECT zc_MIContainer_SummCurrency() AS DescId, tmp.ContainerId_Currency AS ContainerId, tmp.AccountId, SUM (tmp.OperSumm_Currency) AS OperSumm FROM _tmpItem_SummPartner AS tmp WHERE vbCurrencyDocumentId <> zc_Currency_Basis() GROUP BY tmp.ContainerId_Currency, tmp.AccountId
            ) AS _tmpItem_group
       -- !!!не будем ограничивать, т.к. эти проводки ?МОГУТ? понадобится в отчетах!!!
       -- WHERE _tmpItem_group.OperSumm <> 0
      ;



     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Income()
                                , inUserId     := inUserId
                                 );

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- дописали - КОЛ-ВО
     UPDATE Object_PartionGoods SET Amount = _tmpItem.OperCount, isErased = FALSE, isArc = FALSE
                                  , OperDate = vbOperDate
     FROM _tmpItem
     WHERE Object_PartionGoods.MovementItemId = _tmpItem.MovementItemId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 08.06.17                                        *
 25.04.17         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 39, inSession:= zfCalc_UserAdmin())
