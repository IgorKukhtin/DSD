-- Function: gpSetErased_Movement_RouteMember (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_RouteMember (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_RouteMember(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_RouteMember());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.17         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_RouteMember (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
