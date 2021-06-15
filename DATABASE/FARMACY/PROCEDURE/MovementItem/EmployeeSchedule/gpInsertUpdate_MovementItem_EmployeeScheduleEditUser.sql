-- Function: gpInsertUpdate_MovementItem_EmployeeScheduleEditUser()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeScheduleEditUser(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeScheduleEditUser(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа чилдрен>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentID            Integer   , -- Ключ объекта <Элемент документа мастер>
    IN inDay                 Integer   , -- День
    IN inUnitID              Integer   , -- Подразделение
    IN inPayrollTypeID       Integer   , -- Тип дня
    IN inTimeStart           TVarChar  , -- Время прихода
    IN inTimeEnd             TVarChar  , -- Время ухода
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbServiceExit Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    IF COALESCE (inMovementId, 0) = 0 OR COALESCE (inParentID, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. График не сохранен.';
    ELSE
      SELECT date_trunc('MONTH', Movement.OperDate)
      INTO vbDate
      FROM Movement
      WHERE Movement.Id = inMovementId;
    END IF;
    
    IF inPayrollTypeID >= 0 AND inTimeStart <> ''
    THEN
       vbDateStart := date_trunc('DAY', vbDate)::Date + ((inDay - 1)::TVarChar||' DAY')::interval + inTimeStart::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30) 
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      vbDateStart := Null;
    END IF;

    IF inPayrollTypeID >= 0 AND inTimeEnd <> ''
    THEN
       vbDateEnd := date_trunc('DAY', vbDate)::Date + ((inDay - 1)::TVarChar||' DAY')::interval + inTimeEnd::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      vbDateEnd := Null;
    END IF;
      
    IF inPayrollTypeID >= 0 AND inTimeStart <> '' and inTimeEnd <> '' and vbDateStart > vbDateEnd
    THEN
      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;
    
    IF inPayrollTypeID < 0
    THEN
      vbServiceExit := True;
      inPayrollTypeID := 0;
    ELSE
      vbServiceExit := False;    
    END IF;
    
    -- сохранили
    ioId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                                              , inMovementId          := inMovementId          -- ключ Документа
                                                              , inParentId            := inParentID            -- элемент мастер
                                                              , inUnitID              := inUnitID              -- Подразделение
                                                              , inAmount              := inDay                 -- День
                                                              , inPayrollTypeID       := inPayrollTypeID       -- Тип дня
                                                              , inDateStart           := vbDateStart           -- Приходы на работу по дням
                                                              , inDateEnd             := vbDateEnd             -- Приходы на работу по дням
                                                              , inServiceExit         := vbServiceExit         -- Служебный выход
                                                              , inUserId              := vbUserId              -- пользователь
                                                                );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
05.09.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_EmployeeScheduleEditUser (, inSession:= '2')

