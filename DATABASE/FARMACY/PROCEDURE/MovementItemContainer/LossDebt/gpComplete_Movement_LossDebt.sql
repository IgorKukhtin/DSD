-- Function: gpComplete_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_LossDebt(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossDebt());

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- �������� ��������
     PERFORM lpComplete_Movement_LossDebt (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.03.15                        * 

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_LossDebt (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 601, inSession:= zfCalc_UserAdmin())
