-- Function: gpInsertUpdate_MovementItem_EmployeeScheduleNew()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeScheduleNew(INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeScheduleNew(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа мастер>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
 INOUT ioValue               TVarChar  , -- Тип дня
 INOUT ioValueStart          TVarChar  , -- Время прихода
 INOUT ioValueEnd            TVarChar  , -- Время ухода
 INOUT ioTypeId              Integer   , -- День
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitID Integer;
   DECLARE vbParentId Integer;

   DECLARE vbDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbPayrollType Integer;
   DECLARE vbServiceExit Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

/*     IF inSession <> '3'
     THEN
        RAISE EXCEPTION 'Ошибка. В разработке';
     END IF;
*/
    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066, 8037524)
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. График не сохранен.';
    ELSE
      SELECT date_trunc('MONTH', Movement.OperDate)
      INTO vbDate
      FROM Movement
      WHERE Movement.Id = inMovementId;
    END IF;
    
    IF COALESCE (ioId, 0) = 0 
       AND EXISTS(SELECT ID FROM MovementItem
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.ObjectId = inUserId
                    AND MovementItem.DescId = zc_MI_Master())
    THEN
      RAISE EXCEPTION 'Повторное создание графика по сотруднику запрещено.';    
    END IF;
    
    IF EXISTS(SELECT COALESCE (ObjectLink_Member_Unit.ChildObjectId, 0)
              FROM ObjectLink AS ObjectLink_User_Member

                   INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                        ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                       AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

              WHERE ObjectLink_User_Member.ObjectId = inUserId
                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member())
    THEN
       SELECT COALESCE (ObjectLink_Member_Unit.ChildObjectId, 0)
       INTO vbUnitID
       FROM ObjectLink AS ObjectLink_User_Member

            INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

       WHERE ObjectLink_User_Member.ObjectId = inUserId
         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();
    ELSE
       vbUnitID := 0;
    END IF;

    IF COALESCE(ioId, 0) = 0 AND vbUnitID = 0
    THEN
        RAISE EXCEPTION 'Ошибка. У физ. лица не заполнено подразделение.';
    END IF;    

    IF upper(ioValue) <> 'СВ' AND ioValueStart <> ''
    THEN
       vbDateStart := date_trunc('DAY', vbDate)::Date + ((ioTypeId - 1)::TVarChar||' DAY')::interval + ioValueStart::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30) 
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      vbDateStart := Null;
    END IF;

    IF upper(ioValue) <> 'СВ' AND ioValueEnd <> ''
    THEN
       vbDateEnd := date_trunc('DAY', vbDate)::Date + ((ioTypeId - 1)::TVarChar||' DAY')::interval + ioValueEnd::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Даты прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      vbDateEnd := Null;
    END IF;
      
    IF upper(ioValue) <> 'СВ' AND ioValueStart <> '' and ioValueEnd <> '' and vbDateStart > vbDateEnd
    THEN
      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;
    
    -- сохранили мастер если надо
    IF COALESCE(ioId, 0) = 0 
    THEN
      ioId := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := ioId                  -- Ключ объекта <Элемент мастера>
                                                          , inMovementId          := inMovementId          -- ключ Документа
                                                          , inPersonId            := inUserId              -- сотрудник
                                                          , inComingValueDay      := ''                    -- Приходы на работу по дням
                                                          , inComingValueDayUser  := ''                    -- Приходы на работу по дням
                                                          , inUserId              := vbUserId              -- пользователь
                                                            );
    ELSEIF vbUnitID <> 0 AND
           COALESCE((SELECT COALESCE (MovementItemLinkObject.ObjectId, 0) 
                     FROM MovementItemLinkObject 
                     WHERE MovementItemLinkObject.MovementItemId = ioId
                       AND MovementItemLinkObject.DescId = zc_MILinkObject_Unit())) = 0
    THEN
       -- сохранили связь с <Подразделением>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, vbUnitID);    
    END IF;
    
    IF EXISTS(SELECT ID
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ParentID = ioId
                AND MovementItem.Amount = ioTypeId
                AND MovementItem.DescId = zc_MI_Child())
    THEN
       SELECT ID
       INTO vbParentId
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.ParentID = ioId
         AND MovementItem.Amount = ioTypeId
         AND MovementItem.DescId = zc_MI_Child();
    END IF;

    IF COALESCE(vbParentId, 0) <> 0 AND COALESCE ((SELECT ObjectId FROM MovementItem WHERE ID = vbParentId), 0) <> 0
    THEN
       SELECT ObjectId 
       INTO vbUnitID
       FROM MovementItem WHERE ID = vbParentId;
    END IF;    
    
    vbServiceExit := False;
    IF upper(ioValue) = 'СВ' 
    THEN
      vbServiceExit := True;
      vbPayrollType := 0;
    ELSEIF ioValue <> '' AND 
       EXISTS(SELECT ValueData FROM ObjectString AS PayrollType_ShortName
              WHERE PayrollType_ShortName.ValueData = ioValue
                AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName())
    THEN
      SELECT ObjectId 
      INTO vbPayrollType
      FROM ObjectString AS PayrollType_ShortName
      WHERE PayrollType_ShortName.ValueData = ioValue
        AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName();
    ELSE
      vbPayrollType := 0;
    END IF;
    
    --RAISE EXCEPTION 'Ошибка. В разработке % % % % % %', vbParentId, vbUnitID, ioTypeId, vbPayrollType, vbDateStart, vbDateEnd;
        
    -- сохранили
    vbParentId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := vbParentId            -- Ключ объекта <Элемент документа>
                                                                    , inMovementId          := inMovementId          -- ключ Документа
                                                                    , inParentId            := ioId                  -- элемент мастер
                                                                    , inUnitID              := vbUnitID              -- Подразделение
                                                                    , inAmount              := ioTypeId              -- День
                                                                    , inPayrollTypeID       := vbPayrollType         -- Тип дня
                                                                    , inDateStart           := vbDateStart           -- Приходы на работу по дням
                                                                    , inDateEnd             := vbDateEnd             -- Приходы на работу по дням
                                                                    , inServiceExit         := vbServiceExit         -- Служебный выход
                                                                    , inUserId              := vbUserId              -- пользователь
                                                                     );

    --
    IF ioTypeId > 0
    THEN
       SELECT CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
              THEN PayrollType_ShortName.ValueData  ELSE 'СВ' END                          AS PThortName
            , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
              THEN TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')  ELSE '' END                 AS TimeStart
            , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
              THEN TO_CHAR(MIDate_End.ValueData, 'HH24:mi')  ELSE '' END                   AS TimeEnd
       INTO ioValue, ioValueStart, ioValueEnd 

       FROM  MovementItem AS MIChild

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                             ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                            AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

            LEFT JOIN ObjectString AS PayrollType_ShortName
                                   ON PayrollType_ShortName.ObjectId = MILinkObject_PayrollType.ObjectId
                                  AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

            LEFT JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MIChild.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start()

            LEFT JOIN MovementItemDate AS MIDate_End
                                       ON MIDate_End.MovementItemId = MIChild.Id
                                      AND MIDate_End.DescId = zc_MIDate_End()

            LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                          ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                         AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

       WHERE MIChild.ID = vbParentId;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
22.05.19                                                        *
13.03.19                                                        *
11.12.18                                                        *
09.12.18                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_EmployeeScheduleNew (, inSession:= '2')

