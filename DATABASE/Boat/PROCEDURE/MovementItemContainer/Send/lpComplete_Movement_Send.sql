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

  DECLARE vbMovementItemId   Integer;
  DECLARE vbMovementId_order Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbPartionId        Integer;
  DECLARE vbPartNumber       TVarChar;
  DECLARE vbAmount           TFloat;
  DECLARE vbAmount_partion   TFloat;

  DECLARE curItem            RefCursor;
  DECLARE curPartion         RefCursor;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     -- !!!обязательно!!! очистили таблицу - сколько осталось зарезервировать для Заказов клиента
     --DELETE FROM _tmpReserveDiff;
     -- !!!обязательно!!! элементы Резерв для Заказов клиента
     --DELETE FROM _tmpReserveRes;


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

                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Склады
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From
                  -- Аналитики счетов - направления - !!!ВРЕМЕННО - zc_Enum_AccountDirection_10100!!! Запасы + Склады
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
     -- проверка - Подразделение
     IF COALESCE (vbUnitId_From, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Подразделение (От кого)>.';
     END IF;
     -- проверка - Подразделение
     IF COALESCE (vbUnitId_To, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Подразделение (Кому)>.';
     END IF;

     -- доопределили - Аналитику для проводок
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;
     vbWhereObjectId_Analyzer_To  := CASE WHEN vbUnitId_To   <> 0 THEN vbUnitId_To   END;


     -- заполняем таблицу - элементы документа
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId
                         , Amount
                         , PartNumber
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , MovementId_order
                          )
        -- результат
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.Amount
             , tmp.PartNumber
               -- УП
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId
               --
             , tmp.MovementId_order

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.Amount              AS Amount
                     --
                   , MIString_PartNumber.ValueData    AS PartNumber
                     -- Управленческая группа
                   , View_InfoMoney.InfoMoneyGroupId
                     -- Управленческие назначения
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- Статьи назначения
                   , View_InfoMoney.InfoMoneyId

                    -- MovementId заказ Клиента
                  , COALESCE (MIFloat_MovementId.ValueData, 0) AS MovementId_order

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   -- ValueData - MovementId заказ Клиента
                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                               ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!ВРЕМЕННО!!! Комплектующие
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Send()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;




     -- 2.заполняем таблицу - элементы по партиям

     -- курсор1 - элементы документа
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId, _tmpItem.PartNumber, _tmpItem.MovementId_order
                           , _tmpItem.Amount
                      FROM _tmpItem
                     ;
     -- начало цикла по курсору1 - элементы документа
     LOOP
     -- данные по партиям
     FETCH curItem INTO vbMovementItemId, vbGoodsId, vbPartNumber, vbMovementId_order, vbAmount;
     -- если данные закончились, тогда выход
     IF NOT FOUND THEN EXIT; END IF;


     -- курсор2 - подбор остатков по партиям
     OPEN curPartion FOR
        SELECT Container.PartionId, Container.Amount - COALESCE (tmp.Amount, 0) AS Amount
        FROM Container
             -- св-во партии
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = Container.PartionId
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
             -- св-во партии
             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = Container.PartionId
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
             -- уже сформированные перемещения партий, их надо вычесть
             LEFT JOIN (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.PartionId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.PartionId
                       ) AS tmp ON tmp.GoodsId   = Container.ObjectId
                               AND tmp.PartionId = Container.PartionId

        WHERE Container.ObjectId      = vbGoodsId
          AND Container.WhereObjectId = vbWhereObjectId_Analyzer_From
          AND Container.Amount  - COALESCE (tmp.Amount, 0) > 0
        ORDER BY -- если MovementId_order совпадает
                 CASE WHEN MIFloat_MovementId.ValueData = vbMovementId_order AND vbMovementId_order <> 0 THEN 0 ELSE 1 END
                 -- если PartNumber совпадает
               , CASE WHEN MIString_PartNumber.ValueData = vbPartNumber AND vbPartNumber <> '' THEN 0 ELSE 1 END
                 -- если MovementId_order не установлен, подбираем сначала партии с пустым MovementId_order
               , CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0)  = 0 AND vbMovementId_order = 0 THEN 0 ELSE 1 END
                 -- если PartNumber не установлен, подбираем сначала партии с пустым PartNumber
               , CASE WHEN COALESCE (MIString_PartNumber.ValueData, '') = '' AND vbPartNumber = '' THEN 0 ELSE 1 END
               , Container.PartionId ASC
       ;
         -- начало цикла по курсору2. - остатки по партиям
         LOOP
             -- данные - сколько есть в остатках
             FETCH curPartion INTO vbPartionId, vbAmount_partion;
             -- если остатки закончились, или все кол-во уже переместили тогда выход
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- если на остатках больше чем надо
             IF vbAmount_partion > vbAmount
             THEN
                 -- заполняем таблицу - элементы zc_MI_Child документа
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                    AS MovementItemId -- Сформируем позже
                         , vbMovementItemId     AS ParentId
                         , vbGoodsId            AS GoodsId
                         , vbPartionId          AS PartionId
                           -- нашли нужное кол-во
                         , vbAmount             AS Amount
                           --
                         , vbMovementId_order   AS MovementId_order
                          ;
                 -- обнуляем кол-во, больше не надо искать
                 vbAmount:= 0;
             ELSE
                 -- заполняем таблицу - элементы zc_MI_Child документа
                 INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                    AS MovementItemId -- Сформируем позже
                         , vbMovementItemId     AS ParentId
                         , vbGoodsId            AS GoodsId
                         , vbPartionId          AS PartionId
                           -- переносим весь остаток по этой партии
                         , vbAmount_partion     AS Amount
                           --
                         , vbMovementId_order   AS MovementId_order
                          ;
                 -- уменьшаем нужное кол-во на остаток и продолжаем подбор
                 vbAmount:= vbAmount - vbAmount_partion;
             END IF;


         END LOOP; -- финиш цикла по курсору2. - остатки по партиям
         CLOSE curPartion; -- закрыли курсор2. - остатки по партиям


     END LOOP; -- финиш цикла по курсору1 - элементы документа
     CLOSE curItem; -- закрыли курсор1 - элементы документа



     -- добавили партии, которые надо создать, т.к. остатков по ним не нашли
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , Amount
                               , MovementId_order
                                )
        SELECT 0                       AS MovementItemId -- Сформируем позже
             , _tmpItem.MovementItemId AS ParentId
             , _tmpItem.GoodsId
               -- !!!ПАРТИЯ создается ?расходным документом?
             , _tmpItem.MovementItemId AS PartionId
               -- сколько в этой партии осталось создать
             , _tmpItem.Amount - COALESCE (tmp.Amount, 0)
               --
             , _tmpItem.MovementId_order
        FROM _tmpItem
             -- сколько партий подобрали, их надо вычесть
             LEFT JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.ParentId
                       ) AS tmp
                         ON tmp.ParentId = _tmpItem.MovementItemId
        WHERE _tmpItem.Amount - COALESCE (tmp.Amount, 0) > 0
       ;

     -- проверка - одинаковое кол-во _tmpItem + _tmpItem_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.Amount) AS Amount
                                FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                               ) AS tmpRes ON tmpRes.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во в элементах = <%> не может отличаться от кол-ва в партиях = <%> <%>.'
                     , (SELECT _tmpItem.Amount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , COALESCE ((SELECT tmpReserveRes.Amount
                                  FROM _tmpItem
                                       FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                                  FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                                 ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                                  WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                                  ORDER BY _tmpItem.MovementItemId
                                  LIMIT 1
                                 ), 0)
                     , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
               ;
     END IF;


     -- RAISE EXCEPTION 'test.<%> <%>', (SELECT SUM (_tmpItem.Amount) FROM _tmpItem), (SELECT SUM (_tmpReserveRes.Amount) FROM _tmpReserveRes);


     -- Создали партии
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := tmpItem.PartionId
                                               , inMovementId        := inMovementId              -- Ключ Документа
                                               , inFromId            := vbUnitId_From             -- Поставщик или Подразделение (место сборки)
                                               , inUnitId            := vbUnitId_From             -- Подразделение(прихода)
                                               , inOperDate          := vbOperDate                -- Дата прихода
                                               , inObjectId          := tmpItem.GoodsId           -- Комплектующие или Лодка
                                               , inAmount            := tmpItem.Amount            -- Кол-во приход
                                                 --
                                               , inEKPrice           := tmpItem.EKPrice_find      -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка = inEKPrice_discount + inCostPrice
                                               , inEKPrice_orig      := tmpItem.EKPrice_find      -- Цена вх. без НДС, с учетом ТОЛЬКО скидки по элементу
                                               , inEKPrice_discount  := tmpItem.EKPrice_find      -- Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
                                               , inCostPrice         := 0                         -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
                                               , inCountForPrice     := 1                         -- Цена за количество
                                                 --
                                               , inEmpfPrice         := tmpItem.EmpfPrice         -- Цена рекоменд. без НДС
                                               , inOperPriceList     := 0                         -- Цена продажи
                                               , inOperPriceList_old := 0                         -- Цена продажи, ДО изменения строки
                                                 -- Тип НДС (!информативно!)
                                               , inTaxKindId         := zc_TaxKind_Basis()
                                                 -- Значение НДС (!информативно!)
                                               , inTaxKindValue      := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_TaxKind_Basis()  AND OFl.DescId = zc_ObjectFloat_TaxKind_Value())
                                                 --
                                               , inUserId            := inUserId
                                                )
     FROM (WITH --
                tmpItem AS (SELECT _tmpItem_Child.*
                                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0)    AS EKPrice
                                 , COALESCE (ObjectFloat_EmpfPrice .ValueData, 0) AS EmpfPrice
                            FROM _tmpItem_Child
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                       ON ObjectFloat_EKPrice.ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                       ON ObjectFloat_EmpfPrice .ObjectId = _tmpItem_Child.GoodsId
                                                      AND ObjectFloat_EmpfPrice .DescId   =  zc_ObjectFloat_Goods_EmpfPrice ()
                            -- условие - тогда надо создать партии
                            WHERE _tmpItem_Child.ParentId = _tmpItem_Child.PartionId
                           )
                -- загруженные цены Поставщика
              , tmpItemPrice AS (SELECT tmpItem.GoodsId
                                        -- Dealer_Price или Price per Base U.M. или Trade Unit Price
                                      , MovementItem.Amount AS EKPrice
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY tmpItem.GoodsId ORDER BY Movement.OperDate DESC) AS Ord
                                 FROM tmpItem
                                      INNER JOIN MovementItem ON MovementItem.ObjectId = tmpItem.GoodsId
                                                             AND MovementItem.DescId   = zc_MI_Master()
                                                             AND MovementItem.isErased = FALSE
                                      INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                         AND Movement.DescId   = zc_Movement_PriceList()
                                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                 WHERE tmpItem.EKPrice = 0
                                )
           -- Результат
           SELECT tmpItem.*
                , COALESCE (tmpItemPrice.EKPrice, tmpItem.EKPrice) AS EKPrice_find
           FROM tmpItem
                LEFT JOIN tmpItemPrice ON tmpItemPrice.GoodsId = tmpItem.GoodsId
                                      AND tmpItemPrice.Ord     = 1
          ) AS tmpItem
    ;


     -- удалили - ВСЕ - zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE;


     -- сохраняем - zc_MI_Child - текущее Перемещение
     UPDATE _tmpItem_Child SET MovementItemId = lpInsertUpdate_MI_Send_Child (ioId                     := _tmpItem_Child.MovementItemId
                                                                            , inParentId               := _tmpItem_Child.ParentId
                                                                            , inMovementId             := inMovementId
                                                                            , inMovementId_OrderClient := _tmpItem_Child.MovementId_order
                                                                            , inObjectId               := _tmpItem_Child.GoodsId
                                                                            , inPartionId              := _tmpItem_Child.PartionId
                                                                              -- кол-во резерв
                                                                            , inAmount                 := _tmpItem_Child.Amount
                                                                            , inUserId                 := inUserId
                                                                             )
     -- !!!ВСЕ элементы
     --WHERE _tmpItem_Child.MovementItemId = 0
    ;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem_Child SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_From
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                          , inPartionId              := _tmpItem_Child.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                           )
                             , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_To
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                          , inPartionId              := _tmpItem_Child.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                           )
     FROM _tmpItem
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;

     -- 2.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpItem_Child SET AccountId_From = _tmpItem_byAccount.AccountId_From
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
          JOIN _tmpItem ON _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
    ;


     -- 2.2. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpItem_Child SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_From
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpItem_Child.AccountId_From
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpItem_Child.ContainerId_GoodsFrom
                                                                                        , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                        , inPartionId              := _tmpItem_Child.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
                             , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_To
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpItem_Child.AccountId_To
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpItem_Child.ContainerId_GoodsTo
                                                                                        , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                        , inPartionId              := _tmpItem_Child.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
     FROM _tmpItem
     WHERE _tmpItem_Child.ParentId = _tmpItem.MovementItemId
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
       -- проводки - РАСХОД
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_From           AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_Child.AccountId_To             AS AccountId_Analyzer     -- Счет - корреспондент - по ПРИХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_Child.ContainerId_SummTo       AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по ПРИХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому
            , -1 * _tmpItem_Child.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
      UNION ALL
       -- проводки - ПРИХОД
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_To             AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_Child.AccountId_From           AS AccountId_Analyzer     -- Счет - корреспондент - по РАСХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_Child.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по РАСХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого
            , 1 * _tmpItem_Child.Amount               AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Child;


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
            , _tmpItem_Child.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_From           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_Child.AccountId_To             AS AccountId_Analyzer     -- Счет - корреспондент - по ПРИХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_Child.ContainerId_SummTo       AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по ПРИХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому
            , -1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_SummFrom
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_Child.MovementItemId
            , _tmpItem_Child.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId_To             AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_Child.AccountId_From           AS AccountId_Analyzer     -- Счет - корреспондент - по РАСХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_Child.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по РАСХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого
            , 1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                            THEN Container_Summ.Amount
                       ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                  END                                 AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_SummFrom
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 687, inSession:= zfCalc_UserAdmin())
