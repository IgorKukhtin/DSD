-- Function: gpUnComplete_Movement_TaxCorrective (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_TaxCorrective());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.02.14                                                         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_TaxCorrective (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())