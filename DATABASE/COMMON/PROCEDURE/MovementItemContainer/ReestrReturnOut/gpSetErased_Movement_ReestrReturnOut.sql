-- Function: gpSetErased_Movement_ReestrReturnOut (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ReestrReturnOut (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ReestrReturnOut(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ReestrReturnOut());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.20         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ReestrReturnOut (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
