-- Function: lpInsertUpdate_MI_OrderExternal_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderExternal_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderExternal_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������> 
    IN inParentId            Integer   , -- ���� �������
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ���������� ������ � ������� ��� � ������� 
    IN inAmountRemains       TFloat    , -- ���������� ������� ����. 
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inMovementId_Send     Integer   , -- � ��������� ������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
 BEGIN
 
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

     -- ��������� �������� <MovementId>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, COALESCE (inMovementId_Send, 0));

     -- ��������� �������� <���������� ������� ����.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), ioId, inAmountRemains);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


     IF 1=0 AND (inUserId = 9457 OR inUserId = 5)
     THEN
         RAISE EXCEPTION '������.����� ������ �� ������';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.22         *
*/

-- ����
--