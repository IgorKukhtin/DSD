-- Function: gpSetErased_Movement_WagesVIP (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_WagesVIP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_WagesVIP(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WagesVIP());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.09.21                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_WagesVIP (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
