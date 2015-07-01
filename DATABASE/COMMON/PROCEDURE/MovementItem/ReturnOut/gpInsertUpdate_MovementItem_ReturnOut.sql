-- Function: gpInsertUpdate_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����������
 INOUT ioAmountPartner       TFloat    , -- ���������� � �����������
    IN inIsCalcAmountPartner Boolean   , -- ������� - ����� �� ��������� <���������� � �����������>
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());


     -- !!!�������� ��������!!!
     IF inIsCalcAmountPartner = TRUE OR 1 = 1 -- �������� OR...
     THEN ioAmountPartner:= ioAmount;
     END IF;

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_ReturnOut (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := ioAmount
                                                 , inAmountPartner      := ioAmountPartner
                                                 , inPrice              := inPrice
                                                 , inCountForPrice      := ioCountForPrice
                                                 , inHeadCount          := inHeadCount
                                                 , inPartionGoods       := inPartionGoods
                                                 , inGoodsKindId        := inGoodsKindId
                                                 , inAssetId            := inAssetId
                                                 , inUserId             := vbUserId
                                                  );

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmountPartner * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmountPartner * inPrice AS NUMERIC (16, 2))
                      END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.06.15                                        * add inIsCalcAmountPartner
 29.05.15                                        *
*/


-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnOut (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
