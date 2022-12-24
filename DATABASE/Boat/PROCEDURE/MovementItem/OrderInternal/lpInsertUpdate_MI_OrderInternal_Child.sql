-- Function: lpInsertUpdate_MI_Send_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Send_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Send_Child(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inObjectId               Integer   , -- �������������
    IN inAmount                 TFloat    , -- ���������� (������ ������)
    IN inAmountReserv           TFloat    , -- ���������� ������
    IN inAmountSend             TFloat    , -- ���-�� ������ �� �������./�����������
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

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReserv(), ioId, inAmountReserv);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSend(), ioId, inAmountSend);
 
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