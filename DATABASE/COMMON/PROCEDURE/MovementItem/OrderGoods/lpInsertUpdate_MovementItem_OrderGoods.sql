-- Function: lpInsertUpdate_MovementItem_OrderGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderGoods(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� �������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ���������� ��
    IN inAmountSecond        TFloat    , -- ���������� ��
    IN inPrice               TFloat    , --
    IN inComment             TVarChar  , -- 
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbId_child Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� �� ���������.';
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     --�������� ���� �������� ��� ������ ��� ���-�� ��������� zc_MI_Child
     IF vbIsInsert = FALSE
     THEN
         vbAmount := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.DescId = zc_MI_Master());
         --vbGoodsKindId := (SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKind());

         IF COALESCE (vbAmount,0) <> COALESCE (inAmount,0) --OR COALESCE (vbGoodsKindId,0) <> COALESCE (inGoodsKindId,0)
         THEN
             -- ��������� ����� ������
             vbId_child := lpInsertUpdate_MovementItem (0, zc_MI_Child(), inUserId, inMovementId, vbAmount, ioId);
             -- ��������� ����� � <���� �������>
             --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbId_child, vbGoodsKindId);
             -- ��������� �������� <>
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId_child, CURRENT_TIMESTAMP);
         END IF;
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <���� �������>
     --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderGoods (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 
 08.06.21         *
*/

-- ����
--