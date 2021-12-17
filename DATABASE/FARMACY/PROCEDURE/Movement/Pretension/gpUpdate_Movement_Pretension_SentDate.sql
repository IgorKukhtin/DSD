-- Function: gpUpdate_Movement_Pretension_SentDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_SentDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_SentDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Перемещение>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;
    
    
    --Сохранили Корректировка нашей даты
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_TIMESTAMP);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/