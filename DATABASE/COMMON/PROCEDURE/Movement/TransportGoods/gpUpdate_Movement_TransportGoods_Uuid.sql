-- Function: gpUpdate_Movement_TransportGoods_Uuid ()

--DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_Uuid (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_Uuid (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportGoods_Uuid(
    IN inMovementId               Integer   , --
    IN inUuid                     TVarChar  , -- Ідентифікатор документа, у «Електронної товарно-транспортної накладної» (е-ТТН)
    IN inCommentError             TVarChar  , -- Текст ошибки при обработке (е-ТТН)
    IN inSession                  TVarChar    -- сессия пользователя

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили Ідентифікатор документа, у «Електронної товарно-транспортної накладної» (е-ТТН)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Uuid(), inMovementId, inUuid);

     -- очистили Текст ошибки
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, inCommentError);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.05.23                                                       *
*/

-- тест
--