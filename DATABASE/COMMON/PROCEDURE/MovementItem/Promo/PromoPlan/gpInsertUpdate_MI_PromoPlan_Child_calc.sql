-- Function: gpInsertUpdate_MI_PromoPlan_Child_calc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoPlan_Child_calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoPlan_Child_calc(
    IN inMovementId            Integer   , -- Ключ объекта <Акция>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbMovementId_plan Integer;

   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());

     
    --находим док план
    vbMovementId_plan := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.DescId = zc_Movement_PromoPlan()); 
    IF COALESCE (vbMovementId_plan,0) = 0
    THEN
        --
        RAISE EXCEPTION 'Не заполнены данные План продаж';
    END IF;


    --таблица данных план, рассчитанных на основании статистики
    CREATE TEMP TABLE _tmpData (Id Integer, GoodsId Integer, GoodsKindId Integer, ReceiptId Integer, Amount TFloat, AmountPartner TFloat, OperDate TDateTime) ON COMMIT DROP;

    INSERT INTO _tmpData (Id, GoodsId, GoodsKindId, ReceiptId, Amount, AmountPartner, OperDate)
       WITH
       --данные План Продаж
       tmpMI_Master AS (SELECT MovementItem.*
                             , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                             , MIDate_OperDate.ValueData       AS OperDate
                        FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                       ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                                      AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                        WHERE MovementItem.MovementId = vbMovementId_plan
                          AND MovementItem.DescId = zc_MI_Master()
                          AND MovementItem.isErased = FALSE
                        )
     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                        AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                      )

     , tmpTermProduction AS (SELECT ObjectLink.ChildObjectId AS GoodsId
                                  , COALESCE (ObjectFloat_TermProduction.ValueData,0) AS TermProduction
                             FROM ObjectLink
                                  INNER JOIN ObjectFloat AS ObjectFloat_TermProduction
                                                         ON ObjectFloat_TermProduction.ObjectId = ObjectLink.ObjectId
                                                        AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction()
                                                        AND COALESCE (ObjectFloat_TermProduction.ValueData,0) <> 0
                             WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpMI_Master.ObjectId FROM tmpMI_Master)
                               AND ObjectLink.DescId = zc_ObjectLink_OrderType_Goods()
                             )

    --- рецептуры для tmpMI_Master
     , tmpReceipt AS (WITH 
                      tmpReceipt AS (SELECT tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                                     FROM (SELECT DISTINCT tmpMI_Master.ObjectId AS GoodsId, tmpMI_Master.GoodsKindId FROM tmpMI_Master) AS tmpMI_Master
                                          INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                                ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_Master.GoodsId
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
                                     WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_Master.GoodsKindId
                                    )
                    , tmpReceipt_oth AS (SELECT tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                                         FROM (SELECT DISTINCT tmpMI_Master.ObjectId AS GoodsId, tmpMI_Master.GoodsKindId FROM tmpMI_Master) AS tmpMI_Master
                                              INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                                    ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_Master.GoodsId
                                                                   AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                                 AND Object_Receipt.isErased = FALSE
                                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                                   ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                                  AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
          
                                              LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_Master.GoodsId
                                                                  AND tmpReceipt.GoodsKindId = tmpMI_Master.GoodsKindId
       
                                         WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_Master.GoodsKindId
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
                      )
          
          
          
          
       SELECT tmpMI_Master.Id
            , tmpMI_Master.ObjectId AS GoodsId
            , tmpMI_Master.GoodsKindId
            , tmpReceipt.ReceiptId
            , tmpMI_Master.Amount             AS Amount
            , MIFloat_AmountPartner.ValueData AS AmountPartner
            , (tmpMI_Master.OperDate - ( ''|| COALESCE (tmpTermProduction.TermProduction,0)||' DAY') ::INTERVAL ) ::TDateTime AS OperDate
       FROM tmpMI_Master
           LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                ON MIFloat_AmountPartner.MovementItemId = tmpMI_Master.Id 
                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
           LEFT JOIN tmpTermProduction ON tmpTermProduction.GoodsId = tmpMI_Master.ObjectId
           
           LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId = tmpMI_Master.ObjectId
                               AND tmpReceipt.GoodsKindId = tmpMI_Master.GoodsKindId
       ;


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
            AND lpSelect.ReceiptId IN (SELECT _tmpData.ReceiptId FROM _tmpData)
          GROUP BY lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId
                 , lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                 , lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
         ;


------------------------------------------------------------------
       -- нужно удалить сохраненные строки перед сохранением
       UPDATE MovementItem
       SET isErased = TRUE
       WHERE MovementItem.MovementId = vbMovementId_plan
         AND MovementItem.DescId = zc_MI_Child()
         AND MovementItem.IsErased = FALSE;

       --
       PERFORM lpInsertUpdate_MovementItem_PromoPlan_Child(ioId               := 0                      ::Integer   -- Ключ объекта <Элемент документа>
                                                         , inMovementId       := vbMovementId_plan      ::Integer   -- Ключ объекта <Документ>
                                                         , inParentId         := _tmpData.Id            ::Integer
                                                         , inGoodsId          := _tmpData.GoodsId       ::Integer   --
                                                         , inGoodsKindId      := _tmpData.GoodsKindId   ::Integer   --
                                                         , inReceiptId        := tmpChildReceiptTable.ReceiptId        ::Integer   --
                                                         , inReceiptId_parent := tmpChildReceiptTable.ReceiptId_parent ::Integer   --
                                                         , inOperDate         := _tmpData.OperDate      ::TDateTime --
                                                         , inAmount           := _tmpData.Amount        ::TFloat    --   zc_Branch_Basis()
                                                         , inAmountPartner    := _tmpData.AmountPartner ::TFloat    -- 
                                                         , inUserId           := vbUserId               ::Integer)
       FROM _tmpData
          LEFT JOIN (SELECT DISTINCT tmpChildReceiptTable.ReceiptId_parent
                                   , tmpChildReceiptTable.ReceiptId
                     FROM tmpChildReceiptTable
                    ) AS tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = _tmpData.ReceiptId
       ;
       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.11.21         *
*/

-- тест
--