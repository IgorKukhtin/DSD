-- Function: gpUnComplete_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_LossDebt(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_LossDebt());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.15                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_LossDebt (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
