-- Function: gpSetErased_Movement_TransportGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_TransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_TransportGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_TransportGoods());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
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
-- SELECT * FROM gpSetErased_Movement_TransportGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
