-- Function: lpInsertUpdate_MovementItem_PriceList_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList_Child (Integer, Integer, Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceList_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inDateStart           TDateTime , -- ���� ������
    IN inUserId              Integer     -- ������ ������������

)
RETURNS Integer AS
$BODY$
BEGIN

     IF EXISTS (SELECT * FROM MovementItem 
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Child()
                  AND MovementItem.ObjectId   = inGoodsId)
     THEN
       SELECT MovementItem.Id INTO ioId
       FROM MovementItem 
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Child()
         AND MovementItem.ObjectId   = inGoodsId;
         
       IF EXISTS(SELECT 1 
                 FROM MovementItemBoolean
                 WHERE MovementItemBoolean.MovementItemId = ioId
                   AND MovementItemBoolean.DescId = zc_MIBoolean_SupplierFailures()
                   AND MovementItemBoolean.ValueData = TRUE)
       THEN         
          RETURN;       
       END IF;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, 0, NULL);

     -- ��������� �������� <����� ����������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SupplierFailures(), ioId, TRUE);

     -- ��������� �������� <���������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);

     -- ��������� ����� � <����/����� �������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);

     -- ��������� �������� <���������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Start(), ioId, inDateStart);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.15                         *
 19.09.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_PriceList_Child ()