-- Function: gpUpdate_Object_Partner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Order (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Order(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inRouteId             Integer   ,    -- 
    IN inRouteSortingId      Integer   ,    -- 
    IN inPersonalId          Integer   ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Order());

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTake(), ioId, inPersonalId);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Order()
