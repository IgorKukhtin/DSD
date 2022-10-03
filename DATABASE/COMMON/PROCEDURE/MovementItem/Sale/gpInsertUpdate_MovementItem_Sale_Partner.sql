-- Function: gpInsertUpdate_MovementItem_Sale_Partner()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale_Partner(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
 INOUT ioPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ��������� 
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inBoxCount            TFloat    , -- ���������� ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inBoxId               Integer   , -- ����� 
   OUT outGoodsRealCode      Integer  , -- ����� (���� ��������)
   OUT outGoodsRealName      TVarChar  , -- ����� (���� ��������)
   OUT outGoodsKindRealName  TVarChar  , -- ��� ������ (���� ��������)
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
         IF NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_CurrencyDocument() AND ObjectId <> zc_Enum_Currency_Basis())
        AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_CurrencyPartner() AND ObjectId <> zc_Enum_Currency_Basis())
        AND NOT EXISTS (SELECT MovementItem.Id
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
                          AND (COALESCE (MIFloat_Price.ValueData, 0) = COALESCE (ioPrice, 0)
                            OR vbUserId = 12120 -- ��������� �.�. !!!��������!!!
                              )
                       )
         THEN
             RAISE EXCEPTION '������.��� ���� �������������� <�������>.';
         END IF;
     END IF;

     -- ���������
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
          , tmp.outGoodsRealCode, tmp.outGoodsRealName, tmp.outGoodsKindRealName
            INTO ioId, ioCountForPrice, outAmountSumm
               , outGoodsRealCode, outGoodsRealName, outGoodsKindRealName
     FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId AND DescId = zc_MI_Master()), 0)
                                          , inAmountPartner      := inAmountPartner
                                          , inAmountChangePercent:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountChangePercent()), 0)
                                          , inChangePercentAmount:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_ChangePercentAmount()), 0)
                                          , ioPrice              := ioPrice
                                          , ioCountForPrice      := ioCountForPrice
                                          , inCount              := inCount
                                          , inHeadCount          := inHeadCount
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          , inCountPack          := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_CountPack()), 0)
                                          , inWeightTotal        := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_WeightTotal()), 0)
                                          , inWeightPack         := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_WeightPack()), 0)
                                          , inIsBarCode          := COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE MovementItemId = ioId AND DescId = zc_MIBoolean_BarCode()), FALSE)
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.22         * inCount
 10.10.14                                                       * add box
 19.05.14                                        * add COALESCE
 19.05.14                                        * add COALESCE
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
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale_Partner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, ioPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
