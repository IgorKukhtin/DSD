-- Function: gpUpdate_Movement_Income_BranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_BranchDate(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_BranchDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBranchDate          TDateTime , -- Дата в аптеке
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_BranchDate());

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    IF inBranchDate IS NOT NULL
    THEN
        -- 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, inBranchDate);
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.07.17         *

*/
