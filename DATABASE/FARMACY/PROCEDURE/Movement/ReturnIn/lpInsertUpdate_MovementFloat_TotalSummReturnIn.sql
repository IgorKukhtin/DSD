-- Function: lpInsertUpdate_MovementFloat_TotalSummReturnIn (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummReturnIn (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummReturnIn(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountReturnIn TFloat;
  DECLARE vbTotalSummReturnIn TFloat;
  DECLARE vbRoundingTo10 Boolean;
  DECLARE vbRoundingDown Boolean;
  DECLARE vbRoundingTo50 Boolean;
  DECLARE vbParentId Integer;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    --Определили чек
    SELECT
      MovementFloat_MovementId.ValueData::Integer,
      COALESCE(MB_RoundingTo10.ValueData, FALSE),
      COALESCE(MB_RoundingDown.ValueData, FALSE),
      COALESCE(MB_RoundingTo50.ValueData, FALSE)
    INTO
      vbParentId, vbRoundingTo10, vbRoundingDown, vbRoundingTo50
    FROM Movement
    
         LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                 ON MovementFloat_MovementId.MovementId = Movement.Id
                                AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()

         LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                   ON MB_RoundingTo10.MovementId = MovementFloat_MovementId.ValueData::Integer
                                  AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()

         LEFT JOIN MovementBoolean AS MB_RoundingDown
                                   ON MB_RoundingDown.MovementId = MovementFloat_MovementId.ValueData::Integer
                                  AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                                  
         LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                   ON MB_RoundingTo50.MovementId = MovementFloat_MovementId.ValueData::Integer
                                  AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

    WHERE Movement.Id = inMovementId;
    
    IF inMovementId in (24249552, 32732548) 
    THEN
       vbRoundingTo10 := False;
       vbRoundingDown := False; 
       vbRoundingTo50 := False;
    END IF;


    SELECT SUM(COALESCE(MovementItem.Amount,0)),
           SUM(zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * COALESCE(MovementItemFloat_Price.ValueData,0)
                               , vbRoundingDown, vbRoundingTo10, vbRoundingTo50))
    INTO
        vbTotalCountReturnIn,
        vbTotalSummReturnIn
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price()
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.isErased = false;


    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountReturnIn);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummReturnIn);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.04.19                                                       *
 19.01.19         *
*/

-- select * from lpInsertUpdate_MovementFloat_TotalSummReturnIn (32732548)