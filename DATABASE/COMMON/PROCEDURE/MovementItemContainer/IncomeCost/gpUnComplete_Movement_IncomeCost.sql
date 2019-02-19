-- Function: gpUnComplete_Movement_IncomeCost (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_IncomeCost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Income());


     -- �������� <����� ����� ������ �� ��������� (� ������ ���)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSpending(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId), 0);

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId
                                   );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.01.19                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_IncomeCost (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
