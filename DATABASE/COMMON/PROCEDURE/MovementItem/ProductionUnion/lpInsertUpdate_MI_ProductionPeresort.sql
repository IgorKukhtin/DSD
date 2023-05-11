-- Function: lpInsertUpdate_MI_ProductionPeresort

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionPeresort(
    INOUT ioId Integer,
    IN inMovementId Integer,
    IN inGoodsId Integer,
    IN inGoodsId_child Integer,
    IN inGoodsKindId Integer,
    IN inGoodsKindId_Complete   Integer   , -- ���� �������
    IN inGoodsKindId_child Integer,
    IN inGoodsKindId_Complete_child  Integer   , -- ���� �������
    IN inAmount TFloat,
    IN inAmount_child TFloat,
    IN inPartionGoods TVarChar,
    IN inPartionGoods_child TVarChar,
    IN inPartionGoodsDate TDateTime,
    IN inPartionGoodsDate_child TDateTime, 
    IN inStorageId              Integer   , -- ����� ��������
    IN inStorageId_child        Integer   , -- ����� ��������
    IN inPartNumber             TVarChar  , -- � �� ��� ��������
    IN inPartNumber_child       TVarChar  , -- � �� ��� ��������
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId_child Integer;
BEGIN
   -- �����
   IF COALESCE (ioId, 0) <> 0
   THEN
      vbId_child := (SELECT Id FROM MovementItem WHERE MovementId = inMovementId AND ParentId = ioId AND DescId = zc_MI_Child() AND isErased = FALSE);
   END IF;

   -- ��������� <Master>
   ioId:= lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inCount            := 0
                                                  , inCuterWeight      := 0
                                                  , inPartionGoodsDate := inPartionGoodsDate
                                                  , inPartionGoods     := inPartionGoods
                                                  , inPartNumber       := inPartNumber
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inGoodsKindId_Complete := inGoodsKindId_Complete
                                                  , inStorageId        := inStorageId
                                                  , inUserId           := inUserId
                                                   );

   -- ��������� <Child>
   PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId               := vbId_child
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId_child
                                                  , inAmount           := inAmount_child
                                                  , inParentId         := ioId
                                                  , inPartionGoodsDate := inPartionGoodsDate_child
                                                  , inPartionGoods     := inPartionGoods_child
                                                  , inPartNumber       := inPartNumber_child
                                                  , inGoodsKindId      := inGoodsKindId_child
                                                  , inGoodsKindCompleteId := inGoodsKindId_Complete_child
                                                  , inStorageId        := inStorageId_child
                                                  , inCount_onCount    := 0
                                                  , inUserId           := inUserId
                                                   );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.05.23         *
 17.07.15                                        * all
 29.06.15         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
