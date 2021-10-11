-- Function: lpInsert_MI_OrderGoodsDetail_Child()

DROP FUNCTION IF EXISTS lpInsert_MI_OrderGoodsDetail_Child (Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsert_MI_OrderGoodsDetail_Child(
    IN inId                        Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                Integer   , -- ���� �������
    IN inParentId                  Integer   , -- 
    IN inGoodsId                   Integer   , -- ������
    IN inGoodsKindId               Integer   , 
    IN inAmount                    TFloat    , -- ����������
    IN inUserId                    Integer     -- ������ ������������                                                
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <�����> �� ���������.';
     END IF;

     -- ��������� <������� ���������>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inId, inGoodsKindId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.21         *
*/

-- ����
--