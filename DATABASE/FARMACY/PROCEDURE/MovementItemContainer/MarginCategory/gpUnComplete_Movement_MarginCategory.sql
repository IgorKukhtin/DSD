-- Function: gpUnComplete_Movement_MarginCategory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_MarginCategory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_MarginCategory(
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
 21.11.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_MarginCategory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
