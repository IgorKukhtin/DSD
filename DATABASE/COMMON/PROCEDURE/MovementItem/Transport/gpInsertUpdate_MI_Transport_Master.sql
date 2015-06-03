-- Function: gpInsertUpdate_MI_Transport_Master()
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, Integer, TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                        Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inRouteId                   Integer   , -- Маршрут
    IN inAmount	                   TFloat    , -- Пробег, км (основной вид топлива)
    IN inDistanceFuelChild         TFloat    , -- Пробег, км (дополнительный вид топлива)
    IN inDistanceWeightTransport   TFloat    , -- Пробег, км (с грузом,перевезено)
    IN inWeight	                   TFloat    , -- Вес груза, кг (разгрузка)
    IN inWeightTransport	       TFloat    , -- Вес груза, кг (перевезено)
    IN inStartOdometre             TFloat    , -- Спидометр начальное показание, км
    IN inEndOdometre               TFloat    , -- Спидометр конечное показание, км
    IN inFreightId                 Integer   , -- Название груза
    IN inRouteKindId_Freight       Integer   , -- Типы маршрутов(груз)
    IN inRouteKindId               Integer   , -- Типы маршрутов
    IN inUnitId                    Integer   , -- Подразделение
    IN inComment                   TVarChar  , -- Комментарий	
    IN inSession                   TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TransportMaster());

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
   IF COALESCE (inMovementId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.<Путевой лист> не сохранен.';
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

   -- проверка
   IF inDistanceFuelChild > 0 AND NOT EXISTS (SELECT ObjectLink_Car_FuelChild.ChildObjectId
                                              FROM MovementLinkObject AS MovementLinkObject_Car
                                                   -- выбрали у автомобиля - Вид топлива
                                                   JOIN ObjectLink AS ObjectLink_Car_FuelChild ON ObjectLink_Car_FuelChild.ObjectId = MovementLinkObject_Car.ObjectId
                                                                                              AND ObjectLink_Car_FuelChild.DescId = zc_ObjectLink_Car_FuelChild()
                                                                                              AND ObjectLink_Car_FuelChild.ChildObjectId IS NOT NULL
                                              WHERE MovementLinkObject_Car.MovementId = inMovementId
                                                AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car())
   THEN 
       RAISE EXCEPTION 'Ошибка.Неверное значение <Пробег, км (дополнительный вид топлива)>, т.к. у <Автомобиля> не установлен <Дополнительный вид топлива>.';
   END IF;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, inAmount, NULL);
  
   -- сохранили связь с <Название груза>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Freight(), ioId, inFreightId);
   
   -- сохранили связь с <Типы маршрутов(груз)>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKindFreight(), ioId, inRouteKindId_Freight);

   -- сохранили связь с <Типы маршрутов>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKind(), ioId, inRouteKindId);

   -- сохранили связь с <Подразделение>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

   -- сохранили свойство <Пробег, км (дополнительный вид топлива)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DistanceFuelChild(), ioId, inDistanceFuelChild);

   -- сохранили свойство <Пробег, км (с грузом,перевезено)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DistanceWeightTransport(), ioId, inDistanceWeightTransport);
   
   -- сохранили свойство <Вес груза>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Weight(), ioId, inWeight);
   -- сохранили свойство <Вес груза>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTransport(), ioId, inWeightTransport);

   -- сохранили свойство <Спидометр начальное показание, км>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartOdometre(), ioId, inStartOdometre);

   -- сохранили свойство <Спидометр конечное показание, км>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_EndOdometre(), ioId, inEndOdometre);
   
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

   -- !!!обязательно!!! пересчитали Child
   PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := inMovementId, inParentId := ioId, inRouteKindId:= inRouteKindId, inUserId := vbUserId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.15         * add UnitID
 10.12.13         * add DistanceWeightTransport
 09.12.13         * add WeightTransport
 02.12.13         * add Comment
 26.10.13                                        * add inRouteKindId_Freight
 13.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 13.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 12.10.13                                        * add zc_ObjectFloat_Fuel_Ratio
 12.10.13                                        * add lpInsertUpdate_MI_Transport_Child
 07.10.13                                        * add inDistanceFuelChild and inIsMasterFuel
 29.09.13                                        * 
 25.09.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_Transport_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
