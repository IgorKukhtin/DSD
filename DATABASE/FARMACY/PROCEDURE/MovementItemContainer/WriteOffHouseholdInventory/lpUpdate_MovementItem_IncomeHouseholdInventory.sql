-- Function: lpUpdate_MovementItem_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_IncomeHouseholdInventory (Integer, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_IncomeHouseholdInventory(
    IN inMovementItemId               Integer   , -- ���� ������� <��������>
    IN inAmount                       TFloat    , -- ����������
    IN inUserId                       Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbAmount TFloat;
BEGIN

     IF COALESCE (inMovementItemId, 0) = 0
     THEN
        RAISE EXCEPTION '������. ��� ��������� ������� �������.';     
     END IF;
     
     vbAmount := COALESCE((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.ID = inMovementItemId), 0);
     
     IF (COALESCE (vbAmount, 0) + COALESCE (inAmount, 0)) < 0
     THEN
        RAISE EXCEPTION '������. ������� ��� �������.';     
     END IF;

     -- ��������� <>
     UPDATE MovementItem SET Amount = (COALESCE (vbAmount, 0) + COALESCE (inAmount, 0)) WHERE MovementItem.ID = inMovementItemId;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      * 
 */

-- ����
-- SELECT * FROM lpUpdate_MovementItem_IncomeHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
