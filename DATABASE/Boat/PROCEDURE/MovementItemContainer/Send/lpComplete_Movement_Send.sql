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

  DECLARE curReserveDiff     RefCursor;
  DECLARE curItem            RefCursor;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbMovementId_order Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbPartionId        Integer;
  DECLARE vbAmount           TFloat;
  DECLARE vbAmount_Reserve   TFloat;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;
     DELETE FROM _tmpItem_Child;
     -- !!!обязательно!!! очистили таблицу - сколько осталось зарезервировать для Заказов клиента
     DELETE FROM _tmpReserveDiff;
     -- !!!обязательно!!! элементы Резерв для Заказов клиента
     DELETE FROM _tmpReserveRes;


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



     -- заполняем таблицу - элементы zc_MI_Child документа
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , OperCount
                               , MovementId_order
                                )
        SELECT MovementItem.Id, MovementItem.ParentId
             , MovementItem_parent.ObjectId
             , MovementItem.PartionId
             , MovementItem.Amount
             , MIFloat_MovementId.ValueData AS MovementId_order
        FROM MovementItem
             INNER JOIN MovementItem AS MovementItem_parent
                                     ON MovementItem_parent.MovementId = MovementItem.MovementId
                                    AND MovementItem_parent.DescId     = zc_MI_Master()
                                    AND MovementItem_parent.Id         = MovementItem.ParentId
                                    AND MovementItem_parent.isErased   = FALSE
             INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
             -- ValueData - MovementId заказ Клиента
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
       ;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId
                         , OperCount
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- результат
        SELECT tmp.MovementItemId
             , tmp.GoodsId
             , tmp.OperCount
               -- УП
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.Amount              AS OperCount
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


     -- проверка - zc_MI_Master + zc_MI_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.OperCount) AS OperCount
                                FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                               ) AS tmpItem_Child ON tmpItem_Child.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.OperCount, 0) < COALESCE (tmpItem_Child.OperCount, 0)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во в партиях не может быть больше чем в элементах.';
     END IF;

     -- 1.заполняем таблицу - сколько осталось переместить из резервов для Заказов клиента
     INSERT INTO _tmpReserveDiff (MovementId_order, OperDate_order, GoodsId, PartionId, Amount)
        WITH -- Только по этим комплектующим
             tmpGoods AS (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem)
             -- ВСЕ Резервы
           , tmpMI_Child AS (-- Заказы клиента - zc_MI_Child - детализация по Резервам
                             SELECT Movement.OperDate       AS OperDate_order
                                  , MovementItem.MovementId AS MovementId_order
                                  , MovementItem.ObjectId
                                  , MovementItem.PartionId
                                    -- Кол-во - попало в Резерв
                                  , MovementItem.Amount
                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Child()
                                                         AND MovementItem.isErased   = FALSE
                                                         -- элементы резерва, хотя они здесь и так
                                                         --AND MovementItem.ParentId > 0
                                  -- На всякий случай - zc_MI_Master не удален
                                  INNER JOIN MovementItem AS MI_Master
                                                          ON MI_Master.MovementId = Movement.Id
                                                         AND MI_Master.DescId     = zc_MI_Child() -- !!!НЕ Ошибка!!!
                                                         AND MI_Master.Id         = MovementItem.ParentId
                                                         AND MI_Master.isErased   = FALSE
                                  -- ограничение - только по этим комплектующим
                                  INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                  -- ограничение - только для этого Склада
                                  INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                                                   AND MILinkObject_Unit.ObjectId       = vbUnitId_From
                             WHERE Movement.DescId   = zc_Movement_OrderClient()
                               -- все НЕ удаленные
                               AND Movement.StatusId <> zc_Enum_Status_Erased()
                               -- Кол-во - попало в Резерв
                               AND MovementItem.Amount > 0

                            -- Приходы от поставщика - zc_MI_Child - детализация по Резервам
                            UNION ALL
                             SELECT Movement_OrderClient.OperDate AS OperDate_order
                                  , Movement_OrderClient.Id       AS MovementId_order
                                  , MovementItem.ObjectId
                                  , MovementItem.PartionId
                                    -- Кол-во - попало в Резерв
                                  , MovementItem.Amount
                             FROM Movement
                                  -- ограничение - только приход на этот Склад
                                  INNER JOIN MovementLinkObject AS MLO_To
                                                                ON MLO_To.MovementId = Movement.Id
                                                               AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                               AND MLO_To.ObjectId   = vbUnitId_From
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Child()
                                                         AND MovementItem.isErased   = FALSE
                                  -- zc_MI_Master не удален
                                  INNER JOIN MovementItem AS MI_Master
                                                          ON MI_Master.MovementId = Movement.Id
                                                         AND MI_Master.DescId     = zc_MI_Master()
                                                         AND MI_Master.Id         = MovementItem.ParentId
                                                         AND MI_Master.isErased   = FALSE
                                  -- ограничение - только по этим комплектующим
                                  INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                  -- ValueData - MovementId заказ Клиента
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                              ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                             AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                  LEFT JOIN Movement Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer
                             WHERE Movement.DescId   = zc_Movement_Income()
                               -- Проведенные
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                            )
              -- Перемещения - сколько уже переместили Резервов под Заказ клиента
            , tmpMI_Send AS (SELECT MovementItem.MovementId
                                  , MovementItem.ObjectId
                                  , MovementItem.PartionId
                                    -- Сколько переместили
                                  , MovementItem.Amount
                                    -- Заказ клиента
                                  , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                             FROM MovementItemFloat AS MIFloat_MovementId
                                  INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                         AND MovementItem.DescId   = zc_MI_Child()
                                                         AND MovementItem.isErased = FALSE
                                  -- это точно Перемещение
                                  INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     AND Movement.DescId   = zc_Movement_Send()
                                                     -- все НЕ удаленные
                                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                   --AND Movement.StatusId = zc_Enum_Status_Complete()
                                 -- zc_MI_Master не удален
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                             WHERE MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpMI_Child.MovementId_order FROM tmpMI_Child)
                               AND MIFloat_MovementId.DescId   = zc_MIFloat_MovementId()
                            )
        -- сколько осталось переместить для Заказов клиента
        SELECT tmpMI_Child.MovementId_order
             , tmpMI_Child.OperDate_order
             , tmpMI_Child.ObjectId
             , tmpMI_Child.PartionId
               -- осталось
             , tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) AS Amount

        FROM (SELECT tmpMI_Child.MovementId_order, tmpMI_Child.OperDate_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId, SUM (tmpMI_Child.Amount) AS Amount
              FROM tmpMI_Child
              GROUP BY tmpMI_Child.MovementId_order, tmpMI_Child.OperDate_order, tmpMI_Child.ObjectId, tmpMI_Child.PartionId
             ) AS tmpMI_Child
             -- Итого сколько переместили
             LEFT JOIN (SELECT tmpMI_Send.MovementId_order
                             , tmpMI_Send.ObjectId
                             , tmpMI_Send.PartionId
                             , SUM (tmpMI_Send.Amount) AS Amount
                        FROM tmpMI_Send
                        -- !!!с текущим Перемещением
                        --WHERE tmpMI_Send.MovementId <> inMovementId
                        GROUP BY tmpMI_Send.MovementId_order
                               , tmpMI_Send.ObjectId
                               , tmpMI_Send.PartionId
                       ) AS tmpMI_Send
                         ON tmpMI_Send.MovementId_order = tmpMI_Child.MovementId_order
                        AND tmpMI_Send.PartionId        = tmpMI_Child.PartionId
        -- !! осталось что Перемещать!!!
        WHERE tmpMI_Child.Amount - COALESCE (tmpMI_Send.Amount, 0) > 0
        ;


     -- 2.заполняем таблицу - элементы Перемещаем Резерв для Заказов клиента

     -- курсор1 - элементы перемещения
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.GoodsId
                             -- определется - сколько партий осталось найти
                           , _tmpItem.OperCount- COALESCE (tmpItem_Child.OperCount, 0) AS Amount
                      FROM _tmpItem
                           -- уже сформированные перемещения партий, их надо вычесть
                           LEFT JOIN (SELECT _tmpItem_Child.ParentId, SUM (_tmpItem_Child.OperCount) AS OperCount
                                      FROM _tmpItem_Child GROUP BY _tmpItem_Child.ParentId
                                     ) AS tmpItem_Child ON tmpItem_Child.ParentId = _tmpItem.MovementItemId
                     ;
     -- начало цикла по курсору1 - приходы
     LOOP
     -- данные по приходам
     FETCH curItem INTO vbMovementItemId, vbGoodsId, vbAmount;
     -- если данные закончились, тогда выход
     IF NOT FOUND THEN EXIT; END IF;

     -- курсор2. - осталось зарезервировать МИНУС сколько уже зарезервировли для vbGoodsId
     OPEN curReserveDiff FOR
        SELECT _tmpReserveDiff.MovementId_order, _tmpReserveDiff.PartionId, _tmpReserveDiff.Amount - COALESCE (tmp.Amount, 0)
        FROM _tmpReserveDiff
             LEFT JOIN (SELECT _tmpReserveRes.MovementId_order, _tmpReserveRes.GoodsId, _tmpReserveRes.PartionId, SUM (_tmpReserveRes.Amount) AS Amount FROM _tmpReserveRes GROUP BY _tmpReserveRes.MovementId_order, _tmpReserveRes.GoodsId, _tmpReserveRes.PartionId
                       ) AS tmp ON tmp.MovementId_order = _tmpReserveDiff.MovementId_order
                               AND tmp.GoodsId          = _tmpReserveDiff.GoodsId
                               AND tmp.PartionId        = _tmpReserveDiff.PartionId
        WHERE _tmpReserveDiff.GoodsId = vbGoodsId
          AND _tmpReserveDiff.Amount - COALESCE (tmp.Amount, 0) > 0
        ORDER BY _tmpReserveDiff.OperDate_order ASC
       ;
         -- начало цикла по курсору2. - Резервы
         LOOP
             -- данные - сколько осталось зарезервировать
             FETCH curReserveDiff INTO vbMovementId_order, vbPartionId, vbAmount_Reserve;
             -- если данные закончились, или все кол-во зарезервировли тогда выход
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             --
             IF vbAmount_Reserve > vbAmount
             THEN
                 -- получилось в zc_MI_Master меньше чем надо резервировать - заполняем таблицу - элементы Резерв для Заказов клиента
                 INSERT INTO _tmpReserveRes (MovementItemId, ParentId
                                           , GoodsId, PartionId
                                           , ContainerId_SummFrom, ContainerId_GoodsFrom
                                           , ContainerId_SummTo, ContainerId_GoodsTo
                                           , AccountId_From, AccountId_To
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                AS MovementItemId         -- Сформируем позже
                         , vbMovementItemId AS ParentId
                         , vbGoodsId        AS GoodsId
                         , vbPartionId      AS PartionId
                         , 0                AS ContainerId_SummFrom   -- сформируем позже
                         , 0                AS ContainerId_GoodsFrom  -- сформируем позже
                         , 0                AS ContainerId_SummTo     -- сформируем позже
                         , 0                AS ContainerId_GoodsTo    -- сформируем позже
                         , 0                AS AccountId_From         -- Счет(справочника), сформируем позже
                         , 0                AS AccountId_To           -- Счет(справочника), сформируем позже
                         , vbAmount         AS Amount
                         , vbMovementId_order
                          ;
                 -- обнуляем кол-во что бы больше не искать
                 vbAmount:= 0;
             ELSE
                 -- получилось в zc_MI_Master больше чем надо резервировать - заполняем таблицу - элементы Резерв для Заказов клиента
                 INSERT INTO _tmpReserveRes (MovementItemId, ParentId
                                           , GoodsId
                                           , PartionId
                                           , ContainerId_SummFrom, ContainerId_GoodsFrom
                                           , ContainerId_SummTo, ContainerId_GoodsTo
                                           , AccountId_From, AccountId_To
                                           , Amount
                                           , MovementId_order
                                            )
                    SELECT 0                AS MovementItemId         -- Сформируем позже
                         , vbMovementItemId AS ParentId
                         , vbGoodsId        AS GoodsId
                         , vbPartionId      AS PartionId
                         , 0                AS ContainerId_SummFrom   -- сформируем позже
                         , 0                AS ContainerId_GoodsFrom  -- сформируем позже
                         , 0                AS ContainerId_SummTo     -- сформируем позже
                         , 0                AS ContainerId_GoodsTo    -- сформируем позже
                         , 0                AS AccountId_From         -- Счет(справочника), сформируем позже
                         , 0                AS AccountId_To           -- Счет(справочника), сформируем позже
                         , vbAmount_Reserve AS Amount
                         , vbMovementId_order
                          ;
                 -- уменьшаем Перемещение на кол-во которое нашли и продолжаем поиск
                 vbAmount:= vbAmount - vbAmount_Reserve;
             END IF;


             -- !!!если надо найти другие партии, без резерва!!!
             -- IF vbAmount > 0 THEN
             -- END IF;


         END LOOP; -- финиш цикла по курсору2. - Резервы
         CLOSE curReserveDiff; -- закрыли курсор2. - Резервы


     END LOOP; -- финиш цикла по курсору1 - элементы прихода
     CLOSE curItem; -- закрыли курсор1 - элементы прихода


     -- добавили партии, которые уже были в _tmpItem_Child
     UPDATE _tmpReserveRes SET Amount = _tmpReserveRes.Amount + _tmpItem_Child.OperCount
     FROM _tmpItem_Child
     WHERE _tmpReserveRes.ParentId         = _tmpItem_Child.ParentId
       AND _tmpReserveRes.PartionId        = _tmpItem_Child.PartionId
       AND _tmpReserveRes.MovementId_order = _tmpItem_Child.MovementId_order
       ;

     -- добавили партии, которые уже были в _tmpItem_Child
     INSERT INTO _tmpReserveRes (MovementItemId, ParentId
                               , GoodsId
                               , PartionId
                               , Amount
                               , MovementId_order
                                )
        SELECT _tmpItem_Child.MovementItemId
             , _tmpItem_Child.ParentId
             , _tmpItem_Child.GoodsId
             , _tmpItem_Child.PartionId
             , _tmpItem_Child.OperCount
             , _tmpItem_Child.MovementId_order
        FROM _tmpItem_Child
             LEFT JOIN _tmpReserveRes ON _tmpReserveRes.ParentId         = _tmpItem_Child.ParentId
                                     AND _tmpReserveRes.PartionId        = _tmpItem_Child.PartionId
                                     AND _tmpReserveRes.MovementId_order = _tmpItem_Child.MovementId_order
        WHERE _tmpReserveRes.PartionId IS NULL
       ;

     -- проверка - одинаковое кол-во zc_MI_Master + _tmpReserveRes
     IF EXISTS (SELECT 1
                FROM _tmpItem
                     FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                               ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во в элементах не может отличаться от кол-ва в партиях <%> <%> <%>.'
                     , (SELECT _tmpItem.OperCount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , (SELECT tmpReserveRes.Amount
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
                     , (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId)
                        FROM _tmpItem
                             FULL JOIN (SELECT _tmpReserveRes.ParentId, SUM (_tmpReserveRes.Amount) AS Amount
                                        FROM _tmpReserveRes GROUP BY _tmpReserveRes.ParentId
                                       ) AS tmpReserveRes ON tmpReserveRes.ParentId = _tmpItem.MovementItemId
                        WHERE COALESCE (_tmpItem.OperCount, 0) <> COALESCE (tmpReserveRes.Amount, 0)
                        ORDER BY _tmpItem.MovementItemId
                        LIMIT 1
                       )
               ;
     END IF;


     -- RAISE EXCEPTION 'test.<%> <%>', (SELECT SUM (_tmpItem.OperCount) FROM _tmpItem), (SELECT SUM (_tmpReserveRes.Amount) FROM _tmpReserveRes);


     -- сохраняем - zc_MI_Child - текущее Перемещение
     UPDATE _tmpReserveRes SET MovementItemId = lpInsertUpdate_MI_Send_Child (ioId                     := _tmpReserveRes.MovementItemId
                                                                            , inParentId               := _tmpReserveRes.ParentId
                                                                            , inMovementId             := inMovementId
                                                                            , inMovementId_OrderClient := _tmpReserveRes.MovementId_order
                                                                            , inObjectId               := _tmpReserveRes.GoodsId
                                                                            , inPartionId              := _tmpReserveRes.PartionId
                                                                              -- кол-во резерв
                                                                            , inAmount                 := _tmpReserveRes.Amount
                                                                            , inUserId                 := inUserId
                                                                             )
     -- !!!ВСЕ элементы
     --WHERE _tmpReserveRes.MovementItemId = 0
    ;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpReserveRes SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_From
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                          , inPartionId              := _tmpReserveRes.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                           )
                             , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := vbUnitId_To
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                          , inPartionId              := _tmpReserveRes.PartionId
                                                                                          , inIsReserve              := FALSE
                                                                                          , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                           )
     FROM _tmpItem
     WHERE _tmpReserveRes.ParentId = _tmpItem.MovementItemId
    ;

     -- 2.1. определяется Счет(справочника) для проводок по суммовому учету
     UPDATE _tmpReserveRes SET AccountId_From = _tmpItem_byAccount.AccountId_From
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
     WHERE _tmpReserveRes.ParentId = _tmpItem.MovementItemId
    ;


     -- 2.2. определяется ContainerId_Summ для проводок по суммовому учету
     UPDATE _tmpReserveRes SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_From
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpReserveRes.AccountId_From
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpReserveRes.ContainerId_GoodsFrom
                                                                                        , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                        , inPartionId              := _tmpReserveRes.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
                             , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                        , inUnitId                 := vbUnitId_To
                                                                                        , inMemberId               := NULL
                                                                                        , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                        , inBusinessId             := vbBusinessId
                                                                                        , inAccountId              := _tmpReserveRes.AccountId_To
                                                                                        , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                        , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                        , inContainerId_Goods      := _tmpReserveRes.ContainerId_GoodsTo
                                                                                        , inGoodsId                := _tmpReserveRes.GoodsId
                                                                                        , inPartionId              := _tmpReserveRes.PartionId
                                                                                        , inIsReserve              := FALSE
                                                                                         )
     FROM _tmpItem
     WHERE _tmpReserveRes.ParentId = _tmpItem.MovementItemId
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
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_From           AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpReserveRes.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpReserveRes.AccountId_To             AS AccountId_Analyzer     -- Счет - корреспондент - по ПРИХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpReserveRes.ContainerId_SummTo       AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по ПРИХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому
            , -1 * _tmpReserveRes.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpReserveRes
      UNION ALL
       -- проводки - ПРИХОД
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_To             AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpReserveRes.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Место учета
            , _tmpReserveRes.AccountId_From           AS AccountId_Analyzer     -- Счет - корреспондент - по РАСХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpReserveRes.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по РАСХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого
            , 1 * _tmpReserveRes.Amount               AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpReserveRes;


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
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_From           AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpReserveRes.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- Место учета
            , _tmpReserveRes.AccountId_To             AS AccountId_Analyzer     -- Счет - корреспондент - по ПРИХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpReserveRes.ContainerId_SummTo       AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по ПРИХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому
            , -1 * CASE WHEN _tmpReserveRes.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpReserveRes.Amount * (Object_PartionGoods.EKPrice + Object_PartionGoods.CostPrice)
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpReserveRes
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpReserveRes.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpReserveRes.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpReserveRes.ContainerId_SummFrom
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpReserveRes.MovementItemId
            , _tmpReserveRes.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpReserveRes.AccountId_To             AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpReserveRes.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpReserveRes.PartionId                AS PartionId              -- Партия
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- Место учета
            , _tmpReserveRes.AccountId_From           AS AccountId_Analyzer     -- Счет - корреспондент - по РАСХОДУ
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpReserveRes.ContainerId_SummFrom     AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - по РАСХОДУ
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого
            , 1 * CASE WHEN _tmpReserveRes.Amount = Container_Count.Amount
                            THEN Container_Summ.Amount
                       ELSE _tmpReserveRes.Amount * (Object_PartionGoods.EKPrice + Object_PartionGoods.CostPrice)
                  END                                 AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpReserveRes
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpReserveRes.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpReserveRes.ContainerId_GoodsFrom
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpReserveRes.ContainerId_SummFrom
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
-- SELECT * FROM lpComplete_Movement_Send (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 589, inSession:= '5');
