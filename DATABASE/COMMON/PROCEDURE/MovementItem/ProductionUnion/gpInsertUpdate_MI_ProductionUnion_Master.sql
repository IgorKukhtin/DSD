-- Function: gpInsertUpdate_MI_ProductionUnion_Master()

-- DROP FUNCTION gpInsertUpdate_MI_ProductionUnion_Master();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPartionClose	     Boolean   , -- ������ ������� (��/���)        	
    IN inCount	             TFloat    , -- ���������� ������� ��� �������� 
    IN inRealWeight          TFloat    , -- ����������� ���(������������)
    IN inCuterCount          TFloat    , -- ���������� �������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inComment             TVarChar  , -- �����������	                   
    IN inGoodsKindId         Integer   , -- ���� ������� 
    IN inReceiptId           Integer   , -- ���������	                   
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
   vbUserId := inSession;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Receipt(), ioId, inReceiptId);
   
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   
   -- ��������� �������� <������ ������� (��/���)>
   PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_PartionClose(), ioId, inPartionClose);
   
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_PartionGoods(), ioId, inPartionGoods);

   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
   -- ��������� �������� <���������� ������� ��� ��������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount);
   -- ��������� �������� <����������� ���(������������)>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_CuterCount(), ioId, inCuterCount);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.07.13                                        * ����� ������� �����
 22.07.13         * add GoodsKind
 17.07.13         *              
 30.06.13                                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
