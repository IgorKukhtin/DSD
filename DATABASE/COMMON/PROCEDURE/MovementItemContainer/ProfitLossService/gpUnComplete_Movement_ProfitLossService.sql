-- Function: gpUnComplete_Movement_ProfitLossService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ProfitLossService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ProfitLossService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ProfitLossService());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.03.14                                        * add lpCheckRight
 17.02.14				                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ProfitLossService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
