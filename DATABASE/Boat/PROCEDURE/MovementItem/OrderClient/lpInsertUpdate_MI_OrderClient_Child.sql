-- Function: lpInsertUpdate_MI_OrderClient_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , -- 
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPartionId           Integer   , -- ������������� / ������/������
    IN inObjectId            Integer   , -- ������������� / ������/������
    IN inGoodsId_Basis       Integer   , -- ������������� - ����� ���� ����������
    IN inGoodsId             Integer   , -- ������������� - ���� ���� ������, ����� ���� ��� � ReceiptProdModel
    IN inAmountBasis         TFloat    , -- ���������� 
    IN inAmount              TFloat    , -- ���������� ������
    IN inAmountPartner       TFloat    , -- ���������� ����� ����������
    IN inOperPrice           TFloat    , -- ���� �� ��� ���
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inUnitId              Integer   , -- ������������� - �� ������� ���������� ������
    IN inPartnerId           Integer   , -- ��������� - ���� ������ ����� ����������
    IN inColorPatternId      Integer   , -- ������ Boat Structure
    IN inProdColorPatternId  Integer   , -- Boat Structure
    IN inProdOptionsId       Integer   , -- �����
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, inPartionId, inMovementId, inAmount, inParentId, inUserId);

     -- ��������� �������� <AmountBasis>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountBasis(), ioId, inAmountBasis);
     -- ��������� �������� <AmountPartner>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <���� �� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ���.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     
     -- ��������� ����� � <�������������> - ����� ���� ����������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� ����� � <�������������> - ���� ���� ������, ����� ���� ��� � ReceiptProdModel
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(), ioId, inGoodsId_Basis);
     -- ��������� ����� � <�������������> - �� ������� ���������� ������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <���������> - ���� ������ ����� ����������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
     -- ��������� ����� � <������ Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ColorPattern(), ioId, inColorPatternId);
     -- ��������� ����� � <Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdColorPattern(), ioId, inProdColorPatternId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdOptions(), ioId, inProdOptionsId);

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
