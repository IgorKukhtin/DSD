-- Function: grUpdate_Movement_SendLoss()

DROP FUNCTION IF EXISTS grUpdate_Movement_SendLoss(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION grUpdate_Movement_SendLoss(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisSendLoss          Boolean   ,    -- В полное списание
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbUnitIdFrom  Integer;
   DECLARE vbUnitIdTo    Integer;
   DECLARE vbisDeferred  Boolean;
   DECLARE vbisSUN       Boolean;
   DECLARE vbisSent      Boolean;
   DECLARE vbisReceived  Boolean;
   DECLARE vbOperDate    TDateTime;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение признака <В полное списание> разрешено только администратору.';
   END IF;
   
   SELECT Movement.StatusId,  Movement.OperDate
        , MovementLinkObject_From.ObjectId
        , MovementLinkObject_To.ObjectId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)::Boolean     AS isSent
        , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
   INTO vbStatusId, vbOperDate, vbUnitIdFrom, vbUnitIdTo, vbisDeferred, vbisSUN, vbisSent, vbisReceived
   FROM Movement

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                      ON MovementBoolean_SUN.MovementId = Movement.Id
                                     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()

            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()

            LEFT JOIN MovementBoolean AS MovementBoolean_Confirmed
                                      ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                     AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

   WHERE Movement.Id = inMovementId;

   IF date_trunc('month', CURRENT_DATE) <> date_trunc('month', vbOperDate)
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение признака <В полное списание> можно только на документы текущего месяца.';
   END IF;
  

   IF COALESCE (inisSendLoss, False) = False
   THEN

     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
     END IF;
     
     IF inisSendLoss = FALSE AND (vbisSUN <> TRUE  OR vbisDeferred <> TRUE OR vbisSent <> TRUE OR vbisReceived = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка. Для установки <В полное списание> документ должен быть с признаками <Перемещение по СУН>, <Отложен>, <Отправден> и не <Получен>.';
     END IF;

     -- сохранили признак
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SendLoss(), inMovementId, NOT inisSendLoss);

     PERFORM gpUpdate_Movement_Send_Deferred (inMovementId   := inMovementId
                                            , inisDeferred   := False
                                            , inSession      := inSession);
      
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := MovementItem.Id  
                                             , inMovementId          := inMovementId
                                             , inGoodsId             := MovementItem.ObjectId  
                                             , inAmount              := MovementItem.Amount / 2
                                             , inAmountManual        := MovementItem.Amount / 2
                                             , inAmountStorage       := MovementItem.Amount / 2
                                             , inReasonDifferencesId := MILinkObject_ReasonDifferences.ObjectId
                                             , inCommentSendID       := MILinkObject_CommentSend.ObjectId
                                             , inUserId              := vbUserId
                                              )
     FROM MovementItem
     
       LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                        ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                       AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
       LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                        ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                       AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                       
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount > 0
       AND MovementItem.isErased = FALSE;
    
     PERFORM lpInsertUpdate_MovementItem_Send_Child (ioId                  := MovementItem.Id
                                                   , inParentId            := MIMaster.Id
                                                   , inMovementId          := inMovementId
                                                   , inGoodsId             := MovementItem.ObjectId
                                                   , inAmount              := MovementItem.Amount / 2
                                                   , inContainerId         := MovementItemFloat.ValueData::Integer
                                                   , inUserId              := vbUserId
                                                    )
     FROM MovementItem AS MIMaster

          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.ParentId = MIMaster.Id
                                 AND MovementItem.DescId = zc_MI_Child()
                                 AND MovementItem.Amount > 0                                 
          INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                      AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                      
     WHERE MIMaster.MovementId = inMovementId
       AND MIMaster.DescId = zc_MI_Master()
       AND MIMaster.Amount > 0
       AND MIMaster.isErased = FALSE;
                                      
     PERFORM gpComplete_Movement_Send (inMovementId    := inMovementId
                                     , inIsCurrentData := False
                                     , inSession       := inSession);

   ELSE

     -- сохранили признак
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SendLoss(), inMovementId, NOT inisSendLoss);

     IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Complete()
     THEN
       
       PERFORM gpUnComplete_Movement_Send (inMovementId    := inMovementId
                                         , inSession       := inSession);
                                         
       PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := MovementItem.Id  
                                               , inMovementId          := inMovementId
                                               , inGoodsId             := MovementItem.ObjectId  
                                               , inAmount              := MovementItem.Amount * 2
                                               , inAmountManual        := MovementItem.Amount * 2
                                               , inAmountStorage       := MovementItem.Amount * 2
                                               , inReasonDifferencesId := MILinkObject_ReasonDifferences.ObjectId
                                               , inCommentSendID       := MILinkObject_CommentSend.ObjectId
                                               , inUserId              := vbUserId
                                                )
       FROM MovementItem
       
         LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                          ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                         AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                          ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                         AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
                                         
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.Amount > 0
         AND MovementItem.isErased = FALSE;
      
       PERFORM lpInsertUpdate_MovementItem_Send_Child (ioId                  := MovementItem.Id
                                                     , inParentId            := MIMaster.Id
                                                     , inMovementId          := inMovementId
                                                     , inGoodsId             := MovementItem.ObjectId
                                                     , inAmount              := MovementItem.Amount * 2
                                                     , inContainerId         := MovementItemFloat.ValueData::Integer
                                                     , inUserId              := vbUserId
                                                      )
       FROM MovementItem AS MIMaster

            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.ParentId = MIMaster.Id
                                   AND MovementItem.DescId = zc_MI_Child()
                                   AND MovementItem.Amount > 0                                 
            INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                        AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                        
       WHERE MIMaster.MovementId = inMovementId
         AND MIMaster.DescId = zc_MI_Master()
         AND MIMaster.Amount > 0
         AND MIMaster.isErased = FALSE;
       
       PERFORM gpUpdate_Movement_Send_Deferred (inMovementId   := inMovementId
                                              , inisDeferred   := True
                                              , inSession      := inSession);     
     ELSEIF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
     END IF;
   END IF;

   PERFORM * FROM grInsertUpdate_Movement_LossSendLossUnit (inUnitID := vbUnitIdFrom, inSession:= '3');
   PERFORM * FROM grInsertUpdate_Movement_LossSendLossUnit (inUnitID := vbUnitIdTo, inSession:= '3');
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 12.10.19                                                                      *
 06.08.19                                                                      *
*/

-- select * from grUpdate_Movement_SendLoss(inMovementID := 23200084 , inisSendLoss := 'False' ,  inSession := '3');

-- select * from grUpdate_Movement_SendLoss(inMovementID := 23200084 , inisSendLoss := 'False' ,  inSession := '3');