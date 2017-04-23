-- Function: lpInsertUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderIncomeSnab_Property (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderIncomeSnab_Property (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderIncomeSnab_Property (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderIncomeSnab_Property(
    IN inId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- 
    IN inGoodsId              Integer   , -- Товары
    IN inMeasureId            Integer   , -- 
    IN inRemainsStart         TFloat    , -- 
    --IN inRemainsEnd           TFloat    , -- 
    IN inBalanceStart         TFloat    , -- 
    IN inBalanceEnd           TFloat    , -- 
    IN inIncome               TFloat    , -- 
    IN inAmountForecast       TFloat    , -- 
    IN inAmountIn             TFloat    , -- 
    IN inAmountOut            TFloat    , -- 
    IN inAmountOrder          TFloat    , -- 
    IN inUserId               Integer     -- пользователь
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     IF COALESCE (inId, 0) = 0
     THEN
         -- замена
         IF COALESCE (inMeasureId, 0) = 0
         THEN
             inMeasureId:= zc_Measure_Sht();
         END IF;
           
         -- сохранили <Элемент документа>
         inId := lpInsertUpdate_MovementItem (COALESCE (inId, 0), zc_MI_Master(), inMeasureId, inMovementId, 0, NULL);

         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), inId, inGoodsId);
     END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), inId, inRemainsStart);
   -- сохранили свойство <>
   --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsEnd(), inId, inRemainsEnd);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BalanceStart(), inId, inBalanceStart);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BalanceEnd(), inId, inBalanceEnd);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Income(), inId, inIncome);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForecast(), inId, inAmountForecast);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountIn(), inId, inAmountIn);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut(), inId, inAmountOut);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), inId, inAmountOrder);
   
  
   -- сохранили протокол
   -- PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_OrderIncomeSnab_Property (inId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
