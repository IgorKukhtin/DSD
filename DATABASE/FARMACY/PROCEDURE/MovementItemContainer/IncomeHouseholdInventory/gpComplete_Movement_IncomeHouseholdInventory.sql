-- Function: gpComplete_Movement_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_IncomeHouseholdInventory  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Complete_IncomeHouseholdInventory());
           
    -- �������� - ������� ������ � ����� ������ ���������, ���� ��� - �� �������������� �� ��������� ��� ������ ������ ������ �������
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Error. ��� ������ ��� ����������.';
    END IF;
    
    -- ���������� ��������
    PERFORM lpComplete_Movement_IncomeHouseholdInventory(inMovementId, -- ���� ���������
                                                         vbUserId);    -- ������������

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
-- select * from gpUpdate_Status_IncomeHouseholdInventory(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

