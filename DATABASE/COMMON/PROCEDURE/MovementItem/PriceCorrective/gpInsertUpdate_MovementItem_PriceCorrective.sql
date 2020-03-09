-- Function: gpInsertUpdate_MovementItem_PriceCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceCorrective (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceCorrective (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PriceCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ���� -  �� ������� ��������������("+"����������� ��� "-"�������������) 
    IN inPriceTax_calc       TFloat    , -- ���� ������� (����.) - ������������, ������� ��������������
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PriceCorrective());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_PriceCorrective (ioId      := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inPrice              := inPrice
                                          , inPriceTax_calc      := inPriceTax_calc
                                          , ioCountForPrice      := ioCountForPrice
                                          , inGoodsKindId        := inGoodsKindId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.05.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PriceCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')
