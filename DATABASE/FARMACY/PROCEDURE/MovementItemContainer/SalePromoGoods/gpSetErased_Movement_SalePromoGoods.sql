-- Function: gpSetErased_Movement_SalePromoGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SalePromoGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SalePromoGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_SalePromoGoods());
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
 07.09.22                                                       *
*/
