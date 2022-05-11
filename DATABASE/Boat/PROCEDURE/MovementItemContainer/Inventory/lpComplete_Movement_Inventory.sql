DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbIsList                   Boolean;
  DECLARE vbUnitId                   Integer;
  DECLARE vbAccountDirectionId       Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- значение пока НЕ определяется
  DECLARE vbBusinessId               Integer; -- значение пока НЕ определяется

  DECLARE vbWhereObjectId_Analyzer   Integer; -- Аналитика для проводок

  DECLARE curItem             RefCursor;
  DECLARE curRemainsCalc      RefCursor;
  DECLARE vbMovementItemId    Integer;
  DECLARE vbContainerId       Integer;
  DECLARE vbGoodsId           Integer;
  DECLARE vbPartionId         Integer;
  DECLARE vbPartNumber        TVarChar;
  DECLARE vbOperCount         TFloat;
  DECLARE vbAmount_remains    TFloat;
  DECLARE vbContainerId_start Integer;
  DECLARE vbPartionId_start   Integer;

BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     DELETE FROM _tmpRemains;


     -- Параметры из документа
     SELECT tmp.MovementDescId, tmp.OperDate, tmp.isList, tmp.UnitId
          , tmp.AccountDirectionId
            INTO vbMovementDescId
               , vbOperDate
               , vbIsList
               , vbUnitId
               , vbAccountDirectionId

     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (MovementBoolean_List.Valuedata, FALSE) isList
                , COALESCE (CASE WHEN Object_Unit.DescId = zc_Object_Unit() THEN Object_Unit.Id ELSE 0 END, 0) AS UnitId

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Склады
                , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId

           FROM Movement
                LEFT JOIN MovementBoolean AS MovementBoolean_List
                                          ON MovementBoolean_List.MovementId = Movement.Id
                                         AND MovementBoolean_List.DescId     = zc_MovementBoolean_List()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                            AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_Unit.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()
           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Inventory()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- проверка - Подразделение
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Подразделение (От кого)>.';
     END IF;

     -- доопределили - Аналитику для проводок
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId END;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId, PartNumber
                         , OperCount, OperPrice
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- результат
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.PartNumber
             , tmp.OperCount
             , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (inOperDate:= vbOperDate, inGoodsId:= tmp.GoodsId, inUserId:= inUserId) AS lpGet) AS OperPrice
               -- УП
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                     -- факт остаток
                   , MovementItem.Amount              AS OperCount
                     --
                   , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
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
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!ВРЕМЕННО!!! Комплектующие
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Inventory()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;

     -- проверка -
     IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено дублирование <Строка>%<%><%>.'
                        , CHR (13)
                        , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId    FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1))
                        ,                         (SELECT _tmpItem.PartNumber FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1)
                         ;
     END IF;

     -- Расчетный остаток
     INSERT INTO _tmpRemains (ContainerId, GoodsId, PartionId, PartNumber, OperDate, Amount_container, Amount)
        WITH -- ВСЕ остаки на vbUnitId
             tmpContainer_Count AS (SELECT Container.Id            AS ContainerId
                                         , Container.ObjectId      AS GoodsId
                                         , COALESCE (Container.PartionId, 0)            AS PartionId
                                         , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                                         , Container.Amount AS Amount_container
                                         , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                                    FROM Container
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.ContainerId = Container.Id
                                                                        AND MIContainer.OperDate    > vbOperDate
                                         LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                      ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                                     AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                    WHERE Container.WhereObjectId = vbUnitId
                                      AND Container.DescId        = zc_Container_Count()
                                      AND (Container.ObjectId IN (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem)
                                           OR vbIsList = FALSE)
                                    GROUP BY Container.Id
                                           , Container.ObjectId
                                           , Container.PartionId
                                           , MIString_PartNumber.ValueData
                                    HAVING Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                                   )
             -- нашли ОДИН PartionId - MAX
           , tmpContainer_find AS (SELECT _tmpItem.GoodsId
                                        , _tmpItem.PartNumber
                                        , Object_PartionGoods.MovementItemId AS PartionId
                                        , Object_PartionGoods.OperDate       AS OperDate
                                          -- № п/п
                                        , ROW_NUMBER() OVER (PARTITION BY _tmpItem.GoodsId, _tmpItem.PartNumber ORDER BY COALESCE (Container.Amount, 0) DESC, Object_PartionGoods.OperDate DESC) AS Ord
                                   FROM _tmpItem
                                        LEFT JOIN tmpContainer_Count ON tmpContainer_Count.GoodsId    = _tmpItem.GoodsId
                                                                    AND tmpContainer_Count.PartNumber = _tmpItem.PartNumber
                                        INNER JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = _tmpItem.GoodsId
                                        LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                     ON MIString_PartNumber.MovementItemId = Object_PartionGoods.MovementItemId
                                                                    AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                        -- если есть остаток на "другом" Подразделении
                                        LEFT JOIN Container ON Container.PartionId = Object_PartionGoods.MovementItemId
                                                           AND Container.Amount > 0
                                   WHERE tmpContainer_Count.GoodsId IS NULL
                                     AND COALESCE (MIString_PartNumber.ValueData, '') = _tmpItem.PartNumber
                                     AND _tmpItem.OperCount > 0
                                  )
            -- расчетный остаток на дату
            SELECT tmpContainer_Count.ContainerId
                 , tmpContainer_Count.GoodsId
                 , tmpContainer_Count.PartionId
                 , tmpContainer_Count.PartNumber
                 , Object_PartionGoods.OperDate
                 , tmpContainer_Count.Amount_container
                 , tmpContainer_Count.Amount
            FROM tmpContainer_Count
                 LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpContainer_Count.PartionId
           UNION
            -- найдены партии PartionId, но остаток = 0
            SELECT 0 AS ContainerId
               , tmpContainer_find.GoodsId
               , tmpContainer_find.PartionId
               , tmpContainer_find.PartNumber
               , tmpContainer_find.OperDate
               , 0 AS Amount_container
               , 0 AS Amount
            FROM tmpContainer_find
           ;

     -- курсор1 - факт остаток
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartNumber, _tmpItem.OperCount
                      FROM _tmpItem
                     ;
     -- начало цикла по курсору1 - факт остаток
     LOOP
         -- данные - факт остаток
         FETCH curItem INTO vbMovementItemId, vbGoodsId, vbPartNumber, vbOperCount;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- Обнулмлм
         vbContainerId_start:= 0;
         vbPartionId_start  := 0;

         -- курсор2. - остаток расчетный
         OPEN curRemainsCalc FOR
            SELECT _tmpRemains.ContainerId, _tmpRemains.PartionId, _tmpRemains.Amount
            FROM _tmpRemains
            WHERE _tmpRemains.GoodsId    = vbGoodsId
              AND _tmpRemains.PartNumber = vbPartNumber
            ORDER BY _tmpRemains.OperDate DESC, _tmpRemains.ContainerId DESC
           ;

             -- начало цикла по курсору2. - расчетный остаток
             LOOP
                 -- данные - расчетный остаток
                 FETCH curRemainsCalc INTO vbContainerId, vbPartionId, vbAmount_remains;
                 -- если данные закончились, тогда выход
                 IF NOT FOUND THEN EXIT; END IF;

                 -- сохранили "первую"  партию
                 IF vbPartionId_start = 0
                 THEN
                    vbContainerId_start:= vbContainerId;
                    vbPartionId_start  := vbPartionId;
                 END IF;

                 --
                 IF vbAmount_remains > vbOperCount OR vbAmount_remains < 0
                 THEN
                     -- остальной остаток - надо списать
                     INSERT INTO _tmpItem_Child (MovementItemId, ContainerId, ContainerId_summ
                                               , GoodsId, PartionId, PartNumber
                                               , OperCount
                                                )
                        SELECT vbMovementItemId AS MovementItemId
                             , vbContainerId    AS ContainerId
                             , 0                AS ContainerId_summ
                             , vbGoodsId        AS GoodsId
                             , vbPartionId      AS PartionId
                             , vbPartNumber     AS PartNumber
                             , -1 * (vbAmount_remains - CASE WHEN vbAmount_remains > 0 THEN vbOperCount ELSE 0 END) AS OperCount
                              ;
                     --
                     IF vbAmount_remains > 0 THEN vbOperCount:= 0; END IF;
                 ELSE
                     -- уменьшили и крутим дальше
                     vbOperCount:= vbOperCount - vbAmount_remains;
                 END IF;


             END LOOP; -- финиш цикла по курсору2. - расчетный остаток
             CLOSE curRemainsCalc; -- закрыли курсор2. - расчетный остаток

             -- Если факт больше расчетного
             IF vbOperCount <> 0
             THEN
                     -- остальной остаток надо приходовать - на "последнюю" партию или "пустую"
                     INSERT INTO _tmpItem_Child (MovementItemId, ContainerId, ContainerId_summ
                                               , GoodsId, PartionId, PartNumber
                                               , OperCount
                                                )
                        SELECT vbMovementItemId       AS MovementItemId
                             , vbContainerId_start    AS ContainerId
                             , 0                      AS ContainerId_summ
                             , vbGoodsId              AS GoodsId
                             , vbPartionId_start      AS PartionId
                             , vbPartNumber           AS PartNumber
                             , 1 * vbOperCount        AS OperCount
                              ;
             END IF;

     END LOOP; -- финиш цикла по курсору1 - факт остаток
     CLOSE curItem; -- закрыли курсор1 - факт остаток


     -- остальной расчетный остаток - надо списать + создать MovementItemId
     INSERT INTO _tmpItem_Child (MovementItemId, ContainerId, ContainerId_summ
                               , GoodsId, PartionId, PartNumber
                               , OperCount
                                )
        SELECT 0                          AS MovementItemId
             , _tmpRemains.ContainerId    AS ContainerId
             , 0                          AS ContainerId_summ
             , _tmpRemains.GoodsId        AS GoodsId
             , _tmpRemains.PartionId      AS PartionId
             , _tmpRemains.PartNumber     AS PartNumber
             , -1 * _tmpRemains.Amount    AS OperCount
        FROM _tmpRemains
             LEFT JOIN _tmpItem ON _tmpItem.GoodsId    = _tmpRemains.GoodsId
                               AND _tmpItem.PartNumber = _tmpRemains.PartNumber
        WHERE _tmpItem.GoodsId IS NULL
       ;

     -- Создали Элементы
     UPDATE _tmpItem_Child SET MovementItemId = tmp.MovementItemId
     FROM (SELECT tmp.GoodsId, tmp.PartNumber
                , (SELECT tmp.ioId
                   FROM lpInsertUpdate_MovementItem_Inventory (ioId              := 0
                                                             , inMovementId      := inMovementId
                                                             , inGoodsId         := tmp.GoodsId
                                                             , ioAmount          := 0
                                                             , inTotalCount      := 0
                                                             , inTotalCount_old  := 0
                                                             , ioPrice           := 0
                                                             , inPartNumber      := tmp.PartNumber
                                                             , inComment         := ''
                                                             , inUserId          := inUserId
                                                              ) AS tmp) AS MovementItemId

           FROM (SELECT DISTINCT _tmpItem_Child.GoodsId, _tmpItem_Child.PartNumber
                 FROM _tmpItem_Child
                 WHERE _tmpItem_Child.MovementItemId = 0
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_Child.MovementItemId = 0
       AND _tmpItem_Child.GoodsId        = tmp.GoodsId
       AND _tmpItem_Child.PartNumber     = tmp.PartNumber
      ;


     -- заполняем-2 таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId, PartNumber
                         , OperCount, OperPrice
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- результат
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.PartNumber
             , tmp.OperCount
             , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (inOperDate:= vbOperDate, inGoodsId:= tmp.GoodsId, inUserId:= inUserId) AS lpGet) AS OperPrice
               -- УП
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                     -- факт остаток
                   , MovementItem.Amount              AS OperCount
                     --
                   , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
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
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!ВРЕМЕННО!!! Комплектующие
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

                   LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = MovementItem.Id

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Inventory()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                AND _tmpItem.MovementItemId IS NULL
             ) AS tmp
            ;

     -- проверка - 2
     IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка-2.Найдено дублирование <Комплектующие>.<%><%>'
                        , lfGet_Object_ValueData ((SELECT _tmpItem.GoodsId    FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1))
                        ,                         (SELECT _tmpItem.PartNumber FROM _tmpItem GROUP BY _tmpItem.GoodsId, _tmpItem.PartNumber HAVING COUNT(*) > 1 ORDER BY _tmpItem.GoodsId, _tmpItem.PartNumber LIMIT 1)
                         ;
     END IF;


     -- Создали Партии - где надо
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := _tmpItem_Child.MovementItemId        -- Ключ партии
                                               , inMovementId        := inMovementId                         -- Ключ Документа
                                               , inFromId            := vbUnitId                             -- Поставщик или Подразделение (место сборки)
                                               , inUnitId            := vbUnitId                             -- Подразделение(прихода)
                                               , inOperDate          := vbOperDate                           -- Дата прихода
                                               , inObjectId          := _tmpItem_Child.GoodsId               -- Комплектующие или Лодка
                                               , inAmount            := _tmpItem_Child.OperCount             -- Кол-во приход
                                               , inEKPrice           := _tmpItem.OperPrice                   -- Цена вх. без НДС, !!!с учетом скидки!!!
                                               , inCountForPrice     := 1                                    -- Цена за количество
                                               , inEmpfPrice         := 0                                    -- Цена рекоменд. без НДС
                                               , inOperPriceList     := 0                                    -- Цена продажи
                                               , inOperPriceList_old := 0                                    -- Цена продажи, ДО изменения строки
                                               , inTaxKindId         := 0                                    -- Тип НДС (!информативно!)
                                               , inTaxKindValue      := 0                                    -- Значение НДС (!информативно!)
                                               , inUserId            := inUserId                             --
                                                )
     FROM _tmpItem_Child
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_Child.MovementItemId
     WHERE _tmpItem_Child.PartionId = 0;


     -- дописали партию
     UPDATE _tmpItem_Child SET PartionId = _tmpItem_Child.MovementItemId WHERE _tmpItem_Child.PartionId = 0;


     -- 1. определяется ContainerId для количественного учета - где надо
     UPDATE _tmpItem_Child SET ContainerId = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                , inPartionId              := _tmpItem_Child.PartionId
                                                                                , inIsReserve              := FALSE
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId    = _tmpItem_Child.MovementItemId
       AND _tmpItem_Child.ContainerId = 0
    ;

     -- 2.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpItem_Child SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
          JOIN _tmpItem ON _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpItem_Child.MovementItemId = _tmpItem.MovementItemId
    ;



     -- 2.2. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpItem_Child SET ContainerId_summ = CASE WHEN Container.Id > 0
                                                            THEN Container.Id
                                                       ELSE lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                              , inUnitId                 := vbUnitId
                                                                                              , inMemberId               := NULL
                                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                              , inBusinessId             := vbBusinessId
                                                                                              , inAccountId              := _tmpItem_Child.AccountId
                                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                              , inContainerId_Goods      := _tmpItem_Child.ContainerId
                                                                                              , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                              , inPartionId              := _tmpItem_Child.PartionId
                                                                                              , inIsReserve              := FALSE
                                                                                               )
                                                  END

                           , ContainerId_ProfitLoss = lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()      -- DescId Суммовой учет
                                                                            , inParentId          := NULL                     -- Главный Container
                                                                            , inObjectId          := zc_Enum_Account_90301()  -- Объект всегда Счет для Суммовой учет
                                                                            , inPartionId         := NULL
                                                                            , inIsReserve         := FALSE
                                                                            , inJuridicalId_basis := vbJuridicalId_Basis      -- Главное юридическое лицо
                                                                            , inBusinessId        := vbBusinessId             -- Бизнесы
                                                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss() -- DescId для 1-ой Аналитики
                                                                            , inObjectId_1        := zc_Enum_Account_90301()  -- временно, надо будет потом использовать lpInsertFind_Object_ProfitLoss
                                                                             )

                             , OperSumm = CASE WHEN -- если списали остаток
                                                    _tmpRemains.Amount_container = -1 * _tmpItem_Child_find.OperCount
                                                    THEN -- спишем сумму остатка
                                                         -1 * COALESCE (Container.Amount, 0)
                                               -- иначе всегда из партии
                                               ELSE _tmpItem_Child_find.OperCount * Object_PartionGoods.EKPrice
                                          END
     FROM _tmpItem_Child AS _tmpItem_Child_find
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_Child_find.MovementItemId
          LEFT JOIN _tmpRemains ON _tmpRemains.ContainerId = _tmpItem_Child_find.ContainerId
          LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child_find.PartionId
          LEFT JOIN Container ON Container.ParentId = _tmpItem_Child_find.ContainerId
                             AND Container.DescId   = zc_Container_Summ()
     WHERE _tmpItem_Child_find.ContainerId = _tmpItem_Child.ContainerId
    ;



     -- 3.1. формируются Проводки - остаток количество
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - изменение Остаток Кол-во
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ПРИБЫЛЬ
            , _tmpItem_Child.ContainerId_ProfitLoss   AS ContainerId_Analyzer   -- Контейнер - корреспондент - ПРИБЫЛЬ
            , 0                                       AS ContainerExtId_Analyzer-- нет - Контейнер - Корреспондент
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , 0                                       AS ObjectExtId_Analyzer   -- Аналитический справочник
            , 1 * _tmpItem_Child.OperCount            AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      ;


     -- 3.2. формируются Проводки - остаток сумма
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- проводки - РАСХОД
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Место учета
            , zc_Enum_Account_90301()                 AS AccountId_Analyzer     -- Счет - корреспондент - ПРИБЫЛЬ
            , _tmpItem_Child.ContainerId_ProfitLoss   AS ContainerId_Analyzer   -- Контейнер - корреспондент - ПРИБЫЛЬ
            , 0                                       AS ContainerExtId_Analyzer-- нет - Контейнер - Корреспондент
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , 0                                       AS ObjectExtId_Analyzer   -- Аналитический справочник
            , _tmpItem_Child.OperSumm                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child

      UNION ALL
       -- проводки - ОПиУ
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_ProfitLoss
            , 0                                       AS ParentId
            , zc_Enum_Account_90301()                 AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Место учета
            , 0                                       AS AccountId_Analyzer     -- в ОПиУ не нужен
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , 0                                       AS ContainerExtId_Analyzer-- нет - Контейнер - Корреспондент
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , 0                                       AS ObjectExtId_Analyzer   -- Аналитический справочник
            , -1 * _tmpItem_Child.OperSumm            AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      ;


     -- 5.0. сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), _tmpItem.MovementItemId, COALESCE (_tmpItem.OperPrice, 0))
     FROM _tmpItem;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := inUserId
                                 );

   /* RAISE EXCEPTION 'Ошибка. <%>  <%>  <%>  <%>', (select count() from _tmpItem  where _tmpItem.MovementItemId = 56225)
                  , (select count() from _tmpItem_Child  where _tmpItem_Child.MovementItemId = 56225)
                  , (select count() from _tmpRemains  where _tmpRemains.GoodsId = 14982)
                  , (select count() from _tmpMIContainer_insert)
                                       ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 25.04.17         *
*/

-- тест
-- select * from lpComplete_Movement_Inventory (inMovementId:= 604, inUserId:= '5');
