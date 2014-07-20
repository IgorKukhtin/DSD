-- Function: lpInsertUpdate_MI_SaleCOMDOC()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SaleCOMDOC (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SaleCOMDOC(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementItemId      Integer   , -- ���� ������� 
    IN inGoodsId             Integer   , -- �����
    IN inGoodsKindId         Integer   , -- 
    IN inAmountPartner       TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inUserId              Integer     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.� �������� ��������� ��� ����� � ������� <EDI>.';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (inMovementItemId, 0) = 0;

     IF COALESCE (inMovementItemId, 0) = 0
     THEN 
         -- ��������� <������� ���������>
         inMovementItemId := lpInsertUpdate_MovementItem (inMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);
         -- ��������� ����� � <���� �������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inMovementItemId, inGoodsKindId);
         -- ��������� �������� <����>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), inMovementItemId, inPrice);
     END IF;

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), inMovementItemId, inAmountPartner);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.14                                        * ALL
 29.05.14                         * 
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_SaleCOMDOC (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
