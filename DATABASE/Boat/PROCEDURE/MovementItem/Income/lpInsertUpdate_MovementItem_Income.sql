-- Function: lpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inOperPriceList       TFloat    , -- ���� �������
    IN inPartNumber          TVarChar  , -- � �� ��� ��������
    IN inComment             TVarChar  ,
    IN inPartionCellId       Integer   , --
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN ioId > 0 THEN ioId ELSE NULL END, inMovementId, inAmount, NULL, inUserId);

     -- ��������� �������� <OperPriceList>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, inOperPriceList);

     -- <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     -- <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, inPartionCellId);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
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
 08.01.24         * inPartionCellId
 24.02.21         * PartNumber
 11.05.18         *
*/

-- ����
--
