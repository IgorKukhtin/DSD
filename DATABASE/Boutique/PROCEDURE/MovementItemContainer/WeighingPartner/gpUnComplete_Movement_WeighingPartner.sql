-- Function: gpUnComplete_Movement_WeighingPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_WeighingPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_WeighingPartner(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_WeighingPartner());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.05.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_WeighingPartner (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
