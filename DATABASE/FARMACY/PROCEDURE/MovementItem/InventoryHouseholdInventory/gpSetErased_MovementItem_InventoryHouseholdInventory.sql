-- Function: gpSetErased_MovementItem_InventoryHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_InventoryHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_InventoryHouseholdInventory(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory());

  -- ������������� ����� ��������
  outIsErased:= gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_InventoryHouseholdInventory_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.ID = inMovementItemId));
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_InventoryHouseholdInventory (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 17.07.20                                                                      * 
*/

-- ����
-- SELECT * FROM gpSetErased_MovementItem_InventoryHouseholdInventory (inMovementItemId:= 0, inSession:= '2')
