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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsReportSale());

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
     CREATE TEMP TABLE tmpGoodsMaster (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     INSERT INTO tmpGoodsMaster (GoodsId, Amount)
       SELECT MovementItem.ObjectId AS GoodsId
              -- Переводим в нужную Ед.изм.
            , SUM (CAST (CASE -- если это Штучный товар
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                              THEN CASE WHEN ObjectFloat_Weight.ValueData > 0 AND MovementItem.Amount > 0
                                        -- ввели ВЕС, переводим в ШТ
                                        THEN MovementItem.Amount / ObjectFloat_Weight.ValueData
                                        -- ввели ШТ
                                        ELSE MIFloat_AmountSecond.ValueData
                                   END
                              -- это Весовой товар
                              ELSE CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                        -- ввели  Вес
                                        THEN MovementItem.Amount
                                        -- ввели ШТ, переводим в ВЕС - но такого быть не может, надо сделать проверку при вводе
                                        ELSE MIFloat_AmountSecond.ValueData * COALESCE (ObjectFloat_Weight.ValueData, 1)
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
      CREATE TEMP TABLE tmpAll (GoodsId Integer, GoodsKindId Integer, AmountOrder TFloat, AmountOrderPromo TFloat, AmountSale TFloat, AmountSalePromo TFloat, Amount_calc TFloat, ReceiptId Integer) ON COMMIT DROP;
      WITH -- Список ГП
           tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                             , CASE WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                                         THEN TRUE
                                    ELSE FALSE
                               END AS isGoodsKind
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
         , tmpOrder AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId AS GoodsId
                             , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId
                               -- Статистика(заявка)  - БЕЗ акций
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount
                               -- Статистика(заявка)  - ТОЛЬКО Акции
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPromo
                        FROM (SELECT Movement.Id
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_OrderExternal()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                   -- если это Заявка с Филиала
                                   LEFT JOIN Object AS Object_From ON Object_From.Id     = MovementLinkObject_From.ObjectId
                                                                  AND Object_From.DescId = zc_Object_Unit()
      
                              WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                -- без Заявок с Филиала
                                AND Object_From.Id IS NULL
                             ) AS Movement

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId

                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                             
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                             AND tmpGoods.isGoodsKind                  = TRUE
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()

                             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                         ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                      --GROUP BY MovementItem.ObjectId
                      --       , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END
                       )
            -- Продажи - по ним и распределяем
          , tmpSale AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId AS GoodsId
                             , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId
                               -- Статистика(заявка)  - БЕЗ акций
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Amount
                               -- Статистика(заявка)  - ТОЛЬКО Акции
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPromo
                        FROM (SELECT Movement.Id
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_Sale()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                              WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                             ) AS Movement

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId

                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                             AND tmpGoods.isGoodsKind                  = TRUE
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()

                             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                         ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                      --GROUP BY MovementItem.ObjectId
                      --       , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END
                       )
         , tmpMIAll AS (-- 1.1 Заявки
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
      INSERT INTO tmpAll (GoodsId, GoodsKindId, AmountOrder, AmountOrderPromo, AmountSale, AmountSalePromo, Amount_calc, ReceiptId)
         SELECT tmpMIAll.GoodsId
              , tmpMIAll.GoodsKindId
              , SUM (tmpMIAll.AmountOrder)        AS AmountOrder
              , SUM (tmpMIAll.AmountOrderPromo)   AS AmountOrderPromo
              , SUM (tmpMIAll.AmountSale)         AS AmountSale
              , SUM (tmpMIAll.AmountSalePromo)    AS AmountSalePromo
                -- По этому значению - РАСПРЕДЕЛЯЕМ
              , SUM (tmpMIAll.AmountSale + tmpMIAll.AmountSalePromo) AS Amount_calc
                --
              , 0 AS ReceiptId

         FROM tmpMIAll
         GROUP BY tmpMIAll.GoodsId
                , tmpMIAll.GoodsKindId
         HAVING SUM (tmpMIAll.AmountOrder)      <> 0
             OR SUM (tmpMIAll.AmountOrderPromo) <> 0
             OR SUM (tmpMIAll.AmountSale)       <> 0
             OR SUM (tmpMIAll.AmountSalePromo)  <> 0
    ;
     
     -- нашли Receipt
     UPDATE tmpAll SET ReceiptId = ObjectLink_Receipt_Goods.ObjectId
     FROM ObjectLink AS ObjectLink_Receipt_Goods
          INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                             AND Object_Receipt.isErased = FALSE
          INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                   ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                  AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                  AND ObjectBoolean_Main.ValueData = TRUE
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                               ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
     WHERE ObjectLink_Receipt_Goods.ChildObjectId = tmpAll.GoodsId
       AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
       AND COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpAll.GoodsKindId
    ;


   -- Элементы - План по видам упаковки (детализация)
   CREATE TEMP TABLE tmpMI_Master (Id Integer, GoodsId Integer, GoodsKindId Integer) ON COMMIT DROP;
    INSERT INTO tmpMI_Master (Id, GoodsId, GoodsKindId)
       SELECT MovementItem.Id
            , MovementItem.ObjectId                 AS GoodsId
            , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
       FROM MovementItem
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
       WHERE MovementItem.MovementId = vbMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
      ;

   -- удаляем строки которых нет в выборке, остальные обновим
   PERFORM gpMovementItem_OrderGoodsDetail_SetErased_Master (inMovementItemId := tmpMI_Master.Id
                                                           , inSession := inSession)
   FROM tmpMI_Master
        LEFT JOIN tmpAll ON tmpAll.GoodsId = tmpMI_Master.GoodsId
                        AND tmpAll.GoodsKindId = tmpMI_Master.GoodsKindId
   WHERE tmpAll.GoodsId IS NULL;

   -- MI_Master - распределяем - План по видам упаковки (детализация)
   PERFORM lpInsert_MI_OrderGoodsDetail_Master(inId                       := tmpMI_Master.Id
                                             , inMovementId               := vbMovementId
                                             , inGoodsId                  := tmpGoodsMaster.GoodsId
                                             , inGoodsKindId              := CASE WHEN tmpAll.GoodsKindId > 0 THEN tmpAll.GoodsKindId ELSE zc_GoodsKind_Basis() END
                                             , inAmount                   := CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                  THEN
                                                                                     CAST (CASE -- есть продажи - распределяем tmpGoodsMaster
                                                                                                WHEN tmpAll_total.Amount_calc <> 0
                                                                                                     THEN tmpGoodsMaster.Amount * tmpAll.Amount_calc / tmpAll_total.Amount_calc
                                                                                                -- запишем в первый
                                                                                                WHEN tmpAll.Ord = 1
                                                                                                     THEN tmpGoodsMaster.Amount
                                                                                                ELSE 0
                                                                                           END AS NUMERIC (16,0))
                                                                                  ELSE
                                                                                     CAST (CASE -- есть продажи - распределяем
                                                                                                WHEN tmpAll_total.Amount_calc <> 0
                                                                                                     THEN tmpGoodsMaster.Amount * tmpAll.Amount_calc / tmpAll_total.Amount_calc
                                                                                                -- запишем в первый
                                                                                                WHEN tmpAll.Ord = 1
                                                                                                     THEN tmpGoodsMaster.Amount
                                                                                                ELSE 0
                                                                                           END AS NUMERIC (16,2))
                                                                                  END
                                             , inAmountForecast           := COALESCE (tmpAll.AmountSale,0)       ::TFloat
                                             , inAmountForecastOrder      := COALESCE (tmpAll.AmountOrder,0)      ::TFloat
                                             , inAmountForecastPromo      := COALESCE (tmpAll.AmountSalePromo,0)  ::TFloat
                                             , inAmountForecastOrderPromo := COALESCE (tmpAll.AmountOrderPromo,0) ::TFloat
                                             , inUserId                   := vbUserId
                                              )
   FROM tmpGoodsMaster
        -- Статистика Заявки + Продажи по видам упаковки
        LEFT JOIN (SELECT tmpAll.*
                          -- № п/п, т.к. если продаж нет - запишем в первый
                        , ROW_NUMBER() OVER (PARTITION BY tmpAll.GoodsId ORDER BY tmpAll.AmountOrder DESC, tmpAll.AmountOrderPromo DESC) AS Ord
                   FROM tmpAll
                  ) AS tmpAll ON tmpAll.GoodsId = tmpGoodsMaster.GoodsId
        -- Статистика Заявки + Продажи ИТОГО
        LEFT JOIN (SELECT tmpAll.GoodsId, SUM (tmpAll.Amount_calc) AS Amount_calc FROM tmpAll GROUP BY tmpAll.GoodsId
                  ) AS tmpAll_total ON tmpAll_total.GoodsId = tmpGoodsMaster.GoodsId
        -- уже сохраненные - поиск Id
        LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId     = tmpAll.GoodsId
                              AND tmpMI_Master.GoodsKindId = tmpAll.GoodsKindId
        -- округление для ШТ.
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = tmpGoodsMaster.GoodsId
                            AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
       ;



     -- ВСЕ рецептуры
     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer, isCost Boolean
                                            ) ON COMMIT DROP;
     -- ВСЕ рецептуры
     INSERT INTO tmpChildReceiptTable (ReceiptId_parent, ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, Amount_out_start, isStart, isCost
                                      )
          SELECT lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , 0 AS ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
               , SUM (lpSelect.Amount_out) AS Amount_out
               , SUM (CASE WHEN lpSelect.isStart = TRUE THEN lpSelect.Amount_out ELSE 0 END) AS Amount_out_start
               , MAX (CASE WHEN lpSelect.isStart = TRUE THEN 1 ELSE 0 END) AS isStart
               , lpSelect.isCost
          FROM lpSelect_Object_ReceiptChildDetail (TRUE) AS lpSelect
          WHERE lpSelect.isCost = FALSE
          GROUP BY lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId
                 , lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                 , lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
                 -- , lpSelect.isStart
                 , lpSelect.isCost
         ;
         
     -- сохранили связь с Receipt
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      MovementItem.Id, tmpChildReceiptTable.ReceiptId)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), MovementItem.Id, tmpChildReceiptTable.ReceiptId_parent)
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                           ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          LEFT JOIN tmpAll ON tmpAll.GoodsId     = MovementItem.ObjectId
                          AND tmpAll.GoodsKindId = COALESCE (MILO_GoodsKind.ObjectId, 0)
          LEFT JOIN (SELECT DISTINCT tmpChildReceiptTable.ReceiptId_parent
                                   , tmpChildReceiptTable.ReceiptId
                                   , tmpChildReceiptTable.GoodsId_in
                     FROM tmpChildReceiptTable
                    ) AS tmpChildReceiptTable ON tmpChildReceiptTable.GoodsId_in = MovementItem.ObjectId
                                             AND tmpChildReceiptTable.ReceiptId  = tmpAll.ReceiptId
     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
    ;

     -- удаляем ВСЕ zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE
   ;
     

     -- сохранили zc_MI_Child
     PERFORM lpInsert_MI_OrderGoodsDetail_Child (inId         := 0
                                               , inMovementId := vbMovementId
                                               , inParentId   := MovementItem.Id
                                               , inGoodsId    := tmpChildReceiptTable.GoodsId_out
                                               , inGoodsKindId:= tmpChildReceiptTable.GoodsKindId_out
                                               , inAmount     := CASE WHEN tmpChildReceiptTable.Amount_in > 0 THEN MovementItem.Amount * tmpChildReceiptTable.Amount_out / tmpChildReceiptTable.Amount_in ELSE 0 END
                                               , inUserId     := vbUserId
                                                )
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                           ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          LEFT JOIN tmpAll ON tmpAll.GoodsId     = MovementItem.ObjectId
                          AND tmpAll.GoodsKindId = COALESCE (MILO_GoodsKind.ObjectId, 0)
          LEFT JOIN tmpChildReceiptTable ON tmpChildReceiptTable.GoodsId_in = MovementItem.ObjectId
                                        AND tmpChildReceiptTable.ReceiptId   = tmpAll.ReceiptId
     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
   ;

     -- удаляем НУЛИ в zc_MI_Master + zc_MI_Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = vbMovementId
     --AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE
       AND MovementItem.Amount     = 0
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
-- select * from gpInsert_MI_OrderGoodsDetail_Master(inParentId := 20242962 , inOperDateStart := ('28.07.2021')::TDateTime , inOperDateEnd := ('31.08.2021')::TDateTime ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
