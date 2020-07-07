-- Function: gpUnComplete_Movement_SendPartionDateChange (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SendPartionDateChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SendPartionDateChange(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendPartionDateChange());

    -- проверка - если <Master> Удален, то <Ошибка>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

    -- Распроводим документ изменения сроков
    SELECT Movement.ID, Movement.StatusId
    INTO vbMovementId, vbStatusId
    FROM Movement
    WHERE Movement.DescId = zc_Movement_SendPartionDate()
      AND Movement.ParentId = inMovementId;

    IF COALESCE (vbMovementId, 0) > 0 AND vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      PERFORM gpUnComplete_Movement_SendPartionDate (vbMovementId, inSession);
    END IF;

    --пересчитываем сумму документа по приходным ценам
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_SendPartionDateChange (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())