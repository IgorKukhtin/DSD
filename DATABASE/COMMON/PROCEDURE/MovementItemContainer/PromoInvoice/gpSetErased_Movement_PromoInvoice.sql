-- Function: gpSetErased_Movement_PromoInvoice (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PromoInvoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PromoInvoice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PromoInvoice());

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
-- SELECT * FROM gpSetErased_Movement_PromoInvoice (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
