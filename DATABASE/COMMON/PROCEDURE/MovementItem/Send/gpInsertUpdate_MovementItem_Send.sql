-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
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
    IN inAssetId               Integer   , -- �������� �������� 1(��� ������� ���������� ���)
    IN inAssetId_two           Integer   , -- �������� �������� 2(��� ������� ���������� ���)
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     -- ���������
     SELECT tmp.ioId, tmp.ioPartionGoods
            INTO ioId, ioPartionGoods
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
                                          , inAssetId_two         := inAssetId_two
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
 18.10.22         * asset_two
 02.08.17         * add inGoodsKindCompleteId
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
