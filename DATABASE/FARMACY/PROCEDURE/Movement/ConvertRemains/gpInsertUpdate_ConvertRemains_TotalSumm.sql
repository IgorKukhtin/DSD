-- Function: gpInsertUpdate_ConvertRemains_TotalSumm (Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_ConvertRemains_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ConvertRemains_TotalSumm(
    IN inMovementId    Integer,    -- Ключ объекта <Документ>
    IN inSession       TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCount TFloat;
  DECLARE vbTotalSum TFloat;
BEGIN

      SELECT SUM(MovementItem.Amount) AS TotalCount
           , SUM(ROUND(MIFloat_PriceWithVAT.ValueData * MovementItem.Amount, 2)) AS TotalSum
      INTO vbTotalCount, vbTotalSum
      FROM MovementItem

           LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                       ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                      AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased = FALSE
        AND MovementItem.DescId = zc_MI_Master();

      -- Сохранили свойство <Итого количество>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, COALESCE(vbTotalCount));
      -- Сохранили свойство <Итого сумма>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, COALESCE(vbTotalSum));

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_ConvertRemains_TotalSumm (Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
*/