-- Function: gpUpdate_Movement_Check_CurrentOperDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_CurrentOperDate (Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_CurrentOperDate(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF COALESCE(inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;
    
    SELECT Movement.InvNumber
    INTO vbInvNumber
    FROM Movement
    WHERE Movement.Id =  inMovementId;    

    -- сохранили <Документ>
    inMovementId := lpInsertUpdate_Movement (inMovementId, zc_Movement_Check(), vbInvNumber, CURRENT_TIMESTAMP, NULL);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.03.20                                                        *
*/
-- тест
-- SELECT * FROM gpUpdate_Movement_Check_CurrentOperDate (inId := 0, inOperDate := NULL::TDateTime, inInvNumber:= '12345'::TVarChar, inSession := '3'::TVarChar); 
