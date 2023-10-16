-- Function: lpUpdate_MI_OrderInternal_Property()

DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, Boolean, Integer);
-- DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_OrderInternal_Property(
 INOUT ioId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                  Integer   , -- Товары
    IN inGoodsKindId              Integer   , -- Виды товаров
    IN inAmount_Param             TFloat    , --
    IN inDescId_Param             Integer   ,
    IN inAmount_ParamOrder        TFloat    , --
    IN inDescId_ParamOrder        Integer   ,
    IN inAmount_ParamSecond       TFloat    , --
    IN inDescId_ParamSecond       Integer   ,
    IN inAmount_ParamAdd          TFloat    DEFAULT 0    , --
    IN inDescId_ParamAdd          Integer   DEFAULT 0    ,
    IN inAmount_ParamNext         TFloat    DEFAULT 0    , --
    IN inDescId_ParamNext         Integer   DEFAULT 0    ,
    IN inAmount_ParamNextPromo    TFloat    DEFAULT 0    , --
    IN inDescId_ParamNextPromo    Integer   DEFAULT 0    ,
    IN inAmountRK_start           TFloat    DEFAULT 0    , --
    IN inIsPack                   Boolean   DEFAULT NULL , --
    IN inIsParentMulti            Boolean   DEFAULT FALSE, -- надо ли раскладывать по разным ГП
    IN inUserId                   Integer   DEFAULT 0      -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsParentMulti_goods Boolean;
   DECLARE vbMonth Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbAmount_calc TFloat;

   DECLARE vbGoodsId_add     Integer;
   DECLARE vbGoodsKindId_add Integer;
   
   DECLARE vbMovementItemId_tmp Integer;
   DECLARE vbGoodsId_tmp Integer;
   DECLARE vbGoodsKindId_tmp Integer;
   DECLARE vbGoodsId_child_tmp Integer;
   DECLARE vbGoodsKindId_child_tmp Integer;
   DECLARE vbReceipId_tmp Integer;
   DECLARE vbAmount_Param_tmp TFloat;
   DECLARE vbAmount_ParamOrder_tmp TFloat;
BEGIN
     -- переопределили
     IF COALESCE (inAmountRK_start, 0) = 0 AND inDescId_Param <> zc_MIFloat_AmountRemains() AND ioId > 0
     THEN
         -- нашли
         inAmountRK_start:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountRemainsRK()), 0);
     END IF;


     -- определяется
     SELECT EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbMonth, vbOperDate, vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


    -- таблица -
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpParentMulti')
     THEN
         DELETE FROM _tmpParentMulti;
     ELSE
         CREATE TEMP TABLE _tmpParentMulti (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, GoodsId_child Integer, GoodsKindId_child Integer, ReceipId Integer, Amount_Param TFloat, Amount_ParamOrder TFloat, AmountRK_start TFloat) ON COMMIT DROP;
     END IF;
     -- нашли - надо ли раскладывать по разным ГП
     IF inIsParentMulti = TRUE
     THEN
         --
         vbIsParentMulti_goods:= COALESCE ((SELECT ObjectBoolean_ParentMulti.ValueData
                                            FROM ObjectLink AS ObjectLink_Receipt_Goods
                                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                                       ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                                                      AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                                                      AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                                                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                                    AND Object_Receipt.isErased = FALSE
                                                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                          ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                                                         AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                                                         AND ObjectBoolean_Main.ValueData = TRUE
                                                 INNER JOIN ObjectBoolean AS ObjectBoolean_ParentMulti
                                                                          ON ObjectBoolean_ParentMulti.ObjectId  = Object_Receipt.Id
                                                                         AND ObjectBoolean_ParentMulti.DescId    = zc_ObjectBoolean_Receipt_ParentMulti()
                                                                         AND ObjectBoolean_ParentMulti.ValueData = TRUE
                                            WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                                              AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                           ), FALSE);
     ELSE
         vbIsParentMulti_goods:= FALSE;
     END IF;

if ioId = 185125074 and inUserId = 5
then
    RAISE EXCEPTION 'Ошибка.<%>', vbIsParentMulti_goods;
