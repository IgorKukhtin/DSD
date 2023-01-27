DROP FUNCTION IF EXISTS lpComplete_Movement_ProductionUnion (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ProductionUnion(
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

  DECLARE vbMovementItemId   Integer;
  DECLARE vbParentId         Integer;
  DECLARE vbMovementId_order Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbPartionId        Integer;
  DECLARE vbPartNumber       TVarChar;
  DECLARE vbAmount           TFloat;
  DECLARE vbAmount_partion   TFloat;

  DECLARE curItem            RefCursor;
  DECLARE curPartion         RefCursor;
BEGIN

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
             AND Movement.DescId   = zc_Movement_ProductionUnion()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;

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



     -- заполняем таблицу - элементы документа
     INSERT INTO _tmpItem_pr (MovementItemId
                            , GoodsId, PartionId
                            , ContainerId_Summ, ContainerId_Goods
                            , Amount
                            , PartNumber
                            , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                            , MovementId_order
                             )
        -- результат
        SELECT MovementItem.Id                  AS MovementItemId
             , MovementItem.ObjectId            AS GoodsId
               -- !!!Создали партию!!!
             , MovementItem.Id                  AS PartionId
               -- Сформируем позже
             , 0 AS ContainerId_Summ, 0 AS ContainerId_Goods
               --
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

        FROM MovementItem
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

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
       ;

     -- заполняем таблицу - элементы документа
     INSERT INTO _tmpItem_Child_mi (MovementItemId, ParentId
                                  , GoodsId
                                  , Amount
                                  , PartNumber
                                  , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                                  , MovementId_order
                                   )
        -- результат
        SELECT MovementItem.Id                  AS MovementItemId
             , MovementItem.ParentId            AS ParentId
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
            , _tmpItem_pr.MovementId_order

        FROM MovementItem
             INNER JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = MovementItem.ParentId

             LEFT JOIN MovementItemString AS MIString_PartNumber
                                          ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                         AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
             -- !!!ВРЕМЕННО!!! Комплектующие
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
       ;


     -- 2.заполняем таблицу - элементы по партиям

     -- курсор1 - элементы документа
     OPEN curItem FOR SELECT _tmpItem.MovementItemId, _tmpItem.ParentId
                           , _tmpItem.GoodsId, _tmpItem.PartNumber, _tmpItem.MovementId_order
                           , _tmpItem.Amount
                      FROM _tmpItem_Child_mi AS _tmpItem
                     ;
     -- начало цикла по курсору1 - элементы документа
     LOOP
     -- данные по партиям
     FETCH curItem INTO vbMovementItemId, vbParentId, vbGoodsId, vbPartNumber, vbMovementId_order, vbAmount;
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
          AND Container.WhereObjectId = vbUnitId_From
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
                    SELECT vbMovementItemId     AS MovementItemId
                         , vbParentId           AS ParentId
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
                    SELECT vbMovementItemId     AS MovementItemId
                         , vbParentId           AS ParentId
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


     -- добавили партии - !!!РАСХОД!!!, которые надо создать, т.к. остатков по ним не нашли
     INSERT INTO _tmpItem_Child (MovementItemId, ParentId
                               , GoodsId, PartionId
                               , Amount
                               , MovementId_order
                                )
        SELECT _tmpItem.MovementItemId AS MovementItemId -- Сформируем позже
             , _tmpItem.ParentId       AS ParentId
             , _tmpItem.GoodsId
               -- !!!ПАРТИЯ создается ?расходным документом?
             , _tmpItem_partion.MovementItemId AS PartionId
               -- сколько в этой партии осталось создать
             , _tmpItem.Amount - COALESCE (tmp.Amount, 0)
               --
             , _tmpItem.MovementId_order
        FROM _tmpItem_Child_mi AS _tmpItem
             -- сколько партий подобрали, их надо вычесть
             LEFT JOIN (SELECT _tmpItem_Child.MovementItemId, SUM (_tmpItem_Child.Amount) AS Amount
                        FROM _tmpItem_Child
                        GROUP BY _tmpItem_Child.MovementItemId
                       ) AS tmp
                         ON tmp.MovementItemId = _tmpItem.MovementItemId
             -- партия !!!только!!! ОДНА
             LEFT JOIN (SELECT MAX (_tmpItem_Child_mi.MovementItemId) AS MovementItemId, _tmpItem_Child_mi.GoodsId, _tmpItem_Child_mi.MovementId_order
                        FROM _tmpItem_Child_mi
                        GROUP BY _tmpItem_Child_mi.GoodsId, _tmpItem_Child_mi.MovementId_order
                       ) AS _tmpItem_partion
                         ON _tmpItem_partion.GoodsId          = _tmpItem.GoodsId
                       -- здесь еще условие Id_order
                       AND _tmpItem_partion.MovementId_order = _tmpItem.MovementId_order
        WHERE _tmpItem.Amount - COALESCE (tmp.Amount, 0) > 0
       ;


     -- проверка - если партия создается, тогда она ОДНА для GoodsId + MovementId_order
     IF EXISTS (SELECT _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                FROM _tmpItem_Child
                WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                GROUP BY _tmpItem_Child.GoodsId, _tmpItem_Child.MovementId_order
                HAVING COUNT(*) > 1
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Партия создается, но она НЕ ОДНА для GoodsId + MovementId_order.';
     END IF;


     -- RAISE EXCEPTION 'test.<%> <%>', (SELECT SUM (_tmpItem_Child_mi.Amount) FROM _tmpItem_Child_mi), (SELECT SUM (_tmpItem_Child.Amount) FROM _tmpItem_Child);

     -- проверка - одинаковое кол-во _tmpItem_Child_mi + _tmpItem_Child
     IF EXISTS (SELECT 1
                FROM _tmpItem_Child_mi AS _tmpItem
                     FULL JOIN (SELECT _tmpItem_Child.MovementItemId, SUM (_tmpItem_Child.Amount) AS Amount FROM _tmpItem_Child GROUP BY _tmpItem_Child.MovementItemId
                               ) AS tmpRes ON tmpRes.MovementItemId = _tmpItem.MovementItemId
                WHERE COALESCE (_tmpItem.Amount, 0) <> COALESCE (tmpRes.Amount, 0)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Кол-во в элементах не может отличаться от кол-ва в партиях.';
     END IF;


     -- Создали партии - !!!ПРИХОД!!!
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := _tmpItem_pr.PartionId
                                               , inMovementId        := inMovementId              -- Ключ Документа
                                               , inFromId            := vbUnitId_To               -- Поставщик или Подразделение (место сборки)
                                               , inUnitId            := vbUnitId_To               -- Подразделение(прихода)
                                               , inOperDate          := vbOperDate                -- Дата прихода
                                               , inObjectId          := _tmpItem_pr.GoodsId       -- Комплектующие или Лодка
                                               , inAmount            := _tmpItem_pr.Amount        -- Кол-во приход
                                                 --
                                               , inEKPrice           := 0                         -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка = inEKPrice_discount + inCostPrice
                                               , inEKPrice_orig      := 0                         -- Цена вх. без НДС, с учетом ТОЛЬКО скидки по элементу
                                               , inEKPrice_discount  := 0                         -- Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
                                               , inCostPrice         := 0                         -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
                                               , inCountForPrice     := 1                         -- Цена за количество
                                                 --
                                               , inEmpfPrice         := 0                         -- Цена рекоменд. без НДС
                                               , inOperPriceList     := 0                         -- Цена продажи
                                               , inOperPriceList_old := 0                         -- Цена продажи, ДО изменения строки
                                                 -- Тип НДС (!информативно!)
                                               , inTaxKindId         := zc_TaxKind_Basis()
                                                 -- Значение НДС (!информативно!)
                                               , inTaxKindValue      := (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_TaxKind_Basis()  AND OFl.DescId = zc_ObjectFloat_TaxKind_Value())
                                                 --
                                               , inUserId            := inUserId
                                                )
     FROM _tmpItem_pr
    ;


     -- определили - !!!нужна ли партия MovementId_order!!!
     UPDATE _tmpItem_Child SET isId_order = tmpItem_Child.isId_order

     FROM (WITH tmpItem AS (SELECT DISTINCT _tmpItem_Child.GoodsId FROM _tmpItem_Child)
              , tmpMI AS (SELECT DISTINCT _tmpItem_Child.GoodsId
                          FROM _tmpItem_Child
                               INNER JOIN MovementItem ON MovementItem.ObjectId = _tmpItem_Child.GoodsId
                                                      AND MovementItem.DescId   = zc_MI_Master()
                                                      AND MovementItem.isErased = FALSE
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 YEAR' AND vbOperDate + INTERVAL '1 YEAR'
                                                  AND Movement.DescId   IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
                         UNION ALL
                          -- виртуальные" узлы
                          SELECT DISTINCT
                                 OL.ChildObjectId
                          FROM ObjectLink AS OL
                               -- Не удален
                               INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = OL.ObjectId
                                                                            AND Object_ReceiptGoodsChild.isErased = FALSE

                               INNER JOIN ObjectLink AS OL_ReceiptGoodsChild_ReceiptGoods
                                                     ON OL_ReceiptGoodsChild_ReceiptGoods.ObjectId = OL.ObjectId
                                                    AND OL_ReceiptGoodsChild_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                               -- Не удален
                               INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = OL_ReceiptGoodsChild_ReceiptGoods.ChildObjectId
                                                                       AND Object_ReceiptGoods.isErased = FALSE
                          WHERE OL.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                            AND OL.ChildObjectId > 0
                         )
           --
           SELECT tmpItem.GoodsId
                , CASE WHEN tmpMI.GoodsId > 0 THEN TRUE ELSE FALSE END AS isId_order
           FROM tmpItem
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpItem.GoodsId
          ) AS tmpItem_Child
     WHERE _tmpItem_Child.GoodsId = tmpItem_Child.GoodsId
    ;

     -- если партия не нужна - !!!подставляем абсолютно любую - без партии Заказ Клиента!!!
     UPDATE _tmpItem_Child SET PartionId = tmpItem_Child.PartionId_new
     FROM (WITH tmpPartion AS (SELECT _tmpItem_Child.GoodsId             AS GoodsId
                                    , _tmpItem_Child.PartionId           AS PartionId_old
                                      -- нашли Партию
                                    , Object_PartionGoods.MovementItemId AS PartionId_new
                                      -- № п/п
                                    , ROW_NUMBER() OVER (PARTITION BY _tmpItem_Child.GoodsId
                                                         ORDER BY CASE WHEN MovementItem.Amount > 0 THEN 0 ELSE 1 END
                                                                , CASE WHEN Movement.Id > 0 THEN 0 ELSE 1 END
                                                                , COALESCE (Movement.OperDate, zc_DateStart()) DESC
                                                                , Object_PartionGoods.MovementItemId ASC
                                                        ) AS Ord
                               FROM _tmpItem_Child
                                    -- если это "текущая" партия - она может стать приоритетной
                                    -- LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId

                                    -- если это "любая" партия
                                    INNER JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = _tmpItem_Child.GoodsId
                                    -- без партии Заказ Клиента
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = Object_PartionGoods.MovementItemId
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                               AND MIFloat_MovementId.ValueData      > 0
                                    -- если это партия Приход
                                    LEFT JOIN MovementItem ON MovementItem.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem.isErased = FALSE
                                                          AND MovementItem.Amount   > 0
                                    -- если это "любая" партия не равная 0
                                    LEFT JOIN MovementItem AS MovementItem_two
                                                           ON MovementItem_two.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem_two.isErased = FALSE
                                                          AND MovementItem_two.Amount   <> 0
                                    -- Документ - Проведен
                                    LEFT JOIN Movement ON Movement.Id       = COALESCE (MovementItem.MovementId, MovementItem_two.MovementId)
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                               -- условие - когда создаются партии
                               WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                                 AND _tmpItem_Child.isId_order     = FALSE
                                 -- без партии Заказ Клиента
                                 AND MIFloat_MovementId.MovementItemId IS NULL
                              )
           -- Результат
           SELECT tmpPartion.PartionId_old, tmpPartion.PartionId_new
           FROM tmpPartion
           -- взяли только первую
           WHERE tmpPartion.Ord = 1
          ) AS tmpItem_Child

     WHERE _tmpItem_Child.PartionId = tmpItem_Child.PartionId_old
    ;


     -- если партия !!!нужна!!!подставляем любую - с учетом Заказ Клиента!!!
     UPDATE _tmpItem_Child SET PartionId = tmpItem_Child.PartionId_new
     FROM (WITH tmpPartion AS (SELECT _tmpItem_Child.MovementId_order    AS MovementId_order
                                    , _tmpItem_Child.PartionId           AS PartionId_old
                                      -- нашли Партию
                                    , Object_PartionGoods.MovementItemId AS PartionId_new
                                      -- № п/п
                                    , ROW_NUMBER() OVER (PARTITION BY _tmpItem_Child.GoodsId
                                                         ORDER BY CASE WHEN MovementItem.Amount > 0 THEN 0 ELSE 1 END
                                                                , CASE WHEN Movement.Id > 0 THEN 0 ELSE 1 END
                                                                , COALESCE (Movement.OperDate, zc_DateStart()) DESC
                                                                , Object_PartionGoods.MovementItemId ASC
                                                        ) AS Ord
                               FROM _tmpItem_Child
                                    -- если это "любая" партия
                                    INNER JOIN Object_PartionGoods ON Object_PartionGoods.ObjectId = _tmpItem_Child.GoodsId
                                    -- партия Заказ Клиента
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = Object_PartionGoods.MovementItemId
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                    -- если это партия Приход
                                    LEFT JOIN MovementItem ON MovementItem.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem.isErased = FALSE
                                                          AND MovementItem.Amount   > 0
                                    -- если это "любая" партия не равная 0
                                    LEFT JOIN MovementItem AS MovementItem_two
                                                           ON MovementItem_two.Id       = Object_PartionGoods.MovementItemId
                                                          AND MovementItem_two.isErased = FALSE
                                                          AND MovementItem_two.Amount   <> 0
                                    -- Документ - Проведен
                                    LEFT JOIN Movement ON Movement.Id       = COALESCE (MovementItem.MovementId, MovementItem_two.MovementId)
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                               -- условие - когда создаются партии
                               WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
                                 AND _tmpItem_Child.isId_order     = TRUE
                                 -- партия Заказ Клиента
                                 AND COALESCE (MIFloat_MovementId.ValueData, 0) = COALESCE (_tmpItem_Child.MovementId_order, 0)
                              )
           -- Результат
           SELECT tmpPartion.MovementId_order, tmpPartion.PartionId_old, tmpPartion.PartionId_new
           FROM tmpPartion
           -- взяли только первую
           WHERE tmpPartion.Ord = 1
          ) AS tmpItem_Child

     WHERE _tmpItem_Child.PartionId        = tmpItem_Child.PartionId_old
       AND _tmpItem_Child.MovementId_order = tmpItem_Child.MovementId_order
    ;

     -- Создали партии - !!!РАСХОД!!!
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := tmpItem.PartionId
                                               , inMovementId        := inMovementId              -- Ключ Документа
                                               , inFromId            := vbUnitId_From             -- Поставщик или Подразделение (место сборки)
                                               , inUnitId            := vbUnitId_From             -- Подразделение(прихода)
                                               , inOperDate          := vbOperDate                -- Дата прихода
                                               , inObjectId          := tmpItem.GoodsId           -- Комплектующие или Лодка
                                               , inAmount            := 0                         -- Кол-во приход
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
                            -- условие - когда надо создать партии
                            WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
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
           SELECT DISTINCT
                  tmpItem.PartionId
                , tmpItem.GoodsId
                , tmpItem.EmpfPrice
                , COALESCE (tmpItemPrice.EKPrice, tmpItem.EKPrice) AS EKPrice_find
           FROM tmpItem
                LEFT JOIN tmpItemPrice ON tmpItemPrice.GoodsId = tmpItem.GoodsId
                                      AND tmpItemPrice.Ord     = 1
          ) AS tmpItem
    ;

     -- Создали св-во у партии - !!!РАСХОД!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), _tmpItem_Child.MovementItemId, CASE WHEN _tmpItem_Child.isId_order = TRUE THEN _tmpItem_Child.MovementId_order ELSE 0 END)
     FROM _tmpItem_Child
     WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child.PartionId
    ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1. определяется ContainerId_Goods для количественного учета - ПРИХОД
     UPDATE _tmpItem_pr SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                   , inUnitId                 := vbUnitId_To
                                                                                   , inMemberId               := NULL
                                                                                   , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                   , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                   , inPartionId              := _tmpItem_pr.PartionId
                                                                                   , inIsReserve              := FALSE
                                                                                   , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                    );
     -- 1.2. определяется ContainerId_Goods для количественного учета - РАСХОД
     UPDATE _tmpItem_Child SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                      , inUnitId                 := vbUnitId_From
                                                                                      , inMemberId               := NULL
                                                                                      , inInfoMoneyDestinationId := _tmpItem_Child_mi.InfoMoneyDestinationId
                                                                                      , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                      , inPartionId              := _tmpItem_Child.PartionId
                                                                                      , inIsReserve              := FALSE
                                                                                      , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                       )
     FROM _tmpItem_Child_mi
     WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child_mi.MovementItemId
    ;

     -- 2.1. определяется Счет(справочника) для проводок по суммовому учету - ПРИХОД
     UPDATE _tmpItem_pr SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_pr.InfoMoneyDestinationId FROM _tmpItem_pr) AS _tmpItem_group
          ) AS _tmpItem_byAccount
    ;
     -- 2.2. определяется Счет(справочника) для проводок по суммовому учету - РАСХОД
     UPDATE _tmpItem_Child SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- Запасы
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem_Child_mi.InfoMoneyDestinationId FROM _tmpItem_Child_mi) AS _tmpItem_group
          ) AS _tmpItem_byAccount
          JOIN _tmpItem_Child_mi ON _tmpItem_Child_mi.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
     WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child_mi.MovementItemId
    ;


     -- 3.1. определяется ContainerId_Summ для проводок по суммовому учету - ПРИХОД
     UPDATE _tmpItem_pr SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                 , inUnitId                 := vbUnitId_From
                                                                                 , inMemberId               := NULL
                                                                                 , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                 , inBusinessId             := vbBusinessId
                                                                                 , inAccountId              := _tmpItem_pr.AccountId
                                                                                 , inInfoMoneyDestinationId := _tmpItem_pr.InfoMoneyDestinationId
                                                                                 , inInfoMoneyId            := _tmpItem_pr.InfoMoneyId
                                                                                 , inContainerId_Goods      := _tmpItem_pr.ContainerId_Goods
                                                                                 , inGoodsId                := _tmpItem_pr.GoodsId
                                                                                 , inPartionId              := _tmpItem_pr.PartionId
                                                                                 , inIsReserve              := FALSE
                                                                                  );
     -- 3.2. определяется ContainerId_Summ для проводок по суммовому учету - РАСХОД
     UPDATE _tmpItem_Child SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId_From
                                                                                    , inMemberId               := NULL
                                                                                    , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                    , inBusinessId             := vbBusinessId
                                                                                    , inAccountId              := _tmpItem_Child.AccountId
                                                                                    , inInfoMoneyDestinationId := _tmpItem_Child_mi.InfoMoneyDestinationId
                                                                                    , inInfoMoneyId            := _tmpItem_Child_mi.InfoMoneyId
                                                                                    , inContainerId_Goods      := _tmpItem_Child.ContainerId_Goods
                                                                                    , inGoodsId                := _tmpItem_Child.GoodsId
                                                                                    , inPartionId              := _tmpItem_Child.PartionId
                                                                                    , inIsReserve              := FALSE
                                                                                     )
     FROM _tmpItem_Child_mi
     WHERE _tmpItem_Child.MovementItemId = _tmpItem_Child_mi.MovementItemId
    ;

     -- 4.1. формируются Проводки - остаток количество
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
            , _tmpItem_Child.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_Child.AccountId                AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_Child.GoodsId                  AS ObjectId_Analyzer      -- Товар
            , _tmpItem_Child.PartionId                AS PartionId              -- Партия
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_pr.AccountId                   AS AccountId_Analyzer     -- Счет - корреспондент - ПРИХОД
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_pr.ContainerId_Goods           AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - ПРИХОД
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому - ПРИХОД
            , -1 * _tmpItem_Child.Amount              AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child.ParentId

      UNION ALL
       -- проводки - ПРИХОД
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_pr.MovementItemId
            , _tmpItem_pr.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem_pr.AccountId                   AS AccountId              -- счет из суммового учета
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_pr.GoodsId                     AS ObjectId_Analyzer      -- Товар
            , _tmpItem_pr.PartionId                   AS PartionId              -- Партия
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- Место учета
            , tmpItem_Child.AccountId                 AS AccountId_Analyzer     -- Счет - корреспондент - РАСХОД - пока оставил, возможно он один
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , 0                                       AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - РАСХОД - убрали, т.к. их очень много
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого - РАСХОД
            , 1 * _tmpItem_pr.Amount                  AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem_pr
            JOIN (SELECT _tmpItem_Child.ParentId, MAX (_tmpItem_Child.AccountId) AS AccountId
                  FROM _tmpItem_Child
                  GROUP BY _tmpItem_Child.ParentId
                 ) AS tmpItem_Child ON tmpItem_Child.ParentId = _tmpItem_pr.MovementItemId
      ;

     -- 4.2. формируются Проводки - остаток сумма
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
            , vbUnitId_From                           AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_pr.AccountId                   AS AccountId_Analyzer     -- Счет - корреспондент - ПРИХОД
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_pr.ContainerId_Summ            AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - ПРИХОД
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение Кому - ПРИХОД
            , -1 * CASE WHEN _tmpItem_Child.Amount = Container_Count.Amount
                             THEN Container_Summ.Amount
                        ELSE _tmpItem_Child.Amount * Object_PartionGoods.EKPrice
                   END                                AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Child
            JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem_Child.PartionId
            JOIN Container AS Container_Count ON Container_Count.Id = _tmpItem_Child.ContainerId_Goods
            JOIN Container AS Container_Summ  ON Container_Summ.Id  = _tmpItem_Child.ContainerId_Summ
            JOIN _tmpItem_pr ON _tmpItem_pr.MovementItemId = _tmpItem_Child.ParentId

      UNION ALL
       -- проводки - ПРИХОД
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem_pr.MovementItemId
            , _tmpItem_pr.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem_pr.AccountId                   AS AccountId              -- счет
            , 0                                       AS AnalyzerId             -- нет - Типы аналитик (проводки)
            , _tmpItem_pr.GoodsId                     AS ObjectId_Analyzer      -- Товар
            , _tmpItem_pr.PartionId                   AS PartionId              -- Партия
            , vbUnitId_To                             AS WhereObjectId_Analyzer -- Место учета
            , _tmpItem_Child.AccountId                AS AccountId_Analyzer     -- Счет - корреспондент - РАСХОД
            , 0                                       AS ContainerId_Analyzer   -- нет - Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
            , _tmpItem_Child.ContainerId_Summ         AS ContainerExtId_Analyzer-- Контейнер - Корреспондент - РАСХОД
            , 0                                       AS ObjectIntId_Analyzer   -- Аналитический справочник
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- Аналитический справочник - Подразделение От Кого - РАСХОД
            , -1 * _tmpMIContainer_insert.Amount      AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpMIContainer_insert
            JOIN _tmpItem_Child ON _tmpItem_Child.MovementItemId = _tmpMIContainer_insert.MovementItemId
            JOIN _tmpItem_pr    ON _tmpItem_pr.MovementItemId    = _tmpItem_Child.ParentId
       WHERE _tmpMIContainer_insert.DescId = zc_MIContainer_Summ()
      ;


     -- 5.0. получили цену партии - !!!ПРИХОД!!!
     UPDATE Object_PartionGoods SET EKPrice           = tmpMIContainer.EKPrice / Object_PartionGoods.Amount    -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка = inEKPrice_discount + inCostPrice
                                  , EKPrice_orig      = tmpMIContainer.EKPrice / Object_PartionGoods.Amount    -- Цена вх. без НДС, с учетом ТОЛЬКО скидки по элементу
                                  , EKPrice_discount  = tmpMIContainer.EKPrice / Object_PartionGoods.Amount    -- Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
                                  , CostPrice         = 0
     FROM (SELECT _tmpMIContainer_insert.MovementItemId
                , SUM (_tmpMIContainer_insert.Amount) AS EKPrice
           FROM _tmpMIContainer_insert
           WHERE _tmpMIContainer_insert.DescId   = zc_MIContainer_Summ()
             AND _tmpMIContainer_insert.isActive = TRUE
           GROUP BY _tmpMIContainer_insert.MovementItemId
          ) AS tmpMIContainer
     WHERE tmpMIContainer.MovementItemId = Object_PartionGoods.MovementItemId
    ;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ProductionUnion()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_ProductionUnion (inMovementId:= 676, inSession:= zfCalc_UserAdmin());
