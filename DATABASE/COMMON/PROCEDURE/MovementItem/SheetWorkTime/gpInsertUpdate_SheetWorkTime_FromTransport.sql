-- Function: gpInsertUpdate_SheetWorkTime_FromTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_SheetWorkTime_FromTransport(INTEGER, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_SheetWorkTime_FromTransport(
    IN inUnitId              Integer   , -- Подразделение
    IN inOperDate            TDateTime , -- дата установки часов
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbStartDate TDateTime;
          vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     
     --if lpGetUserBySession (inSession) = 5 then inSession:= '8551773'; END IF;

     vbStartDate := date_trunc('month', inOperDate)                            ;    -- первое число месяца
     vbEndDate := vbStartDate + interval '1 month' - interval '1 microseconds' ;    -- последнее число месяца


    -- обнулили
    PERFORM
           gpInsertUpdate_MovementItem_SheetWorkTime (inMemberId          := tmpMI.MemberId         -- Ключ физ. лицо
                                                    , inPositionId        := tmpMI.PositionId       -- Должность
                                                    , inPositionLevelId   := tmpMI.PositionLevelId  -- Разряд
                                                    , inUnitId            := inUnitId               -- Подразделение
                                                    , inPersonalGroupId   := tmpMI.PersonalGroupId  -- Группировка Сотрудника
                                                    , inStorageLineId     := tmpMI.StorageLineId    -- линия произв-ва
                                                    , inOperDate          := tmpMI.OperDate         -- дата установки часов
                                                    , ioValue             := '0'
                                                    , ioTypeId            := zc_Enum_WorkTimeKind_Work()
                                                    , ioWorkTimeKindId_key:= NULL :: Integer
                                                    , inIsPersonalGroup   := FALSE                  -- используется при сохранении из списка бригад
                                                    , inSession           := inSession              -- сессия пользователя
                                                     )
       FROM (WITH tmpTransport AS (SELECT DISTINCT COALESCE (View_PersonalDriver.MemberId, 0)        AS MemberId
                                               /*, COALESCE (View_PersonalDriver.PositionId, 0)      AS PositionId
                                                 , COALESCE (View_PersonalDriver.PositionLevelId, 0) AS PositionLevelId
                                                 , COALESCE (View_PersonalDriver.PersonalGroupId, 0) AS PersonalGroupId
                                                 , COALESCE (View_PersonalDriver.StorageLineId, 0)   AS StorageLineId
                                                 , Movement.OperDate*/
                                   FROM Movement
                                        LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                                                ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                                               AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                                        LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                                                ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                                               AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
                                        JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                                               AND MovementLinkObject_PersonalDriver.DescId  IN (zc_MovementLinkObject_PersonalDriver()
                                                                                                               , zc_MovementLinkObject_PersonalDriverMore()
                                                                                                               , zc_MovementLinkObject_Personal()
                                                                                                                )
                                        JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
                                   WHERE Movement.DescId = zc_Movement_Transport()
                                     AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                     AND View_PersonalDriver.UnitId = inUnitId
                                  )
   , tmpMI AS (SELECT Movement.OperDate
                    , COALESCE (MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                    , COALESCE (MIObject_Position.ObjectId, 0)       AS PositionId
                    , COALESCE (MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                    , COALESCE (MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                    , COALESCE (MIObject_StorageLine.ObjectId, 0)    AS StorageLineId
               FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                           AND MovementLinkObject_Unit.ObjectId   = inUnitId
                    JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                         AND MI_SheetWorkTime.isErased = FALSE
                    LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position()
                    LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                    LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                    LEFT JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                     ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_StorageLine.DescId         = zc_MILinkObject_StorageLine()
                    INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                      ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                     AND MIObject_WorkTimeKind.DescId         = zc_MILinkObject_WorkTimeKind() 
                                                     AND MIObject_WorkTimeKind.ObjectId       = zc_Enum_WorkTimeKind_Work() 
               WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                 AND Movement.DescId   = zc_Movement_SheetWorkTime()
              )
             SELECT tmpMI.OperDate
                  , tmpMI.MemberId
                  , tmpMI.PositionId
                  , tmpMI.PositionLevelId
                  , tmpMI.PersonalGroupId
                  , tmpMI.StorageLineId
             FROM tmpMI
                  INNER JOIN tmpTransport ON tmpTransport.MemberId        = tmpMI.MemberId
                                         /*AND tmpTransport.OperDate        = tmpMI.OperDate
                                         AND tmpTransport.PositionId      = tmpMI.PositionId
                                         AND tmpTransport.PositionLevelId = tmpMI.PositionLevelId
                                         AND tmpTransport.PersonalGroupId = tmpMI.PersonalGroupId
                                         AND tmpTransport.StorageLineId   = tmpMI.StorageLineId*/
             --WHERE tmpTransport.OperDate IS NULL
            ) AS tmpMI;

    -- PersonalDriver
    PERFORM
           gpInsertUpdate_MovementItem_SheetWorkTime(
              inMemberId        := View_PersonalDriver.MemberId        , -- Ключ физ. лицо
              inPositionId      := View_PersonalDriver.PositionId      , -- Должность
              inPositionLevelId := View_PersonalDriver.PositionLevelId , -- Разряд
              inUnitId          := inUnitId                            , -- Подразделение
              inPersonalGroupId := View_PersonalDriver.PersonalGroupId , -- Группировка Сотрудника
              inStorageLineId   := View_PersonalDriver.StorageLineId   , -- линия произв-ва
              inOperDate        := Movement.OperDate                   , -- дата установки часов
              ioValue           := SUM (CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat))::TVarChar                    , -- часы
              ioTypeId          := zc_Enum_WorkTimeKind_Work()         ,
              ioWorkTimeKindId_key:= NULL,
              inisPersonalGroup := FALSE                               , -- используется при сохранении из списка бригад
              inSession         := inSession)    -- сессия пользователя
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
            JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                    ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
         AND Movement.StatusId = zc_enum_status_complete()
         AND View_PersonalDriver.unitid = inUnitId
       GROUP BY
             Movement.OperDate
           , View_PersonalDriver.memberid
           , View_PersonalDriver.positionid
           , View_PersonalDriver.positionlevelid
           , View_PersonalDriver.personalgroupid
           , View_PersonalDriver.StorageLineId;

    -- PersonalDriver
    PERFORM
           gpInsertUpdate_MovementItem_SheetWorkTime(
              inMemberId        := View_PersonalDriver.MemberId        , -- Ключ физ. лицо
              inPositionId      := View_PersonalDriver.PositionId      , -- Должность
              inPositionLevelId := View_PersonalDriver.PositionLevelId , -- Разряд
              inUnitId          := inUnitId                            , -- Подразделение
              inPersonalGroupId := View_PersonalDriver.PersonalGroupId , -- Группировка Сотрудника
              inStorageLineId   := View_PersonalDriver.StorageLineId   , -- линия произв-ва
              inOperDate        := Movement.OperDate                   , -- дата установки часов
              ioValue           := SUM(CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat))::TVarChar                    , -- часы
              ioTypeId          := zc_Enum_WorkTimeKind_Work()         ,
              ioWorkTimeKindId_key:= NULL,
              inisPersonalGroup := FALSE                               , -- используется при сохранении из списка бригад
              inSession         := inSession)    -- сессия пользователя
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
            JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                    ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriverMore()
            JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
         AND Movement.StatusId = zc_enum_status_complete()
         AND View_PersonalDriver.unitid = inUnitId
       GROUP BY
             Movement.OperDate
           , View_PersonalDriver.memberid
           , View_PersonalDriver.positionid
           , View_PersonalDriver.positionlevelid
           , View_PersonalDriver.personalgroupid
           , View_PersonalDriver.StorageLineId;


    -- Personal
    PERFORM
           gpInsertUpdate_MovementItem_SheetWorkTime(
              inMemberId        := View_PersonalDriver.MemberId        , -- Ключ физ. лицо
              inPositionId      := View_PersonalDriver.PositionId      , -- Должность
              inPositionLevelId := View_PersonalDriver.PositionLevelId , -- Разряд
              inUnitId          := inUnitId                            , -- Подразделение
              inPersonalGroupId := View_PersonalDriver.PersonalGroupId , -- Группировка Сотрудника
              inStorageLineId   := View_PersonalDriver.StorageLineId   , -- линия произв-ва
              inOperDate        := Movement.OperDate                   , -- дата установки часов
              ioValue           := SUM(CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat))::TVarChar                    , -- часы
              ioTypeId          := zc_Enum_WorkTimeKind_Work()         ,
              ioWorkTimeKindId_key:= NULL,
              inisPersonalGroup := FALSE                               , -- используется при сохранении из списка бригад
              inSession         := inSession)    -- сессия пользователя
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                    ON MovementFloat_HoursWork.MovementId =  Movement.Id
                                   AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
            LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                    ON MovementFloat_HoursAdd.MovementId =  Movement.Id
                                   AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
            JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                    ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                   AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_Personal()
            JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
         AND Movement.StatusId = zc_enum_status_complete()
         AND View_PersonalDriver.unitid = inUnitId
       GROUP BY
             Movement.OperDate
           , View_PersonalDriver.memberid
           , View_PersonalDriver.positionid
           , View_PersonalDriver.positionlevelid
           , View_PersonalDriver.personalgroupid
           , View_PersonalDriver.StorageLineId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03,03,22         *
 26.05.17         * add StorageLine
 25.02.14                         * Replace inPersonalId <> inMemberId

*/

-- тест
-- SELECT * FROM gpInsertUpdate_SheetWorkTime_FromTransport (, inSession:= '2')
