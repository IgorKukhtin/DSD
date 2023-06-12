-- Function: gpInsert_MI_OrderGoodsDetail_Master()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderGoodsDetail_Master (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderGoodsDetail_Master(
    IN inParentId             Integer  , -- ключ Документа OrderGoods
    IN inOperDateStart        TDateTime, --
    IN inOperDateEnd          TDateTime, --
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderGoods());
     
-- if vbUserId <> 5 THEN  RAISE EXCEPTION 'Повторите действие через 15 мин.';end if;



     --пробуем найти сохраненный док.
     vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());
     -- перезаписываем даты или записываем новый док , елси не было
     vbMovementId := lpInsertUpdate_Movement_OrderGoodsDetail (ioId            := vbMovementId
                                                             , inParentId      := inParentId   -- ключ Документа OrderGoods
                                                             , inOperDate      := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inParentId)
                                                             , inOperDateStart := inOperDateStart
                                                             , inOperDateEnd   := inOperDateEnd
                                                             , inUserId        := vbUserId
                                                              );

     -- Элементы - План без вида упаковки
     CREATE TEMP TABLE tmpMI_plan (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     INSERT INTO tmpMI_plan (GoodsId, Amount)
       SELECT MovementItem.ObjectId AS GoodsId
              -- Переводим в нужную Ед.изм.
            , SUM (CAST (CASE -- если это Штучный товар
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                              THEN CASE WHEN ObjectFloat_Weight.ValueData > 0 AND MovementItem.Amount > 0
                                        -- ввели ВЕС, переводим в ШТ
                                        THEN MovementItem.Amount / ObjectFloat_Weight.ValueData
                                        -- ввели ШТ
                                        ELSE COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                   END
                              -- это Весовой товар
                              ELSE CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                        -- ввели  Вес
                                        THEN MovementItem.Amount
                                        -- ввели ШТ, переводим в ВЕС - но такого быть не может, надо сделать проверку при вводе
                                        ELSE COALESCE (MIFloat_AmountSecond.ValueData, 0) * COALESCE (ObjectFloat_Weight.ValueData, 1)
                                   END
                         END AS NUMERIC (16,0))
                   )AS Amount
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
       WHERE MovementItem.MovementId = inParentId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
      ;

     -- Статистика Заявки + Продажи
     CREATE TEMP TABLE tmpMI_stat (GoodsId Integer, GoodsKindId Integer, AmountOrder TFloat, AmountOrderPromo TFloat, AmountSale TFloat, AmountSalePromo TFloat, Amount_calc TFloat, ReceiptId Integer) ON COMMIT DROP;
     --
     WITH -- Список ГП - определился isGoodsKind
          tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                            , CASE WHEN Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Готовая продукция
                                     OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                        THEN TRUE
                                   ELSE FALSE
                              END AS isGoodsKind
                            , Object_InfoMoney_View.InfoMoneyId
                       FROM Object_InfoMoney_View
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       WHERE (Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция + Готовая продукция and Тушенка and Хлеб
                           OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                         --OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье : запечена...
                             )
                      )
         -- Заявки - информативно
      /*, tmpMovOrder AS (SELECT Movement.Id AS MovementId
                          FROM MovementDate AS MD_OperDatePartner
                               INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                  AND Movement.DescId   = zc_Movement_OrderExternal()
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId         = zc_MovementLinkObject_From()
                               -- если это Заявка с Филиала
                               LEFT JOIN Object AS Object_From ON Object_From.Id     = MovementLinkObject_From.ObjectId
                                                              AND Object_From.DescId = zc_Object_Unit()
                          WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                            AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                            -- без Заявок с Филиала
                            AND Object_From.Id IS NULL
                            --AND 1=0
                         )*/
        , tmpMovOrder AS (SELECT Movement.Id AS MovementId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId         = zc_MovementLinkObject_From()
                               -- если это Заявка с Филиала
                               LEFT JOIN Object AS Object_From ON Object_From.Id     = MovementLinkObject_From.ObjectId
                                                              AND Object_From.DescId = zc_Object_Unit()
                          WHERE Movement.OperDate BETWEEN inOperDateStart AND inOperDateEnd
                            AND Movement.DescId   = zc_Movement_OrderExternal()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            -- без Заявок с Филиала
                            AND Object_From.Id IS NULL
                            --AND 1=0
                         )
     , tmpMIOrder_all AS (SELECT MovementItem.*
                          FROM MovementItem 
                          WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovOrder.MovementId FROM tmpMovOrder)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
         , tmpMIOrder AS (SELECT tmpMIOrder_all.*
                          FROM tmpMIOrder_all
                               INNER JOIN tmpMI_plan ON tmpMI_plan.GoodsId = tmpMIOrder_all.ObjectId
                         )
       , tmpMIFloat_o AS (SELECT MovementItemFloat.*
                           FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIOrder.Id FROM tmpMIOrder)
                         )
          , tmpMILO_o AS (SELECT MovementItemLinkObject.*
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIOrder.Id FROM tmpMIOrder)
                            AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )
        , tmpOrder AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId AS GoodsId
                            , CASE WHEN tmpGoods.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Тушенка
                                        THEN zc_GoodsKind_Basis()
                                   WHEN tmpGoods.isGoodsKind = TRUE
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                                   ELSE 0
                              END AS GoodsKindId
                              -- Статистика(заявка)  - БЕЗ акций
                            , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount
                              -- Статистика(заявка)  - ТОЛЬКО Акции
                            , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPromo
                       FROM tmpMovOrder
                            INNER JOIN tmpMIOrder AS MovementItem
                                                  ON MovementItem.MovementId = tmpMovOrder.MovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                          --INNER JOIN tmpMI_plan ON tmpMI_plan.GoodsId = MovementItem.ObjectId

                            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                            LEFT JOIN tmpMILO_o AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                               AND tmpGoods.isGoodsKind                  = TRUE
                            LEFT JOIN tmpMIFloat_o AS MIFloat_AmountSecond
                                                   ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()

                            LEFT JOIN tmpMIFloat_o AS MIFloat_PromoMovementId
                                                   ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                     --GROUP BY MovementItem.ObjectId
                     --       , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END
                      )
           -- Продажи - по ним и распределяем
         , tmpMovSale AS (SELECT Movement.Id AS MovementId
                          FROM MovementDate AS MD_OperDatePartner
                               INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                  AND Movement.DescId   = zc_Movement_Sale()
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                          WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                            AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                         )
      , tmpMISale_all AS (SELECT MovementItem.*
                          FROM MovementItem
                          WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovSale.MovementId FROM tmpMovSale)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
          , tmpMISale AS (SELECT tmpMISale_all.*
                          FROM tmpMISale_all
                               INNER JOIN tmpMI_plan ON tmpMI_plan.GoodsId = tmpMISale_all.ObjectId
                         )
         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMISale.Id FROM tmpMISale)
                         )
            , tmpMILO AS (SELECT MovementItemLinkObject.*
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMISale.Id FROM tmpMISale)
                            AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )
         , tmpSale AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId AS GoodsId
                            , CASE WHEN tmpGoods.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Тушенка
                                        THEN zc_GoodsKind_Basis()
                                   WHEN tmpGoods.isGoodsKind = TRUE
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                                   ELSE 0
                              END AS GoodsKindId
                              -- Статистика(заявка)  - БЕЗ акций
                            , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Amount
                              -- Статистика(заявка)  - ТОЛЬКО Акции
                            , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPromo
                       FROM tmpMovSale
                            INNER JOIN tmpMISale AS MovementItem
                                                 ON MovementItem.MovementId = tmpMovSale.MovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                          --INNER JOIN tmpMI_plan ON tmpMI_plan.GoodsId = MovementItem.ObjectId

                            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                             AND tmpGoods.isGoodsKind                  = TRUE
                            LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()

                            LEFT JOIN tmpMIFloat AS MIFloat_PromoMovementId
                                                 ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                     --GROUP BY MovementItem.ObjectId
                     --       , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END
                      )
        , tmpMI_all AS (-- 1.1 Заявки
                       SELECT tmpOrder.GoodsId
                            , tmpOrder.GoodsKindId
                            , SUM (tmpOrder.Amount)      AS AmountOrder
                            , SUM (tmpOrder.AmountPromo) AS AmountOrderPromo
                            , 0                          AS AmountSale
                            , 0                          AS AmountSalePromo
                       FROM tmpOrder
                       WHERE tmpOrder.Amount > 0 OR tmpOrder.AmountPromo > 0
                       GROUP BY tmpOrder.GoodsId
                              , tmpOrder.GoodsKindId

                      UNION ALL
                       -- 1.2 Продажи
                       SELECT tmpSale.GoodsId
                            , tmpSale.GoodsKindId
                            , 0                         AS AmountOrder
                            , 0                         AS AmountOrderPromo
                            , SUM (tmpSale.Amount)      AS AmountSale
                            , SUM (tmpSale.AmountPromo) AS AmountSalePromo
                       FROM tmpSale
                       WHERE tmpSale.Amount > 0 OR tmpSale.AmountPromo > 0
                       GROUP BY tmpSale.GoodsId
                              , tmpSale.GoodsKindId
                      )
     -- Результат - Статистика Заявки + Продажи
     INSERT INTO tmpMI_stat (GoodsId, GoodsKindId, AmountOrder, AmountOrderPromo, AmountSale, AmountSalePromo, Amount_calc, ReceiptId)
        SELECT tmpMI_all.GoodsId
             , tmpMI_all.GoodsKindId
             , SUM (tmpMI_all.AmountOrder)        AS AmountOrder
             , SUM (tmpMI_all.AmountOrderPromo)   AS AmountOrderPromo
             , SUM (tmpMI_all.AmountSale)         AS AmountSale
             , SUM (tmpMI_all.AmountSalePromo)    AS AmountSalePromo
               -- По этому значению - РАСПРЕДЕЛЯЕМ
             , SUM (tmpMI_all.AmountSale + tmpMI_all.AmountSalePromo) AS Amount_calc
               --
             , 0 AS ReceiptId

        FROM tmpMI_all
        GROUP BY tmpMI_all.GoodsId
               , tmpMI_all.GoodsKindId
        HAVING SUM (tmpMI_all.AmountOrder)      <> 0
            OR SUM (tmpMI_all.AmountOrderPromo) <> 0
            OR SUM (tmpMI_all.AmountSale)       <> 0
            OR SUM (tmpMI_all.AmountSalePromo)  <> 0
    ;

