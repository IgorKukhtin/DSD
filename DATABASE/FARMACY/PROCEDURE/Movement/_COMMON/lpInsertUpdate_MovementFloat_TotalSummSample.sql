-- Function: lpInsertUpdate_MovementFloat_TotalSummSample (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummSample (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummSample(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalSummSample   TFloat;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     SELECT SUM(COALESCE(MovementItem.Amount, 0) * COALESCE (MIFloat_PriceSample.ValueData)) 
   INTO vbTotalSummSample 
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_PriceSample
                                      ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()
     WHERE MovementItem.MovementId = inMovementId 
       AND MovementItem.isErased = FALSE;

      -- Сохранили свойство <Итого Сумма реализации>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSample(), inMovementId, vbTotalSummSample);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.18         *
*/
--