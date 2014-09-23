-- Function: gpUnComplete_Movement_FounderService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_FounderService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_FounderService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_FounderService());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.09.14         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_FounderService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
