-- Function: gpInsert_MI_PersonalGroup()

DROP FUNCTION IF EXISTS gpInsert_MI_PersonalGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_PersonalGroup(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbPersonalGroupId Integer;
   DECLARE vbPairDayId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());

     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.isErased = False AND MI.MovementId = inMovementId)
     THEN
          RAISE EXCEPTION 'Ошибка.Строчная часть документа уже заполнена';   --, lfGet_Object_ValueData ();
     END IF;

     --данные из шапки документа
     SELECT MovementLinkObject_Unit.ObjectId          AS UnitId
          , MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
          , MovementLinkObject_PairDay.ObjectId       AS PairDayId
          , Movement.OperDate                         AS OperDate
    INTO vbUnitId, vbPersonalGroupId, vbPairDayId, vbOperDate
     FROM MovementLinkObject AS MovementLinkObject_Unit
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                       ON MovementLinkObject_PersonalGroup.MovementId = MovementLinkObject_Unit.MovementId
                                      AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                       ON MovementLinkObject_PairDay.MovementId = MovementLinkObject_Unit.MovementId
                                      AND MovementLinkObject_PairDay.DescId = zc_MovementLinkObject_PairDay()

          LEFT JOIN Movement ON Movement.Id = inMovementId
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

   
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_PersonalGroup (ioId              := 0
                                                      , inMovementId      := inMovementId
                                                      , inPersonalId      := tmp.PersonalId
                                                      , inPositionId      := tmp.PositionId
                                                      , inPositionLevelId := tmp.PositionLevelId
                                                      , inWorkTimeKindId  := CASE WHEN vbPairDayId = 7438170 THEN zc_Enum_WorkTimeKind_WorkD() -- день
                                                                                  WHEN vbPairDayId = 7438171 THEN zc_Enum_WorkTimeKind_WorkN() -- ночь
                                                                                  ELSE zc_Enum_WorkTimeKind_WorkD()--день
                                                                             END
                                                      , inAmount          := tmp.HoursDay
                                                      , inUserId          := vbUserId
                                                      ) 
     FROM (WITH tmpPersonal AS (SELECT lfSelect.MemberId
                                     , lfSelect.PersonalId
                                     , lfSelect.PositionId
                                     , ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                                FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                     INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                           ON ObjectLink_Personal_PersonalGroup.ObjectId = lfSelect.PersonalId
                                                          AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                                          AND ObjectLink_Personal_PersonalGroup.ChildObjectId = vbPersonalGroupId
     
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                          ON ObjectLink_Personal_PositionLevel.ObjectId = lfSelect.PersonalId
                                                         AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                                WHERE lfSelect.UnitId = vbUnitId
                                 AND (lfSelect.DateOut >= vbOperDate
                                  AND lfSelect.DateIn  <= vbOperDate)
                               )
                -- штатное расписание №2Дневной план на человека 
              , tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
                                      , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
                                      , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
                                      , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0))::TFloat AS HoursDay
                                 FROM Object AS Object_StaffList
                                       INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
                                       LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                                            ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                                           AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
            
                                       LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                                            ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                                           AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit() 
                                       LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                                             ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                                                            AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
                                   WHERE Object_StaffList.DescId = zc_Object_StaffList()
                                    AND Object_StaffList.isErased = False
                                  GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                                         , ObjectLink_StaffList_Position.ChildObjectId
                                         , ObjectLink_StaffList_PositionLevel.ChildObjectId
                       --HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                       )
                -- Нужно найти сотрудников кто в отпуске в єтот день
              , tmpMov_Holiday AS (SELECT Movement.Id
                                     FROM MovementDate AS MovementDate_BeginDateStart
                                          INNER JOIN Movement ON Movement.Id = MovementDate_BeginDateStart.MovementId
                                                             AND Movement.DescId = zc_Movement_MemberHoliday()
                                                             AND Movement.StatusId = zc_Enum_Status_Complete()
             
                                          INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                                                  ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                                 AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()
                                                                 AND MovementDate_BeginDateEnd.ValueData >= vbOperDate
             
                                     WHERE MovementDate_BeginDateStart.MovementId = Movement.Id
                                       AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()
                                       AND MovementDate_BeginDateStart.ValueData <= vbOperDate
                                     )
               , tmpHoliday AS (SELECT DISTINCT ObjectLink_Personal_Member.ObjectId  AS PersonalId
                                FROM tmpMov_Holiday
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                                  ON MovementLinkObject_Member.MovementId = tmpMov_Holiday.Id
                                                                 AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ChildObjectId = MovementLinkObject_Member.ObjectId
                                                         AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                )
               --уволенные
               
            -- для сотрудников получаем данніе из штатного
            SELECT tmpPersonal.PersonalId
                 , tmpPersonal.PositionId
                 , tmpPersonal.PositionLevelId
               --, COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay, 0) AS HoursDay
                 , 0 AS HoursDay
            FROM tmpPersonal    
                 LEFT JOIN tmpHoliday ON tmpHoliday.PersonalId = tmpPersonal.PersonalId
                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmpPersonal.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmpPersonal.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = vbUnitId
                 -- второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmpPersonal.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmpPersonal.PositionLevelId,0)
                                       AND tmpStaffList.PositionId IS NULL
            WHERE tmpHoliday.PersonalId IS NULL
            ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.21         *
*/

-- тест
--


/* заполнение тустого типа раб. времени в сохр. документах
WITH
tmpMovement AS (SELECT Movement.Id 
                     , MovementLinkObject_PairDay.ObjectId AS PairDayId
                FROM Movement
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                 ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                AND MovementLinkObject_PairDay.DescId = zc_MovementLinkObject_PairDay()
                WHERE Movement.DescId = zc_Movement_PersonalGroup()
                  AND Movement.StatusId <>zc_Enum_Status_Erased() 
                  )
  
, tmpMI AS (SELECT MovementItem.*
                 
            FROM MovementItem
                
            WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
              AND MovementItem.DescId = zc_MI_Master()
              AND MovementItem.isErased = FALSE

            )

, tmpMILO AS (SELECT MovementItemLinkObject.*
              FROM MovementItemLinkObject
              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
              and MovementItemLinkObject.DescId = zc_MILinkObject_WorkTimeKind()
              )

SELECT tmpMovement.Id AS MovementId
     , tmpMovement.PairDayId
     , tmpMI.Id AS MI_Id
     , CASE WHEN tmpMovement.PairDayId = 7438171 THEN zc_Enum_WorkTimeKind_WorkN() -- ночь
            ELSE zc_Enum_WorkTimeKind_WorkD()--день
       END
     , MILinkObject_WorkTimeKind.ObjectId AS WorkTimeKindId
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind()
                                            , tmpMI.Id
                                            , CASE WHEN tmpMovement.PairDayId = 7438171 THEN zc_Enum_WorkTimeKind_WorkN() -- ночь
                                                   ELSE zc_Enum_WorkTimeKind_WorkD()--день
                                              END
                                              )
FROM tmpMovement
     INNER JOIN tmpMI ON tmpMI.MovementId = tmpMovement.Id
 LEFT JOIN tmpMILO AS MILinkObject_WorkTimeKind
                                                  ON MILinkObject_WorkTimeKind.MovementItemId = tmpMI.Id 
                                                 AND MILinkObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
WHERE MILinkObject_WorkTimeKind.ObjectId IS NULL

*/