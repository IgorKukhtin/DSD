-- Function: gpReport_HolidayCompensation ()

DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayCompensation(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inUnitId         Integer,   --�������������
    IN inPersonalId     Integer,   --���������
    IN inPositionId     Integer,   --���������
    IN inSession        TVarChar   --������ ������������
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
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbMonthHoliday TFloat;
    DECLARE vbDayHoliday   TFloat;
    DECLARE vbCountDay     TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    
    -- ���-�� ������� ����� ���� ������� ������ - 1 ������ - ����� 6 �. ������������ �����
    vbMonthHoliday := 6;
    -- ���-�� ���������� ���� �������
    vbDayHoliday := 14;

    -- ����������� ���� � ����
    vbCountDay := (SELECT COUNT (*) - SUM (CASE WHEN Working = FALSE AND DayOfWeekName NOT IN ('�������', '�����������') THEN 1 ELSE 0 END)
                   FROM gpSelect_Object_Calendar (inStartDate := inStartDate - INTERVAL '1 YEAR' , inEndDate := inStartDate + INTERVAL '1 DAY',  inSession := inSession)) :: TFloat;
    -- ���������
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
                       , tmp.Day_holiday   -- ������������ 
                       , tmp.Day_diff      -- �� ������������   
                    FROM gpReport_HolidayPersonal (inStartDate:= inStartDate, inUnitId:= inUnitId, inPersonalId:= inPersonalId, inPositionId:= inPositionId, inisDetail:= FALSE, inSession:= inSession) AS tmp
                   )

  , tmpMovement AS (SELECT Movement.Id                                                                          -- ����� ����������
                    FROM Movement
                    WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '1 YEAR' AND inStartDate + INTERVAL '1 DAY' 
                      AND Movement.DescId = zc_Movement_PersonalService()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
  
  , tmpPersonalService AS (SELECT MovementItem.ObjectId          AS PersonalId
                                , MILinkObject_Position.ObjectId AS PositionId
                                , CASE WHEN vbCountDay <> 0 THEN (SUM (COALESCE (MIFloat_SummToPay.ValueData, 0)) / 12 / vbCountDay) ELSE 0 END AS AmountCompensation
                           FROM tmpMovement AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                                       AND (MovementItem.ObjectId  = inPersonalId OR inPersonalId = 0)
                                INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 AND (MILinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                  ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                                 AND (MILinkObject_Position.ObjectId = inPositionId OR inPositionId = 0)
                                LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                            ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                           GROUP BY MovementItem.ObjectId
                                  , MILinkObject_Position.ObjectId
                           )

    -- ���������
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
         , tmpReport.Day_holiday    :: TFloat       -- ������������ 
         , tmpReport.Day_diff       :: TFloat       -- �� ������������   
         , tmpPersonalService.AmountCompensation                        :: TFloat
         , (tmpPersonalService.AmountCompensation * tmpReport.Day_diff) :: TFloat AS SummaCompensation
    FROM tmpReport
         LEFT JOIN tmpPersonalService ON tmpPersonalService.PersonalId = tmpReport.PersonalId
                                     AND tmpPersonalService.PositionId = tmpReport.PositionId
    ORDER BY tmpReport.UnitName
           , tmpReport.PersonalName
           , tmpReport.PositionName
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- ����
-- SELECT * FROM gpReport_HolidayCompensation (inStartDate:= '03.11.2018', inUnitId:= 8439, inPersonalId:= 0, inPositionId:= 0, inSession:= '5');
