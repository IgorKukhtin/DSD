-- Function: gpInsertUpdate_MovementItem_Send()
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendMember (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendMember (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendMember(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- ����������
    IN inPartionGoodsDate      TDateTime , -- ���� ������
    IN inCount                 TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount             TFloat    , -- ���������� �����
 INOUT ioPartionGoods          TVarChar  , -- ������ ������/����������� �����
 INOUT ioPartNumber            TVarChar  , -- � �� ��� ��������
    IN inGoodsKindId           Integer   , -- ���� �������
    IN inGoodsKindCompleteId   Integer   , -- ���� �������  ��
    IN inAssetId               Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUnitId                Integer   , -- ������������� (��� ��)
    IN inStorageId             Integer   , -- ����� ��������
    IN inPartionModelId        Integer   , -- ������
    IN inPartionGoodsId        Integer   , -- ������ ������� (��� ������ ������� ���� � ��)
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendMember());

     -- ���������
     SELECT tmp.ioId, tmp.ioPartionGoods , tmp.ioPartNumber
            INTO ioId, ioPartionGoods, ioPartNumber
     FROM lpInsertUpdate_MovementItem_Send (ioId                  := ioId
                                          , inMovementId          := inMovementId
                                          , inGoodsId             := inGoodsId
                                          , inAmount              := inAmount
                                          , inPartionGoodsDate    := inPartionGoodsDate
                                          , inCount               := inCount
                                          , inHeadCount           := inHeadCount
                                          , ioPartionGoods        := ioPartionGoods
                                          , ioPartNumber          := ioPartNumber
                                          , inGoodsKindId         := inGoodsKindId
                                          , inGoodsKindCompleteId := inGoodsKindCompleteId
                                          , inAssetId             := inAssetId 
                                          , inAssetId_two         := Null
                                          , inUnitId              := inUnitId
                                          , inStorageId           := inStorageId 
                                          , inPartionModelId      := inPartionModelId
                                          , inPartionGoodsId      := inPartionGoodsId
                                          , inUserId              := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.11.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SendMember (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
