-- Function: gpSetErased_Movement_EmployeeSchedule (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_EmployeeSchedule (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_EmployeeSchedule(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    vbUserId := inSession;

  -- проверка прав пользователя на вызов процедуры
  IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer
  THEN
    RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
  END IF;

  -- изменили статус
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete());

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
