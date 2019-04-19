-- Function: gpInsertUpdate_MI_Transport_Master()

DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_MI_Transport_Master(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Transport_Master(
 INOUT ioId                        Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inRouteId                   Integer   , -- Маршрут
    IN inAmount	                   TFloat    , -- Пробег, км (основной вид топлива)
    IN inDistanceFuelChild         TFloat    , -- Пробег, км (дополнительный вид топлива)
    IN inDistanceWeightTransport   TFloat    , -- Пробег, км (с грузом,перевезено)
    IN inWeight	                   TFloat    , -- Вес груза, кг (разгрузка)
    IN inWeightTransport           TFloat    , -- Вес груза, кг (перевезено)
    IN inStartOdometre             TFloat    , -- Спидометр начальное показание, км
    IN inEndOdometre               TFloat    , -- Спидометр конечное показание, км
 INOUT iоRateSumma                 TFloat    , -- Сумма коммандировочных
    IN inRatePrice                 TFloat    , -- Ставка грн/км (дальнобойные)
    IN inTimePrice                 TFloat    , -- Ставка грн/ч коммандировочных
    IN inTaxi                      TFloat    , -- Сумма на такси
    IN inTaxiMore                  TFloat    , -- Сумма на такси(водитель дополнительный)
 INOUT ioRateSummaAdd              TFloat    , -- Сумма доплаты(дальнобойные)
    IN inRateSummaExp              TFloat    , -- Сумма командировочных экспедитору
   OUT outRatePrice_Calc           TFloat    , -- Сумма грн (дальнобойные)
    IN inFreightId                 Integer   , -- Название груза
    IN inRouteKindId_Freight       Integer   , -- Типы маршрутов(груз)
    IN inRouteKindId               Integer   , -- Типы маршрутов
 INOUT ioUnitId                    Integer   , -- Подразделение
   OUT outUnitName                 TVarChar  , -- Подразделение
    IN inComment                   TVarChar  , -- Комментарий
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbHours TFloat;
   DECLARE vbOperDate TDateTime;
   DECLARE vbStartRunPlan TDateTime;
   DECLARE vbEndRunPlan TDateTime;
   DECLARE vbHoursWork TFloat;
   
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

   -- дата документа
   vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
   
   -- если это если ioId = 0 ТОЛЬКО тогда сделать гет StartRunPlan + HoursPlan и сохранить в zc_MovementDate_StartRunPlan + zc_MovementDate_EndRunPlan + zc_MovementDate_StartRun + zc_MovementDate_EndRun + zc_MovementFloat_HoursWork 
   -- + если это первый НЕ УДАЛЕННЫЙ zc_MI_Master, т.е. когда добавляют 2,3 маршрут - уже параметры не менять
   IF  COALESCE (ioId, 0) = 0 AND NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE)
   THEN 
       SELECT (vbOperDate ::Date + ObjectDate_StartRunPlan.ValueData::Time) ::TDateTime AS StartRunPlan
            , ((vbOperDate ::Date + ObjectDate_StartRunPlan.ValueData ::Time) ::TDateTime + (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) :: TDateTime AS EndRunPlan
            -- расчитали свойство <Кол-во рабочих часов>
            , EXTRACT (DAY FROM (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) * 24 
            + EXTRACT (HOUR FROM (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) 
            + CAST (EXTRACT (MIN FROM (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) / 60 AS NUMERIC (16, 2)) AS HoursWork

              INTO vbStartRunPlan, vbEndRunPlan, vbHoursWork  

       FROM Object AS Object_Route
            LEFT JOIN ObjectDate AS ObjectDate_StartRunPlan
                                 ON ObjectDate_StartRunPlan.ObjectId = Object_Route.Id
                                AND ObjectDate_StartRunPlan.DescId = zc_ObjectDate_Route_StartRunPlan()
    
            LEFT JOIN ObjectDate AS ObjectDate_EndRunPlan
                                 ON ObjectDate_EndRunPlan.ObjectId = Object_Route.Id
                                AND ObjectDate_EndRunPlan.DescId = zc_ObjectDate_Route_EndRunPlan()
       WHERE Object_Route.Id = inRouteId;
       
       IF NOT (vbStartRunPlan IS NULL) AND NOT (vbEndRunPlan IS NULL)
       THEN
           -- сохранили связь с <Дата/Время выезда план>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRunPlan(), inMovementId, vbStartRunPlan);
           -- сохранили связь с <Дата/Время возвращения план>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRunPlan(), inMovementId, vbEndRunPlan);
           -- сохранили связь с <Дата/Время выезда факт>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartRun(), inMovementId, vbStartRunPlan);
           -- сохранили связь с <Дата/Время возвращения факт>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndRun(), inMovementId, vbEndRunPlan);
           -- сохранили свойство <Кол-во рабочих часов>
           PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), inMovementId, vbHoursWork);
       END IF;

   END IF;
  
   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inRouteId, inMovementId, inAmount, NULL);

   -- сохранили связь с <Название груза>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Freight(), ioId, inFreightId);

   -- сохранили связь с <Типы маршрутов(груз)>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKindFreight(), ioId, inRouteKindId_Freight);

   -- сохранили связь с <Типы маршрутов>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RouteKind(), ioId, inRouteKindId);

   -- только при создании - расчет
   IF vbIsInsert
   THEN
        -- поиск Подразделения для затрат (т.е. в Child перенесется отсюда при проведении)
        ioUnitId:= (SELECT CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                                     THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- если филиал = "пусто", тогда затраты по принадлежности маршрута к подразделению, т.е. это мясо(з+сб), снабжение, админ, произв.
                                WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                                     THEN COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению, т.е. это филиалы
                                ELSE (SELECT MLO.ObjectId AS MLO FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_UnitForwarding()) -- иначе Подразделение (Место отправки), т.е. везут на филиалы но затраты к ним не падают
                           END
                    FROM Object AS Object_Route
                         LEFT JOIN ObjectLink AS ObjectLink_Route_Branch
                                              ON ObjectLink_Route_Branch.ObjectId = Object_Route.Id
                                             AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
                         LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                              ON ObjectLink_Route_Unit.ObjectId = Object_Route.Id
                                             AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                         LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                              ON ObjectLink_UnitRoute_Branch.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                             AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                         LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                              ON ObjectLink_UnitRoute_Business.ObjectId = ObjectLink_Route_Unit.ChildObjectId
                                             AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()
                    WHERE Object_Route.Id = inRouteId
                   );
   END IF;
   -- еще досчитали
   outUnitName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioUnitId);
   -- сохранили связь с <Подразделение>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, ioUnitId);


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

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), ioId, iоRateSumma);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RatePrice(), ioId, inRatePrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Taxi(), ioId, inTaxi);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxiMore(), ioId, inTaxiMore);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TimePrice(), ioId, inTimePrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaAdd(), ioId, ioRateSummaAdd);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaExp(), ioId, inRateSummaExp);

   IF COALESCE (inTimePrice,0) <> 0 -- OR 1=1 -- !!!временно - что б всегда!!!
   THEN
       vbHours := (SELECT CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat) AS Hours_All
                   FROM MovementFloat AS MovementFloat_HoursWork
                       LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                               ON MovementFloat_HoursAdd.MovementId = MovementFloat_HoursWork.MovementId
                                              AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
                   WHERE MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                     AND MovementFloat_HoursWork.MovementId = inMovementId);

       iоRateSumma:= COALESCE (vbHours,0) * inTimePrice;
       -- пересохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), ioId, iоRateSumma);

   END IF;


   IF COALESCE (inRatePrice, 0) <> 0 -- OR 1=1 -- !!!временно - что б всегда!!!
   THEN
       outRatePrice_Calc:= COALESCE (inRatePrice, 0) * (COALESCE (inAmount, 0) + COALESCE (inDistanceFuelChild, 0));
       --
       ioRateSummaAdd:= 0;
       -- пересохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaAdd(), ioId, ioRateSummaAdd);
   ELSE
       outRatePrice_Calc:= ioRateSummaAdd;
   END IF;


   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

   -- !!!обязательно!!! пересчитали Child
   PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := inMovementId, inParentId := ioId, inRouteKindId:= inRouteKindId, inUserId := vbUserId);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.17         *
 17.04.16         *
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
