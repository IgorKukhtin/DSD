-- Function: lpUpdate_MI_ReturnIn_Total()

DROP FUNCTION IF EXISTS lpUpdate_MI_ReturnIn_Total (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_ReturnIn_Total(
    IN inMovementItemId      Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbTotalPayOth  TFloat;
BEGIN
     -- Итого сумма оплаты (в ГРН) - док расчет
     vbTotalPayOth := COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                 FROM  Object AS Object_PartionMI
                                       INNER JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                         ON MILinkObject_PartionMI.ObjectId = Object_PartionMI.Id 
                                                                        AND MILinkObject_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                       INNER JOIN MovementItem ON MovementItem.Id       = MILinkObject_PartionMI.MovementItemId
                                                              AND MovementItem.DescId   = zc_MI_Master()
                                                              AND MovementItem.isErased = FALSE
                                       INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                          AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                       LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                   ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay() 
                                 WHERE Object_PartionMI.ObjectCode = inMovementItemId 
                                   AND Object_PartionMI.DescId     = zc_Object_PartionMI() 
                                ), 0);
                              
     -- сохранили свойство <Итого сумма возврата оплаты (в ГРН) из Расчетов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayOth(), inMovementItemId, vbTotalPayOth);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.17         *
*/

-- тест
-- 