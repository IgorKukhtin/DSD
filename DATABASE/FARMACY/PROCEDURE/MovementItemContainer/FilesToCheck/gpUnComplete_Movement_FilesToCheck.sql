-- Function: gpUnComplete_Movement_FilesToCheck (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_FilesToCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_FilesToCheck(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= inSession;
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_FilesToCheck());

    -- �������� - ���� <Master> ������, �� <������>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --������������� ����� ��������� �� ��������� �����
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.22                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_FilesToCheck (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())

