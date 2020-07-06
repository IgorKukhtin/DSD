-- Function: gpUpdate_MI_PromoGoods_MainDiscount()

--DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_MainDiscount (Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_MainDiscount (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_MainDiscount(
    IN inMovementId           Integer   , -- ���� ������� <��������>
    IN inGoodsId              Integer   , -- ������
    IN inMainDiscount         TFloat    , -- ����� % ������
    IN inPriceSale            TFloat    , -- ���� �� �����
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Promo_MainDiscount());

    -- ����� ������ ���. 
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MainDiscount(), MovementItem.Id, inMainDiscount)  -- ����� % ������
          , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem.Id, COALESCE(inPriceSale,0))       -- ��������� <���� �� �����>
          , lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
    FROM MovementItem
    WHERE MovementItem.DescId = zc_MI_Master()
      AND MovementItem.MovementId = inMovementId
      AND MovementItem.ObjectId = inGoodsId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.20         *
*/