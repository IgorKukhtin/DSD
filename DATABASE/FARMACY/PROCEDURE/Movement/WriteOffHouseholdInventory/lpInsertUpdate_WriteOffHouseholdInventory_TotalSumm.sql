-- Function: lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalSum TFloat;
BEGIN

      SELECT SUM(MovementItem.Amount) AS TotalCount, SUM(MIFloat_CountForPrice.ValueData) AS TotalSum
      INTO vbTotalCount, vbTotalSum
      FROM MovementItem

           LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                 ON PHI_MovementItemId.ObjectId = MovementItem.ObjectId
                                AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                                
           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                       ON MIFloat_CountForPrice.MovementItemId = PHI_MovementItemId.ValueData::Integer
                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.DescId = zc_MI_Master();
        
      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCount, 0));
      -- ��������� �������� <����� �����>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, COALESCE(vbTotalSum, 0));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      * 
*/

