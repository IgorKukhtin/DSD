-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule_Filling()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule_Filling(Integer, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule_Filling(
    IN inMovementID          Integer,    -- Документ
    IN inOperDate            TDateTime,  -- Дата
    IN inUserID              Integer,    -- Пользователь
    IN inUnitID              Integer,    -- Подразделение
    IN inPayrollTypeID       Integer,    -- Тип дня
    IN inStartHour           TVarChar,   -- Час прихода
    IN inStartMin            TVarChar,   -- Минуты прихода
    IN inEndHour             TVarChar,   -- Час ухода
    IN inEndMin              TVarChar,   -- Минуты ухода
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;

   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;

   DECLARE vbUnitOldId Integer;
   DECLARE vbDateStartOld TDateTime;
   DECLARE vbDateEndOld TDateTime;
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

    IF COALESCE (inUserID, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Не выбран сотрудник.';
    END IF;

    -- проверка наличия графика
    IF NOT EXISTS(SELECT 1 FROM Movement
              WHERE Movement.ID = inMovementId
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      RAISE EXCEPTION 'Ошибка. График работы сотрудеиков не найден.';
    END IF;

    IF inPayrollTypeID < 0
    THEN
      IF inStartHour <> '' OR inEndHour <> ''
      THEN
        RAISE EXCEPTION 'Ошибка. Часы прихода и ухода для служебного выхода заполнять ненадо.';
      END IF;
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = inMovementID
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = inUserId)
    THEN
      SELECT MovementItem.ID
      INTO vbMovementItemID
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementID
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = inUserId;
    ELSE
      -- сохранили
      vbMovementItemID := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                 -- Ключ объекта <Элемент документа>
                                                                      , inMovementId          := inMovementID      -- ключ Документа
                                                                      , inPersonId            := inUserId          -- сотрудник
                                                                      , inComingValueDay      := '0000000000000000000000000000000'::TVarChar      -- Приходы на работу по дням
                                                                      , inComingValueDayUser  := '0000000000000000000000000000000'::TVarChar      -- Приходы на работу по дням
                                                                      , inUserId              := vbUserId          -- пользователь
                                                                       );

    END IF;


    IF inPayrollTypeID >= 0 AND inStartHour <> ''
    THEN
      vbDateStart := date_trunc('DAY', inOperDate)::Date + (inStartHour||':'||inStartMin)::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      vbDateStart := Null;
    END IF;

    IF inPayrollTypeID >= 0 AND inEndHour <> ''
    THEN
       vbDateEnd := date_trunc('DAY', inOperDate)::Date + (inEndHour||':'||inEndMin)::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      vbDateEnd := Null;
    END IF;

    IF inPayrollTypeID >= 0 AND inStartHour <> '' and inEndHour <> '' and vbDateStart > vbDateEnd
    THEN
      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;


      -- Наличие записи по дню
    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = inMovementID
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ParentId = vbMovementItemID
                AND MovementItem.Amount = date_part('DAY', inOperDate)::Integer)
    THEN
      SELECT MovementItem.ObjectId
           , MIDate_Start.ValueData
           , MIDate_End.ValueData
      INTO vbUnitOldId, vbDateStartOld, vbDateEndOld
      FROM MovementItem

           LEFT JOIN MovementItemDate AS MIDate_Start
                                      ON MIDate_Start.MovementItemId = MovementItem.Id
                                     AND MIDate_Start.DescId = zc_MIDate_Start()

           LEFT JOIN MovementItemDate AS MIDate_End
                                      ON MIDate_End.MovementItemId = MovementItem.Id
                                     AND MIDate_End.DescId = zc_MIDate_End()

      WHERE MovementItem.MovementId = inMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;

      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := MovementItem.ID, -- Ключ объекта <Элемент документа>
                                                                 inMovementId     := inMovementID, -- ключ Документа
                                                                 inParentId       := vbMovementItemID, -- элемент мастер
                                                                 inUnitId         := COALESCE(inUnitId, vbUnitOldId), -- подразделение
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- День недели
                                                                 inPayrollTypeID  := inPayrollTypeID,
                                                                 inDateStart      := COALESCE(vbDateStart, vbDateStartOld),
                                                                 inDateEnd        := COALESCE(vbDateEnd, vbDateEndOld),
                                                                 inServiceExit    := inPayrollTypeID < 0,
                                                                 inSession        := inSession)
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementID
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.ParentId = vbMovementItemID
        AND MovementItem.Amount = date_part('DAY',  inOperDate)::Integer;
    ELSE

      IF COALESCE (inUnitId, 0) = 0
      THEN

         SELECT ObjectLink_Member_Unit.ChildObjectId
         INTO inUnitId
         FROM ObjectLink AS ObjectLink_User_Member

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

         WHERE ObjectLink_User_Member.ObjectId =inUserId
           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();

      END IF;

      PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule_Child(ioId             := 0, -- Ключ объекта <Элемент документа>
                                                                 inMovementId     := inMovementID, -- ключ Документа
                                                                 inParentId       := vbMovementItemID, -- элемент мастер
                                                                 inUnitId         := inUnitId, -- подразделение
                                                                 inAmount         := date_part('DAY',  inOperDate)::Integer, -- День недели
                                                                 inPayrollTypeID  := inPayrollTypeID,
                                                                 inDateStart      := vbDateStart, -- Дата время начала смены
                                                                 inDateEnd        := vbDateEnd, -- Дата время конца счены
                                                                 inServiceExit    := inPayrollTypeID < 0,  -- Служебный выход
                                                                 inSession        := inSession);

    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
25.09.19                                                        *

*/
