-- Function: gpUnComplete_Movement_OrderInternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderInternal(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_OrderInternal());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.07.14                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_OrderInternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
