-- Function: lpUpdate_Movement_IlliquidUnit_TotalCount (Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_IlliquidUnit_TotalCount (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_IlliquidUnit_TotalCount(
    IN inMovementId Integer -- ���� ������� <��������>
)
RETURNS VOID
AS
$BODY$
  DECLARE vbTotalCount TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;


    SELECT SUM (MovementItem.Amount)
    INTO vbTotalCount
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;

    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE (vbTotalCount, 0));
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
23.12.19                                                       *  
*/
