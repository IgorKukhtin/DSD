-- Function: gpSetErased_Movement_SaleExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SaleExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SaleExternal(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_SaleExternal());

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
-- SELECT * FROM gpSetErased_Movement_SaleExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
