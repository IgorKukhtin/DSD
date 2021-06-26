-- Function: lpGet_MovementItem_WagesAE_TotalSum()

DROP FUNCTION IF EXISTS lpGet_MovementItem_WagesAE_TotalSum(Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_WagesAE_TotalSum(
    IN inMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
    IN inUserId              Integer     -- пользователь
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbSumma1                 TFloat;
   DECLARE vbSumma2                 TFloat;
   DECLARE vbSummaTMP               TFloat;
   DECLARE vbSummaMoneyBox          TFloat;
   DECLARE vbSummaMoneyBoxUsed      TFloat;
   DECLARE vbSummaMoneyBoxNew       TFloat;
   DECLARE vbOperDate               TDateTime;
   DECLARE vbUnitID                 Integer;
BEGIN

    -- проверка сохранения
    IF COALESCE (inMovementItemId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Дополнительные затраты не сохранены.';
    END IF;

    -- проверка сохранения
    IF NOT EXISTS(SELECT 1
                  FROM MovementItem
                       INNER JOIN Movement ON Movement.ID = MovementItem.MovementID
                                          AND Movement.DescId = zc_Movement_Wages()
                  WHERE MovementItem.ID = inMovementItemId
                    AND MovementItem.DescId = zc_MI_Sign())
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не найден.';
    END IF;

    SELECT Movement.OperDate, MovementItem.ObjectId
    INTO vbOperDate, vbUnitID
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementID
                            AND Movement.DescId = zc_Movement_Wages()
    WHERE MovementItem.ID = inMovementItemId
      AND MovementItem.DescId = zc_MI_Sign();

    vbSumma1 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                          FROM MovementItemFloat AS MIFloat_SummaSUN1
                          WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                            AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaCleaning(), zc_MIFloat_SummaSP(), zc_MIFloat_SummaOther(),
                                                             zc_MIFloat_ValidationResults(), zc_MIFloat_SummaSUN1())), 0);

    IF vbOperDate >= '01.12.2020'
    THEN
      vbSumma1 := vbSumma1 + COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                       FROM MovementItemFloat AS MIFloat_SummaSUN1
                                       WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                          AND MIFloat_SummaSUN1.DescId = zc_MIFloat_IntentionalPeresort()), 0);
    END IF;

    IF vbOperDate >= '01.03.2020'
    THEN

      -- Полное списание остаток сумм на текущий месяц
      vbSummaTMP := COALESCE((SELECT SUM(COALESCE(MIF_SummaFullChargeMonth.ValueData, 0) - COALESCE(MIF_SummaFullChargeFact.ValueData, 0))
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                                          AND MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.ObjectId = vbUnitID
                                   INNER JOIN MovementItemFloat AS MIF_SummaFullChargeMonth
                                                                ON MIF_SummaFullChargeMonth.MovementItemId = MovementItem.Id
                                                               AND MIF_SummaFullChargeMonth.DescId = zc_MIFloat_SummaFullChargeMonth()
                                   INNER JOIN MovementItemFloat AS MIF_SummaFullCharge
                                                                ON MIF_SummaFullCharge.MovementItemId = MovementItem.Id
                                                               AND MIF_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()
                                   LEFT JOIN MovementItemFloat AS MIF_SummaFullChargeFact
                                                               ON MIF_SummaFullChargeFact.MovementItemId = MovementItem.Id
                                                              AND MIF_SummaFullChargeFact.DescId = zc_MIFloat_SummaFullChargeFact()
                              WHERE Movement.DescId = zc_Movement_Wages()
                                AND Movement.OperDate < vbOperDate), 0);

      -- Заполняем переходящую сумму если надо
      IF vbSummaTMP <> COALESCE((SELECT SUM(MIFloat_SummaFullCharge.ValueData)
                                 FROM MovementItemFloat AS MIFloat_SummaFullCharge
                                 WHERE MIFloat_SummaFullCharge.MovementItemId = inMovementItemId
                                   AND MIFloat_SummaFullCharge.DescId in (zc_MIFloat_SummaFullCharge())), 0)
      THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullCharge(), inMovementItemId, COALESCE (vbSummaTMP, 0)::TFloat);
      END IF;


      -- Сумма кошелька остаток сумм на текущий месяц
      vbSummaTMP := COALESCE((SELECT SUM(COALESCE(MIF_SummaMoneyBoxMonth.ValueData, 0) - COALESCE(MIF_SummaMoneyBoxUsed.ValueData, 0))
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Sign()
                                                          AND MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.ObjectId = vbUnitID
                                   LEFT JOIN MovementItemFloat AS MIF_SummaMoneyBoxMonth
                                                                ON MIF_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                                               AND MIF_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()
                                   LEFT JOIN MovementItemFloat AS MIF_SummaMoneyBoxUsed
                                                               ON MIF_SummaMoneyBoxUsed.MovementItemId = MovementItem.Id
                                                              AND MIF_SummaMoneyBoxUsed.DescId = zc_MIFloat_SummaMoneyBoxUsed()
                              WHERE Movement.DescId = zc_Movement_Wages()
                                AND Movement.OperDate < vbOperDate), 0);

      -- Заполняем переходящую сумму если надо
      IF vbSummaTMP <> COALESCE((SELECT SUM(MIFloat_SummaMoneyBox.ValueData)
                                 FROM MovementItemFloat AS MIFloat_SummaMoneyBox
                                 WHERE MIFloat_SummaMoneyBox.MovementItemId = inMovementItemId
                                   AND MIFloat_SummaMoneyBox.DescId in (zc_MIFloat_SummaMoneyBox())), 0)
      THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBox(), inMovementItemId, COALESCE (vbSummaTMP, 0)::TFloat);
      END IF;

      -- Сумма кошелька
      vbSummaMoneyBox := COALESCE((SELECT SUM(MIFloat_SummaMoneyBoxMonth.ValueData)
                                   FROM MovementItemFloat AS MIFloat_SummaMoneyBoxMonth
                                   WHERE MIFloat_SummaMoneyBoxMonth.MovementItemId = inMovementItemId
                                     AND MIFloat_SummaMoneyBoxMonth.DescId in (zc_MIFloat_SummaMoneyBoxMonth())), 0) + COALESCE (vbSummaTMP, 0);

      -- Использовано в текущем месяце
      vbSummaMoneyBoxUsed := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                       FROM MovementItemFloat AS MIFloat_SummaSUN1
                                       WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                         AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaMoneyBoxUsed())), 0);

      -- Сумма ТП + ПС
                              
      vbSumma2 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                            FROM MovementItemFloat AS MIFloat_SummaSUN1
                            WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                              AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaTechnicalRediscount(), zc_MIFloat_SummaFullChargeFact())), 0);      
                              
      IF vbSumma2 > 0 THEN vbSumma2 := 0; END IF;


      IF vbSumma2 < 0 AND vbSummaMoneyBox  > 0
      THEN
        
        IF vbSummaMoneyBox + vbSumma2 > 0
        THEN
          vbSummaMoneyBoxNew := - vbSumma2;
        ELSE
          vbSummaMoneyBoxNew := vbSummaMoneyBox;
        END IF;

        IF vbSummaMoneyBoxNew <> vbSummaMoneyBoxUsed
        THEN
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBoxUsed(), inMovementItemId, vbSummaMoneyBoxNew);
        END IF;

      ELSE
        IF vbSummaMoneyBoxUsed <> 0
        THEN
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaMoneyBoxUsed(), inMovementItemId, 0);
        END IF;
      END IF;

      vbSumma2 := vbSumma2 + COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                                       FROM MovementItemFloat AS MIFloat_SummaSUN1
                                       WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                                         AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaMoneyBoxUsed())), 0);

    ELSE
      vbSumma2 := 0;
    END IF;

    -- Результат
    RETURN vbSumma1 + vbSumma2;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.02.20                                                        *
*/

-- тест
-- SELECT * FROM lpGet_MovementItem_WagesAE_TotalSum (inMovementItemId := 323828208, inUserId := 3)
