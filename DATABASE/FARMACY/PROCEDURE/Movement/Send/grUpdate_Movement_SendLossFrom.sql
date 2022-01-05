-- Function: grUpdate_Movement_SendLossFrom()

DROP FUNCTION IF EXISTS grUpdate_Movement_SendLossFrom(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION grUpdate_Movement_SendLossFrom(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisSendLossFrom      Boolean   ,    -- В полное списание на отправителя
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbInvNumber   TVarChar;
   DECLARE vbUnitIdFrom  Integer;
   DECLARE vbUnitIdTo    Integer;
   DECLARE vbisDeferred  Boolean;
   DECLARE vbisSUN       Boolean;
   DECLARE vbisSent      Boolean;
   DECLARE vbisReceived  Boolean;
   DECLARE vbisSendLoss  Boolean;
   DECLARE vbisSendLossFrom  Boolean;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbLossId      Integer;
   DECLARE vbLossStatusId Integer;
   DECLARE vbLossInvNumber TVarChar;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение признака <В полное списание> разрешено только администратору.';
   END IF;
   
   SELECT Movement.StatusId,  Movement.OperDate,  Movement.InvNumber
        , MovementLinkObject_From.ObjectId
        , MovementLinkObject_To.ObjectId
        , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)::Boolean AS isDeferred
        , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     ::Boolean AS isSUN
        , COALESCE (MovementBoolean_Sent.ValueData, FALSE)::Boolean     AS isSent
        , COALESCE (MovementBoolean_Received.ValueData, FALSE)::Boolean AS isReceived
        , COALESCE (MovementBoolean_SendLoss.ValueData, FALSE)          AS isSendLoss
        , COALESCE (MovementBoolean_SendLossFrom.ValueData, FALSE)      AS isSendLossFrom
        , COALESCE (MovementLinkMovement_Loss.MovementChildId, 0)       AS LossId
        , COALESCE (MovementLoss.StatusId, 0)                           AS LossStatusId 
        , MovementLoss.InvNumber                                        AS LossInvNumber
   INTO vbStatusId, vbOperDate, vbInvNumber, vbUnitIdFrom, vbUnitIdTo, vbisDeferred, vbisSUN, vbisSent, vbisReceived, vbisSendLoss, vbisSendLossFrom
      , vbLossId, vbLossStatusId, vbLossInvNumber
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

            LEFT JOIN MovementBoolean AS MovementBoolean_SendLoss
                                      ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                     AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()
            LEFT JOIN MovementBoolean AS MovementBoolean_SendLossFrom
                                      ON MovementBoolean_SendLossFrom.MovementId = Movement.Id
                                     AND MovementBoolean_SendLossFrom.DescId = zc_MovementBoolean_SendLossFrom()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Loss
                                           ON MovementLinkMovement_Loss.MovementId = Movement.Id
                                          AND MovementLinkMovement_Loss.DescId = zc_MovementLinkMovement_Loss()
                                          
            LEFT JOIN Movement AS MovementLoss ON MovementLoss.Id = COALESCE (MovementLinkMovement_Loss.MovementChildId, 0) 
                                     
   WHERE Movement.Id = inMovementId;
   
   IF vbisSendLossFrom <> inisSendLossFrom
   THEN
      RAISE EXCEPTION 'Ошибка. Признак <В полное списание на отправителя> изменился из вне обновите форму и повторите попытку.';
   END IF;  

   IF vbisSendLoss = TRUE
   THEN
      RAISE EXCEPTION 'Ошибка. Установлен признак <В полное списание> изменение признака <В полное списание на отправителя> запрещено.';
   END IF;  

   IF date_trunc('month', CURRENT_DATE) <> date_trunc('month', vbOperDate)
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение признака <В полное списание> можно только на документы текущего месяца.';
   END IF;
      
   IF COALESCE (inisSendLossFrom, False) = False
   THEN

     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
     END IF;
     
     IF inisSendLossFrom = FALSE AND (vbisSUN <> TRUE  OR vbisDeferred <> TRUE OR vbisSent <> TRUE OR vbisReceived = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка. Для установки <В полное списание> документ должен быть с признаками <Перемещение по СУН>, <Отложен>, <Отправлен> и не <Получен>.';
     END IF;

     -- сохранили признак
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SendLossFrom(), inMovementId, NOT inisSendLossFrom);

     PERFORM gpUpdate_Movement_Send_Deferred (inMovementId   := inMovementId
                                            , inisDeferred   := False
                                            , inSession      := inSession);
                                            
     PERFORM gpSetErased_Movement_Send (inMovementId    := inMovementId
                                      , inSession       := inSession);
                                      
                                      
     -- сохранили <Документ>
     IF COALESCE (vbLossId, 0) = 0
     THEN
           vbLossId := lpInsertUpdate_Movement_Loss (ioId                 := 0
                                                   , inInvNumber          := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                                   , inOperDate           := vbOperDate
                                                   , inUnitId             := vbUnitIdFrom
                                                   , inArticleLossId      := 13892113
                                                   , inComment            := 'Списание по перемещению '||vbInvNumber||' от '||zfConvert_DateShortToString(vbOperDate)
                                                   , inConfirmedMarketing := ''
                                                   , inUserId             := vbUserId
                                                    );
     ELSE 

         IF COALESCE (vbLossStatusId, 0) = zc_Enum_Status_Complete()
         THEN
            RAISE EXCEPTION 'Ошибка. Изменение документа полного списания <%> в статусе <%> не возможно.', vbLossInvNumber, lfGet_Object_ValueData (vbStatusId);
         END IF;
         
         IF COALESCE (vbLossStatusId, 0) = zc_Enum_Status_Erased()
         THEN
            PERFORM gpUnComplete_Movement_Loss(inMovementId := vbLossId, inSession := inSession);
         END IF;
              
         PERFORM lpInsertUpdate_Movement_Loss (ioId                 := vbLossId
                                             , inInvNumber          := Movement.InvNumber
                                             , inOperDate           := vbOperDate
                                             , inUnitId             := vbUnitIdFrom
                                             , inArticleLossId      := 13892113
                                             , inComment            := 'Списание по перемещению '||vbInvNumber||' от '||zfConvert_DateShortToString(vbOperDate)
                                             , inConfirmedMarketing := ''
                                             , inUserId             := vbUserId
                                              )
         FROM Movement WHERE Movement.Id = vbLossId;
             
         -- Востановим если чтото удалиди раньше
         UPDATE MovementItem SET isErased = FALSE 
         WHERE MovementItem.MovementId = vbLossId 
           AND MovementItem.isErased = TRUE;  
                  
     END IF;
        
     -- сохранили признак
        
     PERFORM lpInsertUpdate_MovementItem_Loss (ioId                := COALESCE (MovementItemLoss.Id, 0)
                                             , inMovementId        := vbLossId
                                             , inGoodsId           := COALESCE (MovementItemSend.ObjectId, MovementItemSend.ObjectId)
                                             , inAmount            := COALESCE (MovementItemSend.Amount, 0)
                                             , inUserId            := vbUserId)
     FROM (SELECT MovementItemSend.ObjectId
                , SUM(MovementItemSend.Amount) AS Amount
           FROM MovementItem AS MovementItemSend
           WHERE MovementItemSend.MovementId = inMovementID
             AND MovementItemSend.IsErased = False
             AND MovementItemSend.DescId = zc_MI_Master()
             AND MovementItemSend.Amount > 0
           GROUP BY MovementItemSend.ObjectId) AS MovementItemSend

          LEFT JOIN MovementItem AS MovementItemLoss ON MovementItemLoss.MovementId = vbLossId
                                AND MovementItemLoss.DescId     = zc_MI_Master()
                                AND MovementItemLoss.ObjectId   = MovementItemSend.ObjectId

     WHERE COALESCE (MovementItemSend.Amount, 0) <> COALESCE (MovementItemLoss.Amount, 0);

     -- Удалим если количество 0
     UPDATE MovementItem SET isErased = TRUE 
     WHERE MovementItem.MovementId = vbLossId 
       AND MovementItem.Amount = 0;  

     -- Проводим списание
     PERFORM gpComplete_Movement_Loss (inMovementId:= vbLossId, inIsCurrentData:= False, inSession:= inSession);
                                      
     -- сохранили ID списания
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Loss(), inMovementId, vbLossId);                                      

   ELSE

     -- сохранили признак
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SendLossFrom(), inMovementId, NOT inisSendLossFrom);

     PERFORM gpUnComplete_Movement_Send (inMovementId    := inMovementId
                                       , inSession       := inSession);
                                         
     IF COALESCE (vbLossId, 0) <> 0
     THEN
       IF COALESCE (vbLossStatusId, 0) = zc_Enum_Status_Complete()
       THEN
          PERFORM gpUnComplete_Movement_Loss(inMovementId := vbLossId, inSession := inSession);
       END IF;
           
       IF COALESCE (vbLossStatusId, 0) <> zc_Enum_Status_Erased()
       THEN
          PERFORM gpSetErased_Movement_Loss(inMovementId := vbLossId, inSession := inSession);
       END IF;
     END IF;
      
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 29.12.21                                                                      *
*/

-- select * from grUpdate_Movement_SendLossFrom(inMovementID := 23200084 , inisSendLoss := 'False' ,  inSession := '3');