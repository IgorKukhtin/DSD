-- Function: gpSetErased_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MemberHoliday());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     --��� ������������� ��� �������� - � ������ ���������  ��������� WorkTimeKind
     PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.18         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_MemberHoliday (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
