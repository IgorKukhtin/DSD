-- Function: gpSetErased_Movement_IncomeHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_IncomeHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_IncomeHouseholdInventory());


    SELECT Movement.StatusId
    INTO vbStatusId
    FROM Movement
    WHERE Movement.ID = inMovementId;

    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.�������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
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
 30.07.20                                                       *
 09.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_IncomeHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
