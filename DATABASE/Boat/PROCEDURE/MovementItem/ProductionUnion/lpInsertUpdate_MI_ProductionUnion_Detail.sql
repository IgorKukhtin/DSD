-- Function: lpInsertUpdate_MI_ProductionUnion_Detail()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Detail (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Detail(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inReceiptServiceId       Integer   , -- ������
    IN inPersonalId             Integer   , -- ���������
    IN inAmount                 TFloat    , -- 
    IN inOperPrice              TFloat    , -- 
    IN inHours                  TFloat    , -- 
    IN inSumm                   TFloat    , -- 
    IN inComment                TVarChar  , --
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inReceiptServiceId, Null, inMovementId, inAmount, inParentId, inUserId); 
     
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Personal(), ioId, inPersonalId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Hours(), ioId, inHours); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     
     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.01.23         *
*/

-- ����
--