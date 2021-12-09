-- Function: gpUnComplete_Movement_Pretension (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Pretension (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Pretension(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnit Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbChangeIncmePaymentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Pretension());

     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

                                  
     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.12.21                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Pretension (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
