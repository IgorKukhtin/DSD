-- Function: lpInsertUpdate_Movement_ServiceItem_byHistory()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ServiceItem_byHistory (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ServiceItem_byHistory(
    IN inDateStart           TDateTime , --
    IN inDateEnd             TDateTime , --
    IN inUnitId              Integer   , -- 
    IN inInfoMoneyId         Integer  , -- 
    IN inCommentInfoMoneyId  Integer  ,
    IN inAmount              TFloat   ,
    IN inPrice               TFloat   ,
    IN inArea                TFloat   ,
    IN inUserId              Integer     -- Пользователь
)       
                       
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumber TVarChar; 
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- Проверка
     IF 1 < (SELECT COUNT(*)
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.ObjectId   = inUnitId
                           INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                            AND MILinkObject_InfoMoney.ObjectId       = inInfoMoneyId
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                            ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                                                         --AND MILinkObject_CommentInfoMoney.ObjectId       = inCommentInfoMoneyId
                      WHERE Movement.DescId    = zc_Movement_ServiceItem()
                        AND Movement.OperDate  = inDateEnd
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     )
     THEN
         RAISE EXCEPTION 'Ошибка.Найдены документы для <%> + <%> + <%>', lfGet_Object_ValueData_sh (inUnitId), lfGet_Object_ValueData_sh (inInfoMoneyId), zfConvert_DateToString (inDateEnd);
     END IF;
     
     -- найти документ
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.ObjectId   = inUnitId
                           INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                            AND MILinkObject_InfoMoney.ObjectId       = inInfoMoneyId
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                            ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                                                         --AND MILinkObject_CommentInfoMoney.ObjectId       = inCommentInfoMoneyId
                      WHERE Movement.DescId    = zc_Movement_ServiceItem()
                        AND Movement.OperDate  = inDateEnd
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );
     
     -- если не нашли  создаем
     IF COALESCE (vbMovementId, 0) = 0
     THEN
         vbInvNumber := CAST (NEXTVAL ('movement_serviceitem_seq') AS TVarChar);
         vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_ServiceItem(), vbInvNumber, inDateEnd, NULL, inUserId);
     END IF;
      
     -- найти строку
     vbMovementItemId := (SELECT MovementItem.Id
                          FROM MovementItem
                              INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                               AND MILinkObject_InfoMoney.ObjectId       = inInfoMoneyId
                          WHERE MovementItem.MovementId = vbMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            AND MovementItem.ObjectId   = inUnitId
                         );
                   
     --
     -- сохраняем или обновляем данные
     PERFORM lpInsertUpdate_MovementItem_ServiceItem (ioId                 := COALESCE (vbMovementItemId,0)
                                                    , inMovementId         := vbMovementId
                                                    , inUnitId             := inUnitId
                                                    , inInfoMoneyId        := inInfoMoneyId
                                                    , inCommentInfoMoneyId := inCommentInfoMoneyId
                                                    , inDateEnd            := inDateEnd
                                                    , inAmount             := inAmount
                                                    , inPrice              := inPrice
                                                    , inArea               := inArea
                                                    , inUserId             := inUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
 */

-- тест
--