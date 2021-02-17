-- Function: lpInsertUpdate_PromoBonus_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_PromoBonus_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_PromoBonus_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountSend TFloat;
BEGIN

      SELECT COUNT(*) AS Amount
      INTO vbTotalCountSend
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.DescId = zc_MI_Master();

      -- Сохранили свойство <Итого количество>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCountSend));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_PromoBonus_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.02.21                                                                      * 
*/