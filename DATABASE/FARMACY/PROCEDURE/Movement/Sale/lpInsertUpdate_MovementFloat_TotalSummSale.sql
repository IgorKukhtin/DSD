-- Function: lpInsertUpdate_MovementFloat_TotalSummSale (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSale (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummSale(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCountSale         TFloat;
  DECLARE vbTotalSummSale          TFloat;
  DECLARE vbTotalSummPrimeCostSale TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    SELECT 
        SUM(COALESCE(MI_Sale.Amount,0))
       ,SUM(COALESCE(MI_Sale.Summ,0)) 
    INTO 
        vbTotalCountSale
       ,vbTotalSummSale
    FROM 
        MovementItem_Sale_View AS MI_Sale
    WHERE 
        MI_Sale.MovementId = inMovementId 
        AND 
        MI_Sale.isErased = false;

    -- ��������� �������� <����� ����������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountSale);
    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummSale);

    IF EXISTS(SELECT 1 
              FROM Movement_Sale_View 
              Where Id = inMovementId 
                AND StatusCode = zc_Enum_StatusCode_Complete())
    THEN
        SELECT 
            SUM(COALESCE(-MovementItemContainer.Amount,0))
        INTO 
            vbTotalSummPrimeCostSale
        FROM 
            MovementItemContainer
        WHERE 
            MovementItemContainer.MovementId = inMovementId 
            AND 
            MovementItemContainer.DescId = zc_Container_Summ();
        
        -- ��������� �������� <����� �����>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPrimeCost(), inMovementId, vbTotalSummPrimeCostSale);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummSale (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 13.10.15                                                         * 
*/
