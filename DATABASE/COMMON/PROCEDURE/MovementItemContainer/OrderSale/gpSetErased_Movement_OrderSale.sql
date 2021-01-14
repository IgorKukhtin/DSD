-- Function: gpSetErased_Movement_OrderSale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderSale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderSale());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.21         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_OrderSale (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
