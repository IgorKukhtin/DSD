-- Function: lpInsertUpdate_MI_ChangePercent_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ChangePercent_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ChangePercent_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inParentId            Integer   , -- ���� ������� 
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inUnitId              Integer   , -- �������������
    IN inAmount              TFloat    , -- ����������
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

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

      -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.04.23         *
*/

-- ����
--