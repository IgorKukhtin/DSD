-- Function: lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_IncomeHouseholdInventory_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalSum TFloat;
BEGIN

      SELECT SUM(MovementItem.Amount) AS TotalCount, SUM(ROUND(MIFloat_CountForPrice.ValueData * MovementItem.Amount, 2)) AS TotalSum
      INTO vbTotalCount, vbTotalSum
      FROM MovementItem

           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.DescId = zc_MI_Master();

      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCount));
      -- ��������� �������� <����� �����>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, COALESCE(vbTotalSum));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      * 
*/
