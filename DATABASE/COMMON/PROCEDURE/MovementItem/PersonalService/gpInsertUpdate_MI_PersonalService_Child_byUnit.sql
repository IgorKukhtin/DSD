-- Function: gpInsertUpdate_MI_PersonalService_Child_byUnit()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PersonalService_Child_byUnit (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PersonalService_Child_byUnit(
    --IN inStartDate            TDateTime , -- ����
    --IN inEndDate              TDateTime , -- ���� 
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

     -- ���� 3� 11,2022, ���� ���.01,12,2022
     vbStartDate := '01.12.2022';
     vbEndDate   := '30.12.2022';

     /*
     -- ������ �� ������� �����
     vbStartDate := DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 MONTH');
     vbEndDate   := DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'); 
     */

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
       FROM  gpSelect_Report_Wage_Server(inStartDate      := vbStartDate ::TDateTime --���� ������ �������
                                       , inEndDate        := vbEndDate   ::TDateTime --���� ��������� �������
                                       , inUnitId         := inUnitId    ::Integer   --�������������
                                       , inModelServiceId := 0           ::Integer   --������ ����������
                                       , inMemberId       := 0           ::Integer   --���������
                                       , inPositionId     := 0           ::Integer   --���������
                                       , inDetailDay                    := FALSE  ::Boolean   --�������������� �� ����
                                       , inDetailModelService           := FALSE  ::Boolean   --�������������� �� �������
                                       , inDetailModelServiceItemMaster := FALSE  ::Boolean   --�������������� �� ����� ���������� � ������
                                       , inDetailModelServiceItemChild  := FALSE  ::Boolean   --�������������� �� ������� � ����� ����������
                                       , inSession        := inSession   ::TVarChar
                                       ) tmp;  
                                        
    outPersonalServiceDate := CURRENT_TIMESTAMP;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
*/

-- ����
--