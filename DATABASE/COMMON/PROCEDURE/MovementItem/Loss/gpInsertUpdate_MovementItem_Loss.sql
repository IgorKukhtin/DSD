-- Function: gpInsertUpdate_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, TFloat, TFloat,TFloat, TDateTime, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loss(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoodsDate    TDateTime , -- ���� ������/���� �����������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Loss());

     -- ���������
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_Loss (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := inAmount
                                          , inCount              := inCount
                                          , inHeadCount          := inHeadCount
                                          , inPartionGoodsDate   := inPartionGoodsDate
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.09.14                                        * add lpInsertUpdate_MovementItem_Loss
 01.09.14                                                       * + PartionGoodsDate
 26.05.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Loss (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
