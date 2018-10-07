-- Function: lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCount         TFloat;
  DECLARE vbTotalSumm          TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    SELECT 
        SUM(COALESCE(MovementItem.Amount,0))
       ,SUM(COALESCE(ROUND(COALESCE(MovementItem.Amount,0)*COALESCE(MIFloat_Price.ValueData,0),2),0)) 
    INTO 
        vbTotalCount
       ,vbTotalSumm
    FROM MovementItem 
         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
    WHERE 
        MovementItem.MovementId = inMovementId 
        AND MovementItem.isErased = false;

    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 30.09.18         *
*/
