-- Function: gpUnComplete_Movement_IncomeAsset (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_IncomeAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_IncomeAsset(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_IncomeAsset());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.08.16         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_IncomeAsset (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
