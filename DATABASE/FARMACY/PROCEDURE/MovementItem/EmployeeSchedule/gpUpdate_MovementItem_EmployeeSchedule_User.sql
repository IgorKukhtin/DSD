-- Function: gpUpdate_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_User(
    IN inOperDate            TDateTime,  -- Дата
    IN inStartHour           TVarChar,   -- Час прихода
    IN inStartMin            TVarChar,   -- Минуты прихода
    IN inEndHour             TVarChar,   -- Час ухода
    IN inEndMin              TVarChar,   -- Минуты ухода
    IN inServiceExit         Boolean,    -- Служебный выход
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
   DECLARE vbServiceExitOld Boolean;
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

    IF inServiceExit = FALSE
    THEN
      IF inStartHour  = '' OR inStartMin = '' OR inEndHour = '' OR inEndMin = ''
      THEN
        RAISE EXCEPTION 'Ошибка. Должно быть заполнено время прихода и ухода.';
      END IF;
    ELSE
      IF inStartHour <> '' OR inEndHour <> ''
      THEN
        RAISE EXCEPTION 'Ошибка. Часы прихода и ухода для служебного выхода заполнять ненадо.';
      END IF;
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
                                                                      , inComingValueDay      := ''::TVarChar      -- Приходы на работу по дням
                                                                      , inComingValueDayUser  := ''::TVarChar      -- Приходы на работу по дням
                                                                      , inUserId              := vbUserId          -- пользователь
                                                                       );

    END IF;

    IF inServiceExit = FALSE
    THEN

      vbDateStart := date_trunc('DAY', inOperDate)::Date + (inStartHour||':'||inStartMin)::Time;
      vbDateEnd := date_trunc('DAY', inOperDate)::Date + (inEndHour||':'||inEndMin)::Time;

      IF vbDateStart > vbDateEnd
      THEN
        vbDateEnd := vbDateEnd + interval '1 day';
      END IF;

      IF date_part('minute',  vbDateStart) not in (0, 30) OR date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;

    ELSE
      vbDateStart := Null;
      vbDateEnd := Null;
    END IF;

      -- Наличие записи по дню
    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementID
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ParentId = vbMovementItemID
                AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer)
    THEN
      SELECT MIDate_Start.ValueData
           , MIDate_End.ValueData
           , COALESCE(MIBoolean_ServiceExit.ValueData, FALSE)
      INTO vbDateStartOld, vbDateEndOld, vbServiceExitOld
      FROM MovementItem

           LEFT JOIN MovementItemDate AS MIDate_Start
                                      ON MIDate_Start.MovementItemId = MovementItem.Id
                                     AND MIDate_Start.DescId = zc_MIDate_Start()

           LEFT JOIN MovementItemDate AS MIDate_End
                                      ON MIDate_End.MovementItemId = MovementItem.Id
                                     AND MIDate_End.DescId = zc_MIDate_End()

           LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                         ON MIBoolean_ServiceExit.MovementItemId = MovementItem.Id
                                        AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;

      IF vbServiceExitOld = TRUE
      THEN
        RAISE EXCEPTION 'Ошибка. День отмечен как служебный выход. Изменения запрещено.';
      ELSEIF vbDateStart <> vbDateStartOld
      THEN
        RAISE EXCEPTION 'Ошибка. Шзменение времени прихода запрещено.';
      END IF;

      IF inServiceExit = FALSE
      THEN

        IF vbDateStartOld IS NULL
        THEN

          IF CURRENT_TIME::Time - vbDateStart::Time > '0:30'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Вы пытаетесь поставить время прихода не соответствующее реальному времени! Время прихода <%> не должно быть менее 30 мин от текущего времени <%>!', vbDateStart, CURRENT_TIME;
          END IF;

          IF date_part('HOUR', CURRENT_TIME)::Integer < 20
          THEN
            IF vbDateStart::Time < '7:00'::Time OR vbDateStart::Time >= '21:00'::Time
            THEN
              RAISE EXCEPTION 'Ошибка. Время прихода должно быть в диапазон с 7:00 до 21:00.';
            END IF;
          ELSE
            IF vbDateStart::Time < '21:00'::Time
            THEN
              RAISE EXCEPTION 'Ошибка. Время прихода должно быть в диапазон с 21:00 по 24:00.';
            END IF;
          END IF;
        END IF;

        IF date_part('HOUR', vbDateStart)::Integer < 21
        THEN
          IF vbDateStart::Time >= vbDateEnd::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время ухода должно быть больше времени прихода.';
          END IF;

          IF vbDateEnd::Time > '21:30'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время ухода должно быть в диапазон с % до 21:30.', to_char(vbDateStart::Time, 'HH24:MI');
          END IF;
        ELSE
          IF vbDateEnd::Time > '8:00'::Time AND vbDateEnd::Time < '21:00'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время ухода должно быть в диапазон с  % по 8:00.', to_char(vbDateStart::Time, 'HH24:MI');
          END IF;
        END IF;
      END IF;

      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := MovementItem.ID, -- Ключ объекта <Элемент документа>
                                                                 inMovementId     := vbMovementID, -- ключ Документа
                                                                 inParentId       := vbMovementItemID, -- элемент мастер
                                                                 inUnitId         := vbUnitId, -- подразделение
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- День недели
                                                                 inPayrollTypeID  := -1,
                                                                 inDateStart      := vbDateStart,
                                                                 inDateEnd        := vbDateEnd,
                                                                 inServiceExit    := inServiceExit,
                                                                 inSession        := inSession)
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;
    ELSE

      IF inServiceExit = FALSE 
      THEN

        IF CURRENT_TIME::Time - vbDateStart::Time > '0:30'::Time
        THEN
          RAISE EXCEPTION 'Ошибка. Вы пытаетесь поставить время прихода не соответствующее реальному времени! Время прихода <%> не должно быть менее 30 мин от текущего времени <%>!', vbDateStart, CURRENT_TIME;
        END IF;

        IF date_part('HOUR', CURRENT_TIME)::Integer < 20
        THEN
          IF vbDateStart::Time < '7:00'::Time OR vbDateStart::Time >= '21:00'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время прихода должно быть в диапазон с 7:00 до 21:00.';
          END IF;
        ELSE
          IF vbDateStart::Time < '21:00'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время прихода должно быть в диапазон с 21:00 по 24:00.';
          END IF;
        END IF;

        IF date_part('HOUR', vbDateStart)::Integer < 21
        THEN
          IF vbDateStart::Time >= vbDateEnd::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время ухода должно быть больше времени прихода.';
          END IF;

          IF vbDateEnd::Time > '21:30'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время ухода должно быть в диапазон с % до 21:30.', to_char(vbDateStart::Time, 'HH24:MI');
          END IF;
        ELSE
          IF vbDateEnd::Time > '8:00'::Time AND vbDateEnd::Time < '21:00'::Time
          THEN
            RAISE EXCEPTION 'Ошибка. Время ухода должно быть в диапазон с  % по 8:00.', to_char(vbDateStart::Time, 'HH24:MI');
          END IF;
        END IF;
      END IF;

      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := 0, -- Ключ объекта <Элемент документа>
                                                                 inMovementId     := vbMovementID, -- ключ Документа
                                                                 inParentId       := vbMovementItemID, -- элемент мастер
                                                                 inUnitId         := vbUnitId, -- подразделение
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- День недели
                                                                 inPayrollTypeID  := -1,
                                                                 inDateStart      := vbDateStart, -- Дата время начала смены
                                                                 inDateEnd        := vbDateEnd, -- Дата время конца счены
                                                                 inServiceExit    := inServiceExit,  -- Служебный выход
                                                                 inSession        := inSession);

    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
23.09.19                                                        *
31.08.19                                                        *
22.05.19                                                        *
10.12.18                                                        *

*/

