-- Function: lpInsertUpdate_MovementItem_ServiceItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ServiceItem(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- ����� 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inArea                TFloat    , -- 
    IN inUserId              Integer    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUnitId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Area(), ioId, inArea);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_DateEnd(), ioId, inDateEnd);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), ioId, inCommentInfoMoneyId);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_ServiceItem (ioId := 56 , inMovementId := 17 , inUnitId := 446 , inPartionId := 50 , inAmount := 3 , ioCountForPrice := 1 , inOperPrice := 100 ,  inSession := '2');