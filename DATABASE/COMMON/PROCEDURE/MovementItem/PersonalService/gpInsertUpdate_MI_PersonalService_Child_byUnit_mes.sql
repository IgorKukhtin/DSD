-- Function: gpInsertUpdate_MI_PersonalService_Child_byUnit()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit_mes (Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_byUnit_mes(
    --IN inStartDate            TDateTime , -- ����
    --IN inEndDate              TDateTime , -- ���� 
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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF COALESCE (inisPersonalService, FALSE) = FALSE
     THEN
         RETURN;
     END IF;

     -- ������ �� ������� �����
     vbStartDate := '01.02.2025' ::TDateTime; --DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime);
     vbEndDate   := '19.02.2025' ::TDateTime; --DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 DAY')::TDateTime); 
     
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
                                   , isMain Boolean) ON COMMIT DROP;  
                                           
     ---- ������� �������, � ������� ����� ������ ��� ������ ��� �������
     CREATE TEMP TABLE _tmpReport (PersonalServiceListId Integer
                                 , MemberId Integer
                                 , PositionId Integer
                                 , PositionLevelId Integer
                                 , StaffListId Integer
                                 , ModelServiceId Integer
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
          , tmp.MemberId
          , tmp.PositionId
          , tmp.PositionLevelId
          , tmp.StaffListId
          , tmp.ModelServiceId
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
                                    , inDetailModelService           := FALSE  ::Boolean   --�������������� �� �������
                                    , inDetailModelServiceItemMaster := FALSE  ::Boolean   --�������������� �� ����� ���������� � ������
                                    , inDetailModelServiceItemChild  := FALSE  ::Boolean   --�������������� �� ������� � ����� ����������
                                    , inSession        := inSession   ::TVarChar
                                    ) tmp;


     INSERT INTO _tmpPersonal (PersonalId
                             , MemberId
                             , PositionId
                             , PositionLevelId
                             , PersonalServiceListId
                             , isMain)
     SELECT Object_Personal.Id                                            AS PersonalId
          , ObjectLink_Personal_Member.ChildObjectId                      AS MemberId
          , COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0)      AS PositionId
          , COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId, 0) AS PositionLevelId
          , ObjectLink_Personal_PersonalServiceList.ChildObjectId         AS PersonalServiceListId
          , COALESCE (ObjectBoolean_Main.ValueData, FALSE)                AS isMain
     FROM Object AS Object_Personal
          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                               AND ObjectLink_Personal_Unit.ChildObjectId = inUnitId 
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
       AND Object_Personal.isErased = FALSE;


     --��������  
     --1) ��������� �� ���������
     --2) � ������� ��� - ��������� ����� "��������� ���������� �������" 
     --3) ������������ ��������� � ������ � � "����������� ������� ���������� (������) 
     --4) ���� � ������, �� ���� ���������� 
     --5) ���� � ������, ����� ���� ������ 
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
     SELECT tmp.MemberId, tmp.PersonalServiceListId, '������� ��������� �� �����������' ::TVarChar, '�������� 2' ::TVarChar
     FROM 
          (SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
                LEFT JOIN _tmpPersonal ON _tmpPersonal.MemberId = spReport.MemberId
                                      AND _tmpPersonal.PositionId = spReport.PositionId
                                      AND _tmpPersonal.PositionLevelId = spReport.PositionLevelId
           WHERE _tmpPersonal.PersonalServiceListId IS NULL
          ) AS tmp;
     ---RAISE EXCEPTION 'Test2. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);  

     -- 3 ������������ ��������� � ������ � � "����������� ������� ���������� (������)
     -- 4) ���� � ������, �� ���� ���������� 
     -- 5) ���� � ������, ����� ���� ������
     
      
     -- 6) ���� ������� "�������� ����� ������" , ���� � ������� ��� �������� ������ 
     INSERT INTO _tmpMessagePersonalService (MemberId, PersonalServiceListId, Name, Comment)
     SELECT tmp.MemberId, tmp.PersonalServiceListId, '�������� ����� ������ �� �����������' ::TVarChar, '�������� 6' ::TVarChar
     FROM 
          (WITH
           --���������� �� ��� ���������� �������� ����� ������
           tmpMain AS (SELECT DISTINCT _tmpPersonal.MemberId
                       FROM _tmpPersonal
                       WHERE _tmpPersonal.isMain = TRUE 
                      )
           SELECT spReport.MemberId
                , spReport.PersonalServiceListId
           FROM _tmpReport AS spReport
                LEFT JOIN tmpMain ON tmpMain.MemberId = spReport.MemberId
           WHERE tmpMain.MemberId IS NULL
          ) AS tmp;
     
     --RAISE EXCEPTION 'Test6. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService);
     
     -- ����� ��������  
     IF (SELECT COUNT (*) FROM _tmpMessagePersonalService) > 0
     THEN
         -- ���� ���� ������ �� ���������� �� � MessagePersonalService
         PERFORM gpInsertUpdate_Object_MessagePersonalService(ioId                    := 0                          ::Integer,       --
                                                              inCode                  := inSessionCode              ::Integer,      -- � ������           
                                                              inName                  := tmp.Name                   ::TVarChar,     -- ��������� �� ������
                                                              inPersonalServiceListId := tmp.PersonalServiceListId  ::Integer,      --                    
                                                              inMemberId              := tmp.MemberId               ::Integer,      --                    
                                                              inComment               := tmp.Comment                ::TVarChar,     -- ����������         
                                                              inSession               := inSession                  ::TVarChar
                                                              )
         FROM _tmpMessagePersonalService AS tmp;
     
     ELSE    
     /*
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
       */

       -- ���� ��� ������ �� ���������� � MessagePersonalService ��������� �� ������, ������� ����������
       PERFORM gpInsertUpdate_Object_MessagePersonalService(ioId                    := 0                          ::Integer,       -- ���� �������
                                                            inCode                  := inSessionCode              ::Integer,       -- � ������            
                                                            inName                  := '��� ������'               ::TVarChar,      -- ��������� �� ������ 
                                                            inPersonalServiceListId := tmp.PersonalServiceListId  ::Integer,       --                    
                                                            inMemberId              := NULL                       ::Integer,       --                    
                                                            inComment               := '���������'                ::TVarChar,      -- ����������         
                                                            inSession               := inSession                  ::TVarChar
                                                            )
       FROM (SELECT DISTINCT _tmpReport.PersonalServiceListId FROM _tmpReport) AS tmp; 
                    
     END IF;
         
    outPersonalServiceDate := CURRENT_TIMESTAMP;

    --if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ok. <%>', (SELECT COUNT (*) FROM _tmpMessagePersonalService); end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.25         *
*/

-- ����
--select * from  gpInsertUpdate_MI_PersonalService_Child_byUnit_mes( inSessionCode := 1 ::Integer, inUnitId := 8449 ::Integer, inisPersonalService:= TRUE ::Boolean, inSession := '6561986' ::TVarChar)