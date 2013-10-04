-- Function: lpInsertUpdate_MI_Transport_Child()

-- DROP FUNCTION lpInsertUpdate_MI_Transport_Child (Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inFuelId              Integer   , -- Вид топлива
    IN inCalculated          Boolean   , -- Количество по факту рассчитыталось из нормы или вводилось
 INOUT ioAmount              TFloat    , -- Количество по факту
   OUT outAmount_calc        TFloat    , -- Количество расчетное по норме
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
RETURNS RECORD AS
$BODY$
BEGIN

   -- проверка
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Маршрут не установлен.';
   END IF;

   -- Получаем расчетное значение по норме
   outAmount_calc := (SELECT -- для "Основного" вида топлива расчитываем норму
                             CASE WHEN inFuelId = ObjectLink_Car_FuelMaster.ChildObjectId
                                       THEN zfCalc_RateFuelValue (inDistance           := MovementItem_Master.Amount
                                                                , inAmountFuel         := inAmountFuel
                                                                , inColdHour           := inColdHour
                                                                , inAmountColdHour     := inAmountColdHour
                                                                , inColdDistance       := inColdDistance
                                                                , inAmountColdDistance := inAmountColdDistance
                                                                , inRateFuelKindTax    := ObjecTFloat_RateFuelKind_Tax.ValueData
                                                                 )
                                            -- !!!Коэффициент перевода нормы!!!
                                            -- * COALESCE (ObjecTFloat_Ratio.ValueData, 0)
                                  ELSE 0
                             END
                      FROM MovementItem AS MovementItem_Master
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                        ON MovementLinkObject_Car.MovementId = inMovementId
                                                       AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                           LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster ON ObjectLink_Car_FuelMaster.ObjectId = MovementLinkObject_Car.ObjectId
                                                                            AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
                           LEFT JOIN ObjecTFloat AS ObjecTFloat_RateFuelKind_Tax ON ObjecTFloat_RateFuelKind_Tax.ObjectId =inRateFuelKindId
                                                                                AND ObjecTFloat_RateFuelKind_Tax.DescId = zc_ObjecTFloat_RateFuelKind_Tax()
                           -- LEFT JOIN ObjecTFloat AS ObjecTFloat_Ratio ON ObjecTFloat_Ratio.ObjectId = inFuelId
                           --                                           AND ObjecTFloat_Ratio.DescId = zc_ObjecTFloat_Fuel_Ratio()
                      WHERE MovementItem_Master.Id = inParentId
                     );

   IF inCalculated = TRUE
   THEN
       -- При определенных условиях, Количество по факту должно быть равно нолрме
       ioAmount := outAmount_calc;
   END IF;


   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inFuelId, inMovementId, ioAmount, inParentId);

   -- сохранили свойство <Количество по факту рассчитыталось из нормы или вводилось>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inCalculated);
   
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
 04.10.13                                        * add inUserId
 01.10.13                                        * add inRateFuelKindTax and zfCalc_RateFuelValue
 29.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
