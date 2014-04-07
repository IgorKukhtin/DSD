-- Function: gpInsertUpdate_MovementItem_Sale_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale_Partner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale_Partner());

     -- ��������, �.�. ��� ��������� ������ ������
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND Amount <> 0 AND isErased = FALSE)
     THEN
         IF NOT EXISTS (SELECT MovementItem.Id
                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                        WHERE MovementItem.Id = ioId
                          AND MovementItem.ObjectId = inGoodsId
                          AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                          AND COALESCE (MIFloat_Price.ValueData, 0) = COALESCE (inPrice, 0)
                       )
         THEN
             RAISE EXCEPTION '������.��� ���� �������������� <�������>.';
         END IF;
     END IF;

     -- ���������
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := (SELECT Amount FROM MovementItem WHERE Id = ioId AND DescId = zc_MI_Master())
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= (SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountChangePercent())
                                          , inChangePercentAmount:= (SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_ChangePercentAmount())
                                          , inPrice              := inPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inHeadCount          := inHeadCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

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
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale_Partner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
