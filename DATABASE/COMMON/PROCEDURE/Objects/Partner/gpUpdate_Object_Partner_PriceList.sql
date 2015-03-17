-- Function: gpUpdate_Object_Partner_PriceList()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PriceList (Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_PriceList(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции
    IN inRouteId             Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inMemberId            Integer   ,    -- 
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inPersonalId          Integer   ,    -- Сотрудник (супервайзер)
    IN inPersonalTradeId     Integer   ,    -- Сотрудник (торговый)
    IN inUnitId              Integer   ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());


   -- сохранили свойство <>
--   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_StartPromo(), ioId, inStartPromo);
      -- сохранили свойство <>
--   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_EndPromo(), ioId, inEndPromo);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberId);
 
   -- сохранили связь с <>
--   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
--   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceListPromo(), ioId, inPriceListPromoId);

   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Unit(), ioId, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.03.15                                        * all
 27.10.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_PriceList()
