-- Function: gpUpdate_Unit_isShowActiveAlerts()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isShowActiveAlerts(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isShowActiveAlerts(
    IN inId                      Integer   ,    -- ключ объекта <подразделение>
    IN inisShowActiveAlerts      Boolean   ,    -- 
   OUT outisShowActiveAlerts     Boolean   ,
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
   outisShowActiveAlerts:= NOT inisShowActiveAlerts;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShowActiveAlerts(), inId, outisShowActiveAlerts);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 14.12.21                                                      *

*/
--select * from gpUpdate_Unit_isShowActiveAlerts(inId := 1393106 , inisShowActiveAlerts := 'False' ,  inSession := '3');