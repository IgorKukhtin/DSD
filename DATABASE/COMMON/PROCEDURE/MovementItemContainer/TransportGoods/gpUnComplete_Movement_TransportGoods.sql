-- Function: gpUnComplete_Movement_TransportGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_TransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_TransportGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_TransportGoods());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.03.15                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_TransportGoods (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
