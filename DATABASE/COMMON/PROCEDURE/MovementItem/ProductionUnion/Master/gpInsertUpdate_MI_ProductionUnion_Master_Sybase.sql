-- Function: gpInsertUpdate_MI_ProductionUnion_Master_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master_Sybase (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master_Sybase (Integer, Integer, Integer, TFloat, Boolean , TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master_Sybase(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inIsPartionClose	     Boolean   , -- ������ ������� (��/���)
    IN inCount	             TFloat    , -- ���������� �������
    IN inRealWeight          TFloat    , -- ����������� ���(������������)
    IN inCuterCount          TFloat    , -- ���������� �������
    IN inPartionGoodsDate    TDateTime , -- ������ ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inComment             TVarChar  , -- ����������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inReceiptId           Integer   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());


   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioId, inReceiptId);

   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ����� � <���� ������� ��>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   -- ��������� �������� <������ ������� (��/���)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), ioId, inIsPartionClose);

   -- ������ ��������
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_PartionGoods(), ioId, inPartionGoods);

   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount);
   -- ��������� �������� <����������� ���(������������)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_CuterCount(), ioId, inCuterCount);

   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- ��������� ��������
   -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.03.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master_Sybase (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inIsPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
