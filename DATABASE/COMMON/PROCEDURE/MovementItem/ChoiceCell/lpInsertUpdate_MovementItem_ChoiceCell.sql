-- Function: lpInsertUpdate_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ChoiceCell(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <>
    IN inChoiceCellId        Integer   , -- 
    IN inGoodsId             Integer   ,
    IN inGoodsKindId         Integer   ,    
    IN inPartionGoodsDate    TDateTime ,
    IN inPartionGoodsDate_next TDateTime ,
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inChoiceCellId, inMovementId, 0, NULL);


     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     --
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate); 
     --
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_next(), ioId, inPartionGoodsDate_next); 

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.24         *
*/

-- ����
-- 