-- Function: gpInsertUpdate_MI_PersonalService_Child_byUnit()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit_mes (Integer,Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_byUnit_mes(
    IN inStartDate            TDateTime , -- ����
    IN inEndDate              TDateTime , -- ����
    IN inSessionCode          Integer   , -- � ������ MessagePersonalService
    IN inUnitId               Integer   , -- �������������
    IN inisPersonalService    Boolean   , --
   OUT outPersonalServiceDate TDateTime , --
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TDateTime
AS
$BODY$
    DECLARE vbUserId    Integer;
    DECLARE vbStartDate TDateTime;
    DECLARE vbEndDate   TDateTime;
    DECLARE vbisPersonalService Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     --���� ����������
     if vbUserId IN (9457) then RETURN; end if; 
     
     

     vbisPersonalService := (SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_Unit_PersonalService() AND OB.ObjectId = inUnitId);

     -- �������� �� �������� �������������
     IF COALESCE (vbisPersonalService, FALSE) = FALSE
        -- AND vbUserId <> 5
     THEN 
         RETURN;
     END IF;


     /*
     IF COALESCE (inisPersonalService, FALSE) = FALSE     --zc_ObjectBoolean_Unit_PersonalService
     THEN
         RETURN;
     END IF;
     */

     -- ������ �� ������� �����
     --vbStartDate := DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime);  --'01.02.2025' ::TDateTime; --
     --vbEndDate   := DATE_TRUNC ('MONTH', CURRENT_DATE)  - INTERVAL '1 DAY';    --'19.02.2025' ::TDateTime; --        
     vbStartDate := inStartDate;
     vbEndDate   := inEndDate;

     IF inStartDate <> vbStartDate OR inEndDate <> vbEndDate
     THEN
         RAISE EXCEPTION '������.��������� ������ ���������� �� ����������.';
     END IF;
     
-- RAISE EXCEPTION 'Test.Ok. <%>  <%>', vbStartDate,  vbEndDate;

     --
     CREATE TEMP TABLE _tmpMessagePersonalService (MemberId Integer
                                                 , PersonalServiceListId Integer
                                                 , Name TVarChar
                                                 , Comment TVarChar) ON COMMIT DROP;

     CREATE TEMP TABLE _tmpPersonal (PersonalId Integer
                                   , MemberId Integer
                                   , PositionId Integer
                                   , PositionLevelId Integer
                                   , PersonalServiceListId Integer
                                   , UnitId Integer
                                   , isMain Boolean
                                   , isErased Boolean) ON COMMIT DROP;

     ---- ������� �������, � ������� ����� ������ ��� ������ ��� �������
     CREATE TEMP TABLE _tmpReport (PersonalServiceListId Integer
                                 , MemberId Integer
                                 , PositionId Integer
                                 , PositionLevelId Integer
                                 , StaffListId Integer
                                 , ModelServiceId Integer
                                 , ServiceModelName TVarChar
                                 , StaffListSummKindId Integer
                                 , AmountOnOneMember TFloat
                                 , Count_Member TFloat
                                 , Count_Day TFloat
                                 , SheetWorkTime_Amount TFloat
                                 , SUM_MemberHours TFloat
                                 , Price TFloat
                                 , GrossOnOneMember TFloat
                                 , KoeffHoursWork_car TFloat) ON COMMIT DROP;
     INSERT INTO _tmpReport (PersonalServiceListId
                           , MemberId
                           , PositionId
                           , PositionLevelId
                           , StaffListId
                           , ModelServiceId
                           , ServiceModelName
                           , StaffListSummKindId
                           , AmountOnOneMember
                           , Count_Member
                           , Count_Day
                           , SheetWorkTime_Amount
                           , SUM_MemberHours
                           , Price
                           , GrossOnOneMember
                           , KoeffHoursWork_car )
     SELECT tmp.PersonalServiceListId
          , CASE WHEN COALESCE (ObjectLink_Personal_Member.ChildObjectId,0) <> 0 THEN ObjectLink_Personal_Member.ChildObjectId ELSE tmp.MemberId END AS MemberId
          , tmp.PositionId
          , tmp.PositionLevelId
          , tmp.StaffListId
          , tmp.ModelServiceId
          , tmp.ServiceModelName
          , tmp.StaffListSummKindId
          , tmp.AmountOnOneMember
          , tmp.Count_Member
          , tmp.Count_Day
          , tmp.SheetWorkTime_Amount
          , tmp.SUM_MemberHours
          , tmp.Price
          , tmp.GrossOnOneMember
          , tmp.KoeffHoursWork_car
     FROM gpSelect_Report_Wage_Server(inStartDate      := vbStartDate ::TDateTime --���� ������ �������
                                    , inEndDate        := vbEndDate   ::TDateTime --���� ��������� �������
                                    , inUnitId         := inUnitId    ::Integer   --�������������
                                    , inModelServiceId := 0           ::Integer   --������ ����������
                                    , inMemberId       := 0           ::Integer   --���������
                                    , inPositionId     := 0           ::Integer   --���������
                                    , inDetailDay                    := FALSE  ::Boolean   --�������������� �� ����
                                    , inDetailMonth                  := FALSE  ::Boolean   --�������������� �� �������
                                    , inDetailModelService           := TRUE   ::Boolean   --�������������� �� �������
                                    , inDetailModelServiceItemMaster := TRUE   ::Boolean   --�������������� �� ����� ���������� � ������
                                    , inDetailModelServiceItemChild  := FALSE  ::Boolean   --�������������� �� ������� � ����� ����������
                                    , inSession        := inSession   ::TVarChar
                                    ) tmp
          --����� ����� ������� ���������� � MemberId
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                               ON ObjectLink_Personal_Member.ObjectId = tmp.MemberId
                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_NotAuto
                                  ON ObjectBoolean_NotAuto.ObjectId  = tmp.PersonalServiceListId
                                 AND ObjectBoolean_NotAuto.DescId    = zc_ObjectBoolean_PersonalServiceList_NotAuto()
     WHERE COALESCE (ObjectBoolean_NotAuto.ValueData, FALSE) = FALSE 
     ;


     INSERT INTO _tmpPersonal (PersonalId
                             , MemberId
                             , PositionId
                             , PositionLevelId
                             , PersonalServiceListId
                             , UnitId
                             , isMain
                             , isErased)
     SELECT Object_Personal.Id                                            AS PersonalId
          , ObjectLink_Personal_Member.ChildObjectId                      AS MemberId
          , COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0)      AS PositionId
          , COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId
          , ObjectLink_Personal_PersonalServiceList.ChildObjectId         AS PersonalServiceListId 
          , ObjectLink_Personal_Unit.ChildObjectId                        AS UnitId
          , COALESCE (ObjectBoolean_Main.ValueData, FALSE)                AS isMain
          , Object_Personal.isErased                                      AS isErased
     FROM Object AS Object_Personal
          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                               --AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                               ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                               ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                               ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
     WHERE Object_Personal.DescId = zc_Object_Personal()
       --AND Object_Personal.isErased = FALSE
     ;

     --��������
     --1) ��������� �� ���������
     --2) � ������� ��� - ��������� ����� "��������� ���������� �������"
     --3) ������������ ��������� � ������ � � "����������� ������� ���������� (������)
     --4)���� � ������, ����� ���� ����������
     --5)���� � ������, �� ���� ������
     --6) ���� ������� "�������� ����� ������" , ���� � ������� ��� �������� ������
        -- ������ ����� ���������� � ����������, ���� �� ������ - ����������� ������ ��� ��������� �� ������ + ��� + ��������� + ��������� + � ������ + ����/����� - ��� � zc_Object_MessagePersonalService, ���� ������ ��� ����� 1 ������� ��������� + � ������ + ����/�����


     -- 1 ��������� �� ���������
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT NULL :: Integer, tmp.PersonalServiceListId, '�������� ��������' ::TVarChar, '�������� 1' ::TVarChar
     FROM
          (WITH
           tmpMovement AS (SELECT tmpPSL.PersonalServiceListId
                                , Movement.StatusId
                                , ROW_NUMBER () OVER (PARTITION BY tmpPSL.PersonalServiceListId ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId) AS Ord
                           FROM (SELECT DISTINCT _tmpReport.PersonalServiceListId FROM _tmpReport) AS tmpPSL
                               INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                             ON MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                            AND MLO_PersonalServiceList.ObjectId   = tmpPSL.PersonalServiceListId
                               INNER JOIN Movement ON Movement.Id = MLO_PersonalServiceList.MovementId
                                                  AND Movement.DescId   = zc_Movement_PersonalService()
                                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                               INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                       ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                      AND MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', vbEndDate)
                                                      AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
                               LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                                         ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                        AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                           )
           SELECT tmpMovement.*
           FROM tmpMovement                
           WHERE tmpMovement.Ord = 1
           ) AS tmp
     WHERE tmp.StatusId = zc_Enum_Status_Complete();

     --RAISE EXCEPTION 'Test1. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);

     -- 2 � ������� ��� - ��������� ����� "��������� ���������� �������"
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, '�� ����������� �������� <��������� ����������>' ::TVarChar, '�������� 2' ::TVarChar
     FROM
          (SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
           WHERE COALESCE (spReport.PersonalServiceListId, 0) = 0
          ) AS tmp;
     ---RAISE EXCEPTION 'Test2. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);

     -- 3 ������������ ��������� � ������ � � "����������� ������� ���������� (������)
     -- �������� ������ �� ���. ������� ���������� �� ����������, � ��������� ��� �� �����. ��������� ��� ����������� ������
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, '��������� ('||Object_Position.ObjectCode :: TVarChar||')'|| Object_Position.ValueData|| '  ��� ��� ����� ' ||tmp.ServiceModelName ||' �� ������������� �������� ����������' ::TVarChar, '�������� 3' ::TVarChar
     FROM
          (WITH
           tmpStaffList AS (SELECT
                                  ObjectLink_StaffList_Unit.ObjectId               AS StaffListId
                                , ObjectLink_StaffList_Position.ChildObjectId      AS PositionId
                                , ObjectLink_StaffList_PositionLevel.ChildObjectId AS PositionLevelId
                                , Coalesce(ObjectBoolean_PositionLevel.ValueData,False)  AS isPositionLevel
                            FROM ObjectLink AS ObjectLink_StaffList_Unit
                                 LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                      ON ObjectLink_StaffList_Position.ObjectId = ObjectLink_StaffList_Unit.ObjectId
                                                     AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()

                                 LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                                      ON ObjectLink_StaffList_PositionLevel.ObjectId = ObjectLink_StaffList_Unit.ObjectId
                                                     AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionLevel
                                                         ON ObjectBoolean_PositionLevel.ObjectId = ObjectLink_StaffList_Unit.ObjectId
                                                        AND ObjectBoolean_PositionLevel.DescId = zc_ObjectBoolean_StaffList_PositionLevel()

                            WHERE ObjectLink_StaffList_Unit.ChildObjectId = inUnitId
                              AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
                            )
           SELECT DISTINCT
                  spReport.MemberId
                , spReport.PersonalServiceListId
                , spReport.PositionId
                , spReport.ServiceModelName
           FROM _tmpReport AS spReport
                LEFT JOIN tmpStaffList ON tmpStaffList.StaffListId = spReport.StaffListId
                                      AND tmpStaffList.PositionId = spReport.PositionId
                                      AND (COALESCE (tmpStaffList.PositionLevelId,0) = COALESCE (spReport.PositionLevelId,0) OR tmpStaffList.isPositionLevel = TRUE)
           WHERE tmpStaffList.PositionId IS NULL
          ) AS tmp
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmp.PositionId
          ;

     -- 4) ���� � ������, ����� ���� ����������
     -- 5) ���� � ������, �� ���� ������
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId
          , tmp.PersonalServiceListId
          , CASE WHEN tmp.ErrorCode = 4 THEN '���� � ������, ����� ���� ����������'
                 WHEn tmp.ErrorCode = 5 THEN '���� � ������, �� ���� ������'
            END ::TVarChar
          , CASE WHEN tmp.ErrorCode = 4 THEN '�������� 4'
                 WHEn tmp.ErrorCode = 5 THEN '�������� 5'
            END ::TVarChar
     FROM
          (WITH
          -- ������� �������� � ��������� ����. � ������ ������
          tmpListOut AS (SELECT Object_Personal_View.MemberId
                              , MAX (Object_Personal_View.PersonalId) AS PersonalId
                              , Object_Personal_View.PositionId
                              , _tmpReport.PersonalServiceListId
                              , COALESCE (Object_Personal_View.PositionLevelId,0) AS PositionLevelId
                              , MAX (CASE WHEN Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate
                                               THEN Object_Personal_View.DateIn
                                          ELSE zc_DateStart()
                                     END)  AS DateIn
                              , CASE WHEN MAX (COALESCE (Object_Personal_View.DateOut_user, zc_DateStart())) = zc_DateStart()
                                          THEN zc_DateEnd()
                                     ELSE MAX (COALESCE (Object_Personal_View.DateOut_user, zc_DateStart()))
                                END :: TDateTime AS DateOut
                         FROM _tmpReport
                             LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = _tmpReport.MemberId
                                                           AND Object_Personal_View.PositionId = _tmpReport.PositionId
                                                           AND COALESCE (Object_Personal_View.PositionLevelId,0) = COALESCE (_tmpReport.PositionLevelId,0)
                                                           AND Object_Personal_View.UnitId = inUnitId
                         WHERE ((Object_Personal_View.DateOut >= vbStartDate AND Object_Personal_View.DateOut <= vbEndDate)
                             OR (Object_Personal_View.DateIn >= vbStartDate AND Object_Personal_View.DateIn <= vbEndDate)
                                )
                         GROUP BY Object_Personal_View.MemberId
                                , Object_Personal_View.PositionId
                                , COALESCE (Object_Personal_View.PositionLevelId,0)
                                , _tmpReport.PersonalServiceListId
                         )
        , tmpOperDate AS (SELECT GENERATE_SERIES (vbStartDate, vbEndDate, '1 DAY' :: INTERVAL) AS OperDate)

        , tmpWorkTimeKind AS (SELECT SUM (COALESCE (MI_SheetWorkTime.Amount, 0))   AS Amount
                                   , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                                   , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                                   , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                                   , Movement.operDate
                              FROM tmpOperDate
                                   JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                                AND Movement.DescId = zc_Movement_SheetWorkTime()
                                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                                   JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          AND MovementLinkObject_Unit.ObjectId = inUnitId
                                   JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                                        AND MI_SheetWorkTime.DescId = zc_MI_Master()
                                                                        AND MI_SheetWorkTime.isErased = FALSE
                                   LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                                    ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                                   AND MIObject_Position.DescId = zc_MILinkObject_Position()
                                   LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                    ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                                   AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                   LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                                    ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                                                   AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                   INNER JOIN (SELECT DISTINCT tmpListOut.MemberId
                                                    , tmpListOut.PositionId
                                                    , tmpListOut.PositionLevelId
                                               FROM tmpListOut) AS tmpMember ON tmpMember.MemberId = COALESCE(MI_SheetWorkTime.ObjectId, 0)
                                                                            AND tmpMember.PositionId = COALESCE(MIObject_Position.ObjectId, 0)
                                                                            AND COALESCE(tmpMember.PositionLevelId,0) = COALESCE(MIObject_PositionLevel.ObjectId, 0)
                              GROUP BY COALESCE(MI_SheetWorkTime.ObjectId, 0)
                                     , COALESCE(MIObject_Position.ObjectId, 0)
                                     , COALESCE(MIObject_PositionLevel.ObjectId, 0)
                                     , Movement.operDate
                             )
        -- ������ 4, 5
         , tmpDate AS (SELECT tmp.operdate
                            , tmp.Amount
                            , tmp.MemberId
                            , COALESCE (tmpList.PersonalServiceListId, tmpList_out.PersonalServiceListId) AS PersonalServiceListId
                            --, tmp.PositionId
                            --, tmp.PositionLevelId
                            --, COALESCE (tmpList.DateIn, tmpList_out.DateIn) AS DateIn
                            --, COALESCE (tmpList.DateOut, tmpList_out.DateOut) AS DateOut
                            , CASE WHEN tmpList.MemberId IS NOT NULL THEN 5
                                   WHEN tmpList_out.MemberId IS NOT NULL THEN 4
                              END AS ErrorCode
                       FROM tmpWorkTimeKind AS tmp
                          -- ���� ��� ������ �� ������� ������ ��� ������ � ������� ������ �������� �

                          LEFT JOIN tmpListOut AS tmpList
                                               ON tmpList.DateIn   > tmp.OperDate
                                              AND tmpList.MemberId = tmp.MemberId
                                              AND tmpList.PositionId = tmp.PositionId
                                              AND COALESCE (tmpList.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                              AND tmp.Amount            <> 0
                          LEFT JOIN tmpListOut AS tmpList_out
                                               ON tmpList_out.DateOut   < tmp.OperDate
                                              AND tmpList_out.MemberId = tmp.MemberId
                                              AND tmpList_out.PositionId = tmp.PositionId
                                              AND COALESCE (tmpList_out.PositionLevelId,0) = COALESCE (tmp.PositionLevelId,0)
                                              AND tmp.Amount            <> 0
                        WHERE tmpList.MemberId IS NOT NULL or tmpList_out.MemberId IS NOT NULL
                        )
             --
             SELECT DISTINCT
                    tmp.MemberId
                  , tmp.PersonalServiceListId
                  , tmp.ErrorCode
             FROM tmpDate AS tmp

             ) AS tmp;

     -- 6) ���� ������� "�������� ����� ������", ���� � ������� ��� �������� ������
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId
         , CASE WHEN tmp.isErased = TRUE THEN '���������� �� �������� ��������, � � ����� � ����'
                ELSE'�������� ����� ������ �� ������� ����� ����'
           END ::TVarChar
         , '�������� 6' ::TVarChar
     FROM
          (WITH
           --���������� �� ��� ���������� �������� ����� ������
           tmpMain AS (SELECT DISTINCT _tmpPersonal.MemberId, _tmpPersonal.isErased
                       FROM _tmpPersonal
                       WHERE _tmpPersonal.isMain = TRUE
                         --AND _tmpPersonal.isErased = FALSE
                       )
           --��������� �� ����������� ���������
         , tmp1 AS (SELECT spReport.MemberId
                         , spReport.PersonalServiceListId
                         , tmpMain.isErased
                    FROM _tmpReport AS spReport
                         LEFT JOIN tmpMain ON tmpMain.MemberId = spReport.MemberId
                                          AND  tmpMain.isErased = FALSE
                    WHERE tmpMain.MemberId IS NULL
                    )
           SELECT tmp1.MemberId
                , tmp1.PersonalServiceListId
                , COALESCE (tmp1.isErased, tmpMain.isErased) AS isErased
           FROM tmp1 
                LEFT JOIN tmpMain ON tmpMain.MemberId = tmp1.MemberId
                                 AND tmpMain.isErased = TRUE        
          ) AS tmp;

     --RAISE EXCEPTION 'Test6. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);

     -- 7  StaffListId
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, '�� ����������� �������� <������� ����������>' ::TVarChar, '�������� 7' ::TVarChar
     FROM
          (SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
           WHERE COALESCE (spReport.StaffListId, 0) = 0
          ) AS tmp;

     -- 8 ������ ���������� ��� ���� ���� ��� �������� ����������
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, '�� ����������� �������� <������ ����������> ��� <���� ���� ��� �������� ����������>.' ::TVarChar, '�������� 8' ::TVarChar
     FROM
          (SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
           WHERE COALESCE (spReport.ModelServiceId, 0) = 0 
             AND COALESCE (spReport.StaffListSummKindId, 0) = 0
          ) AS tmp;


     /*--*******************************--*/
     -- ����� ��������
     IF (SELECT COUNT (*) FROM _tmpMessagePersonalService) > 0
     THEN
         -- ���� ���� ������ �� ���������� �� � MessagePersonalService
         PERFORM gpInsertUpdate_Object_MessagePersonalService (ioId                    := 0                          ::Integer       --
                                                             , ioCode                  := inSessionCode              ::Integer      -- � ������
                                                             , inName                  := tmp.Name                   ::TVarChar     -- ��������� �� ������
                                                             , inUnitId                := inUnitId
                                                             , inPersonalServiceListId := tmp.PersonalServiceListId  ::Integer      --
                                                             , inMemberId              := tmp.MemberId               ::Integer      --
                                                               -- ����������
                                                             , inComment               := (tmp.Comment || ' �� ������ � <'  || zfConvert_DateToString (inStartDate) || '> �� <' || zfConvert_DateToString (inEndDate) || '>') :: TVarChar
                                                             , inSession               := inSession                  ::TVarChar
                                                              )
         FROM (SELECT DISTINCT 
                      _tmpMessagePersonalService.Name
                    , _tmpMessagePersonalService.PersonalServiceListId
                    , _tmpMessagePersonalService.MemberId
                    , _tmpMessagePersonalService.Comment
               FROM _tmpMessagePersonalService
              ) AS tmp; 
         
     ELSEIF 1=1 -- vbUserId NOT IN (5)
     THEN

         -- ������� ������� ����� �����������
         PERFORM gpInsertUpdate_MI_PersonalService_Child_Erased (inUnitId                := inUnitId                  ::Integer
                                                               , inPersonalServiceListId := tmp.PersonalServiceListId ::Integer    -- ��������� ����������
                                                               , inStartDate             := vbStartDate               ::TDateTime  -- ����
                                                               , inEndDate               := vbEndDate                 ::TDateTime  -- ����
                                                               , inPositionId            := 0                         ::Integer    -- ���� = 0, ����� ������� ���, ����� - ������ ��� ���������
                                                               , inSession               := inSession                 ::TVarChar
                                                               )
         FROM (SELECT DISTINCT tmp.PersonalServiceListId
               FROM _tmpReport AS tmp
               ) AS tmp;

         -- ��������� ����������� ������� ������ �� ��
         PERFORM gpInsertUpdate_MI_PersonalService_Child_Auto (inUnitId                 := inUnitId
                                                             , inPersonalServiceListId  := tmp.PersonalServiceListId
                                                             , inMemberId               := tmp.MemberId
                                                             , inStartDate              := vbStartDate
                                                             , inEndDate                := vbEndDate
                                                             , inPositionId             := tmp.PositionId
                                                             , inPositionLevelId        := tmp.PositionLevelId
                                                             , inStaffListId            := tmp.StaffListId
                                                             , inModelServiceId         := tmp.ModelServiceId
                                                             , inStaffListSummKindId    := tmp.StaffListSummKindId
                                                             , inAmount                 := tmp.AmountOnOneMember
                                                             , inMemberCount            := tmp.Count_Member
                                                             , inDayCount               := tmp.Count_Day
                                                             , inWorkTimeHoursOne       := tmp.SheetWorkTime_Amount
                                                             , inWorkTimeHours          := tmp.SUM_MemberHours
                                                             , inPrice                  := tmp.Price
                                                             , inGrossOne               := tmp.GrossOnOneMember
                                                             , inKoeff                  := tmp.KoeffHoursWork_car
                                                             , inSession                := inSession
                                                              )
         FROM _tmpReport AS tmp;

 
         -- ���� ��� ������ �� ���������� � MessagePersonalService ��������� �� ������, ������� ����������
         PERFORM gpInsertUpdate_Object_MessagePersonalService (ioId                    := 0                          ::Integer       -- ���� �������
                                                             , ioCode                  := inSessionCode              ::Integer       -- � ������
                                                             , inName                  := '��� ������'               ::TVarChar      -- ��������� �� ������
                                                             , inUnitId                := inUnitId
                                                             , inPersonalServiceListId := tmp.PersonalServiceListId  ::Integer       --
                                                             , inMemberId              := NULL                       ::Integer       --
                                                               -- ����������
                                                             , inComment               := ('��������� �� ������ � <' || zfConvert_DateToString (inStartDate) || '> �� <' || zfConvert_DateToString (inEndDate) || '>') :: TVarChar
                                                             , inSession               := inSession                  ::TVarChar
                                                              )
         FROM (SELECT DISTINCT _tmpReport.PersonalServiceListId FROM _tmpReport) AS tmp;


         -- ��������� �������� <> 
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_PersonalService(), inUnitId, CURRENT_TIMESTAMP ::TDateTime);

         -- ��� ����� - ������ ��� �������������
         if vbUserId IN (9457, 5) then RAISE EXCEPTION 'Test.Ok. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService); end if;
         -- RAISE EXCEPTION '������ ���.��� ��������� ������ ������������ ������ � ��������� ���������.'; 

     END IF;

    -- ��� �����
    if vbUserId IN (9457) then RAISE EXCEPTION 'Test.Ok. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService); end if;

    outPersonalServiceDate := CURRENT_TIMESTAMP;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.25         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_PersonalService_Child_byUnit_mes( inStartDate := '01.02.2025', inEndDate := '01.02.2025' , inSessionCode := 1 ::Integer, inUnitId := 8449 ::Integer, inisPersonalService:= TRUE ::Boolean, inSession := '9457' ::TVarChar)


---  inSession        := '6561986'   ::TVarChar
-- 3080681 