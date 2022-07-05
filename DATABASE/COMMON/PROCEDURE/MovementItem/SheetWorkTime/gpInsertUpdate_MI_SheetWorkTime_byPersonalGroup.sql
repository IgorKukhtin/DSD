-- Function: gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(
    IN inMovementId_pg     Integer   , -- ID Movement_PersonalGroup
    IN inIsDel             Boolean   , -- если проводим устанавливаем данные в табель (FALSE), если распроводим/удалем устанавливаем NULL (TRUE)
    IN inSession           TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDAte   TDateTime;
   DECLARE vbMemberId   Integer;
   DECLARE vbWorkTimeKindId Integer;
BEGIN
     vbUserId := lpGetUserBySession (inSession);

     -- автоматом проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind - при распроведении или удалении - в табеле удаляется WorkTimeKind
     -- vbWorkTimeKindId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_mh AND MovementLinkObject.DescId = zc_MovementLinkObject_WorkTimeKind());


     --     
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_pg);

     --
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(tmp.MemberId           :: Integer    -- Ключ физ. лицо
                                                     , tmp.PositionId         :: Integer    -- Должность
                                                     , tmp.PositionLevelId    :: Integer    -- Разряд
                                                     , tmp.UnitId             :: Integer    -- Подразделение
                                                     , tmp.PersonalGroupId    :: Integer    -- Группировка Сотрудника
                                                     , tmp.StorageLineId      :: Integer    -- линия произ-ва
                                                     , tmp.OperDate           :: TDateTime  -- дата
                                                     , COALESCE (tmp.Value,NULL)              :: TVarChar   -- часы
                                                     , COALESCE (tmp.WorkTimeKindId,NULL)     :: Integer
                                                     , COALESCE (tmp.WorkTimeKindId,NULL)     :: Integer
                                                     , TRUE                   :: Boolean    -- inisPersonalGroup   -- если вызываем от сюда нужно учесть вид смены при поиске MovementItem
                                                     , inSession              :: TVarChar
                                                      )
     FROM (WITH
           tmpMemberHoliday AS (SELECT MovementLinkObject_Member.ObjectId AS MemberId
                                FROM MovementLinkObject AS MovementLinkObject_Member
                                     INNER JOIN Movement AS Movement_MemberHoliday 
                                                         ON Movement_MemberHoliday.Id = MovementLinkObject_Member.MovementId
                                                        AND Movement_MemberHoliday.DescId = zc_Movement_MemberHoliday()
                                                        AND Movement_MemberHoliday.StatusId = zc_Enum_Status_Complete()
                 
                                     INNER JOIN MovementDate AS MovementDate_BeginDateStart
                                                             ON MovementDate_BeginDateStart.MovementId = MovementLinkObject_Member.MovementId
                                                            AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()
                                                            AND MovementDate_BeginDateStart.ValueData <= vbOperDate
                                     INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                                             ON MovementDate_BeginDateEnd.MovementId = MovementDate_BeginDateStart.MovementId
                                                            AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()
                                                            AND MovementDate_BeginDateEnd.ValueData >= vbOperDate
                                WHERE MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                               )
         , tmpMI AS (SELECT Movement.OperDate
                          , MovementLinkObject_Unit.ObjectId          AS UnitId
                          , MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
                          , MovementLinkObject_PairDay.ObjectId       AS PairDayId
                          , MovementItem.ObjectId                     AS PersonalId
                          , ObjectLink_Personal_Member.ChildObjectId  AS MemberId
                          , MILinkObject_Position.ObjectId            AS PositionId
                          , MILinkObject_PositionLevel.ObjectId       AS PositionLevelId
                          , ObjectLink_Personal_StorageLine.ChildObjectId AS StorageLineId
                             /*, CASE WHEN MovementLinkObject_PairDay.ObjectId = 7438171 THEN zc_Enum_WorkTimeKind_WorkN() -- ночь
                                    ELSE zc_Enum_WorkTimeKind_WorkD()--день
                               END AS WorkTimeKindId
                             */
                          , CASE WHEN MovementItem.isErased = TRUE AND MovementLinkObject_PairDay.ObjectId = 7438171
                                      THEN zc_Enum_WorkTimeKind_WorkN() -- ночь
                                 WHEN MovementItem.isErased = TRUE AND MovementLinkObject_PairDay.ObjectId = 7438170 
                                      THEN zc_Enum_WorkTimeKind_WorkD()-- день
                                 ELSE MILinkObject_WorkTimeKind.ObjectId
                            END AS WorkTimeKindId
                          , CASE WHEN inIsDel = FALSE THEN MovementItem.Amount ELSE 0 END AS Amount
                     FROM Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                       ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                      AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                       ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                      AND MovementLinkObject_PairDay.DescId = zc_MovementLinkObject_PairDay()
                          
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                                               --AND (MovementItem.isErased = FALSE OR inIsDel = TRUE)
                                                 AND MovementItem.isErased = FALSE
                          
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                           ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
 
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                           ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_WorkTimeKind
                                                           ON MILinkObject_WorkTimeKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                               ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                          LEFT JOIN ObjectLink AS ObjectLink_Personal_StorageLine
                                               ON ObjectLink_Personal_StorageLine.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_Personal_StorageLine.DescId = zc_ObjectLink_Personal_StorageLine()
 
                     WHERE Movement.Id = inMovementId_pg
                    )
         -- Результат
         SELECT tmpMI.OperDate
              , tmpMI.MemberId
              , tmpMI.PersonalId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.UnitId
              ---, CASE WHEN inIsDel = FALSE THEN tmpMI.WorkTimeKindId ELSE 0 END ::Integer AS WorkTimeKindId
              , tmpMI.WorkTimeKindId ::Integer AS WorkTimeKindId
              , CASE WHEN inIsDel = TRUE THEN '-' ELSE zfCalc_ViewWorkHour (tmpMI.Amount, ObjectString_ShortName.ValueData) ::TVarChar END AS Value
         FROM tmpMI
             INNER JOIN ObjectString AS ObjectString_ShortName
                                     ON ObjectString_ShortName.ObjectId = tmpMI.WorkTimeKindId
                                    AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
             LEFT JOIN tmpMemberHoliday ON tmpMemberHoliday.MemberId = tmpMI.MemberId
         WHERE tmpMemberHoliday.MemberId IS NULL
     ) AS tmp
     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.11.21         *
*/

-- тест
-- 