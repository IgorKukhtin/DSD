-- Function: lpInsertUpdate_MovementFloat_TotalSummOrderFinance (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummOrderFinance (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummOrderFinance(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalSumm     TFloat;
  DECLARE vbAmountPlan_1  TFloat;
  DECLARE vbAmountPlan_2  TFloat;
  DECLARE vbAmountPlan_3  TFloat;
  DECLARE vbAmountPlan_4  TFloat;
  DECLARE vbAmountPlan_5  TFloat;  
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    --
    SELECT (SUM (COALESCE (MovementFloat_TotalSumm_1.Valuedata, 0))
          + SUM (COALESCE (MovementFloat_TotalSumm_2.Valuedata, 0))
          + SUM (COALESCE (MovementFloat_TotalSumm_3.Valuedata, 0))) ::TFloat AS TotalSumm

     INTO vbTotalSumm
    FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_1
                                    ON MovementFloat_TotalSumm_1.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_1.DescId = zc_MovementFloat_TotalSumm_1()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_2
                                    ON MovementFloat_TotalSumm_2.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_2.DescId = zc_MovementFloat_TotalSumm_2()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_3
                                    ON MovementFloat_TotalSumm_3.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_3.DescId = zc_MovementFloat_TotalSumm_3()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderFinance();
    --
    SELECT SUM (COALESCE (MIFloat_AmountPlan_1.ValueData,0)) ::TFloat AS AmountPlan_1
         , SUM (COALESCE (MIFloat_AmountPlan_2.ValueData,0)) ::TFloat AS AmountPlan_2
         , SUM (COALESCE (MIFloat_AmountPlan_3.ValueData,0)) ::TFloat AS AmountPlan_3
         , SUM (COALESCE (MIFloat_AmountPlan_4.ValueData,0)) ::TFloat AS AmountPlan_4
         , SUM (COALESCE (MIFloat_AmountPlan_5.ValueData,0)) ::TFloat AS AmountPlan_5

     INTO vbAmountPlan_1
        , vbAmountPlan_2
        , vbAmountPlan_3
        , vbAmountPlan_4
        , vbAmountPlan_5
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_1
                                        ON MIFloat_AmountPlan_1.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan_1.DescId = zc_MIFloat_AmountPlan_1()
         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_2
                                        ON MIFloat_AmountPlan_2.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan_2.DescId = zc_MIFloat_AmountPlan_2()
         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_3
                                        ON MIFloat_AmountPlan_3.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan_3.DescId = zc_MIFloat_AmountPlan_3()
         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_4
                                        ON MIFloat_AmountPlan_4.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan_4.DescId = zc_MIFloat_AmountPlan_4()
         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_5
                                        ON MIFloat_AmountPlan_5.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPlan_5.DescId = zc_MIFloat_AmountPlan_5()
    WHERE MovementItem.MovementId = inMovementId 
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased = false;


    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPlan_1(), inMovementId, vbAmountPlan_1);
    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPlan_2(), inMovementId, vbAmountPlan_2);
    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPlan_3(), inMovementId, vbAmountPlan_3);
    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPlan_4(), inMovementId, vbAmountPlan_4);
    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPlan_5(), inMovementId, vbAmountPlan_5);
    
    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.07.16         * 
*/
