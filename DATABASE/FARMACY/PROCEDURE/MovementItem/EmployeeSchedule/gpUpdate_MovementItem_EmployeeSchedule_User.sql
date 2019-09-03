-- Function: gpUpdate_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_User(
    IN inOperDate            TDateTime,  -- Дата
    IN inStartHour           TVarChar,   -- Час прихода
    IN inStartMin           TVarChar,    -- Минуты прихода
    IN inEndHour             TVarChar,   -- Час ухода
    IN inEndMin             TVarChar,    -- Минуты ухода
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbDateStartOld TDateTime;
   DECLARE vbDateEndOld TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- проверка наличия графика
    IF NOT EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', inOperDate)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      RAISE EXCEPTION 'Ошибка. График работы сотрудеиков не найден. Обратитесь к Романовой Т.В.';
    END IF;

    IF inStartHour  = '' OR inStartMin = '' OR inEndHour = '' OR inEndMin = ''
    THEN
      RAISE EXCEPTION 'Ошибка. Должно быть заполнено время прихода и ухода.';
    END IF;

    SELECT Movement.ID
    INTO vbMovementID
    FROM Movement
    WHERE Movement.OperDate = date_trunc('month', inOperDate)
      AND Movement.DescId = zc_Movement_EmployeeSchedule();

    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = vbUserId)
    THEN
      SELECT MovementItem.ID
      INTO vbMovementItemID
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = vbUserId;
    ELSE
      -- сохранили
      vbMovementItemID := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                 -- Ключ объекта <Элемент документа>
                                                                      , inMovementId          := vbMovementID      -- ключ Документа
                                                                      , inPersonId            := vbUserId          -- сотрудник
                                                                      , inComingValueDay      := '0000000000000000000000000000000'::TVarChar      -- Приходы на работу по дням
                                                                      , inComingValueDayUser  := '0000000000000000000000000000000'::TVarChar      -- Приходы на работу по дням
                                                                      , inUserId              := vbUserId          -- пользователь
                                                                       );

    END IF;

    vbDateStart := date_trunc('DAY', inOperDate) + (inStartHour||':'||inStartMin)::Time;
    vbDateEnd := date_trunc('DAY', inOperDate) + (inEndHour||':'||inEndMin)::Time;
      
    IF vbDateStart > vbDateEnd
    THEN
      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;
      
    IF date_part('minute',  vbDateStart) not in (0, 30) OR date_part('minute',  vbDateEnd) not in (0, 30)
    THEN
      RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
    END IF;
    
      -- Наличие записи по дню
    IF EXISTS(SELECT 1 FROM MovementItem

                             INNER JOIN MovementItemDate AS MIDate_Start
                                                         ON MIDate_Start.MovementItemId = MovementItem.Id
                                                        AND MIDate_Start.DescId = zc_MIDate_Start()

                             INNER JOIN MovementItemDate AS MIDate_EndEnd
                                                         ON MIDate_EndEnd.MovementItemId = MovementItem.Id
                                                        AND MIDate_EndEnd.DescId = zc_MIDate_End()
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ParentId = vbMovementItemID
                AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer)
    THEN
      SELECT MIDate_Start.ValueData
           , MIDate_End.ValueData
      INTO vbDateStartOld, vbDateEndOld
      FROM MovementItem

           INNER JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MovementItem.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start()

           INNER JOIN MovementItemDate AS MIDate_End
                                       ON MIDate_End.MovementItemId = MovementItem.Id
                                      AND MIDate_End.DescId = zc_MIDate_End()

      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;

      IF vbDateStart <> vbDateStartOld
      THEN
        RAISE EXCEPTION 'Ошибка. Шзменение времени прихода запрещено.';
      END IF;

      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := MovementItem.ID, -- Ключ объекта <Элемент документа>
                                                                 inMovementId     := vbMovementID, -- ключ Документа
                                                                 inParentId       := vbMovementItemID, -- элемент мастер
                                                                 inUnitId         := vbUnitId, -- подразделение
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- День недели
                                                                 inPayrollTypeID  := -1,
                                                                 inDateStart      := vbDateStart,
                                                                 inDateEnd        := vbDateEnd,
                                                                 inSession        := inSession)
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;
    ELSE
      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := 0, -- Ключ объекта <Элемент документа>
                                                                 inMovementId     := vbMovementID, -- ключ Документа
                                                                 inParentId       := vbMovementItemID, -- элемент мастер
                                                                 inUnitId         := vbUnitId, -- подразделение
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- День недели
                                                                 inPayrollTypeID  := -1,
                                                                 inDateStart      := vbDateStart, -- Дата время начала смены
                                                                 inDateEnd        := vbDateEnd, -- Дата время конца счены
                                                                 inSession        := inSession);

    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbMovementItemID, vbUserId, False);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
31.08.19                                                        *
22.05.19                                                        *
10.12.18                                                        *

*/
