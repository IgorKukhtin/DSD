-- Function: gpInsertUpdate_MI_Transport_Child()

-- DROP FUNCTION gpInsertUpdate_MI_Transport_Child();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inFuelId              Integer   , -- Вид топлива
    IN inAmount              TFloat    , -- Количество по факту
    IN inParentId            Integer   , -- Главный элемент документа
    IN inCalculated          Boolean   , -- Количество по факту рассчитыталось из нормы или вводилось
    
    IN inСoldHour            TFloat    , -- Холод, Кол-во факт часов 
    IN inСoldDistance        TFloat    , -- Холод, Кол-во факт км 
    IN inAmountСoldHour      TFloat    , -- Холод, Кол-во норма в час  
    IN inAmountСoldDistance  TFloat    , -- Холод, Кол-во норма на 100 км 
    IN inAmountFuel          TFloat    , -- Кол-во норма на 100 км 
    
    IN inRateFuelKindId      Integer   , -- Типы норм для топлива          

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Transport());
   vbUserId := inSession;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inFuelId, inMovementId, inAmount, inParentId);

   -- сохранили свойство <Количество>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inCalculated);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_СoldHour(), ioId, inСoldHour);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_СoldDistance(), ioId, inСoldDistance);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountСoldHour(), ioId, inAmountСoldHour);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountСoldDistance(), ioId, inAmountСoldDistance);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountFuel(), ioId, inAmountFuel);

   
   -- сохранили связь с <Типы норм для топлива>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RateFuelKind(), ioId, inRateFuelKindId);
   
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.07.13                                        * Важен порядок полей
 15.07.13         *     
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
