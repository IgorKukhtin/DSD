-- Function: gpUnComplete_Movement_SalePromoGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SalePromoGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SalePromoGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_SalePromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.22                                                       *
*/