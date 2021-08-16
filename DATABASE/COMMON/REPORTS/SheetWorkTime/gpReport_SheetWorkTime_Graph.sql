--- -- Function: gpReport_SheetWorkTime_Graph()

DROP FUNCTION IF EXISTS gpReport_SheetWorkTime_Graph(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime_Graph(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnitId      Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    DECLARE Cursor4 refcursor;
BEGIN

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT generate_series(inStartDate, inEndDate, '1 DAY'::interval) OperDate;

     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
   SELECT  tmp.OperDate
         , tmp.PersonalGroupId
         , SUM (tmp.Amount)        AS Amount
         , SUM (tmp.CountPersonal) AS CountPersonal
   FROM (
        SELECT tmpOperDate.operdate
             , MI_SheetWorkTime.Amount
             
             /*, COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
             , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
             , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
             */
             , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
             --, COALESCE(MIObject_StorageLine.ObjectId, 0)    AS StorageLineId
             --, CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE MIObject_WorkTimeKind.ObjectId END AS WorkTimeKindId
             --, ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName
             --, MovementLinkObject_Unit.ObjectId AS UnitId
             , 1 AS CountPersonal
        FROM tmpOperDate
             JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                          AND Movement.DescId = zc_Movement_SheetWorkTime()
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
             JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
             /*LEFT JOIN MovementItemLinkObject AS MIObject_Position
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
             */
             LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                              ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                             AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
             /*LEFT JOIN MovementItemLinkObject AS MIObject_StorageLine
                                              ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                             AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
             */
        WHERE MovementLinkObject_Unit.ObjectId = inUnitId
        ) AS tmp
   GROUP BY tmp.OperDate
          , tmp.PersonalGroupId;

     --Данные из отчета по упаковке
     CREATE TEMP TABLE tmpReport ON COMMIT DROP AS
        SELECT tmp.OperDate
             , tmp.PersonalGroupId
             , tmp.PersonalGroupName
             , SUM (tmp.CountPackage_calc)  AS CountPackage
             , SUM (tmp.WeightPackage_calc) AS WeightPackage
        FROM gpReport_GoodsMI_Package(inStartDate
                                    , inEndDate
                                    , inUnitId
                                    , TRUE      --inIsDate
                                    , TRUE      --inIsPersonalGroup
                                    , FALSE     --inisMovement
                                    , inSession
                                    ) AS tmp
        GROUP BY tmp.OperDate
               , tmp.PersonalGroupName
               , tmp.PersonalGroupId
        ;


   OPEN Cursor1 FOR
   -- Факт
   SELECT 
          Object_PersonalGroup.Id         AS PersonalGroupId
        , Object_PersonalGroup.ValueData  AS PersonalGroupName
        , tmpMI.OperDate :: TDateTime
        , SUM (tmpMI.Amount)            ::TFloat  AS AmountHours
        , SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) ::TFloat AS CountDay
        , SUM (tmpReport.CountPackage)  ::TFloat AS CountPackage
        , SUM (tmpReport.WeightPackage) ::TFloat AS WeightPackage
--        , SUM (tmp.AmountHours) ::TFloat AS AmountHours
--        , SUM (tmp.CountDay)    ::TFloat AS CountDay
        
   FROM tmpMI
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpMI.PersonalGroupId

        LEFT JOIN tmpReport ON COALESCE (tmpReport.PersonalGroupId,0) = COALESCE (tmpMI.PersonalGroupId,0)
                           AND tmpReport.OperDate = tmpMI.OperDate
   GROUP BY Object_PersonalGroup.Id
          , Object_PersonalGroup.ValueData
          , tmpMI.OperDate
   ;
   RETURN NEXT Cursor1;

   --
   OPEN Cursor2 FOR
   ---
   SELECT Object_PersonalGroup.Id         AS PersonalGroupId
        , Object_PersonalGroup.ValueData  AS PersonalGroupName
        , tmpMI.OperDate :: TDateTime
        , SUM (tmpMI.Amount)        ::TFloat AS Amount
        , SUM (tmpMI.CountPersonal) ::TFloat AS CountPersonal
   FROM tmpMI
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpMI.PersonalGroupId
   GROUP BY Object_PersonalGroup.Id
          , Object_PersonalGroup.ValueData
          , tmpMI.OperDate
   ;
   RETURN NEXT Cursor2;

   OPEN Cursor3 FOR
   ---
   SELECT tmpReport.PersonalGroupName
        , tmpReport.OperDate :: TDateTime
        , SUM (tmpReport.CountPackage)  ::TFloat AS CountPackage
        , SUM (tmpReport.WeightPackage) ::TFloat AS WeightPackage
   FROM tmpReport
   GROUP BY tmpReport.PersonalGroupName
          , tmpReport.OperDate
   ;
   RETURN NEXT Cursor3;

   OPEN Cursor4 FOR
   ---
   SELECT tmpReport.PersonalGroupName
        , tmpReport.OperDate :: TDateTime
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12466   THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_1
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 2237044 THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_2
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12471   THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_3
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12467   THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_4
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 0       THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_0
        , SUM (CASE WHEN tmpReport.PersonalGroupId not in (0,12466,2237044,12471,12467) THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage

        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12466   THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_1
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 2237044 THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_2
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12471   THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_3
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12467   THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_4
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 0       THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_0
        , SUM (CASE WHEN tmpReport.PersonalGroupId not in (0,12466,2237044,12471,12467) THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage
        
       -- , SUM (tmpReport.WeightPackage) ::TFloat AS WeightPackage
   FROM tmpReport
   GROUP BY tmpReport.PersonalGroupName
          , tmpReport.OperDate
   ;
   RETURN NEXT Cursor4;
   
   
/*   OPEN Cursor1 FOR
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
        , tmpMI.ShortName
        , tmpMI.OperDate :: TDateTime
        , tmpMI.Amount ::TFloat
   FROM tmpMI
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI.MemberId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMI.PositionId
        LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpMI.PositionLevelId
        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpMI.PersonalGroupId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
        LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpMI.WorkTimeKindId

        LEFT JOIN (SELECT tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId
                         , Sum (tmpMI.Amount) AS Amount
                         , Sum (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) AS CountDay 
                    FROM tmpMI
                    GROUP BY tmpMI.MemberId, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.PersonalGroupId, tmpMI.StorageLineId
                   ) AS tmp ON tmp.MemberId =tmpMI.MemberId
                           AND tmp.PositionId = tmpMI.PositionId
                           AND tmp.PositionLevelId = tmpMI.PositionLevelId
                           AND tmp.PersonalGroupId = tmpMI.PersonalGroupId
                           AND tmp.StorageLineId = tmpMI.StorageLineId
   ;
   RETURN NEXT Cursor1;*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.08.21         *
*/

-- тест--
--
-- select * from gpReport_SheetWorkTime_Graph(inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('15.08.2021')::TDateTime , inUnitId := 8459::Integer ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e'::TVarChar);
 --fetch all "<unnamed portal 26>";