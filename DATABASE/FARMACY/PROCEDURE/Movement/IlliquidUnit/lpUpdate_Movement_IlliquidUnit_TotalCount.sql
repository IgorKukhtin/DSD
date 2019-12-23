-- Function: lpUpdate_Movement_IlliquidUnit_TotalCount (Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_IlliquidUnit_TotalCount (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_IlliquidUnit_TotalCount(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
RETURNS VOID
AS
$BODY$
  DECLARE vbTotalCount TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;


    SELECT SUM (MovementItem.Amount)
    INTO vbTotalCount
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE (vbTotalCount, 0));
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
23.12.19                                                       *  
*/
