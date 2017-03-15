-- Function: gpUnComplete_Movement_ReestrReturn (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ReestrReturn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ReestrReturn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ReestrReturn());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.03.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ReestrReturn (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
