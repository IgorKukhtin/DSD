-- Function: gpUpdate_Status_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpUpdate_Status_InventoryHouseholdInventory (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_InventoryHouseholdInventory(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_InventoryHouseholdInventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_InventoryHouseholdInventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_InventoryHouseholdInventory (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_InventoryHouseholdInventory (ioId:= 0, inSession:= zfCalc_UserAdmin())