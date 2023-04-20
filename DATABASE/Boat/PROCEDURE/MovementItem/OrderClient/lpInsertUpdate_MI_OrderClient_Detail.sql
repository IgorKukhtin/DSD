-- Function: lpInsertUpdate_MI_OrderClient_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderClient_Detail(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inObjectId            Integer   , -- ������������� / ������/������ / Boat Structure
    IN inGoodsId             Integer   , -- ������������� - ����
    IN inGoodsId_basis       Integer   , -- ������������� - �������������� ����
    IN inAmount              TFloat    , -- ���������� ��� ������ ����
    IN inAmountPartner       TFloat    , -- ���������� ����� ����������
    IN inForCount            TFloat    , -- ��� ���-��
    IN inOperPrice           TFloat    , -- ���� �� ��� ���
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inPartnerId           Integer   , -- ��������� - ���� ������ ����� ����������
    IN inProdOptionsId       Integer   , -- �����
    IN inColorPatternId      Integer   , -- ������ Boat Structure
    IN inProdColorPatternId  Integer   , -- Boat Structure
    IN inReceiptLevelId      Integer   , -- ReceiptLevel
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� - 
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                      ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                     -- ����� ���� ���������� 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                      ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                     -- ����� "�����������" ���� ���������� 
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                      ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                     -- ReceiptLevel
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                      ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Detail()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.ObjectId   = inObjectId
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
                  AND COALESCE (MILinkObject_ProdColorPattern.ObjectId, 0) = inProdColorPatternId
                  AND COALESCE (MILinkObject_Goods.ObjectId, 0)            = inGoodsId
                  AND COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)       = inGoodsId_basis
                  AND COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)     = inReceiptLevelId
               )
       AND 1=0
     THEN
         RAISE EXCEPTION '������.������� ������ ���� ��� ���������� %<%> %<%> %<%> %<%> %<%>.'
             , CHR (13)
             , lfGet_Object_ValueData (inObjectId)
             , CHR (13)
             , lfGet_Object_ValueData (inGoodsId)
             , CHR (13)
             , lfGet_Object_ValueData (inGoodsId_basis)
             , CHR (13)
             , lfGet_Object_ValueData (inReceiptLevelId)
             , CHR (13)
             , lfGet_Object_ValueData_pcp (inProdColorPatternId)
              ;
     END IF;
     

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inObjectId, NULL, inMovementId, inAmount, NULL, inUserId);

     -- ��������� �������� <��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ForCount(), ioId, CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END);
     -- ��������� �������� <AmountPartner>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <���� �� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ���.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     
     
     -- ��������� ����� � <������������� - ����� ���� ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� ����� � <������������� - ����� "�����������" ���� ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(), ioId, inGoodsId_basis);
     -- ��������� ����� � <���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptLevel(), ioId, inReceiptLevelId);

     
     -- ��������� ����� � <���������> - ���� ������ ����� ����������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdOptions(), ioId, inProdOptionsId);
     -- ��������� ����� � <������ Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ColorPattern(), ioId, inColorPatternId);
     -- ��������� ����� � <Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdColorPattern(), ioId, inProdColorPatternId);


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
