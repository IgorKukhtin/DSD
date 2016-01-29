-- Function: lpInsertUpdate_MovementFloat_TotalSummPaymentExactly (Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementFloat_TotalSummPayment (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementFloat_TotalSummPayment (Integer, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementFloat_TotalSummPayment(
    IN inMovementId Integer, -- ���� ������� <��������>
    IN inSession TVarChar -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
BEGIN

    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementFloat_TotalSummPayment (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 10.12.15                                                         * 
*/
