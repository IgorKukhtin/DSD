-- Function: gpSelect_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalService (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalService(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , MemberId_Personal Integer
             , INN TVarChar, Code1C TVarChar, Card TVarChar, CardSecond TVarChar
             , CardIBAN TVarChar, CardIBANSecond TVarChar
             , isMain Boolean, isOfficial Boolean, DateOut TDateTime, DateIn TDateTime
             , PersonalCode_to Integer, PersonalName_to TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberId Integer, MemberName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , FineSubjectId Integer, FineSubjectName TVarChar
             , UnitFineSubjectId Integer, UnitFineSubjectName TVarChar
             , StaffListSummKindName TVarChar
             
             , Amount TFloat, AmountToPay TFloat, AmountCash TFloat,AmountCash_rem TFloat, AmountCash_pay TFloat
             , SummService TFloat
             , SummCard TFloat, SummCardRecalc TFloat, SummCardSecond TFloat, SummCardSecondRecalc TFloat, SummCardSecondDiff TFloat, SummCardSecondCash TFloat
             , SummCardSecond_Avance TFloat
             , SummAvCardSecond TFloat, SummAvCardSecondRecalc TFloat
             , SummNalog TFloat, SummNalogRecalc TFloat
             , SummNalogRet TFloat, SummNalogRetRecalc TFloat
             , SummMinus TFloat, SummFine TFloat, SummFineOth TFloat, SummFineOthRecalc TFloat
             , SummAdd TFloat, SummAuditAdd TFloat
             , SummHoliday TFloat, SummHosp TFloat, SummHospOth TFloat, SummHospOthRecalc TFloat
             , SummSocialIn TFloat, SummSocialAdd TFloat
             , SummChild TFloat, SummChildRecalc TFloat, SummMinusExt TFloat, SummMinusExtRecalc TFloat
             , SummTransport TFloat, SummTransportAdd TFloat, SummTransportAddLong TFloat, SummTransportTaxi TFloat, SummPhone TFloat
             , Amount_avance TFloat, Amount_avance_ps TFloat
             , SummAvance TFloat, SummAvanceRecalc TFloat
             , TotalSummChild TFloat, SummDiff TFloat

             , DayCount_child TFloat
             , WorkTimeHoursOne_child TFloat
             , Price_child TFloat

             , SummAddOth TFloat, SummAddOthRecalc TFloat
             , SummHouseAdd TFloat
             , SummCompensation TFloat, SummCompensationRecalc TFloat
             , DayCompensation TFloat, PriceCompensation TFloat
             , DayVacation TFloat, DayHoliday TFloat, DayWork TFloat
             , DayAudit TFloat 
             , SummMedicdayAdd TFloat, DayMedicday TFloat
             , SummSkip TFloat, DaySkip TFloat
             , DayPriceNalog TFloat
             , isPriceNalog Boolean             
             , Number TVarChar
             , Comment TVarChar
             , isErased Boolean
             , isAuto Boolean
             , isBankOut Boolean
             , BankOutDate TDateTime, BankOutDate_export TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbInfoMoneyId_def Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
   DECLARE vbIsSummCardRecalc Boolean;
   DECLARE vbServiceDate TDateTime;
   DECLARE vbServiceDateId         Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!�������� ���� ���� - ����������� ��������� ������ ��!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);


     -- ������������
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- ������������ ������
     vbInfoMoneyId_def:= (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_60101()); -- 60101 ���������� ����� + ���������� �����
     -- ������������
     vbIsSummCardRecalc:= COALESCE (inMovementId, 0) = 0
                       -- OR 1=1
                       OR EXISTS (SELECT ObjectLink_PersonalServiceList_PaidKind.ChildObjectId
                                  FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                       INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                             ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                                            AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                            AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                                  WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                                    AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                 );

     -- �� ����� ���.
     vbServiceDate  := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MIDate_ServiceDate());
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate);
     vbPersonalServiceListId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList());

     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('tmpPersonalServiceList_check'))
     THEN
          -- �����������
          CREATE TEMP TABLE tmpPersonalServiceList_check ON COMMIT DROP AS
            WITH tmpUserAll_check AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- ���������-���� (����������) AND <> ����� �.�. + �� �������� ���
            SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
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
              AND (EXISTS (SELECT 1 FROM tmpUserAll_check)
               OR vbUserId = 80373 -- ��������� �.�.
                  )
           UNION
            -- ����� � ������ ����� ����
            SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
            FROM Object AS Object_PersonalServiceList
            WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
              AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
           ;
     END IF;

     -- ���������
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
          , tmpMIContainer_all AS (SELECT MIContainer.MovementItemId
                                        , CLO_Unit.ObjectId     AS UnitId
                                        , CLO_Position.ObjectId AS PositionId
                                        , CLO_Personal.ObjectId AS PersonalId
                                        , (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_Nalog() THEN MIContainer.Amount ELSE 0 END) AS SummNalog
                                        , ROW_NUMBER() OVER (PARTITION BY MIContainer.MovementItemId ORDER BY ABS (MIContainer.Amount) DESC) AS Ord
                                   FROM MovementItemContainer AS MIContainer
                                        LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                      ON CLO_Unit.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                        LEFT JOIN ContainerLinkObject AS CLO_Position
                                                                      ON CLO_Position.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                        LEFT JOIN ContainerLinkObject AS CLO_Personal
                                                                      ON CLO_Personal.ContainerId = MIContainer.ContainerId
                                                                     AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                   WHERE MIContainer.MovementId = inMovementId
                                     AND MIContainer.DescId     = zc_MIContainer_Summ()
                                     AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_PersonalService_Nalog())
                                  )
          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.Amount
                           , MovementItem.ObjectId                    AS PersonalId
                           , MILinkObject_Unit.ObjectId               AS UnitId
                           , MILinkObject_Position.ObjectId           AS PositionId
                           , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                           , MILinkObject_Member.ObjectId             AS MemberId
                           , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                           , MILinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                            ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                            ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                     )
      , tmpMIChild_all AS (SELECT
                                  MovementItem.ParentId                    AS ParentId
                                , MovementItem.Id                          AS MovementItemId
                                , MovementItem.Amount                      AS Amount
                                , COALESCE (MIFloat_DayCount.ValueData, 0) AS DayCount
                                , COALESCE (MIFloat_WorkTimeHoursOne.ValueData, 0) AS WorkTimeHoursOne
                                , MIFloat_Price.ValueData                  AS Price
                                , Object_StaffListSummKind.ValueData       AS StaffListSummKindName
                              /*, COALESCE (MILinkObject_StaffList.ObjectId, 0)      AS StaffListId
                                , COALESCE (MILinkObject_ModelService.ObjectId, 0)   AS ModelServiceId
                                , COALESCE (MILinkObject_StorageLine.ObjectId, 0)    AS StorageLineId
                                , COALESCE (MILinkObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                , COALESCE (MIFloat_GrossOne.ValueData, 0)           AS GrossOne
                                , COALESCE (MIFloat_HoursPlan.ValueData, 0)          AS HoursPlan
                                , COALESCE (MIFloat_HoursDay.ValueData, 0)           AS HoursDay*/

                           FROM MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffListSummKind
                                                               ON MILinkObject_StaffListSummKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_StaffListSummKind.DescId = zc_MILinkObject_StaffListSummKind()
                              LEFT JOIN Object AS Object_StaffListSummKind ON Object_StaffListSummKind.Id = MILinkObject_StaffListSummKind.ObjectId
                              --
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_StaffList
                                                               ON MILinkObject_StaffList.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_StaffList.DescId = zc_MILinkObject_StaffList()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_ModelService
                                                               ON MILinkObject_ModelService.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_ModelService.DescId = zc_MILinkObject_ModelService()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                               ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                               ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()

                              --
                              LEFT JOIN MovementItemFloat AS MIFloat_DayCount
                                                          ON MIFloat_DayCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_DayCount.DescId = zc_MIFloat_DayCount()
                              LEFT JOIN MovementItemFloat AS MIFloat_WorkTimeHoursOne
                                                          ON MIFloat_WorkTimeHoursOne.MovementItemId = MovementItem.Id
                                                         AND MIFloat_WorkTimeHoursOne.DescId = zc_MIFloat_WorkTimeHoursOne()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemFloat AS MIFloat_GrossOne
                                                          ON MIFloat_GrossOne.MovementItemId = MovementItem.Id
                                                         AND MIFloat_GrossOne.DescId = zc_MIFloat_GrossOne()
                              LEFT JOIN MovementItemFloat AS MIFloat_HoursPlan
                                                          ON MIFloat_HoursPlan.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HoursPlan.DescId = zc_MIFloat_HoursPlan()
                              LEFT JOIN MovementItemFloat AS MIFloat_HoursDay
                                                          ON MIFloat_HoursDay.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HoursDay.DescId = zc_MIFloat_HoursDay()



                           WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Child()
                              AND MovementItem.isErased = FALSE
                          )
          , tmpMIChild AS (SELECT tmpMIChild_all.ParentId
                                , SUM (tmpMIChild_all.Amount)           AS Amount
                                , MAX (tmpMIChild_all.DayCount)         AS DayCount
                              --, SUM (tmpMIChild_all.WorkTimeHoursOne) AS WorkTimeHoursOne
                                , SUM (tmpMIChild_all.Price)            AS Price
                                , STRING_AGG (DISTINCT tmpMIChild_all.StaffListSummKindName, ';') AS StaffListSummKindName
                           FROM tmpMIChild_all
                           GROUP BY tmpMIChild_all.ParentId
                          )
    , tmpMIChild_Hours AS (SELECT tmpMIChild_all.ParentId
                                , SUM (tmpMIChild_all.WorkTimeHoursOne) AS WorkTimeHoursOne
                           FROM (SELECT DISTINCT
                                        tmpMIChild_all.ParentId, tmpMIChild_all.WorkTimeHoursOne
                                      /*, tmpMIChild_all.StaffListId
                                      , tmpMIChild_all.ModelServiceId
                                      , tmpMIChild_all.StorageLineId
                                      , tmpMIChild_all.PositionLevelId
                                      , tmpMIChild_all.GrossOne
                                      , tmpMIChild_all.HoursPlan
                                      , tmpMIChild_all.HoursDay*/
                                      , CASE WHEN vbPersonalServiceListId = 8265914 -- ��������� ��� ��������
                                                  THEN tmpMIChild_all.MovementItemId
                                             ELSE 0
                                        END AS MovementItemId
                                 FROM tmpMIChild_all
                                ) AS tmpMIChild_all
                           GROUP BY tmpMIChild_all.ParentId
                          )

          , tmpUserAll AS (-- ����� ����� ����
                           SELECT DISTINCT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()/*, 293449*/) AND UserId = vbUserId/* AND UserId <> 9464*/ -- ���������-���� (����������) AND <> ����� �.�.
                          UNION
                           -- ��������� �.�. ����� ����
                           SELECT vbUserId WHERE vbUserId = 80830
                          UNION
                           -- ��������� �.�. ����� ����
                           SELECT vbUserId WHERE vbUserId = 2573318
                          )

            , tmpPersonal_all AS (SELECT View_Personal.*
                                  FROM (SELECT UnitId_PersonalService FROM Object_RoleAccessKeyGuide_View WHERE UnitId_PersonalService <> 0 AND UserId = vbUserId AND inShowAll = TRUE
                                        UNION
                                         -- ����� ����� ����
                                         SELECT Object.Id AS UnitId_PersonalService FROM Object WHERE Object.DescId = zc_Object_Unit() AND inShowAll = TRUE
                                                                                                  AND EXISTS (SELECT 1 FROM tmpUserAll)
                                        ) AS View_RoleAccessKeyGuide
                                        INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = View_RoleAccessKeyGuide.UnitId_PersonalService

                                 UNION
                                  SELECT View_Personal.*
                                  FROM tmpPersonalServiceList_check
                                       INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList_all
                                                             ON ObjectLink_Personal_PersonalServiceList_all.ChildObjectId = tmpPersonalServiceList_check.PersonalServiceListId
                                                            AND ObjectLink_Personal_PersonalServiceList_all.DescId        = zc_ObjectLink_Personal_PersonalServiceList()
                                       INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = ObjectLink_Personal_PersonalServiceList_all.ObjectId
                                 )
          , tmpPersonal AS (SELECT 0 AS MovementItemId
                                 , 0 AS Amount
                                 , View_Personal.PersonalId
                                 , View_Personal.UnitId
                                 , View_Personal.PositionId
                                 , vbInfoMoneyId_def         AS InfoMoneyId
                                 , View_Personal.MemberId    AS MemberId_Personal
                                 , 0     AS MemberId
                                 , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId -- !!!����� ��� ���� �.�. ���� ����������� �� ��!!!
                                 , FALSE AS isErased
                            FROM tmpPersonal_all AS View_Personal
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                      ON ObjectLink_Personal_PersonalServiceList.ObjectId = View_Personal.PersonalId
                                                     AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
                                                     AND vbIsSummCardRecalc = TRUE -- !!!�.�. ���� ��� ��!!!

                                 LEFT JOIN tmpMI ON tmpMI.PersonalId = View_Personal.PersonalId
                                                AND tmpMI.UnitId     = View_Personal.UnitId
                                                AND tmpMI.PositionId = View_Personal.PositionId

                            WHERE tmpMI.PersonalId IS NULL
                              AND inShowAll = TRUE
                           )
          , tmpAll AS (SELECT tmpMI.MovementItemId, tmpMI.Amount, tmpMI.PersonalId, tmpMI.UnitId, tmpMI.PositionId, tmpMI.InfoMoneyId, tmpMI.MemberId_Personal, tmpMI.MemberId , tmpMI.PersonalServiceListId, tmpMI.isErased FROM tmpMI
                      UNION ALL
                       SELECT tmpPersonal.MovementItemId, tmpPersonal.Amount, tmpPersonal.PersonalId, tmpPersonal.UnitId, tmpPersonal.PositionId, tmpPersonal.InfoMoneyId, tmpPersonal.Memberid_Personal, tmpPersonal.MemberId, tmpPersonal.PersonalServiceListId, tmpPersonal.isErased FROM tmpPersonal
                      )
            -- ������� ������
          , tmpContainer_pay AS (SELECT DISTINCT
                                        CLO_ServiceDate.ContainerId
                                      , CLO_Personal.ObjectId                    AS PersonalId
                                      , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                      , CLO_Position.ObjectId                    AS PositionId
                                      , ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                                      , CLO_Unit.ObjectId                        AS UnitId
                                 FROM ContainerLinkObject AS CLO_PersonalServiceList
                                      INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                                     ON CLO_ServiceDate.ObjectId    = vbServiceDateId
                                                                    AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                                    AND CLO_ServiceDate.ContainerId = CLO_PersonalServiceList.ContainerId

                                      INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                     ON CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                                                    AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                      INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                            ON ObjectLink_Personal_Member.ObjectId = CLO_Personal.ObjectId
                                                           AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                      LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                           ON ObjectLink_Personal_PositionLevel.ObjectId = CLO_Personal.ObjectId
                                                          AND ObjectLink_Personal_PositionLevel.DescId   = zc_ObjectLink_Personal_PositionLevel()
                                      LEFT JOIN ContainerLinkObject AS CLO_Position
                                                                    ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                      LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                 WHERE CLO_PersonalServiceList.ObjectId = vbPersonalServiceListId
                                   AND CLO_PersonalServiceList.DescId   = zc_ContainerLinkObject_PersonalServiceList()
                                )
        , tmpMIContainer_pay AS (SELECT SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()) AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END) AS Amount_avance
                                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance())  THEN MIContainer.Amount ELSE 0 END) AS Amount_avance_all
                                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalService()) THEN MIContainer.Amount ELSE 0 END) AS Amount_service
                                        -- ����� �� ���������
                                      , SUM (CASE WHEN ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                                                   AND MIContainer.MovementDescId = zc_Movement_Cash()
                                                   AND Object.ValueData ILIKE '%�����%'

                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_avance_ps

                                      , tmpContainer_pay.MemberId
                                      , tmpContainer_pay.PositionId
                                      , tmpContainer_pay.PositionLevelId
                                      , tmpContainer_pay.UnitId
                                 FROM tmpContainer_pay
                                      INNER JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId    = tmpContainer_pay.ContainerId
                                                                      AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                      AND MIContainer.MovementDescId = zc_Movement_Cash()
                                      LEFT JOIN MovementItem ON MovementItem.MovementId = MIContainer.MovementId
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                       ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                      LEFT JOIN Object ON Object.Id = MILinkObject_MoneyPlace.ObjectId
                                      LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId   = zc_ObjectLink_PersonalServiceList_PaidKind()
                                 GROUP BY tmpContainer_pay.MemberId
                                        , tmpContainer_pay.PositionId
                                        , tmpContainer_pay.PositionLevelId
                                        , tmpContainer_pay.UnitId
                                )

      --��� ��������� � ������� ��������� - zc_ObjectLink_PersonalServiceList_Avance_F2
     , tmpServiceList_wITH_AvanceF2 AS (SELECT ObjectLink_PersonalServiceList_Avance_F2.ObjectId AS PersonalServiceListId
                                FROM ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                                WHERE ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_PersonalServiceList_Avance_F2()
                               AND coalesce (ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId ,0) <> 0
                               )
 
       -- ��� ���������
     , tmpMovement_Avance AS (SELECT MovementDate_ServiceDate.MovementId AS Id
                              FROM MovementDate AS MovementDate_ServiceDate
                                   JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                AND Movement.DescId = zc_Movement_PersonalService()
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                 ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                                AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                                AND MovementLinkObject_PersonalServiceList.ObjectId IN (SELECT DISTINCT tmpServiceList_wITH_AvanceF2.PersonalServiceListId FROM tmpServiceList_wITH_AvanceF2)
                              WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', vbServiceDate) AND (DATE_TRUNC ('MONTH', vbServiceDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                AND MovementDate_ServiceDate.MovementId  <> inMovementId
                              ) 
     
       -- ��� ��������� � ������� ��������� - zc_ObjectLink_PersonalServiceList_Avance_F2
     , tmpMI_SummCardSecondRecalc AS (SELECT MovementItem.ObjectId                                     AS PersonalId
                                           , MILinkObject_Position.ObjectId                            AS PositionId
                                           , SUM (COALESCE (MIFloat_SummCardSecond.ValueData,0))       AS SummCardSecondRecalc
                                      FROM tmpMovement_Avance AS Movement
                                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                  AND MovementItem.DescId = zc_MI_Master()
                                                                  AND MovementItem.isErased = FALSE
                                           INNER JOIN MovementItemFloat AS MIFloat_SummCardSecond
                                                                        ON MIFloat_SummCardSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_SummCardSecond.DescId         = zc_MIFloat_SummAvCardSecond()
                                                                       AND MIFloat_SummCardSecond.ValueData      <> 0
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                            ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                      GROUP BY MovementItem.ObjectId, MILinkObject_Position.ObjectId                                     
                                     )
       -- ���������
       SELECT tmpAll.MovementItemId                         AS Id
            , Object_Personal.Id                            AS PersonalId
            , Object_Personal.ObjectCode                    AS PersonalCode
            , Object_Personal.ValueData                     AS PersonalName
            , tmpAll.MemberId_Personal
            , ObjectString_Member_INN.ValueData             AS INN
            , ObjectString_Code1C.ValueData                 AS Code1C
            , ObjectString_Member_Card.ValueData            AS Card
            , ObjectString_Member_CardSecond.ValueData      AS CardSecond
            , ObjectString_Member_CardIBAN.ValueData        AS CardIBAN
            , ObjectString_Member_CardIBANSecond.ValueData  AS CardIBANSecond
            , CASE WHEN tmpAll.MovementItemId > 0 AND 1=0 /*vbUserId <> 5*/ THEN COALESCE (MIBoolean_Main.ValueData, FALSE) ELSE COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE) END :: Boolean AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial
              -- ���� ����������
            , CASE WHEN COALESCE (ObjectDate_Personal_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_Personal_DateOut.ValueData END     :: TDateTime AS DateOut
             -- ���� ������ �� ������ - ������ ���� ��� ���������� ����� ������ ������
            , CASE WHEN DATE_TRUNC ('Month', ObjectDate_DateIn.ValueData) = DATE_TRUNC ('Month', vbServiceDate) THEN ObjectDate_DateIn.ValueData ELSE NULL END ::TDateTime AS DateIn
            , Object_PersonalTo.ObjectCode            AS PersonalCode_to
            , Object_PersonalTo.ValueData             AS PersonalName_to

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all

            , COALESCE (Object_Member.Id, 0)          AS MemberId
            , COALESCE (Object_Member.ValueData, ''::TVarChar) AS MemberName

            , COALESCE (Object_PersonalServiceList.Id, 0)                   AS PersonalServiceListId
            , COALESCE (Object_PersonalServiceList.ValueData, ''::TVarChar) AS PersonalServiceListName

            , COALESCE (Object_FineSubject.Id, 0)         :: Integer  AS FineSubjectId
            , COALESCE (Object_FineSubject.ValueData, '') :: TVarChar AS FineSubjectName

            , COALESCE (Object_UnitFineSubject.Id, 0)         :: Integer  AS UnitFineSubjectId
            , COALESCE (Object_UnitFineSubject.ValueData, '') :: TVarChar AS UnitFineSubjectName

            , COALESCE (tmpMIChild.StaffListSummKindName,'') ::TVarChar AS StaffListSummKindName

            , tmpAll.Amount :: TFloat           AS Amount
            , MIFloat_SummToPay.ValueData       AS AmountToPay
              -- � ������� (�� �����)
            , (COALESCE (MIFloat_SummToPay.ValueData, 0)
            + (-1) *  CASE WHEN 1=0 AND vbUserId = 5
                               THEN 0
                          ELSE COALESCE (MIFloat_SummCard.ValueData, 0)
                             + COALESCE (MIFloat_SummCardSecond.ValueData, 0)
                             + COALESCE (MIFloat_SummCardSecondCash.ValueData, 0)
                      END
              ) :: TFloat AS AmountCash
              -- ������� � ������ (�� �����) ���
            , (COALESCE (MIFloat_SummToPay.ValueData, 0)
            + (-1) *  CASE WHEN 1=0 AND vbUserId = 5
                               THEN 0
                          ELSE COALESCE (MIFloat_SummCard.ValueData, 0)
                             + COALESCE (MIFloat_SummCardSecond.ValueData, 0)
                             + COALESCE (MIFloat_SummCardSecondCash.ValueData, 0)
                             + COALESCE (tmpMIContainer_pay.Amount_avance_all, 0)
                             + COALESCE (tmpMIContainer_pay.Amount_service, 0)
                      END
              ) :: TFloat AS AmountCash_rem
              -- ������� � ������ (�� �����) ���
            , (COALESCE (tmpMIContainer_pay.Amount_avance_all, 0) + COALESCE (tmpMIContainer_pay.Amount_service, 0)) :: TFloat AS AmountCash_pay

            , MIFloat_SummService.ValueData           AS SummService
            , MIFloat_SummCard.ValueData              AS SummCard
            , MIFloat_SummCardRecalc.ValueData        AS SummCardRecalc
            , MIFloat_SummCardSecond.ValueData        AS SummCardSecond
            , MIFloat_SummCardSecondRecalc.ValueData  AS SummCardSecondRecalc
            , MIFloat_SummCardSecondDiff.ValueData    AS SummCardSecondDiff
            , MIFloat_SummCardSecondCash.ValueData    AS SummCardSecondCash
            , tmpMI_SummCardSecondRecalc.SummCardSecondRecalc ::TFloat AS SummCardSecond_Avance    
            , MIFloat_SummAvCardSecond.ValueData       AS SummAvCardSecond
            , MIFloat_SummAvCardSecondRecalc.ValueData AS SummAvCardSecondRecalc
            , MIFloat_SummNalog.ValueData             AS SummNalog
            , MIFloat_SummNalogRecalc.ValueData       AS SummNalogRecalc
            , MIFloat_SummNalogRet.ValueData          AS SummNalogRet
            , MIFloat_SummNalogRetRecalc.ValueData    AS SummNalogRetRecalc
            , MIFloat_SummMinus.ValueData             AS SummMinus
            , MIFloat_SummFine.ValueData              AS SummFine
            , MIFloat_SummFineOth.ValueData           AS SummFineOth
            , MIFloat_SummFineOthRecalc.ValueData     AS SummFineOthRecalc
            , MIFloat_SummAdd.ValueData               AS SummAdd
            , MIFloat_SummAuditAdd.ValueData          AS SummAuditAdd
            , MIFloat_SummHoliday.ValueData           AS SummHoliday
            , MIFloat_SummHosp.ValueData              AS SummHosp
            , MIFloat_SummHospOth.ValueData           AS SummHospOth
            , MIFloat_SummHospOthRecalc.ValueData     AS SummHospOthRecalc
            , MIFloat_SummSocialIn.ValueData          AS SummSocialIn
            , MIFloat_SummSocialAdd.ValueData         AS SummSocialAdd
            , MIFloat_SummChild.ValueData             AS SummChild
            , MIFloat_SummChildRecalc.ValueData       AS SummChildRecalc
            , MIFloat_SummMinusExt.ValueData          AS SummMinusExt
            , MIFloat_SummMinusExtRecalc.ValueData    AS SummMinusExtRecalc

            , MIFloat_SummTransport.ValueData         AS SummTransport
            , MIFloat_SummTransportAdd.ValueData      AS SummTransportAdd
            , MIFloat_SummTransportAddLong.ValueData  AS SummTransportAddLong
            , MIFloat_SummTransportTaxi.ValueData     AS SummTransportTaxi
            , MIFloat_SummPhone.ValueData             AS SummPhone
            , ( 1 * tmpMIContainer_pay.Amount_avance)    :: TFloat AS Amount_avance
            , ( 1 * tmpMIContainer_pay.Amount_avance_ps) :: TFloat AS Amount_avance_ps


            , MIFloat_SummAvance.ValueData        ::TFloat AS SummAvance
            , MIFloat_SummAvanceRecalc.ValueData  ::TFloat AS SummAvanceRecalc

            , COALESCE (tmpMIChild.Amount, 0)                                                 :: TFloat AS TotalSummChild
            , (COALESCE (tmpMIChild.Amount, 0) - COALESCE (MIFloat_SummService.ValueData, 0)) :: TFloat AS SummDiff
            , COALESCE (tmpMIChild.DayCount, 0)         ::TFloat AS DayCount_child
            , COALESCE (tmpMIChild_Hours.WorkTimeHoursOne, 0) ::TFloat AS WorkTimeHoursOne_child
            , COALESCE (tmpMIChild.Price, 0)            ::TFloat AS Price_child

            , MIFloat_SummAddOth.ValueData              AS SummAddOth
            , MIFloat_SummAddOthRecalc.ValueData        AS SummAddOthRecalc
            , MIFloat_SummHouseAdd.ValueData  ::TFloat  AS SummHouseAdd


            , CASE WHEN tmpPersonalServiceList_check.PersonalServiceListId > 0 OR tmpAll.PersonalServiceListId IS NULL THEN MIFloat_SummCompensation.ValueData        ELSE 0 END ::TFloat AS SummCompensation
            , CASE WHEN tmpPersonalServiceList_check.PersonalServiceListId > 0 OR tmpAll.PersonalServiceListId IS NULL THEN MIFloat_SummCompensationRecalc.ValueData  ELSE 0 END ::TFloat AS SummCompensationRecalc

            , MIFloat_DayCompensation.ValueData AS DayCompensation
            , CASE WHEN tmpPersonalServiceList_check.PersonalServiceListId > 0 OR tmpAll.PersonalServiceListId IS NULL THEN MIFloat_PriceCompensation.ValueData       ELSE 0 END ::TFloat AS PriceCompensation

            , MIFloat_DayVacation.ValueData             ::TFloat AS DayVacation
            , MIFloat_DayHoliday.ValueData              ::TFloat AS DayHoliday
            , MIFloat_DayWork.ValueData                 ::TFloat AS DayWork
            , MIFloat_DayAudit.ValueData                ::TFloat AS DayAudit

            , MIFloat_SummMedicdayAdd.ValueData         ::TFloat AS SummMedicdayAdd
            , MIFloat_DayMedicday.ValueData             ::TFloat AS DayMedicday
            , MIFloat_SummSkip.ValueData                ::TFloat AS SummSkip
            , MIFloat_DaySkip.ValueData                 ::TFloat AS DaySkip 
            
            , MIFloat_DayPriceNalog.ValueData           ::TFloat AS DayPriceNalog
            , COALESCE (MIBoolean_PriceNalog.ValueData, FALSE)  :: Boolean AS isPriceNalog

            , MIString_Number.ValueData   ::TVarChar AS Number
            , MIString_Comment.ValueData             AS Comment
            , tmpAll.isErased
            , COALESCE (MIBoolean_isAuto.ValueData, FALSE)      :: Boolean   AS isAuto
            , COALESCE (ObjectBoolean_BankOut.ValueData, FALSE) :: Boolean   AS isBankOut
            , MIDate_BankOut.ValueData                          :: TDateTime AS BankOutDate
            , COALESCE (MIDate_BankOut.ValueData, vbOperDate)   :: TDateTime AS BankOutDate_export
       FROM tmpAll
            LEFT JOIN ObjectString AS ObjectString_Code1C
                                   ON ObjectString_Code1C.ObjectId = tmpAll.PersonalId
                                  AND ObjectString_Code1C.DescId    = zc_ObjectString_Personal_Code1C()

            LEFT JOIN tmpPersonalServiceList_check ON tmpPersonalServiceList_check.PersonalServiceListId = tmpAll.PersonalServiceListId

            LEFT JOIN tmpMIContainer_all ON tmpMIContainer_all.MovementItemId = tmpAll.MovementItemId
                                        AND tmpMIContainer_all.Ord            = 1 -- !!!������ 1-��!!!

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemString AS MIString_Number
                                         ON MIString_Number.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Number.DescId = zc_MIString_Number()

            LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                        ON MIFloat_SummToPay.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
            LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                        ON MIFloat_SummService.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummService.DescId = zc_MIFloat_SummService()

            LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                        ON MIFloat_SummCard.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                        ON MIFloat_SummCardRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecond
                                        ON MIFloat_SummCardSecond.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()

            LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                        ON MIFloat_SummCardSecondRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondDiff
                                        ON MIFloat_SummCardSecondDiff.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecondDiff.DescId         = zc_MIFloat_SummCardSecondDiff()

            LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                        ON MIFloat_SummCardSecondCash.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()

            LEFT JOIN MovementItemFloat AS MIFloat_SummNalog
                                        ON MIFloat_SummNalog.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()
            LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                        ON MIFloat_SummNalogRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRet
                                        ON MIFloat_SummNalogRet.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalogRet.DescId = zc_MIFloat_SummNalogRet()
            LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRetRecalc
                                        ON MIFloat_SummNalogRetRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalogRetRecalc.DescId = zc_MIFloat_SummNalogRetRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                        ON MIFloat_SummMinus.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
            LEFT JOIN MovementItemFloat AS MIFloat_SummFine
                                        ON MIFloat_SummFine.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummFine.DescId = zc_MIFloat_SummFine()
            LEFT JOIN MovementItemFloat AS MIFloat_SummFineOth
                                        ON MIFloat_SummFineOth.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummFineOth.DescId = zc_MIFloat_SummFineOth()
            LEFT JOIN MovementItemFloat AS MIFloat_SummFineOthRecalc
                                        ON MIFloat_SummFineOthRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

            LEFT JOIN MovementItemFloat AS MIFloat_SummAuditAdd
                                        ON MIFloat_SummAuditAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()

            LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                        ON MIFloat_SummHoliday.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                        ON MIFloat_SummHosp.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHosp.DescId = zc_MIFloat_SummHosp()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHospOth
                                        ON MIFloat_SummHospOth.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHospOth.DescId = zc_MIFloat_SummHospOth()
            LEFT JOIN MovementItemFloat AS MIFloat_SummHospOthRecalc
                                        ON MIFloat_SummHospOthRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                        ON MIFloat_SummSocialIn.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
            LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                        ON MIFloat_SummSocialAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                        ON MIFloat_SummChild.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()

            LEFT JOIN MovementItemFloat AS MIFloat_SummChildRecalc
                                        ON MIFloat_SummChildRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExt
                                        ON MIFloat_SummMinusExt.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()
            LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExtRecalc
                                        ON MIFloat_SummMinusExtRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummTransport
                                        ON MIFloat_SummTransport.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()
            LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAdd
                                        ON MIFloat_SummTransportAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransportAdd.DescId = zc_MIFloat_SummTransportAdd()
            LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAddLong
                                        ON MIFloat_SummTransportAddLong.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransportAddLong.DescId = zc_MIFloat_SummTransportAddLong()
            LEFT JOIN MovementItemFloat AS MIFloat_SummTransportTaxi
                                        ON MIFloat_SummTransportTaxi.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransportTaxi.DescId = zc_MIFloat_SummTransportTaxi()
            LEFT JOIN MovementItemFloat AS MIFloat_SummPhone
                                        ON MIFloat_SummPhone.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummPhone.DescId = zc_MIFloat_SummPhone()

            LEFT JOIN MovementItemFloat AS MIFloat_SummAddOth
                                        ON MIFloat_SummAddOth.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAddOthRecalc
                                        ON MIFloat_SummAddOthRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummHouseAdd
                                        ON MIFloat_SummHouseAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()

            LEFT JOIN MovementItemFloat AS MIFloat_SummCompensation
                                        ON MIFloat_SummCompensation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCompensation.DescId = zc_MIFloat_SummCompensation()
            LEFT JOIN MovementItemFloat AS MIFloat_SummCompensationRecalc
                                        ON MIFloat_SummCompensationRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummAvance
                                        ON MIFloat_SummAvance.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                        ON MIFloat_SummAvanceRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_DayCompensation
                                        ON MIFloat_DayCompensation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayCompensation.DescId = zc_MIFloat_DayCompensation()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceCompensation
                                        ON MIFloat_PriceCompensation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_PriceCompensation.DescId = zc_MIFloat_PriceCompensation()

            LEFT JOIN MovementItemFloat AS MIFloat_DayVacation
                                        ON MIFloat_DayVacation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayVacation.DescId = zc_MIFloat_DayVacation()
            LEFT JOIN MovementItemFloat AS MIFloat_DayHoliday
                                        ON MIFloat_DayHoliday.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayHoliday.DescId = zc_MIFloat_DayHoliday()
            LEFT JOIN MovementItemFloat AS MIFloat_DayWork
                                        ON MIFloat_DayWork.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayWork.DescId = zc_MIFloat_DayWork()

            LEFT JOIN MovementItemFloat AS MIFloat_DayAudit
                                        ON MIFloat_DayAudit.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayAudit.DescId = zc_MIFloat_DayAudit()

            LEFT JOIN MovementItemFloat AS MIFloat_SummMedicdayAdd
                                        ON MIFloat_SummMedicdayAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMedicdayAdd.DescId = zc_MIFloat_SummMedicdayAdd()

            LEFT JOIN MovementItemFloat AS MIFloat_DayMedicday
                                        ON MIFloat_DayMedicday.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayMedicday.DescId = zc_MIFloat_DayMedicday()

            LEFT JOIN MovementItemFloat AS MIFloat_SummSkip
                                        ON MIFloat_SummSkip.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummSkip.DescId = zc_MIFloat_SummSkip()

            LEFT JOIN MovementItemFloat AS MIFloat_DaySkip
                                        ON MIFloat_DaySkip.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DaySkip.DescId = zc_MIFloat_DaySkip()

            LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                        ON MIFloat_SummAvCardSecond.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAvCardSecond.DescId = zc_MIFloat_SummAvCardSecond()
            LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                        ON MIFloat_SummAvCardSecondRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()

            LEFT JOIN MovementItemFloat AS MIFloat_DayPriceNalog
                                        ON MIFloat_DayPriceNalog.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayPriceNalog.DescId = zc_MIFloat_DayPriceNalog()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                          ON MIBoolean_Main.MovementItemId = tmpAll.MovementItemId
                                         AND MIBoolean_Main.DescId = zc_MIBoolean_Main()

            LEFT JOIN MovementItemBoolean AS MIBoolean_PriceNalog
                                          ON MIBoolean_PriceNalog.MovementItemId = tmpAll.MovementItemId
                                         AND MIBoolean_PriceNalog.DescId = zc_MIBoolean_PriceNalog()

            LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = tmpAll.MovementItemId
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            LEFT JOIN MovementItemDate AS MIDate_BankOut
                                       ON MIDate_BankOut.MovementItemId = tmpAll.MovementItemId
                                      AND MIDate_BankOut.DescId = zc_MIDate_BankOut()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpAll.MemberId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpAll.InfoMoneyId
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpAll.PersonalServiceListId
            LEFT JOIN Object AS Object_PersonalTo ON Object_PersonalTo.Id = tmpMIContainer_all.PersonalId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpAll.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectDate AS ObjectDate_Personal_DateOut
                                 ON ObjectDate_Personal_DateOut.ObjectId = tmpAll.PersonalId
                                AND ObjectDate_Personal_DateOut.DescId = zc_ObjectDate_Personal_Out()

            LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                 ON ObjectDate_DateIn.ObjectId = tmpAll.PersonalId
                                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectString AS ObjectString_Member_Card
                                   ON ObjectString_Member_Card.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_Card.DescId = zc_ObjectString_Member_Card()
            LEFT JOIN ObjectString AS ObjectString_Member_CardSecond
                                   ON ObjectString_Member_CardSecond.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardSecond.DescId = zc_ObjectString_Member_CardSecond()

            LEFT JOIN ObjectString AS ObjectString_Member_CardIBAN
                                   ON ObjectString_Member_CardIBAN.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardIBAN.DescId = zc_ObjectString_Member_CardIBAN()
            LEFT JOIN ObjectString AS ObjectString_Member_CardIBANSecond
                                   ON ObjectString_Member_CardIBANSecond.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardIBANSecond.DescId = zc_ObjectString_Member_CardIBANSecond()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpAll.MemberId_Personal
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_BankOut
                                    ON ObjectBoolean_BankOut.ObjectId = Object_PersonalServiceList.Id
                                   AND ObjectBoolean_BankOut.DescId = zc_ObjectBoolean_PersonalServiceList_BankOut()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                             ON MILinkObject_FineSubject.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
            LEFT JOIN Object AS Object_FineSubject ON Object_FineSubject.Id = MILinkObject_FineSubject.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                             ON MILinkObject_UnitFineSubject.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
            LEFT JOIN Object AS Object_UnitFineSubject ON Object_UnitFineSubject.Id = MILinkObject_UnitFineSubject.ObjectId

            LEFT JOIN tmpMIChild ON tmpMIChild.ParentId = tmpAll.MovementItemId
            LEFT JOIN tmpMIChild_Hours ON tmpMIChild_Hours.ParentId = tmpAll.MovementItemId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                 ON ObjectLink_Personal_PositionLevel.ObjectId = tmpAll.PersonalId
                                AND ObjectLink_Personal_PositionLevel.DescId   = zc_ObjectLink_Personal_PositionLevel()

            LEFT JOIN tmpMIContainer_pay ON tmpMIContainer_pay.MemberId    = tmpAll.MemberId_Personal
                                        AND tmpMIContainer_pay.PositionId  = tmpAll.PositionId
                                        AND tmpMIContainer_pay.UnitId      = tmpAll.UnitId
                                        AND COALESCE (tmpMIContainer_pay.PositionLevelId, 0) = COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId, 0)     

            LEFT JOIN tmpMI_SummCardSecondRecalc ON tmpMI_SummCardSecondRecalc.PersonalId = tmpAll.PersonalId
                                                AND tmpMI_SummCardSecondRecalc.PositionId = tmpAll.PositionId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.07.23         *
 02.05.23         *
 27.03.23         *
 17.01.23         *
 09.06.22         *
 13.03.22         *
 17.11.21         *16:36 04.05.2023
 04.06.20         * DayAudit
 25.03.20         * add SummAuditAdd
 05.02.20         *
 27.01.19         *
 15.10.19         *
 09.09.19         *
 29.07.19         *
 25.06.18         * add SummAddOth,
                        SummAddOthRecalc
 05.01.18         * add SummNalogRet
                        SummNalogRetRecalc
 20.06.17         * add SummCardSecondCash
 24.02.17         *
 20.02.17         *
 21.06.16         *
 20.04.16         * add SummHoliday
 25.03.16         * add Card
 07.05.15         * add PersonalServiceList
 01.10.14         * add redmine 30.09
 14.09.14                                        * ALL
 11.09.14         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_PersonalService (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '106593')
-- SELECT * FROM gpSelect_MovementItem_PersonalService (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
