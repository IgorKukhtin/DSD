-- Function: gpUnComplete_Movement_Reestr (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Reestr (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Reestr(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Reestr());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.16         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Reestr (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
