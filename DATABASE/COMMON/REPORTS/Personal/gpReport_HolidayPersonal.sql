-- Function: gpReport_HolidayPersonal ()

DROP FUNCTION IF EXISTS gpReport_HolidayPersonal (TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayPersonal(
    IN inStartDate      TDateTime, --дата начала периода
    IN inUnitId         Integer,   --подразделение
    IN inPersonalId     Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inisDetail       Boolean,   --детализировать по дн€м
    IN inSession        TVarChar   --сесси€ пользовател€
)
RETURNS TABLE(MemberId Integer, PersonalId Integer
            , PersonalCode Integer, PersonalName TVarChar
            , PositionCode Integer, PositionName TVarChar
            , PositionLevelName TVarChar
            , UnitCode Integer, UnitName TVarChar
            , BranchName TVarChar
            , PersonalGroupName TVarChar
            , StorageLineName TVarChar
            , DateIn TDateTime, DateOut TDateTime
            , isDateOut Boolean, isMain Boolean, isOfficial Boolean
            , Age_work      TVarChar
            , Month_work    TFloat
            , Day_vacation  TFloat
            , Day_holiday   TFloat
            , Day_diff      TFloat

            , InvNumber          TVarChar 
            , OperDate           TDateTime
            , OperDateStartDate  TDateTime
            , OperDateEndDate    TDateTime
            , BeginDateStartDate TDateTime
            , BeginDateEndDate   TDateTime
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbMonthHoliday TFloat;
    DECLARE vbDayHoliday   TFloat;
BEGIN
    -- проверка прав пользовател€ на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    
    -- кол-во мес€цев после чего положен отпуск - 1 отпуск - после 6 м. непрерывного стажа
    vbMonthHoliday := 6;
    -- кол-во положенных дней отпуска
    vbDayHoliday := 14;

    -- –езультат
    RETURN QUERY

    WITH
    tmpPersonal AS (SELECT Object_Personal_View.*
                         , CASE WHEN Object_Personal_View.isDateOut = FALSE THEN inStartDate ELSE Object_Personal_View.DateOut_user END AS DateOut_Calc  -- CURRENT_DATE  -- если дата увольнени€ пута€ ставим = дате форм. отчета, дл€ расчета отр. мес€цев на дату форм. отчета
                         , ROW_NUMBER(*) OVER (PARTITION BY Object_Personal_View.MemberId
                                                          , COALESCE (Object_Personal_View.PositionId, 0)
                                                          , COALESCE (Object_Personal_View.PositionLevelId, 0)
                                                          , COALESCE (Object_Personal_View.UnitId, 0)
                                              ) AS Ord
                    FROM Object_Personal_View
                    WHERE Object_Personal_View.isErased = FALSE
                      AND (Object_Personal_View.UnitId = inUnitId OR inUnitId = 0)
                      AND (Object_Personal_View.PersonalId = inPersonalId OR inPersonalId = 0)
                      AND (Object_Personal_View.PositionId = inPositionId OR inPositionId = 0)
                      AND Object_Personal_View.DateIn <= inStartDate
                   )

  , tmpWork AS (SELECT *
                     , DATE_PART('YEAR', AGE (tmpPersonal.DateOut_Calc, tmpPersonal.DateIn)) * 12 
                     + DATE_PART('MONTH', AGE (tmpPersonal.DateOut_Calc, tmpPersonal.DateIn)) AS Month_work  -- кол-во отработанных мес€цев
                     , AGE (tmpPersonal.DateOut_Calc, tmpPersonal.DateIn) AS Age_work                                                                             -- итого отработано
                FROM tmpPersonal
                )

  , tmpVacation AS (SELECT *
                         , CASE WHEN tmpWork.Month_work >= vbMonthHoliday THEN CAST (vbDayHoliday * tmpWork.Month_work / 12 AS NUMERIC (16,0)) ELSE 0 END  AS Day_vacation -- колво положенных дней отпуска  (14 дней в год, 1 отпуск - после 6 м. непрерывного стажа)
                    FROM tmpWork
                   )
  --выбираем документы отпусков
  , tmpMov_Holiday AS (SELECT Movement.Id
                            , Movement.InvNumber
                            , Movement.OperDate                            
                            , MovementLinkObject_Member.ObjectId    AS MemberId
                            , MovementDate_OperDateStart.ValueData  AS OperDateStartDate
                            , MovementDate_OperDateEnd.ValueData    AS OperDateEndDate
                            , MovementDate_BeginDateStart.ValueData AS BeginDateStartDate
                            , MovementDate_BeginDateEnd.ValueData   AS BeginDateEndDate
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                            INNER JOIN (SELECT DISTINCT tmpPersonal.MemberId FROM tmpPersonal) AS tmp ON tmp.MemberId = MovementLinkObject_Member.ObjectId

                            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

                            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                            LEFT JOIN MovementDate AS MovementDate_BeginDateStart
                                                   ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                  AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()

                            LEFT JOIN MovementDate AS MovementDate_BeginDateEnd
                                                   ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                  AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()

                       WHERE Movement.DescId = zc_Movement_MemberHoliday()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.OperDate <= inStartDate
                      )
  -- считаем кол-во дней пердоставленного отпуска
  , tmpHoliday AS (SELECT CASE WHEN inisDetail = TRUE THEN tmpData.InvNumber          ELSE ''   END :: TVarChar  AS InvNumber
                        , CASE WHEN inisDetail = TRUE THEN tmpData.OperDate           ELSE NULL END :: TDateTime AS OperDate
                        , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateStartDate  ELSE NULL END :: TDateTime AS OperDateStartDate
                        , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateEndDate    ELSE NULL END :: TDateTime AS OperDateEndDate
                        , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateStartDate ELSE NULL END :: TDateTime AS BeginDateStartDate
                        , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateEndDate   ELSE NULL END :: TDateTime AS BeginDateEndDate
                        , tmpData.MemberId
                        , SUM (DATE_PART ('DAY', tmpData.BeginDateEndDate - tmpData.BeginDateStartDate))  :: TFloat AS Day_holiday
                   FROM tmpMov_Holiday AS tmpData
                   GROUP BY CASE WHEN inisDetail = TRUE THEN tmpData.InvNumber         ELSE ''   END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.OperDate          ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateStartDate ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateEndDate   ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateStartDate ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateEndDate   ELSE NULL END
                          , tmpData.MemberId
                   HAVING SUM (DATE_PART ('DAY', tmpData.BeginDateEndDate - tmpData.BeginDateStartDate)) <> 0
                   )
    -- св€зываемданные положенных дней отпуска и фоактич.
    -- –езультат

             

    SELECT tmpVacation.MemberId
         , tmpVacation.PersonalId
         , tmpVacation.PersonalCode
         , tmpVacation.PersonalName
         , tmpVacation.PositionCode
         , tmpVacation.PositionName
         , tmpVacation.PositionLevelName
         , tmpVacation.UnitCode
         , tmpVacation.UnitName
         , Object_Branch.ValueData  AS BranchName
         , tmpVacation.PersonalGroupName
         , tmpVacation.StorageLineName
         , tmpVacation.DateIn
         , tmpVacation.DateOut_user AS DateOut
         , tmpVacation.isDateOut
         , tmpVacation.isMain
         , tmpVacation.isOfficial
         , tmpVacation.Age_work      :: TVarChar
         , tmpVacation.Month_work    :: TFloat
         , tmpVacation.Day_vacation  :: TFloat
         , tmpHoliday.Day_holiday    :: TFloat                                                                       -- использовано 
         , (COALESCE (tmpVacation.Day_vacation, 0) - COALESCE (tmpHoliday.Day_holiday, 0))   :: TFloat AS Day_diff   -- не использовано   
         , tmpHoliday.InvNumber          :: TVarChar 
         , tmpHoliday.OperDate           :: TDateTime
         , tmpHoliday.OperDateStartDate  :: TDateTime
         , tmpHoliday.OperDateEndDate    :: TDateTime
         , tmpHoliday.BeginDateStartDate  :: TDateTime
         , tmpHoliday.BeginDateEndDate    :: TDateTime
    FROM tmpVacation
         LEFT JOIN tmpHoliday ON tmpHoliday.MemberId = tmpVacation.MemberId
                             AND tmpVacation.Ord = 1

         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = tmpVacation.UnitId
                             AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
         LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
    ORDER BY tmpVacation.UnitName
           , tmpVacation.PersonalName
           , tmpVacation.PositionName
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- тест
-- SELECT * FROM gpReport_HolidayPersonal (inStartDate:= '03.11.2018', inUnitId:= 8439, inPersonalId:= 0, inPositionId:= 0, inisDetail:= TRUE, inSession:= '5');
