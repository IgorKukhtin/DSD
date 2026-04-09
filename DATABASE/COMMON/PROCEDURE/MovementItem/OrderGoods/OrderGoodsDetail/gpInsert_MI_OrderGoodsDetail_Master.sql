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

     -- Элементы - План + вид упаковки
     CREATE TEMP TABLE tmpMI_plan (GoodsId Integer, GoodsKindId Integer, Amount TFloat, ReceiptId Integer) ON COMMIT DROP;
     INSERT INTO tmpMI_plan (GoodsId, GoodsKindId, Amount, ReceiptId)
       SELECT MovementItem.ObjectId                 AS GoodsId
            , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
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
                   ) AS Amount
              -- найдем потом
            , 0 AS ReceiptId

       FROM MovementItem
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
            -- ШТ
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
              , MILO_GoodsKind.ObjectId
      ;


     -- нашли Receipt
     UPDATE tmpMI_plan SET ReceiptId = tmpReceipt.ReceiptId
     FROM (WITH tmpReceipt AS (SELECT tmpMI_plan.GoodsId, tmpMI_plan.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                               FROM tmpMI_plan
                                    INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                          ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_plan.GoodsId
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
                               WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_plan.GoodsKindId
                              )
             , tmpReceipt_oth AS (SELECT tmpMI_plan.GoodsId, tmpMI_plan.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                                  FROM tmpMI_plan
                                       INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                             ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_plan.GoodsId
                                                            AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                       INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                          AND Object_Receipt.isErased = FALSE
                                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                            ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                           AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
   
                                       LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_plan.GoodsId
                                                           AND tmpReceipt.GoodsKindId = tmpMI_plan.GoodsKindId

                                  WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_plan.GoodsKindId
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
     WHERE tmpMI_plan.GoodsId     = tmpReceipt.GoodsId
       AND tmpMI_plan.GoodsKindId = tmpReceipt.GoodsKindId
    ;

     -- Проверка
     IF EXISTS (SELECT 1 FROM tmpMI_plan WHERE COALESCE (tmpMI_plan.ReceiptId, 0) = 0) AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Значение рецепт не установлено <%> <%>.'
                      , lfGet_Object_ValueData ((SELECT tmpMI_plan.GoodsId FROM tmpMI_plan WHERE COALESCE (tmpMI_plan.ReceiptId, 0) = 0 ORDER BY tmpMI_plan.GoodsId, tmpMI_plan.GoodsKindId LIMIT 1))
                      , lfGet_Object_ValueData_sh ((SELECT tmpMI_plan.GoodsKindId FROM tmpMI_plan WHERE COALESCE (tmpMI_plan.ReceiptId, 0) = 0 ORDER BY tmpMI_plan.GoodsId, tmpMI_plan.GoodsKindId LIMIT 1))
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


/*RAISE EXCEPTION ' %', (select distinct tmpMI_plan.GoodsKindId from tmpMI_Master
          LEFT JOIN tmpMI_plan ON tmpMI_plan.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_plan.GoodsKindId = tmpMI_Master.GoodsKindId

     );*/


      -- удалить строки которых нет в результате
     PERFORM gpMovementItem_OrderGoodsDetail_SetErased_Master (inMovementItemId := tmpMI_Master.Id
                                                             , inSession := inSession)
     FROM tmpMI_Master
          LEFT JOIN tmpMI_plan ON tmpMI_plan.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_plan.GoodsKindId = tmpMI_Master.GoodsKindId
     WHERE tmpMI_plan.GoodsId IS NULL
    ;




     -- MI_Master - распределяем - План по видам упаковки (детализация)
     PERFORM lpInsert_MI_OrderGoodsDetail_Master(inId                       := tmpMI_Master.Id
                                               , inMovementId               := vbMovementId
                                               , inGoodsId                  := tmpMI_plan.GoodsId
                                               , inGoodsKindId              := CASE WHEN tmpMI_plan.GoodsKindId > 0 THEN tmpMI_plan.GoodsKindId ELSE zc_GoodsKind_Basis() END
                                               , inAmount                   := tmpMI_plan.Amount
                                               , inAmountForecast           := 0
                                               , inAmountForecastOrder      := 0
                                               , inAmountForecastPromo      := 0
                                               , inAmountForecastOrderPromo := 0
                                               , inUserId                   := vbUserId
                                                )
     FROM tmpMI_plan
          -- уже сохраненные - нужен Id
          LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId     = tmpMI_plan.GoodsId
                                AND tmpMI_Master.GoodsKindId = tmpMI_plan.GoodsKindId
                              --AND 1=0
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
          LEFT JOIN tmpMI_plan ON tmpMI_plan.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_plan.GoodsKindId = tmpMI_Master.GoodsKindId
          LEFT JOIN (SELECT DISTINCT tmpChildReceiptTable.ReceiptId_parent
                                   , tmpChildReceiptTable.ReceiptId
                     FROM tmpChildReceiptTable
                    ) AS tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmpMI_plan.ReceiptId
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
          LEFT JOIN tmpMI_plan ON tmpMI_plan.GoodsId     = tmpMI_Master.GoodsId
                              AND tmpMI_plan.GoodsKindId = tmpMI_Master.GoodsKindId
          LEFT JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmpMI_plan.ReceiptId
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
-- SELECT * FROM gpInsert_MI_OrderGoodsDetail_Master (inParentId := 34004540 , inOperDateStart := ('25.02.2026')::TDateTime , inOperDateEnd := ('31.03.2026')::TDateTime ,  inSession := '5');
