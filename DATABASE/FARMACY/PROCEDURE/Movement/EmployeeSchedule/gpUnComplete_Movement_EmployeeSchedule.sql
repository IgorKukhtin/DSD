-- Function: gpUnComplete_Movement_EmployeeSchedule (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_EmployeeSchedule (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_EmployeeSchedule (
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
  vbUserId:= inSession;

  -- проверка прав пользователя на вызов процедуры
  IF inSession::Integer NOT IN (3, 758920, 4183126, 9383066, 8037524)
  THEN
    RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
  END IF;
  
  -- изменили статус
  UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased());

  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Шаблий О.В.
 10.12.18                                                                        *
 */
 
