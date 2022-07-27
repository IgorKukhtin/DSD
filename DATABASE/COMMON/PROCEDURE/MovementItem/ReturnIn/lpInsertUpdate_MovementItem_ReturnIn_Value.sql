-- Function: lpInsertUpdate_MovementItem_ReturnIn_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn_Value(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inMovementId_Promo    Integer   , -- 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��������� <������� ���������>
     SELECT tmp.ioId INTO ioId
     FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := inAmount
                                              , inAmountPartner      := inAmountPartner
                                              , ioPrice              := inPrice
                                              , ioCountForPrice      := inCountForPrice
                                              , inCount              := inCount
                                              , inHeadCount          := inHeadCount
                                              , inMovementId_Partion := COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_MovementId()), 0) :: Integer
                                              , inPartionGoods       := inPartionGoods
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , ioMovementId_Promo   := inMovementId_Promo
                                              , ioChangePercent      := inChangePercent
                                              , inIsCheckPrice       := TRUE
                                              , inUserId             := inUserId
                                               ) AS tmp;

     -- !!!���� �����!!! - ��� ��� ��������� �������� <(-)% ������ (+)% �������> + �� ������ ������ SELECT ...
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, CASE WHEN inMovementId_Promo > 0 THEN COALESCE (inChangePercent, 0) ELSE COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0) END);
     -- !!!���� �����!!! - ��������� �������� <MovementId-�����>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (inMovementId_Promo, 0));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 04.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
