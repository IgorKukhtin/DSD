-- Function: lpInsertUpdate_MI_Transport_Child_only()

-- DROP FUNCTION lpInsertUpdate_MI_Transport_Child_only (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Transport_Child_only(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inFuelId              Integer   , -- Вид топлива
    IN inIsCalculated        Boolean   , -- Количество по факту рассчитыталось из нормы или вводилось (да/нет)
    IN inIsMasterFuel        Boolean   , -- Основной вид топлива (да/нет)
    IN inAmount              TFloat    , -- Количество по факту
    IN inColdHour            TFloat    , -- Холод, Кол-во факт часов 
    IN inColdDistance        TFloat    , -- Холод, Кол-во факт км 
    IN inAmountColdHour      TFloat    , -- Холод, Кол-во норма в час  
    IN inAmountColdDistance  TFloat    , -- Холод, Кол-во норма на 100 км 
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км 
    IN inNumber              TFloat    , -- № по порядку
    IN inRateFuelKindTax     TFloat    , -- % дополнительного расхода в связи с сезоном/температурой
    IN inRateFuelKindId      Integer   , -- Типы норм для топлива
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
BEGIN

   -- проверка
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Маршрут не установлен.';
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
 15.10.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_Transport_Child_only (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
