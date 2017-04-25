-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSale (Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummIncome (Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalSumm TFloat;
  DECLARE vbTotalSummPriceList TFloat;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     SELECT SUM(COALESCE(MovementItem.Amount, 0))
          , SUM(CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) <> 0
                           THEN CAST (COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPrice.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                     ELSE CAST ( COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPrice.ValueData, 0) AS NUMERIC (16, 2))
                END)
          , SUM(CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) <> 0
                           THEN CAST (COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPriceList.ValueData, 0) / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                     ELSE CAST ( COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2))
                END)

    INTO vbTotalCount, vbTotalSumm, vbTotalSummPriceList
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()    
            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                    
      WHERE MovementItem.MovementId = inMovementId 
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased = false;

      -- Сохранили свойство <Итого количество("главные элементы")>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
      -- Сохранили свойство <Итого Сумма>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
      -- Сохранили свойство <Итого Сумма реализации>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPriceList(), inMovementId, vbTotalSummPriceList);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                         * 
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Income() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
