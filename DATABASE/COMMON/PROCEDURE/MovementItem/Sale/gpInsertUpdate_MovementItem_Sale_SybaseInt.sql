-- Function: gpInsertUpdate_MovementItem_Sale_SybaseInt()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_SybaseInt (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale_SybaseInt(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inIsOnlyUpdateInt     Boolean   , -- !!!!!!
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN
     IF inIsOnlyUpdateInt = TRUE
     THEN
          -- ��������� <������� ���������>
          SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
                 INTO ioId, ioCountForPrice, outAmountSumm
          FROM gpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                               , inMovementId         := inMovementId
                                               , inGoodsId            := inGoodsId
                                               , inAmount             := inAmount
                                               , inAmountPartner      := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountPartner()), 0)
                                               , inAmountChangePercent:= inAmountChangePercent
                                               , inChangePercentAmount:= inChangePercentAmount
                                               , inPrice              := inPrice
                                               , ioCountForPrice      := ioCountForPrice
                                               , inHeadCount          := inHeadCount
                                               , inBoxCount           := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_BoxCount()), 0)
                                               , inPartionGoods       := inPartionGoods
                                               , inGoodsKindId        := inGoodsKindId
                                               , inAssetId            := inAssetId
                                               , inBoxId              := COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioId AND DescId = zc_MILinkObject_Box()), 0)
                                               , inSession            := inSession
                                                ) AS tmp;
     ELSE
          -- ��������� <������� ���������>
          SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
                 INTO ioId, ioCountForPrice, outAmountSumm
          FROM gpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                               , inMovementId         := inMovementId
                                               , inGoodsId            := inGoodsId
                                               , inAmount             := inAmount
                                               , inAmountPartner      := inAmountPartner
                                               , inAmountChangePercent:= inAmountChangePercent
                                               , inChangePercentAmount:= inChangePercentAmount
                                               , inPrice              := inPrice
                                               , ioCountForPrice      := ioCountForPrice
                                               , inHeadCount          := inHeadCount
                                               , inBoxCount           := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_BoxCount()), 0)
                                               , inPartionGoods       := inPartionGoods
                                               , inGoodsKindId        := inGoodsKindId
                                               , inAssetId            := inAssetId
                                               , inBoxId              := COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioId AND DescId = zc_MILinkObject_Box()), 0)
                                               , inSession            := inSession
                                                ) AS tmp;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.02.14                                        * ���� ������ � lpInsertUpdate_MovementItem_Sale
 04.02.14                        * add lpInsertUpdate_MovementItem_Sale
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 02.09.13                                        * add zc_MIFloat_ChangePercentAmount
 13.08.13                                        * add RAISE EXCEPTION
 09.07.13                                        * add IF inGoodsId <> 0
 18.07.13         * add inAssetId
 13.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale_SybaseInt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
