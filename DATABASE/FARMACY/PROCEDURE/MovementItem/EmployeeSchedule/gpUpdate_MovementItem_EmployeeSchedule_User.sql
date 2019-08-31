-- Function: gpUpdate_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_EmployeeSchedule_User(TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_EmployeeSchedule_User(
    IN inOperDate            TDateTime,  -- Дата
    IN inValueUser           TVarChar,   -- Время прихода
    IN inTimeStart           TVarChar,   -- Время прихода
    IN inTimeEnd             TVarChar,   -- Время прихода
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
   DECLARE vbComingValueDay TVarChar;
   DECLARE vbTypeId Integer;
   DECLARE vbValue Integer;
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

    IF inValueUser = '7:00' AND vbUnitId NOT IN (2886778)
    THEN
      RAISE EXCEPTION 'Ошибка. Время прихода 7:00 вам устанавлтивать запрещено.';
    END IF;

    -- проверка наличия графика
    IF NOT EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', inOperDate)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
      RAISE EXCEPTION 'Ошибка. График работы сотрудеиков не найден. Обратитесь к Романовой Т.В.';
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

    SELECT MovementItemString.ValueData
    INTO vbComingValueDay
    FROM MovementItemString
    WHERE MovementItemString.DescId = zc_MIString_ComingValueDayUser()
      AND MovementItemString.MovementItemId = vbMovementItemID;

    IF COALESCE (vbComingValueDay, '') = ''
    THEN
      vbComingValueDay := '0000000000000000000000000000000';
    END IF;

    vbTypeId :=  date_part('day', inOperDate);

    vbValue := CASE inValueUser WHEN '8:00' THEN 1
                                WHEN '9:00' THEN 2
                                WHEN '10:00' THEN 3
                                WHEN '7:00' THEN 4
                                WHEN '12:00' THEN 5
                                WHEN '21:00' THEN 7
                                WHEN 'В' THEN 9
                                ELSE 0 END;

    IF SUBSTRING(vbComingValueDay, vbTypeId, 1) <> '0' AND  SUBSTRING(vbComingValueDay, vbTypeId, 1)::Integer <> vbValue
    THEN
      RAISE EXCEPTION 'Вы уже поставили отметку, повторная попытка не предусмотрена!';
    END IF;

    vbComingValueDay := SUBSTRING(vbComingValueDay, 1, vbTypeId - 1) || vbValue::TVarChar || SUBSTRING(vbComingValueDay, vbTypeId + 1, 31);

    -- сохранили <приходы по дням сотрудника>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDayUser(), vbMovementItemID, vbComingValueDay);

    IF inTimeStart <> '' OR inTimeEnd <> ''
    THEN
      IF inTimeStart = '' OR inTimeEnd = ''
      THEN
        RAISE EXCEPTION 'Ошибка. Должно быть заполнено время прихода и ухода.';
      END IF;

      vbDateStart := date_trunc('DAY', inOperDate) + inTimeStart::Time;
      vbDateEnd := date_trunc('DAY', inOperDate) + inTimeEnd::Time;
      
      IF vbDateStart > vbDateEnd
      THEN
        vbDateEnd := vbDateEnd + interval '1 day';
      END IF;
      
      IF date_part('minute',  vbDateStart) not in (0, 30) AND date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны получасу.';
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
