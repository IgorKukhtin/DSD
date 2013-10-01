-- Function: gpInsertUpdate_MI_Transport_Master()

-- DROP FUNCTION gpInsertUpdate_MI_Transport_Master();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inRouteId             Integer   , -- Маршрут
    IN inAmount	             TFloat    , -- Пробег, км
    IN inWeight	             TFloat    , -- Вес груза
    IN inStartOdometre       TFloat    , -- Спидометр начальное показание, км
    IN inEndOdometre         TFloat    , -- Спидометр конечное показание, км
    IN inFreightId           Integer   , -- Название груза
    IN inRouteKindId         Integer   , -- Типы маршрутов
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Transport());
   vbUserId := inSession;

   -- При определенных условиях, расчитываем inAmount - Пробег, км
   IF COALESCE (inStartOdometre, 0) <> 0 OR COALESCE (inEndOdometre, 0) <> 0
   THEN
       inAmount := ABS (COALESCE (inEndOdometre, 0) - COALESCE (inStartOdometre, 0));
   ELSE
       -- иначе оставляем введенное значение
       inAmount := ABS (inAmount);
   END IF;


   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, inAmount, NULL);
  
   -- сохранили связь с <Название груза>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Freight(), ioId, inFreightId);
   
   -- сохранили связь с <Типы маршрутов>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RouteKind(), ioId, inRouteKindId);
  
   -- сохранили свойство <Вес груза>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Weight(), ioId, inWeight);

   -- сохранили свойство <Спидометр начальное показание, км>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Weight(), ioId, inStartOdometre);

   -- сохранили свойство <Спидометр конечное показание, км>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Weight(), ioId, inEndOdometre);

   -- пересчитали Child для тех кому надо (MIBoolean_Calculated.ValueData = TRUE)
   PERFORM lpInsertUpdate_MI_Transport_Child (ioId                 := MovementItem.Id
                                            , inMovementId         := inMovementId
                                            , inParentId           := ioId
                                            , inFuelId             := MovementItem.ObjectId
                                            , inCalculated         := MIBoolean_Calculated.ValueData
                                            , ioAmount             := MovementItem.Amount
                                            , outAmount_calc       := MovementItem.Amount
                                            , inColdHour           := MIFloat_ColdHour.ValueData
                                            , inColdDistance       := MIFloat_ColdDistance.ValueData
                                            , inAmountColdHour     := MIFloat_AmountColdHour.ValueData
                                            , inAmountColdDistance := MIFloat_AmountColdDistance.ValueData
                                            , inAmountFuel         := MIFloat_AmountFuel.ValueData
                                            , inNumber             := MIFloat_Number.ValueData
                                            , inRateFuelKindTax    := MIFloat_RateFuelKindTax.ValueData
                                            , inRateFuelKindId     := MILinkObject_RateFuelKind.ObjectId
                                             )
   FROM MovementItem
        JOIN MovementItemBoolean AS MIBoolean_Calculated
                                 ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                AND MIBoolean_Calculated.ValueData = TRUE
             LEFT JOIN MovementItemFloat AS MIFloat_ColdHour
                                         ON MIFloat_ColdHour.MovementItemId = MovementItem.Id
                                        AND MIFloat_ColdHour.DescId = zc_MIFloat_ColdHour()
             LEFT JOIN MovementItemFloat AS MIFloat_ColdDistance
                                         ON MIFloat_ColdDistance.MovementItemId = MovementItem.Id
                                        AND MIFloat_ColdDistance.DescId = zc_MIFloat_ColdDistance()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountColdHour
                                        ON MIFloat_AmountColdHour.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountColdHour.DescId = zc_MIFloat_AmountColdHour()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountColdDistance
                                         ON MIFloat_AmountColdDistance.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountColdDistance.DescId = zc_MIFloat_AmountColdDistance()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountFuel
                                         ON MIFloat_AmountFuel.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountFuel.DescId = zc_MIFloat_AmountFuel()
             LEFT JOIN MovementItemFloat AS MIFloat_RateFuelKindTax
                                         ON MIFloat_RateFuelKindTax.MovementItemId = MovementItem.Id
                                        AND MIFloat_RateFuelKindTax.DescId = zc_MIFloat_RateFuelKindTax()

             LEFT JOIN MovementItemFloat AS MIFloat_Number
                                         ON MIFloat_Number.MovementItemId = MovementItem.Id
                                        AND MIFloat_Number.DescId = zc_MIFloat_Number()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_RateFuelKind
                                              ON MILinkObject_RateFuelKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_RateFuelKind.DescId = zc_MILinkObject_RateFuelKind()

   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.DescId = zc_MI_Child()
     AND MovementItem.ParentId = ioId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.09.13                                        * 
 25.09.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
