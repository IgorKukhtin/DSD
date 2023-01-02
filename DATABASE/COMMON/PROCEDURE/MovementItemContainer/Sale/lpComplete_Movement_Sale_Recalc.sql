-- Function: lpComplete_Movement_Sale_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_Recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_Recalc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUnitId            Integer  , --
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Peresort Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbIsNotRealGoods Boolean;
BEGIN
     -- нашли дату
     vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);


    vbIsNotRealGoods:= EXISTS (SELECT 1
                               FROM MovementLinkObject AS MLO
                                   INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ObjectId = MLO.ObjectId
                                                        AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                   INNER JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                                            ON ObjectBoolean_isNotRealGoods.ObjectId  = ObjectLink_Partner_Juridical.ChildObjectId 
                                                           AND ObjectBoolean_isNotRealGoods.DescId    = zc_ObjectBoolean_Juridical_isNotRealGoods()
                                                           AND ObjectBoolean_isNotRealGoods.ValueData = TRUE
                               WHERE MLO.MovementId = inMovementId
                                 AND MLO.DescId     = zc_MovementLinkObject_To()
                              );

     -- Временно захардкодил - !!!только для этого склада!!!
     IF inUnitId = 8459 -- Склад Реализации
     OR inUnitId IN (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId <> zc_Branch_Basis() AND OL.ChildObjectId > 0)
     OR (inUnitId IN (8444 -- Склад ОХЛАЖДЕНКА
                    , 8445 -- Склад МИНУСОВКА
                    , 133049 -- Склад реализации мясо
                     )
         AND '01.11.2016' <= vbOperDate -- Дата когда стартанула схема для этих 3-х складов
        )
        -- AND inUserId = 5
     THEN

     -- Поиск "Пересортица" или "Обычный"
     vbMovementId_Peresort:= (SELECT MLM.MovementId
                              FROM MovementLinkMovement AS MLM
                                   JOIN Movement ON Movement.Id       = MLM.MovementId
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                              WHERE MLM.MovementChildId = inMovementId
                                AND MLM.DescId          = zc_MovementLinkMovement_Production()
                             );



     -- таблица остатки для  inUnitId = 8459
     CREATE TEMP TABLE _tmpRemains (GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpRemains (GoodsId, GoodsKindId, Amount)
        SELECT Container.ObjectId     AS GoodsId
             , CLO_GoodsKind.ObjectId AS GoodsKindId
             , SUM (Container.Amount) AS Amount
        FROM Container
             INNER JOIN ContainerLinkObject AS CLO_Unit
                                            ON CLO_Unit.ContainerId = Container.Id
                                           AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                           AND CLO_Unit.ObjectId    = inUnitId
             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                           ON CLO_GoodsKind.ContainerId = Container.Id
                                          AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
        WHERE Container.DescId = zc_Container_Count()
          AND Container.Amount > 0
          --  !!!Розподільчий комплекс!!!
          AND inUnitId = 8459
          -- !!!
          AND COALESCE (vbMovementId_Peresort, 0) = 0
        GROUP BY Container.ObjectId, CLO_GoodsKind.ObjectId
       ;

IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>  <%>'
    , (select COUNT(*) from _tmpRemains)
    , vbMovementId_Peresort
     ;
END IF;


     -- таблица - элементы
     CREATE TEMP TABLE _tmpItemPeresort_new (MovementItemId_to Integer, MovementItemId_from Integer
                                           , GoodsId_to Integer, GoodsKindId_to Integer
                                           , GoodsId_from Integer, GoodsKindId_from Integer
                                           , ReceipId_to Integer, ReceipId_gp_to Integer
                                           , Amount_to TFloat, Amount_Remains TFloat) ON COMMIT DROP;
     -- элементы
     INSERT INTO _tmpItemPeresort_new (MovementItemId_to, MovementItemId_from, GoodsId_to, GoodsKindId_to, GoodsId_from, GoodsKindId_from, ReceipId_to, ReceipId_gp_to, Amount_to, Amount_Remains)
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
             , _tmpItem.GoodsId                                       AS GoodsId_to
             , _tmpItem.GoodsKindId                                   AS GoodsKindId_to
             , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsId_from
             , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId, 0) AS GoodsKindId_from
             , COALESCE (ObjectLink_GoodsByGoodsKind_Receipt_gp.ChildObjectId, ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId, 0) AS ReceipId_to
             , COALESCE (ObjectLink_GoodsByGoodsKind_Receipt_gp.ChildObjectId, 0)   AS ReceipId_gp_to
             , CASE WHEN SUM (_tmpItem.OperCount) - COALESCE (_tmpRemains.Amount, 0) > 0
                         THEN SUM (_tmpItem.OperCount) - COALESCE (_tmpRemains.Amount, 0)
                    ELSE 0
               END AS Amount_to
               -- для сохранения этого параметра
             , COALESCE (_tmpRemains.Amount,0) AS Amount_Remains
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                   ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = _tmpItem.GoodsId
                                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                  AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = _tmpItem.GoodsKindId
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                   ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId > 0
             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                  ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                 -- AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId > 0

             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsReal
                                  ON ObjectLink_GoodsByGoodsKind_GoodsReal.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_GoodsReal.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsReal()
                                 AND vbIsNotRealGoods = FALSE
                                 AND vbOperDate >= '23.12.2022'
             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindReal
                                  ON ObjectLink_GoodsByGoodsKind_GoodsKindReal.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_GoodsKindReal.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal()
                                 AND vbIsNotRealGoods = FALSE
                                 AND vbOperDate >= '23.12.2022'

             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Receipt
                                  ON ObjectLink_GoodsByGoodsKind_Receipt.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_Receipt.DescId   = zc_ObjectLink_GoodsByGoodsKind_Receipt()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Receipt_gp
                                  ON ObjectLink_GoodsByGoodsKind_Receipt_gp.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                 AND ObjectLink_GoodsByGoodsKind_Receipt_gp.DescId   = zc_ObjectLink_GoodsByGoodsKind_ReceiptGP()

             LEFT JOIN _tmpRemains ON _tmpRemains.GoodsId     = _tmpItem.GoodsId
                                  AND _tmpRemains.GoodsKindId = _tmpItem.GoodsKindId

        WHERE (_tmpItem.GoodsId       <> ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
            OR (_tmpItem.GoodsKindId  <> ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId
               AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId > 0
              ))
          AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsReal.ChildObjectId, 0) = 0
          AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindReal.ChildObjectId, 0) = 0
        GROUP BY _tmpItem.GoodsId
               , _tmpItem.GoodsKindId
               , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
               , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId
               , ObjectLink_GoodsByGoodsKind_Receipt.ChildObjectId
               , ObjectLink_GoodsByGoodsKind_Receipt_gp.ChildObjectId
               , COALESCE (_tmpRemains.Amount, 0)
      --HAVING SUM (_tmpItem.OperCount) - COALESCE (_tmpRemains.Amount, 0) > 0
                ;

     -- !!! для филиалов - только одна схема, только для zc_ObjectLink_GoodsByGoodsKind_ReceiptGP !!!
     IF (NOT EXISTS (SELECT 1 FROM _tmpItemPeresort_new WHERE _tmpItemPeresort_new.ReceipId_gp_to > 0)
      AND inUnitId IN (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId <> zc_Branch_Basis() AND OL.ChildObjectId > 0)
        )
       -- !!!Розподільчий комплекс!!!
       --OR (vbMovementId_Peresort > 0 AND inUnitId = 8459)
       -- !!!
     --OR inUserId = zc_Enum_Process_Auto_PrimeCost()
     THEN
         -- !!! ВЫХОД !!!
         RETURN;
     END IF;


     -- элементы - добавили еще те что по рецептуре
     INSERT INTO _tmpItemPeresort_new (MovementItemId_to, MovementItemId_from, GoodsId_to, GoodsKindId_to, GoodsId_from, GoodsKindId_from, ReceipId_to, ReceipId_gp_to, Amount_to)
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
             , _tmpItemPeresort_new.GoodsId_to                        AS GoodsId_to
             , _tmpItemPeresort_new.GoodsKindId_to                    AS GoodsKindId_to
             , ObjectLink_ReceiptChild_Goods.ChildObjectId            AS GoodsId_from
             , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_from
             , -- т.к. надо будет отличать кол-во для ГП от других составляющих
               -1 * _tmpItemPeresort_new.ReceipId_to                  AS ReceipId_to
             , 0                                                      AS ReceipId_gp_to
             , _tmpItemPeresort_new.Amount_to * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_to
        FROM _tmpItemPeresort_new
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = _tmpItemPeresort_new.ReceipId_to
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpItemPeresort_new.ReceipId_to
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_30000()             -- Доходы
                                                              AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
        WHERE _tmpItemPeresort_new.ReceipId_to <> 0

       UNION ALL
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
             , _tmpItemPeresort_new.GoodsId_to                        AS GoodsId_to
             , _tmpItemPeresort_new.GoodsKindId_to                    AS GoodsKindId_to
             , ObjectLink_ReceiptChild_Goods.ChildObjectId            AS GoodsId_from
             , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_from
               -- т.к. надо будет отличать кол-во для ГП от других составляющих
             , -1 * _tmpItemPeresort_new.ReceipId_gp_to               AS ReceipId_to
             , -1 * _tmpItemPeresort_new.ReceipId_gp_to               AS ReceipId_gp_to
               --
             , _tmpItemPeresort_new.Amount_to * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_to
        FROM _tmpItemPeresort_new
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = _tmpItemPeresort_new.ReceipId_gp_to
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpItemPeresort_new.ReceipId_gp_to
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- Доходы
                                                                OR Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                  )
        WHERE _tmpItemPeresort_new.ReceipId_gp_to <> 0
       ;


     IF EXISTS (SELECT 1 FROM _tmpItemPeresort_new) AND '01.10.2016' <= vbOperDate -- Дата когда стартанула схема вообще
     THEN
         -- нашли MovementItemId - Master
         UPDATE _tmpItemPeresort_new SET MovementItemId_to = tmpMI.MovementItemId_to
         FROM (SELECT MovementItem.Id                                     AS MovementItemId_to
                    , MovementItem.ObjectId                               AS GoodsId_to
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId_to
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId_Peresort
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.GoodsId_to     = tmpMI.GoodsId_to
           AND _tmpItemPeresort_new.GoodsKindId_to = tmpMI.GoodsKindId_to
           AND tmpMI.Ord                           = 1
        ;

         -- нашли MovementItemId - Child
         UPDATE _tmpItemPeresort_new SET MovementItemId_from   = tmpMI.MovementItemId_from
         FROM (SELECT MI_Child.ParentId                                   AS MovementItemId_to
                    , MI_Child.Id                                         AS MovementItemId_from
                    , MI_Child.ObjectId                                   AS GoodsId_from
                    , COALESCE (MILinkObject_GoodsKind_Child.ObjectId, 0) AS GoodsKindId_from
                    , ROW_NUMBER() OVER (PARTITION BY MI_Child.ParentId, MI_Child.ObjectId, COALESCE (MILinkObject_GoodsKind_Child.ObjectId, 0)) AS Ord
               FROM MovementItem AS MI_Child
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Child
                                                     ON MILinkObject_GoodsKind_Child.MovementItemId = MI_Child.Id
                                                    AND MILinkObject_GoodsKind_Child.DescId         = zc_MILinkObject_GoodsKind()
               WHERE MI_Child.MovementId = vbMovementId_Peresort
                 AND MI_Child.DescId     = zc_MI_Child()
                 AND MI_Child.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.MovementItemId_to = tmpMI.MovementItemId_to
           AND _tmpItemPeresort_new.GoodsId_from      = tmpMI.GoodsId_from
           AND _tmpItemPeresort_new.GoodsKindId_from  = tmpMI.GoodsKindId_from
           AND tmpMI.Ord                              = 1
        ;


         -- Проверка - что б ничего не делать
         IF vbMovementId_Peresort <> 0
            -- если дата Документа раньше чем "незакрытый" период
            AND DATE_TRUNC ('MONTH', vbOperDate) < DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '5 DAY')
         THEN
            IF -- если НЕТ элементов которые надо добавить
               NOT EXISTS (SELECT 1 FROM _tmpItemPeresort_new WHERE MovementItemId_to = 0 OR MovementItemId_from = 0)
               -- если НЕТ элементов Master + Child которые прийдется удалять
           AND NOT EXISTS (SELECT 1 FROM MovementItem LEFT JOIN (SELECT MovementItemId_to   AS MovementItemId FROM _tmpItemPeresort_new UNION ALL SELECT MovementItemId_from AS MovementItemId FROM _tmpItemPeresort_new) AS tmp ON tmp.MovementItemId = MovementItem.Id
                           WHERE MovementItem.MovementId = vbMovementId_Peresort AND MovementItem.isErased   = FALSE AND tmp.MovementItemId IS NULL)
               -- если по элементам Master НЕТ изменений в кол-ве - обязательно взяли только там где нет составляющих
           AND NOT EXISTS (SELECT 1 FROM MovementItem INNER JOIN (SELECT DISTINCT _tmpItemPeresort_new.MovementItemId_to, _tmpItemPeresort_new.Amount_to FROM _tmpItemPeresort_new WHERE _tmpItemPeresort_new.ReceipId_to >= 0) AS tmp ON tmp.MovementItemId_to = MovementItem.Id
                           WHERE MovementItem.MovementId = vbMovementId_Peresort AND MovementItem.Amount <> tmp.Amount_to)
               -- если по элементам Child НЕТ изменений в кол-ве
           AND NOT EXISTS (SELECT 1 FROM MovementItem INNER JOIN _tmpItemPeresort_new ON _tmpItemPeresort_new.MovementItemId_from = MovementItem.Id
                                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_to ON ObjectLink_Goods_Measure_to.ObjectId = _tmpItemPeresort_new.GoodsId_to
                                                                                                         AND ObjectLink_Goods_Measure_to.DescId = zc_ObjectLink_Goods_Measure()
                                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_from ON ObjectLink_Goods_Measure_from.ObjectId = _tmpItemPeresort_new.GoodsId_from
                                                                                                           AND ObjectLink_Goods_Measure_from.DescId = zc_ObjectLink_Goods_Measure()
                                                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                            ON ObjectFloat_Weight.ObjectId = CASE WHEN ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_from.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                                                                       THEN ObjectLink_Goods_Measure_to.ObjectId
                                                                                                                  WHEN ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_to.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                                                                       THEN ObjectLink_Goods_Measure_from.ObjectId
                                                                                                             END
                                                                           AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                           WHERE MovementItem.MovementId = vbMovementId_Peresort
                             AND MovementItem.Amount <> CASE -- если это составляющие
                                                             WHEN _tmpItemPeresort_new.ReceipId_to < 0
                                                                  THEN _tmpItemPeresort_new.Amount_to
                                                             -- если это НЕ составляющие и надо перевести в Вес
                                                             WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh()
                                                                  THEN _tmpItemPeresort_new.Amount_to * ObjectFloat_Weight.ValueData
                                                             -- если это НЕ составляющие и надо перевести в Шт
                                                             WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh()
                                                                  THEN _tmpItemPeresort_new.Amount_to / ObjectFloat_Weight.ValueData
                                                             -- иначе ... ?
                                                             ELSE _tmpItemPeresort_new.Amount_to
                                                        END
                          )
            THEN
                -- Админу только отладка
                --if inUserId = 5 then RAISE EXCEPTION 'OK - Проверка - что б ничего не делать'; end if;
                -- !!!Выход!!!
                RETURN;
            END IF;

            -- Админу только отладка
            -- if inUserId = 5 then RAISE EXCEPTION 'Ошибка - НЕТ Проверки - что б ничего не делать  <%>', (SELECT COUNT(*) FROM _tmpItemPeresort_new WHERE MovementItemId_to = 0 OR MovementItemId_from = 0); end if;
            if inUserId = 5 then RAISE EXCEPTION 'Ошибка - НЕТ Проверки - что б ничего не делать  <%>', (SELECT COUNT(*) FROM _tmpItemPeresort_new WHERE GoodsKindId_to is null OR GoodsKindId_from is null); end if;

         END IF;


         -- Распровели
         IF vbMovementId_Peresort <> 0
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Peresort
                                          , inUserId     := inUserId
                                           );
         END IF;


         -- создается документ - <Производство смешивание> - Пересортица
         vbMovementId_Peresort:= lpInsertUpdate_Movement_ProductionUnion (ioId             := vbMovementId_Peresort
                                                                        , inInvNumber      := CASE WHEN vbMovementId_Peresort <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Peresort) ELSE CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar) END
                                                                        , inOperDate       := vbOperDate
                                                                        , inFromId         := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inToId           := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inDocumentKindId := 0
                                                                        , inIsPeresort     := CASE WHEN EXISTS (SELECT 1 FROM _tmpItemPeresort_new AS tmp WHERE tmp.ReceipId_to <> 0) THEN FALSE ELSE TRUE END
                                                                        , inUserId         := inUserId
                                                                         );

IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>   <%>   <%>', vbMovementId_Peresort
    , (select SUM (_tmpItemPeresort_new.Amount_to) from _tmpItemPeresort_new)
    , (select SUM (_tmpItemPeresort_new.Amount_Remains) from _tmpItemPeresort_new)
    ;
END IF;

         -- сохранили свойство <автоматически сформирован>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_Peresort, TRUE);

         -- удаляются элементы - Master + Child
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                         , inUserId        := inUserId
                                          )
         FROM MovementItem
              LEFT JOIN (SELECT MovementItemId_to   AS MovementItemId FROM _tmpItemPeresort_new
                        UNION ALL
                         SELECT MovementItemId_from AS MovementItemId FROM _tmpItemPeresort_new
                       ) AS tmp ON tmp.MovementItemId = MovementItem.Id
         WHERE MovementItem.MovementId = vbMovementId_Peresort
           AND MovementItem.isErased   = FALSE
           AND tmp.MovementItemId IS NULL
        ;

         -- сохранили в табл. элементы - Master
         UPDATE _tmpItemPeresort_new SET MovementItemId_to = tmpMI.MovementItemId_new
         FROM (SELECT tmp.MovementItemId_new, tmp.GoodsId_to, tmp.GoodsKindId_to
                    , -- еще св-во связь с <Рецептуры>
                      lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), tmp.MovementItemId_new, tmp.ReceipId_to)
               FROM
              (SELECT tmp.GoodsId_to, tmp.GoodsKindId_to, tmp.ReceipId_to
                    , -- сохранили элементы - Master
                      lpInsertUpdate_MI_ProductionUnion_Master
                                                  (ioId                     := tmp.MovementItemId_to
                                                 , inMovementId             := vbMovementId_Peresort
                                                 , inGoodsId                := tmp.GoodsId_to
                                                 , inAmount                 := tmp.Amount_to
                                                 , inCount                  := 0
                                                 , inCuterWeight            := 0
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := tmp.GoodsKindId_to
                                                 , inGoodsKindId_Complete   := NULL
                                                 , inUserId                 := inUserId
                                                  ) AS MovementItemId_new
               FROM (-- обязательно взяли только там где нет составляющих
                     SELECT DISTINCT _tmpItemPeresort_new.MovementItemId_to, _tmpItemPeresort_new.GoodsId_to, _tmpItemPeresort_new.GoodsKindId_to, _tmpItemPeresort_new.ReceipId_to, _tmpItemPeresort_new.Amount_to
                     FROM _tmpItemPeresort_new
                     WHERE _tmpItemPeresort_new.ReceipId_to >= 0
                    ) AS tmp
              ) AS tmp
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.GoodsId_to     = tmpMI.GoodsId_to
           AND _tmpItemPeresort_new.GoodsKindId_to = tmpMI.GoodsKindId_to
          ;

         -- отдельно для информации сохраняем обязательно факт остатка Amount_Remains
         PERFORM lpInsert_MovementItemProtocol (tmpMI.MovementItemId_to, inUserId, FALSE)
         FROM (SELECT lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), _tmpItemPeresort_new.MovementItemId_to, COALESCE (_tmpItemPeresort_new.Amount_Remains, 0))
                    , _tmpItemPeresort_new.MovementItemId_to
               FROM _tmpItemPeresort_new
                    LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItemPeresort_new.MovementItemId_to
                                                      AND MIF.DescId         = zc_MIFloat_Remains()
               WHERE COALESCE(_tmpItemPeresort_new.Amount_Remains, 0) <> COALESCE (MIF.ValueData, 0)
              ) AS tmpMI
              ;

         -- сохранили элементы - Child
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := _tmpItemPeresort_new.MovementItemId_from
                                                 , inMovementId             := vbMovementId_Peresort
                                                 , inGoodsId                := _tmpItemPeresort_new.GoodsId_from
                                                 , inAmount                 := CASE -- если это составляющие
                                                                                    WHEN _tmpItemPeresort_new.ReceipId_to < 0
                                                                                         THEN _tmpItemPeresort_new.Amount_to
                                                                                    -- если это НЕ составляющие и надо перевести в Вес
                                                                                    WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh()
                                                                                         THEN _tmpItemPeresort_new.Amount_to * ObjectFloat_Weight.ValueData
                                                                                    -- если это НЕ составляющие и надо перевести в Шт
                                                                                    WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh()
                                                                                         THEN _tmpItemPeresort_new.Amount_to / ObjectFloat_Weight.ValueData
                                                                                    -- иначе ... ?
                                                                                    ELSE _tmpItemPeresort_new.Amount_to
                                                                               END
                                                 , inParentId               := _tmpItemPeresort_new.MovementItemId_to
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := _tmpItemPeresort_new.GoodsKindId_from
                                                 , inGoodsKindCompleteId    := NULL
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := inUserId
                                                  )
         FROM _tmpItemPeresort_new
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_to ON ObjectLink_Goods_Measure_to.ObjectId = _tmpItemPeresort_new.GoodsId_to
                                                                 AND ObjectLink_Goods_Measure_to.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_from ON ObjectLink_Goods_Measure_from.ObjectId = _tmpItemPeresort_new.GoodsId_from
                                                                   AND ObjectLink_Goods_Measure_from.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = CASE WHEN ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_from.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                               THEN ObjectLink_Goods_Measure_to.ObjectId
                                                                          WHEN ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_to.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                               THEN ObjectLink_Goods_Measure_from.ObjectId
                                                                     END
                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
         WHERE _tmpItemPeresort_new.ReceipId_gp_to <= 0
        ;

         -- Сохранили связь документов
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Production(), vbMovementId_Peresort, inMovementId);

         -- создаются временные таблицы - для формирование данных для проводок
         PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
         -- Проводим
         PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_Peresort
                                                    , inIsHistoryCost  := TRUE
                                                    , inUserId         := inUserId)
        ;
         -- !!!обязательно!!! очистили таблицу проводок
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
         -- !!!обязательно!!! удалили таблицы
         DROP TABLE _tmpItem_pr;
         DROP TABLE _tmpItemSumm_pr;
         DROP TABLE _tmpItemChild;
         DROP TABLE _tmpItemSummChild;
         DROP TABLE _tmpItem_Partion;
         DROP TABLE _tmpItem_Partion_child;


     ELSE
         IF vbMovementId_Peresort <> 0 AND zc_Enum_Status_Erased() <> (SELECT StatusId FROM Movement WHERE Id = vbMovementId_Peresort)
         THEN
             PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Peresort
                                         , inUserId     := inUserId
                                          );
         END IF;

     END IF;
     END IF; -- if ... Временно захардкодил - !!!только для этого склада!!!

     -- Админу только отладка
     if inUserId = 5 AND 1=0 then RAISE EXCEPTION 'Нет Прав и нет Проверки - что б ничего не делать'; end if;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.16                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_Recalc (inMovementId:= 4691383, inUnitId:= 8459, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_SendOnPrice (inMovementId:= 4691383, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_Sale (inMovementId:= 4691383, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
