-- Function: gpInsert_Movement_OrderInternal_byPromoChild()

DROP FUNCTION IF EXISTS gpInsert_Movement_OrderInternal_byPromoChild (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_Movement_OrderInternal_byPromoChild(
    IN inMovementId           Integer    , -- главый документ  Заявки внутренние(маркет-товары)
    IN inSession              TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbOperDate  TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    SELECT Movement.OperDate
  INTO vbOperDate
    FROM Movement 
    WHERE Movement.Id = inMovementId;
     
    -- Cуществующие документы заказов, Непроведенные и не сохраненные
     CREATE TEMP TABLE tmpMovement_OrderInternal (Id Integer, UnitId Integer) ON COMMIT DROP;
       INSERT INTO tmpMovement_OrderInternal (Id, UnitId)
       SELECT Movement.Id
            , MovementLinkObject_Unit.ObjectId AS UnitId
       FROM MovementLinkMovement AS MLM_Master
            INNER JOIN Movement ON Movement.Id = MLM_Master.MovementId
                               AND Movement.DescId = zc_Movement_OrderInternal()
                               AND Movement.StatusId = zc_Enum_Status_UnComplete()
            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId = Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()
                                                                    
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE MLM_Master.DescId = zc_MovementLinkMovement_Master()
         AND MLM_Master.MovementChildId = inMovementId
         AND COALESCE(MovementBoolean_Document.ValueData, FALSE) = FALSE;

    -- Cуществующие чайлд
     CREATE TEMP TABLE tmpMI_Child (UnitId Integer, GoodsId Integer, MovementId_OrderInternal Integer, Amount Integer, Price TFloat) ON COMMIT DROP;
       INSERT INTO tmpMI_Child (UnitId, GoodsId, MovementId_OrderInternal, Amount, Price)
       WITH 
       tmpMI_Master AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId            AS GoodsId
                             , MIFloat_Price.ValueData ::TFloat AS Price
                        FROM MovementItem
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Master()
                          AND COALESCE (MovementItem.Amount,0) > 0
                          AND MovementItem.isErased = FALSE
                       )

       SELECT MovementItem.ObjectId AS UnitId
            , tmpMI_Master.GoodsId  AS GoodsId
            , tmpMovement_OrderInternal.Id        AS MovementId_OrderInternal
            , (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountManual.ValueData,0)) AS Amount
            , tmpMI_Master.Price    AS Price
       FROM MovementItem
            LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = MovementItem.ParentId
            LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                        ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
            LEFT JOIN tmpMovement_OrderInternal ON tmpMovement_OrderInternal.UnitId = MovementItem.ObjectId
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Child()
         AND (COALESCE (MovementItem.Amount,0) <> 0 OR COALESCE (MIFloat_AmountManual.ValueData,0) <> 0);


       -- Сохраняем новыее Документы OrderInternal
       PERFORM lpInsert_Movement_OrderInternal (ioId          := 0
                                              , inInvNumber   := CAST (NEXTVAL ('movement_OrderInternal_seq') AS TVarChar)
                                              , inOperDate    := vbOperDate
                                              , inUnitId      := tmp.UnitId
                                              , inOrderKindId := 0
                                              , inMasterId    := inMovementId
                                              , inUserId      := vbUserId)
       FROM (SELECT DISTINCT tmpMI_Child.UnitId
             FROM tmpMI_Child
             WHERE COALESCE (tmpMI_Child.MovementId_OrderInternal,0) = 0
             ) AS tmp
       ;
       
       -- довыбираем вновь созданные документы
       INSERT INTO tmpMovement_OrderInternal (Id, UnitId)
       SELECT Movement.Id
            , MovementLinkObject_Unit.ObjectId      AS UnitId
       FROM MovementLinkMovement AS MLM_Master
            INNER JOIN Movement ON Movement.Id = MLM_Master.MovementId
                               AND Movement.DescId = zc_Movement_OrderInternal()
                               AND Movement.StatusId = zc_Enum_Status_UnComplete()
            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId = Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE MLM_Master.DescId = zc_MovementLinkMovement_Master()
         AND MLM_Master.MovementChildId = inMovementId
         AND COALESCE(MovementBoolean_Document.ValueData, FALSE) = FALSE
         AND Movement.Id NOT IN (SELECT tmpMovement_OrderInternal.Id FROM tmpMovement_OrderInternal);
         
       -- теперь выбираем строки документов заказов. которые уже есть
      CREATE TEMP TABLE tmpMI_OrderInternal (MovementId Integer, UnitId Integer, MovementItemId Integer, GoodsId Integer) ON COMMIT DROP;
       INSERT INTO tmpMI_OrderInternal (MovementId, UnitId, MovementItemId, GoodsId)
       SELECT tmpMovement_OrderInternal.Id        AS Id
            , tmpMovement_OrderInternal.UnitId    AS UnitId
            , MovementItem.Id       AS MovementItemId
            , MovementItem.ObjectId AS GoodsId
       FROM tmpMovement_OrderInternal
            LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement_OrderInternal.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE;


       -- сохраняем строки документов
       PERFORM lpInsertUpdate_MovementItem_OrderInternal (ioId           := COALESCE (tmpMI_OrderInternal.MovementItemId,0)
                                                        , inMovementId   := tmpMovement_OrderInternal.Id
                                                        , inGoodsId      := tmpMI_Child.GoodsId
                                                        , inAmount       := tmpMI_Child.Amount
                                                        , inAmountManual := 0          :: TFloat
                                                        , inPrice        := tmpMI_Child.Price
                                                        , inUserId       := vbUserId
                                                        )
       FROM tmpMI_Child
            INNER JOIN tmpMovement_OrderInternal ON tmpMovement_OrderInternal.UnitId = tmpMI_Child.UnitId
            LEFT JOIN tmpMI_OrderInternal ON tmpMI_OrderInternal.MovementId = tmpMovement_OrderInternal.Id
                                         AND tmpMI_OrderInternal.GoodsId = tmpMI_Child.GoodsId;
                                         
           
      -- Подписуем
      PERFORM gpUpdate_Status_OrderInternal(inMovementId := tmpMovement_OrderInternal.ID 
                                          , inStatusCode := 2 
                                          , inSession := inSession)
      FROM tmpMovement_OrderInternal;    
                                           
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.19         *
*/