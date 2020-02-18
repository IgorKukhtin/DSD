-- Function: lpUpdate_Movement_TechnicalRediscount_TotalDiff (Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_TechnicalRediscount_TotalDiff (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_TechnicalRediscount_TotalDiff(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
RETURNS VOID
AS
$BODY$
  DECLARE vbTotalDiff TFloat;
  DECLARE vbTotalDiffSumm TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;


    SELECT SUM (MovementItem.Amount)
    INTO vbTotalCount, vbTotalDiffSumm
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiff(), inMovementId, COALESCE (vbTotalDiff, 0));

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiffSumm(), inMovementId, COALESCE (vbTotalDiffSumm, 0));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 15.02.20                                                       *
*/
