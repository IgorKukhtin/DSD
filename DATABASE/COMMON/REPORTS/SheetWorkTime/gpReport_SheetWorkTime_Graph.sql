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
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


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
             
             , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId

             , 1 AS CountPersonal
        FROM tmpOperDate
             JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                          AND Movement.DescId = zc_Movement_SheetWorkTime()
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
             JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
            
             LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                              ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                             AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
        WHERE MovementLinkObject_Unit.ObjectId = inUnitId 
          AND MI_SheetWorkTime.Amount <> 0
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
             , SUM (tmp.Weight_Send_out)    AS Weight_Send_out
        FROM gpReport_GoodsMI_Package(inStartDate
                                    , inEndDate
                                    , inUnitId
                                    , TRUE      --inIsDate
                                    , TRUE      --inIsPersonalGroup
                                    , FALSE     --inisMovement 
                                    , FALSE     --inisUnComplete
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
        , COALESCE (tmpMI.OperDate,tmpReport.OperDate)  :: TDateTime AS OperDate
        , SUM (tmpMI.Amount)             ::TFloat AS AmountHours
        , SUM (CASE WHEN COALESCE (tmpMI.Amount, 0) <> 0 THEN 1 ELSE 0 END) ::TFloat AS CountDay
        , SUM (tmpReport.CountPackage)   ::TFloat AS CountPackage
        , SUM (tmpReport.WeightPackage)  ::TFloat AS WeightPackage  
        , SUM (tmpReport.Weight_Send_out)::TFloat AS Weight_Send_out
--        , SUM (tmp.AmountHours) ::TFloat AS AmountHours
--        , SUM (tmp.CountDay)    ::TFloat AS CountDay
        
   FROM tmpMI
        FULL JOIN tmpReport ON COALESCE (tmpReport.PersonalGroupId,0) = COALESCE (tmpMI.PersonalGroupId,0)
                           AND tmpReport.OperDate = tmpMI.OperDate

        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = COALESCE (tmpMI.PersonalGroupId, tmpReport.PersonalGroupId,0)
   GROUP BY Object_PersonalGroup.Id
          , Object_PersonalGroup.ValueData
          , COALESCE (tmpMI.OperDate,tmpReport.OperDate)
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
        , SUM (tmpReport.CountPackage)   ::TFloat AS CountPackage
        , SUM (tmpReport.WeightPackage)  ::TFloat AS WeightPackage
        , SUM (tmpReport.Weight_Send_out)::TFloat AS Weight_Send_out
   FROM tmpReport
   GROUP BY tmpReport.PersonalGroupName
          , tmpReport.OperDate
   ;
   RETURN NEXT Cursor3;

   OPEN Cursor4 FOR
   ---
   SELECT tmpReport.PersonalGroupName
        , tmpReport.OperDate :: TDateTime
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12471   THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_1
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12467   THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_2
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 2237044 THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_3
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12466   THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_4
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 0       THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage_0
        , SUM (CASE WHEN tmpReport.PersonalGroupId not in (0,12466,2237044,12471,12467) THEN COALESCE (tmpReport.CountPackage,0) ELSE 0 END)  ::TFloat AS CountPackage

        /*, SUM (CASE WHEN tmpReport.PersonalGroupId = 12471   THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_1
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12467   THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_2
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 2237044 THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_3
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12466   THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_4
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 0       THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage_0
        , SUM (CASE WHEN tmpReport.PersonalGroupId not in (0,12466,2237044,12471,12467) THEN COALESCE (tmpReport.WeightPackage,0) ELSE 0 END)  ::TFloat AS WeightPackage 
        */
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12471   THEN COALESCE (tmpReport.Weight_Send_out,0) ELSE 0 END)  ::TFloat AS Weight_Send_out_1
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12467   THEN COALESCE (tmpReport.Weight_Send_out,0) ELSE 0 END)  ::TFloat AS Weight_Send_out_2
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 2237044 THEN COALESCE (tmpReport.Weight_Send_out,0) ELSE 0 END)  ::TFloat AS Weight_Send_out_3
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 12466   THEN COALESCE (tmpReport.Weight_Send_out,0) ELSE 0 END)  ::TFloat AS Weight_Send_out_4
        , SUM (CASE WHEN tmpReport.PersonalGroupId = 0       THEN COALESCE (tmpReport.Weight_Send_out,0) ELSE 0 END)  ::TFloat AS Weight_Send_out_0
        , SUM (CASE WHEN tmpReport.PersonalGroupId not in (0,12466,2237044,12471,12467) THEN COALESCE (tmpReport.Weight_Send_out,0) ELSE 0 END)  ::TFloat AS Weight_Send_out
        
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