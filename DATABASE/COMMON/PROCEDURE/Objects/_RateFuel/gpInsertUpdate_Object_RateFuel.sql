-- Function: gpInsertUpdate_Object_RateFuel (nteger, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_RateFuel (nteger, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RateFuel(
 INOUT ioId                             Integer   ,    -- ключ объекта <Машина>
    IN inRateFuelId_Internal            Integer   ,    -- ключ Нормы топлива город
    IN inRateFuelId_External            Integer   ,    -- ключ Нормы топлива межгород
    IN inAmount_Internal                TFloat    ,    -- Кол-во норма на 100 км
    IN inAmountСoldHour_Internal        TFloat    ,    -- Холод, Кол-во норма в час
    IN inAmountСoldDistance_Internal    TFloat    ,    -- Холод, Кол-во норма на 100 км
    IN inAmount_External                TFloat    ,    -- Кол-во норма на 100 км
    IN inAmountСoldHour_External        TFloat    ,    -- Холод, Кол-во норма в час
    IN inAmountСoldDistance_External    TFloat    ,    -- Холод, Кол-во норма на 100 км
    IN inSession                        TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_RateFuel());
   vbUserId := inSession;
       
       SELECT 
             tmpRateFuel.RateFuelId_Internal  AS RateFuelId_Internal
           , tmpRateFuel.RateFuelId_External  AS RateFuelId_External
         INTO inRateFuelId_Internal, inRateFuelId_External
       FROM Object AS Object_Car
            
            JOIN ( SELECT ObjectLink_RateFuel_Car.ChildObjectId AS CarId
                              , MAX(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_Internal() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_Internal
                              , MAX(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_External() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_External
							  
                        FROM Object AS Object_RateFuel
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_Car
                                                  ON ObjectLink_RateFuel_Car.ObjectId = Object_RateFuel.Id
                                                 AND ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                             LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                  ON ObjectLink_RateFuel_RouteKind.ObjectId = Object_RateFuel.Id
                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                        WHERE Object_RateFuel.DescId = zc_Object_RateFuel()
                        GROUP BY ObjectLink_RateFuel_Car.ChildObjectId
                             ) tmpRateFuel ON tmpRateFuel.CarId = Object_Car.Id
        WHERE  Object_Car.Id = ioId ;
                             
   -- сохранили <Объект>
   inRateFuelId_External := lpInsertUpdate_Object(inRateFuelId_External, zc_Object_RateFuel(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_Amount(), inRateFuelId_External, inAmount_External);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountСoldHour(), inRateFuelId_External, inAmountСoldHour_External);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountСoldDistance(), inRateFuelId_External, inAmountСoldDistance_External);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_Car(), inRateFuelId_External, ioId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_RouteKind(), inRateFuelId_External, zc_Enum_RouteKind_External());



   inRateFuelId_Internal := lpInsertUpdate_Object(inRateFuelId_Internal, zc_Object_RateFuel(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_Amount(), inRateFuelId_Internal, inAmount_Internal);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountСoldHour(), inRateFuelId_Internal, inAmountСoldHour_Internal);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuel_AmountСoldDistance(), inRateFuelId_Internal, inAmountСoldDistance_Internal);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_Car(), inRateFuelId_Internal, ioId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RateFuel_RouteKind(), inRateFuelId_Internal, zc_Enum_RouteKind_Internal());

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_RateFuel (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_RateFuel()
