-- Function: gpComplete_Movement_ReestrTransportGoods()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReestrTransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReestrTransportGoods(
    IN inMovementId        Integer                , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''      -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReestrTransportGoods());

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReestrTransportGoods()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.02.20         *
 */

-- ����
--