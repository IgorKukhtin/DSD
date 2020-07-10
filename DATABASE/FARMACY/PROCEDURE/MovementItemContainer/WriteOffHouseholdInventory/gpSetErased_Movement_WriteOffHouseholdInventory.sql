-- Function: gpSetErased_Movement_WriteOffHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_WriteOffHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_WriteOffHouseholdInventory(
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
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_WriteOffHouseholdInventory());

    -- ��������� ������ ��������
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete() 
    THEN
       RAISE EXCEPTION '������.�������� �������� �������� ���������.';
    END IF;

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_WriteOffHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
