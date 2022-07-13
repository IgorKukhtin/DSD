-- Function: lpInsertUpdate_Object_CarExternal ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_OrderCarInfo (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_OrderCarInfo(
   INOUT ioId                    Integer, 
      IN inRouteId               Integer, 
      IN inRetailId              Integer,
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
                   INNER JOIN ObjectLink AS ObjectLink_Retail 
                                         ON ObjectLink_Retail.ObjectId = ObjectLink_Route.ObjectId
                                        AND ObjectLink_Retail.DescId = zc_ObjectLink_OrderCarInfo_Retail()
                                        AND ObjectLink_Retail.ChildObjectId = inRetailId
              WHERE ObjectLink_Route.DescId = zc_ObjectLink_OrderCarInfo_Route()
                AND ObjectLink_Route.ObjectId <> ioId
                AND ObjectLink_Route.ChildObjectId = inRouteId
              )
   THEN
        RAISE EXCEPTION 'Ошибка. Соотношение Маршрут <%> - Торг.сеть <%> уже существует.' , lfGet_Object_ValueData(inRouteId), lfGet_Object_ValueData(inRetailId);
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderCarInfo(), 0, '', NULL);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderCarInfo_Route(), ioId, inRouteId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OrderCarInfo_Retail(), ioId, inRetailId);

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
