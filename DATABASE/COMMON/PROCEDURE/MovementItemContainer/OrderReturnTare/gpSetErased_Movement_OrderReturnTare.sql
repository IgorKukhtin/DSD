-- Function: gpSetErased_Movement_OrderReturnTare (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderReturnTare (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderReturnTare(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderReturnTare());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_OrderReturnTare (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
