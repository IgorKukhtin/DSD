-- Function: lpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS lpUpdate_MI_Sale_Total (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Sale_Total(
    IN inMovementItemId      Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbTotalChangePercentPay TFloat;   --Итого сумма скидки (в ГРН) - док расчет
   DECLARE vbTotalPayOth           TFloat;   --Итого сумма оплаты (в ГРН) - док расчет
   DECLARE vbTotalCountReturn      TFloat;   --Итого количество возврата  - док возврат
   DECLARE vbTotalReturn           TFloat;   --Итого сумма возврата со скидкой (в ГРН)  - док возврат
   DECLARE vbTotalPayReturn        TFloat;   --Итого сумма возврата оплаты (в ГРН) - док возврат 
   DECLARE vbOperPriceList         TFloat;   --цена (прайс)
BEGIN
  
     vbOperPriceList := (SELECT MIFloat_OperPriceList.ValueData 
                         FROM MovementItemFloat AS MIFloat_OperPriceList
                         WHERE MIFloat_OperPriceList.MovementItemId = inMovementItemId
                           AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                         );
                                      
     -- получение сумм
     SELECT  COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN COALESCE(MIFloat_TotalPay.ValueData,0)  ELSE 0         END), 0) AS TotalPayOth
           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN COALESCE(MIFloat_SummChangePercent.ValueData,0) ELSE 0 END) , 0) AS TotalChangePercentPay
           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()     THEN MovementItem.Amount                     ELSE 0         END ), 0) AS TotalCountReturn
           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()     THEN (MovementItem.Amount * vbOperPriceList) - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) ELSE 0 END), 0) AS TotalReturn
           , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()     THEN COALESCE(MIFloat_TotalPay.ValueData,0)  ELSE 0         END), 0) AS TotalPayReturn
     INTO vbTotalPayOth, vbTotalChangePercentPay, vbTotalCountReturn, vbTotalReturn, vbTotalPayReturn
    
      FROM  Object AS Object_PartionMI
            INNER JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                              ON MILinkObject_PartionMI.ObjectId =  Object_PartionMI.Id 
                                             AND MILinkObject_PartionMI.DescId   = zc_MILinkObject_PartionMI()
            INNER JOIN MovementItem ON MovementItem.Id       = MILinkObject_PartionMI.MovementItemId
                                   AND MovementItem.DescId   = zc_MI_Master()
                                   AND MovementItem.isErased = False
                                   
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                               AND Movement.StatusId = zc_Enum_Status_Complete() 

            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay() 
            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                        ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                                       
     WHERE Object_PartionMI.ObjectCode = inMovementItemId
       AND Object_PartionMI.DescId = zc_Object_PartionMI();
                            
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercentPay(), inMovementItemId, vbTotalChangePercentPay);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayOth(), inMovementItemId, vbTotalPayOth);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalCountReturn(), inMovementItemId, vbTotalCountReturn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalReturn(), inMovementItemId, vbTotalReturn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayReturn(), inMovementItemId, vbTotalPayReturn);


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