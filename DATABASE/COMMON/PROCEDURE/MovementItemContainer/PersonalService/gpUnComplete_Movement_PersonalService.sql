-- Function: gpUnComplete_Movement_PersonalService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PersonalService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_PersonalService());

     -- �������� - ���� <Master> ������, �� <������>
     -- PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
                                  
     --��� ������������� ������� Export ������  = FALSE
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Export(), inMovementId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.09.14         *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_PersonalService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
