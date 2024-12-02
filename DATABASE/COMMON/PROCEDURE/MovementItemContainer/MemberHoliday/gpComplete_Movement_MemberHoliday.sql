-- Function: gpComplete_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_MemberHoliday());

     --��������  �� ���� ������ �������, ���� ��� ������ � �����-�� ���� �������� ������ ��� �� ����  ��������� � ���� � �.�.
     PERFORM gpGet_MemberHoliday_Check_byPersonalGroup (inMovementId, inSession);

     IF vbUserId <> 5
     THEN
         -- ��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, FALSE, (-1 * vbUserId)::TVarChar);
     END IF;


    -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MemberHoliday()
                                , inUserId     := vbUserId
                                 );

     -- ���� �������� <� ��� ���������� �������� (1 ������)> + <� ��� ���������� �������� (2 ������)>
     IF EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId()     AND MF.ValueData > 0)
     OR EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId() AND MF.ValueData > 0)
     THEN
         PERFORM gpInsertUpdate_Movement_PersonalServiceByHoliday (inMovementId             := inMovementId
                                                                 , inMemberId               := gpGet.MemberId
                                                                 , inPersonalId             := gpGet.PersonalId
                                                                 , inPersonalServiceListId  := gpGet.PersonalServiceListId
                                                                 , inMovementId_1           := gpGet.MovementId_PersonalService1
                                                                 , inMovementId_2           := gpGet.MovementId_PersonalService2
                                                                 , inSummHoliday1           := gpGet.SummHoliday1_calc
                                                                 , inSummHoliday2           := gpGet.SummHoliday2_calc
                                                                 , inAmountCompensation     := gpGet.AmountCompensation
                                                                 , inServiceDate1           := gpGet.ServiceDateStart
                                                                 , inServiceDate2           := gpGet.ServiceDateEnd
                                                                 , inUnitId                 := gpGet.UnitId
                                                                 , inPositionId             := gpGet.PositionId
                                                                 , inisMain                 := gpGet.IsMain
                                                                 , inSession                := inSession
                                                                  )
         FROM gpGet_Movement_MemberHolidayForPersonalService (inMovementId := inMovementId, inSession:= inSession) AS gpGet;

     END IF;

-- !!! �������� !!!
IF vbUserId = 5 AND 1=0 THEN
    RAISE EXCEPTION 'Admin - Test = OK';
END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.18         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_MemberHoliday (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
