-- Function: gpInsertUpdate_MovementItem_SaleExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SaleExternal (Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SaleExternal(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    IN inAmount                 TFloat    , -- ����������
    IN inGoodsKindId            Integer   , -- ���� �������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleExternal());

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_SaleExternal (ioId           := ioId
                                                     , inMovementId   := inMovementId
                                                     , inGoodsId      := inGoodsId
                                                     , inAmount       := inAmount
                                                     , inGoodsKindId  := inGoodsKindId
                                                     , inUserId       := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SaleExternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1 , inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= zfCalc_UserAdmin())
