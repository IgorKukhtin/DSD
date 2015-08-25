-- Function: lpInsertUpdate_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, TFloat, TFloat, TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_Child(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId           Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId              Integer   , -- ������
    IN inAmount               TFloat    , -- ����������
    IN inContainerId          TFloat    , -- 
    IN inPartionGoodsDate     TDateTime , -- ������ ������	
    IN inGoodsKindId          Integer   , -- ���� �������
    IN inGoodsKindId_complete Integer   , -- ���� �������
    IN inUserId               Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, NULL);
  
   -- ��������� �������� <ContainerId>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
   
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindId_complete);

   -- ��������� ��������
   -- !!!��� � �� ����� ����!!! PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.06.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_OrderInternal_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
