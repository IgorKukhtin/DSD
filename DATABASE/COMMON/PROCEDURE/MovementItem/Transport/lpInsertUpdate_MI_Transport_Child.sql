-- Function: lpInsertUpdate_MI_Transport_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Transport_Child (integer, integer, integer, integer, boolean, boolean, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Transport_Child_only (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inFuelId              Integer   , -- Вид топлива
    IN inIsCalculated        Boolean   , -- Количество по факту рассчитыталось из нормы или вводилось (да/нет)
    IN inIsMasterFuel        Boolean   , -- Основной вид топлива (да/нет)
 INOUT ioAmount              TFloat    , -- Количество по факту
   OUT outAmount_calc               TFloat    , -- Количество расчетное по норме
   OUT outAmount_Distance_calc      TFloat    , -- Количество расчетное по норме
   OUT outAmount_ColdHour_calc      TFloat    , -- Количество расчетное по норме
   OUT outAmount_ColdDistance_calc  TFloat    , -- Количество расчетное по норме
    IN inColdHour            TFloat    , -- Холод, Кол-во факт часов 
    IN inColdDistance        TFloat    , -- Холод, Кол-во факт км 
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км 
    IN inAmountColdHour      TFloat    , -- Холод, Кол-во норма в час  
    IN inAmountColdDistance  TFloat    , -- Холод, Кол-во норма на 100 км 
    IN inNumber              TFloat    , -- № по порядку
    IN inRateFuelKindTax     TFloat    , -- % дополнительного расхода в связи с сезоном/температурой
    IN inRateFuelKindId      Integer   , -- Типы норм для топлива
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS RECORD AS
$BODY$
BEGIN

   -- проверка
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Маршрут не установлен.';
   END IF;

   -- Расчитываем норму
   SELECT zfCalc_RateFuelValue_Distance     (inDistance           := CASE WHEN inIsMasterFuel = TRUE  THEN MovementItem_Master.Amount          -- если "Основной" вид топлива
                                                                          WHEN inIsMasterFuel = FALSE THEN MIFloat_DistanceFuelChild.ValueData -- если "Дополнительный" вид топлива
                                                                          ELSE 0
                                                                     END
                                           , inAmountFuel         := inAmountFuel
                                           , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                           , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                        ) AS Amount_Distance_calc
        , zfCalc_RateFuelValue_ColdHour     (inColdHour           := inColdHour
                                           , inAmountColdHour     := inAmountColdHour
                                           , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                           , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                            ) AS Amount_ColdHour_calc
        , zfCalc_RateFuelValue_ColdDistance (inColdDistance       := inColdDistance
                                           , inAmountColdDistance := inAmountColdDistance
                                           , inFuel_Ratio         := 1 -- !!!Коэффициент перевода нормы уже учтен!!!
                                           , inRateFuelKindTax    := 0 -- !!!% дополнительного расхода в связи с сезоном/температурой уже учтен!!!
                                            ) AS Amount_ColdHour_calc

          INTO outAmount_Distance_calc, outAmount_ColdHour_calc, outAmount_ColdDistance_calc
   FROM MovementItem AS MovementItem_Master
        LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                    ON MIFloat_DistanceFuelChild.MovementItemId = MovementItem_Master.Id
                                   AND MIFloat_DistanceFuelChild.DescId = zc_MIFloat_DistanceFuelChild()
   WHERE MovementItem_Master.Id = inParentId
     AND MovementItem_Master.MovementId = inMovementId;

   -- Расчитываем норму за все
   outAmount_calc := outAmount_Distance_calc + outAmount_ColdHour_calc + outAmount_ColdDistance_calc;


   IF inIsCalculated = TRUE
   THEN
       -- При определенных условиях, Количество по факту должно быть равно норме
       ioAmount := outAmount_calc;
   END IF;


   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inFuelId, inMovementId, ioAmount, inParentId);

   -- сохранили свойство <Количество по факту рассчитывалось из нормы или вводилось (да/нет)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inIsCalculated);
   -- сохранили свойство <Основной вид топлива (да/нет)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_MasterFuel(), ioId, inIsMasterFuel);
   
   -- сохранили свойство <Холод, Кол-во факт часов >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColdHour(), ioId, inColdHour);
   -- сохранили свойство <Холод, Кол-во факт км >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColdDistance(), ioId, inColdDistance);
   -- сохранили свойство <Холод, Кол-во норма в час  >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountColdHour(), ioId, inAmountColdHour);
   -- сохранили свойство <Холод, Кол-во норма на 100 км >
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountColdDistance(), ioId, inAmountColdDistance);
   -- сохранили свойство <Кол-во норма на 100 км>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountFuel(), ioId, inAmountFuel);
   -- сохранили свойство <№ по порядку>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Number(), ioId, inNumber);
   -- сохранили свойство <% дополнительного расхода в связи с сезоном/температурой>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateFuelKindTax(), ioId, inRateFuelKindTax);
   
   -- сохранили связь с <Типы норм для топлива>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RateFuelKind(), ioId, inRateFuelKindId);

   -- сохранили протокол
   -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.13                                        * add outAmount_...
 24.10.13                                        * add zfCalc_RateFuelValue_...
 07.10.13                                        * add DistanceFuelChild and isMasterFuel
 04.10.13                                        * add inUserId
 01.10.13                                        * add inRateFuelKindTax and zfCalc_RateFuelValue
 29.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
