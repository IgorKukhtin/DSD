-- Function: gpUpdate_Movement_TransportGoods_CommentError ()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_CommentError (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportGoods_CommentError(
    IN inMovementId               Integer   , --
    IN inCommentError             TVarChar  , -- Текст ошибки при обработке (е-ТТН)
    IN inSession                  TVarChar    -- сессия пользователя

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили Текст ошибки
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, inCommentError);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.06.23                                                       *
*/

-- тест
--