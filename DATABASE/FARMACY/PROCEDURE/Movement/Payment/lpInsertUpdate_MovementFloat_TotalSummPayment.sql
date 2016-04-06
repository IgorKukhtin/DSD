-- Function: lpInsertUpdate_MovementFloat_TotalSummPaymentExactly (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummPaymentExactly (Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummPayment (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummPayment(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbTotalCountPayment         TFloat;
  DECLARE vbTotalSummPayment          TFloat;
  
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    SELECT COUNT(*)
         , SUM(COALESCE(MI_Payment.Amount,0)) --, SUM(COALESCE(MI_Payment.SummaPay,0)) 
    INTO vbTotalCountPayment
       , vbTotalSummPayment
    FROM MovementItem AS MI_Payment
        LEFT JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                      ON MIBoolean_NeedPay.MovementItemId = MI_Payment.Id
                                     AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
    WHERE MI_Payment.MovementId = inMovementId 
      AND MI_Payment.DescId = zc_MI_Master()
      AND MI_Payment.isErased = FALSE
      AND COALESCE(MIBoolean_NeedPay.ValueData,FALSE) = TRUE;

   --RAISE EXCEPTION '% %',vbTotalCountPayment,  vbTotalSummPayment;
    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountPayment);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummPayment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummPayment (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 06.04.16         *
 29.10.15                                                         * 
*/

--select * from gpGet_Movement_Payment_TotalSumm(inMovementId := 1470596 ,  inSession := '3');

--select * from lpInsertUpdate_MovementFloat_TotalSummPayment(1470596)
