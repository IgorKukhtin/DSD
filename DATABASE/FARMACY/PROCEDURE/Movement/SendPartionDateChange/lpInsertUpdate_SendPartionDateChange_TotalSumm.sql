-- Function: lpInsertUpdate_SendPartionDateChange_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_SendPartionDateChange_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_SendPartionDateChange_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountSend TFloat;
BEGIN

      SELECT SUM(MovementItem.Amount) AS Amount
      INTO vbTotalCountSend
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.DescId = zc_MI_Master();

      -- ��������� �������� <����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCountSend));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_SendPartionDateChange_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 02.07.20                                                                      * 
*/