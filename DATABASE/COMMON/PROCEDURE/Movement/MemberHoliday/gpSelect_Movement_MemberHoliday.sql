-- Function: gpSelect_Movement_MemberHoliday()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_MemberHoliday (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_MemberHoliday (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MemberHoliday(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , BeginDateStart TDateTime, BeginDateEnd TDateTime
             , MemberId Integer, MemberName TVarChar
             , MemberMainId Integer, MemberMainName TVarChar
             , PositionId Integer, PositionName TVarChar
             , UnitId Integer, UnitName TVarChar
             , WorkTimeKindId Integer, WorkTimeKindName TVarChar
             , InsertName TVarChar
             , UpdateName TVarChar
             , InsertDate TDateTime
             , UpdateDate TDateTime
             , DateIn TDateTime
             , DateOut TDateTime
             , Day_work    TFloat
             , Day_holiday TFloat, Day_holiday1 TFloat, Day_holiday2 TFloat
             , Day_holiday1_calc TFloat, Day_holiday2_calc TFloat

             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , InvNumber_Full1 TVarChar, InvNumber_Full2 TVarChar
             , SummHoliday1 TFloat, SummHoliday2 TFloat, TotalSummHoliday TFloat
             , SummHoliday1_calc TFloat, SummHoliday2_calc TFloat, TotalSummHoliday_calc TFloat
             , Summ_diff TFloat
             , Amount TFloat
             , isLoad Boolean
             , Color_SummHoliday Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_MemberHoliday Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_MemberHoliday());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- �������� ����
     vbIsAccessKey_MemberHoliday:= EXISTS (SELECT *        FROM Object_RoleAccessKey_View WHERE AccessKeyId = zc_Enum_Process_AccessKey_MemberHoliday() AND UserId = vbUserId)
                                OR EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
                                  ;

     -- ���������
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT Object_RoleAccessKeyDocument_View.AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY Object_RoleAccessKeyDocument_View.AccessKeyId
                         -- UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )

        , tmpMember AS (SELECT lfSelect.MemberId
                             , lfSelect.PersonalId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                             , lfSelect.BranchId
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                        WHERE lfSelect.Ord = 1
                        )

        , tmpMovement_1 AS (SELECT Movement.Id
                                 , Movement.StatusId
                                 , Movement.InvNumber
                                 , Movement.OperDate
                                   --
                                 , MovementFloat_MovementId.ValueData    ::Integer  AS MovementId_1
                                 , MovementFloat_MovementItemId.ValueData::Integer  AS MovementId_2
                                   --
                                 , MovementLinkObject_Member.ObjectId               AS MemberId
                                 , MovementLinkObject_WorkTimeKind.ObjectId         AS WorkTimeKindId
                                 , MovementDate_BeginDateStart.ValueData            AS BeginDateStart
                                 , MovementDate_BeginDateEnd.ValueData              AS BeginDateEnd

                                   -- ������ - ������, ����
                                 , (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1) :: TFloat AS Day_holiday

                                   -- ������ - ������������ ��� ������� ��� �������-1 AND <> "zc_Enum_WorkTimeKind_HolidayNoZp"
                                 , CASE WHEN MovementLinkObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_HolidayNoZp()
                                        THEN CASE WHEN DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) = DATE_TRUNC ('Month', MovementDate_BeginDateStart.ValueData)
                                                      THEN (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1)
                                                  ELSE (DATE_PART ('DAY', (DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData)-Interval '1 day') :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1)
                                             END
                                        ELSE 0
                                   END :: TFloat AS Day_holiday1_calc

                                   -- ������ - ������������ ��� ������� ��� �������-2 AND <> "zc_Enum_WorkTimeKind_HolidayNoZp"
                                 , CASE WHEN MovementLinkObject_WorkTimeKind.ObjectId <> zc_Enum_WorkTimeKind_HolidayNoZp()
                                        THEN CASE WHEN DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) = DATE_TRUNC ('Month', MovementDate_BeginDateStart.ValueData)
                                                      THEN 0
                                                  ELSE (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) :: TIMESTAMP) + 1)
                                             END
                                        ELSE 0
                                   END :: TFloat AS Day_holiday2_calc

                                 , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) AS isLoad

                                   -- ��.�� �� ����
                                 , CASE WHEN vbIsAccessKey_MemberHoliday = TRUE THEN MovementFloat_Amount.ValueData  ELSE 0 END ::TFloat AS Amount_day

                          FROM tmpStatus
                               JOIN Movement ON Movement.DescId = zc_Movement_MemberHoliday()
                                            AND Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', inStartDate - INTERVAL '1 MONTH') AND (DATE_TRUNC ('MONTH', inEndDate + INTERVAL '2 MONTH') - INTERVAL '1 DAY')
                                            AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

                               -- ��.�� �� ����
                               LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                       ON MovementFloat_Amount.MovementId = Movement.Id
                                                      AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()

                               LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                                         ON MovementBoolean_isLoad.MovementId = Movement.Id
                                                        AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

                               LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                                       ON MovementFloat_MovementId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()

                               LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()

                               LEFT JOIN MovementDate AS MovementDate_BeginDateStart
                                                      ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                     AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()

                               LEFT JOIN MovementDate AS MovementDate_BeginDateEnd
                                                      ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                     AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                                            ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_WorkTimeKind.DescId = zc_MovementLinkObject_WorkTimeKind()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                            ON MovementLinkObject_Member.MovementId = Movement.Id
                                                           AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                               LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId
                          )
      -- ��������� �����
    , tmpMovement_add AS (SELECT tmpMovement.Id
                                 -- �� ����������� ������� � ������� - ������
                               , SUM (tmpMovement.Summ_holiday1_add) AS Summ_holiday1_add
                                 -- �� �������� ������� � ������� - ������
                               , SUM (tmpMovement.Summ_holiday2_add) AS Summ_holiday2_add

                          FROM (-- �� ����������� ������� � ������� - ������
                                SELECT tmpMovement.Id
                                     , SUM (COALESCE (tmpMovement_old.Amount_day * tmpMovement_old.Day_holiday2_calc, 0)) AS Summ_holiday1_add
                                     , 0 AS Summ_holiday2_add
                                FROM tmpMovement_1 AS tmpMovement
                                     LEFT JOIN tmpMovement_1 AS tmpMovement_old ON tmpMovement_old.MovementId_2 = tmpMovement.MovementId_1
                                                                               AND tmpMovement_old.MemberId     = tmpMovement.MemberId
                                --WHERE vbUserId = 5 AND 1=1
                                GROUP BY tmpMovement.Id

                               UNION ALL
                                -- �� �������� ������� � ������� - ������
                                SELECT tmpMovement.Id
                                     , 0  AS Summ_holiday1_add
                                     , SUM (COALESCE (tmpMovement_next.Amount_day * tmpMovement_next.Day_holiday1_calc, 0)) AS Summ_holiday2_add
--                                     , SUM (COALESCE (tmpMovement_next.Day_holiday1_calc, 0)) AS Summ_holiday2_add
  --                                   -- , max (COALESCE (tmpMovement_next.Day_holiday1_calc, 0)) AS Summ_holiday2_add
                                FROM tmpMovement_1 AS tmpMovement
                                     LEFT JOIN tmpMovement_1 AS tmpMovement_next ON tmpMovement_next.MovementId_1 = tmpMovement.MovementId_2
                                                                                AND tmpMovement_next.MemberId     = tmpMovement.MemberId
                                --WHERE vbUserId = 5 AND 1=1
                                GROUP BY tmpMovement.Id
                               ) AS tmpMovement
                          GROUP BY tmpMovement.Id
                         )

          -- ������ ���� ������� � ������ � ������ ��������
        , tmpMovement AS (SELECT tmpMovement.Id
                               , tmpMovement.StatusId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                                 --
                               , tmpMovement.MovementId_1
                               , tmpMovement.MovementId_2
                                 --
                               , tmpMovement.MemberId
                               , tmpMovement.WorkTimeKindId

                                 -- ���. ���� �������
                               , tmpMovement.BeginDateStart
                                 -- ������. ���� �������
                               , tmpMovement.BeginDateEnd

                               , tmpMovement.isLoad

                                 -- ������ - ������, ����
                               , tmpMovement.Day_holiday

                                 -- ��.�� �� ����
                               , tmpMovement.Amount_day

                               , tmpMovement.Day_holiday1_calc
                               , tmpMovement.Day_holiday2_calc

                               , CASE WHEN tmpMovement.isLoad = TRUE THEN tmpMovement.Day_holiday1_calc ELSE 0 END AS Day_holiday1
                               , CASE WHEN tmpMovement.isLoad = TRUE THEN tmpMovement.Day_holiday2_calc ELSE 0 END AS Day_holiday2

                               , CASE WHEN tmpMovement.isLoad = TRUE THEN tmpMovement.Day_holiday1_calc * tmpMovement.Amount_day ELSE 0 END AS Summ_holiday1
                               , CASE WHEN tmpMovement.isLoad = TRUE THEN tmpMovement.Day_holiday2_calc * tmpMovement.Amount_day ELSE 0 END AS Summ_holiday2

                                 -- ����� ������ ����� 1-��� �������
                               , SUM (CASE WHEN tmpMovement.isLoad = TRUE THEN tmpMovement.Day_holiday1_calc * tmpMovement.Amount_day + COALESCE (tmpMovement_add.Summ_holiday1_add, 0) ELSE 0 END) OVER (PARTITION BY tmpMovement.MovementId_1, tmpMovement.MemberId) AS TotalSumm_holiday1
                                 -- ����� ������ ����� 2-��� �������
                               , SUM (CASE WHEN tmpMovement.isLoad = TRUE THEN tmpMovement.Day_holiday2_calc * tmpMovement.Amount_day + COALESCE (tmpMovement_add.Summ_holiday2_add, 0) ELSE 0 END) OVER (PARTITION BY tmpMovement.MovementId_2, tmpMovement.MemberId) AS TotalSumm_holiday2

                          FROM tmpMovement_1 AS tmpMovement
                               LEFT JOIN tmpMovement_add ON tmpMovement_add.Id = tmpMovement.Id
                          WHERE tmpMovement.OperDate BETWEEN inStartDate AND inEndDate
                         )

          -- ����� �� ��� ���������� - ����
        , tmpSummHoliday AS (SELECT MovementItem.MovementId                           AS MovementId
                                  , ObjectLink_Personal_Member.ChildObjectId          AS MemberId
                                  , SUM (COALESCE (MIFloat_SummHoliday.ValueData,0) ) AS SummHoliday
                             FROM (SELECT DISTINCT tmpMovement.MovementId_1 AS MovementId FROM tmpMovement
                                  UNION
                                   SELECT DISTINCT tmpMovement.MovementId_2 AS MovementId FROM tmpMovement
                                   ) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                                ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                               AND MIFloat_SummHoliday.DescId         = zc_MIFloat_SummHoliday()
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                        ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                             GROUP BY MovementItem.MovementId
                                    , ObjectLink_Personal_Member.ChildObjectId
                            )
       -- ���������
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.Id                      AS StatusId
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName

             -- ���. ���� �������� �������
           , MovementDate_OperDateStart.ValueData  AS OperDateStart
             -- ������. ���� �������� �������
           , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
             -- ���. ���� �������
           , Movement.BeginDateStart AS BeginDateStart
             -- ������. ���� �������
           , Movement.BeginDateEnd   AS BeginDateEnd

           , Object_Member.Id                      AS MemberId
           , Object_Member.ValueData               AS MemberName
           , Object_MemberMain.Id                  AS MemberMainId
           , Object_MemberMain.ValueData           AS MemberMainName

           , Object_Position.Id                    AS PositionId
           , Object_Position.ValueData             AS PositionName
           , Object_Unit.Id                        AS UnitId
           , Object_Unit.ValueData                 AS UnitName

           , Object_WorkTimeKind.Id                AS WorkTimeKindId
           , Object_WorkTimeKind.ValueData         AS WorkTimeKindName

           , Object_Insert.ValueData               AS InsertName
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

           , ObjectDate_DateIn.ValueData           AS DateIn
           , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut

             -- ���-�� ���� (������� ������)
           , (DATE_PART ('DAY', MovementDate_OperDateEnd.ValueData  :: TIMESTAMP - MovementDate_OperDateStart.ValueData  :: TIMESTAMP) + 1) :: TFloat AS Day_work

             -- ������, ����
           , Movement.Day_holiday ::TFloat

             -- ������ - ���� ���������� ��� ������� ��� ������� - 1 � 2 AND <> "zc_Enum_WorkTimeKind_HolidayNoZp" AND isLoad = TRUE
           , Movement.Day_holiday1 :: TFloat AS Day_holiday1
           , Movement.Day_holiday2 :: TFloat AS Day_holiday2

             -- ������ - ������������ ��� ������� ��� ������� - 1 � 2 AND <> "zc_Enum_WorkTimeKind_HolidayNoZp"
           , Movement.Day_holiday1_calc :: TFloat AS Day_holiday1_calc
           , Movement.Day_holiday2_calc :: TFloat AS Day_holiday2_calc

           , Object_PersonalServiceList.Id            AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData     AS PersonalServiceListName

             -- � ��� ���������� �������� (������ ������)
           , zfCalc_InvNumber_isErased (MovementDesc1.ItemName, Movement_PersonalService1.InvNumber, Movement_PersonalService1.OperDate, Movement_PersonalService1.StatusId) ::TVarChar AS InvNumber_Full1
             -- � ��� ���������� �������� (������ ������)
           , zfCalc_InvNumber_isErased (MovementDesc2.ItemName, Movement_PersonalService2.InvNumber, Movement_PersonalService2.OperDate, Movement_PersonalService2.StatusId) ::TVarChar AS InvNumber_Full2

             -- ��������� (1 - ������) - �� ��������������� ����� � �����������
           , CASE /*WHEN vbIsAccessKey_MemberHoliday = TRUE AND vbUserId <> 5 AND 1=1
                  THEN Movement.Summ_holiday1*/

                  /*WHEN vbUserId = 5 
                  THEN Movement.TotalSumm_holiday1*/

                  WHEN vbIsAccessKey_MemberHoliday = TRUE
                  THEN
                      CASE WHEN Movement.TotalSumm_holiday1 <> 0 THEN tmpSummHoliday1.SummHoliday * Movement.Summ_holiday1 / Movement.TotalSumm_holiday1 ELSE 0 END
                  ELSE 0
             END ::TFloat AS SummHoliday1

             -- ��������� (2 - ������) - �� ��������������� ����� � �����������
           , CASE /*WHEN vbIsAccessKey_MemberHoliday = TRUE AND vbUserId <> 5 AND 1=1
                  THEN Movement.Summ_holiday2*/

                  /*WHEN vbUserId = 5 
                  THEN Movement.TotalSumm_holiday2*/

                  WHEN vbIsAccessKey_MemberHoliday = TRUE
                  THEN --tmpSummHoliday2.SummHoliday
                      CASE WHEN Movement.TotalSumm_holiday2 <> 0 THEN tmpSummHoliday2.SummHoliday * Movement.Summ_holiday2 / Movement.TotalSumm_holiday2 ELSE 0 END
                  ELSE 0
             END ::TFloat AS SummHoliday2

             -- ��������� ����� - �� ��������������� ����� � �����������
           , CASE /*WHEN vbIsAccessKey_MemberHoliday = TRUE AND vbUserId <> 5 AND 1=1
                  THEN Movement.Summ_holiday1 + Movement.Summ_holiday2*/

                  WHEN vbIsAccessKey_MemberHoliday = TRUE
                  THEN
                      (CASE WHEN Movement.TotalSumm_holiday1 <> 0 THEN tmpSummHoliday1.SummHoliday * Movement.Summ_holiday1 / Movement.TotalSumm_holiday1 ELSE 0 END)
                    + (CASE WHEN Movement.TotalSumm_holiday2 <> 0 THEN tmpSummHoliday2.SummHoliday * Movement.Summ_holiday2 / Movement.TotalSumm_holiday2 ELSE 0 END)
                  ELSE 0
             END ::TFloat AS TotalSummHoliday

             -- ��������� (������ ������) - ������
           , CASE WHEN vbIsAccessKey_MemberHoliday = TRUE
                  THEN Movement.Summ_holiday1
                  ELSE 0
             END ::TFloat AS SummHoliday1_calc
             -- ��������� (������ ������)- ������
           , CASE WHEN vbIsAccessKey_MemberHoliday = TRUE
                  THEN Movement.Summ_holiday2
                  ELSE 0
             END ::TFloat AS SummHoliday2_calc
             -- ��������� ����� - ������
           , CASE WHEN vbIsAccessKey_MemberHoliday = TRUE AND Object_WorkTimeKind.Id <> zc_Enum_WorkTimeKind_HolidayNoZp()
                  THEN Movement.Amount_day * (DATE_PART ('DAY', Movement.BeginDateEnd   :: TIMESTAMP
                                                              - Movement.BeginDateStart :: TIMESTAMP)
                                            + 1)
                  ELSE 0
             END ::TFloat AS SummHoliday_calc

             -- �������
           , CASE /*WHEN vbIsAccessKey_MemberHoliday = TRUE AND vbUserId <> 5 AND 1=1
                  THEN 0*/

                  WHEN vbIsAccessKey_MemberHoliday = TRUE AND Object_WorkTimeKind.Id <> zc_Enum_WorkTimeKind_HolidayNoZp()
                  THEN (CASE WHEN Movement.TotalSumm_holiday1 <> 0 THEN tmpSummHoliday1.SummHoliday * Movement.Summ_holiday1 / Movement.TotalSumm_holiday1 ELSE 0 END)
                     + (CASE WHEN Movement.TotalSumm_holiday2 <> 0 THEN tmpSummHoliday2.SummHoliday * Movement.Summ_holiday2 / Movement.TotalSumm_holiday2 ELSE 0 END)
                     - (Movement.Amount_day * (DATE_PART ('DAY', Movement.BeginDateEnd   :: TIMESTAMP
                                                               - Movement.BeginDateStart :: TIMESTAMP)
                                             + 1)) :: TFloat
                  ELSE 0
             END :: TFloat AS Summ_diff

             -- ��.�� �� ����
           , CASE WHEN vbIsAccessKey_MemberHoliday = TRUE THEN Movement.Amount_day  ELSE 0 END ::TFloat AS Amount
             --
           , CASE WHEN (Movement_PersonalService1.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                     OR Movement_PersonalService2.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                       )
                   AND Movement.isLoad = TRUE
                       THEN Movement.isLoad
                  ELSE FALSE
             END :: Boolean AS isLoad

             -- ���
           , CASE /*WHEN vbUserId <> 5 AND 1=1
                  THEN zc_Color_White()*/

                  WHEN Object_WorkTimeKind.Id <> zc_Enum_WorkTimeKind_HolidayNoZp()
                   AND (Movement.Amount_day * (DATE_PART ('DAY', Movement.BeginDateEnd :: TIMESTAMP
                                                               - Movement.BeginDateStart :: TIMESTAMP)
                                             + 1)) :: TFloat
                    <> (CASE WHEN Movement.TotalSumm_holiday1 <> 0 THEN tmpSummHoliday1.SummHoliday * Movement.Summ_holiday1 / Movement.TotalSumm_holiday1 ELSE 0 END)
                     + (CASE WHEN Movement.TotalSumm_holiday2 <> 0 THEN tmpSummHoliday2.SummHoliday * Movement.Summ_holiday2 / Movement.TotalSumm_holiday2 ELSE 0 END)

                  THEN zc_Color_Pink()
                  ELSE zc_Color_White()

             END ::Integer AS Color_SummHoliday

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

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

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN Movement AS Movement_PersonalService1 ON Movement_PersonalService1.Id = Movement.MovementId_1  --MovementFloat_MovementId.ValueData::Integer
            LEFT JOIN MovementDesc AS MovementDesc1 ON MovementDesc1.Id = Movement_PersonalService1.DescId

            LEFT JOIN Movement AS Movement_PersonalService2 ON Movement_PersonalService2.Id = Movement.MovementId_2  --MovementFloat_MovementItemId.ValueData::Integer
            LEFT JOIN MovementDesc AS MovementDesc2 ON MovementDesc2.Id = Movement_PersonalService2.DescId


            LEFT JOIN Object AS Object_Member ON Object_Member.Id = Movement.MemberId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberMain
                                         ON MovementLinkObject_MemberMain.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberMain.DescId = zc_MovementLinkObject_MemberMain()
            LEFT JOIN Object AS Object_MemberMain ON Object_MemberMain.Id = MovementLinkObject_MemberMain.ObjectId

            LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = Movement.WorkTimeKindId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            --
            LEFT JOIN tmpMember ON tmpMember.MemberId = Object_Member.Id
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMember.PositionId
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpMember.UnitId


            LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                 ON ObjectDate_DateIn.ObjectId = tmpMember.PersonalId
                                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
            LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                 ON ObjectDate_DateOut.ObjectId = tmpMember.PersonalId
                                AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                 ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpMember.PersonalId
                                AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

            --
            LEFt JOIN tmpSummHoliday AS tmpSummHoliday1
                                     ON tmpSummHoliday1.MovementId = Movement_PersonalService1.Id
                                    AND tmpSummHoliday1.MemberId   = Object_Member.Id
            LEFt JOIN tmpSummHoliday AS tmpSummHoliday2
                                     ON tmpSummHoliday2.MovementId = Movement_PersonalService2.Id
                                    AND tmpSummHoliday2.MemberId   = Object_Member.Id

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.21         *
 27.12.18         *
 20.12.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_MemberHoliday (inStartDate:= '01.08.2023', inEndDate:= '01.08.2023', inIsErased:=true, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
