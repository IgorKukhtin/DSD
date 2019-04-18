 -- Function: gpUpdate_Movement_Check_Delay()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Delay (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Delay(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Учтановка признака <Просрочка.> вам запрещено.';
    END IF;

    SELECT StatusId
    INTO vbStatusId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
    WHERE Id = inMovementId;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение признака <Просрочка.> в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- Удалили чек
    PERFORM gpSetErased_Movement_Check (inMovementId, inSession);

    -- сохранили отметку <Просрочка>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Delay(), inMovementId, True);

    -- сохранили свойство <Дата создания просрочки>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Delay(), inMovementId, CURRENT_TIMESTAMP);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 18.04.19                                                                    *
 04.04.19                                                                    *
*/
-- тест
-- select * from gpUpdate_Movement_Check_Delay(inMovementId := 7784533 ,  inSession := '3');