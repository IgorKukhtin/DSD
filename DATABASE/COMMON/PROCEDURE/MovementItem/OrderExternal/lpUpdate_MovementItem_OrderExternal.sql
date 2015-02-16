-- Function: lpUpdate_MovementItem_OrderExternal()

--DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_OrderExternal(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAmount              TFloat    , -- 
    IN inAmountRemains       TFloat    , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS VOID AS--RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   --DECLARE vbinId Integer;   
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- ��������� <������� ���������>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), inId, inAmountRemains);


     IF vbIsInsert = True                    -- ���� ����� ������
     THEN
         -- ��������� �������� <���� �� ����������>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, 1);
     END IF;

     IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;
    
        -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.02.15         *
*/

-- ����
-- SELECT * FROM lpUpdate_MovementItem_OrderExternal (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
