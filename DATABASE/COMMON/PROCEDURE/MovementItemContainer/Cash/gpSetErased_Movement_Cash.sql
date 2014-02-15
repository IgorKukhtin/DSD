-- Function: gpSetErased_Movement_Cash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Cash(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Cash());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.12.13                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Cash (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
