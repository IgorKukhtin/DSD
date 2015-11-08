-- Function: lpInsertUpdate_MI_ProductionUnionTech_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Child (Integer, Integer, Integer, TFloat, Integer, TFloat, TDateTime, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnionTech_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inAmountReceipt       TFloat    , -- ���������� �� ��������� �� 1 ����� 
    IN inPartionGoodsDate    TDateTime , -- ������ ������
    IN inComment             TVarChar  , -- ����������
    IN inGoodsKindId         Integer   , -- ���� �������  
    IN inGoodsKindCompleteId Integer   , -- ���� ������� ��           
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;

BEGIN
   -- ������ ��������
   IF (inPartionGoodsDate <= '01.01.1900') OR COALESCE (inGoodsKindId, 0) <> zc_GoodsKind_WorkProgress() THEN inPartionGoodsDate:= NULL; END IF;

   -- ��������
   IF COALESCE (inGoodsId, 0) = 0 
   THEN
       RAISE EXCEPTION '������.�������� <�������� (������)> �� �����������.';
   END IF;

   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
   -- ��������� �������� <���������� �� ��������� �� 1 �����>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReceipt(), ioId, inAmountReceipt);
   
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ����� � <���� ������� ��>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   IF vbIsInsert = TRUE
   THEN
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   ELSE
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
   END IF;


   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.03.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnionTech_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
