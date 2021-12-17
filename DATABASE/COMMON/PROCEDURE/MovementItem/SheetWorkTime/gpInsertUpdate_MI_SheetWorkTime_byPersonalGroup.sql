-- Function: gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SheetWorkTime_byPersonalGroup(
    IN inMovementId_pg     Integer   , -- ID Movement_PersonalGroup
    IN inisDel             Boolean   , -- если проводим устанавливаем данные в табель (FALSE), если распроводим/удалем устанавливаем NULL (TRUE)
    IN inSession           TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDAte   TDateTime;
   DECLARE vbMemberId   Integer;
   DECLARE vbWorkTimeKindId Integer;
BEGIN


     --автоматом проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind - при распроведении или удалении - в табеле удаляется WorkTimeKind

     --vbWorkTimeKindId := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_mh AND MovementLinkObject.DescId = zc_MovementLinkObject_WorkTimeKind());

     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(tmp.MemberId           :: Integer    -- Ключ физ. лицо
                                                     , tmp.PositionId         :: Integer    -- Должность
                                                     , tmp.PositionLevelId    :: Integer    -- Разряд
                                                     , tmp.UnitId             :: Integer    -- Подразделение
                                                     , tmp.PersonalGroupId    :: Integer    -- Группировка Сотрудника
                                                     , tmp.StorageLineId      :: Integer    -- линия произ-ва
                                                     , tmp.OperDate           :: TDateTime  -- дата
                                                     , COALESCE (tmp.Value,NULL)              :: TVarChar   -- часы
                                                     , COALESCE (tmp.WorkTimeKindId,NULL)     :: Integer    
                                                     , inSession              :: TVarChar
                                                     )
     FROM (WITH
           tmpMI AS (SELECT Movement.OperDate
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
                          , MILinkObject_WorkTimeKind.ObjectId        AS WorkTimeKindId
                          , CASE WHEN inisDel = FALSE THEN MovementItem.Amount ELSE 0 END AS Amount
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
         
         SELECT tmpMI.OperDate
              , tmpMI.MemberId
              , tmpMI.PersonalId
              , tmpMI.PositionId
              , tmpMI.PositionLevelId
              , tmpMI.PersonalGroupId
              , tmpMI.StorageLineId
              , tmpMI.UnitId
              , CASE WHEN inisDel = FALSE THEN tmpMI.WorkTimeKindId ELSE 0 END ::Integer AS WorkTimeKindId
              , zfCalc_ViewWorkHour (tmpMI.Amount, ObjectString_ShortName.ValueData) ::TVarChar AS Value
         FROM tmpMI
             LEFT JOIN ObjectString AS ObjectString_ShortName
                                    ON ObjectString_ShortName.ObjectId = CASE WHEN inisDel = FALSE THEN tmpMI.WorkTimeKindId ELSE 0 END
                                   AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
     ) AS tmp
     ;


-- !!! ВРЕМЕННО !!!
IF vbUserId = 5 AND 1=1 THEN
    RAISE EXCEPTION 'Admin - Test = OK';
END IF;


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