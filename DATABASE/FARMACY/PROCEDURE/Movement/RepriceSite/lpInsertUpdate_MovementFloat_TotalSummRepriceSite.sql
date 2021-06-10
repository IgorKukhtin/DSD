-- Function: lpInsertUpdate_MovementFloat_TotalSummRepriceSite (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummRepriceSite (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummRepriceSite(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
RETURNS VOID
AS
$BODY$
  DECLARE vbTotalSummRepriceSite TFloat;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;


    vbTotalSummRepriceSite:=
                 (SELECT SUM (MovementItem.Amount * (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0)))
                  FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                      LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                  ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                 AND MIFloat_PriceSale.DescId         = zc_MIFloat_PriceSale()
                      LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedRepriceSite
                                                    ON MIBoolean_ClippedRepriceSite.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_ClippedRepriceSite.DescId         = zc_MIBoolean_ClippedReprice()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                    AND COALESCE (MIBoolean_ClippedRepriceSite.ValueData, FALSE) = FALSE
                 );

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, COALESCE (vbTotalSummRepriceSite, 0));
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
10.06.21                                                       *  
*/
