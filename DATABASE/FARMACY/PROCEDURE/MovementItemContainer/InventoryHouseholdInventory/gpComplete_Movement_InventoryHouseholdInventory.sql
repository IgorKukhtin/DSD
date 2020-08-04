-- Function: gpComplete_Movement_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_InventoryHouseholdInventory  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_InventoryHouseholdInventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
  DECLARE vbUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Complete_InventoryHouseholdInventory());
           
    -- ����������
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

    -- �������� - ������� ������ � ����� ������ ���������, ���� ��� - �� �������������� �� ��������� ��� ������ ������ ������ �������
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION '������. ��� ������ ��� ����������.';
    END IF;

    -- ��������� ������ ��������
    IF EXISTS (SELECT MI_Master.ObjectId AS PartionHouseholdInventoryID
               FROM MovementItem AS MI_Master

                         LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                               ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                                              AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                         LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                         LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.IsErased   = FALSE
                 AND COALESCE (Movement.StatusId, 0) <> zc_Enum_Status_Complete())
    THEN
     
       SELECT Object_HouseholdInventory.ValueData, Object_PartionHouseholdInventory.ObjectCode 
       INTO vbGoodsName, vbInvNumber
       FROM MovementItem AS MI_Master

                 LEFT JOIN Object AS Object_PartionHouseholdInventory 
                                  ON Object_PartionHouseholdInventory.ID = MI_Master.ObjectId

                 LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                       ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                                      AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                 LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer
                 LEFT JOIN Object AS Object_HouseholdInventory 
                                  ON Object_HouseholdInventory.ID = MovementItem.ObjectId

                 LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

       WHERE MI_Master.MovementId = inMovementId
         AND MI_Master.DescId     = zc_MI_Master()
         AND MI_Master.IsErased   = FALSE
         AND COALESCE (Movement.StatusId, 0) <> zc_Enum_Status_Complete();
         
      RAISE EXCEPTION '������.��� ������� �� ������ ���. ��������� <%> <%> ������ �� ��������.', vbInvNumber, vbGoodsName;
    END IF;
    
    -- ����������� �������� �����
    PERFORM lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (inMovementId);
    -- ���������� ��������
    PERFORM lpComplete_Movement_InventoryHouseholdInventory (inMovementId, vbUserId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.07.20                                                       *
 */

-- ����
-- select * from gpUpdate_Status_InventoryHouseholdInventory(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

