-- Function: gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType ()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType(
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inUserID              Integer   , -- Сотрудник
    IN inUnitId              Integer   , -- подразделение
    IN inPayrollTypeID       Integer   , -- Тип начисления
    IN inDateStart           TDateTime , -- Дата время начала смены
    IN inDateEnd             TDateTime , -- Дата время конца счены
    IN inSession             TVarChar   -- пользователь
 )
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbId       Integer;
   DECLARE vbAmount   Integer;
   DECLARE vbOperDate TDateTime;

BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;
   
    vbAmount := date_part('DAY', inDateStart);
    vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.ID = inMovementId);

    IF date_trunc('month', inDateStart) <> vbOperDate
    THEN
      RAISE EXCEPTION 'Ошибка. Дата <%> не входит в период действия графика <%>.', inDateStart, vbOperDate;
    END IF;


    IF date_trunc('day', inDateStart) <> date_trunc('day', inDateEnd)
    THEN
      RAISE EXCEPTION 'Ошибка. Дата прихода <%> и ухода <%> должны быть в одном дне.', inDateStart, inDateEnd;
    END IF;

    -- Если по аптеке уже есть zc_MI_Child()
    IF EXISTS(SELECT 1 
              FROM MovementItem

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                                    ON MILinkObject_PayrollType.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

              WHERE MovementItem.MovementID = inMovementId
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ObjectId = inUnitId
                AND MovementItem.ParentId = inParentId
                AND MovementItem.Amount = vbAmount
                AND COALESCE(MILinkObject_PayrollType.ObjectId, 0) = inPayrollTypeID)
    THEN
      RAISE EXCEPTION 'Ошибка. В дне по подразделению уже есть запись.';
    END IF;

    -- сохранили
    vbId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := 0                     -- Ключ объекта <Элемент документа>
                                                              , inMovementId          := inMovementId          -- ключ Документа
                                                              , inParentId            := inParentId
                                                              , inUnitId              := inUnitId
                                                              , inAmount              := vbAmount
                                                              , inPayrollTypeID       := inPayrollTypeID
                                                              , inDateStart           := inDateStart
                                                              , inDateEnd             := inDateEnd
                                                              , inServiceExit         := False
                                                              , inUserId              := vbUserId              -- пользователь
                                                               );

--    RAISE EXCEPTION 'Прошло.';

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.09.19                                                        *
 31.09.19                                                        *
*/

-- тест
-- select * from gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType(inMovementId := 17692072 , inParentId := 363753684 , inUserID := 12198759 , inUnitID := 377574 , inPayrollTypeID := 14976313 , inDateStart := ('19.08.2020 15:00:00')::TDateTime , inDateEnd := ('19.08.2020 18:00:00')::TDateTime ,  inSession := '3');
