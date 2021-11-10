-- Function: lpInsertUpdate_MovementItem_PromoPlan_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoPlan_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoPlan_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoPlan_Child(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ������� ������� ���������
    IN inGoodsId               Integer   , -- ������
    IN inGoodsKindId           Integer   , -- �� ������� <��� ������>
    IN inReceiptId             Integer   , --
    IN inReceiptId_parent      Integer   , --
    IN inOperDate              TDateTime , --
    IN inAmount                TFloat    , -- 
    IN inAmountPartner         TFloat    , -- 
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId, inUserId);

    -- ��������� ����� � <��� ������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

    -- ��������� ����� � <���������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      ioId, inReceiptId);
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, inReceiptId_parent);


    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.11.21         *
 */