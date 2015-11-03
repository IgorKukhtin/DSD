-- Function: lpInsertUpdate_MovementFloat_TotalSummPaymentExactly (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummPaymentExactly (Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummPayment (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummPayment(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCountPayment         TFloat;
  DECLARE vbTotalSummPayment          TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    SELECT 
        COUNT(*)
       ,SUM(COALESCE(MI_Payment.SummaPay,0)) 
    INTO 
        vbTotalCountPayment
       ,vbTotalSummPayment
    FROM 
        MovementItem_Payment_View AS MI_Payment
    WHERE 
        MI_Payment.MovementId = inMovementId 
        AND 
        MI_Payment.isErased = FALSE
        AND
        MI_Payment.NeedPay = TRUE;

    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountPayment);
    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummPayment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummPayment (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 29.10.15                                                         * 
*/
