 -- Function: gpUpdate_Movement_Check_SummCard()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SummCard (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SummCard(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSummCard          TFloat    , -- Предоплатs на карту
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
        RAISE EXCEPTION 'Ошибка.Изменение признака <Предоплатs на карту.> в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- сохранили отметку <Предоплатs на карту>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCard(), inMovementId, inSummCard);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 01.07.20                                                                    *
*/
-- тест
-- select * from gpUpdate_Movement_Check_SummCard(inMovementId := 7784533 ,  inSession := '3');