-- Function: gpSetErased_Movement_Service (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Service(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Service());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.13                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Service (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
