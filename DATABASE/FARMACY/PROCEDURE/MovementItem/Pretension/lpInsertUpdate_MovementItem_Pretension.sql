	
-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Pretension(Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Pretension(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������ �� ��������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ���������� ��� ���������
    IN inReasonDifferencesId Integer   , -- ������
    IN inAmountIncome        TFloat    , -- ���������� ������
    IN inAmountManual        TFloat    , -- ����. ���-��
    IN inisChecked           Boolean   , -- ���������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <������ �� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inParentId);
     -- ��������� �������� <����. ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Amount(), ioId, inAmountIncome);
     -- ��������� �������� <����. ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, inAmountManual);

     -- ��������� <������� �����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), ioId, inReasonDifferencesId);

     -- ��������� �������� <���������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), ioId, inisChecked);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.12.21                                                       *
*/

-- ����
-- 