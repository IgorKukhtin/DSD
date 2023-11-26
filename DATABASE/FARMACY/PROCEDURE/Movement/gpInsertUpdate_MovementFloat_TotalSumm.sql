-- Function: gpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementFloat_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId  Integer, -- ���� ������� <��������>
    IN inSession     TVarChar -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
BEGIN

    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementFloat_TotalSumm (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 24.11.23                                                      * 
*/