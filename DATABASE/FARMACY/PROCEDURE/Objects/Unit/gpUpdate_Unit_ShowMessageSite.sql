-- Function: gpUpdate_Unit_ShowMessageSite()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ShowMessageSite(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_ShowMessageSite(
    IN inId                      Integer   ,    -- ключ объекта <подразделение>
    IN inisShowMessageSite       Boolean   ,    -- 
    IN inSession                 TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShowMessageSite(), inId, NOT inisShowMessageSite);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.02.22                                                      *

*/
--select * from gpUpdate_Unit_ShowMessageSite(inId := 1393106 , inisShowMessageSite := 'False' ,  inSession := '3');