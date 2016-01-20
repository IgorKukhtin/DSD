-- Function: gpMI_SheetWorkTime_SetErased()

DROP FUNCTION IF EXISTS gpMI_SheetWorkTime_SetErased(Integer, Integer, Integer, Integer, Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpMI_SheetWorkTime_SetErased(   
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
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
    CREATE TEMP TABLE tmpMI (MovementItemId Integer) ON COMMIT DROP;

    -- все данные по этому сотруднику + ...
    INSERT INTO tmpMI (MovementItemId)
                         SELECT MI_SheetWorkTime.Id 
                         FROM tmpOperDate
                              INNER JOIN Movement ON Movement.OperDate = tmpOperDate.OperDate
                                                AND Movement.DescId = zc_Movement_SheetWorkTime()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitId
                              INNER JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                          AND MI_SheetWorkTime.ObjectId  = inMemberId
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_Position.ObjectId, 0) = COALESCE (inPositionId, 0)
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                        ;

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
