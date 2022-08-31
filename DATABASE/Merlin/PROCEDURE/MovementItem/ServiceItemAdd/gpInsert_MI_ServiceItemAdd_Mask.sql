-- Function: gpInsert_MI_ServiceItemAdd_Mask()

DROP FUNCTION IF EXISTS gpInsert_MI_ServiceItemAdd_Mask (Integer, Integer, TVarChar);
 
CREATE OR REPLACE FUNCTION gpInsert_MI_ServiceItemAdd_Mask(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);

    
     PERFORM lpInsertUpdate_MovementItem_ServiceItemAdd (ioId                 := 0
                                                       , inMovementId         := inMovementId
                                                       , inUnitId             := MovementItem.ObjectId
                                                       , inInfoMoneyId        := MILinkObject_InfoMoney.ObjectId
                                                       , inCommentInfoMoneyId := MILinkObject_CommentInfoMoney.ObjectId
                                                       , inDateStart          := MIDate_DateEnd.ValueData + INTERVAL '1 DAY'  --сл. месяц
                                                       , inDateEnd            := MIDate_DateEnd.ValueData + INTERVAL '1 DAY'  --сл. месяц   - в lp переопределится как последнее число месяца
                                                       , inAmount             := MovementItem.Amount ::TFloat
                                                       , inUserId             := vbUserId
                                                        )
     FROM MovementItem 
         LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                    ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                   AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                          ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                         AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                          ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                         AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()   
     WHERE MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.Id         = inId
       AND MovementItem.MovementId = inMovementId
         ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.22         *
*/

-- тест
--