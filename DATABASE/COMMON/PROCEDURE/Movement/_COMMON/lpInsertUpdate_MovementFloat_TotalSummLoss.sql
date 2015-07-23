-- Function: lpInsertUpdate_MovementFloat_TotalSummLoss (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummLoss (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummLoss(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCountLoss     TFloat;
  
BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     SELECT SUM(COALESCE(MovementItem.Amount,0)) INTO vbTotalCountLoss
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = false;


      -- Сохранили свойство <Итого Сумма инвентаризации>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountLoss);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummLoss (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 20.07.15                                                         * 
*/