end if;

     -- если товар раскладывается на несколько
     IF vbIsParentMulti_goods = TRUE
     THEN
         INSERT INTO _tmpParentMulti (MovementItemId, GoodsId, GoodsKindId, GoodsId_child, GoodsKindId_child, ReceipId, Amount_Param, Amount_ParamOrder, AmountRK_start)
            WITH -- Рецепт
                 tmpReceiptChild AS
              (SELECT ObjectLink_Receipt_Goods.ObjectId               AS ReceiptId
                    , ObjectLink_Receipt_Goods.ChildObjectId          AS GoodsId
                    , ObjectLink_Receipt_GoodsKind.ChildObjectId      AS GoodsKindId
                    , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId_child
                    , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId AS GoodsKindId_child
                    , ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS Value
               FROM ObjectLink AS ObjectLink_Receipt_Goods
                    INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                          ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                         AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                         AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                    INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                       AND Object_Receipt.isErased = FALSE
                    INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                           ON ObjectFloat_Value_master.ObjectId  = Object_Receipt.Id
                                          AND ObjectFloat_Value_master.DescId    = zc_ObjectFloat_Receipt_Value()
                                          AND ObjectFloat_Value_master.ValueData <> 0
                    INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                             ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                            AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                            AND ObjectBoolean_Main.ValueData = TRUE
                    INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                          ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = Object_Receipt.Id
                                         AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()
                    INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                            AND Object_ReceiptChild.isErased = FALSE
                    LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                         ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                        AND ObjectLink_ReceiptChild_Goods.DescId   = zc_ObjectLink_ReceiptChild_Goods()
                    LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                         ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                        AND ObjectLink_ReceiptChild_GoodsKind.DescId   = zc_ObjectLink_ReceiptChild_GoodsKind()
                    INNER JOIN ObjectFloat AS ObjectFloat_Value
                                           ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                          AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                          AND ObjectFloat_Value.ValueData <> 0
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                         ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                        AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                    INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                    AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- Доходы
                                                      OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                        )
                    LEFT JOIN ObjectLink AS ObjectLink_Measure
                                         ON ObjectLink_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                        AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                          ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                         AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                 AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                 AND ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END <> 0
                 AND ObjectLink_Receipt_GoodsKind.ChildObjectId      > 0
                 AND ObjectLink_ReceiptChild_Goods.ChildObjectId     > 0
                 AND ObjectLink_ReceiptChild_GoodsKind.ChildObjectId > 0
              )
                 -- Элементы
               , tmpMI AS
              (SELECT MovementItem.Id                                       AS MovementItemId
                    , MovementItem.ObjectId                                 AS GoodsId
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                    , COALESCE (MILinkObject_Goods.ObjectId, 0)             AS GoodsId_child
                    , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_child
                      -- № п/п
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                    , MILinkObject_GoodsKind.ObjectId
                                                    , MILinkObject_Goods.ObjectId
                                                    , MILinkObject_GoodsKindComplete.ObjectId
                                         ORDER BY MovementItem.Id DESC
                                        ) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                     ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()
                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.ObjectId   = inGoodsId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
                 AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                 AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                 AND MILinkObject_Goods.ObjectId > 0
               )
           --
           SELECT COALESCE (tmpMI.MovementItemId, 0)                                    AS MovementItemId
                , COALESCE (tmpReceiptChild.GoodsId, tmpMI.GoodsId)                     AS GoodsId
                , COALESCE (tmpReceiptChild.GoodsKindId, tmpMI.GoodsKindId)             AS GoodsKindId
                , COALESCE (tmpReceiptChild.GoodsId_child, tmpMI.GoodsId_child)         AS GoodsId_child
                , COALESCE (tmpReceiptChild.GoodsKindId_child, tmpMI.GoodsKindId_child) AS GoodsKindId_child
                , tmpReceiptChild.ReceiptId
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 AND tmpReceiptChild.Value > 0 THEN tmpReceiptChild.Value * inAmount_Param      / tmpReceiptChild_sum.Value ELSE 0 END AS Amount_Param
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 AND tmpReceiptChild.Value > 0 THEN tmpReceiptChild.Value * inAmount_ParamOrder / tmpReceiptChild_sum.Value ELSE 0 END AS Amount_ParamOrder
                , CASE WHEN COALESCE (tmpMI.Ord, 1) = 1 AND tmpReceiptChild.Value > 0 THEN tmpReceiptChild.Value * inAmountRK_start    / tmpReceiptChild_sum.Value ELSE 0 END AS AmountRK_start
           FROM tmpMI
                FULL JOIN tmpReceiptChild ON tmpReceiptChild.GoodsId           = tmpMI.GoodsId
                                         AND tmpReceiptChild.GoodsKindId       = tmpMI.GoodsKindId
                                         AND tmpReceiptChild.GoodsId_child     = tmpMI.GoodsId_child
                                         AND tmpReceiptChild.GoodsKindId_child = tmpMI.GoodsKindId_child

                LEFT JOIN (SELECT SUM (tmpReceiptChild.Value) AS Value FROM tmpReceiptChild) AS tmpReceiptChild_sum ON 1=1
           ;

     ELSE
         -- если товар НЕ раскладывается на несколько
         INSERT INTO _tmpParentMulti (MovementItemId, GoodsId, GoodsKindId, GoodsId_child, GoodsKindId_child, ReceipId, Amount_Param, Amount_ParamOrder, AmountRK_start)
            SELECT COALESCE (ioId, 0), inGoodsId, inGoodsKindId, inGoodsId, inGoodsKindId, 0, inAmount_Param, inAmount_ParamOrder, inAmountRK_start
           ;
     END IF;

     -- !!!только - для Заявки на упаковку по ОСТАТКАМ!!!
     IF COALESCE (ioId, 0) = 0 AND inIsPack IS NULL AND inDescId_ParamOrder = zc_MIFloat_ContainerId() AND COALESCE (inAmount_ParamOrder, 0) = 0
     THEN
         -- !!!нашли!!!
         ioId:= (SELECT MovementItem.Id
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                  ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                 AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId   = inGoodsId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                   AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                );
         --
         UPDATE _tmpParentMulti SET MovementItemId = COALESCE (ioId, 0);
         -- Проверка, на всякий случай
         IF (SELECT COUNT(*) FROM _tmpParentMulti) > 1
         THEN
             RAISE EXCEPTION 'Ошибка.Найдено больше одной строчки.';
         END IF;
         
     END IF;


     -- Расчет ТОЛЬКО для СЫРЬЯ
     IF inDescId_ParamSecond = zc_MIFloat_AmountPartnerSecond()
     /*AND EXISTS (SELECT 1
                FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                    AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                    -- AND Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10204() -- Основное сырье + Прочее сырье + Прочее сырье
                WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
               )*/
     THEN 
         -- Проверка, на всякий случай
         IF (SELECT COUNT(*) FROM _tmpParentMulti) > 1
         THEN
             RAISE EXCEPTION 'Ошибка.Найдено больше одной строчки.';
         END IF;
         --
         vbAmount_calc:= CASE WHEN EXISTS (SELECT 1
                                            FROM ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                                      ON ObjectLink_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                                     AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                                            WHERE ObjectLink_Goods_GoodsGroup.ObjectId = inGoodsId
                                              AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                                              AND (ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                  )
                                           )
                          THEN
                               COALESCE (inAmount_Param, 0) + COALESCE (inAmount_ParamOrder, 0) + COALESCE (inAmount_ParamSecond, 0)
                          ELSE
                               COALESCE (inAmount_Param, 0) + COALESCE (inAmount_ParamOrder, 0) + COALESCE (inAmount_ParamSecond, 0)
                             - (-- Остатки
                                COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountRemains()), 0)
                                 -- группируется Перемещение
                              + COALESCE ((SELECT SUM (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                                           FROM (SELECT CASE -- !!!временно захардкодил!!!
                                                             WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                                              -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                                  THEN 8338 -- морож.
                                                             ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                                        END AS GoodsKindId
                                                      , SUM (MIContainer.Amount) AS Amount
                                                 FROM MovementItemContainer AS MIContainer
                                                 WHERE MIContainer.OperDate               = vbOperDate
                                                   AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                   AND MIContainer.MovementDescId         = zc_Movement_Send()
                                                   AND MIContainer.ObjectId_Analyzer      = inGoodsId
                                                   AND MIContainer.WhereObjectId_Analyzer = vbFromId
                                                   -- AND MIContainer.isActive = TRUE
                                                 GROUP BY CASE -- !!!временно захардкодил!!!
                                                               WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                                                -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                                    THEN 8338 -- морож.
                                                               ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                                          END
                                                UNION ALL
                                                 SELECT CASE -- !!!временно захардкодил!!!
                                                             WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                                              -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                                  THEN 8338 -- морож.
                                                             ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                                        END AS GoodsKindId
                                                      , SUM (MIContainer.Amount) AS Amount
                                                 FROM MovementItemContainer AS MIContainer
                                                 WHERE MIContainer.OperDate               = vbOperDate
                                                   AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                   AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                                                   AND MIContainer.ObjectId_Analyzer      = inGoodsId
                                                   AND MIContainer.WhereObjectId_Analyzer = vbFromId
                                                -- AND MIContainer.isActive = TRUE
                                                   AND MIContainer.ObjectExtId_Analyzer <> MIContainer.WhereObjectId_Analyzer
                                                 GROUP BY CASE -- !!!временно захардкодил!!!
                                                               WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                                                -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                                    THEN 8338 -- морож.
                                                               ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                                          END
                                                ) AS tmpMI
                                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                     ON ObjectLink_Goods_Measure.ObjectId = inGoodsId
                                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                      ON ObjectFloat_Weight.ObjectId = inGoodsId
                                                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                           WHERE tmpMI.GoodsKindId = COALESCE (inGoodsKindId, 0)
                                          ), 0)
                               )
                          END;
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF vbIsParentMulti_goods = TRUE
     THEN
         -- проверка уникальности
         IF EXISTS (SELECT 1
                    FROM _tmpParentMulti
                    GROUP BY _tmpParentMulti.GoodsId, _tmpParentMulti.GoodsKindId, _tmpParentMulti.GoodsId_child, _tmpParentMulti.GoodsKindId_child
                    HAVING COUNT(*) > 1
                    )
            -- для Заявки на упаковку по ОСТАТКАМ
            AND (COALESCE (inDescId_ParamOrder, 0) <> zc_MIFloat_ContainerId() OR COALESCE (inAmount_ParamOrder, 0) = 0)
         THEN
             RAISE EXCEPTION 'Ошибка.В документе уже существует <%> <%>.Дублирование запрещено. % %'
                            , lfGet_Object_ValueData (inGoodsId)
                            , lfGet_Object_ValueData (inGoodsKindId)
                            , inGoodsId
                            , inGoodsKindId
                             ;
         END IF;

         -- сохранили <Элемент документа>
         UPDATE _tmpParentMulti SET MovementItemId =
                 lpInsertUpdate_MovementItem (_tmpParentMulti.MovementItemId, zc_MI_Master(), inGoodsId, inMovementId
                                            , (SELECT CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                                               , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                                                )
                                                          --AND _tmpParentMulti.MovementItemId > 0
                                                                 THEN COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = _tmpParentMulti.MovementItemId), 0)
                                                           ELSE COALESCE (CASE WHEN vbAmount_calc > 0 THEN vbAmount_calc ELSE 0 END, 0)
                                                      END
                                               FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                               WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                              )
                                            , NULL
                                             )
         WHERE _tmpParentMulti.MovementItemId = 0
        ;

         -- сохранили связь с <Виды товаров>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), _tmpParentMulti.MovementItemId, inGoodsKindId)
         FROM _tmpParentMulti;

     ELSEIF COALESCE (ioId, 0) = 0
     THEN
         -- проверка уникальности
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                      AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                    )
            -- для Заявки на упаковку по ОСТАТКАМ
            AND (COALESCE (inDescId_ParamOrder, 0) <> zc_MIFloat_ContainerId() OR COALESCE (inAmount_ParamOrder, 0) = 0)
         THEN
             RAISE EXCEPTION 'Ошибка.В документе уже существует <%> <%>.Дублирование запрещено. % %', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), inGoodsId, inGoodsKindId;
         END IF;


         -- сохранили <Элемент документа>
         UPDATE _tmpParentMulti SET MovementItemId =
                 lpInsertUpdate_MovementItem (_tmpParentMulti.MovementItemId, zc_MI_Master(), inGoodsId, inMovementId
                                            , (SELECT CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                                               , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                                                )
                                                          --AND _tmpParentMulti.MovementItemId > 0
                                                                 THEN COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = _tmpParentMulti.MovementItemId), 0)
                                                           ELSE COALESCE (CASE WHEN vbAmount_calc > 0 THEN vbAmount_calc ELSE 0 END, 0)
                                                      END
                                               FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                               WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                              )
                                            , NULL
                                             );

         -- сохранили связь с <Виды товаров>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), _tmpParentMulti.MovementItemId, inGoodsKindId)
         FROM _tmpParentMulti;

     -- ТОЛЬКО для СЫРЬЯ
     ELSEIF inDescId_ParamSecond = zc_MIFloat_AmountPartnerSecond()
     THEN

         -- сохранили <Элемент документа>
         UPDATE _tmpParentMulti SET MovementItemId =
                 lpInsertUpdate_MovementItem (_tmpParentMulti.MovementItemId, zc_MI_Master(), inGoodsId, inMovementId
                                            , (SELECT CASE WHEN _tmpParentMulti.MovementItemId > 0
                                                            AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                                               , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                                                )
                                                                 THEN (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = _tmpParentMulti.MovementItemId)
                                                           ELSE COALESCE (CASE WHEN vbAmount_calc > 0 THEN vbAmount_calc ELSE 0 END, 0)
                                                      END
                                               FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                               WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                 AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                              )
                                            , NULL
                                             );

     -- !!!временно
     -- ELSE
         -- сохранили <Элемент документа>
         -- ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

     END IF;
     
     

     -- !!!только для заявки на производство!!!
     IF inIsPack = FALSE AND (vbIsInsert = TRUE OR 1=1)
     THEN
         -- проверка
         IF EXISTS (SELECT 1 FROM _tmpParentMulti WHERE COALESCE (_tmpParentMulti.MovementItemId, 0) = 0)
         THEN
             RAISE EXCEPTION 'Ошибка.В документе _tmpParentMulti.MovementItemId = 0 Кол-во=%', (SELECT COUNT(*) FROM _tmpParentMulti WHERE COALESCE (_tmpParentMulti.MovementItemId, 0) = 0);
         END IF;

         -- сохранили связь с <Рецептуры>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), _tmpParentMulti.MovementItemId, tmp.ReceiptId_basis)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      _tmpParentMulti.MovementItemId, tmp.ReceiptId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(),   _tmpParentMulti.MovementItemId, ObjectLink_Receipt_Goods_basis.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(),        _tmpParentMulti.MovementItemId, ObjectLink_Receipt_Goods.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), _tmpParentMulti.MovementItemId, ObjectLink_Receipt_GoodsKind.ChildObjectId)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TermProduction(),         _tmpParentMulti.MovementItemId, COALESCE (ObjectFloat_TermProduction.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NormInDays(),             _tmpParentMulti.MovementItemId, COALESCE (ObjectFloat_NormInDays.ValueData, 2))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(),                  _tmpParentMulti.MovementItemId, COALESCE (ObjectFloat_Koeff.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartProductionInDays(),  _tmpParentMulti.MovementItemId, COALESCE (ObjectFloat_StartProductionInDays.ValueData, 1))
         FROM _tmpParentMulti
              LEFT JOIN (SELECT _tmpParentMulti.GoodsId_child AS GoodsId
                              , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                END AS ReceiptId_basis
                              , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_0.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_1.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_2.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_3.ObjectId
                                END AS ReceiptId
                         FROM _tmpParentMulti
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = _tmpParentMulti.GoodsId_child
                                                   AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                              
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                                   AND ObjectLink_Receipt_GoodsKind.ChildObjectId = _tmpParentMulti.GoodsKindId_child

                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                   ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                   ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_1.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                   ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_2.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                   ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_3.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        ) AS tmp ON tmp.GoodsId = _tmpParentMulti.GoodsId_child


                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_basis
                                             ON ObjectLink_Receipt_Goods_basis.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_Goods_basis.DescId = zc_ObjectLink_Receipt_Goods()

                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                             ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                            AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                             ON ObjectLink_OrderType_Goods.ChildObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                            AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                              ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                                         WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                                         WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                                         WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                                         WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                                         WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                                         WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                                         WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                                         WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                                         WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                                         WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                                         WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                            END
                                             AND ObjectFloat_Koeff.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                              ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction()
                                             AND ObjectFloat_TermProduction.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                              ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays()
                                             AND ObjectFloat_NormInDays.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                              ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays()
                       ;
     END IF;

     -- !!!только для заявки на упаковку!!!
     IF inIsPack = TRUE AND (vbIsInsert = TRUE OR 1=1)
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);

         -- сохранили связь с <Рецептуры>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, tmp.ReceiptId_basis)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      ioId, tmp.ReceiptId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(),        ioId, ObjectLink_Receipt_Goods.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, ObjectLink_Receipt_GoodsKind.ChildObjectId)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TermProduction(),         ioId, COALESCE (ObjectFloat_TermProduction.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NormInDays(),             ioId, COALESCE (ObjectFloat_NormInDays.ValueData, 2))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(),                  ioId, COALESCE (ObjectFloat_Koeff.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartProductionInDays(),  ioId, COALESCE (ObjectFloat_StartProductionInDays.ValueData, 1))
         FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods
              LEFT JOIN (SELECT inGoodsId AS GoodsId
                              , Object_Receipt.Id AS ReceiptId
                              , ObjectLink_Receipt_Parent_0.ChildObjectId AS ReceiptId_basis
                         FROM ObjectLink AS ObjectLink_Receipt_Goods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                   AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Disabled
                                                      ON ObjectBoolean_Disabled.ObjectId = Object_Receipt.Id
                                                     AND ObjectBoolean_Disabled.DescId = zc_ObjectBoolean_Receipt_Disabled()
                                                     AND ObjectBoolean_Disabled.ValueData = TRUE

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                   ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                              /*LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()*/
                         WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                           AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                           AND ObjectBoolean_Disabled.ObjectId IS NULL
                        ) AS tmp ON tmp.GoodsId = inGoodsId


                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                             ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                             ON ObjectLink_OrderType_Goods.ChildObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                            AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                              ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                                         WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                                         WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                                         WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                                         WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                                         WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                                         WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                                         WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                                         WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                                         WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                                         WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                                         WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                            END
                                             AND ObjectFloat_Koeff.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                              ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction()
                                             AND ObjectFloat_TermProduction.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                              ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays()
                                             AND ObjectFloat_NormInDays.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                              ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays()
                       ;
     END IF;


     -- !!!только для заявки СЫРЬЕ!!!
     IF inIsPack IS NULL AND (vbIsInsert = TRUE OR 1=1) AND COALESCE (inDescId_ParamOrder, 0) <> zc_MIFloat_ContainerId()
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);

         -- сохранили связь с <Рецептуры>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, tmp.ReceiptId)
         FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods
              LEFT JOIN (SELECT inGoodsId AS GoodsId
                              , Object_Receipt.Id AS ReceiptId
                         FROM ObjectLink AS ObjectLink_Receipt_Goods
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                         WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                           AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        ) AS tmp ON tmp.GoodsId = inGoodsId
                       ;
     END IF;


     -- !!!только - для Заявки на упаковку по ОСТАТКАМ!!!
     IF inIsPack IS NULL AND (vbIsInsert = TRUE OR 1=1)
        AND (inDescId_ParamOrder = zc_MIFloat_ContainerId() OR inDescId_ParamAdd = zc_MIFloat_AmountPartnerPriorPromo())
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);

         -- сохранили связь с <Рецептуры>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, tmp.ReceiptId)
                 -- то из чего делается упаковка - НУЛЕВОЙ уровень - Здесь то что делается из ПФ_ГП
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(),             ioId, CASE WHEN tmpGoods.GoodsKindId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN NULL
                                                                                                        -- если след уровень - ПФ_ГП, тогда сейчас товар типа "ВЕС"
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN NULL -- tmpGoods.GoodsId
                                                                                                        -- если ЭТО ИРНА
                                                                                                        WHEN ObjectLink_Receipt_Parent_0.ChildObjectId IS NULL
                                                                                                         AND tmp.ReceiptId > 0
                                                                                                         AND tmpGoods.GoodsKindId <> zc_GoodsKind_WorkProgress()
                                                                                                             THEN tmpGoods.GoodsId
                                                                                                        -- иначе следуюющий товар типа "ВЕС"
                                                                                                        ELSE ObjectLink_Receipt_Goods_Parent_0.ChildObjectId
                                                                                                   END)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, CASE WHEN tmpGoods.GoodsKindId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN NULL
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                              THEN NULL -- tmp.GoodsKindId
                                                                                                        -- если ЭТО ИРНА
                                                                                                        WHEN ObjectLink_Receipt_Parent_0.ChildObjectId IS NULL
                                                                                                         AND tmp.ReceiptId > 0
                                                                                                         AND tmpGoods.GoodsKindId <> zc_GoodsKind_WorkProgress()
                                                                                                             THEN zc_GoodsKind_Basis()
                                                                                                        ELSE ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId
                                                                                                   END)
                 -- Товар <пф-гп>
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(),      ioId, CASE WHEN tmpGoods.GoodsKindId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN tmp.ReceiptId
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId
                                                                                                   END)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(),        ioId, CASE WHEN tmpGoods.GoodsKindId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN tmpGoods.GoodsId
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN ObjectLink_Receipt_Goods_Parent_0.ChildObjectId
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN ObjectLink_Receipt_Goods_Parent_1.ChildObjectId
                                                                                                        WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                                                                                             THEN ObjectLink_Receipt_Goods_Parent_2.ChildObjectId
                                                                                                   END)
                 -- Срок пр-ва
               , lpInsertUpdate_MovementItemFloat_byDesc (CASE WHEN tmpGoods.GoodsKindId = zc_GoodsKind_WorkProgress() THEN zc_MIFloat_TermProduction() ELSE NULL END
                                                        , ioId
                                                        , COALESCE (ObjectFloat_TermProduction.ValueData, 1)
                                                         )
         FROM (SELECT inGoodsId         AS GoodsId
                    , inGoodsKindId     AS GoodsKindId
              ) AS tmpGoods
              LEFT JOIN
               -- Рецепт для Товара, т.е. из чего он делается (как правило это Упаковка)
              (SELECT Object_Receipt.Id AS ReceiptId
               FROM ObjectLink AS ObjectLink_Receipt_Goods
                    INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                          ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                         AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                         AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                    --
                    INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                       AND Object_Receipt.isErased = FALSE
                    -- Только Главный рецепт
                    INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                             ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                            AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                            AND ObjectBoolean_Main.ValueData = TRUE
               WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                 AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
              ) AS tmp ON tmp.ReceiptId > 0

              -- Поднялись на 0 уровень - т.е. из чего делается Товар для Упаковки (как правило это уже ВЕС из ПФ_ГП)
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                   ON ObjectLink_Receipt_Parent_0.ObjectId = tmp.ReceiptId
                                  AND ObjectLink_Receipt_Parent_0.DescId   = zc_ObjectLink_Receipt_Parent()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent_0
                                   ON ObjectLink_Receipt_Goods_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                  AND ObjectLink_Receipt_Goods_Parent_0.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                   ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                  AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId   = zc_ObjectLink_Receipt_GoodsKind()
              -- Поднялись на 1 уровень - т.е. из чего делается ПФ_ГП (как правило это ЦЕХ и делается из СЫРЬЯ)
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                   ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                  AND ObjectLink_Receipt_Parent_1.DescId   = zc_ObjectLink_Receipt_Parent()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent_1
                                   ON ObjectLink_Receipt_Goods_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                  AND ObjectLink_Receipt_Goods_Parent_1.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                   ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                  AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId   = zc_ObjectLink_Receipt_GoodsKind()
              -- Поднялись на 2 уровень - т.е. если предыдущий это НЕ Цех
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                   ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                  AND ObjectLink_Receipt_Parent_2.DescId   = zc_ObjectLink_Receipt_Parent()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent_2
                                   ON ObjectLink_Receipt_Goods_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                  AND ObjectLink_Receipt_Goods_Parent_2.DescId   = zc_ObjectLink_Receipt_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                   ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                  AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId   = zc_ObjectLink_Receipt_GoodsKind()

              -- Параметры Пр-ва
              LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                   ON ObjectLink_OrderType_Goods.ChildObjectId = tmpGoods.GoodsId
                                  AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
              LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                    ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                   AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction()
                                   AND ObjectFloat_TermProduction.ValueData <> 0
             ;


         -- !!!Добавили еще!!!
         vbGoodsId_add    := (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Goods());
         vbGoodsKindId_add:= (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKindComplete());
