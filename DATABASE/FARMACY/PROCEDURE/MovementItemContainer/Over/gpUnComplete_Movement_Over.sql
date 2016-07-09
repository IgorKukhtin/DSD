-- Function: gpUnComplete_Movement_Over (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Over (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Over(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; 

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.07.16         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Over (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
