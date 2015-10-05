-- Function: lpInsertUpdate_MovementFloat_TotalSummCheck (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummCheck (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummCheck(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountCheck     TFloat;
  DECLARE vbTotalSummCheck     TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    SELECT 
        SUM(COALESCE(MovementItem.Amount,0)),
        SUM((COALESCE(MovementItem.Amount,0)*COALESCE(MovementItemFloat_Price.ValueData,0))::NUMERIC (16, 2))
    INTO 
        vbTotalCountCheck,
        vbTotalSummCheck
    FROM 
        MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = false;


    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountCheck);
    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummCheck);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummCheck (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 20.07.15                                                         * 
*/
