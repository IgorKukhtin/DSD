-- Function: gpUpdate_MI_TechnicalRediscount_CommentSend()

DROP FUNCTION IF EXISTS gpUpdate_MI_TechnicalRediscount_CommentSend (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TechnicalRediscount_CommentSend(
     IN inMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
     IN inCommentSendId       Integer   , -- Ключ объекта <Документ>
     IN inSession             TVarChar    -- пользователь
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbMISendId      Integer;
   DECLARE vbCommentSendId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

     SELECT MovementItemFloat.ValueData::Integer, MILinkObject_CommentSend.ObjectId
     INTO vbMISendId, vbCommentSendId
     FROM MovementItemFloat

          LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                           ON MILinkObject_CommentSend.MovementItemId = MovementItemFloat.ValueData::Integer
                                          AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

     WHERE MovementItemFloat.MovementItemId = inMovementItemId
               AND MovementItemFloat.DescId = zc_MIFloat_MovementItemId();

     IF COALESCE (vbMISendId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка. Не найдена строка в перемещении!';
     END IF;

     PERFORM gpInsertUpdate_MovementItem_Send (ioId                  := MovementItem.Id,
                                               inMovementId          := MovementItem.MovementId,
                                               inGoodsId             := MovementItem.ObjectId,
                                               inAmount              := MovementItem.Amount,
                                               inPrice               := 0,
                                               inPriceUnitFrom       := 0,
                                               ioPriceUnitTo         := 0,
                                               inAmountManual        := COALESCE(MIFloat_AmountManual.ValueData,0),
                                               inAmountStorage       := COALESCE(MIFloat_AmountStorage.ValueData,0),
                                               inReasonDifferencesId := COALESCE(MILinkObject_ReasonDifferences.ObjectId, 0),
                                               inCommentSendID       := inCommentSendId,
                                               inSession             := inSession)
     FROM MovementItem

          LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                      ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
          LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                      ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                           ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()

     WHERE MovementItem.Id = vbMISendId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  21.09.20                                                      *
*/

-- тест select * from gpUpdate_MI_TechnicalRediscount_CommentSend(inMovementItemId := 371775078 , inCommentSendId := 14883321 ,  inSession := '3');
--select * from gpUpdate_MI_TechnicalRediscount_CommentSend(inMovementItemId := 427715976 , inCommentSendId := 14887488 ,  inSession := '3');