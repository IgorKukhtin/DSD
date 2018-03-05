-- Function: gpComplete_Movement_LossPersonal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_LossPersonal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_LossPersonal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossPersonal());

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_LossPersonal (inMovementId := inMovementId
                                             , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.02.18         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_LossPersonal (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
