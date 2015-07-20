-- Function: gpComplete_Movement_Inventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_Inventory  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  vbUserId:= inSession;
  -- ����������� �������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);
  -- ���������� ��������
  PERFORM lpComplete_Movement_Inventory(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������                          
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 11.07.15                                                         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 29207, inSession:= '2')
