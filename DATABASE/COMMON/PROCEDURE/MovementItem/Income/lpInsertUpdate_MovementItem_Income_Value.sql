-- Function: lpInsertUpdate_MovementItem_Income_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income_Value (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income_Value (
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountPartnerSecond TFloat    , -- ���������� � �����������
    IN inAmountPacker        TFloat    , -- ���������� � ������������
    IN inPrice               TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ����������
    IN inPricePartner        TFloat    , -- ���� � �����������
    IN inLiveWeight          TFloat    , -- ����� ���
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������ 
    IN inPartNumber          TVarChar  , -- � �� ��� �������� 
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���) 
    IN inStorageId           Integer   , -- ����� ��������
    IN inUserId              Integer     -- ������������
   )
RETURNS Integer
AS
$BODY$
BEGIN

     --
     ioId:= lpInsertUpdate_MovementItem_Income (ioId                  := ioId
                                              , inMovementId          := inMovementId
                                              , inGoodsId             := inGoodsId
                                              , inAmount              := inAmount
                                              , inAmountPartner       := inAmountPartner
                                              , inAmountPacker        := inAmountPacker
                                              , inPrice               := inPrice
                                              , inCountForPrice       := inCountForPrice
                                              , inLiveWeight          := inLiveWeight
                                              , inHeadCount           := inHeadCount
                                              , inPartionGoods        := inPartionGoods
                                              , inPartNumber          := inPartNumber
                                              , inGoodsKindId         := inGoodsKindId
                                              , inAssetId             := inAssetId
                                              , inStorageId           := inStorageId
                                              , inUserId              := inUserId
                                               );

     -- ��������� �������� <���� ���������� ��� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), ioId, inAmountPartnerSecond);

     -- ��������� �������� <���� ���������� ��� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), ioId, inPricePartner);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.10.24                                        *
*/

-- ����
-- 
