-- Function: lpInsertUpdate_ComputerAccessoriesRegister_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ComputerAccessoriesRegister_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ComputerAccessoriesRegister_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount TFloat;
BEGIN

      SELECT SUM(MovementItem.Amount) AS TotalCount
      INTO vbTotalCount
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.DescId = zc_MI_Master();

      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCount));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ComputerAccessoriesRegister_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 14.07.20                                                                      * 
*/
