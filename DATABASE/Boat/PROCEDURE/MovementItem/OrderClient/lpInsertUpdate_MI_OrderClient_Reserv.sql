-- Function: lpInsertUpdate_MI_OrderClient_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Reserv (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Reserv(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , -- 
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPartionId           Integer   , -- ������
    IN inObjectId            Integer   , -- �������������
    IN inAmount              TFloat    , -- ���������� ������
    IN inOperPrice           TFloat    , -- ���� �� ��� ���
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inUnitId              Integer   , -- ������������� - �� ������� ���������� ������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- �������� - ParentId
     IF COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������� �������>.';
     END IF;
     -- �������� - PartionId
     IF COALESCE (inPartionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������>.';
     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Reserv(), inObjectId, inPartionId, inMovementId, inAmount, inParentId, inUserId);

     -- ��������� �������� <���� �� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ���.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     -- ��������� ����� � <�������������> - �� ������� ���������� ������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.04.21         *
 05.04.21         * inOperPriceList
 15.02.21         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MI_OrderClient_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inGoodsName = '', inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
