-- Function: gpReComplete_Movement_MemberHoliday(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_MemberHoliday(
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

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_MemberHoliday())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
         --��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);
     END IF;

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MemberHoliday()
                                , inUserId     := vbUserId
                                 );

     --��������� ����������� � zc_Movement_SheetWorkTime ���������� �� ������ �������������� WorkTimeKind - ��� ������������� ��� �������� - � ������ ��������� WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, FALSE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.18         *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_MemberHoliday (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
