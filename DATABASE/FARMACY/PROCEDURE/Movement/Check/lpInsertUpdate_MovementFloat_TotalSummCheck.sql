-- Function: lpInsertUpdate_MovementFloat_TotalSummCheck (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummCheck (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummCheck(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountCheck TFloat;
  DECLARE vbTotalSummCheck TFloat;
  DECLARE vbTotalSummChangePercent TFloat;
  DECLARE vbRoundingTo10 Boolean;
  DECLARE vbRoundingTo50 Boolean;
  DECLARE vbRoundingDown Boolean;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    SELECT
      COALESCE(MB_RoundingTo10.ValueData, FALSE),
      COALESCE(MB_RoundingDown.ValueData, FALSE),
      COALESCE(MB_RoundingTo50.ValueData, FALSE)
    INTO
      vbRoundingTo10, vbRoundingDown, vbRoundingTo50
    FROM Movement
    
         LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                   ON MB_RoundingTo10.MovementId = Movement.Id
                                  AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()

         LEFT JOIN MovementBoolean AS MB_RoundingDown
                                   ON MB_RoundingDown.MovementId = Movement.Id
                                  AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                                  
         LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                   ON MB_RoundingTo50.MovementId = Movement.Id
                                  AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

    WHERE Movement.Id = inMovementId;

    SELECT SUM(COALESCE(MovementItem.Amount,0)),
           SUM(zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * COALESCE(MovementItemFloat_Price.ValueData,0), vbRoundingDown, vbRoundingTo10, vbRoundingTo50)),
           SUM(COALESCE(MIFloat_SummChangePercent.ValueData,0)::NUMERIC (16, 4))
    INTO
        vbTotalCountCheck,
        vbTotalSummCheck,
        vbTotalSummChangePercent
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                    ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                   AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
        LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                      ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                     AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
    WHERE MovementItem.MovementId = inMovementId 
      AND MovementItem.DescId = zc_MI_Master() 
      AND MovementItem.isErased = false
      AND COALESCE (MIBoolean_Present.ValueData, False) = False;

    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountCheck);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummCheck);
    -- Сохранили свойство <Итого Сумма скидки>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChangePercent(), inMovementId, vbTotalSummChangePercent);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummCheck (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 06.06.19                                                                       *
 02.04.19                                                                       *
 11.04.17         *
 20.07.15                                                         *
*/
