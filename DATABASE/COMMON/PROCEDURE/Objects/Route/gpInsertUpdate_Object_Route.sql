-- Function: gpInsertUpdate_Object_Route(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Route (Integer, Integer, TVarChar, TDateTime, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Route (Integer, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Route(
 INOUT ioId             Integer   , -- Ключ объекта <маршрут>
    IN inCode           Integer   , -- свойство <Код маршрута>
    IN inName           TVarChar  , -- свойство <Наименование маршрута>
    IN inStartRunPlan   TDateTime , -- Время выезда план
    IN inHoursPlan      TFloat    , -- Время в пути - часы
    IN inMinutePlan     TFloat    , -- Время в пути - минуты
    IN inRateSumma      TFloat    , -- Сумма коммандировочных
    IN inRatePrice      TFloat    , -- Ставка грн/км (дальнобойные)
    IN inTimePrice      TFloat    , -- Ставка грн/ч (коммандировочные)
    IN inRateSummaAdd   TFloat    , -- Сумма доплата (дальнобойные)
    IN inRateSummaExp   TFloat    , -- Сумма командировочных экспедитору
    IN inUnitId         Integer   , -- ссылка на Подразделение
    IN inBranchId       Integer   , -- ссылка на Филиал
    IN inRouteKindId    Integer   , -- ссылка на Типы маршрутов
    IN inFreightId      Integer   , -- ссылка на Название груза
    IN inRouteGroupId   Integer   , -- ссылка на Группу маршрута
    IN inIsNotPayForWeight Boolean   , -- Нет оплаты водителю за вес
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Route());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Route());

   -- проверка уникальности для свойства <Наименование Маршрута>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Route(), inName);
   -- проверка уникальности для свойства <Код маршрута>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Route(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId:= ioId, inDescId:= zc_Object_Route(), inObjectCode:= vbCode_calc, inValueData:= inName
                                , inAccessKeyId:= (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId));

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_Unit(), ioId, inUnitId);

   -- сохранили связь с <Филиалом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_Branch(), ioId, inBranchId);

   -- сохранили связь с <Типы маршрутов>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_RouteKind(), ioId, inRouteKindId);
   -- сохранили связь с <Название груза>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_Freight(), ioId, inFreightId);
  
   -- сохранили связь с <Группой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Route_RouteGroup(), ioId, inRouteGroupId);   

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RateSumma(), ioId, inRateSumma);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RatePrice(), ioId, inRatePrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_TimePrice(), ioId, inTimePrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RateSummaAdd(), ioId, inRateSummaAdd);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat (zc_ObjecTFloat_Route_RateSummaExp(), ioId, inRateSummaExp);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Route_StartRunPlan(), ioId, inStartRunPlan);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Route_EndRunPlan(), ioId, (inStartRunPlan + (inHoursPlan||' hour '||inMinutePlan||' minute') :: INTERVAL) );

   -- сохранили свойство <Нет оплаты водителю за вес>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Route_NotPayForWeight(), ioId, inIsNotPayForWeight);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.19         *
 06.04.19         *
 29.01.19         * add RateSummaExp
 24.10.17         * add RateSummaAdd
 24.05.16         * add TimePrice
 17.04.16         *
 20.04.15         * RouteGroup                
 13.12.13         * add inBranchId              
 08.12.13                                        * add inAccessKeyId
 09.10.13                                        * пытаемся найти код
 24.09.13         * add Unit, RouteKind, Freight
 03.06.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Route()
