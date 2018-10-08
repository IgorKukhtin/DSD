-- Function: lpUpdate_MovementItem_KPU (Integer)

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_KPU (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_KPU(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbKPU         Integer;
BEGIN
  IF COALESCE (inMovementId, 0) = 0
  THEN
    RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
  END IF;

  vbKPU := 30;

  SELECT
    vbKPU
    +  COALESCE (MIFloat_MarkRatio.ValueData::Integer,
              CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0)
              THEN 1 ELSE -1 END::Integer)
    +  COALESCE (MIFloat_AverageCheckRatio.ValueData::Integer,
            CASE WHEN COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) <= COALESCE (MIFloat_AverageCheck.ValueData, 0)
            THEN 1 ELSE -1 END::Integer)
  INTO
    vbKPU
  FROM MovementItem

       LEFT JOIN MovementItemFloat AS MIFloat_AmountTheFineTab
                                   ON MIFloat_AmountTheFineTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_AmountTheFineTab.DescId = zc_MIFloat_AmountTheFineTab()

       LEFT JOIN MovementItemFloat AS MIFloat_BonusAmountTab
                                   ON MIFloat_BonusAmountTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_BonusAmountTab.DescId = zc_MIFloat_BonusAmountTab()

       LEFT JOIN MovementItemFloat AS MIFloat_MarkRatio
                                   ON MIFloat_MarkRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_MarkRatio.DescId = zc_MIFloat_MarkRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_PrevAverageCheck
                                   ON MIFloat_PrevAverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_PrevAverageCheck.DescId = zc_MIFloat_PrevAverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheck
                                   ON MIFloat_AverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheck.DescId = zc_MIFloat_AverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheckRatio
                                   ON MIFloat_AverageCheckRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheckRatio.DescId = zc_MIFloat_AverageCheckRatio()

  WHERE MovementItem.Id = inMovementId
    AND MovementItem.isErased = false;

    -- Сохранили свойство <KPU>
  UPDATE MovementItem SET Amount = vbKPU WHERE ID = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_MovementItem_KPU (Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.10.18         *
*/