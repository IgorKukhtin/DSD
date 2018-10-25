-- Function: lpInsertUpdate_MovementFloat_TotalSummReprice (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummReprice (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummReprice(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
RETURNS VOID
AS
$BODY$
  DECLARE vbTotalSummReprice TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;


    vbTotalSummReprice:=
                 (SELECT SUM (MovementItem.Amount * (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0)))
                  FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                      LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                  ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                 AND MIFloat_PriceSale.DescId         = zc_MIFloat_PriceSale()
                      LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                    ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                    AND COALESCE (MIBoolean_ClippedReprice.ValueData, FALSE) = FALSE
                 );

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, COALESCE (vbTotalSummReprice, 0));
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
25.10.18                                                                        *  
27.11.15                                                              *
*/
