-- Function: lpInsertUpdate_MovementFloat_TotalSummReprice (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummReprice (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummReprice(
    IN inMovementId Integer -- ���� ������� <��������>
)
RETURNS VOID AS
$BODY$
  DECLARE vbTotalSummReprice          TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    SELECT 
        SUM(COALESCE(MI_Reprice.SummReprice,0)) 
    INTO 
        vbTotalSummReprice
    FROM 
        MovementItem_Reprice_View AS MI_Reprice
    WHERE 
        MI_Reprice.MovementId = inMovementId;

    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummReprice);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummReprice (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
27.11.15                                                              *
*/
