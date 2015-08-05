-- Function: lpDelete_MovementItemReport (Integer)

-- DROP FUNCTION lpDelete_MovementItemReport (Integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemReport (inMovementId Integer)
RETURNS VOID
AS
$BODY$
BEGIN

    IF zc_IsLockTable() = FALSE
    THEN
        PERFORM MovementItemReport.* FROM MovementItemReport WHERE MovementItemReport.MovementId = inMovementId FOR UPDATE;
    END IF;

    -- ������� ��� �������� ��� ������
    DELETE FROM MovementItemReport WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_MovementItemReport (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.13                                        * add lpDelete_MovementItemReport
*/
