-- Function: lpInsertUpdate_MovementItem_StoreReal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StoreReal (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_StoreReal(
 INOUT ioId          Integer   , -- ���� ������� <������� ���������>
    IN inMovementId  Integer   , -- ���� ������� <��������>
    IN inGoodsId     Integer   , -- ������
    IN inAmount      TFloat    , -- ����������
    IN inGoodsKindId Integer   , -- ���� �������
    IN inUserId      Integer   , -- ������������
    IN inGUID        TVarChar    -- ���������� ���������� ������������� ��� ������������� � ���������� ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
      -- ������������ ������� ��������/�������������
      vbIsInsert:= COALESCE (ioId, 0) = 0;

      -- ��������� <������� ���������>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

      -- ��������� ����� � <���� �������>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

      IF inGoodsId <> 0
      THEN
           -- ������� ������ <����� ������ � ���� �������>
           PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
      END IF;

      -- ��������� GUID, ���� �����
      IF inGUID IS NOT NULL
      THEN
           PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, inGUID);
      END IF;
      
      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 20.03.17                                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_StoreReal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inGoodsKindId:= 0, inUserId:= 1, inGUID:= NULL)
