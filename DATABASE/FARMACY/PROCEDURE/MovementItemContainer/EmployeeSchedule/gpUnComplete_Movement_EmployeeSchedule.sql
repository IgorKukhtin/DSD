-- Function: gpUnComplete_Movement_EmployeeSchedule (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_EmployeeSchedule (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_EmployeeSchedule(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeSchedule());
    vbUserId := inSession;


     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --пересчитываем сумму документа по приходным ценам
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.12.23                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_EmployeeSchedule (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())