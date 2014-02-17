-- Function: gpUnComplete_Movement_ProfitLossService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= PERFORM lpCheckRight(inSession, zc_Enum_Process_UnComplete_ProfitLossService());
     vbUserId:=2;


     -- �������� - ���� <Master> ������, �� <������>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');


     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.14				                                           *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ProfitLossService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
