-- Function: lpInsertUpdate_MI_Sale_Child()

DROP FUNCTION IF EXISTS lpUpdate_MI_Sale_Total (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Sale_Total(
    IN inMovementItemId      Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbTotalChangePercentPay TFloat;
   DECLARE vbTotalPayOth           TFloat;
   DECLARE vbTotalCountReturn      TFloat;
   DECLARE vbTotalReturn           TFloat;
   DECLARE vbTotalPayReturn        TFloat;            
BEGIN
  
     
     vbTotalChangePercentPay := 0;
     vbTotalPayOth := 0;
     vbTotalCountReturn := 0;
     vbTotalReturn := 0;
     vbTotalPayReturn := 0;
     
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