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
  DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     IF                (EXISTS (SELECT ValueData FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Checked() AND ValueData = TRUE)
                    OR EXISTS (SELECT MovementLinkMovement.MovementId
                               FROM MovementLinkMovement
                                    INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    INNER JOIN MovementBoolean AS MovementBoolean_Medoc
                                                               ON MovementBoolean_Medoc.MovementId = MovementLinkMovement.MovementChildId
                                                              AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()
                                                              AND MovementBoolean_Medoc.ValueData = TRUE
                               WHERE MovementLinkMovement.MovementId = inMovementId
                                 AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                    OR EXISTS (SELECT MovementLinkMovement.MovementId
                               FROM MovementLinkMovement
                                    INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementChildId
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    INNER JOIN MovementBoolean AS MovementBoolean_Electron
                                                               ON MovementBoolean_Electron.MovementId = MovementLinkMovement.MovementChildId
                                                              AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
                                                              AND MovementBoolean_Electron.ValueData = TRUE
                               WHERE MovementLinkMovement.MovementId = inMovementId
                                 AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master())
                      )
     THEN
          IF ioId <> 0 OR 1=1
          THEN
          -- ��������� <������� ���������>
          SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
                 INTO ioId, ioCountForPrice, outAmountSumm
          FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                               , inMovementId         := inMovementId
                                               , inGoodsId            := CASE WHEN COALESCE (ioId, 0) = 0 THEN inGoodsId ELSE (SELECT ObjectId FROM MovementItem WHERE Id = ioId) END
                                               , inAmount             := inAmount
                                               , inAmountPartner      := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountPartner()), 0)
                                               , inAmountChangePercent:= inAmountChangePercent
                                               , inChangePercentAmount:= inChangePercentAmount
                                               , inPrice              := CASE WHEN COALESCE (ioId, 0) = 0 THEN inPrice ELSE COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_Price()), 0) END
                                               , ioCountForPrice      := CASE WHEN COALESCE (ioId, 0) = 0 THEN ioCountForPrice ELSE COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_CountForPrice()), 0) END
                                               , inHeadCount          := inHeadCount
                                               , inBoxCount           := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_BoxCount()), 0)
                                               , inPartionGoods       := inPartionGoods
                                               , inGoodsKindId        := COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioId AND DescId = zc_MILinkObject_GoodsKind()), 0)
                                               , inAssetId            := inAssetId
                                               , inBoxId              := COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioId AND DescId = zc_MILinkObject_Box()), 0)
                                               , inUserId             := vbUserId
                                                ) AS tmp;
          ELSE
              RAISE EXCEPTION '������. ��������� � <�����> ��� �������� <��������>.';
          END IF;

     ELSE
     IF inIsOnlyUpdateInt = TRUE
     THEN
          -- ��������� <������� ���������>
          SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
                 INTO ioId, ioCountForPrice, outAmountSumm
          FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
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
                                               , inUserId             := vbUserId
                                                ) AS tmp;
     ELSE
          -- ��������� <������� ���������>
          SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
                 INTO ioId, ioCountForPrice, outAmountSumm
          FROM lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
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
                                               , inUserId             := vbUserId
                                                ) AS tmp;
     END IF;
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
