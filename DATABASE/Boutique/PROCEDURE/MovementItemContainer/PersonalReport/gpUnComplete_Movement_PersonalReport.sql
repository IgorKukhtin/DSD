-- Function: gpUnComplete_Movement_PersonalReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PersonalReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PersonalReport(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_PersonalReport());

     -- ��������
     PERFORM lpCheck_Movement_PersonalReport (inMovementId:= inMovementId, inComment:= '�����������', inUserId:= vbUserId);

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.09.14                                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_PersonalReport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
