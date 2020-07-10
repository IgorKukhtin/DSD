-- Function: gpUnComplete_Movement_WriteOffHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_WriteOffHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_WriteOffHouseholdInventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_UnComplete_WriteOffHouseholdInventory());

    -- �������� ����������
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete()
    THEN
        PERFORM lpUpdate_MovementItem_IncomeHouseholdInventory (PHI_MovementItemId.ValueData::Integer, MI_Master.Amount, vbUserId)
        FROM MovementItem AS MI_Master

             LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                   ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                                  AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                                  
        WHERE MI_Master.MovementId = inMovementId
          AND MI_Master.DescId     = zc_MI_Master()
          AND MI_Master.Amount     > 0
          AND MI_Master.IsErased   = FALSE; 
    END IF;

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm (inMovementId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_WriteOffHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())