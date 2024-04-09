-- Function: gpSelect_HolidayCompensation_day ()

DROP FUNCTION IF EXISTS gpSelect_HolidayCompensation_day (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_HolidayCompensation_day(
    IN inStartDate                 TDateTime, --���� ������ �������
    IN inUnitId                    Integer,   --�������������
    IN inMemberId                  Integer,   --���������
    IN inPersonalServiceListId     Integer,   -- ��������� ����������(�������)
    IN inSession                   TVarChar   --������ ������������
)
RETURNS TABLE(OperDate_year TDateTime, OperDate TDateTime
            , YEAR Integer
            , IsWork      Boolean 
            , isHoliday   Boolean
            , isHoliday_year Boolean
            , isHoliday_NoZp Boolean
            , OperDate_year_amount TFloat 
            , OperDate_amount TFloat
            , Holiday TFloat
            , Holiday_year TFloat
            , Holiday_NoZp TFloat
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
    DECLARE vbStartDate    TDateTime;
    DECLARE vbStartDate_year TDateTime;
    DECLARE vbEndDate      TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

    -- ��������� ����  ���
    vbStartDate := DATE_TRUNC ('YEAR', inStartDate);
    -- ��������� ���� - ����� ���
    vbStartDate_year := inStartDate - INTERVAL '1 YEAR' + INTERVAL '1 DAY';
    -- ���� !!!���������!!! ������� - ��� ������� ��������� ���� ������
    vbEndDate   := inStartDate;


    RETURN QUERY
    --tmpListDate AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)

    WITH
    -- ��� ����������
    tmpMemberPersonal AS (SELECT ObjectLink_Personal_Member.ChildObjectId         AS MemberId
                                 -- ���� ��������
                               , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd())  AS DateIn
                                 -- ���� ����������
                               , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) AS DateOut
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut_user
                                 -- ������ �� ���������
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut
                                 -- �������� ����� ������
                               , COALESCE (ObjectBoolean_Main.ValueData, FALSE)     AS isMain
                                 -- �� ������ ������ - ���� 2 ���� ���. ����� ������, �������� ������ ������ ����
                               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                    -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                    ORDER BY -- ���� �������� ����� ������
                                                             CASE WHEN COALESCE (ObjectBoolean_Main.ValueData, FALSE) = TRUE THEN 0 ELSE 1 END
                                                             -- ���� �� ������
                                                           , CASE WHEN Object_Personal.isErased = FALSE THEN 0 ELSE 1 END
                                                             -- ���� ����������� ����� ������
                                                           , CASE WHEN COALESCE (ObjectBoolean_Official.ValueData, FALSE) = TRUE THEN 0 ELSE 1 END
                                                             -- � ������������ ����� ����������
                                                           , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) DESC
                                                             -- � ������ ����� ��������
                                                           , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ASC
                                                           , ObjectLink_Personal_Member.ObjectId
                                                   ) AS Ord
                                 -- ��������� �� ���� ���������� - ����� ������ ����������� ������
                               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                    -- ����������� ������������ ��������� ��� ������, �.�. �������� � Ord = 1
                                                    ORDER BY -- !!!������ ���� ������!!!
                                                             CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) <= vbEndDate THEN 0 ELSE 1 END
                                                             -- ���� �� �������� ����� ������
                                                           , CASE WHEN COALESCE (ObjectBoolean_Main.ValueData, FALSE) = FALSE THEN 0 ELSE 1 END
                                                             -- � ������������ ����� ����������
                                                           , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) DESC
                                                             -- � ������ ����� ��������
                                                           , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ASC
                                                           , ObjectLink_Personal_Member.ObjectId
                                                   ) AS Ord_out
                          FROM ObjectLink AS ObjectLink_Personal_Member
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId

                               LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                                    ON ObjectDate_DateIn.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectDate_DateIn.DescId   = zc_ObjectDate_Personal_In()
                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                    ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                    ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                                      
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                          WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                            AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                            AND (ObjectLink_Personal_Member.ChildObjectId = inMemberId )    --OR inMemberId = 0
                            --AND (ObjectLink_Personal_Unit.ChildObjectId = inUnitId OR inUnitId = 0) --�������� �� ���� ��������������, ���� ����� ���� ���������� �������� ���� ������ �� ������ (����� ���� �������� �� ��������������)
                            AND (ObjectLink_Personal_PersonalServiceList.ChildObjectId = inPersonalServiceListId OR inPersonalServiceListId = 0)
                         )

    -- ���������� - ������ �������� ����� ������ � ������ ����
  , tmpList_one AS (SELECT tmpMemberPersonal.*
                    FROM tmpMemberPersonal
                    WHERE tmpMemberPersonal.isMain = TRUE
                      AND tmpMemberPersonal.Ord    = 1
                   )
    -- ���� ������ ������ �� �����������
  , tmpStart AS (SELECT tmpList.MemberId
                      , COALESCE (tmpList5.DateIn, tmpList4.DateIn, tmpList3.DateIn, tmpList2.DateIn, tmpList1.DateIn, tmpList.DateIn) AS DateIn
                 FROM tmpList_one AS tmpList
                      -- ������ ���������
                      LEFT JOIN tmpMemberPersonal AS tmpList1
                                                  ON tmpList1.MemberId  = tmpList.MemberId
                                                 -- ����������� ������ � ������ �� ������ �� ��������� ����
                                                 AND tmpList1.DateOut   = tmpList.DateIn - '1 DAY' :: INTERVAL
                                                 -- ����������� ������
                                                 AND tmpList1.isDateOut = TRUE
                                                 -- c ������������ ����� ���������� + ����������� ����� ������
                                                 AND tmpList1.Ord_Out   = 1
                      -- ���������
                      LEFT JOIN tmpMemberPersonal AS tmpList2
                                                  ON tmpList2.MemberId  = tmpList.MemberId
                                                 -- ����������� ������ � ������ �� ������ �� ��������� ����
                                                 AND tmpList2.DateOut   = tmpList1.DateIn - '1 DAY' :: INTERVAL
                                                 -- ����������� ������
                                                 AND tmpList2.isDateOut = TRUE
                                                 -- c ������������ ����� ���������� + ����������� ����� ������
                                                 AND tmpList2.Ord_Out   = 2
                      -- ���������
                      LEFT JOIN tmpMemberPersonal AS tmpList3
                                                  ON tmpList3.MemberId  = tmpList.MemberId
                                                 -- ����������� ������ � ������ �� ������ �� ��������� ����
                                                 AND tmpList3.DateOut   = tmpList2.DateIn - '1 DAY' :: INTERVAL
                                                 -- ����������� ������
                                                 AND tmpList3.isDateOut = TRUE
                                                 -- c ������������ ����� ���������� + ����������� ����� ������
                                                 AND tmpList3.Ord_Out   = 3
                      -- ���������
                      LEFT JOIN tmpMemberPersonal AS tmpList4
                                                  ON tmpList4.MemberId  = tmpList.MemberId
                                                 -- ����������� ������ � ������ �� ������ �� ��������� ����
                                                 AND tmpList4.DateOut   = tmpList3.DateIn - '1 DAY' :: INTERVAL
                                                 -- ����������� ������
                                                 AND tmpList4.isDateOut = TRUE
                                                 -- c ������������ ����� ���������� + ����������� ����� ������
                                                 AND tmpList4.Ord_Out   = 4
                      -- ���������
                      LEFT JOIN tmpMemberPersonal AS tmpList5
                                                  ON tmpList5.MemberId  = tmpList.MemberId
                                                 -- ����������� ������ � ������ �� ������ �� ��������� ����
                                                 AND tmpList5.DateOut   = tmpList4.DateIn - '1 DAY' :: INTERVAL
                                                 -- ����������� ������
                                                 AND tmpList5.isDateOut = TRUE
                                                 -- c ������������ ����� ���������� + ����������� ����� ������
                                                 AND tmpList5.Ord_Out   = 5
                 )
        -- ���������� - ������� ������
      , tmpList AS (SELECT tmpList_one.*
                         , tmpStart.DateIn AS DateIn_real
                           -- ������ - ��� ���� ������ ������ - ��� ���� �������� �� ������ - ��� ������� ������� ������������ ���� ������ �� ������
                         , CASE WHEN tmpStart.DateIn > vbStartDate THEN tmpStart.DateIn ELSE vbStartDate END AS DateIn_Calc
                           -- ������ - ��� ���� ������ ������ - ��� ���� �������� �� ������ - ��� ������� ������� ������������ ���� �� ���
                         , CASE WHEN tmpStart.DateIn > vbStartDate_year THEN tmpStart.DateIn ELSE vbStartDate_year END AS DateIn_Calc_year
                           -- ������ - ��� ���� ��������� ������ - ��� ���� ���������� - ��� ������� ������� ������������ ���� ������ �� ������
                         , CASE WHEN tmpList_one.DateOut < vbEndDate THEN tmpList_one.DateOut ELSE vbEndDate END AS DateOut_Calc
                    FROM tmpList_one
                         LEFT JOIN tmpStart ON tmpStart.MemberId = tmpList_one.MemberId
                   )
    -- ������ - ��� � ����� ��� ���� ������
  , MI_SheetWorkTime AS (SELECT DISTINCT
                                Movement.OperDate
                              , MI_SheetWorkTime.ObjectId AS MemberId
                              --�������� ������ ��� ���������� ��
                              , CASE WHEN MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_HolidayNoZp() THEN True ELSE False END AS isHolidayNoZp
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                              INNER JOIN MovementItem AS MI_SheetWorkTime
                                                      ON MI_SheetWorkTime.MovementId = Movement.Id
                                                     AND MI_SheetWorkTime.isErased = FALSE
                              INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                               AND MIObject_WorkTimeKind.DescId         = zc_MILinkObject_WorkTimeKind()
                                                               AND MIObject_WorkTimeKind.ObjectId       IN (zc_Enum_WorkTimeKind_Holiday()     -- ������
                                                                                                          , zc_Enum_WorkTimeKind_HolidayNoZp() -- ������ ��� ����.��
                                                                                                           )
                         WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                           AND Movement.OperDate BETWEEN vbStartDate_year AND vbEndDate
                           AND MI_SheetWorkTime.ObjectId = inMemberId
                        )
   --��� ���
   , tmpListDate AS (SELECT GENERATE_SERIES ((SELECT tmpList.DateIn_Calc_year FROM tmpList)
                                           , (SELECT tmpList.DateOut_Calc FROM tmpList), '1 DAY' :: INTERVAL) AS OperDate)

    -- ���������
    SELECT tmpListDate.OperDate::TDateTime AS OperDate_year
         
         , CASE WHEN tmpListDate.OperDate BETWEEN (SELECT tmpList.DateIn_Calc FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                 AND MI_SheetWorkTime.OperDate IS NULL THEN tmpListDate.OperDate
               ELSE NULL
           END ::TDateTime AS OperDate
          
         , DATE_PART ('YEAR', tmpListDate.OperDate) ::Integer AS YEAR
         , CASE WHEN tmpCalendar.Working = True THEN True
                ELSE FALSE
           END ::Boolean AS IsWork

        , CASE WHEN MI_SheetWorkTime.OperDate IS NULL THEN FALSE
                ELSE TRUE
           END ::Boolean AS isHoliday
        , CASE WHEN MI_SheetWorkTime_year.OperDate IS NULL THEN FALSE
                ELSE TRUE
           END ::Boolean AS isHoliday_year
        , CASE WHEN MI_SheetWorkTime_NoZp.OperDate IS NULL THEN FALSE
               ELSE TRUE
          END ::Boolean AS isHoliday_NoZp
          
          --��� ������ 
        , CASE WHEN MI_SheetWorkTime.OperDate IS NULL THEN 1
               ELSE 0
           END ::TFloat AS OperDate_year_amount  --   ������� ��� ���
           
        , CASE WHEN tmpListDate.OperDate BETWEEN (SELECT tmpList.DateIn_Calc FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                 AND MI_SheetWorkTime.OperDate IS NULL THEN 1
               ELSE 0
           END ::TFloat AS OperDate_amount          -- ���. ����  �� ���

        , CASE WHEN MI_SheetWorkTime.OperDate IS NULL THEN 0
                ELSE 1
           END ::TFloat AS Holiday
        , CASE WHEN MI_SheetWorkTime_year.OperDate IS NULL THEN 0
                ELSE 1
           END ::TFloat AS Holiday_year
        , CASE WHEN MI_SheetWorkTime_NoZp.OperDate IS NULL THEN 0
               ELSE 1
          END ::TFloat AS Holiday_NoZp

    FROM tmpListDate

        -- ��� ������� - �� ������   � ������ ����
         LEFT JOIN (SELECT MI_SheetWorkTime.OperDate, MI_SheetWorkTime.MemberId 
                    FROM MI_SheetWorkTime 
                    WHERE MI_SheetWorkTime.OperDate BETWEEN (SELECT tmpList.DateIn_Calc_year FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                      AND MI_SheetWorkTime.isHolidayNoZp = False
                    ) AS MI_SheetWorkTime ON MI_SheetWorkTime.OperDate = tmpListDate.OperDate
                                   --AND MI_SheetWorkTime.MemberId = tmpVacation.MemberId
         -- ��� ������� - �� ���
         LEFT JOIN (SELECT MI_SheetWorkTime.OperDate, MI_SheetWorkTime.MemberId FROM MI_SheetWorkTime WHERE MI_SheetWorkTime.isHolidayNoZp = False 
                   ) AS MI_SheetWorkTime_year ON MI_SheetWorkTime_year.OperDate = tmpListDate.OperDate
                                   --AND MI_SheetWorkTime_year.MemberId = tmpVacation.MemberId

         -- ��� ������� ��� ����.��- �� ������ � ������ ����
         LEFT JOIN (SELECT MI_SheetWorkTime.OperDate, MI_SheetWorkTime.MemberId 
                    FROM MI_SheetWorkTime 
                    WHERE MI_SheetWorkTime.OperDate BETWEEN (SELECT tmpList.DateIn_Calc_year FROM tmpList) AND (SELECT tmpList.DateOut_Calc FROM tmpList)
                      AND MI_SheetWorkTime.isHolidayNoZp = True
                   -- GROUP BY MI_SheetWorkTime.MemberId
                   ) AS MI_SheetWorkTime_NoZp ON MI_SheetWorkTime_NoZp.OperDate = tmpListDate.OperDate
                                   --AND MI_SheetWorkTime_NoZp.MemberId = tmpVacation.MemberId
         --����������� ������
         LEFT JOIN gpSelect_Object_Calendar (vbStartDate_year, vbEndDate, inSession) AS tmpCalendar ON tmpCalendar.Value = tmpListDate.OperDate
    WHERE inMemberId <> 0
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.23         *
*/
-- ����
--     SELECT * FROM gpSelect_HolidayCompensation_day(inStartDate := ('01.01.2023')::TDateTime , inUnitId := 8384 , inMemberId :=  8918847  , inPersonalServiceListId:=0,  inSession := '5');
