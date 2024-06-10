-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient Integer, -- ����� �������
    IN inGoodsId             Integer   , -- �������������
    IN inPartionCellId       Integer   , --
    IN inAmount              TFloat    , -- ����������
    IN inOperPrice           TFloat    , -- ����
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inPartNumber          TVarChar  , -- � �� ��� ��������
    IN inComment             TVarChar  ,
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) <= 0;

     -- ��������� � �����
     IF inMovementId_OrderClient > 0
     THEN
         UPDATE Movement SET ParentId = inMovementId_OrderClient WHERE Movement.Id = inMovementId AND COALESCE (Movement.ParentId, 0) <> inMovementId_OrderClient;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, inOperPrice);
     -- ��������� �������� <���� �� ���.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, inPartionCellId);


     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.12.22         *
 23.06.21         *
*/

-- ����
--