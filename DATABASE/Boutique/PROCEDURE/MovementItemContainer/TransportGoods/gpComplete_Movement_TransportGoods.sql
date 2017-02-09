-- Function: gpComplete_Movement_TransportGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_TransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TransportGoods(
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

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TransportGoods()
                                , inUserId     := vbUserId
                                 );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.03.15                                        *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_TransportGoods (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
