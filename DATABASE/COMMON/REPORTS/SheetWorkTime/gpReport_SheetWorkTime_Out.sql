-- Function: gpReport_SheetWorkTime_Out()

DROP FUNCTION IF EXISTS gpReport_SheetWorkTime_Out(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime_Out(
    IN inDateStart   TDateTime , --
    IN inDateEnd     TDateTime , --
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
)
AS
$BODY$

BEGIN

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inDateStart, inDateEnd, '1 DAY'::interval) OperDate;

    -- Результат
    RETURN QUERY
    WITH
    -- сотрудники дата приема , увольнения
    tmpList AS (SELECT Object_Personal_View.MemberId
                     , Object_Personal_View.PersonalId
                     , Object_Personal_View.PositionId
                     , Object_Personal_View.PositionLevelId
                     , Object_Personal_View.DateIn
                     , Object_Personal_View.DateOut
                     , Object_Personal_View.UnitId
                    FROM Object_Personal_View
                    WHERE ((Object_Personal_View.DateOut >= inDateStart AND Object_Personal_View.DateOut <= inDateEnd)
                        OR (Object_Personal_View.DateIn >= inDateStart AND Object_Personal_View.DateIn <= inDateEnd))
                        --    ((Object_Personal_View.DateOut >= '01.06.2021' AND Object_Personal_View.DateOut <= '11.08.2021')
                          --OR (Object_Personal_View.DateIn >= '01.06.2021' AND Object_Personal_View.DateIn <= '11.08.2021'))
                      AND Object_Personal_View.UnitId = inUnitId
                   )
   -- рабочее время из табеля
  , tmpMovement AS (SELECT tmpOperDate.operdate
                         , MI_SheetWorkTime.Amount
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
                    WHERE MovementLinkObject_Unit.ObjectId = inUnitId
                          )

  , tmpRes AS (SELECT tmp.*
                    , COALESCE (tmpList.DateIn, tmpList_out.DateIn) AS DateIn
                    , COALESCE (tmpList.DateOut, tmpList_out.DateOut) AS DateOut
               FROM tmpMovement AS tmp
                 -- если был принят не сначала месяца или уволен в течении месяца отмечаем Х
                 Left JOIN tmpList ON tmpList.DateIn   > tmp.OperDate
                                      AND tmpList.MemberId = tmp.MemberId
                                      AND tmpList.PositionId = tmp.PositionId
                                      AND tmpList.PositionLevelId = tmp.PositionLevelId
                                      AND tmpList.UnitId     = tmp.UnitId
                                      AND tmp.Amount            <> 0
                 Left JOIN tmpList AS tmpList_out
                                     ON tmpList_out.DateOut   <= tmp.OperDate
                                      AND tmpList_out.MemberId = tmp.MemberId
                                      AND tmpList_out.PositionId = tmp.PositionId
                                      AND tmpList_out.PositionLevelId = tmp.PositionLevelId
                                      AND tmpList_out.UnitId     = tmp.UnitId
                                      AND tmp.Amount            <> 0
               WHERE tmpList.MemberId IS NOT NULL or tmpList_out.MemberId IS NOT NULL
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
        , tmpRes.Amount
   FROM tmpRes
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpRes.MemberId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpRes.PositionId
        LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpRes.PositionLevelId
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpRes.PersonalGroupId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpRes.UnitId
        LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpRes.WorkTimeKindId
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
---  SELECT * from gpReport_SheetWorkTime_Out (inDateStart:= '01.06.2021'::TDateTime, inDateEnd:= '30.06.2021'::TDateTime, inUnitId := 8459 , inSession := zfCalc_UserAdmin());
