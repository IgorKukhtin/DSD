-- Function: gpInsertUpdate_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, TFloat, TFloat, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderExternal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountSecond        TFloat    , -- ���������� �������
    IN inGoodsKindId         Integer   , -- ���� �������
 INOUT ioPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
   OUT outMovementPromo      TVarChar  , -- 
   OUT outPricePromo         TFloat    , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Promo Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());


     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- ���������
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
          , zfCalc_PromoMovementName (tmp.outMovementId_Promo, NULL, NULL, NULL, NULL)
          , tmp.outPricePromo
            INTO ioId, ioPrice, ioCountForPrice, outAmountSumm, outMovementPromo, outPricePromo
     FROM lpInsertUpdate_MovementItem_OrderExternal (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := inAmount
                                                   , inAmountSecond       := inAmountSecond
                                                   , inGoodsKindId        := inGoodsKindId
                                                   , ioPrice              := ioPrice
                                                   , ioCountForPrice      := ioCountForPrice
                                                   , inUserId             := vbUserId
                                                    ) AS tmp;

     -- �������� ��-�� <�������� ����/����� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), ioId, vbOperDate_StartBegin);
     -- �������� ��-�� <�������� ����/����� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), ioId, CLOCK_TIMESTAMP());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.10.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderExternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
