-- Function: lpInsertUpdate_MovementItem_Send_Value()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send_Value (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send_Value(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPartionGoodsDate    TDateTime , -- ���� ������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inPartionGoods        TVarChar  , -- ������ ������/����������� ����� 
    IN inPartNumber          TVarChar  , -- ��� �����
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inAssetId_two         Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUnitId              Integer   , -- ������������� (��� ��)
    IN inStorageId           Integer   , -- ����� ��������
    IN inPartionModelId      Integer   , -- ������
    IN inPartionGoodsId      Integer   , -- ������ ������� (��� ������ ������� ���� � ��)
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_MovementItem_Send (ioId                  := ioId
                                          , inMovementId          := inMovementId
                                          , inGoodsId             := inGoodsId
                                          , inAmount              := inAmount
                                          , inPartionGoodsDate    := inPartionGoodsDate
                                          , inCount               := inCount
                                          , inHeadCount           := inHeadCount
                                          , ioPartionGoods        := inPartionGoods
                                          , ioPartNumber          := inPartNumber
                                          , inGoodsKindId         := inGoodsKindId
                                          , inGoodsKindCompleteId := NULL
                                          , inAssetId             := inAssetId 
                                          , inAssetId_two         := inAssetId_two
                                          , inUnitId              := inUnitId
                                          , inStorageId           := inStorageId
                                          , inPartionModelId      := inPartionModelId
                                          , inPartionGoodsId      := inPartionGoodsId
                                          , inUserId              := inUserId
                                           ) AS tmp);

     -- ��������� ����� � <������������-2 (���������)>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset_two(), ioId, inAssetId_two);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Send_Value (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
