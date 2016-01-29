-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inOperDate            TDateTime , -- дата
 INOUT ioValue               TVarChar  , -- часы
 INOUT ioTypeId              Integer   , 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


    IF (ioValue = '0' OR TRIM (ioValue) = '')
    THEN
         ioTypeId := 0;
         vbValue  := 0;
    ELSE

        -- RAISE EXCEPTION '"%"  %  ', vbValue, POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId));

        IF EXISTS (SELECT 1
                   FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                   WHERE ObjectString_WorkTimeKind_ShortName.ValueData = UPPER (TRIM (ioValue))
                     AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                  )
        THEN
            ioTypeId:= (SELECT ObjectString_WorkTimeKind_ShortName.ObjectId
                        FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                        WHERE ObjectString_WorkTimeKind_ShortName.ValueData = UPPER (TRIM (ioValue))
                          AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                       );
            --
            vbValue:= 0;
        ELSE
/*        IF (vbValue >= 0 AND vbValue <= 24 AND POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId)) = 1) --  AND zfConvert_StringToNumber (ioValue) > 0)
        OR (ioTypeId = 0 AND vbValue >= 0 AND vbValue <= 24)
        THEN
*/
           ioTypeId := CASE WHEN COALESCE (ioTypeId, 0) = 0 OR POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId)) = 0
                                 THEN zc_Enum_WorkTimeKind_Work()
                            ELSE ioTypeId
                       END;
        vbValue := zfConvert_ViewWorkHourToHour (ioValue);

        END IF;

    END IF;

    -- Для начала определим ID Movement, если таковой имеется. Ключом будет OperDate и UnitId
    vbMovementId := (SELECT Movement_SheetWorkTime.Id
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                     WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() AND Movement_SheetWorkTime.OperDate = inOperDate
                    );
 
    -- сохранили <Документ>
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_SheetWorkTime(vbMovementId, '', inOperDate::DATE, inUnitId);
    END IF;

    -- Поиск MovementItemId
    vbMovementItemId := (SELECT MI_SheetWorkTime.Id 
                         FROM MovementItem AS MI_SheetWorkTime
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
                          WHERE 
                              MI_SheetWorkTime.MovementId = vbMovementId AND
                              MI_SheetWorkTime.ObjectId = inMemberId);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_SheetWorkTime (inMovementItemId      := vbMovementItemId  -- Ключ объекта <Элемент документа>
                                                     , inMovementId          := vbMovementId      -- ключ Документа
                                                     , inMemberId            := inMemberId        -- Физ. лицо
                                                     , inPositionId          := inPositionId      -- Должность
                                                     , inPositionLevelId     := inPositionLevelId -- Разряд
                                                     , inPersonalGroupId     := inPersonalGroupId -- Группировка Сотрудника
                                                     , inAmount              := vbValue           -- Количество часов факт
                                                     , inWorkTimeKindId      := ioTypeId          -- Типы рабочего времени
                                                      );

    -- 
    ioValue := zfGet_ViewWorkHour (vbValue, ioTypeId);
                         

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.01.14                         * Replace inPersonalId <> inMemberId
 25.11.13                         * Add inPositionLevelId
 17.10.13                         *
 03.10.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')
