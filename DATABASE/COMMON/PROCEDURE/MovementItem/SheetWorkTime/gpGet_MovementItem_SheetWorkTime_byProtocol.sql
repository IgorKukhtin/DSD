-- Function: gpGet_MovementItem_SheetWorkTime_byProtocol()

-- DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime_byProtocol (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_SheetWorkTime_byProtocol (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_SheetWorkTime_byProtocol(
    IN inMemberId            Integer   , -- Ключ физ. лицо
    IN inPositionId          Integer   , -- Должность
    IN inPositionLevelId     Integer   , -- Разряд
    IN inUnitId              Integer   , -- Подразделение
    IN inPersonalGroupId     Integer   , -- Группировка Сотрудника
    IN inStorageLineId       Integer   , -- линия произ-ва
    IN inWorkTimeKindId      Integer   , -- 
    IN inOperDate            TDateTime , -- дата
   OUT outMovementId         Integer   , -- 
   OUT outMovementItemId     Integer   , 
   OUT outOperDate           TVarChar   , 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
BEGIN

    -- Для начала определим ID Movement, если таковой имеется. Ключом будет OperDate и UnitId
    outMovementId := (SELECT Movement_SheetWorkTime.Id
                      FROM Movement AS Movement_SheetWorkTime
                           JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                                   ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                  AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                                  AND MovementLinkObject_Unit.ObjectId = inUnitId
                      WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() AND Movement_SheetWorkTime.OperDate = inOperDate
                        --AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
                     );
 
    -- сохранили <Документ>
    IF COALESCE (outMovementId, 0) = 0
    THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
    END IF;

    -- Поиск MovementItemId
    outMovementItemId := (SELECT MI_SheetWorkTime.Id 
                          FROM MovementItem AS MI_SheetWorkTime
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                     ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine() 
                              LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                               ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                              AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                          WHERE MI_SheetWorkTime.MovementId = outMovementId
                            AND MI_SheetWorkTime.ObjectId   = inMemberId
                            AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                            AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                            AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                            AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                            AND (COALESCE (MIObject_WorkTimeKind.ObjectId, 0)  = COALESCE (inWorkTimeKindId, 0) OR inWorkTimeKindId = 0)
                         );
    outOperDate := zfConvert_DateShortToString(inOperDate)::TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.21         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_SheetWorkTime_byProtocol (inMemberId := 13117 , inPositionId := 12950 , inPositionLevelId := 0 , inUnitId := 8384 , inPersonalGroupId := 13551 , inStorageLineId := 0 , inWorkTimeKindId:= 0, inOperDate := ('01.10.2017')::TDateTime, inSession:= '5')
