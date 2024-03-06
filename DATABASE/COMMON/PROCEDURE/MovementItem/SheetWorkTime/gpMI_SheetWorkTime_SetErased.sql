-- Function: gpMI_SheetWorkTime_SetErased()

-- DROP FUNCTION IF EXISTS gpMI_SheetWorkTime_SetErased(Integer, Integer, Integer, Integer, Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpMI_SheetWorkTime_SetErased(Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpMI_SheetWorkTime_SetErased(   
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inWorkTimeKindId_key  Integer   ,
    IN inOperDate            TDateTime , -- дата (месяц, за который будут удалены все данные по этому сотруднику + ...)
 INOUT ioIsErased            Boolean   , -- новое значение
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_SheetWorkTime());

    -- 
    CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
       SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

    -- 
    CREATE TEMP TABLE tmpMI (MovementItemId Integer, OperDate TDateTime) ON COMMIT DROP;

    -- все данные по этому сотруднику + ...
    INSERT INTO tmpMI (MovementItemId, OperDate)
                         SELECT MI_SheetWorkTime.Id, Movement.OperDate
                         FROM tmpOperDate
                              INNER JOIN Movement ON Movement.OperDate = tmpOperDate.OperDate
                                                 AND Movement.DescId = zc_Movement_SheetWorkTime()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitId
                              INNER JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                         AND MI_SheetWorkTime.isErased   = ioIsErased
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                              -- нужно учитывать тип Раб. времени только при вызове из док. список бригад
                              LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                               ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                              AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                         WHERE COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                           AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                           AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                           --
                           AND (inUnitId <> 8451 OR (inUnitId = 8451 AND MIObject_WorkTimeKind.ObjectId = inWorkTimeKindId_key))
                        ;

    -- Проверка - период закрыт
    IF  EXISTS (SELECT 1
                FROM tmpMI
                     INNER JOIN Movement ON Movement.DescId = zc_Movement_SheetWorkTimeClose()
                                        AND Movement.OperDate <= tmpMI.OperDate
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                     INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                             ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                            AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                                            AND MovementDate_OperDateEnd.ValueData >= tmpMI.OperDate
                     LEFT JOIN MovementDate AS MovementDate_TimeClose
                                            ON MovementDate_TimeClose.MovementId = Movement.Id
                                           AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                     LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                               ON MovementBoolean_Closed.MovementId = Movement.Id
                                              AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
                     LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                               ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                              AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()
                     LEFT JOIN MovementLinkObject AS MLO_Unit
                                                  ON MLO_Unit.MovementId = Movement.Id
                                                 AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                     LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAll
                                               ON MovementBoolean_ClosedAll.MovementId = Movement.Id
                                              AND MovementBoolean_ClosedAll.DescId     = zc_MovementBoolean_ClosedAll()
                WHERE (MovementBoolean_Closed.ValueData = TRUE
                    OR (MovementBoolean_ClosedAuto.ValueData = TRUE AND MovementDate_TimeClose.ValueData <= CURRENT_TIMESTAMP)
                      )
                  AND (COALESCE (MLO_Unit.ObjectId, 0)     <> COALESCE (inUnitId, 0)
                    OR MovementBoolean_ClosedAll.ValueData = TRUE
                      )
               )
     --OR vbUserId = 5
    THEN
        RAISE EXCEPTION 'Ошибка.Период закрыт с <%>.'
                      , (SELECT CASE WHEN MovementBoolean_ClosedAuto.ValueData = TRUE
                                          THEN zfConvert_DateTimeShortToString (MovementDate_TimeClose.ValueData)
                                     ELSE zfConvert_DateToString (MovementDate_OperDateEnd.ValueData)
                                END
                         FROM tmpMI
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_SheetWorkTimeClose()
                                                 AND Movement.OperDate <= tmpMI.OperDate
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                      ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                     AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                                                     AND MovementDate_OperDateEnd.ValueData >= tmpMI.OperDate
                              LEFT JOIN MovementDate AS MovementDate_TimeClose
                                                     ON MovementDate_TimeClose.MovementId = Movement.Id
                                                    AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                              LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                                        ON MovementBoolean_Closed.MovementId = Movement.Id
                                                       AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
                              LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                                        ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                                       AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()
                              LEFT JOIN MovementLinkObject AS MLO_Unit
                                                           ON MLO_Unit.MovementId = Movement.Id
                                                          AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                              LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAll
                                                        ON MovementBoolean_ClosedAll.MovementId = Movement.Id
                                                       AND MovementBoolean_ClosedAll.DescId     = zc_MovementBoolean_ClosedAll()
                         WHERE (MovementBoolean_Closed.ValueData = TRUE
                             OR (MovementBoolean_ClosedAuto.ValueData = TRUE AND MovementDate_TimeClose.ValueData <= CURRENT_TIMESTAMP)
                               )
                           AND (COALESCE (MLO_Unit.ObjectId, 0)     <> COALESCE (inUnitId, 0)
                             OR MovementBoolean_ClosedAll.ValueData = TRUE
                               )
                         LIMIT 1
                        )
                       ;
    END IF;

    -- устанавливаем новое значение
    IF ioIsErased = FALSE
    THEN
        PERFORM lpSetErased_MovementItem (inMovementItemId:= tmpMI.MovementItemId, inUserId:= vbUserId)
        FROM tmpMI;
    ELSE
        PERFORM lpSetUnErased_MovementItem (inMovementItemId:= tmpMI.MovementItemId, inUserId:= vbUserId)
        FROM tmpMI;
    END IF;

    ioIsErased:= NOT ioIsErased;
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.15         *
*/

-- тест
-- SELECT * FROM gpMI_SheetWorkTime_SetErased (, inSession:= '2')
