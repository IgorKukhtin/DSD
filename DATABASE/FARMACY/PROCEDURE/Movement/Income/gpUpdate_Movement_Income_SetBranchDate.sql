-- Function: gpUpdate_Movement_Income_SetBranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_SetBranchDate(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_SetBranchDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBranchDate          TDateTime , -- Дата в аптеке
   OUT outBranchDate         TDateTime , -- Дата в аптеке
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_BranchDate());
    vbUserId := inSession;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    SELECT
      StatusId
    INTO
      vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF inBranchDate IS NOT NULL
    THEN
        -- сохраняем <Дату Аптеки>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, inBranchDate);
        
        outBranchDate := inBranchDate;
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.21                                                       *

*/