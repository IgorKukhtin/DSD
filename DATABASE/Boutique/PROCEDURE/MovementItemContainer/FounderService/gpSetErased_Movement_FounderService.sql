-- Function: gpSetErased_Movement_FounderService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_FounderService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_FounderService(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_FounderService());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.09.14         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_FounderService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
