-- Function: lpInsertUpdate_MovementFloat_TotalSumm_Pretension (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm_Pretension (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm_Pretension(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$

  DECLARE vbTotalCount   TFloat;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     SELECT SUM(COALESCE(MIFloat_AmountManual.ValueData, 0) - COALESCE(MI_Pretension.Amount,0)) INTO vbTotalCount 
     FROM MovementItem AS MI_Pretension
     
          LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                      ON MIFloat_AmountManual.MovementItemId = MI_Pretension.Id
                                     AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

          LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                        ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                       AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                       
     WHERE MI_Pretension.MovementId = inMovementId 
       AND MI_Pretension.isErased   = false
       AND MI_Pretension.DescId     = zc_MI_Master()
       AND COALESCE(MIBoolean_Checked.ValueData, FALSE) = True;


      -- Сохранили свойство <Итого Сумма реализации>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm_Pretension (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                         * 
*/
-- тест
--