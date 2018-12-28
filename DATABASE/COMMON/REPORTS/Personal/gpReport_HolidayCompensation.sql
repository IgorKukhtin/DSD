-- Function: gpReport_HolidayCompensation ()

DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayCompensation(
    IN inStartDate      TDateTime, --дата начала периода
    IN inUnitId         Integer,   --подразделение
    IN inMemberId       Integer,   --сотрудник
    --IN inPositionId     Integer,   --должность
    IN inSession        TVarChar   --сесси€ пользовател€
)
RETURNS TABLE(MemberId Integer, PersonalId Integer
            , PersonalCode Integer, PersonalName TVarChar
            , PositionCode Integer, PositionName TVarChar
            , UnitCode Integer, UnitName TVarChar
            , BranchName TVarChar
            , PersonalGroupName TVarChar
            , DateIn TDateTime, DateOut TDateTime
            , isDateOut Boolean, isMain Boolean, isOfficial Boolean
            , Day_vacation  TFloat
            , Day_holiday   TFloat
            , Day_diff      TFloat
            , AmountCompensation TFloat
            , SummaCompensation  TFloat
            , Day_calendar  TFloat
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbMonthHoliday TFloat;
    DECLARE vbDayHoliday   TFloat;
    --DECLARE vbCountDay     TFloat;
BEGIN
    -- проверка прав пользовател€ на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    
    -- кол-во мес€цев после чего положен отпуск - 1 отпуск - после 6 м. непрерывного стажа
    vbMonthHoliday := 6;
    -- кол-во положенных дней отпуска
    vbDayHoliday := 14;

    -- календарных дней в году
    /*vbCountDay := (SELECT COUNT (*) - SUM (CASE WHEN gpSelect.isHoliday = TRUE THEN 1 ELSE 0 END)
                   FROM gpSelect_Object_Calendar (inStartDate := inStartDate - INTERVAL '1 YEAR' , inEndDate := inStartDate - INTERVAL '1 DAY',  inSession := inSession) AS gpSelect
                   ) :: TFloat;
    */
    -- –езультат
    RETURN QUERY

    WITH
    tmpReport AS (SELECT tmp.MemberId
                       , tmp.PersonalId
                       , tmp.PersonalCode
                       , tmp.PersonalName
                       , tmp.PositionId
                       , tmp.PositionCode
                       , tmp.PositionName
                       , tmp.UnitCode
                       , tmp.UnitName
                       , tmp.BranchName
                       , tmp.PersonalGroupName
                       , tmp.StorageLineName
                       , tmp.DateIn
                       , tmp.DateOut
                       , tmp.isDateOut
                       , tmp.isMain
                       , tmp.isOfficial
                       , tmp.Day_vacation
                       , tmp.Day_holiday   -- использовано 
                       , tmp.Day_diff      -- не использовано   
                       , tmp.Day_calendar
                    FROM gpReport_HolidayPersonal (inStartDate:= inStartDate, inUnitId:= inUnitId, inMemberId:= inMemberId, inisDetail:= FALSE, inSession:= inSession) AS tmp
                   )

  , tmpMovement AS (SELECT Movement.Id                                                                          -- итого отработано
                    FROM Movement
                    WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '1 YEAR' AND inStartDate - INTERVAL '1 DAY' 
                      AND Movement.DescId = zc_Movement_PersonalService()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
  
  , tmpPersonalService AS (SELECT ObjectLink_Personal_Member.ChildObjectId  AS MemberId
                                , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0)) AS Amount
                           FROM tmpMovement AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                                                
                                INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 AND (MILinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                     AND (ObjectLink_Personal_Member.ChildObjectId = inMemberId OR inMemberId = 0)
                                               
                                LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                            ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                           GROUP BY ObjectLink_Personal_Member.ChildObjectId
                           )

    -- –езультат
    SELECT tmpReport.MemberId
         , tmpReport.PersonalId
         , tmpReport.PersonalCode
         , tmpReport.PersonalName
         , tmpReport.PositionCode
         , tmpReport.PositionName
         , tmpReport.UnitCode
         , tmpReport.UnitName
         , tmpReport.BranchName
         , tmpReport.PersonalGroupName
         , tmpReport.DateIn
         , tmpReport.DateOut
         , tmpReport.isDateOut
         , tmpReport.isMain
         , tmpReport.isOfficial
         , tmpReport.Day_vacation   :: TFloat
         , tmpReport.Day_holiday    :: TFloat       -- использовано 
         , tmpReport.Day_diff       :: TFloat       -- не использовано   

         , CASE WHEN tmpReport.Day_calendar <> 0 THEN tmpPersonalService.Amount / tmpReport.Day_calendar ELSE 0 END                        :: TFloat AS AmountCompensation
         , (tmpReport.Day_diff * CASE WHEN tmpReport.Day_calendar <> 0 THEN tmpPersonalService.Amount / tmpReport.Day_calendar ELSE 0 END) :: TFloat AS SummaCompensation
         , tmpReport.Day_calendar :: TFloat
    FROM tmpReport
         LEFT JOIN tmpPersonalService ON tmpPersonalService.MemberId = tmpReport.MemberId
                                     AND COALESCE (tmpPersonalService.Amount, 0) > 0
    ORDER BY tmpReport.UnitName
           , tmpReport.PersonalName
           , tmpReport.PositionName
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- тест
-- select * from gpReport_HolidayCompensation(inStartDate := ('01.01.2019')::TDateTime , inUnitId := 8384 , inMemberId := 442269 ,  inSession := '5');