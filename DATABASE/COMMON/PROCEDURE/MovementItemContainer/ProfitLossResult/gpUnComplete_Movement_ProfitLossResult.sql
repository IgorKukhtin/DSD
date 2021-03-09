-- Function: gpUnComplete_Movement_ProfitLossResult (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ProfitLossResult (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ProfitLossResult(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId_ProfitLossResult_out Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProfitLossResult());

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
               ������� �.�.   ������ �.�.   ���������� �.�.
  09.03.21         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ProfitLossResult (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
