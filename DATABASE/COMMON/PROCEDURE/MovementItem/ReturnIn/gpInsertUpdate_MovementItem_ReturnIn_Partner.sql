-- Function: gpInsertUpdate_MovementItem_ReturnIn_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn_Partner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
   OUT outAmountSummVat         TFloat    , -- ����� � ��� ���������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner());

    -- ���� � ���, % ��� 
     SELECT MB_PriceWithVAT.ValueData , MF_VATPercent.ValueData
    INTO vbPriceWithVAT, vbVATPercent
     FROM MovementBoolean AS MB_PriceWithVAT 
         LEFT JOIN MovementFloat AS MF_VATPercent
                                 ON MF_VATPercent.MovementId = MB_PriceWithVAT.MovementId
                                AND MF_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE MB_PriceWithVAT.MovementId = inMovementId 
       AND MB_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT();


     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId AND DescId = zc_MI_Master()), 0)
                                              , inAmountPartner      := inAmountPartner
                                              , inPrice              := inPrice
                                              , ioCountForPrice      := ioCountForPrice
                                              , inHeadCount          := inHeadCount
                                              , inMovementId_Partion := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_MovementId()), 0) :: Integer
                                              , inPartionGoods       := inPartionGoods
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , inUserId             := vbUserId
                                               ) AS tmp;

    outAmountSummVat:= CASE WHEN ioCountForPrice > 0
                            THEN CASE WHEN vbPriceWithVAT = TRUE THEN CAST(inPrice * inAmountPartner/ioCountForPrice AS NUMERIC (16, 2))
                                                                 ELSE CAST( (( (1 + vbVATPercent / 100)* inPrice) * inAmountPartner/ioCountForPrice) AS NUMERIC (16, 2)) 
                                 END
                            ELSE CASE WHEN vbPriceWithVAT = TRUE THEN CAST(inPrice * inAmountPartner AS NUMERIC (16, 2))
                                                                 ELSE CAST( (((1 + vbVATPercent / 100)* inPrice) * inAmountPartner) AS NUMERIC (16, 2) ) 
                                 END
                        END;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 05.11.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnIn_Partner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1 , inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
