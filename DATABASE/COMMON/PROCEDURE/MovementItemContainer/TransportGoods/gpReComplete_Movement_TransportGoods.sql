-- Function: gpReComplete_Movement_TransportGoods(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_TransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_TransportGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TransportGoods());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_TransportGoods())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TransportGoods()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.03.15                                        *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_TransportGoods (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
