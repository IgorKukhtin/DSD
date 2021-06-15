-- Function: gpInsert_MovementItem_EmployeeSchedule_PreviousMonth()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_EmployeeSchedule_PreviousMonth(INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_EmployeeSchedule_PreviousMonth(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbPreviousId Integer;
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Не сохранен график работы сотрудников.';
    END IF;

    SELECT Movement.OperDate
    INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = vbOperDate - INTERVAL '1 MONTH'
                AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      SELECT Movement.Id
      INTO vbPreviousId
      FROM Movement
      WHERE Movement.OperDate = vbOperDate - INTERVAL '1 MONTH'
         AND Movement.DescId = zc_Movement_EmployeeSchedule();
    ELSE
      RAISE EXCEPTION 'Не найден график работы сотрудников за предыдущий месяц.';
    END IF;

    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                                  -- Ключ объекта <Элемент документа>
                                                        , inMovementId          := inMovementId                       -- ключ Документа
                                                        , inPersonId            := MovementItem.ObjectId              -- сотрудник
                                                        , inComingValueDay      := MIString_ComingValueDay.ValueData  -- Приходы на работу по дням
                                                        , inUserId              := vbUserId                           -- пользователь
                                                         )
    FROM Movement

         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                AND MovementItem.DescId = zc_MI_Master()

         INNER JOIN MovementItemString AS MIString_ComingValueDay
                                       ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                      AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

    WHERE Movement.ID = vbPreviousId
      AND MovementItem.IsErased = FALSE
      AND MovementItem.ObjectId NOT IN (SELECT MovementItem.ObjectId 
                                        FROM MovementItem 
                                        WHERE MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId = zc_MI_Master())
    ORDER BY MovementItem.ObjectId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
28.02.19                                                        *

*/

-- тест
-- select * from gpInsert_MovementItem_EmployeeSchedule_PreviousMonth(inMovementId := 12604182 ,  inSession := '4183126');