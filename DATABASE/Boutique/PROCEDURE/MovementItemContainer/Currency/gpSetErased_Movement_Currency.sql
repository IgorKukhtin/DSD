-- Function: gpSetErased_Movement_Currency (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Currency(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Currency());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.11.14                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Currency (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
