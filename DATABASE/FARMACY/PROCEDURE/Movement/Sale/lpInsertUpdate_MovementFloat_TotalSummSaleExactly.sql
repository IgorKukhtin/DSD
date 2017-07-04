-- Function: lpInsertUpdate_MovementFloat_TotalSummSaleExactly (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSaleExactly (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummSaleExactly(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCountSale         TFloat;
  DECLARE vbTotalSumm              TFloat;
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
       ,SUM(COALESCE(MI_Sale.Amount,0) * COALESCE(MI_Sale.PriceSale,0))
    INTO 
        vbTotalCountSale
       ,vbTotalSumm
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
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
    -- ��������� �������� <����� ����� ��� ������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSale(), inMovementId, vbTotalSummSale);

    IF EXISTS(SELECT 1 
              FROM Movement_Sale_View 
              Where Id = inMovementId 
                AND StatusCode = zc_Enum_StatusCode_Complete())
    THEN
/*
        SELECT SUM(COALESCE(-MovementItemContainer.Amount,0))
      INTO vbTotalSummPrimeCostSale
        FROM MovementItemContainer
        WHERE MovementItemContainer.MovementId = inMovementId 
          AND MovementItemContainer.DescId = zc_Container_Summ();
 */

        SELECT  SUM ( COALESCE(-MIC.Amount,0) * MI_Income.PriceWithVAT ) 
       INTO  vbTotalSummPrimeCostSale
        FROM MovementItemContainer AS MIC
             LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                 ON CLI_MI.ContainerId = MIC.ContainerId
                                                AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
             LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
             LEFT OUTER JOIN MovementItem_Income_View AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
        WHERE MIC.MovementId = inMovementId
            AND MIC.DescId = zc_Container_Count();

        -- ��������� �������� <����� �����>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPrimeCost(), inMovementId, vbTotalSummPrimeCostSale);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummSaleExactly (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 04.07.17         *
 13.10.15                                                         * 
*/
