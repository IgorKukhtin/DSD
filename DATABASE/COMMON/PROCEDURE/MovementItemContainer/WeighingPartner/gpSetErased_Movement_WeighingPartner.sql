-- Function: gpSetErased_Movement_WeighingPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_WeighingPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_WeighingPartner(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_WeighingPartner());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.05.15                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_WeighingPartner (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
