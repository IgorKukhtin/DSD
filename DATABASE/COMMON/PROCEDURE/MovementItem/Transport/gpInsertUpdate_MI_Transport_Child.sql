-- Function: gpInsertUpdate_MI_Transport_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Transport_Child (integer, integer, integer, integer, boolean, boolean, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inFuelId              Integer   , -- Вид топлива
    IN inIsCalculated        Boolean   , -- Количество по факту рассчитыталось из нормы или вводилось
    IN inIsMasterFuel        Boolean   , -- Основной вид топлива (да/нет)
 INOUT ioAmount              TFloat    , -- Количество по факту
   OUT outAmount_calc        TFloat    , -- Количество расчетное по норме
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
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TransportChild());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа> и вернули параметры
     SELECT tmp.ioId, tmp.ioAmount, tmp.outAmount_calc, tmp.outAmount_Distance_calc, tmp.outAmount_ColdHour_calc, tmp.outAmount_ColdDistance_calc
            INTO ioId, ioAmount, outAmount_calc, outAmount_Distance_calc, outAmount_ColdHour_calc, outAmount_ColdDistance_calc
     FROM lpInsertUpdate_MI_Transport_Child (ioId                 := ioId
                                           , inMovementId         := inMovementId
                                           , inParentId           := inParentId
                                           , inFuelId             := inFuelId
                                           , inIsCalculated       := inIsCalculated
                                           , inIsMasterFuel       := inIsMasterFuel
                                           , ioAmount             := ioAmount
                                           , inColdHour           := inColdHour
                                           , inColdDistance       := inColdDistance
                                           , inAmountFuel         := inAmountFuel
                                           , inAmountColdHour     := inAmountColdHour
                                           , inAmountColdDistance := inAmountColdDistance
                                           , inNumber             := inNumber
                                           , inRateFuelKindTax    := inRateFuelKindTax
                                           , inRateFuelKindId     := inRateFuelKindId
                                           , inUserId             := vbUserId
                                            ) AS tmp;

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId,vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.13                                        * add outAmount_...
 07.10.13                                        * add inIsMasterFuel
 04.10.13                                        * add inUserId
 01.10.13                                        * add inRateFuelKindTax
 29.09.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
