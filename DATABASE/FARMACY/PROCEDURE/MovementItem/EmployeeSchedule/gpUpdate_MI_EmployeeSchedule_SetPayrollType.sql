-- Function: gpUpdate_MI_EmployeeSchedule_SetPayrollType()

DROP FUNCTION IF EXISTS gpUpdate_MI_EmployeeSchedule_SetPayrollType (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_EmployeeSchedule_SetPayrollType(
    IN inMovementId            Integer    , -- Ключ объекта <Документ продажи>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeSchedule());
    vbUserId := inSession;

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 4183126, 235009)
    THEN
      RAISE EXCEPTION 'Изменение <График работы кассиров> вам запрещено.';
    END IF;

    PERFORM  lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := MovementItem.Id
                                                               , inMovementId          := MovementItem.MovementId
                                                               , inParentId            := MovementItem.ParentId
                                                               , inUnitId              := MovementItem.ObjectId
                                                               , inAmount              := MovementItem.Amount  
                                                               , inPayrollTypeID       := CASE WHEN Object_Position.ObjectCode = 2
                                                                                               THEN zc_Enum_PayrollType_WorkS()
                                                                                               WHEN MIDate_End.ValueData::Time >= '18:30:00'
                                                                                               THEN zc_Enum_PayrollType_WorkCS()
                                                                                               ELSE zc_Enum_PayrollType_WorkAS() END
                                                               , inDateStart           := MIDate_Start.ValueData
                                                               , inDateEnd             := MIDate_End.ValueData
                                                               , inServiceExit         := COALESCE(MIBoolean_ServiceExit.ValueData, FALSE)  
                                                               , inUserId              := vbUserId)
    FROM MovementItem

         INNER JOIN MovementItem AS MIMaster
                                 ON MIMaster.Id = MovementItem.ParentId
                                AND MIMaster.DescId = zc_MI_Master()

         INNER JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = MIMaster.ObjectId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

         INNER JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
         INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

         LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                       ON MIBoolean_ServiceExit.MovementItemId = MovementItem.Id
                                      AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

         LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                          ON MILinkObject_PayrollType.MovementItemId = MovementItem.Id
                                         AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

         LEFT JOIN ObjectString AS PayrollType_ShortName
                                ON PayrollType_ShortName.ObjectId = MILinkObject_PayrollType.ObjectId
                               AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

         LEFT JOIN MovementItemDate AS MIDate_Start
                                    ON MIDate_Start.MovementItemId = MovementItem.Id
                                   AND MIDate_Start.DescId = zc_MIDate_Start()

         LEFT JOIN MovementItemDate AS MIDate_End
                                    ON MIDate_End.MovementItemId = MovementItem.Id
                                   AND MIDate_End.DescId = zc_MIDate_End()
                                                            
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Child()
      AND COALESCE (MILinkObject_PayrollType.ObjectId, 0) = 0
      AND Object_Position.ObjectCode in (1, 2)
      AND COALESCE (MIDate_Start.MovementItemId, 0) <> 0
      AND COALESCE (MIDate_End.MovementItemId, 0) <> 0
      AND COALESCE(MIBoolean_ServiceExit.ValueData, FALSE)  = FALSE
      AND MIDate_Start.ValueData IS NOT NULL
      AND MIDate_End.ValueData IS NOT NULL
      AND date_trunc('DAY', MIDate_End.ValueData) = date_trunc('DAY', MIDate_Start.ValueData);
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.09.21                                                        *
*/

-- select * from gpUpdate_MI_EmployeeSchedule_SetPayrollType(inMovementId := 24861838 ,  inSession := '3');