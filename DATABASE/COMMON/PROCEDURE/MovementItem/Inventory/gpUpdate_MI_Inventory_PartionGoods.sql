-- Function: gpUpdate_MI_Inventory_PartionGoods (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_PartionGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_PartionGoods(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inPartionGoodsId      Integer   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     IF inId <> 0
     THEN
          -- ��������� ����� � <������ �������>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), inId, inPartionGoodsId);

          -- ��������� ��������
          PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.12.18         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Inventory_PartionGoods
