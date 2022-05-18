-- Function: gpUpdate_Unit_SupplementAdd30Cash()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SupplementAdd30Cash(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_SupplementAdd30Cash(
    IN inId                      Integer   ,    -- ключ объекта <подразделение>
    IN inisSupplementAdd30Cash       Boolean   ,    -- 
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

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_SupplementAdd30Cash(), inId, NOT inisSupplementAdd30Cash);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.02.22                                                      *

*/
--select * from gpUpdate_Unit_SupplementAdd30Cash(inId := 1393106 , inisSupplementAdd30Cash := 'False' ,  inSession := '3');