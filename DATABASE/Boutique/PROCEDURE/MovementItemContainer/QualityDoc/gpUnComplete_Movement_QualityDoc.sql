-- Function: gpUnComplete_Movement_QualityDoc (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_QualityDoc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_QualityDoc(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_QualityDoc());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_QualityDoc (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
