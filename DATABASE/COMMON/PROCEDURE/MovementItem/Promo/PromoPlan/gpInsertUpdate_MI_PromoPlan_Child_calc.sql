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
    CREATE TEMP TABLE _tmpData (Id Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, AmountPartner TFloat, OperDate TDateTime) ON COMMIT DROP;

    INSERT INTO _tmpData (Id, GoodsId, GoodsKindId, Amount, AmountPartner, OperDate)
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
                               
       SELECT tmpMI_Master.Id
            , tmpMI_Master.ObjectId AS GoodsId
            , tmpMI_Master.GoodsKindId
            , tmpMI_Master.Amount             AS Amount
            , MIFloat_AmountPartner.ValueData AS AmountPartner
            , (tmpMI_Master.OperDate - ( ''|| COALESCE (tmpTermProduction.TermProduction,0)||' DAY') ::INTERVAL ) ::TDateTime AS OperDate
       FROM tmpMI_Master
           LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                ON MIFloat_AmountPartner.MovementItemId = tmpMI_Master.Id 
                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
           LEFT JOIN tmpTermProduction ON tmpTermProduction.GoodsId = tmpMI_Master.ObjectId
       ;


------------------------------------------------------------------
       -- нужно удалить сохраненные строки перед сохранением
       UPDATE MovementItem
       SET isErased = TRUE
       WHERE MovementItem.MovementId = vbMovementId_plan
         AND MovementItem.DescId = zc_MI_Child()
         AND MovementItem.IsErased = FALSE;

       --
       PERFORM lpInsertUpdate_MovementItem_PromoPlan_Child(ioId           := 0                      ::Integer   -- Ключ объекта <Элемент документа>
                                                         , inMovementId   := vbMovementId_plan      ::Integer   -- Ключ объекта <Документ>
                                                         , inParentId     := _tmpData.Id            ::Integer
                                                         , inGoodsId      := _tmpData.GoodsId       ::Integer   --
                                                         , inGoodsKindId  := _tmpData.GoodsKindId   ::Integer   --
                                                         , inOperDate     := _tmpData.OperDate      ::TDateTime --
                                                         , inAmount       := _tmpData.Amount        ::TFloat    --   zc_Branch_Basis()
                                                         , inAmountPartner:= _tmpData.AmountPartner ::TFloat    -- 
                                                         , inUserId       := vbUserId               ::Integer)
       FROM _tmpData;  
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