-- RAISE EXCEPTION 'end ';
-- RAISE EXCEPTION ' %', (select sum(AmountOrder +  AmountOrderPromo) from tmpMI_stat where tmpMI_stat.GoodsId = );


     -- нашли Receipt
     UPDATE tmpMI_stat SET ReceiptId = tmpReceipt.ReceiptId
     FROM (WITH tmpReceipt AS (SELECT tmpMI_stat.GoodsId, tmpMI_stat.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                               FROM tmpMI_stat
                                    INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                          ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_stat.GoodsId
                                                         AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                    INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                       AND Object_Receipt.isErased = FALSE
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                             ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                                            AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                                            AND ObjectBoolean_Main.ValueData = TRUE
                                    LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                         ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                        AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                               WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_stat.GoodsKindId
                              )
             , tmpReceipt_oth AS (SELECT tmpMI_stat.GoodsId, tmpMI_stat.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                                  FROM tmpMI_stat
                                       INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                             ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_stat.GoodsId
                                                            AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                       INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                          AND Object_Receipt.isErased = FALSE
                                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                            ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                           AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
   
                                       LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_stat.GoodsId
                                                           AND tmpReceipt.GoodsKindId = tmpMI_stat.GoodsKindId

                                  WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_stat.GoodsKindId
                                       -- если не нашли Receipt_Main = TRUE
                                       AND tmpReceipt.GoodsId IS NULL
                                 )
           -- Главные
           SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId FROM tmpReceipt
          UNION ALL
           -- Если НЕ главная и только одна
           SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
           FROM tmpReceipt_oth AS tmpReceipt
           WHERE tmpReceipt.ReceiptId IN (SELECT tmpReceipt_oth.ReceiptId FROM tmpReceipt_oth GROUP BY tmpReceipt_oth.ReceiptId HAVING COUNT(*) = 1)
          ) AS tmpReceipt
     WHERE tmpMI_stat.GoodsId     = tmpReceipt.GoodsId
       AND tmpMI_stat.GoodsKindId = tmpReceipt.GoodsKindId
    ;

     -- Проверка
     IF EXISTS (SELECT 1 FROM tmpMI_stat WHERE COALESCE (tmpMI_stat.ReceiptId, 0) = 0) AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение рецепт не установлено <%> <%>.'
                      , lfGet_Object_ValueData ((SELECT tmpMI_stat.GoodsId FROM tmpMI_stat WHERE COALESCE (tmpMI_stat.ReceiptId, 0) = 0 ORDER BY tmpMI_stat.GoodsId, tmpMI_stat.GoodsKindId LIMIT 1))
                      , lfGet_Object_ValueData_sh ((SELECT tmpMI_stat.GoodsKindId FROM tmpMI_stat WHERE COALESCE (tmpMI_stat.ReceiptId, 0) = 0 ORDER BY tmpMI_stat.GoodsId, tmpMI_stat.GoodsKindId LIMIT 1))
                       ;
     END IF;

     -- Элементы - План по видам упаковки (детализация)
     CREATE TEMP TABLE tmpMI_Master (Id Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
      INSERT INTO tmpMI_Master (Id, GoodsId, GoodsKindId, Amount)
         SELECT MovementItem.Id
              , MovementItem.ObjectId                 AS GoodsId
              , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
              , MovementItem.Amount
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                               ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
         WHERE MovementItem.MovementId = vbMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
        ;


/*RAISE EXCEPTION ' %', (select distinct tmpMI_stat.GoodsKindId from tmpMI_Master
          LEFT JOIN tmpMI_stat ON tmpMI_stat.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_stat.GoodsKindId = tmpMI_Master.GoodsKindId

     );*/


      -- удалить строки которых нет в результате
     PERFORM gpMovementItem_OrderGoodsDetail_SetErased_Master (inMovementItemId := tmpMI_Master.Id
                                                             , inSession := inSession)
     FROM tmpMI_Master
          LEFT JOIN tmpMI_stat ON tmpMI_stat.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_stat.GoodsKindId = tmpMI_Master.GoodsKindId
     WHERE tmpMI_stat.GoodsId IS NULL
    ;



     IF EXISTS (SELECT 1
                FROM tmpMI_plan
                     -- Статистика Заявки + Продажи по видам упаковки
                     LEFT JOIN (SELECT tmpMI_stat.*
                                       -- № п/п, т.к. если продаж нет - запишем в первый
                                     , ROW_NUMBER() OVER (PARTITION BY tmpMI_stat.GoodsId ORDER BY tmpMI_stat.AmountOrder DESC, tmpMI_stat.AmountOrderPromo DESC) AS Ord
                                FROM tmpMI_stat
                                ORDER BY tmpMI_stat.AmountSale DESC
                              --LIMIT 1
                               ) AS tmpMI_stat ON tmpMI_stat.GoodsId = tmpMI_plan.GoodsId
                     -- Статистика Заявки + Продажи ИТОГО
                     LEFT JOIN (SELECT tmpMI_stat.GoodsId, SUM (tmpMI_stat.Amount_calc) AS Amount_calc FROM tmpMI_stat GROUP BY tmpMI_stat.GoodsId
                               ) AS tmpMI_stat_total ON tmpMI_stat_total.GoodsId = tmpMI_plan.GoodsId
                     -- уже сохраненные - нужен Id
                     LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId     = tmpMI_stat.GoodsId
                                           AND tmpMI_Master.GoodsKindId = tmpMI_stat.GoodsKindId
                                         --AND 1=0
                     -- округление для ШТ.
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                          ON ObjectLink_Goods_Measure.ObjectId = tmpMI_plan.GoodsId
                                         AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                WHERE CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                           THEN
                              CAST (CASE -- есть продажи - распределяем tmpMI_plan
                                         WHEN tmpMI_stat_total.Amount_calc <> 0
                                              THEN tmpMI_plan.Amount * tmpMI_stat.Amount_calc / tmpMI_stat_total.Amount_calc
                                         -- запишем в первый
                                         WHEN tmpMI_stat.Ord = 1
                                              THEN tmpMI_plan.Amount
                                         ELSE 0
                                    END AS NUMERIC (16,0))
                           ELSE
                              CAST (CASE -- есть продажи - распределяем
                                         WHEN tmpMI_stat_total.Amount_calc <> 0
                                              THEN tmpMI_plan.Amount * tmpMI_stat.Amount_calc / tmpMI_stat_total.Amount_calc
                                         -- запишем в первый
                                         WHEN tmpMI_stat.Ord = 1
                                              THEN tmpMI_plan.Amount
                                         ELSE 0
                                    END AS NUMERIC (16,2))
                      END IS NULL)
     THEN
         RAISE EXCEPTION 'Ошибка. Пустое расчетное значение для <%>.'
                       , (SELECT lfGet_Object_ValueData (tmpMI_plan.GoodsId) || '  ' || lfGet_Object_ValueData_sh (CASE WHEN tmpMI_stat.GoodsKindId > 0 THEN tmpMI_stat.GoodsKindId ELSE zc_GoodsKind_Basis() END)
                          FROM tmpMI_plan
                               -- Статистика Заявки + Продажи по видам упаковки
                               LEFT JOIN (SELECT tmpMI_stat.*
                                                 -- № п/п, т.к. если продаж нет - запишем в первый
                                               , ROW_NUMBER() OVER (PARTITION BY tmpMI_stat.GoodsId ORDER BY tmpMI_stat.AmountOrder DESC, tmpMI_stat.AmountOrderPromo DESC) AS Ord
                                          FROM tmpMI_stat
                                          ORDER BY tmpMI_stat.AmountSale DESC
                                        --LIMIT 1
                                         ) AS tmpMI_stat ON tmpMI_stat.GoodsId = tmpMI_plan.GoodsId
                               -- Статистика Заявки + Продажи ИТОГО
                               LEFT JOIN (SELECT tmpMI_stat.GoodsId, SUM (tmpMI_stat.Amount_calc) AS Amount_calc FROM tmpMI_stat GROUP BY tmpMI_stat.GoodsId
                                         ) AS tmpMI_stat_total ON tmpMI_stat_total.GoodsId = tmpMI_plan.GoodsId
                               -- уже сохраненные - нужен Id
                               LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId     = tmpMI_stat.GoodsId
                                                     AND tmpMI_Master.GoodsKindId = tmpMI_stat.GoodsKindId
                                                   --AND 1=0
                               -- округление для ШТ.
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                    ON ObjectLink_Goods_Measure.ObjectId = tmpMI_plan.GoodsId
                                                   AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                          WHERE CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                     THEN
                                        CAST (CASE -- есть продажи - распределяем tmpMI_plan
                                                   WHEN tmpMI_stat_total.Amount_calc <> 0
                                                        THEN tmpMI_plan.Amount * tmpMI_stat.Amount_calc / tmpMI_stat_total.Amount_calc
                                                   -- запишем в первый
                                                   WHEN tmpMI_stat.Ord = 1
                                                        THEN tmpMI_plan.Amount
                                                   ELSE 0
                                              END AS NUMERIC (16,0))
                                     ELSE
                                        CAST (CASE -- есть продажи - распределяем
                                                   WHEN tmpMI_stat_total.Amount_calc <> 0
                                                        THEN tmpMI_plan.Amount * tmpMI_stat.Amount_calc / tmpMI_stat_total.Amount_calc
                                                   -- запишем в первый
                                                   WHEN tmpMI_stat.Ord = 1
                                                        THEN tmpMI_plan.Amount
                                                   ELSE 0
                                              END AS NUMERIC (16,2))
                                END IS NULL
                          LIMIT 1
                         );
     END IF;


     -- MI_Master - распределяем - План по видам упаковки (детализация)
     PERFORM lpInsert_MI_OrderGoodsDetail_Master(inId                       := tmpMI_Master.Id
                                               , inMovementId               := vbMovementId
                                               , inGoodsId                  := tmpMI_plan.GoodsId
                                               , inGoodsKindId              := CASE WHEN tmpMI_stat.GoodsKindId > 0 THEN tmpMI_stat.GoodsKindId ELSE zc_GoodsKind_Basis() END
                                               , inAmount                   := CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                    THEN
                                                                                       CAST (CASE -- есть продажи - распределяем tmpMI_plan
                                                                                                  WHEN tmpMI_stat_total.Amount_calc <> 0
                                                                                                       THEN tmpMI_plan.Amount * tmpMI_stat.Amount_calc / tmpMI_stat_total.Amount_calc
                                                                                                  -- запишем в первый
                                                                                                  WHEN tmpMI_stat.Ord = 1
                                                                                                       THEN tmpMI_plan.Amount
                                                                                                  ELSE 0
                                                                                             END AS NUMERIC (16,0))
                                                                                    ELSE
                                                                                       CAST (CASE -- есть продажи - распределяем
                                                                                                  WHEN tmpMI_stat_total.Amount_calc <> 0
                                                                                                       THEN tmpMI_plan.Amount * tmpMI_stat.Amount_calc / tmpMI_stat_total.Amount_calc
                                                                                                  -- запишем в первый
                                                                                                  WHEN tmpMI_stat.Ord = 1
                                                                                                       THEN tmpMI_plan.Amount
                                                                                                  ELSE 0
                                                                                             END AS NUMERIC (16,2))
                                                                               END
                                               , inAmountForecast           := COALESCE (tmpMI_stat.AmountSale,0)       ::TFloat
                                               , inAmountForecastOrder      := COALESCE (tmpMI_stat.AmountOrder,0)      ::TFloat
                                               , inAmountForecastPromo      := COALESCE (tmpMI_stat.AmountSalePromo,0)  ::TFloat
                                               , inAmountForecastOrderPromo := COALESCE (tmpMI_stat.AmountOrderPromo,0) ::TFloat
                                               , inUserId                   := vbUserId
                                                )
     FROM tmpMI_plan
          -- Статистика Заявки + Продажи по видам упаковки
          LEFT JOIN (SELECT tmpMI_stat.*
                            -- № п/п, т.к. если продаж нет - запишем в первый
                          , ROW_NUMBER() OVER (PARTITION BY tmpMI_stat.GoodsId ORDER BY tmpMI_stat.AmountOrder DESC, tmpMI_stat.AmountOrderPromo DESC) AS Ord
                     FROM tmpMI_stat
                     ORDER BY tmpMI_stat.AmountSale DESC
                   --LIMIT 1
                    ) AS tmpMI_stat ON tmpMI_stat.GoodsId = tmpMI_plan.GoodsId
          -- Статистика Заявки + Продажи ИТОГО
          LEFT JOIN (SELECT tmpMI_stat.GoodsId, SUM (tmpMI_stat.Amount_calc) AS Amount_calc FROM tmpMI_stat GROUP BY tmpMI_stat.GoodsId
                    ) AS tmpMI_stat_total ON tmpMI_stat_total.GoodsId = tmpMI_plan.GoodsId
          -- уже сохраненные - нужен Id
          LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId     = tmpMI_stat.GoodsId
                                AND tmpMI_Master.GoodsKindId = tmpMI_stat.GoodsKindId
                              --AND 1=0
          -- округление для ШТ.
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = tmpMI_plan.GoodsId
                              AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
    ;

     -- еще раз - Элементы - План по видам упаковки (детализация)
     DELETE FROM tmpMI_Master;
     INSERT INTO tmpMI_Master (Id, GoodsId, GoodsKindId, Amount)
        SELECT MovementItem.Id
             , MovementItem.ObjectId                 AS GoodsId
             , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
             , MovementItem.Amount
        FROM MovementItem
             LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                              ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
        WHERE MovementItem.MovementId = vbMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
       ;

     -- Проверка
     IF EXISTS (SELECT 1 FROM tmpMI_Master GROUP BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка.Дублирование заблокировано <%> <%>.'
                      , lfGet_Object_ValueData ((SELECT tmpMI_Master.GoodsId
                                                 FROM tmpMI_Master GROUP BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId HAVING COUNT(*) > 1
                                                 ORDER BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId
                                                 LIMIT 1
                                               ))
                      , lfGet_Object_ValueData_sh ((SELECT tmpMI_Master.GoodsKindId
                                                    FROM tmpMI_Master GROUP BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId HAVING COUNT(*) > 1
                                                    ORDER BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId
                                                    LIMIT 1
                                                  ))
                 ;
     END IF;


     -- ВСЕ рецептуры
     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer
                                            ) ON COMMIT DROP;
     -- ВСЕ рецептуры
     INSERT INTO tmpChildReceiptTable (ReceiptId_parent, ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, Amount_out_start, isStart
                                      )
          SELECT lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , 0 AS ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
               , SUM (lpSelect.Amount_out) AS Amount_out
               , SUM (CASE WHEN lpSelect.isStart = TRUE THEN lpSelect.Amount_out ELSE 0 END) AS Amount_out_start
               , MAX (CASE WHEN lpSelect.isStart = TRUE THEN 1 ELSE 0 END) AS isStart
          FROM lpSelect_Object_ReceiptChildDetail (TRUE) AS lpSelect
          WHERE lpSelect.isCost = FALSE AND lpSelect.ReceiptId_from = 0
          GROUP BY lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId
                 , lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                 , lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
                 -- , lpSelect.isStart
         ;

     -- сохранили связь с Receipt
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      tmpMI_Master.Id, tmpChildReceiptTable.ReceiptId)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), tmpMI_Master.Id, tmpChildReceiptTable.ReceiptId_parent)
     FROM tmpMI_Master
          LEFT JOIN tmpMI_stat ON tmpMI_stat.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_stat.GoodsKindId = tmpMI_Master.GoodsKindId
          LEFT JOIN (SELECT DISTINCT tmpChildReceiptTable.ReceiptId_parent
                                   , tmpChildReceiptTable.ReceiptId
                     FROM tmpChildReceiptTable
                    ) AS tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmpMI_stat.ReceiptId
    ;

     -- zc_MI_Child - Элементы - План по видам упаковки (детализация)
     CREATE TEMP TABLE tmpMI_Child (Id Integer, Amount TFloat) ON COMMIT DROP;
      INSERT INTO tmpMI_Child (Id, Amount)
         SELECT MovementItem.Id, MovementItem.Amount
         FROM MovementItem
         WHERE MovementItem.MovementId = vbMovementId
           AND MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.isErased   = FALSE
        ;

     -- удаляем ВСЕ zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= tmpMI_Child.Id, inUserId:= vbUserId)
     FROM tmpMI_Child
    ;

     -- сохранили zc_MI_Child
     PERFORM lpInsert_MI_OrderGoodsDetail_Child (inId         := 0
                                               , inMovementId := vbMovementId
                                               , inParentId   := tmpMI_Master.Id
                                               , inGoodsId    := tmpChildReceiptTable.GoodsId_out
                                               , inGoodsKindId:= tmpChildReceiptTable.GoodsKindId_out
                                               , inAmount     := CASE WHEN tmpChildReceiptTable.Amount_in > 0 THEN tmpMI_Master.Amount * tmpChildReceiptTable.Amount_out / tmpChildReceiptTable.Amount_in ELSE 0 END
                                               , inUserId     := vbUserId
                                                )
     FROM tmpMI_Master
          LEFT JOIN tmpMI_stat ON tmpMI_stat.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_stat.GoodsKindId = tmpMI_Master.GoodsKindId
          LEFT JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmpMI_stat.ReceiptId
    ;


     -- еще раз - zc_MI_Child - Элементы - План по видам упаковки (детализация)
     DELETE FROM tmpMI_Child;
     INSERT INTO tmpMI_Child (Id, Amount)
        SELECT MovementItem.Id, MovementItem.Amount
        FROM MovementItem
        WHERE MovementItem.MovementId = vbMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
       ;

     -- удаляем НУЛИ в zc_MI_Master + zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= tmpMI.Id, inUserId:= vbUserId)
     FROM (SELECT tmpMI_Master.Id FROM tmpMI_Master WHERE tmpMI_Master.Amount = 0
          UNION
           SELECT tmpMI_Child.Id  FROM tmpMI_Child  WHERE tmpMI_Child.Amount  = 0
          ) AS tmpMI
    ;

 --RAISE EXCEPTION 'end ';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
-- SELECT * FROM gpInsert_MI_OrderGoodsDetail_Master (inParentId := 21114328 , inOperDateStart := ('28.07.2021')::TDateTime , inOperDateEnd := ('31.08.2021')::TDateTime ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
-- SELECT * FROM gpInsert_MI_OrderGoodsDetail_Master (inParentId := 20228197 , inOperDateStart := ('27.05.2021')::TDateTime , inOperDateEnd := ('30.06.2021')::TDateTime ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
