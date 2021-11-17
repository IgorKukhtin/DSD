-- Function: gpUpdate_Unit_isMarginCategory()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isOnlyTimingSUN(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isOnlyTimingSUN(
    IN inId                      Integer   ,    -- ключ объекта <подразделение>
    IN inisOnlyTimingSUN         Boolean   ,    -- 
   OUT outisOnlyTimingSUN        Boolean   ,
    IN inSession                 TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisOnlyTimingSUN:= NOT inisOnlyTimingSUN;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_OnlyTiming(), inId, outisOnlyTimingSUN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.11.21                                                      *

*/
--select * from gpUpdate_Unit_isOnlyTimingSUN(inId := 1393106 , inisOnlyTimingSUN := 'False' ,  inSession := '3');