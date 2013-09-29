-- Function: gpInsertUpdate_MI_Transport_Child()

-- DROP FUNCTION gpInsertUpdate_MI_Transport_Child();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Child(
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

   PERFORM lpInsertUpdate_MI_Transport_Child (ioId                 = ioId
                                            , inMovementId         = inMovementId
                                            , inParentId           = inParentId
                                            , inFuelId             = inFuelId
                                            , inCalculated         = inCalculated
                                            , inAmount             = inAmount
                                            , inColdHour           = inColdHour
                                            , inColdDistance       = inColdDistance
                                            , inAmountColdHour     = inAmountColdHour
                                            , inAmountColdDistance = inAmountColdDistance
                                            , inAmountFuel         = inAmountFuel
                                            , inRateFuelKindId     = inRateFuelKindId
                                             );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
