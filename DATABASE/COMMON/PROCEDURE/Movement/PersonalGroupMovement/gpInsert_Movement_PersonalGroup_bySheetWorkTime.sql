-- Function: gpInsert_Movement_PersonalGroup_bySheetWorkTime()

DROP FUNCTION IF EXISTS gpInsert_Movement_PersonalGroup_bySheetWorkTime (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PersonalGroup_bySheetWorkTime(
    IN inStartDate             TDateTime ,
    IN inEndDate               TDateTime ,
    IN inUnitId                Integer   , -- Ключ объекта <подразделение>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbInvNumber TVarChar;
   
   DECLARE vbPersonalGroupId Integer;
   DECLARE vbPairDayId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());


   -- сохранили
     PERFORM lpInsert_Movement_PersonalGroup_bySheetWorkTime (inOperDate        := tmp.OperDate
                                                            , inUnitId          := inUnitId
                                                            , inPersonalGroupId := COALESCE (tmp.PersonalGroupId,0)
                                                            , inPairDayId       := CASE WHEN tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_WorkD(), 8302788) THEN 7438170  -- день  vbPairDayId
                                                                                        WHEN tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_WorkN(), 8302790) THEN 7438171  -- ночь  vbPairDayId
                                                                                        ELSE 7438170  --день
                                                                                   END
                                                            , inPersonalId      := tmp.PersonalId
                                                            , inPositionId      := tmp.PositionId
                                                            , inPositionLevelId := tmp.PositionLevelId
                                                            , inWorkTimeKindId  := tmp.WorkTimeKindId
                                                            , inAmount          := tmp.Amount
                                                            , inUserId          := vbUserId
                                                            ) 
     FROM (WITH
             tmpOperDate AS (SELECT GENERATE_SERIES (inStartDate, inEndDate :: TDateTime, '1 DAY' :: INTERVAL) AS OperDate)
             --данные из табеля
           , tmpMovement AS (SELECT tmpOperDate.OperDate
                                 , MI_SheetWorkTime.Amount
                                 , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                                 , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                                 , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                 , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                                 , CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS WorkTimeKindId
                            FROM tmpOperDate
                                 JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                              AND Movement.DescId = zc_Movement_SheetWorkTime()
                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 JOIN MovementItem AS MI_SheetWorkTime
                                                   ON MI_SheetWorkTime.MovementId = Movement.Id
                                                  AND MI_SheetWorkTime.isErased = FALSE
                                 LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                                  ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_Position.DescId = zc_MILinkObject_Position()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                  ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                  ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                  ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                            WHERE MovementLinkObject_Unit.ObjectId = inUnitId
                            AND COALESCE(MIObject_PersonalGroup.ObjectId, 0) <> 0
                            )
             --сотрудники подразделения
           , tmpPersonal AS (SELECT Object_Personal_View.MemberId
                                  , Object_Personal_View.PersonalId
                                  , Object_Personal_View.PositionId
                                  , Object_Personal_View.PositionLevelId
                                  , Object_Personal_View.PersonalGroupId
                             FROM Object_Personal_View
                             WHERE Object_Personal_View.UnitId = inUnitId
                              AND (Object_Personal_View.DateOut >= inEndDate
                               AND Object_Personal_View.DateIn  <= inStartDate)
                            )

            SELECT tmp.OperDate
                 , tmpPersonal.PersonalId
                 , tmp.PositionId
                 , tmp.PositionLevelId
                 , tmp.PersonalGroupId
                 , tmp.WorkTimeKindId
                 , tmp.Amount
            FROM tmpMovement AS tmp
               INNER JOIN tmpPersonal ON tmpPersonal.MemberId = tmp.MemberId
                                     AND tmpPersonal.PositionId = tmp.PositionId
                                     --AND tmpPersonal.PersonalGroupId = tmp.PersonalGroupId
                                     AND COALESCE (tmpPersonal.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
            WHERE tmp.WorkTimeKindId <> zc_Enum_WorkTimeKind_Holiday()
            ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.21         *
*/

-- тест
--


/* WITH
tmpOperDate AS (SELECT GENERATE_SERIES ('01.12.2021' :: TDateTime, '05.12.2021' :: TDateTime, '1 DAY' :: INTERVAL) AS OperDate)
         ,   tmpMovement AS (SELECT tmpOperDate.operdate
                               --, CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN 0 ELSE MI_SheetWorkTime.Amount END AS Amount
                                 , MI_SheetWorkTime.Amount
                                 , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                                 , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                                 , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                 , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                                 , CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS ObjectId
                            FROM tmpOperDate
                                 JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                              AND Movement.DescId = zc_Movement_SheetWorkTime()
                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 JOIN MovementItem AS MI_SheetWorkTime
                                                   ON MI_SheetWorkTime.MovementId = Movement.Id
                                                  AND MI_SheetWorkTime.isErased = FALSE
                                 LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                                  ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_Position.DescId = zc_MILinkObject_Position()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                  ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                 LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                  ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                        LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                  ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                                 AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()

                            WHERE MovementLinkObject_Unit.ObjectId = 8451 --inUnitId

                            )
           
            -- объединяем даты увольнения и рабочие
            -- рабочий график
            SELECT *, zc_Enum_WorkTimeKind_WorkD(), zc_Enum_WorkTimeKind_WorkN()
 
            FROM tmpMovement AS tmp
Where tmp.ObjectId <> zc_Enum_WorkTimeKind_Holiday()
              
--select * from gpSelect_MovementItem_SheetWorkTime(inDate := ('01.11.2021')::TDateTime , inUnitId := 8451 , inisErased := 'False' ,  inSession := '9457');



*/

--select * from gpInsert_Movement_PersonalGroup_bySheetWorkTime(inStartDate := ('02.12.2021')::TDateTime ,inEndDate := ('02.12.2021')::TDateTime , inUnitId := 8451 , inSession := '9457');

--select * from gpGet_Movement_PersonalGroup(inMovementId := 21750152 , inOperDate := ('31.12.2021')::TDateTime ,  inSession := '9457');