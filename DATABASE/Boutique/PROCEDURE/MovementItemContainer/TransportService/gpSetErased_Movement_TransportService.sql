-- Function: gpSetErased_Movement_TransportService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_TransportService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_TransportService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_TransportService());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.01.14                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_TransportService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
