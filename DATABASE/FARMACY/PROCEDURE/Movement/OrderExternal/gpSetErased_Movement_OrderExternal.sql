-- Function: gpSetErased_Movement_BankStatement (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_BankStatement());

     vbUserId:= inSession::Integer;

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 14.10.14                          * 
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
