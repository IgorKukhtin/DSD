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

    -- ��������� ������ ��������
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Master
               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount     <> 1
                 AND MI_Master.IsErased   = FALSE
              )
    THEN
       SELECT Object_HouseholdInventory.ValueData, MIFloat_InvNumber.ValueData::Integer
       INTO vbGoodsName, vbInvNumber
       FROM MovementItem AS MI_Master

            LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                        ON MIFloat_InvNumber.MovementItemId = MI_Master.Id
                                       AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()
                                       
            LEFT JOIN Object AS Object_HouseholdInventory
                             ON Object_HouseholdInventory.ID = MI_Master.ObjectId

       WHERE MI_Master.MovementId = inMovementId
         AND MI_Master.DescId     = zc_MI_Master()
         AND MI_Master.Amount     <> 1
         AND MI_Master.IsErased   = FALSE;

       RAISE EXCEPTION '������.��� ������� �� ������ ���. ��������� <%> <%> �� ��������� ����������.', vbInvNumber, vbGoodsName;
    END IF;
    
    -- �������� ������
    PERFORM lpInsertUpdate_Object_PartionHouseholdInventory(ioId               := 0,                                     -- ���� ������� <>
                                                            inInvNumber        := MIFloat_InvNumber.ValueData::Integer,  -- ����������� �����
                                                            inUnitId           := MovementLinkObject_Unit.ObjectId,      -- �������������
                                                            inMovementItemId   := MI_Master.ID,                          -- ���� �������� ������� �������������� ���������
                                                            inUserId           := vbUserId)
    FROM MovementItem AS MI_Master

         LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                     ON MIFloat_InvNumber.MovementItemId = MI_Master.Id
                                    AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()
                                       
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = MI_Master.MovementId
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    WHERE MI_Master.MovementId = inMovementId
      AND MI_Master.DescId     = zc_MI_Master()
      AND MI_Master.Amount     > 0
      AND MI_Master.IsErased   = FALSE;    
         
    -- ������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_IncomeHouseholdInventory()
                               , inUserId     := vbUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
 */

-- ����
-- select * from gpUpdate_Status_IncomeHouseholdInventory(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

