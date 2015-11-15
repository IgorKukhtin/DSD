-- Function: lpInsertUpdate_MovementItem_Sale_Value()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale_Value(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
    IN inPrice               TFloat    , -- ����
    IN ioCountForPrice       TFloat    , -- ���� �� ����������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inBoxCount            TFloat    , -- ���������� ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inBoxId               Integer   , -- �����
    IN inCountPack           TFloat    , -- ���������� �������� (������)
    IN inWeightTotal         TFloat    , -- ��� 1 ��. ��������� + ��������
    IN inWeightPack          TFloat    , -- ��� �������� ��� 1-�� ��. ���������
    IN inIsBarCode           Boolean   , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ���������
     SELECT tmp.ioId INTO ioId
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
                                          , inBoxCount           := inBoxCount
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := inGoodsKindId
                                          , inAssetId            := inAssetId
                                          , inBoxId              := inBoxId
                                          , inCountPack          := inCountPack
                                          , inWeightTotal        := inWeightTotal
                                          , inWeightPack         := inWeightPack
                                          , inIsBarCode          := inIsBarCode
                                          , inUserId             := inUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.11.15                                        *
 04.02.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Sale_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
