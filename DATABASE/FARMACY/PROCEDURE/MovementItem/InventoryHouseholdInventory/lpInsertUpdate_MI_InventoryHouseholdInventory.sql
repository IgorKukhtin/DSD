-- Function: lpInsertUpdate_MI_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_InventoryHouseholdInventory (Integer, Integer, Integer, TFloat, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_InventoryHouseholdInventory(
 INOUT ioId                           Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                   Integer   , -- ���� ������� <��������>
    IN inPartionHouseholdInventoryId  Integer   , -- ������ �������������� ���������
    IN inAmount                       TFloat    , -- ����������
    IN inComment                      TVarChar  , -- �����������
    IN inUserId                       Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
               
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPartionHouseholdInventoryId, inMovementId, inAmount, NULL);
     
     -- ��������� <�����������>
     PERFORM lpInsertUpdate_MovementString (zc_MIString_Comment(), ioId, inComment);
      
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 17.07.20                                                                      * 
 */

-- ����
-- SELECT * FROM lpInsertUpdate_MI_InventoryHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
