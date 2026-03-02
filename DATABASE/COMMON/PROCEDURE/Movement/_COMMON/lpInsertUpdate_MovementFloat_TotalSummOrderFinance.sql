-- Function: lpInsertUpdate_MovementFloat_TotalSummOrderFinance (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummOrderFinance (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummOrderFinance(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalSumm      TFloat;
  DECLARE vbTotalSumm_next TFloat;
  DECLARE vbAmountPlan_1   TFloat;
  DECLARE vbAmountPlan_2   TFloat;
  DECLARE vbAmountPlan_3   TFloat;
  DECLARE vbAmountPlan_4   TFloat;
  DECLARE vbAmountPlan_5   TFloat;

BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    --
    /*SELECT (SUM (COALESCE (MovementFloat_TotalSumm_1.Valuedata, 0))
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
     */
    --
    SELECT SUM (COALESCE (tmpMI_all.AmountPlan_1, 0))     ::TFloat AS AmountPlan_1
         , SUM (COALESCE (tmpMI_all.AmountPlan_2, 0))     ::TFloat AS AmountPlan_2
         , SUM (COALESCE (tmpMI_all.AmountPlan_3, 0))     ::TFloat AS AmountPlan_3
         , SUM (COALESCE (tmpMI_all.AmountPlan_4, 0))     ::TFloat AS AmountPlan_4
         , SUM (COALESCE (tmpMI_all.AmountPlan_5, 0))     ::TFloat AS AmountPlan_5
         , SUM (COALESCE (tmpMI_all.Amount, 0))           ::TFloat AS TotalSumm
         , SUM (COALESCE (tmpMI_all.AmountPlan_next, 0))  ::TFloat AS TotalSumm_next

     INTO vbAmountPlan_1
        , vbAmountPlan_2
        , vbAmountPlan_3
        , vbAmountPlan_4
        , vbAmountPlan_5
        , vbTotalSumm
        , vbTotalSumm_next
    FROM (WITH tmpMI AS (SELECT MovementItem.Id
                              , COALESCE (MIFloat_AmountPlan_1.ValueData, 0)     AS AmountPlan_1
                              , COALESCE (MIFloat_AmountPlan_2.ValueData, 0)     AS AmountPlan_2
                              , COALESCE (MIFloat_AmountPlan_3.ValueData, 0)     AS AmountPlan_3
                              , COALESCE (MIFloat_AmountPlan_4.ValueData, 0)     AS AmountPlan_4
                              , COALESCE (MIFloat_AmountPlan_5.ValueData, 0)     AS AmountPlan_5
                              , COALESCE (MovementItem.Amount, 0)                AS Amount
                              , COALESCE (MIFloat_AmountPlan_next.ValueData, 0)  AS AmountPlan_next
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
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_next
                                                          ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPlan_next.DescId = zc_MIFloat_AmountPlan_next()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                        )
       -- Child - Данные с № заявки 1С + ...
     , tmpMI_Child AS (SELECT MovementItem.Id        AS MovementItemId
                            , MovementItem.ParentId  AS MovementItemId_parent
                              -- Первичный план на неделю
                            , MovementItem.Amount    AS Amount
                              -- Платежный план на неделю
                            , MIFloat_AmountPlan_next.ValueData AS AmountPlan_next
                            , MIDate_Amount_next.ValueData      AS OperDate_next
                              -- Согласовано к оплате
                            , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 1 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_1
                            , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 2 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_2
                            , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 3 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_3
                            , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 4 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_4
                            , CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount_next.ValueData) = 5 THEN COALESCE (MIFloat_AmountPlan_next.ValueData, 0) ELSE 0 END AS AmountPlan_5

                       FROM MovementItem
                            -- Платежный план на неделю
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPlan_next
                                                        ON MIFloat_AmountPlan_next.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPlan_next.DescId         = zc_MIFloat_AmountPlan_next()
                            -- Дата Платежный план
                            LEFT JOIN MovementItemDate AS MIDate_Amount_next
                                                       ON MIDate_Amount_next.MovementItemId = MovementItem.Id
                                                      AND MIDate_Amount_next.DescId         = zc_MIDate_Amount_next()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                      )
      -- Detail - Согласовано к оплате
    , tmpMI_Detail AS (SELECT MovementItem.ParentId AS MovementItemId_parent
                              -- Согласовано к оплате
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 1 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_1
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 2 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_2
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 3 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_3
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 4 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_4
                            , SUM (CASE WHEN zfCalc_DayOfWeekNumber (MIDate_Amount.ValueData) = 5 THEN MovementItem.Amount ELSE 0 END) AS AmountPlan_5

                       FROM MovementItem
                            -- Дата Согласовано к оплате
                            LEFT JOIN MovementItemDate AS MIDate_Amount
                                                       ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                      AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Detail()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                      )

          SELECT tmpMI.Id, tmpMI_Child.MovementItemId_parent, tmpMI_Detail_1.MovementItemId_parent AS MovementItemId_parent_1, tmpMI_Detail_2.MovementItemId_parent AS MovementItemId_parent_2
                 -- Первичный план на неделю
               , COALESCE (tmpMI_Child.Amount, tmpMI.Amount)                   AS Amount
                 -- Платежный план на неделю
               , COALESCE (tmpMI_Child.AmountPlan_next, tmpMI.AmountPlan_next) AS AmountPlan_next

                 -- Согласовано к оплате
               , COALESCE (tmpMI_Detail_1.AmountPlan_1, tmpMI_Detail_2.AmountPlan_1, tmpMI_Child.AmountPlan_1, tmpMI.AmountPlan_1) AS AmountPlan_1
               , COALESCE (tmpMI_Detail_1.AmountPlan_2, tmpMI_Detail_2.AmountPlan_2, tmpMI_Child.AmountPlan_2, tmpMI.AmountPlan_2) AS AmountPlan_2
               , COALESCE (tmpMI_Detail_1.AmountPlan_3, tmpMI_Detail_2.AmountPlan_3, tmpMI_Child.AmountPlan_3, tmpMI.AmountPlan_3) AS AmountPlan_3
               , COALESCE (tmpMI_Detail_1.AmountPlan_4, tmpMI_Detail_2.AmountPlan_4, tmpMI_Child.AmountPlan_4, tmpMI.AmountPlan_4) AS AmountPlan_4
               , COALESCE (tmpMI_Detail_1.AmountPlan_5, tmpMI_Detail_2.AmountPlan_5, tmpMI_Child.AmountPlan_5, tmpMI.AmountPlan_5) AS AmountPlan_5

          FROM tmpMI
               -- Child - Данные с № заявки 1С + ...
               LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementItemId_parent = tmpMI.Id
               -- Detail-1 - Согласовано к оплате
               LEFT JOIN tmpMI_Detail AS tmpMI_Detail_1 ON tmpMI_Detail_1.MovementItemId_parent = tmpMI.Id
               -- Detail-2 - Согласовано к оплате
               LEFT JOIN tmpMI_Detail AS tmpMI_Detail_2 ON tmpMI_Detail_2.MovementItemId_parent = tmpMI_Child.MovementItemId
         ) AS tmpMI_all;


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

    -- Сохранили свойство <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm_next(), inMovementId, vbTotalSumm_next);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.07.16         *
*/
