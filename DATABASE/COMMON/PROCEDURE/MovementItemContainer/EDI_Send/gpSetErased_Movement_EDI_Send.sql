-- Function: gpSetErased_Movement_EDI_Send (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_EDI_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_EDI_Send(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_EDI_Send());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.18         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_EDI_Send (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
