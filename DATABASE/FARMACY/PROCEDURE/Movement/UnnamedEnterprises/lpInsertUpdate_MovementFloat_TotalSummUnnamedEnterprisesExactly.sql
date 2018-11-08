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
  DECLARE vbTotalCountOrder    TFloat;
  DECLARE vbTotalSummOrder     TFloat;

BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    SELECT
        SUM(COALESCE(MovementItem.Amount,0))
       ,SUM(COALESCE(ROUND(COALESCE(MovementItem.Amount,0)*COALESCE(MIFloat_Price.ValueData,0),2),0))
       ,SUM(COALESCE(MIFloat_AmountOrder.ValueData,0))
       ,SUM(COALESCE(MIFloat_SummOrder.ValueData,0))
    INTO
        vbTotalCount
       ,vbTotalSumm
       ,vbTotalCountOrder
       ,vbTotalSummOrder
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()

         LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                     ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                    AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()

         LEFT JOIN MovementItemFloat AS MIFloat_SummOrder
                                     ON MIFloat_SummOrder.MovementItemId = MovementItem.Id
                                    AND MIFloat_SummOrder.DescId = zc_MIFloat_SummOrder()
    WHERE
        MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = false;

    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
    -- ��������� �������� <����� ���������� � �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountOrder(), inMovementId, vbTotalCountOrder);
    -- ��������� �������� <����� ����� � �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummOrder(), inMovementId, vbTotalSummOrder);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummUnnamedEnterprisesExactly (Integer) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 07.11.18         *
 30.09.18         *
*/