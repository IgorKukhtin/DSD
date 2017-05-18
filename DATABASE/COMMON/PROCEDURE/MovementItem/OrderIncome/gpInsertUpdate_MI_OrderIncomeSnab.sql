-- Function: gpInsertUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderIncomeSnab (Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderIncomeSnab (Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderIncomeSnab(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
 INOUT ioMeasureId            Integer   , -- 
   OUT outMeasureName         TVarChar  , -- 
    IN inAmount               TFloat    , -- Количество
    IN inPrice                TFloat    , -- 
  OUT outAmountSumm           TFloat    , -- Сумма расчетная
  OUT outAmountOrder          TFloat    , --
  OUT outRemainsDaysWithOrder TFloat    , --
    IN inGoodsId              Integer   , -- Товар
    IN inComment              TVarChar ,   -- 
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbNameBeforeId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbCountDays Integer;
   DECLARE vbEndDate TDateTime;
   DECLARE vbStartDate TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не определен.';
     END IF;

     -- замена
     IF COALESCE (ioMeasureId, 0) = 0
     THEN
         ioMeasureId:= zc_Measure_Sht();
     END IF;
     outMeasureName:= (SELECT ValueData FROM Object WHERE Id = ioMeasureId);
   
      
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), ioMeasureId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     
     -- расчитали сумму по элементу, для грида
     outAmountSumm := CAST (inAmount * inPrice AS NUMERIC (16, 2));

     -- данные из документа 
     SELECT  COALESCE (MovementDate_OperDateStart.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate)) ::TDateTime  AS OperDateStart
           , COALESCE (MovementDate_OperDateEnd.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') ::TDateTime  AS OperDateEnd
    INTO vbStartDate, vbEndDate
     FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.id = inMovementId
       AND Movement.DescId = zc_Movement_OrderIncome();

     vbCountDays := (SELECT DATE_PART('day', (vbEndDate - vbStartDate )) + 1);

     SELECT (COALESCE (tmpMI.AmountOrder, 0) + COALESCE (tmpMI.Amount,0))      ::TFloat   AS AmountOrder
           , CASE WHEN tmpMI.AmountForecast <= 0 AND tmpMI.AmountRemainsEnd <> 0
                      THEN 365
                 WHEN (tmpMI.AmountForecast/vbCountDays) <> 0
                      THEN (COALESCE(tmpMI.AmountRemainsEnd,0) + COALESCE(tmpMI.AmountOrder,0) + COALESCE (tmpMI.Amount,0))/ (tmpMI.AmountForecast/vbCountDays)
                 ELSE 0
            END  :: TFloat AS RemainsDaysWithOrder
    INTO outAmountOrder, outRemainsDaysWithOrder
     FROM (
           SELECT COALESCE (MovementItem.Amount,0) AS Amount   
                , COALESCE (MIFloat_AmountOrder.ValueData, 0)    AS AmountOrder
                , COALESCE (MIFloat_AmountForecast.ValueData, 0) AS AmountForecast
                , COALESCE (MIFloat_AmountRemains.ValueData, 0) + COALESCE (MIFloat_AmountIncome.ValueData, 0) + COALESCE (MIFloat_AmountIn.ValueData, 0)
                - COALESCE (MIFloat_AmountForecast.ValueData, 0) - COALESCE (MIFloat_AmountOut.ValueData, 0)  AS AmountRemainsEnd
           FROM MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                            ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountRemains.DescId = zc_MIFloat_Remains()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountIncome
                                            ON MIFloat_AmountIncome.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountIncome.DescId = zc_MIFloat_Income()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                            ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountIn
                                            ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                            ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                            ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
           WHERE MovementItem.Id = ioId
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
           ) AS tmpMI;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.17         *
*/

-- тест
-- 