-- Function: lpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inObjectId               Integer   , -- �������������
    IN inReceiptLevelId         Integer   , -- ���� ������
    IN inColorPatternId         Integer   , -- ������ Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- �����
    IN inAmount                 TFloat    , -- ���������� 
    IN inUserId                 Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


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
 12.07.21         *
*/

-- ����
-- SELECT * FROM