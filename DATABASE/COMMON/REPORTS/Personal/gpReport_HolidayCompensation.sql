-- Function: gpReport_HolidayCompensation ()

DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HolidayCompensation (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HolidayCompensation(
    IN inStartDate                 TDateTime, --���� ������ �������
    IN inUnitId                    Integer,   --�������������
    IN inMemberId                  Integer,   --���������
    IN inPersonalServiceListId     Integer,   -- ��������� ����������(�������)
    --IN inPositionId     Integer,   --���������
    IN inSession                   TVarChar   --������ ������������
)
RETURNS TABLE(MemberId Integer
            , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
            , PositionId Integer, PositionCode Integer, PositionName TVarChar
            , UnitId Integer, UnitCode Integer, UnitName TVarChar
            , BranchName TVarChar
            , PersonalGroupName TVarChar
            , PersonalServiceListName TVarChar
            , DateIn TDateTime, DateOut TDateTime
            , isDateOut Boolean, isMain Boolean, isOfficial Boolean
            , isNotCompensation Boolean
            , Day_vacation           TFloat
            , Day_holiday            TFloat -- ���� ������� �� ������
            , Day_diff               TFloat

            , Day_hol_NoZp           TFloat    -- ������ ��� ����. �� ������
            , Day_holiday_NoZp       TFloat    -- ������ ��� ����. �� ���. ������
            , Day_vacation_NoZp      TFloat
            , Day_diff_NoZp          TFloat    --

            , AmountCompensation     TFloat
            , SummaCompensation      TFloat
            , SummaCompensation_fact TFloat -- ����������� �� ���. ��������� ����������
            , SummaCompensation_diff TFloat
            , Day_calendar           TFloat -- �����. ���� - �� ������
            , Day_calendar_year      TFloat -- �����. ���� - �� ���
            , Day_Holiday_cl         TFloat -- Holiday ���� - �� ������
            , Day_Holiday_year_cl    TFloat -- Holiday ���� - �� ���
            , Amount                 TFloat -- ����� �� �� ������ (����� ��������� + ���������)
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbMonthHoliday TFloat;
    DECLARE vbDayHoliday   TFloat;
    --DECLARE vbCountDay     TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

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
                                          INNER JOIN Object AS Object_MemberPersonalServiceList
                                                            ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                                                           AND Object_MemberPersonalServiceList.isErased = FALSE
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
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
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
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
                                    UNION
                                     -- ����� � ������ ����� ����
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND EXISTS (SELECT 1 FROM tmpUserAll)
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
                                    UNION
                                     -- ����� � ������ ����� ����
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
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
                       , tmp.UnitId
                       , tmp.UnitCode
                       , tmp.UnitName
                       , tmp.BranchName
                       , tmp.PersonalGroupName
                       , tmp.StorageLineName
                       , tmp.PersonalServiceListName
                       , tmp.DateIn
                       , tmp.DateOut
                       , tmp.isDateOut
                       , tmp.isMain
                       , tmp.isOfficial
                       , tmp.isNotCompensation
                       , tmp.Day_vacation
                       , tmp.Day_holiday       -- ������������ ���� �������
                       , tmp.Day_diff          -- �� ������������ ���� �������
                       , tmp.Day_hol_NoZp
                       , tmp.Day_holiday_NoZp
                       , tmp.Day_vacation_NoZp
                       , tmp.Day_diff_NoZp
                       , tmp.Day_calendar        -- �����. ����
                       , tmp.Day_calendar_year   -- �����. ����
                       , tmp.Day_Holiday_cl      -- Holiday ����
                       , tmp.Day_Holiday_year_cl -- Holiday ����

                    FROM gpReport_HolidayPersonal (inStartDate:= inStartDate, inUnitId:= inUnitId, inMemberId:= inMemberId, inPersonalServiceListId := inPersonalServiceListId, inisDetail:= FALSE, inSession:= inSession) AS tmp
                   )

  , tmpMember_day AS (SELECT tmpReport.MemberId, MIN (tmpReport.DateIn) AS DateIn
                      FROM tmpReport
                      GROUP BY tmpReport.MemberId
                     )

  , tmpMovement AS (SELECT Movement.Id
                         , MovementDate.ValueData AS ServiceDate
                    FROM MovementDate
                         INNER JOIN Movement ON Movement.Id       = MovementDate.MovementId
                                            AND Movement.DescId   = zc_Movement_PersonalService()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                    WHERE MovementDate.ValueData BETWEEN inStartDate - INTERVAL '1 YEAR' + INTERVAL '1 DAY' AND inStartDate
                      AND MovementDate.DescId = zc_MIDate_ServiceDate()
                   )
  , tmpPersonalService AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                , SUM (CASE WHEN DATE_TRUNC ('MONTH', tmpMember_day.DateIn) <= DATE_TRUNC ('MONTH', Movement.ServiceDate)
                                                 THEN COALESCE (MIFloat_SummService.ValueData, 0) + COALESCE (MIFloat_SummHoliday.ValueData, 0) + COALESCE (MIFloat_SummHospOth.ValueData, 0)
                                            ELSE 0
                                       END) AS Amount
                           FROM tmpMovement AS Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                            AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_CompensationNot
                                                        ON ObjectBoolean_CompensationNot.ObjectId  = MovementLinkObject_PersonalServiceList.ObjectId
                                                       AND ObjectBoolean_CompensationNot.DescId    = zc_ObjectBoolean_PersonalServiceList_CompensationNot()
                                                       AND ObjectBoolean_CompensationNot.ValueData = TRUE

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

                                LEFT JOIN tmpMember_day ON tmpMember_day.MemberId = ObjectLink_Personal_Member.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                     ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem.ObjectId
                                                    AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()

                                LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                                LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                            ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                            ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
                                LEFT JOIN MovementItemFloat AS MIFloat_SummHospOth
                                                            ON MIFloat_SummHospOth.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummHospOth.DescId = zc_MIFloat_SummHospOth()
                           WHERE tmpMemberPersonalServiceList.PersonalServiceListId > 0
                             AND (ObjectLink_Personal_PersonalServiceList.ChildObjectId = inPersonalServiceListId OR inPersonalServiceListId = 0)
                             -- ��������� �� ������� ����������� ��� �������
                             AND ObjectBoolean_CompensationNot.ObjectId IS NULL

                           GROUP BY ObjectLink_Personal_Member.ChildObjectId
                           )
  -- ����� ���. ��� ����������� ������� ����������� �� ��������
  -- ����� - ���� � ������ 31.12.2019, ����� �������� zc_Movement_PersonalService �� ������ � 01.01.2020 �� 30.06.2020, �.�. + 6 �������, �.�. ��������� ����������� � ������� �������
  , tmpMovementCompens AS (SELECT Movement.Id
                           FROM Movement
                           WHERE Movement.DescId   = zc_Movement_PersonalService()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.OperDate BETWEEN inStartDate + INTERVAL '1 DAY' AND inStartDate + INTERVAL '6 MONTH'
                          )
  , tmpMICompens AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                          , SUM (COALESCE (MIFloat_SummCompensation.ValueData,0)) ::TFloat AS SummCompensation
                     FROM tmpMovementCompens AS Movement
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

                          INNER JOIN MovementItemFloat AS MIFloat_SummCompensation
                                                       ON MIFloat_SummCompensation.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummCompensation.DescId =zc_MIFloat_SummCompensation()
                                                      AND COALESCE (MIFloat_SummCompensation.ValueData,0) <> 0
                     GROUP BY ObjectLink_Personal_Member.ChildObjectId
                     )

    -- ���������
    SELECT tmpReport.MemberId
         , tmpReport.PersonalId
         , tmpReport.PersonalCode
         , tmpReport.PersonalName
         , tmpReport.PositionId
         , tmpReport.PositionCode
         , tmpReport.PositionName
         , tmpReport.UnitId
         , tmpReport.UnitCode
         , tmpReport.UnitName
         , tmpReport.BranchName
         , tmpReport.PersonalGroupName
         , tmpReport.PersonalServiceListName
         , tmpReport.DateIn
         , tmpReport.DateOut
         , tmpReport.isDateOut
         , tmpReport.isMain
         , tmpReport.isOfficial
         , tmpReport.isNotCompensation
           -- ������� ������, ����
         , tmpReport.Day_vacation     :: TFloat
           -- ������������ ���� �������
         , tmpReport.Day_holiday      :: TFloat
           -- �� ������������ ���� �������
         , CASE WHEN tmpReport.isNotCompensation = FALSE THEN tmpReport.Day_diff ELSE 0 END :: TFloat AS Day_diff

           --������ ��� ������
         , tmpReport.Day_hol_NoZp     :: TFloat
         , tmpReport.Day_holiday_NoZp :: TFloat
         , tmpReport.Day_vacation_NoZp:: TFloat     -- �������� ���� ��� ���� =  ������� ������, ����
         , tmpReport.Day_diff_NoZp    :: TFloat     -- �� ������������ ���� �������  ��� ����

           -- ��. �� �� ����
         , CASE WHEN tmpReport.Day_calendar_year <> 0 THEN tmpPersonalService.Amount / tmpReport.Day_calendar_year ELSE 0 END :: TFloat AS AmountCompensation
           -- ����� �������. �� �����. ������
         , CAST (CASE WHEN tmpReport.Day_diff > 0 AND tmpReport.isNotCompensation = FALSE
                           THEN tmpReport.Day_diff * CASE WHEN tmpReport.Day_calendar_year <> 0 THEN tmpPersonalService.Amount / tmpReport.Day_calendar_year ELSE 0.0 END
                      ELSE 0.0
                 END AS NUMERIC (16, 2)) :: TFloat AS SummaCompensation
           -- ����� �������. �� �����. ������ (����)
         , tmpMICompens.SummCompensation :: TFloat AS SummaCompensation_fact
           -- ����. �� ����� �������. ������ � ����
         , (CAST (CASE WHEN tmpReport.Day_diff > 0 AND tmpReport.isNotCompensation = FALSE
                            THEN tmpReport.Day_diff * CASE WHEN tmpReport.Day_calendar_year <> 0 THEN tmpPersonalService.Amount / tmpReport.Day_calendar_year ELSE 0.0 END
                       ELSE 0.0
                  END AS NUMERIC (16, 2))
          - COALESCE (tmpMICompens.SummCompensation, 0)) :: TFloat AS SummaCompensation_diff

           -- �����. ����
         , tmpReport.Day_calendar        :: TFloat
         , tmpReport.Day_calendar_year   :: TFloat
           -- �����. ����
         , tmpReport.Day_Holiday_cl      :: TFloat
         , tmpReport.Day_Holiday_year_cl :: TFloat
           -- ����� �� �� ������
         , tmpPersonalService.Amount     :: TFloat

    FROM tmpReport
         LEFT JOIN tmpPersonalService ON tmpPersonalService.MemberId = tmpReport.MemberId
                                     AND COALESCE (tmpPersonalService.Amount, 0) > 0
         LEFT JOIN tmpMICompens ON tmpMICompens.MemberId = tmpReport.MemberId
    ORDER BY tmpReport.UnitName
           , tmpReport.PersonalName
           , tmpReport.PositionName
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.02.23         *
 05.02.20         *
 30.01.19         *
 25.12.18         *
*/
-- ����
-- SELECT * FROM gpReport_HolidayCompensation(inStartDate := ('01.01.2024')::TDateTime , inUnitId := 8384 , inMemberId := 442269 , inPersonalServiceListId:=0,  inSession := '5');
