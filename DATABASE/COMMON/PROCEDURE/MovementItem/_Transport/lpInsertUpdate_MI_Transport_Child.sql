-- Function: lpInsertUpdate_MI_Transport_Child()

-- DROP FUNCTION lpInsertUpdate_MI_Transport_Child();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inFuelId              Integer   , -- Вид топлива
    IN inCalculated          Boolean   , -- Количество по факту рассчитыталось из нормы или вводилось
    IN inAmount              TFloat    , -- Количество по факту
    IN inColdHour            TFloat    , -- Холод, Кол-во факт часов 
    IN inColdDistance        TFloat    , -- Холод, Кол-во факт км 
    IN inAmountColdHour      TFloat    , -- Холод, Кол-во норма в час  
    IN inAmountColdDistance  TFloat    , -- Холод, Кол-во норма на 100 км 
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км 
    IN inRateFuelKindId      Integer     -- Типы норм для топлива          
)                              
RETURNS Integer AS
$BODY$
BEGIN

   IF inCalculated = TRUE
   THEN
       -- При определенных условиях, расчитываем inAmount - Количество по факту
       inAmount := (SELECT -- для "Основного" вида топлива расчитываем норму
                           CASE WHEN inFuelId = ObjectLink_Car_FuelMaster.ChildObjectId
                                     THEN  -- для расстояния
                                          (COALESCE (MovementItem_Master.Amount, 0) * COALESCE (inAmountFuel, 0)
                                           -- для Холод, часов
                                         + COALESCE (inColdHour, 0) * COALESCE (inAmountColdHour, 0)
                                           -- для Холод, км
                                         + COALESCE (inColdDistance, 0) * COALESCE (inAmountColdDistance, 0)
                                          )
                                          -- !!!Коэффициент перевода нормы!!!
                                          -- * COALESCE (ObjectFloat_Ratio.ValueData, 0)
                                ELSE 0
                           END
                    FROM MovementItem AS MovementItem_Master
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                      ON MovementLinkObject_Car.MovementId = inMovementId
                                                     AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                         LEFT JOIN ObjectLink AS ObjectLink_Car_FuelMaster ON ObjectLink_Car_FuelMaster.ObjectId = MovementLinkObject_Car.ObjectId
                                                                          AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster()
                         -- LEFT JOIN ObjectFloat AS ObjectFloat_Ratio ON ObjectFloat_Ratio.ObjectId = inFuelId
                         --                                           AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_Fuel_Ratio()
                    WHERE MovementItem_Master.Id = inParentId
                   );
   END IF;


   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inFuelId, inMovementId, inAmount, inParentId);

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
   
   -- сохранили связь с <Типы норм для топлива>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RateFuelKind(), ioId, inRateFuelKindId);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
