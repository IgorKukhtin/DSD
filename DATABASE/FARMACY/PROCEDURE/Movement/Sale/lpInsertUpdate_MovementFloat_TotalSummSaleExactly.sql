-- Function: lpInsertUpdate_MovementFloat_TotalSummSaleExactly (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSaleExactly (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummSaleExactly(
    IN inMovementId Integer -- Ключ объекта <Документ>
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
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    SELECT 
         SUM(COALESCE(MI_Sale.Amount,0))
       , CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_InsuranceCompanies()
              THEN FLOOR(SUM(COALESCE(MI_Sale.Summ,0)) * 10) / 10
              ELSE SUM(COALESCE(MI_Sale.Summ,0)) END
       , SUM(COALESCE(MI_Sale.Amount,0) * COALESCE(MI_Sale.PriceSale,0))
    INTO 
        vbTotalCountSale
       ,vbTotalSumm
       ,vbTotalSummSale
    FROM 
        MovementItem_Sale_View AS MI_Sale
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                     ON MovementLinkObject_SPKind.MovementId = MI_Sale.MovementId
                                    AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
        LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId
        
    WHERE 
        MI_Sale.MovementId = inMovementId 
        AND 
        MI_Sale.isErased = false
    GROUP BY  MovementLinkObject_SPKind.ObjectId;

    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountSale);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
    -- Сохранили свойство <Итого Сумма без скидки>
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

        -- Сохранили свойство <Итого Сумма>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPrimeCost(), inMovementId, vbTotalSummPrimeCostSale);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummSaleExactly (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 04.07.17         *
 13.10.15                                                         * 
*/

select * from lpInsertUpdate_MovementFloat_TotalSummSaleExactly (30678777);