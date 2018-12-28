-- Function: gpReport_HolidayPersonal ()

DROP FUNCTION IF EXISTS gpReport_HolidayPersonal (TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HolidayPersonal (TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayPersonal(
    IN inStartDate      TDateTime, --дата начала периода
    IN inUnitId         Integer,   --подразделение
    IN inMemberId       Integer,   --сотрудник
    --IN inPositionId     Integer,   --должность
    IN inisDetail       Boolean,   --детализировать по дн€м
    IN inSession        TVarChar   --сесси€ пользовател€
)
RETURNS TABLE(MemberId Integer, PersonalId Integer
            , PersonalCode Integer, PersonalName TVarChar
            , PositionId Integer, PositionCode Integer, PositionName TVarChar
            , PositionLevelName TVarChar
            , UnitCode Integer, UnitName TVarChar
            , BranchName TVarChar
            , PersonalGroupName TVarChar
            , StorageLineName TVarChar
            , DateIn TDateTime, DateOut TDateTime
            , isDateOut Boolean, isMain Boolean, isOfficial Boolean
           -- , Age_work      TVarChar
            , Month_work    TFloat
            , Day_calendar  TFloat
            , Day_vacation  TFloat
            , Day_holiday   TFloat
            , Day_diff      TFloat

            , InvNumber          TVarChar 
            , OperDate           TDateTime
            , OperDateStart      TDateTime
            , OperDateEnd        TDateTime
            , BeginDateStart     TDateTime
            , BeginDateEnd       TDateTime
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbMonthHoliday TFloat;
    DECLARE vbDayHoliday   TFloat;
    DECLARE vbStartDate TDateTime;
    DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользовател€ на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    
    vbStartDate := inStartDate - INTERVAL '1 YEAR';
    vbEndDate   := inStartDate;
    -- кол-во мес€цев после чего положен отпуск - 1 отпуск - после 6 м. непрерывного стажа
    vbMonthHoliday := 6;
    -- кол-во положенных дней отпуска
    vbDayHoliday := 14;

    -- –езультат
    RETURN QUERY

    WITH

    tmpMemberPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.UnitId
                               , lfSelect.PositionId
                               , lfSelect.BranchId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                            AND (lfSelect.MemberId = inMemberId OR inMemberId = 0)
                            AND (lfSelect.UnitId = inUnitId OR inUnitId = 0)
                          )

  , tmpPersonal AS (SELECT Object_Personal_View.*
                         , CASE WHEN Object_Personal_View.DateIn < vbStartDate THEN vbStartDate ELSE Object_Personal_View.DateIn END AS DateIn_Calc      -- 
                         , CASE WHEN Object_Personal_View.isDateOut = FALSE THEN vbEndDate ELSE Object_Personal_View.DateOut_user END AS DateOut_Calc  -- CURRENT_DATE  -- если дата увольнени€ пута€ ставим = дате форм. отчета, дл€ расчета отр. мес€цев на дату форм. отчета
                    FROM tmpMemberPersonal
                         LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = tmpMemberPersonal.MemberId
                                                       AND Object_Personal_View.UnitId = tmpMemberPersonal.UnitId
                                                       AND Object_Personal_View.PositionId = tmpMemberPersonal.PositionId
                    WHERE Object_Personal_View.DateIn <= inStartDate
                      AND ((Object_Personal_View.isDateOut = TRUE AND Object_Personal_View.DateOut_user >= vbStartDate) OR Object_Personal_View.isDateOut = FALSE)
                   )
  -- вычисл€ем интервалы непрерывной работы более 6 мес€цев
  , tmp1 (MemberId, DateIn_Calc, ord) AS
         (SELECT t1.MemberId
               , min(t1.DateIn_Calc) AS DateIn_Calc
               , row_number() over (partition by t1.MemberId order by min(t1.DateIn_Calc))
          FROM tmpPersonal AS t1
               LEFT JOIN tmpPersonal AS t2 ON t1.DateIn_Calc > t2.DateIn_Calc and t1.DateIn_Calc <= t2.DateOut_Calc + interval '1 day' and t2.MemberId = t1.MemberId
          WHERE t2.MemberId IS NULL
          GROUP BY t1.DateIn_Calc, t1.MemberId
         )
  , tmp2 (MemberId, DateOut_Calc, Ord) AS
         (SELECT t1.MemberId
               , min(t1.DateOut_Calc) AS DateOut_Calc
               , row_number() over (partition by t1.MemberId  order by min(t1.DateOut_Calc)) AS Ord
          FROM tmpPersonal AS t1
               LEFT JOIN tmpPersonal AS t2 ON t1.DateOut_Calc + interval '1 day' >= t2.DateIn_Calc and t1.DateOut_Calc < t2.DateOut_Calc and t2.MemberId = t1.MemberId
          WHERE t2.MemberId IS NULL
          GROUP BY t1.DateOut_Calc, t1.MemberId
         )
  , tmpWork AS (SELECT tmp.MemberId
                     , SUM (tmp.Month_work)   AS Month_work
                     , SUM (tmp.Day_calendar) AS Day_calendar
                FROM (SELECT tmp1.MemberId

                           , (SELECT COUNT (*) - SUM (CASE WHEN gpSelect.isHoliday = TRUE THEN 1 ELSE 0 END)
                              FROM gpSelect_Object_Calendar (inStartDate := tmp1.DateIn_Calc, inEndDate := tmp2.DateOut_Calc - INTERVAL '1 DAY', inSession := inSession) AS gpSelect) :: TFloat AS Day_calendar

                           , DATE_PART('YEAR', AGE (tmp2.DateOut_Calc, tmp1.DateIn_Calc)) * 12 
                                                + DATE_PART('MONTH', AGE (tmp2.DateOut_Calc, tmp1.DateIn_Calc))  AS Month_work 
                      FROM tmp1
                           JOIN tmp2 ON tmp1.ord = tmp2.ord
                                    AND tmp2.MemberId = tmp1.MemberId
                      WHERE DATE_PART('YEAR', AGE (tmp2.DateOut_Calc, tmp1.DateIn_Calc)) * 12 + DATE_PART('MONTH', AGE (tmp2.DateOut_Calc, tmp1.DateIn_Calc)) >= 6
                      ) AS tmp
                GROUP BY tmp.MemberId
                )
                   
/*
  , tmpWork AS (SELECT *
                     , DATE_PART('YEAR', AGE (tmpPersonal.DateOut_Calc, tmpPersonal.DateIn_Calc)) * 12 
                     + DATE_PART('MONTH', AGE (tmpPersonal.DateOut_Calc, tmpPersonal.DateIn_Calc)) AS Month_work  -- кол-во отработанных мес€цев
                     , AGE (tmpPersonal.DateOut_Calc, tmpPersonal.DateIn) AS Age_work                                                                             -- итого отработано
                FROM tmpPersonal
                )
                */

  , tmpVacation AS (SELECT *
                         , CASE WHEN tmpWork.Month_work >= vbMonthHoliday THEN CAST (vbDayHoliday * tmpWork.Month_work / 12 AS NUMERIC (16,0)) ELSE 0 END  AS Day_vacation -- колво положенных дней отпуска  (14 дней в год, 1 отпуск - после 6 м. непрерывного стажа)
                    FROM tmpWork
                   )
  --выбираем документы отпусков
  , tmpMov_Holiday AS (SELECT Movement.Id
                            , Movement.InvNumber
                            , Movement.OperDate                            
                            , MovementLinkObject_Member.ObjectId    AS MemberId
                            , MovementDate_OperDateStart.ValueData  AS OperDateStart
                            , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
                            , MovementDate_BeginDateStart.ValueData AS BeginDateStart
                            , MovementDate_BeginDateEnd.ValueData   AS BeginDateEnd
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
                         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                      )
  -- считаем кол-во дней пердоставленного отпуска
  , tmpHoliday AS (SELECT CASE WHEN inisDetail = TRUE THEN tmpData.InvNumber          ELSE ''   END :: TVarChar  AS InvNumber
                        , CASE WHEN inisDetail = TRUE THEN tmpData.OperDate           ELSE NULL END :: TDateTime AS OperDate
                        , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateStart  ELSE NULL END :: TDateTime AS OperDateStart
                        , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateEnd    ELSE NULL END :: TDateTime AS OperDateEnd
                        , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateStart ELSE NULL END :: TDateTime AS BeginDateStart
                        , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateEnd   ELSE NULL END :: TDateTime AS BeginDateEnd
                        , tmpData.MemberId
                        , SUM (DATE_PART ('DAY', tmpData.BeginDateEnd - tmpData.BeginDateStart) +1)  :: TFloat AS Day_holiday
                        , ROW_NUMBER(*) OVER (PARTITION BY tmpData.MemberId ORDER BY tmpData.MemberId) AS Ord
                        , SUM ( SUM(DATE_PART ('DAY', tmpData.BeginDateEnd - tmpData.BeginDateStart) +1 ) )  OVER (PARTITION BY tmpData.MemberId ORDER BY tmpData.MemberId) AS Day_holiday_All
                   FROM tmpMov_Holiday AS tmpData
                   GROUP BY CASE WHEN inisDetail = TRUE THEN tmpData.InvNumber         ELSE ''   END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.OperDate          ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateStart ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.OperDateEnd   ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateStart ELSE NULL END
                          , CASE WHEN inisDetail = TRUE THEN tmpData.BeginDateEnd   ELSE NULL END
                          , tmpData.MemberId
                   HAVING SUM (DATE_PART ('DAY', tmpData.BeginDateEnd - tmpData.BeginDateStart) +1 ) <> 0
                   )
    -- св€зываемданные положенных дней отпуска и фоактич.
    -- –езультат

    SELECT tmpVacation.MemberId
         , tmpPersonal.PersonalId
         , tmpPersonal.PersonalCode
         , tmpPersonal.PersonalName
         , tmpPersonal.PositionId
         , tmpPersonal.PositionCode
         , tmpPersonal.PositionName
         , tmpPersonal.PositionLevelName
         , tmpPersonal.UnitCode
         , tmpPersonal.UnitName
         , tmpPersonal.BranchName
         , tmpPersonal.PersonalGroupName
         , tmpPersonal.StorageLineName
         , tmpPersonal.DateIn
         , tmpPersonal.DateOut_user AS DateOut
         , tmpPersonal.isDateOut
         , tmpPersonal.isMain
         , tmpPersonal.isOfficial
         --, tmpPersonal.Age_work      :: TVarChar
         , tmpVacation.Month_work    :: TFloat
         , tmpVacation.Day_calendar  :: TFloat
         , CASE WHEN tmpHoliday.Ord = 1 OR tmpHoliday.Ord IS NULL THEN tmpVacation.Day_vacation ELSE 0 END :: TFloat AS Day_vacation 
         , tmpHoliday.Day_holiday    :: TFloat                                                                       -- использовано 
         , CASE WHEN tmpHoliday.Ord = 1 OR tmpHoliday.Ord IS NULL THEN (COALESCE (tmpVacation.Day_vacation, 0) - COALESCE (tmpHoliday.Day_holiday_All, 0)) ELSE 0 END  :: TFloat AS Day_diff   -- не использовано   
         , tmpHoliday.InvNumber          :: TVarChar 
         , tmpHoliday.OperDate           :: TDateTime
         , tmpHoliday.OperDateStart  :: TDateTime
         , tmpHoliday.OperDateEnd    :: TDateTime
         , tmpHoliday.BeginDateStart  :: TDateTime
         , tmpHoliday.BeginDateEnd    :: TDateTime
    FROM tmpVacation
         LEFT JOIN tmpHoliday ON tmpHoliday.MemberId = tmpVacation.MemberId

         LEFT JOIN tmpMemberPersonal ON tmpMemberPersonal.MemberId = tmpVacation.MemberId
         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmpVacation.MemberId
                              AND tmpPersonal.PositionId = tmpMemberPersonal.PositionId
                              AND tmpPersonal.UnitId = tmpMemberPersonal.UnitId
                              
    ORDER BY tmpPersonal.UnitName
           , tmpPersonal.PersonalName
           , tmpPersonal.PositionName
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- тест
-- select * from gpReport_HolidayPersonal(inStartDate := ('01.01.2019')::TDateTime , inUnitId := 8384 , inMemberId := 0 , inisDetail := 'True'::Boolean,  inSession := '5'::TVarChar);


