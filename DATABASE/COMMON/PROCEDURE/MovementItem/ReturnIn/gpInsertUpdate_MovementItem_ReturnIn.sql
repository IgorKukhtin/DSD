-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, Boolean, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId                Integer   , -- ������
    IN inAmount                 TFloat    , -- ����������
 INOUT ioAmountPartner          TFloat    , -- ���������� � �����������
    IN inIsCalcAmountPartner    Boolean   , -- ������� - ����� �� ���������� <���������� � �����������>
    IN inPrice                  TFloat    , -- ����
 INOUT ioCountForPrice          TFloat    , -- ���� �� ����������
   OUT outAmountSumm            TFloat    , -- ����� ���������
    IN inHeadCount              TFloat    , -- ���������� �����
    IN inPartionGoods           TVarChar  , -- ������ ������
    IN inGoodsKindId            Integer   , -- ���� �������
    IN inAssetId                Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     -- !!!�������� ��������!!! - ���������� � �����������
     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner:= inAmount;
     END IF;


     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := inAmount
                                              , inAmountPartner      := ioAmountPartner
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
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 14.02.14                                                         * fix lpInsertUpdate_MovementItem_ReturnIn
 13.02.14                        * lpInsertUpdate_MovementItem_ReturnIn
 28.01.14                                                          * add outAmountSumm
 13.01.14                                        * add RAISE EXCEPTION
 18.07.13         * add inAssetId
 17.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnIn (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1 , inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
