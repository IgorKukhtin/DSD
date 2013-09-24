-- Function: gpInsertUpdate_Object_RateFuel (Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_RateFuel (Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RateFuel(
 INOUT ioId                    Integer   ,    -- ключ объекта <Нормы топлива>
    IN inAmount                TFloat    ,    -- Кол-во норма на 100 км
    IN inAmountСoldHour        TFloat    ,    -- Холод, Кол-во норма в час
    IN inAmountСoldDistance    TFloat    ,    -- Холод, Кол-во норма на 100 км
    IN inCarId                 Integer   ,    -- Автомобиль
    IN inRouteKindId           Integer   ,    -- Тип маршрута
    IN inRateFuelKindId        Integer   ,    -- Типы норм топлива
    IN inSession               TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_RateFuel());
   vbUserId := inSession;
 
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RateFuel(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_Amount(), ioId, inAmount);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountСoldHour(), ioId, inAmountСoldHour);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountСoldDistance(), ioId, inAmountСoldDistance);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_Car(), ioId, inCarId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_RouteKind(), ioId, inRouteKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_RateFuelKind(), ioId, inRateFuelKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_RateFuel(Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RateFuel()
