-- Function: lpInsertUpdate_Object_OrderCarInfo ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_OrderCarInfo (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_OrderCarInfo (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_OrderCarInfo(
   INOUT ioId                    Integer, 
      IN inRouteId               Integer, 
      IN inRetailId              Integer,
      IN inUnitId                Integer,
      IN inOperDate              TFloat ,     -- 
      IN inOperDatePartner       TFloat ,     -- 
      IN inDays                  TFloat ,     -- 
      IN inHour                  TFloat ,     --
      IN inMin                   TFloat ,     --      
      IN inUserId                Integer
)
RETURNS Integer
AS
$BODY$
BEGIN

   --проверка
   IF EXISTS (SELECT 1 
              FROM ObjectLink AS ObjectLink_Route 
                   LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                         ON ObjectLink_Unit.ObjectId = ObjectLink_Route.ObjectId
                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_OrderCarInfo_Unit() 
                                        
                   LEFT JOIN ObjectLink AS ObjectLink_Retail 
                                        ON ObjectLink_Retail.ObjectId = ObjectLink_Route.ObjectId
                                       AND ObjectLink_Retail.DescId = zc_ObjectLink_OrderCarInfo_Retail()
                                         
                   INNER JOIN ObjectFloat AS ObjectFloat_OperDate
                                          ON ObjectFloat_OperDate.ObjectId = ObjectLink_Route.ObjectId
                                         AND ObjectFloat_OperDate.DescId = zc_ObjectFloat_OrderCarInfo_OperDate()
                                         AND COALESCE (ObjectFloat_OperDate.ValueData,0) = inOperDate
                   INNER JOIN ObjectFloat AS ObjectFloat_OperDatePartner
                                          ON ObjectFloat_OperDatePartner.ObjectId = ObjectLink_Route.ObjectId
                                         AND ObjectFloat_OperDatePartner.DescId = zc_ObjectFloat_OrderCarInfo_OperDatePartner()
                                         AND COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = inOperDatePartner 
                   INNER JOIN Object ON Object.Id = ObjectLink_Route.ObjectId AND Object.isErased = FALSE
              WHERE ObjectLink_Route.DescId = zc_ObjectLink_OrderCarInfo_Route()
                AND ObjectLink_Route.ObjectId <> ioId
                AND ObjectLink_Route.ChildObjectId = inRouteId
                AND COALESCE (ObjectLink_Retail.ChildObjectId,0) = COALESCE(inRetailId,0)
                AND COALESCE (ObjectLink_Unit.ObjectId,0) = COALESCE (inUnitId,0)
              )
   THEN
        RAISE EXCEPTION 'Ошибка. Соотношение Склад <%>% Маршрут <%>% Торг.сеть <%>% День заказа <%> День отгрузки <%> уже существует.' 
                                                                                                 , lfGet_Object_ValueData(inUnitId), CHR (13)
                                                                                                 , lfGet_Object_ValueData(inRouteId), CHR (13)
                                                                                                 , lfGet_Object_ValueData(inRetailId), CHR (13)
                                                                                                 , inOperDate        ::integer
                                                                                                 , inOperDatePartner ::integer;
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderCarInfo(), 0, '', NULL);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderCarInfo_Route(), ioId, inRouteId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderCarInfo_Retail(), ioId, inRetailId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderCarInfo_Unit(), ioId, inUnitId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_OrderCarInfo_OperDate(), ioId, inOperDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_OrderCarInfo_OperDatePartner(), ioId, inOperDatePartner);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_OrderCarInfo_Days(), ioId, inDays);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_OrderCarInfo_Hour(), ioId, inHour);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_OrderCarInfo_Min(), ioId, inMin);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.22         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_OrderCarInfo()
