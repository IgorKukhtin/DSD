-- Function: gpUpdate_Movement_OrderInternalPromo_Sent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderInternalPromo_Sent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderInternalPromo_Sent(
    IN inMovementId            Integer    , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF vbUserId = 3
    THEN
      RETURN;
    END IF;
    
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_DATE);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.04.22                                                       *
*/


SELECT * FROM gpUpdate_Movement_OrderInternalPromo_Sent (inMovementId := 27547547 , inSession := '3');
