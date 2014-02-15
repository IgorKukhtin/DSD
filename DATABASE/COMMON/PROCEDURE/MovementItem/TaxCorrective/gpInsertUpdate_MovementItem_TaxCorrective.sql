-- Function: gpInsertUpdate_MovementItem_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxCorrective (integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TaxCorrective(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
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
--     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());

     -- �������� - ��������� ������� ��������� �� ����� ����������������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND isErased = TRUE)
     THEN
         RAISE EXCEPTION '������.������� �� ����� ���������������� �.�. �� <������>.';
     END IF;

     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_TaxCorrective (ioId        := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inPrice              := inPrice
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
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_TaxCorrective (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')
