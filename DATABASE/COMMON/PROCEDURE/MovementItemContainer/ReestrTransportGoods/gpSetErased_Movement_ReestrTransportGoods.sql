-- Function: gpSetErased_Movement_ReestrTransportGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ReestrTransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ReestrTransportGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ReestrTransportGoods());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.02.20         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ReestrTransportGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
