-- Function: gpUpdate_Object_OrderPeriodKind

DROP FUNCTION IF EXISTS gpUpdate_Object_OrderPeriodKind (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_OrderPeriodKind(
    IN inId             Integer,       -- 
    IN inWeek           TFloat ,       -- 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_OrderPeriodKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderPeriodKind_Week(), inId, inWeek);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *

*/

-- тест
--