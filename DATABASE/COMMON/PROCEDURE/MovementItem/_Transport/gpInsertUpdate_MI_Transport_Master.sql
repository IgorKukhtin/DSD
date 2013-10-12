-- Function: gpInsertUpdate_MI_Transport_Master()

-- DROP FUNCTION gpInsertUpdate_MI_Transport_Master();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inRouteId             Integer   , -- Маршрут
    IN inAmount	             TFloat    , -- Пробег, км (основной вид топлива)
    IN inDistanceFuelChild   TFloat    , -- Пробег, км (дополнительный вид топлива)
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

   IF COALESCE (inStartOdometre, 0) <> 0 OR COALESCE (inEndOdometre, 0) <> 0
   THEN
       -- При определенных условиях, расчитываем inAmount - Пробег, км
       inAmount := ABS (COALESCE (inEndOdometre, 0) - COALESCE (inStartOdometre, 0));
       -- уменьшаем inAmount на Пробег, км (дополнительный вид топлива)
       inAmount := inAmount - COALESCE (inDistanceFuelChild, 0);
   ELSE
       -- иначе оставляем введенное значение
       inAmount := ABS (inAmount);
   END IF;

   -- проверка 
   IF inAmount < 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Неверное значение <Пробег, км (основной вид топлива)>.';
   END IF;

   -- проверка
   IF inDistanceFuelChild < 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Неверное значение <Пробег, км (дополнительный вид топлива)>.';
   END IF;


   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, inAmount, NULL);
  
   -- сохранили связь с <Название груза>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_Freight(), ioId, inFreightId);
   
   -- сохранили связь с <Типы маршрутов>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_RouteKind(), ioId, inRouteKindId);

   -- сохранили свойство <Пробег, км (дополнительный вид топлива)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DistanceFuelChild(), ioId, inDistanceFuelChild);

   -- сохранили свойство <Вес груза>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Weight(), ioId, inWeight);

   -- сохранили свойство <Спидометр начальное показание, км>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_StartOdometre(), ioId, inStartOdometre);

   -- сохранили свойство <Спидометр конечное показание, км>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_EndOdometre(), ioId, inEndOdometre);

   -- пересчитали Child для тех кому надо (MIBoolean_Calculated.ValueData = TRUE)
   PERFORM lpInsertUpdate_MI_Transport_Child (ioId                 := MovementItem.Id
                                            , inMovementId         := inMovementId
                                            , inParentId           := ioId
                                            , inFuelId             := MovementItem.ObjectId
                                            , inIsCalculated       := MIBoolean_Calculated.ValueData
                                            , inIsMasterFuel       := MIBoolean_MasterFuel.ValueData
                                            , ioAmount             := MovementItem.Amount
                                            , inColdHour           := MIFloat_ColdHour.ValueData
                                            , inColdDistance       := MIFloat_ColdDistance.ValueData
                                            , inAmountColdHour     := MIFloat_AmountColdHour.ValueData
                                            , inAmountColdDistance := MIFloat_AmountColdDistance.ValueData
                                            , inAmountFuel         := MIFloat_AmountFuel.ValueData
                                            , inNumber             := MIFloat_Number.ValueData
                                            , inRateFuelKindTax    := MIFloat_RateFuelKindTax.ValueData
                                            , inRateFuelKindId     := MILinkObject_RateFuelKind.ObjectId
                                            , inUserId             := vbUserId
                                             )
   FROM MovementItem
        JOIN MovementItemBoolean AS MIBoolean_Calculated
                                 ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                AND MIBoolean_Calculated.ValueData = TRUE
             LEFT JOIN MovementItemBoolean AS MIBoolean_MasterFuel
                                           ON MIBoolean_MasterFuel.MovementItemId = MovementItem.Id
                                          AND MIBoolean_MasterFuel.DescId = zc_MIBoolean_MasterFuel()

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

   -- сформировали Child для новых (!!!если есть норма!!!)
   PERFORM lpInsertUpdate_MI_Transport_Child (ioId                 := 0
                                            , inMovementId         := inMovementId
                                            , inParentId           := ioId
                                            , inFuelId             := ObjectLink_Car_FuelAll.ChildObjectId
                                            , inIsCalculated       := TRUE
                                            , inIsMasterFuel       := CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN TRUE ELSE FALSE END
                                            , ioAmount             := 0
                                            , inColdHour           := 0
                                            , inColdDistance       := 0
                                            , inAmountColdHour     := tmpRateFuel.AmountColdHour
                                            , inAmountColdDistance := tmpRateFuel.AmountColdDistance
                                            , inAmountFuel         := tmpRateFuel.AmountFuel
                                            , inNumber             := CASE WHEN ObjectLink_Car_FuelAll.DescId = zc_ObjectLink_Car_FuelMaster() THEN 1 ELSE 2 END
                                            , inRateFuelKindTax    := ObjectFloat_RateFuelKind_Tax.ValueData
                                            , inRateFuelKindId     := ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                            , inUserId             := vbUserId
                                             )
        -- !!!это запрос из gpSelect_MI_Transport!!!
        FROM (SELECT zc_ObjectLink_Car_FuelMaster() AS DescId UNION ALL SELECT zc_ObjectLink_Car_FuelChild() AS DescId) AS tmpDesc
             -- выбрали автомобиль (он один)
             JOIN MovementLinkObject AS MovementLinkObject_Car
                                     ON MovementLinkObject_Car.MovementId = inMovementId
                                    AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
             -- выбрали у автомобиля - все Виды топлива
             JOIN ObjectLink AS ObjectLink_Car_FuelAll ON ObjectLink_Car_FuelAll.ObjectId = MovementLinkObject_Car.ObjectId
                                                      AND ObjectLink_Car_FuelAll.DescId = tmpDesc.DescId
                                                      AND ObjectLink_Car_FuelAll.ChildObjectId IS NOT NULL

             -- выбрали у Вида топлива - Вид норм для топлива
             LEFT JOIN ObjectLink AS ObjectLink_Fuel_RateFuelKind ON ObjectLink_Fuel_RateFuelKind.ObjectId = ObjectLink_Car_FuelAll.ChildObjectId
                                                                 AND ObjectLink_Fuel_RateFuelKind.DescId = zc_ObjectLink_Fuel_RateFuelKind()
             -- выбрали у нормы для топлива - % дополнительного расхода в связи с сезоном/температурой
             LEFT JOIN ObjectFloat AS ObjectFloat_RateFuelKind_Tax ON ObjectFloat_RateFuelKind_Tax.ObjectId = ObjectLink_Fuel_RateFuelKind.ChildObjectId
                                                                  AND ObjectFloat_RateFuelKind_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
             -- этот нужен что б отбросить уже введенный вид топлива (если удален/не удален)
             LEFT JOIN MovementItem AS MovementItem_Find ON MovementItem_Find.MovementId = inMovementId
                                                        AND MovementItem_Find.ParentId   = ioId
                                                        AND MovementItem_Find.ObjectId   = ObjectLink_Car_FuelAll.ChildObjectId
                                                        AND MovementItem_Find.DescId     = zc_MI_Child()
                                                        -- AND MovementItem_Find.isErased = FALSE

             -- выбрали норму для автомобиль + Тип маршрута
             LEFT JOIN (SELECT ObjectLink_RateFuel_Car.ChildObjectId       AS CarId
                             , ObjectLink_RateFuel_RouteKind.ChildObjectId AS RouteKindId
                             , ObjectFloat_Amount.ValueData                AS AmountFuel
                             , ObjectFloat_AmountColdHour.ValueData        AS AmountColdHour
                             , ObjectFloat_AmountColdDistance.ValueData    AS AmountColdDistance
                        FROM ObjectLink AS ObjectLink_RateFuel_Car
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                  ON ObjectLink_RateFuel_RouteKind.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_RateFuel_Amount()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdHour
                                                   ON ObjectFloat_AmountColdHour.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdHour.DescId = zc_ObjectFloat_RateFuel_AmountColdHour()
                             LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdDistance
                                                   ON ObjectFloat_AmountColdDistance.ObjectId = ObjectLink_RateFuel_Car.ObjectId
                                                  AND ObjectFloat_AmountColdDistance.DescId = zc_ObjectFloat_RateFuel_AmountColdDistance()
                        WHERE ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                       ) AS tmpRateFuel ON tmpRateFuel.CarId       = MovementLinkObject_Car.ObjectId
                                       AND tmpRateFuel.RouteKindId = inRouteKindId

        WHERE MovementItem_Find.ObjectId IS NULL
              -- если нормы нет, тогда формировать эелементы не надо
         AND (tmpRateFuel.AmountFuel <> 0 OR tmpRateFuel.AmountColdHour <> 0 OR tmpRateFuel.AmountColdDistance <> 0);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.13                                        * add lpInsertUpdate_MI_Transport_Child
 07.10.13                                        * add inDistanceFuelChild and inIsMasterFuel
 29.09.13                                        * 
 25.09.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
