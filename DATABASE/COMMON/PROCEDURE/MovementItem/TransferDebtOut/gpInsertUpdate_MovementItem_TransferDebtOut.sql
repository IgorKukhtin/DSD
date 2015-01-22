-- Function: gpInsertUpdate_MovementItem_TransferDebtOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TransferDebtOut (integer, integer, integer, tfloat, tfloat, tfloat, integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TransferDebtOut (integer, integer, integer, tfloat, tfloat, tfloat, tfloat, integer, integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TransferDebtOut(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inBoxCount            TFloat    , -- ���������� ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inBoxId               Integer   , -- �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TransferDebtOut());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_TransferDebtOut (ioId      := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inBoxCount           := inBoxCount
                                          , inGoodsKindId        := inGoodsKindId
                                          , inBoxId              := inBoxId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.01.15         * add inBoxCount, inBoxId
 22.04.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_TransferDebtOut (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')