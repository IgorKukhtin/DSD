-- Function: lpInsertUpdate_MI_Inventory_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Inventory_Child (Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Inventory_Child(
 INOUT inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- ������� ������
    IN inAmountUser          TFloat    , -- ����������
    IN inUserId              Integer   -- ���������� ����� ����
 )                              
RETURNS Integer AS
$BODY$
 
BEGIN
     -- ��������� <������� ���������>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), inUserId, inMovementId, inAmountUser, inParentId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inId, CURRENT_TIMESTAMP);


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, inUserId, True);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.01.17         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_Inventory_Child (inId:= 0, inMovementId:= 10, inParentId:= 1, inAmountUser:= 0, inSession:= '2')
