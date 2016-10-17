-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPartionGoodsDate    TDateTime , -- ���� ������/���� �����������
    IN inPrice               TFloat    , -- ����
    IN inSumm                TFloat    , -- �����
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inPartionGoods        TVarChar  , -- ������ ������/����������� �����
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUnitId              Integer   , -- ������������� (��� ��)
    IN inStorageId           Integer   , -- ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := inAmount
                                                 , inPartionGoodsDate   := inPartionGoodsDate
                                                 , inPrice              := inPrice
                                                 , inSumm               := inSumm
                                                 , inHeadCount          := inHeadCount
                                                 , inCount              := inCount
                                                 , inPartionGoods       := inPartionGoods
                                                 , inGoodsKindId        := inGoodsKindId
                                                 , inGoodsKindCompleteId:= inGoodsKindCompleteId
                                                 , inAssetId            := inAssetId
                                                 , inUnitId             := inUnitId
                                                 , inStorageId          := inStorageId
                                                 , inUserId             := vbUserId
                                                  ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 25.04.05         * add lpInsertUpdate_MovementItem_Inventory
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
