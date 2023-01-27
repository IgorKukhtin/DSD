-- Function: lpInsertUpdate_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternal_Child(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inObjectId               Integer   , -- ������������� 
    IN inReceiptLevelId         Integer   , -- ���� ������
    IN inColorPatternId         Integer   , -- ������ Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- �����
    IN inUnitId                 Integer   , -- ����� �����
    IN inAmount                 TFloat    , -- ���������� (������ ������)
    IN inAmountReserv           TFloat    , -- ���������� ������
    IN inAmountSend             TFloat    , -- ���-�� ������ �� �������./�����������
    IN inForCount               TFloat    , -- ��� ���-��
    IN inUserId                 Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- ���� ��� ���-��
     /*IF vbIsInsert = TRUE AND COALESCE (inAmount, 0) = 0 
     THEN
         -- !!!�����!!!
         RETURN;
     END IF;
     */

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inObjectId, Null, inMovementId, inAmount, inParentId, inUserId); 
     
     -- ��������� ����� � <���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptLevel(), ioId, inReceiptLevelId);
     -- ��������� ����� � <������ Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ColorPattern(), ioId, inColorPatternId);
     -- ��������� ����� � <Boat Structure>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdColorPattern(), ioId, inProdColorPatternId);
     -- ��������� ����� � <Options>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ProdOptions(), ioId, inProdOptionsId);
     -- ��������� ����� � <����� �����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReserv(), ioId, inAmountReserv);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSend(), ioId, inAmountSend);
     -- ��������� �������� <��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ForCount(), ioId, CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END);
 
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
 24.12.22         *
*/

-- ����
--