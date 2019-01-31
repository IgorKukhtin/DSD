-- Function: gpReport_HolidayCompensation ()

DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayCompensation(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inUnitId         Integer,   --�������������
    IN inMemberId       Integer,   --���������
    --IN inPositionId     Integer,   --���������
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
            , Day_calendar  TFloat
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbMonthHoliday TFloat;
    DECLARE vbDayHoliday   TFloat;
    --DECLARE vbCountDay     TFloat;
BEGIN
IF inSession <> '5' THEN
return;
end if;
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    
    -- ���-�� ������� ����� ���� ������� ������ - 1 ������ - ����� 6 �. ������������ �����
    vbMonthHoliday := 6;
    -- ���-�� ���������� ���� �������
    vbDayHoliday := 14;

    -- ����������� ���� � ����
    /*vbCountDay := (SELECT COUNT (*) - SUM (CASE WHEN gpSelect.isHoliday = TRUE THEN 1 ELSE 0 END)
                   FROM gpSelect_Object_Calendar (inStartDate := inStartDate - INTERVAL '1 YEAR' , inEndDate := inStartDate - INTERVAL '1 DAY',  inSession := inSession) AS gpSelect
                   ) :: TFloat;
    */
    -- ���������
    RETURN QUERY

    WITH
     tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- ���������-���� (����������) AND <> ����� �.�. + �� �������� ���
   , tmpMemberPersonalServiceList AS (SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM ObjectLink AS ObjectLink_User_Member
                                          INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                                                ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                               AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                                          LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                                 AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
                                          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                                               ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                              AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                                        AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                                                          OR ObjectBoolean.ValueData          = TRUE)
                                     WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                    UNION
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM ObjectLink AS ObjectLink_User_Member
                                          INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                                ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                               AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                                          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                                        AND Object_PersonalServiceList.Id     = ObjectLink_PersonalServiceList_Member.ObjectId
                                     WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                    UNION
                                     -- ����� � ������ ����� ����
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND EXISTS (SELECT 1 FROM tmpUserAll)
                                    UNION
                                     -- ����� � ������ ����� ����
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
                                    /*UNION
                                     -- "�� ��������" ����� "����� �.�."
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND vbUserId = 106593*/
                                    )

  , tmpReport AS (SELECT tmp.MemberId
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
                       , tmp.Day_calendar
                    FROM gpReport_HolidayPersonal (inStartDate:= inStartDate, inUnitId:= inUnitId, inMemberId:= inMemberId, inisDetail:= FALSE, inSession:= inSession) AS tmp
                   )

  , tmpMovement AS (SELECT Movement.Id
                    FROM Movement
                    WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '1 YEAR' AND inStartDate - INTERVAL '1 DAY' 
                      AND Movement.DescId = zc_Movement_PersonalService()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
  
  , tmpPersonalService AS (SELECT ObjectLink_Personal_Member.ChildObjectId        AS MemberId
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

                                LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                     ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem.ObjectId
                                                    AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()

                                LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                                LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                            ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()

                           WHERE tmpMemberPersonalServiceList.PersonalServiceListId > 0
                           GROUP BY ObjectLink_Personal_Member.ChildObjectId
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

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.01.19         *
 25.12.18         *
*/
-- ����
-- select * from gpReport_HolidayCompensation(inStartDate := ('01.01.2019')::TDateTime , inUnitId := 8384 , inMemberId := 442269 ,  inSession := '5');