/*
if ioId = 95103717 --  vbGoodsId_add = and vbGoodsKindId_add
then
 RAISE EXCEPTION '<%>  %  <%>  %', vbGoodsId_add, vbGoodsKindId_add,  inGoodsId,  inGoodsKindId;
-- select * from object where Id =  559324
end if;
*/

         -- !!!Добавили еще!!!
         IF vbGoodsId_add > 0 AND vbGoodsKindId_add > 0
            AND NOT EXISTS (SELECT 1
                            FROM MovementItem
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.ObjectId   = vbGoodsId_add
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                              AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = vbGoodsKindId_add
                              AND COALESCE (MIFloat_ContainerId.ValueData, 0)   = 0
                           )
         THEN
             -- запомнили
             vbMovementItemId_tmp    := (SELECT _tmpParentMulti.MovementItemId    FROM _tmpParentMulti);
             vbGoodsId_tmp           := (SELECT _tmpParentMulti.GoodsId           FROM _tmpParentMulti);
             vbGoodsKindId_tmp       := (SELECT _tmpParentMulti.GoodsKindId       FROM _tmpParentMulti);
             vbGoodsId_child_tmp     := (SELECT _tmpParentMulti.GoodsId_child     FROM _tmpParentMulti);
             vbGoodsKindId_child_tmp := (SELECT _tmpParentMulti.GoodsKindId_child FROM _tmpParentMulti);
             vbReceipId_tmp          := (SELECT _tmpParentMulti.ReceipId          FROM _tmpParentMulti);
             vbAmount_Param_tmp      := (SELECT _tmpParentMulti.Amount_Param      FROM _tmpParentMulti);
             vbAmount_ParamOrder_tmp := (SELECT _tmpParentMulti.Amount_ParamOrder FROM _tmpParentMulti);

             --
             -- RAISE EXCEPTION '<%>   <%>', vbGoodsId_add, vbGoodsKindId_add;
             --
             PERFORM lpUpdate_MI_OrderInternal_Property (ioId                     := NULL
                                                        , inMovementId            := inMovementId
                                                        , inGoodsId               := vbGoodsId_add
                                                        , inGoodsKindId           := vbGoodsKindId_add
                                                        , inAmount_Param          := 0
                                                        , inDescId_Param          := zc_MIFloat_AmountRemains()
                                                        , inAmount_ParamOrder     := 0
                                                        , inDescId_ParamOrder     := zc_MIFloat_ContainerId()
                                                        , inAmount_ParamSecond    := NULL
                                                        , inDescId_ParamSecond    := NULL
                                                        , inAmount_ParamAdd       := 0
                                                        , inDescId_ParamAdd       := 0
                                                        , inAmount_ParamNext      := 0
                                                        , inDescId_ParamNext      := 0
                                                        , inAmount_ParamNextPromo := 0
                                                        , inDescId_ParamNextPromo := 0
                                                        , inAmountRK_start        := 0
                                                        , inIsPack                := NULL -- что б не формировать св-ва
                                                        , inIsParentMulti         := TRUE
                                                        , inUserId                := inUserId
                                                         );

             -- удалили
             DELETE FROM _tmpParentMulti;
             -- восстановили
             INSERT INTO _tmpParentMulti (MovementItemId, GoodsId, GoodsKindId, GoodsId_child, GoodsKindId_child, ReceipId, Amount_Param, Amount_ParamOrder)
                VALUES (vbMovementItemId_tmp, vbGoodsId_tmp, vbGoodsKindId_tmp, vbGoodsId_child_tmp, vbGoodsKindId_child_tmp, vbReceipId_tmp, vbAmount_Param_tmp, vbAmount_ParamOrder_tmp);

         END IF;

     END IF;


     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpParentMulti WHERE _tmpParentMulti.Amount_Param IS NULL)
     THEN
          RAISE EXCEPTION 'Ошибка._tmpParentMulti.Amount_Param IS NULL <%> <%>', ioId, (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti WHERE _tmpParentMulti.Amount_Param IS NULL LIMIT 1);
     END IF;
     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemFloat (inDescId_Param, _tmpParentMulti.MovementItemId, _tmpParentMulti.Amount_Param)
     FROM _tmpParentMulti;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemainsRK(), _tmpParentMulti.MovementItemId, COALESCE (_tmpParentMulti.AmountRK_start, 0))
     FROM _tmpParentMulti;

     -- сохранили свойство
     IF inDescId_ParamOrder <> 0
     THEN
          -- Проверка
          IF EXISTS (SELECT 1 FROM _tmpParentMulti WHERE _tmpParentMulti.Amount_Param IS NULL)
          THEN
               RAISE EXCEPTION 'Ошибка._tmpParentMulti.Amount_ParamOrder IS NULL <%> <%>', ioId, (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti WHERE _tmpParentMulti.Amount_ParamOrder IS NULL LIMIT 1);
          END IF;
          -- сохранили
          PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamOrder, _tmpParentMulti.MovementItemId, _tmpParentMulti.Amount_ParamOrder)
          FROM _tmpParentMulti;
     END IF;

     -- сохранили свойство
     IF inDescId_ParamSecond <> 0
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);
         --
         IF inDescId_ParamSecond = zc_MIFloat_AmountPrIn()
         THEN
              IF inAmount_ParamSecond > 0 OR EXISTS (SELECT 1 FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = inDescId_ParamSecond)
              THEN
                  -- Проверка
                  IF inAmount_ParamSecond IS NULL
                  THEN
                       RAISE EXCEPTION 'Ошибка.inAmount_ParamSecond IS NULL<%>', ioId;
                  END IF;
                  --
                  PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamSecond, ioId, inAmount_ParamSecond);
              END IF;
         ELSE
             --
             PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamSecond, ioId, inAmount_ParamSecond);
         END IF;
     END IF;

     -- сохранили свойство
     IF inDescId_ParamAdd = zc_MIFloat_Plan1() AND (inAmount_ParamAdd <> 0 OR ioId <> 0)
     THEN
         -- !!!не ошибка, здесь добавленный Расход на производство в статистику Продаж!!!
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamAdd, ioId, inAmount_ParamAdd);

     ELSEIF inDescId_ParamAdd <> 0
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);
         -- Проверка
         IF inAmount_ParamAdd IS NULL
         THEN
              RAISE EXCEPTION 'Ошибка.inAmount_ParamAdd IS NULL<%>', ioId;
         END IF;
         --
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamAdd, ioId, inAmount_ParamAdd);
     END IF;

     -- сохранили свойство
     IF inDescId_ParamNext = zc_MIFloat_Promo1() AND (inAmount_ParamNext <> 0 OR ioId <> 0)
     THEN
         -- !!!не ошибка, здесь заявки Акции!!!
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamNext, ioId, inAmount_ParamNext);

     ELSEIF inDescId_ParamNext <> 0
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);
         --
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamNext, ioId, inAmount_ParamNext);
     END IF;

     -- сохранили свойство
     IF inDescId_ParamNextPromo = zc_MIFloat_Promo2() AND (inAmount_ParamNextPromo <> 0 OR ioId <> 0)
     THEN
         -- !!!не ошибка, здесь продажи Акции!!!
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamNextPromo, ioId, inAmount_ParamNextPromo);

     ELSEIF inDescId_ParamNextPromo <> 0
     THEN
         -- вернулись к старой схеме, за одно и проверим
         ioId:= (SELECT _tmpParentMulti.MovementItemId FROM _tmpParentMulti);
         --
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamNextPromo, ioId, inAmount_ParamNextPromo);
     END IF;

     -- сохранили протокол
     -- !!!что б росла база!!! 
     IF ioId > 0 THEN
       PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
     END IF;
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.16                                        *
 19.06.15                                        * all
 02.03.15         *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_OrderInternal_Property (ioId:= 10696633, inMovementId:= 869524, inGoodsId:= 7402,  inGoodsKindId := 8328 , inAmount:= 45::TFloat, inAmountParam:= 777::TFloat, inDescCode:= 'zc_MIFloat_AmountRemains'::TVarChar, inSession:= lpCheckRight ('5', zc_Enum_Process_InsertUpdate_MI_OrderExternal()))
