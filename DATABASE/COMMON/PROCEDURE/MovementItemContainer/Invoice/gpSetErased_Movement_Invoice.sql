-- Function: gpSetErased_Movement_Invoice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Invoice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Invoice());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.07.16         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Invoice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
