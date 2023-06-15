-- Function: gpInsert_Movement_InventoryCheck()

DROP FUNCTION IF EXISTS gpInsert_Movement_InventoryCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_InventoryCheck(
    IN inMovementId  Integer   , -- ���� ������� <�������� ��������������>
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());    
    
    PERFORM gpInsert_MI_InventoryCheck (inMovementId  := inMovementId
                                      , inGoodsId     := MICheck.GoodsId
                                      , inAmount      := MICheck.Amount
                                      , inDateInput   := MICheck.OperDate
                                      , inUserInputId := MICheck.UserId
                                      , inCheckId     := MICheck.MovementId
                                      , inSession     := inSession)
    FROM gpSelect_Movement_InventoryCheck(inMovementId := inMovementId, inSession := inSession) AS MICheck;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.06.23                                                       *
*/

-- ����

-- select * from gpInsert_Movement_InventoryCheck(inMovementId := 31882953 , inSession := '3');
    