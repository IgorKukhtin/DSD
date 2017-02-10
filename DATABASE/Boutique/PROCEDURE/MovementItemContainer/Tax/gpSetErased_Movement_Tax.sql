-- Function: gpSetErased_Movement_Tax (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Tax (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Tax(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Tax());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Tax (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
