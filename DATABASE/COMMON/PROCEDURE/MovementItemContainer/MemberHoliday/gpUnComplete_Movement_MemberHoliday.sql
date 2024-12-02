-- Function: gpUnComplete_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_MemberHoliday());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
                                  
     /*IF NOT EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementDate AS MovementDate_BeginDateStart
                                                 ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()
                                                AND MovementDate_BeginDateStart.ValueData  = (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_BeginDateStart())
             
                         INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                                 ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                AND MovementDate_BeginDateEnd.DescId     = zc_MovementDate_BeginDateEnd()
                                                AND MovementDate_BeginDateEnd.ValueData  = (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_BeginDateEnd())
                    WHERE Movement.DescId   = zc_Movement_MemberHoliday()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                   )*/
     -- ����� �������� - � ������ ��������� WorkTimeKind
     IF vbUserId <> 5
     THEN
         -- ��� ������������� ��� �������� - � ������ ���������  ��������� WorkTimeKind
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);
     END IF;


     -- ���� �������� <� ��� ���������� �������� (1 ������)> + <� ��� ���������� �������� (2 ������)>
     IF EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId()     AND MF.ValueData > 0)
     OR EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId() AND MF.ValueData > 0)
     THEN
         PERFORM gpInsertUpdate_Movement_PersonalServiceByHoliday (inMovementId             := inMovementId
                                                                 , inMemberId               := gpGet.MemberId
                                                                 , inPersonalId             := gpGet.PersonalId
                                                                 , inPersonalServiceListId  := gpGet.PersonalServiceListId
                                                                 , inMovementId_1           := (SELECT MF.ValueData :: Integer FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId())
                                                                 , inMovementId_2           := (SELECT MF.ValueData :: Integer FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId())
                                                                 , inSummHoliday1           := 0
                                                                 , inSummHoliday2           := 0
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


IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.test Admin';
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.18         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_MemberHoliday (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
