-- Function: gpReport_SheetWorkTime_Out()

DROP FUNCTION IF EXISTS gpReport_SheetWorkTime_Out(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime_Out(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnitId      Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (
          UnitId Integer
        , UnitName TVarChar
        , MemberId Integer
        , MemberCode Integer
        , MemberName TVarChar
        , PositionId Integer
        , PositionName TVarChar
        , PositionLevelId Integer
        , PositionLevelName TVarChar
        , PersonalGroupId Integer
        , PersonalGroupName TVarChar
        , WorkTimeKindId Integer
        , WorkTimeKindName TVarChar
        , ShortName TVarChar
        , OperDate TDateTime
        , DateIn TDateTime
        , DateOut TDateTime
        , Amount TFloat
        , HoursDay TFloat
        , ErrorCode Integer
        , ErrorText TVarChar
)
AS
$BODY$

BEGIN

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inStartDate, inEndDate, '1 DAY'::interval) OperDate;

    -- Результат
    RETURN QUERY
    WITH
    -- сотрудники дата приема , увольнения
    tmpListAll AS (SELECT Object_Personal_View.MemberId
                        , Object_Personal_View.PersonalId
                        , Object_Personal_View.PositionId
                        , Object_Personal_View.PositionLevelId
                        , Object_Personal_View.DateIn
                        , Object_Personal_View.DateOut
                        , Object_Personal_View.UnitId
                   FROM Object_Personal_View
                   WHERE (Object_Personal_View.UnitId = inUnitId OR inUnitId = 0)
                   )
  -- принятые и уволенные
  , tmpList AS (SELECT tmpListAll.*
                FROM tmpListAll
                WHERE ((tmpListAll.DateOut >= inStartDate AND tmpListAll.DateOut <= inEndDate)
                    OR (tmpListAll.DateIn >= inStartDate AND tmpListAll.DateIn <= inEndDate))
               )

  , tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
                          , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
                          , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
                          , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
                     FROM OBJECT AS Object_StaffList
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
                      HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                    )

   -- рабочее время из табеля
  , tmpMovement AS (SELECT tmpOperDate.operdate
                         , MI_SheetWorkTime.Amount
                         , CASE WHEN COALESCE(MIObject_PositionLevel.ObjectId, 0) = 3970383 THEN 2 * MI_SheetWorkTime.Amount ELSE MI_SheetWorkTime.Amount END AS Amount_calc
                         , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                         , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                         , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                         , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                         , CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS WorkTimeKindId
                         , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
                         , MovementLinkObject_Unit.ObjectId AS UnitId
                    FROM tmpOperDate
                         JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                      AND Movement.DescId = zc_Movement_SheetWorkTime()
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                         JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                         LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                         AND MIObject_Position.DescId = zc_MILinkObject_Position()
                         LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                         LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                          ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                         AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                         LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                                ON ObjectString_WorkTimeKind_ShortName.ObjectId = CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END
                                               AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                         LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                    WHERE (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                          )


  , tmpError AS (SELECT 1 AS ErrorCode, 'дата приема' AS ErrorText
           UNION SELECT 2 AS ErrorCode, 'дата увольнения' AS ErrorText
           UNION SELECT 3 AS ErrorCode, 'факт часов меньше смены' AS ErrorText
           UNION SELECT 4 AS ErrorCode, 'факт часов больше смены' AS ErrorText
           UNION SELECT 5 AS ErrorCode, 'работа больше 24 часов' AS ErrorText
           UNION SELECT 6 AS ErrorCode, 'не протабелированны' AS ErrorText
                 )
  , tmpRes1 AS (-- 
               SELECT tmp.*
                    , COALESCE (tmpList.DateIn, tmpList_out.DateIn) AS DateIn
                    , COALESCE (tmpList.DateOut, tmpList_out.DateOut) AS DateOut
                    , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
                    , CASE WHEN tmpList.MemberId IS NOT NULL THEN 1
                           WHEN tmpList_out.MemberId IS NOT NULL THEN 2
                      END AS ErrorCode
               FROM tmpMovement AS tmp
                 -- если был принят не сначала месяца или уволен в течении месяца отмечаем Х
                 --
                 LEFT JOIN tmpList ON tmpList.DateIn   > tmp.OperDate
                                  AND tmpList.MemberId = tmp.MemberId
                                  AND tmpList.PositionId = tmp.PositionId
                                  AND COALESCE (tmpList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                  AND tmpList.UnitId     = tmp.UnitId
                                  AND tmp.Amount            <> 0
                 LEFT JOIN tmpList AS tmpList_out
                                   ON tmpList_out.DateOut   <= tmp.OperDate
                                  AND tmpList_out.MemberId = tmp.MemberId
                                  AND tmpList_out.PositionId = tmp.PositionId
                                  AND COALESCE (tmpList_out.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                  AND tmpList_out.UnitId     = tmp.UnitId
                                  AND tmp.Amount            <> 0

                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmp.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
               WHERE tmpList.MemberId IS NOT NULL or tmpList_out.MemberId IS NOT NULL
               )
  , tmpRes2 AS (
               --
               SELECT tmp.*
                    , tmpListAll.DateIn
                    , tmpListAll.DateOut
                    , COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) AS HoursDay
                    , CASE WHEN tmp.Amount_calc < COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) THEN 3
                           WHEN tmp.Amount_calc > COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0) THEN 4
                      END AS ErrorCode
               FROM tmpMovement AS tmp
                 LEFT JOIN tmpListAll ON tmpListAll.MemberId = tmp.MemberId
                                     AND tmpListAll.PositionId = tmp.PositionId
                                     AND COALESCE (tmpListAll.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                     AND tmpListAll.UnitId     = tmp.UnitId

                 LEFT JOIN tmpStaffList ON tmpStaffList.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                       AND tmpStaffList.UnitId     = tmp.UnitId
                 --второй раз без подразделения
                 LEFT JOIN tmpStaffList AS tmpStaffList2
                                        ON tmpStaffList2.PositionId = tmp.PositionId
                                       AND COALESCE (tmpStaffList2.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
               WHERE tmp.WorkTimeKindId IN (zc_Enum_WorkTimeKind_Work()
                                          , zc_Enum_WorkTimeKind_WorkD()
                                          , zc_Enum_WorkTimeKind_WorkN()
                                          , zc_Enum_WorkTimeKind_WorkDayOff()
                                          , zc_Enum_WorkTimeKind_RemoteAccess()
                                          , zc_Enum_WorkTimeKind_Trainee50()
                                          )
                 AND tmp.Amount_calc <> COALESCE (tmpStaffList.HoursDay, tmpStaffList2.HoursDay,0)
               )
  , tmpRes AS (SELECT tmpRes1.*
               FROM tmpRes1
             UNION
               SELECT tmpRes2.*
               FROM tmpRes2
              )
  

   ---
   SELECT Object_Unit.Id                  AS UnitId
        , Object_Unit.ValueData           AS UnitName
        , Object_Member.Id                AS MemberId
        , Object_Member.ObjectCode        AS MemberCode
        , Object_Member.ValueData         AS MemberName
        , Object_Position.Id              AS PositionId
        , Object_Position.ValueData       AS PositionName
        , Object_PositionLevel.Id         AS PositionLevelId
        , Object_PositionLevel.ValueData  AS PositionLevelName
        , Object_PersonalGroup.Id         AS PersonalGroupId
        , Object_PersonalGroup.ValueData  AS PersonalGroupName
        , Object_WorkTimeKind.Id          AS WorkTimeKindId
        , Object_WorkTimeKind.ValueData   AS WorkTimeKindName
        , tmpRes.ShortName
        , tmpRes.OperDate :: TDateTime
        , tmpRes.DateIn
        , tmpRes.DateOut
        , tmpRes.Amount   ::TFloat
        , tmpRes.HoursDay ::TFloat
        
        , tmpError.ErrorCode ::Integer
        , tmpError.ErrorText ::TVarChar
        
   FROM tmpRes
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpRes.MemberId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpRes.PositionId
        LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpRes.PositionLevelId
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpRes.PersonalGroupId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpRes.UnitId
        LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpRes.WorkTimeKindId
        LEFT JOIN tmpError ON tmpError.ErrorCode = tmpRes.ErrorCode
   ;




END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.21         *
*/

-- тест
---  SELECT * from gpReport_SheetWorkTime_Out (inStartDate:= '01.06.2021'::TDateTime, inEndDate:= '30.06.2021'::TDateTime, inUnitId := 8459 , inSession := zfCalc_UserAdmin());
--select * from gpReport_SheetWorkTime_Out(inStartDate := ('01.06.2021')::TDateTime , inEndDate := ('30.06.2021')::TDateTime , inUnitId := 8438 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e'::TVarChar);