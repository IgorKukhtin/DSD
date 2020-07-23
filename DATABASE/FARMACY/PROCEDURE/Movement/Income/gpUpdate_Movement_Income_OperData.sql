-- Function: gpUpdate_Movement_Income_OperData()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_OperData(Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_OperData(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- № документа
    IN inOperDate            TDateTime , -- Дата о
   OUT outInvNumber          TVarChar  , -- № документа
   OUT outOperDate           TDateTime , -- Дата о
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND (Movement.InvNumber <> inInvNumber OR Movement.OperDate <> inOperDate))
    THEN
        UPDATE Movement SET
            InvNumber = inInvNumber, OperDate = inOperDate
        WHERE
            Id = inMovementId;
    END IF;
    
    outInvNumber := inInvNumber;
    outOperDate := inOperDate;
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.04.20                                                       *

*/
