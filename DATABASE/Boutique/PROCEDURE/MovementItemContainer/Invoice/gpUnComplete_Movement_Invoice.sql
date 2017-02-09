-- Function: gpUnComplete_Movement_Invoice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Invoice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Invoice());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.07.16         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Invoice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
