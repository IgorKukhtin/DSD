-- Function: lpInsertUpdate_MovementFloat_TotalSummOver (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummOver (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummOver(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$

  DECLARE vbTotalCount    TFloat;
  DECLARE vbTotalSummFrom TFloat;
  DECLARE vbTotalSummTo   TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    SELECT  SUM(CASE WHEN MovementItem.DescId = zc_MI_Master() THEN (COALESCE(MovementItem.Amount,0)) ELSE 0 END)
         ,  SUM(CASE WHEN MovementItem.DescId = zc_MI_Master() THEN ((COALESCE(MovementItem.Amount,0)*COALESCE(MovementItemFloat_Price.ValueData,0))::NUMERIC (16, 2)) ELSE 0 END)
         ,  SUM(CASE WHEN MovementItem.DescId = zc_MI_Child() THEN ((COALESCE(MovementItem.Amount,0)*COALESCE(MovementItemFloat_Price.ValueData,0))::NUMERIC (16, 2)) ELSE 0 END)
     INTO vbTotalCount
       , vbTotalSummFrom
       , vbTotalSummTo
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE MovementItem.MovementId = inMovementId 
      AND MovementItem.isErased = false;


    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFrom(), inMovementId, vbTotalSummFrom);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTo(), inMovementId, vbTotalSummTo);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.07.16         * 
*/
