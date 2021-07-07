-- Function: lpInsertUpdate_MovementFloat_TotalSummTestingTuning (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummTestingTuning (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummTestingTuning(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount     TFloat;
  DECLARE vbQuestion       TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;


    SELECT SUM(MovementItem.Amount)
    INTO vbQuestion
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;                         
          
    SELECT COUNT(*)
    INTO vbTotalCount
    FROM MovementItem 

         INNER JOIN MovementItem AS MovementItemChild
                                 ON MovementItemChild.MovementId = inMovementId
                                AND MovementItemChild.ParentId = MovementItem.Id
                                AND MovementItemChild.DescId = zc_MI_Child()
                                AND MovementItemChild.isErased = FALSE

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;                         

    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TestingUser_Question(), inMovementId, vbQuestion);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummTestingTuning (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.07.21                                                       *
*/