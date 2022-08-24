-- Function: gpSetErased_Movement_PersonalTransport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PersonalTransport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PersonalTransport(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PersonalTransport());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.22         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_PersonalTransport (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
