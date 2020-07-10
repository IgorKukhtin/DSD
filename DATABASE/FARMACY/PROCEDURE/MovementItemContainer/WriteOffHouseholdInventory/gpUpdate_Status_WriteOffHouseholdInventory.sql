-- Function: gpUpdate_Status_WriteOffHouseholdInventory()

DROP FUNCTION IF EXISTS gpUpdate_Status_WriteOffHouseholdInventory (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_WriteOffHouseholdInventory(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_WriteOffHouseholdInventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_WriteOffHouseholdInventory (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_WriteOffHouseholdInventory (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_WriteOffHouseholdInventory (ioId:= 0, inSession:= zfCalc_UserAdmin())