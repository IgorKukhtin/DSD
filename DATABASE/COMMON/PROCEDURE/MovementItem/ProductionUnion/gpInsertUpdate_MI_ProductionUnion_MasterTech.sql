-- Function: gpInsertUpdate_MI_ProductionUnion_MasterTech()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_MasterTech  (Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_MasterTech(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
--    IN inMovementId          Integer   , -- ���� ������� <��������>
--    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
--    IN inPartionClose	     Boolean   , -- ������ ������� (��/���)
    IN inCount	             TFloat    , -- ���������� ������� ��� ��������
    IN inRealWeight          TFloat    , -- ����������� ���(������������)
    IN inCuterCount          TFloat    , -- ���������� �������
--    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inComment             TVarChar  , -- �����������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inReceiptId           Integer   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   vbMovementId = COALESCE ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = ioId), 0);
   vbOperDate   = COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId), inOperDate);
      -- ��������� <��������>
   vbMovementId := lpInsertUpdate_Movement (ioId               := vbMovementId
                                          , inDescid           := zc_Movement_ProductionUnion()
                                          , inInvNumber        := inInvNumber
                                          , inOperDate         := vbOperDate
                                          , inParentId         := NULL);

   -- ��������� ����� � <�� ���� (� ���������)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
   -- ��������� ����� � <���� (� ���������)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);
   -- ��������� ��������
   -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);


   -- ��������� <������� ���������>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := vbMovementId--inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inPartionClose     := COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE MovementItemId = ioId AND DescId = zc_MIBoolean_PartionClose()), 0)--inPartionClose
                                                  , inCount            := inCount
                                                  , inRealWeight       := inRealWeight
                                                  , inCuterCount       := inCuterCount
                                                  , inPartionGoods     := COALESCE ((SELECT ValueData FROM MovementItemString WHERE MovementItemId = ioId AND DescId = zc_MIString_PartionGoods()), 0)--inPartionGoods
                                                  , inComment          := inComment
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inReceiptId        := inReceiptId
                                                  , inUserId           := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.12.14                                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_MasterTech (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')